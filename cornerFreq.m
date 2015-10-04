% corner frequency of filter, either FIR, polynomial, or savitzky-golay
% returns corner frequeny, Fc, and [f, r], frequency in hz and response.
% Inputs:
%   Fs is sampling rate (e.g., 1000 Hz)
%   length(varargin) = 1 ==> FIR filter
%                    = 2 ==> if scalar, Savitzky Golay, [k, F]
%                            if vector, polynomial
% LMO 25mar2015 create

function [Fc, Freqs, Resp] = cornerFreq(Fs, varargin)

debug = 0;

twopi = 2 * pi;
nFFT = 5 * 1024;
Fn = Fs/2;  % nyquist freq
F0 = Fn/ nFFT;
Fhi = 200;  % Hz
dF = 0.25;  % hz
Freqs = F0:dF:Fhi;
nFreqs = length(Freqs);

% create time
dt = 1/Fs;
t = 0:dt:1;
figure(1)
clf

Resp = 0;
switch(numel(varargin))
    case 1
        % FIR filter
        filt = varargin{1};
        for k = 1:nFreqs
            y = sin(twopi * Freqs(k) * t);
            if numel(filt) > numel(y)
                a = filt;
                b = y;
            else
                a = y;
                b = filt;
            end
            z = conv(a, b);
            lo = fix(length(z)/2 - 0.35/dt);
            hi = fix(lo + 0.7/dt);
            z = z(lo:hi);
            Resp(k) = max(abs(z));
            if debug
                tp = ((1:length(z))-1)*dt;
                plot(tp, z);
                ylim([-1, 1]);
                disp(Freqs(k))
                pause(1)
            end
        end
        
    case 2
        a = varargin{1};
        b = varargin{2};
        if length(a) == 1   % scalar, so is savitzky-golay(x, a,b)
            for k = 1:1:nFreqs
                y = sin(twopi * Freqs(k) * t);
                z = sgolayfilt(y, a, b);
                lo = fix(length(z)/2 - 0.25/dt);
                hi = fix(lo + 0.5/dt);
                z = z(lo:hi);
                Resp(k) = max(abs(z));
                if debug
                    tp = ((1:length(z))-1)*dt;
                    plot(tp, z);
                    ylim([-1, 1]);
                    disp(Freqs(k))
                    pause(1)
                end
            end
        else
            polyDenom = a;
            polyNumer = b;
            for k = 1:1:nFreqs
                y = sin(twopi * Freqs(k) * t);
                z = filter(polyNumer, polyDenom, y);
                lo = fix(length(z)/2 - 0.25/dt);
                hi = fix(lo + 0.5/dt);
                z = z(lo:hi);
                Resp(k) = max(abs(z));
                if debug
                    tp = ((1:length(z))-1)*dt;
                    plot(tp, z);
                    ylim([-1, 1]);
                    disp(Freqs(k))
                    pause(1)
                end
            end
        end
end

[mxResp, khi] = max(Resp);
Resp = Resp/mxResp;
plot(Freqs, Resp);

rng = khi : length(Resp);
k = find(Resp(rng) > 1/sqrt(2));
k = rng(k(end));
if length(k) == 1
    Fc = Freqs(k);
else
    Fc = (Freqs(k) + Freqs(k+1))/2;
end
hold on
y0 = Resp(k);
plot(Fc * [1, 1], y0 * [0,1], 'r--');
plot(Fc * [0, 1], y0 * [1, 1], 'r--');
ht = text(Fc * 1.1, y0, sprintf('Fc = %3.2f Hz', Fc));
xlabel('Freq (Hz)');
ylabel('Gain');

