function tstr = timeprint(str, esec);
% print elapsed time

sec = mod(esec, 60);
emin = floor(esec / 60);
min = mod(emin, 60);
hr = floor(emin / 60);

tstr = sprintf('%s: %2.0fh : %2.0fm : %2.1fs', str, hr, min, sec);
disp(tstr);
