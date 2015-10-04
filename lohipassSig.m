% [L, H] = lohipassSig(x, nStrip)
% split a signal into lowpass and highpass parts.
% x = input signal
% nStrip = number of noise levels to strip off (default = 1)
% L = lowpass part
% H = residual = x - L;
function [L, H] = lohipassSig(x, nStrip)

if nargin < 2
    nStrip = 1;
end

wlevel = fix(log2(length(x)));
L = x;
for k = 1:nStrip;    
    L = denoiseSig(L, wlevel);  % denoised is lowpass
end
H = x - L; % residual is highpass
