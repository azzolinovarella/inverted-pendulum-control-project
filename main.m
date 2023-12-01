close all; clear; clc

% addpath(genpath('./classes'))  % Para que seja possivel importar as classes
addpath(genpath('./functions'))  % Caso a gente mude para usarmos apenas funcoes

s = tf('s');

w = logspace(-1, 2, 1E3);

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
P = ng*nm*Kg*Kt/(s^2*(Rm*rmp*Mc + Rm*nm*Kg^2*Jm/rmp) + s*(Rm*rmp*Beq + ng*Kg^2*Kt*Km/rmp));

% Validacao do sistema  --> Acho legal substituir todo esse bloco por uma so funcao de validacao que traz todas essas representacoes... que tal?
% Daqui ----------
figure
margin(P, w)
grid on

figure
t = linspace(0, 30, 1E4);
r = t;
y_ = lsim(feedback(P, 1), r, t);
plot(t, r, 'k--')
hold on
plot(t, y_, 'r')
legend('Setpoint', 'Saida')
title(sprintf('Resposta a rampa - e_{ss} = %.2f %s', (r(end) - y_(end))*100, '%'))  % PORCO!!!
grid on

figure
t = linspace(0, 50, 1E4);
r = ones(length(t), 1);
y_ = step(feedback(P, 1), t);
plot(t, r, 'k--')
hold on
plot(t, y_, 'r')
legend('Setpoint', 'Saida')
title(sprintf('Resposta ao degrau - p_{ss} = %.2f %s', (max(y_) - y_(end))*100, '%'))  % PORCO!!!
grid on
% Ate aqui -------

%% Compensador por avanco

% Especificacoes  -> https://www2.units.it/carrato/didatt/E_web/doc/application_notes/overshoot_and_phase_margin.pdf confiavel? kkk
ess = 1/100;
mp = 5/100;

% Convertendo para especificacoes na frequencia
Kv = 1/ess;
MF = 75;  % Ajustaremos iterativamente
tol = 5;

psc = PhaseShiftController(P, Kv, MF, tol);
Gc = psc.transferFunction();

% for MF = [...]:
%     Gc = projectController(P, Kv, MF , tol);
%     validateController(P, Gc);
%     z
% end

% Validando o sistema compensado
figure
margin(Gc*P, w)
grid on

figure
t = linspace(0, 30, 1E4);
r = t;
y_ = lsim(feedback(Gc*P, 1), r, t);
plot(t, r, 'k--')
hold on
plot(t, y_, 'r')
legend('Setpoint', 'Saida')
title(sprintf('Resposta a rampa - e_{ess} = %.2f %s', (r(end) - y_(end))*100, '%'))  % PORCO!!!
grid on

figure
t = linspace(0, 2, 1E4);
r = ones(length(t), 1);
y_ = step(feedback(Gc*P, 1), t);
plot(t, r, 'k--')
hold on
plot(t, y_, 'r')
legend('Setpoint', 'Saida')
title(sprintf('Resposta ao degrau - p_{ss} = %.2f %s', (max(y_) - y_(end))/y(end)*100, '%'))  % PORCO!!!
grid on
