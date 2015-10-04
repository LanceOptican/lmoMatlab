% denoise a signal using wavelets
% INPUTS:
% sig is the signal to be denoised
% level is the level to use. The bigger the
% level, the smoother it will be.
% OUTPUT:
% sigDen is the denoised signal.
%
function sigDen = denoiseSig(sig, level)
debug = 0;

wname = 'sym3'; % 'db1';

% length must be power of 2, so extend zeros on right
ns = length(sig);
L = 2^nextpow2(ns) - ns;
x = wextend('1', 'zpd', sig, L, 'r');

% check for maximum level
ml = fix(wmaxlev(length(x), wname));
if ml < level
%     fprintf('resetting level = %3.1f to max level = %3.1f\n', level, ml);
    level = ml;
end

tptr =  'heursure'; %'minimaxi'; 'heursure';  % thresholding rule
sorh = 's'; % hard (h) or soft (s) thresholding
scal = 'one'; % one = no rescaling, sln = single noise estimate, mln = level dependent
y = wden(x, tptr, sorh, scal, level, wname); % do the denoising

% chop off extension
sigDen = y(1:(end-L));

% reshape
[nr, nc] = size(sigDen);
if nr < nc
    sigDen = sigDen(:);
end

if debug
    figure(1); clf
    plot(sig, 'b-', 'linewidth', 3); hold on; plot(sigDen, 'r-');
end



