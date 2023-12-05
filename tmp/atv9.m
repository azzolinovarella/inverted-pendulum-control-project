clear; close all; clc

s = tf('s');

%% Planta e especificacoes

% Planta - ex 3
G = 1/(s*(s + 8)*(s + 30));
% Ganho
K = 2400;  % Kv = 10
% Especificacoes
Mp = 10/100; 
tp = 0.6;
% ts = 0.01;
tol = 5;

% % Planta - ex 2
% G = 1/(s * (s + 4)*(s + 2));
% % Ganho
% K = 48;
% % Especificacoes
% Mp = 13.25/100;
% tp = 2;

% % Planta - ex extra
% G = 1*(s + 10)/(s*(s + 5)*(s + 15));
% % Ganho
% K = 12500;  % Kv = 1500
% % Especificacoes
% Mp = 15/100; 
% ts = 0.3;
% tol = 15;

% Planta com ganho ajustado
G1 = K*G;

%% Calculos preliminares

% Calculos considerando aproximacao de segunda ordem
% xi = -log(Mp)/sqrt(pi^2 + (log(Mp))^2);
% wn = pi/(tp*sqrt(1 - xi^2));
% BW = wn*sqrt((1 - 2*xi^2) + sqrt(4*xi^4 - 4*xi^2 + 2));
% MF_des = atand(2*xi/sqrt(-2*xi^2 + sqrt(1 + 4*xi^4)));
% wcg = 0.9*BW;

% Refiz, pq...
xi = -log(Mp)/sqrt(pi^2 + (log(Mp))^2);
wn = pi/(tp*sqrt(1 - xi^2));  % Em funcao do pico
% wn = 4/(ts*xi);  % Em funcao do assentamento
BW = wn*sqrt((1 - 2*xi^2) + sqrt(4*xi^4 - 4*xi^2 + 2));
wcg = 0.8*BW;
MF_des = atand(2*xi/sqrt(-2*xi^2 + sqrt(1 + 4*xi^4)));

%% Projeto atraso

w = logspace(-1, 2, 1E4);
[~, index] = min(abs(w - wcg));
[mag, phase] = bode(G1, w);
gamma = phase(index);

% figure
% margin(G1, w)
MF_at = 180 + gamma;  % MF_at deve ser igual a defasagem de G1 na nova freq de corte de ganho -> DA PROFESSORA

phi = MF_des - MF_at + tol;
alpha = (1 - sind(phi))/(1 + sind(phi));

% Forma 1
% wz_at = 0.1*wcg;
% wp_at = alpha*wz_at;
% beta = 1/alpha -> wz_at = 1/(beta*T2) = alpha*wz_at 

% Forma 2
T2 = 1/(wcg/10);
beta = 1/alpha;

% Forma 1
% Gc_at = 1/beta*(s + wz_at)/(s + wp_at);
% Forma 2
Gc_at = 1/beta*(s + 1/T2)/(s + 1/(beta*T2));

%% Projeto avanço

% Forma 1 
% wz_av = wcg*sqrt(alpha);
% wp_av = wz_av/alpha;

T1 = 1/(wcg*sqrt(alpha));
Gc_av = 1/alpha*(s + 1/T1)/(s + 1/(T1*alpha));

%% Validacao

Gc = Gc_at*Gc_av;
% figure
% margin(Gc*G1, w)

P = feedback(Gc*G1, 1);

figure
t = 0:0.01:10;
step(P, t);

% figure
% t = 0:0.01:30;
% step(P/s, t)