% Hd = mkBandPass()
% make a bandpass filter
%
% INPUTS:
% Fc = center frequency of pass band
% HBWPC = half bandwidth of pass band in percent (i.e. Fc +/- HBW)
% N = filter order
% Fs = sampling rate
%
% OUTPUTS:
% hd = filter object for y = filter(hd, x)
%
function Hd = mkBandPass(Fc, HBWpc, N,Fs)

debug = 0;

if isempty(Fc)
    Hd = [];
    return
end

Fn = Fs/2;  % Nyquist frequency
gd = N/2;   % desired group delay
HBW = Fc * HBWpc / 100;

HBW = min(HBW, (Fn - Fc)/2);

guardband = HBW * 0.5;

% convert to normalized frequency, where Fn = Fs/2, and 0 - Fn => 0 - 1


% first stop band
lo(1) = 0;
hi(1) = (Fc - HBW) - guardband;
F1 = linspace(lo(1), hi(1), 30) / Fn;
A1 = zeros(size(F1));

% pass band
lo(2) = Fc - HBW;
hi(2) = Fc + HBW;
F2 = linspace(lo(2), hi(2), 40) / Fn;
A2 = abs(exp(-1i*pi*gd*F2));

% second stop band
lo(3) = min(hi(2) + guardband, Fn);  
hi(3) = Fn;
F3 = linspace(lo(3), hi(3), 30) / Fn;
A3 = zeros(size(F3));

% multliband design
f = fdesign.arbmag('N,B,F,A',N,3,F1,abs(A1),F2,abs(A2),F3,abs(A3));
Hd = design(f,'equiripple');

if debug
    hfvt = fvtool(Hd, 'Color', 'w');
    legend(hfvt, 'Linear Phase', 'Location', 'NorthEast');
    
    hfvt(2) = fvtool(Hd,'Analysis','grpdelay','Color','w');
    legend(hfvt(2),'Linear Phase', 'Location', 'NorthEast');
    pause
end