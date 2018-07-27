%% Clean environment
clear all;
close;
clc;

%% Initialize
N = 20;
qs = linspace(0, 2*pi, N)';
ws = 1 + 2.*randn(N, 1);

K = 10;
r = 1;

kur = kuram(qs, ws, K, r);

%% Plot
figure;
kur.plotfreq();

figure;
subplot(2, 1, 1);
kur.plot();

for i = 1:100
    kur.update(0.01);
end
subplot(2, 1, 2);
kur.plot();