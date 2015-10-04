% test OU programs from sitmo
use_sitmo_data = 0;
use_ou_proc = 1;

if use_sitmo_data
    S = [ 3.0000 1.7600 1.2693 1.1960 0.9468 0.9532 0.6252 ...
        0.8604 1.0984 1.4310 1.3019 1.4005 1.2686 0.7147 ...
        0.9237 0.7297 0.7105 0.8683 0.7406 0.7314 0.6232 ];
    
    delta = 0.25;
    
    LSout = [0.90748788828331, 0.58307607458526, 3.12873217812387];
    MLout = [0.90748788828331, 0.55315453345189, 3.12873217812386];
elseif use_ou_proc
    %parameters
    t_start = 0;          %simulation start time
    t_end = 400;          %simuation end time
    delta = 0.01;         %time step
    tau = 1;              %relaxation time
    lambda = 1/tau;       %mean reversion rate = 1/tau, where tau is the relaxation time
    c = 0.5;              %diffusion constant
    x0 = 0;               %initial value for stochastic variable x
    mu = 1;               %mean of stochatic process x
    y0 = 0;               %initial value for integral x
    start_dist = -2.0;    %start of OU pdf
    end_dist = 2.0;       %end of OU pdf
    
    LSout = [mu, c, lambda];
    MLout = [mu, c, lambda];
    
    tic
    [S, y, T, j, p] = ou_process(t_start, t_end, delta, tau, c, x0, mu, y0, start_dist, end_dist);
    toc
    
else
    delta = 0.01;         %time step
    tau = 1;            %relaxation time
    lambda = 1/tau;       %mean reversion rate = 1/tau, where tau is the relaxation time
    sigma = 0.5;          %diffusion constant
    S0 = 0;               %initial value for stochastic variable x
    mu = 1;               %mean of stochatic process x
    T = 150;                % time for process to run
    
    LSout = [mu, sigma, lambda];
    MLout = [mu, sigma, lambda];
    
    
    tic
    S = SimulateOrnsteinUhlenbeck( S0, mu, sigma, lambda, delta, T );
    toc
end
figure(1)
clf
plot(S);

% LS
tic
[mu1, sigma1, lambda1] = OU_Calibrate_LS(S,delta);
time = toc;
fprintf('LS: %5.4f s\n', time);
disp([mu1, sigma1, lambda1])

tic
[mu1, sigma1, lambda1] = CalibrateOrnsteinUhlenbeckLeastSquares(S, delta);
time = toc;
fprintf('C_LS: %5.4f s\n', time);
disp([mu1, sigma1, lambda1])

fprintf('\nValues should be:\n');
disp(LSout);


% ML
tic
[mu2, sigma2, lambda2] = OU_Calibrate_ML(S,delta);
time = toc;
fprintf('\nML: %5.4f s\n', time);
disp([mu2, sigma2, lambda2])

tic
[mu2, sigma2, lambda2] =  CalibrateOrnsteinUhlenbeckMaxLikelihood(S, delta);
time = toc;
fprintf('\nC_ML: %5.4f s\n', time);
disp([mu2, sigma2, lambda2])


fprintf('\nValues should be:\n');
disp(MLout);

