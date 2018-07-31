%% Clean environment
close all;
clear;
clc;

%% Initialize
N = 20;
qs = linspace(0, 2*pi, N);
ws = 0 + 2.*randn(N, 1);

K = 10;
r = 1;

kur = kuram(qs, ws, K, r);

%% Plot

figure;
for i = 1:100
    subplot(1, 2, 1);
    kur.update(0.01);
    kur.plot();
    hold on;
    kur.plotop();
    hold off;
    
    subplot(1, 2, 2);
    kur.plotfreq();
end