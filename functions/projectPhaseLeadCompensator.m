function compensator_transfer_function = projectPhaseLeadCompensator(plant_transfer_function, desired_error_constant, desired_phase_margin)
    s = tf('s');

    % Cálculo de K
    sys_type = sum(pole(plant_transfer_function) == 0);
    error_constant = evalfr(plant_transfer_function*(s^sys_type), eps);
    K = desired_error_constant/error_constant;

    % Cálculo de alpha
    [~, phase_margin] = margin(K*plant_transfer_function);  % Ganho do sistema com ganho ajustado mas não compensado
    phi = deg2rad(desired_phase_margin - phase_margin);
    alpha = (1 - sin(phi))/(1 + sin(phi));

    % Cálculo de T
    [~, ~, ~, wgc] = margin(K*plant_transfer_function/sqrt(alpha));  % Nova frequência de corte de ganho desejada
    T = 1/(wgc*sqrt(alpha));
        
    % Função de transferência
    compensator_transfer_function = K*(1 + s*T)/(1 + s*T*alpha);
end

