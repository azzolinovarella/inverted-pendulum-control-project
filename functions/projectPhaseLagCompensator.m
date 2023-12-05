function compensator_tf = projectPhaseLagCompensator(plant_tf, desired_ess, desired_phase_margin)
    s = tf('s');

    % Calculo de K
    sys_type = sum(pole(plant_tf) == 0);
    error_constant = evalfr(plant_tf*(s^sys_type), eps);
    ess = 1/error_constant;
    K = ess/desired_ess;

    % Calculo de gamma
    gamma = desired_phase_margin - 180;
    [mag, phase, w] = bode(K*plant_tf);

    % Obter a frequencia onde a fase e igual (proxima) a gamma
    [~, index] = min(abs(phase - gamma));
    index = index(1);
    frequency_at_gamma = w(index);

    % Frequencia do zero do compensador
    zero_comp = frequency_at_gamma/10;
    T = 1/zero_comp;

    % Ganho em frequency_at_gamma
    gain_at_gamma = mag2db(mag(index));

    % Calculo de beta
    beta = 10^(gain_at_gamma/20);

    % Funcao de transferencia do compensador
    compensator_tf = K*(1 + s*T)/(1 + s*T*beta);
end