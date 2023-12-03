function compensator_transfer_function = projectPhaseLagCompensator(plant_transfer_function, desired_error_constant, desired_phase_margin)
    s = tf('s');

    % Cálculo de K
    sys_type = sum(pole(plant_transfer_function) == 0);
    error_constant = evalfr(plant_transfer_function*(s^sys_type), eps);
    K = desired_error_constant/error_constant;

    % Cálculo de gamma
    gamma = desired_phase_margin - 180;
    [mag, phase, w] = bode(K*plant_transfer_function);

    % Obter a frequência onde a fase é igual (próxima) a gamma
    [~, index] = min(abs(phase - gamma));
    index = index(1);  % So para garantir que so vamos pegar um unico valor
    frequency_at_gamma = w(index);

    % A frequência do zero do compensador será de uma década a um oitavo abaixo de frequency_at_gamma
    zero_comp = frequency_at_gamma/10;  % Uma dec
    % zero_comp = frequency_at_gamma/2;  % Uma oit
    % zero_comp = frequency_at_gamma/100;  % Duas dec -> atende as especificacoes
    T = 1/zero_comp;

    % Ganho em frequencyAtGamma
    gain_at_gamma = mag2db(mag(index));

    % Cálculo de beta
    beta = 10^(gain_at_gamma/20);

    % Função de transferência
    compensator_transfer_function = K*(1 + s*T)/(1 + s*T*beta);
end

