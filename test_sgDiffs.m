% test sgDiffs

dt = 0.2;
tLim = 200;
t = [0:dt:tLim-1]';

y = 8 * (t/200) + 2 * cos(0.01 * pi * t) + 5*sin(0.04*pi*t) + 3*sin(0.06*pi*t) + randn(size(t))/1000000;  % Sinusoid with noise

sgK = 4; 4;
sgF = 21; 25;

tic
dy = sgDiff(y, dt, sgK, sgF);
ddy = [0; diff(diff(y)); 0]/(dt*dt);
toc

tic
[sy, sdy, sddy] = sgDiffs(y, dt, sgK, sgF);
toc

figure(1)
clf
subplot(1, 3, 1)
plot(t, y, 'k.');
hold on
plot(t, sy, 'r');


subplot(1, 3, 2)
dz = [diff(y)]/dt;
dz = [dz; dz(end) + (dz(end) - dz(end-1))];
plot(t, dz, 'k.');
hold on
plot(t, sdy, 'rx');
% plot(t, dy, 'm.');


subplot(1, 3, 3)
plot(t, ddy, 'k.');
hold on
plot(t, sddy, 'r.-');

