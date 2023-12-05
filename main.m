close all; clear; clc

% Para importar as funçoes (que estao em outra pasta)
addpath(genpath('./functions'))

% Para deixar os graficos mais bonitos (facilita na hora de colocar no relatorio)
set(0, 'DefaultLineLineWidth', 2, 'DefaultAxesFontSize', 14, 'DefaultAxesFontName', 'Latin Modern Roman')

%% Definicao da planta e verificacao do sistema nao compensado

% Planta
P = buildPlant();

% Validacao do sistema
w_bode = logspace(-1, 2, 1E3);
t_ramp = linspace(0, 50, 1E3);
t_step = linspace(0, 50, 1E3);
% plotSystemResponse(P, w_bode, t_ramp, t_step);

%% Compensador por avanco

% Especificacoes
ess_lead = 1/100;
mp_lead = 5/100;

% Convertendo para especificacoes na frequencia
MF_lead_start = 45; % Valor inicial

% Para encontrarmos o melhor compensador de forma automatica  --> talvez substituir isso por outra func? kkkk
w_bode_lead = logspace(-1, 2, 1E3);  % Tempo muda de um compensador pro outro! 
t_ramp_lead = linspace(0, 5, 1E3);
t_step_lead = linspace(0, 1, 1E3);

for MF_lead = MF_lead_start:5:180
    Gc_lead = projectPhaseLeadCompensator(P, ess_lead, MF_lead);
    
    [~, mp_i, ess_i, ~, ~] = getMetrics(Gc_lead*P, t_ramp_lead, t_step_lead);

    if ((mp_i <= mp_lead) && (ess_i <= ess_lead))
        break
    end
end

% Validacao do sistema compensado
% plotSystemResponse(Gc_lead*P, w_bode_lead, t_ramp_lead, t_step_lead);

%% Compensador por atraso

% Especificacoes 
ess_lag = 0.1/100;
% mp_lag = 5/100;  % Reduz um pouco mais o pss mas aumenta ts
mp_lag = 10/100;  % Aumenta um pouco mais o pss mas diminui o ts (melhor trade-off?)

% Convertendo para especificacoes na frequencia
MF_lag_start = 45;  % Valor inicial

% Para encontrarmos o melhor compensador de forma automatica  --> talvez substituir isso por outra func? kkkk
w_bode_lag = logspace(-1, 2, 1E3);  % Tempo muda de um compensador pro outro!
% t_ramp_lag = linspace(0, 1E4, 1E3);
% t_step_lag = linspace(0, 400, 1E4);
t_ramp_lag = linspace(0, 1E2, 1E3);
t_step_lag = linspace(0, 10, 1E4);

for MF_lag = MF_lag_start:5:180
    Gc_lag = projectPhaseLagCompensator(P, ess_lag, MF_lag);
    
    [~, mp_i, ess_i, ~, ~] = getMetrics(Gc_lag*P, t_ramp_lag, t_step_lag);

    if ((mp_i <= mp_lag) && (ess_i <= ess_lag))
        break
    end
end

% Validacao do sistema compensado
plotSystemResponse(Gc_lag*P, w_bode_lag, t_ramp_lag, t_step_lag);

%% Compensador por avanco-atraso

% Especificacoes 
ess_leadlag = 0.1/100;
mp_leadlag = 5/100;  % Reduz um pouco mais o pss mas aumenta ts
tp_leadlag = 0.1;  % Aumenta um pouco mais o pss mas diminui o ts (melhor trade-off?)

% Convertendo para especificacoes na frequencia
tol_leadlag_start = 0;  % Valor inicial

% Para encontrarmos o melhor compensador de forma automatica  --> talvez substituir isso por outra func? kkkk
w_bode_leadlag = logspace(-1, 2, 1E3);  % Tempo muda de um compensador pro outro!
t_ramp_leadlag = linspace(0, 10, 1E3);
t_step_leadlag = linspace(0, 1, 1E3);

for tol_leadlag = tol_leadlag_start:1:20
    Gc_leadlag = projectPhaseLeadLagCompensator(P, ess_leadlag, mp_leadlag, tp_leadlag, tol_leadlag);
    
    [tp_i, mp_i, ess_i, ~, ~] = getMetrics(Gc_leadlag*P, t_ramp_leadlag, t_step_leadlag);

    if ((mp_i <= mp_leadlag) && (ess_i <= ess_leadlag)) && (tp_i <= tp_leadlag)
        break
    end
end

% Validacao do sistema compensado
plotSystemResponse(Gc_leadlag*P, w_bode_leadlag, t_ramp_leadlag, t_step_leadlag);