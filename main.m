close all; clear; clc

% Para importar as funçoes (que estao em outra pasta)
addpath(genpath('./functions'))

% Para deixar os graficos mais bonitos (facilita na hora de colocar no relatorio)
set(0, 'DefaultLineLineWidth', 2, 'DefaultAxesFontSize', 14, 'DefaultAxesFontName', 'Latin Modern Roman')


%% Definicao da planta e verificacao do sistema nao compensado
% Planta
P = buildPlant();

% Validacao do sistema
wBode = logspace(-1, 2, 1E3);
tRamp = linspace(0, 50, 1E3);
tStep = linspace(0, 50, 1E3);
%validateSystem(P, wBode, tRamp, tStep);

%% Compensador por avanco

% Especificacoes  -> https://www2.units.it/carrato/didatt/E_web/doc/application_notes/overshoot_and_phase_margin.pdf confiavel? kkk
ess = 1/100;
mp = 5/100;

% Convertendo para especificacoes na frequencia
Kv = 1/ess;
MF_lead = 75;  % Ajustaremos iterativamente
tol_lead = 5;

% Gc_lead = projectPhaseLeadCompensator(P, Kv, MF_lead + tol_lead);

% Validacao do sistema compensado
wBode = logspace(-1, 2, 1E3);
tRamp = linspace(0, 5, 1E3);
tStep = linspace(0, 1, 1E3);
% validateSystem(Gc_lead*P, wBode, tRamp, tStep);

%% Compensador por atraso

MF_lag = 65;  % Ajustaremos iterativamente
tol_lag = 5;

Gc_lag = projectPhaseLagCompensator(P, Kv, MF_lag + tol_lag);
validateSystem(Gc_lag*P, wBode, tRamp, tStep);





