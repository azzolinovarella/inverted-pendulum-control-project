function Gc = projectPhaseLeadCompensator(plantTransferFunction, desiredErrorConstant, desiredPhaseMargin)
    s = tf('s');

    % Cálculo de K
    sysType = sum(pole(plantTransferFunction) == 0);
    errorConstant = evalfr(plantTransferFunction*(s^sysType), eps);
    K = desiredErrorConstant/errorConstant;

    % Cálculo de alpha
    [~, phaseMargin] = margin(K*plantTransferFunction);  % Ganho do sistema com ganho ajustado mas não compensado
    phi = deg2rad(desiredPhaseMargin - phaseMargin);
    alpha = (1 - sin(phi))/(1 + sin(phi));

    % Cálculo de T
    [~, ~, ~, wgc] = margin(K*plantTransferFunction/sqrt(alpha));  % Nova frequência de corte de ganho desejada
    T = 1/(wgc*sqrt(alpha));
        
    % Função de transferência
    Gc = K*(1 + s*T)/(1 + s*T*alpha);
end

