close all; clear; clc

addpath(genpath('../functions'))
s = tf('s');

desired_ess = 0.1/100;
desired_overshoot = 5/100;  % Reduz um pouco mais o pss mas aumenta ts
peak_time = 0.1;
tolerance = 5;

plant_tf = buildPlant();

% Calculo de K
sys_type = sum(pole(plant_tf) == 0);
error_constant = evalfr(plant_tf*(s^sys_type), eps);
ess = 1/error_constant;
K = ess/desired_ess;

% Aproximacao de segunda ordem - calculo xi, wn e BW
xi = -log(desired_overshoot)/sqrt(pi^2 + (log(desired_overshoot))^2);
wn = pi/(peak_time*sqrt(1 - xi^2));
BW = wn*sqrt((1 - 2*xi^2) + sqrt(4*xi^4 - 4*xi^2 + 2));

% Projeto atraso
desired_phase_margin = atand(2*xi/sqrt(-2*xi^2 + sqrt(1 + 4*xi^4)));
wcg = 0.8*BW;
w = linspace(0.9*wcg, 1.1*wcg, 1E3);  % Para centralizar em wcg e melhorar precisao
[~, phase] = bode(K*plant_tf, w);
[~, index] = min(abs(w - wcg));
gamma = phase(index);
phase_margin = 180 + gamma;
phi = desired_phase_margin - phase_margin + tolerance;
alpha = (1 - sind(phi))/(1 + sind(phi));
beta = 1/alpha;
T2 = 1/(wcg/10);
lag_compensator_tf = 1/beta*(s + 1/T2)/(s + 1/(beta*T2));

% Projeto avanco
T1 = 1/(wcg*sqrt(alpha));
lead_compensator_tf = 1/alpha*(s + 1/T1)/(s + 1/(alpha*T1));

% Funcao de transferencia do compensador
Gc = K*lag_compensator_tf*lead_compensator_tf;