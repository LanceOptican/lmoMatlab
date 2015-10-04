% function [ output_args ] = MLE_Test( )

%% Create an Ornstein-Uhlenbeck mean reverting process with know
%% parameters, then try to estimate those same parameters using different
%% techniques.
%% License
% Copyright 2010, William Smith, CommodityModels.com . All rights reserved.
%
% Redistribution and use in source and binary forms, with or without modification, are
% permitted provided that the following conditions are met:
%
% 1. Redistributions of source code must retain the above copyright notice, this list of
% conditions and the following disclaimer.
%
% 2. Redistributions in binary form must reproduce the above copyright notice, this list
% of conditions and the following disclaimer in the documentation and/or other materials
% provided with the distribution.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER, WILLIAM SMITH ``AS IS'' AND ANY EXPRESS
% OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
% MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
% THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
% SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
% OF SUBSTITUTE GOODS ORSERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
% HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
% OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%% Known parameters. Based on the parameters estimated for the mean
%% reverting convenience yield in the original 'Gibson Schwartz' model:
%% Gibson, R., and E. S. Schwartz. 1990. "Stochastic convenience yield and the pricing of
%% oil contingent claims" , Journal of Finance: 959-976.
S0 = 0.19;      % starting value
mu = 0.19;      % this is the noise mean
sigma = 1.1;    % this is the noise std dev
lambda = 16;    % this is 1/tau, where tau is the relaxation time from Gillespie
deltat = 1/50;
T = 5;
%% Run and time the simulations and estimations.
fprintf('O-U\n');
simulations = 10000;
mu_hat = zeros(4,simulations);
sigma_hat = zeros(4,simulations);
lambda_hat= zeros(4,simulations);
timers = zeros(5,1);
% Run many simulations, re-estimate parameters in different ways.
% Saving each simulation is memory-intensive, but allows us to plot
% empirical conficence intervals.
for i=1:1:simulations
 tic;
 S(i,:) = SimulateOrnsteinUhlenbeck(S0, mu, sigma, lambda, deltat, T);
 timers(1) = timers(1) + toc;
 tic ;
 [ mu_hat(2,i), sigma_hat(2,i), lambda_hat(2,i) ] = ...
 CalibrateOrnsteinUhlenbeckMaxLikelihood (S(i,:), deltat, T);
 timers(2) = timers(2) + toc;
 tic;
 [ mu_hat(3,i), sigma_hat(3,i), lambda_hat(3,i) ] = ...
 CalibrateOrnsteinUhlenbeckMaxLikelihoodJackknife(S(i,:), deltat, T);
 timers(3) = timers(3) + toc;
 tic;
 [ mu_hat(4,i), sigma_hat(4,i), lambda_hat(4,i) ] = ...
 CalibrateOrnsteinUhlenbeckRegress (S(i,:), deltat, T);
 timers(4) = timers(4) + toc;
 tic;
 [ mu_hat(5,i), sigma_hat(5,i), lambda_hat(5,i) ] = ...
 CalibrateOrnsteinUhlenbeckLeastSquares (S(i,:), deltat, T);
 timers(5) = timers(5) + toc;
end

%%
% Plot two sample paths, the first two, just so we can
% visualise it.
figure(1);
clf

subplot(3,2,1);
plot( 1:size(S,2) , S(1,:), ...
 1:size(S,2) , quantile(S,0.05,1), ...
 1:size(S,2) , quantile(S,0.95,1));
textpercent(5, 95, sprintf('mu %4.3f, sigma %5.3f lambda %5.3f', mu, sigma, lambda));

subplot(3,2,2);
plot( 1:size(S,2) , S(10,:), ...
 1:size(S,2) , quantile(S,0.05,1), ...
 1:size(S,2) , quantile(S,0.95,1));
textpercent(5, 95, sprintf('mu %4.3f, sigma %5.3f lambda %5.3f', mu, sigma, lambda));

fprintf('\nSimulation : %fs\n', timers(1));
fprintf('true: mu = %5.3f, sigma = %5.3f, lambda = %5.3f\n', mu, sigma, lambda);

name = {'simulation', 'MLE', 'Jackknife MLE', 'Simple Regression', ...
    'Least Squares'};

for k = 2:5
    fprintf('\n%s : %fs\n', name{k}, timers(k));
    fprintf('mean hat:  mu, sigma, lambda +- std:\n%5.3f +- %5.3f, %5.3f +- %5.3f, %5.3f +- %5.3f\n',...
    mean(mu_hat(k,:)), std(mu_hat(k,:)), ...
    mean(sigma_hat(k,:)), std(sigma_hat(k,:)), ...
    mean(lambda_hat(k,:)), std(lambda_hat(k,:)));
end

% Intelligent axes.
lambdamin=min(min(lambda_hat));
lambdamax=max(max(lambda_hat));

for k = 2:5
    subplot(3,2, 1 + k);
    histfit(lambda_hat(k,:),100);
    xlim([lambdamin lambdamax]);
    title(name{k});
    textpercent(5, 95, sprintf('%4.3f+-%4.3f, %4.3f+-%4.3f, %4.3f+-%4.3f', ...
    mean(mu_hat(k,:)), std(mu_hat(k,:)), mean(sigma_hat(k,:)), std(sigma_hat(k,:)),...
        mean(lambda_hat(k,:)), std(lambda_hat(k,:)) ));
end
