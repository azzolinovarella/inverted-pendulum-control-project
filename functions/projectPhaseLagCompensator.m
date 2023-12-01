function Gc = projectPhaseLagCompensator(plantTransferFunction, desiredErrorConstant, desiredPhaseMargin)
    s = tf('s');

    % Cálculo de K
    sysType = sum(pole(plantTransferFunction) == 0);
    errorConstant = evalfr(plantTransferFunction*(s^sysType), eps);
    K = desiredErrorConstant/errorConstant;

    % Cálculo de gamma
    gamma = desiredPhaseMargin - 180;
    [mag, phase, w] = bode(K*plantTransferFunction);
        
    % Obter a frequência onde a fase é igual (próxima) a gamma
    [~, index] = min(abs(phase - gamma));
    frequency_at_gamma = w(index);

    % A frequência do zero do compensador será uma década abaixo de frequency_at_gamma
    zero_comp = frequency_at_gamma/10;
    T = 1/zero_comp;

    % Ganho em frequency_at_gamma
    gain_at_gamma = mag(index);

    % Cálculo de beta
    beta = 10^(gain_at_gamma/20);
            
    % Função de transferência
    Gc = K*(T*s+1)/(beta*T*s + 1);    
end

