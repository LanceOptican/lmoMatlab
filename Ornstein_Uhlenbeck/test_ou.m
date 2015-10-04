%Daniel Charlebois - January 2011 - MATLAB v7.11 (R2010b)
%Exact numerical solution and plots of the Ornstein-Uhlenbeck (OU) process
%and its time integral - calculation and plotting of the probability
%density function (pdf) of the OU process is also performed.

clear all; 

%parameters
t_start = 0;          %simulation start time
t_end = 400;          %simuation end time
dt = 0.01;            %time step
tau = 0.1;            %relaxation time
c = 1;                %diffusion constant
x0 = 0;               %initial value for stochastic variable x
mu = 0;               %mean of stochatic process x
y0 = 0;               %initial value for integral x 
start_dist = -2.0;    %start of OU pdf 
end_dist = 2.0;       %end of OU pdf

tic
[x, y, T, j, p] = ou_process_orig(t_start, t_end, dt, tau, c, x0, mu, y0, start_dist, end_dist);
toc


%plots
figure(1);
clf
subplot(3,1,1)
plot(T,x,'k-')
xlabel('time')
ylabel('x')
title('Exact numerical solution  of the Ornstein-Uhlenbeck (OU) process and its time integral');
subplot(3,1,2)
plot(T,y,'k-')
xlabel('time')
ylabel('y')
subplot(3,1,3)
hold on
histfit(x,60)
plot(j,p,'r-')
xlabel('x')
ylabel('probability')
hold off


y1 = y;
tic
[x, y, T, j, p] = ou_process(t_start, t_end, dt, tau, c, x0, mu, y0, start_dist, end_dist);
toc


%plots
figure(2);
clf
subplot(3,1,1)
plot(T,x,'k-')
xlabel('time')
ylabel('x')
title('Exact numerical solution  of the Ornstein-Uhlenbeck (OU) process and its time integral');
subplot(3,1,2)
plot(T,y,'k-')
xlabel('time')
ylabel('y')
subplot(3,1,3)
hold on
histfit(x,60)
plot(j,p,'r-')
xlabel('x')
ylabel('probability')
hold off
