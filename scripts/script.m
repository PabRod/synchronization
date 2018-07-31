%% Clean environment
close all;
clear;
clc;

%% Initialize
N = 20;
qs = linspace(0, 2*pi, N);
% ws = 1 + 2.*randn(N, 1);
ws = 1;

K = 0;
r = 1;

kur = kuram(qs, ws, K, r);

%% Plot
figure;
kur.plotfreq();

figure;
kur.plot();

figure;
for i = 1:100
    kur.update(0.01);
    kur.plot();
end