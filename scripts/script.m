%% Clean environment
close all;
clear;
clc;

%% Initialize
N = 100;
qs = linspace(0, 2*pi, N);
ws = 5 + 2.*randn(N, 1);

K = 7;
r = 1;

kur = kuram(qs, ws, K, r);

%% Simulate
tStep = 0.025;
tEnd = 1;
ts = 0:tStep:tEnd;

F = kur.animate(ts, '..\figs\animation.gif');

%%
[qs, zs, weffs] = kur.sim(ts);

%% Plot
figure;
subplot(2, 2, 1);
xs = cos(qs(:,end));
ys = sin(qs(:,end));
scatter(xs, ys, 'filled');
hold on;
x = real(zs(end));
y = imag(zs(end));
scatter(x, y, 'filled');
hold off;
xlim([-1 1]);
ylim([-1 1]);
title('States and centroid');
%legend({'States', 'Order parameter'});

subplot(2, 2, 2);
histogram(kur.ws, 'Normalization', 'probability');
hold on;
histogram(weffs(:,end), 'Normalization', 'probability');
hold off;
ylim([0 1]);
title('Initial and effective frequencies');

subplot(2, 2, 3);
xs = real(zs);
ys = imag(zs);
plot(xs, ys, 'Color', 'r');
xlim([-1, 1]);
ylim([-1, 1]);
title('Order parameter');

subplot(2, 2, 4);
plot(ts, abs(zs), 'Color', 'r');
xlim([0, tEnd]);
ylim([0, 1]);
title('Order parameter length');
