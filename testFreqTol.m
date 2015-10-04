% test frequency tolerance function

twopi = 2 * pi;
Fs = 1000;

% make the signal
Freq = 40;

t = ([1:4000]-1)/Fs;
y = sin(twopi * Freq * t) + cos(twopi * 1.1 * Freq * t) + ...
   0.5 * sin(twopi * 2.5 * Freq * t) + randn(size(t))/5;

[An, Fn, deltaFn, Fc, ind, t0] = frequencyTolerance(y, 10, Fs);
