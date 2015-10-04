%Daniel Charlebois - January 2011 - MATLAB v7.11 (R2010b)
%Exact numerical solution and plots of the Ornstein-Uhlenbeck (OU) process
%and its time integral - calculation and plotting of the probability
%density function (pdf) of the OU process is also performed.
%
% based on Gillespie, "Exact numerical simulation of the Ornstein-Uhlenbeck
% process and its integral", Phys. Rev. E, 54(2): 2084 - 2091, 1996.
% 
%
% LMO26mar2015 create as function
%
% INPUTS:
% t_start, t_end = simulation start and end times
% dt = time step
% tau = relaxation time
% c = diffusion constant
% x0 = initial value for x
% mu = mean of stochastic process x
% y0 = initial value for integral of x
% start_dist, end_dist = start and end of OU pdf range
%
% OUTPUTS:
% x = the OU variable
% y = the time intergral of OU variable
% T = time for the simulation
% j = range of distances for the OU pdf
% p = OU pdf
%

function [x, y, T, j, p] = ou_process(t_start, t_end, dt, tau, c, x0, mu, y0, start_dist, end_dist)

%parameters
if nargin < 10
    warning('Too few input arguments for ou_process()');
    x = NaN;
    y = NaN;
    T = NaN;
    j = NaN;
    p = NaN;
    return
end

% time
T = t_start:dt:t_end;

% compute x and y
k = 1;
x(1) = x0; 
y(1) = y0;

% constants
for t=t_start+dt:dt:t_end
   k = k + 1; 
   r1 = randn;
   r2 = randn;
   x(k) = x(k-1)*exp(-dt/tau) + sqrt((c*tau*0.5)*(1-(exp(-dt/tau))^2))*r1;
   y(k) = y(k-1) + ...
       x(k-1)*tau*(1-exp(-dt/tau))+sqrt((c*tau^3*(dt/tau-2*(1-exp(-dt/tau))+0.5*(1-exp(-2*dt/tau))))-...
       ((0.5*c*tau^2)* (1-exp(-dt/tau))^2)^2/((c*tau/2)*(1-exp(-2*dt/tau))))*r2+...
       ((0.5*c*tau^2)* (1-exp(-dt/tau))^2)/(sqrt((c*tau/2)*(1-(exp(-dt/tau))^2)))*r1;
end

% pdf for OU process
k = 0;
j = start_dist:dt:end_dist;
p = zeros(size(j));
for d=j
    k = k + 1;
    p(k) = sqrt((1/tau)/(pi*c))*exp(-(1/tau)*(d-mu)^2/(c)); 
end
