close all; clear; clc

% Para importar as funçoes (que estao em outra pasta)
addpath(genpath('./functions'))

% Para deixar os graficos mais bonitos (facilita na hora de colocar no relatorio)
set(0, 'DefaultLineLineWidth', 2, 'DefaultAxesFontSize', 14, 'DefaultAxesFontName', 'Latin Modern Roman')

%% Definicao da planta e verificacao do sistema nao compensado

% Planta
P = buildPlant();

% Validacao do sistema
% w_bode = logspace(-1, 2, 1E3);
% t_ramp = linspace(0, 50, 1E3);
% t_step = linspace(0, 50, 1E3);
% plotSystemResponse(P, w_bode, t_ramp, t_step);

%% Compensador por avanco

% Especificacoes
ess_lead = 1/100;
mp_lead = 5/100;

% Convertendo para especificacoes na frequencia
Kv_lead = 1/ess_lead;
MF_lead_start = 45; % Valor inicial

% Para encontrarmos o melhor compensador de forma automatica  --> talvez substituir isso por outra func? kkkk
w_bode_lead = logspace(-1, 2, 1E3);  % Tempo muda de um compensador pro outro! 
t_ramp_lead = linspace(0, 5, 1E3);
t_step_lead = linspace(0, 1, 1E3);

for MF_lead = MF_lead_start:5:180
    if (MF_lead >= 180)  % Necessario?
        error('Phase margin cannot be greater than 180 deg.')
    end

    Gc_lead = projectPhaseLeadCompensator(P, Kv_lead, MF_lead);
    
    [~, mp_i, ess_i, ~, ~] = getMetrics(Gc_lead*P, t_ramp_lead, t_step_lead);

    if ((mp_i <= mp_lead) && (ess_i <= ess_lead))
        break
    end
end
% Validacao do sistema compensado
plotSystemResponse(Gc_lead*P, w_bode_lead, t_ramp_lead, t_step_lead);

%% Compensador por atraso

% Especificacoes 
ess_lag = 0.1/100;
mp_lag = 5/100;

% Convertendo para especificacoes na frequencia
Kv_lag = 1/ess_lag;
MF_lag_start = 45;  % Valor inicial

% Para encontrarmos o melhor compensador de forma automatica  --> talvez substituir isso por outra func? kkkk
w_bode_lag = logspace(-1, 2, 1E3);  % Tempo muda de um compensador pro outro!
t_ramp_lag = linspace(0, 1E4, 1E3);
t_step_lag = linspace(0, 400, 1E4);

for MF_lag = MF_lag_start:5:180
    if (MF_lag >= 180)  % Necessario?
        % error('Phase margin cannot be greater than 180 deg.')
    end

    Gc_lag = projectPhaseLagCompensator(P, Kv_lag, MF_lag);
    
    [~, mp_i, ess_i, ~, ~] = getMetrics(Gc_lag*P, t_ramp_lag, t_step_lag);

    if ((mp_i <= mp_lag) && (ess_i <= ess_lag))
        break
    end
end

% Validacao do sistema compensado
plotSystemResponse(Gc_lag*P, w_bode_lag, t_ramp_lag, t_step_lag);