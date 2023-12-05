function compensator_tf = projectPhaseLeadCompensator(plant_tf, desired_ess, desired_phase_margin)
    s = tf('s');

    % Calculo de K
    sys_type = sum(pole(plant_tf) == 0);
    error_constant = evalfr(plant_tf*(s^sys_type), eps);
    ess = 1/error_constant;
    K = ess/desired_ess;

    % Calculo de alpha
    [~, phase_margin] = margin(K*plant_tf);
    phi = deg2rad(desired_phase_margin - phase_margin);
    alpha = (1 - sin(phi))/(1 + sin(phi));

    % Calculo de T
    [~, ~, ~, wm] = margin(K*plant_tf/sqrt(alpha)); 
    T = 1/(wm*sqrt(alpha));
        
    % Funcao de transferencia do compensador
    compensator_tf = K*(1 + s*T)/(1 + s*T*alpha);
end