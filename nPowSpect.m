function [S, F, ptot] = nPowSpect(x, nfft, Fs, name, arg)
        % [S, F, ptot] = nPowSpect(x, nfft, Fs, name, arg)
        % returns the normalized power spectrum of x in P,
        % where f is frequency in [Hz], and S is [power / Hz]
        % uses periodogram with boxcar filter to get total power
        %
        % name = name of function that you want to use to get the
        % power spectrum, e.g.:
        % schuster
        % periodogram
        % peig [arg = # signal subspace dimensions]
        % dft
        % pmtm
        % pwelch
        %
        % OUTPUT:
        % S = power spectrum
        % F = frequencies
        % ptot = total power
        %
        % LM Optican  27feb09 wrote to get power into the same units
        %                            9mar09        correct scale, and add pwelch()
        %
        tic
        
        if nargin < 4
            name = 'peig';
        end
        
        xm = mean(x);
        dx = x - xm;
        N = length(dx);

        switch name
                case 'schuster'
                        F = (Fs / 2) * linspace(0, 1, nfft / 2);
                        t = [1:N] / Fs;
                        [S, F] = schusterPerio(t, dx, F);
                        S = 2 * S; % double for one-sided
                        
                case 'periodogram'
                        [S, F] = periodogram(dx, [], nfft, Fs);
                        
                case {'DFT', 'dft'}
                        X = fft(dx,nfft);
                        S = 2 * abs(X(1:nfft/2)).^2 / N;  %  double for one-sided
                        S = S / Fs;  % correct for non-integer spacing
                        F = (Fs / 2) * linspace(0, 1, nfft/2);
                
                case 'peig'
                        if nargin < 5
                            eigs = 128;
                        else
                            eigs = arg;
                        end
                        [S, F] = peig(dx, eigs, nfft, Fs);  % Note S is in DFT units
                        S(1) = xm; % reset DC term
                        S = S.^2;       % convert to power from DFT amplitude

                        % get power in x for normalization
                        L = N / Fs;
                        t = [1:N] / Fs;
                        mx = trapz(t, dx.^2)/L; % convert to power / Hz units
                        ms = trapz(F, S);
                        S = S * mx / ms;
                        
                case 'pwelch'
                        [S, F] = pwelch(dx, [], [], nfft, Fs);
                        
                case 'pmtm'
                        [S, F] = pmtm(dx, 2, nfft, Fs);

                otherwise
                        error(sprintf('Bad name for nPowSpect = %s', name))
        end
        ptot = trapz(F, S);
        toc
end
