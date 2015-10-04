% returns sgolay filtered derivative of x
function dx = sgDiff(x, dt, K, F)
x = x(:);
[~, g] = sgolay(K, F);    % get filter coeffs
H = (F + 1)/2; % half size of filter

% first derivative, correct for on- off-transients by adding diff(smooth())
dx = convn(x, -g(:,2), 'same');  % get first derivative

% correct end  points
dz = diff(x);     % differential
dz = [dz; dz(end) + (dz(end) - dz(end-1))];   % make same length by estimating last point
dz = sgolayfilt(dz, K, F);  % low pass filter

dx(1:H) = dz(1:H); % overwrite with corrections
dx(end-H:end) = dz(end-H:end);

dx = dx/dt;