% Parameters
absTol = 1e-4;
relTol = 1e-6;

%% Constructor
N = 50;
qs = linspace(0, 2*pi, N);
ws = 1 + 2.*randn(N, 1);

K = 1;
r = 1;

try
    % Construct the object
    kur = kuram(qs, ws, K, r);
    
    % Check the object is correctly built
    assert(kur.K == K);
    assert(kur.r == r);
    assert(kur.N == N);
    
    for i = 1:N
        assert(kur.qs(i) == qs(i));
        assert(kur.ws(i) == ws(i));
    end
    
catch % If the constructor fails
    assert(false);
end

%% Merry go round
N = 50;
qs = linspace(0, 2*pi, N);
ws = 1;

K = 0;
r = 1;

kur = kuram(qs, ws, K, r);

tStep = 0.01;
for ts = 0:tStep:1
    kur.update(tStep);
    dist = NaN(1, N-1);
    for i = 1:N-1
        dist(i) = abs(kur.qs(i+1) - kur.qs(i));
    end
    assert(abs(max(dist) - min(dist)) < absTol);
end

%% Order parameter
N = 50;
qs = linspace(0, 2*pi, N);
ws = 1 + 2.*randn(N, 1);

K = 1;
r = 1;

kur = kuram(qs, ws, K, r);

% Compare expected and obtained results
z_expected = mean(exp(1i.*qs(:)));
len_expected = abs(z_expected);
psi_expected = angle(z_expected);

[z, len, psi] = kur.orderparameter();

assert(z == z_expected);
assert(len == len_expected);
assert(psi == psi_expected);

%% Effective frequency
N = 50;
qs = linspace(0, 2*pi, N);
ws = 1 + 2.*randn(N, 1);

K = 1;
r = 1;

kur = kuram(qs, ws, K, r);

% Compare expected and obtained results
z = mean(exp(1i.*qs(:)));
psi = angle(z);

expected_weff = ws(:) + K.*r.*sin(psi(:) - qs(:));
measured_weff = kur.weff();
assert(max(abs(kur.weff - expected_weff)) < absTol);

%% Plot
N = 50;
qs = linspace(0, 2*pi, N);
ws = 1 + 2.*randn(N, 1);

K = 1;
r = 1;

try
    kur = kuram(qs, ws, K, r);
    
    kur.plot();
    close all;
    assert(true);
catch
    assert(false);
end

%% Plot freq
N = 50;
qs = linspace(0, 2*pi, N);
ws = 1 + 2.*randn(N, 1);

K = 1;
r = 1;

try
    kur = kuram(qs, ws, K, r);
    
    kur.plotfreq();
    close all;
    assert(true);
catch
    assert(false);
end

%% Plot order parameter
N = 50;
qs = linspace(0, 2*pi, N);
ws = 1 + 2.*randn(N, 1);

K = 1;
r = 1;

try
    kur = kuram(qs, ws, K, r);
    
    kur.plotop();
    close all;
    assert(true);
catch
    assert(false);
end