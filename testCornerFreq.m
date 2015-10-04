% test cornerFreq program
% gaussian kernel
sigma = 0.001;
nsigma = 3;
kernelTime = (-nsigma):dt:nsigma;
aernel = exp(-((kernelTime/sigma).^2)/2);
kernel = Fs * kernel/sum(kernel);    % normalize to unit area * sample rate
[Fc, Freq, Resp] = cornerFreq(Fs, kernel);    % get corner frequency
disp(sprintf('Fc = %5.2f Hz', Fc))

disp('Sigma  Freq (Hz)')
sigma = [0.2, 0.1, 0.05, 0.01, 0.005, 0.001];
for sigma = logspace(-3, 0, 12)
    nsigma = 3;
    kernelTime = (-nsigma):dt:nsigma;
    kernel = exp(-((kernelTime/(sigma)).^2)/2);
    kernel = Fs * kernel/sum(kernel);    % normalize to unit area * sample rate
    [Fc, Freq, Resp] = cornerFreq(Fs, kernel);    % get corner frequency
    disp(sprintf('%5.3f %8.3f', sigma, Fc))
end

