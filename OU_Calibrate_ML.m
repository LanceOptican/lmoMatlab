% calibrate Ornstein-Uhlenbeck process with Maximum Likelihood method
% from SITMO article, 2014: http://www.sitmo.com/article/calibrating-the-ornstein-uhlenbeck-model/
% INPUTS:
%   S = data to be fit
%   delta = time step
%
% OUTPUTS:
%   mu = long term mean of OU process
%   sigma = noise term
%   lambda = mean reversion rate = 1/tau, where tau is the relaxation time

function [mu,sigma,lambda] = OU_Calibrate_ML(S,delta)
  n = length(S)-1;
 
  Sx  = sum( S(1:end-1) );
  Sy  = sum( S(2:end) );
  Sxx = sum( S(1:end-1).^2 );
  Sxy = sum( S(1:end-1).*S(2:end) );
  Syy = sum( S(2:end).^2 );
 
  mu  = (Sy*Sxx - Sx*Sxy) / ( n*(Sxx - Sxy) - (Sx^2 - Sx*Sy) );
  lambda = -log( (Sxy - mu*Sx - mu*Sy + n*mu^2) / (Sxx -2*mu*Sx + n*mu^2) ) / delta;
  a = exp(-lambda*delta);
  sigmah2 = (Syy - 2*a*Sxy + a^2*Sxx - 2*mu*(1-a)*(Sy - a*Sx) + n*mu^2*(1-a)^2)/n;
  sigma = sqrt(sigmah2*2*lambda/(1-a^2));
end