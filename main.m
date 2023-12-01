close all; clear; clc

% Para importar as funçoes (que estao em outra pasta)
addpath(genpath('./functions'))

% Para deixar os graficos mais bonitos (facilita na hora de colocar no relatorio)
set(0, 'DefaultLineLineWidth', 2, 'DefaultAxesFontSize', 14, 'DefaultAxesFontName', 'Latin Modern Roman')

%% Definicao da planta e verificacao do sistema nao compensado

% Parametros
Rm = 2.6;      % [Rm] = ohm
Jm = 3.9E-7;   % [Jm] = kg m^2
Kt = 7.68E-3;  % [Kt] = Nm/A
nm = 1;        % [nm] = 1 (adimensional
Km = 7.68E-3;  % [Km] = V/(rad/s)
Kg = 3.71;     % [Kg] = 1 (adimensional
ng = 1;        % [ng] = 1 (adimensional
Mc = 0.94;     % [Mc] = kg
rmp = 0.0063;  % [rmp] = m
Beq = 5.4;     % [Beq] = N/(m(rad/s))
g = 9.81;      % [g] = m/s^2

% Planta
s = tf('s');
P = ng*nm*Kg*Kt/(s^2*(Rm*rmp*Mc + Rm*nm*Kg^2*Jm/rmp) + s*(Rm*rmp*Beq + ng*Kg^2*Kt*Km/rmp));

% Validacao do sistema
wBode = logspace(-1, 2, 1E3);
tRamp = linspace(0, 50, 1E3);
tStep = linspace(0, 50, 1E3);
validateSystem(P, wBode, tRamp, tStep);

%% Compensador por avanco

% Especificacoes  -> https://www2.units.it/carrato/didatt/E_web/doc/application_notes/overshoot_and_phase_margin.pdf confiavel? kkk
ess = 1/100;
mp = 5/100;

% Convertendo para especificacoes na frequencia
Kv = 1/ess;
MF = 75;  % Ajustaremos iterativamente
tol = 5;

Gc = projectPhaseLeadCompensator(P, Kv, MF + tol);

% Validacao do sistema compensado
wBode = logspace(-1, 2, 1E3);
tRamp = linspace(0, 5, 1E3);
tStep = linspace(0, 1, 1E3);
validateSystem(Gc*P, wBode, tRamp, tStep);
