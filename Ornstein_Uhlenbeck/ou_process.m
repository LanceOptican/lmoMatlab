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
ctauo2 = c * tau / 2;
ctau2o2 = c * (tau .^ 2) / 2;
ctau3 = c * tau .^ 3;
ex = exp(-dt / tau);
m1ex = 1 - ex;
ex2 = exp(-2 * dt / tau);
m1ex2 = 1 - ex2;
m1exu2 = m1ex^2;
cm1 = (ctau2o2*m1ex^2)^2;
cm2 = (ctauo2*m1ex2);
cm1o2 = cm1 / cm2;
sq1 = sqrt(ctauo2*(1-ex^2));
sq2 = sqrt((ctau3*(dt/tau-2*m1ex+0.5*(1-ex2))) - cm1o2);
cm3 = (ctau2o2 * m1exu2);
cm3osq1 = cm3/sq1;
for t=t_start+dt:dt:t_end
   k = k + 1; 
   r1 = randn;
   r2 = randn;
   x(k) = x(k-1)*ex + sq1 * r1;
   y(k) = y(k-1) + ...
       x(k-1) * tau * m1ex + ...
       sq2 * r2 + ...
       cm3osq1 * r1;
end

% pdf for OU process
k = 0;
j = start_dist:dt:end_dist;
p = zeros(size(j));
for d=j
    k = k + 1;
    p(k) = sqrt((1/tau)/(pi*c))*exp(-(1/tau)*(d-mu)^2/(c)); 
end
