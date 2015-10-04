% returns sgolay filtered zeroth, first and second derivative of x.
% if fewer than 3 output arguments, uwanted ones are not computed
function [sx, sdx, sddx] = sgDiff(x, dt, K, F)
x = x(:);
[~, g] = sgolay(K, F);    % get filter coeffs
H = (F + 1)/2; % half size of filter

% low pass filter, and account for on- off-set transients
sx = sgolayfilt(x, K, F);
sdx = [];
sddx = [];

if nargout > 1
    % first derivative, correct for on- off-transients by adding diff(smooth())
    sdx = convn(x, -g(:,2), 'same');  % get first derivative
    % correct end  points
    dz = diff(x);     % differential
    dz = [dz; dz(end) + (dz(end) - dz(end-1))];   % make same length by estimating last point
    dz = sgolayfilt(dz, K, F);  % low pass filter
    
    sdx(1:H) = dz(1:H); % overwrite with corrections
    sdx(end-H:end) = dz(end-H:end);
    
    % turn differentials into derivatives
    sdx = sdx/dt;
end

if nargout == 3
    % second derivative, correct for on- off-transients by adding diff(diff(smooth())
    ddz = diff(diff(x)); % double differential of x
    ddz = [ddz(2) - 2 * (ddz(3) - ddz(2)); ddz; ddz(end) + 2 * (ddz(end-1) - ddz(end-2))]; % endpoint corrections
    ddz = sgolayfilt(ddz, K, F);  % low pass filter
    if size(g, 2) < 3
        % filter is not long enough to make a double derivative, use double
        % differential
        sddx = ddz;
    else
        sddx = convn(x, 2*g(:,3), 'same');  % second derivative
        sddx(1:H) = ddz(1:H);
        sddx(end-H:end) = ddz(end-H:end);
    end
    
    % turn differentials into derivatives
    sddx = sddx/(dt * dt);
end