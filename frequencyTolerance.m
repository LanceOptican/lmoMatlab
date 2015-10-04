% Frequency Tolerance function
% proposed in:
% Brittain, Cagnan, Mehta, Saifee, Edwards, Brown:
% "Distinguishing the Central Drive to Tremor in Parkinson’s
% Disease and Essential Tremor"
% The Journal of Neuroscience, January 14, 2015, 35(2):795-806
%
% INPUT:
% x = oscillatory signal
% HWBC = half bandwidth of filter in percent of center frequency
% Fs = data sampling rate
% useFilter = 1 to do filtering, 0 to use raw signal. This matters if
%   the signal length is small, e.g., less than 200 samples.
%
% OUTPUT:
% An = amplitude for each cycle
% Fn = frequencies for each cycle
% deltaFn = frequency change (forward difference) to next cycle
% Fc = center frequency of data
% indzc = indices of positive going zero-crossings
% t0 = time of ind
%
% LMO 2apr2015  create
%
function [An, Fn, deltaFn, Fc, indzc, t0] = frequencyTolerance(x, HBWpc, Fs, useFilter)

debug = 0;

% initialize in case it aborts
An = NaN;
Fn = NaN;
deltaFn = NaN;
Fc = NaN;
indzc = NaN;
t0 = NaN;

% detrend data
x = detrend(x);

% get center frequency
try
    [S, Sf] = peig(x, 10, [], Fs);
catch
    [S, Sf] = peig(x, 3, [], Fs);
end
[Smx, Smxi] = max(S);
S = S/Smx;
[Spks, Slocs] = findpeaks(S);
[pkmx, pkmxi] = max(Spks);
Fc = Sf(Slocs(pkmxi));
if isempty(Fc) || Fc >= 100
    return
end

if useFilter
    % make the filter
    Nfilt = min(fix(length(x)/4), 50); % filter length
    Hd = mkBandPass(Fc, HBWpc, Nfilt, Fs);
    
    y = filter(Hd, x);
    gd = fix(Nfilt/2);
    y = y(gd:end); % shift to account for group delay
else
    y = x;
end
tx = ((1:length(x))-1) / Fs;
ty = ((1:length(y))-1) / Fs;

% now, get zero crossings with Positive slope
[indzc,t0,s0] = crossing(y, ty);
slope = y(min(length(y), indzc+2)) - y(max(1, indzc-2));
k = find(slope > 0);
if isempty(k)
    k = find(slope < 0);
end
indzc = indzc(k);
t0 = t0(k);
s0 = s0(k);
if numel(indzc) < 2   % not enough intervals to measure
    indzc = NaN;
    return
end

% get intervals
Tn = diff(t0);
k = find(Tn < (1/150)); % eliminate really short times as errors
Tn(k) = [];
indzc(k) = [];
Fn = 1.0 ./ Tn;
deltaFn = [diff(Fn), NaN];

% downsample, pick peak in each cycle
% get Hilbert transform of filtered signal, which should be ~monocomponent
z = hilbert(y);
hamps = abs(z);

An = [];
Anix = [];
if useFilter
    
    for k = 1:(length(indzc)-1)
        indrng = indzc(k):indzc(k+1);
        [An(k), ix] = max(hamps(indrng));
        Anix(k) = indrng(ix);
    end
    k = k + 1;
    indrng = indzc(end):length(y);
    [An(k), ix] = max(hamps(indrng));
    Anix(k) = indrng(ix);
else
    for k = 1:(length(indzc)-1)
        rngzc = indzc(k):indzc(k+1);
        [hi, ix] = max(y(rngzc));
        lo = min(y(rngzc));
        An(k) = abs(hi - lo) / 2;
        Anix(k) = rngzc(ix);
    end
end

if debug
    oldgcf = gcf;
    figure(800); clf
    plot(Sf, S); hold on
    for k = 1:numel(Slocs)
        f = Sf(Slocs(k));
        plot(f, Spks(k), 'r*');
        text(f + 10, Spks(k), sprintf('%5.3f', f));
    end
    xlabel('Freq (Hz)');
    ylabel('Eig Power Spectrum');
    
    figure(801);clf
    plot(tx, x, ty, y);hold on
    xr = repmat(t0', 1, 2);
    yr = [s0', -1*ones(size(s0))'];
    plot(xr', yr', 'k:');
    plot(ty, zeros(size(ty)), 'k:');
    plot(ty(Anix), An, 'r*');
    fmt = 'Fn = %5.1f +- %5.1f (%d) quartiles Fn = [%5.1f %5.1f %5.1f]\nAn = %5.2f +- %5.2f quartiles An = [%5.2f %5.2f %5.2f]';
    textpercent(2, 95, sprintf(fmt, ...
        nanmean(Fn), nanstd(Fn), length(Fn(~isnan(Fn))), ...
        quantile(Fn, [0.25, 0.5, 0.75]), ...
        nanmean(An), nanstd(An), quantile(An, [0.25, 0.5, 0.75])));
    xlabel('Time (s)');
    ylabel('Signal & Filtered Signal');
    
    figure(802); clf
    plot(Fn, deltaFn, '.', 'markersize', 8);
    xlabel('Frequency (Hz)');
    ylabel('deltaF (Hz)');
    title('Frequency Tolerance');
    
    figure(803); clf
    spectrogram(y,[],[],[],Fs,'yaxis')
    view(-45,70)
    shading interp
    
    figure(804); clf
    instfreq = Fs/(2*pi)*diff(unwrap(angle(z)));
    plot(ty(2:end),instfreq);
    textpercent(5, 80, sprintf('mean F = %5.3f', mean(instfreq)));
    xlabel('Time')
    ylabel('Hz')
    grid on
    title('Instantaneous Frequency')
    
    figure(805); clf
    hpower = hamps.*hamps;
    [Pxx, PF] = pwelch(z, [], 0, [], Fs, 'Centered');
    [Ppks, Plocs] = findpeaks(Pxx);
    [pkmx, pkmxi] = max(Pxx);
    plot(PF, Pxx); hold on
    plot(PF(pkmxi), pkmx, 'r*');
    text(PF(pkmxi) + 10, pkmx, sprintf('%5.3f', PF(pkmxi)));
    ylabel('Hilbert Power Spectrum');
    
    figure(806); clf
    hax(1) = subplot(2, 1, 1);
    histogram_resamp(Fn - Fc);
    xlabel('Frequency offset (Hz)');
    ylabel('Frequency Distribution')
    
    hax(2) = subplot(2, 1, 2);
    histogram_resamp(An);
    ylabel('Amplitude');
    xlabel('Frequency offset (Hz)');
    
    
    figure(807); clf
    Anz = abs(hamps(indzc)); % downsample
    plot(ty, y); hold on;
    plot(tx, x, 'm');
    plot(ty, hamps, 'c');
    plot(ty(indzc), hamps(indzc), 'g*');
    plot(ty(Anix), An, 'r*');
    plot(ty, zeros(size(ty)), 'k:');
    
    figure(oldgcf)
end