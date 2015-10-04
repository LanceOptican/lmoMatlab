% calibrate Ornstein-Uhlenbeck process with Least-Squares method
% from SITMO article, 2014: http://www.sitmo.com/article/calibrating-the-ornstein-uhlenbeck-model/
% INPUTS:
%   S = data to be fit
%   delta = time step
%
% OUTPUTS:
%   mu = long term mean of OU process
%   sigma = noise term
%   lambda = mean reversion rate = 1/tau, where tau is the relaxation time
%
function [mu,sigma,lambda] = OU_Calibrate_LS(S,delta)

% regression
n = length(S)-1;

Sx  = sum( S(1:end-1) );
Sy  = sum( S(2:end) );
Sxx = sum( S(1:end-1).^2 );
Sxy = sum( S(1:end-1).*S(2:end) );
Syy = sum( S(2:end).^2 );

a  = ( n*Sxy - Sx*Sy ) / ( n*Sxx -Sx^2 );
b  = ( Sy - a*Sx ) / n;
sd = sqrt( (n*Syy - Sy^2 - a*(n*Sxy - Sx*Sy) )/n/(n-2) );

lambda = -log(a)/delta;
mu     = b/(1-a);
sigma  =  sd * sqrt( -2*log(a)/delta/(1-a^2) );
