close all; clear; clc

% Para importar as funçoes (que estao em outra pasta)
addpath(genpath('./functions'))

% Para deixar os graficos mais bonitos (facilita na hora de colocar no relatorio)
set(0, 'DefaultLineLineWidth', 2, ...
    'DefaultAxesFontSize', 14, ...
    'DefaultAxesFontName', 'Latin Modern Roman', ...
    'DefaultTextFontName', 'Latin Modern Roman', ...
    'DefaultFigureVisible', 'off')  % Para evitar abrir milhares de graficos...

%% Definicao da planta e verificacao do sistema nao compensado

% Planta
P = buildPlant();

% Validacao do nao compensado sistema
w_bode = logspace(-2, 4, 1E3);
t_ramp = linspace(0, 50, 1E3);
t_step = linspace(0, 50, 1E3);
[fig1, fig2, fig3, fig4] =  plotSystemResponse(P, w_bode, t_ramp, t_step);

% Exportando figuras
saveFig(fig1, './figs/bode_ol_nocomp.png')
saveFig(fig2, './figs/bode_cl_nocomp.png')
saveFig(fig3, './figs/ramp_nocomp.png')
saveFig(fig4, './figs/step_nocomp.png')

%% Compensador por avanco

% Especificacoes
ess_lead = 1/100;
mp_lead = 5/100;

% Convertendo para especificacoes na frequencia
MF_lead_start = 45; % Valor inicial

% Para encontrarmos o melhor compensador de forma automatica
w_bode_lead = logspace(-2, 4, 1E3);  % Tempo muda de um compensador pro outro! 
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
[fig1_lead, fig2_lead, fig3_lead, fig4_lead] = plotSystemResponse(Gc_lead*P, w_bode_lead, t_ramp_lead, t_step_lead);

% Exportando figuras
saveFig(fig1_lead, './figs/bode_ol_lead.png')
saveFig(fig2_lead, './figs/bode_cl_lead.png')
saveFig(fig3_lead, './figs/ramp_lead.png')
saveFig(fig4_lead, './figs/step_lead.png')

%% Compensador por atraso

% Especificacoes 
ess_lag = 0.1/100;
% mp_lag = 5/100;  % Reduz um pouco mais o pss mas aumenta ts
mp_lag = 10/100;  % Aumenta um pouco mais o pss mas diminui o ts (melhor trade-off?)

% Convertendo para especificacoes na frequencia
MF_lag_start = 45;  % Valor inicial

% Para encontrarmos o melhor compensador de forma automatica
w_bode_lag = logspace(-2, 4, 1E3);  % Tempo muda de um compensador pro outro!
% t_ramp_lag = linspace(0, 1E4, 1E3);  % Para mp_lag = 5/100 (mais lento)
% t_step_lag = linspace(0, 400, 1E4);
t_ramp_lag = linspace(0, 1E2, 1E3);  % Para mp_lag = 10/100 (mais rapido)
t_step_lag = linspace(0, 10, 1E4);

for MF_lag = MF_lag_start:5:180
    Gc_lag = projectPhaseLagCompensator(P, ess_lag, MF_lag);
    
    [~, mp_i, ess_i, ~, ~] = getMetrics(Gc_lag*P, t_ramp_lag, t_step_lag);

    if ((mp_i <= mp_lag) && (ess_i <= ess_lag))
        break
    end
end

% Validacao do sistema compensado
[fig1_lag, fig2_lag, fig3_lag, fig4_lag] = plotSystemResponse(Gc_lag*P, w_bode_lag, t_ramp_lag, t_step_lag);

% Exportando figuras
saveFig(fig1_lag, './figs/bode_ol_lag.png')
saveFig(fig2_lag, './figs/bode_cl_lag.png')
saveFig(fig3_lag, './figs/ramp_lag.png')
saveFig(fig4_lag, './figs/step_lag.png')

%% Compensador por avanco-atraso

% Especificacoes 
ess_leadlag = 0.1/100;
mp_leadlag = 5/100;  % Reduz um pouco mais o pss mas aumenta ts
tp_leadlag = 0.1;  % Aumenta um pouco mais o pss mas diminui o ts (melhor trade-off?)

% Convertendo para especificacoes na frequencia
tol_leadlag_start = 0;  % Valor inicial

% Para encontrarmos o melhor compensador de forma automatica
w_bode_leadlag = logspace(-2, 4, 1E3);  % Tempo muda de um compensador pro outro!
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
[fig1_leadlag, fig2_leadlag, fig3_leadlag, fig4_leadlag] = plotSystemResponse(Gc_leadlag*P, w_bode_leadlag, t_ramp_leadlag, t_step_leadlag);

% Exportando figuras
saveFig(fig1_leadlag, './figs/bode_ol_leadlag.png')
saveFig(fig2_leadlag, './figs/bode_cl_leadlag.png')
saveFig(fig3_leadlag, './figs/ramp_leadlag.png')
saveFig(fig4_leadlag, './figs/step_leadlag.png')