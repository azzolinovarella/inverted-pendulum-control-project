function [fig1, fig2, fig3, peakTime, percentageOvershoot, steadyStateError] = validateSystem(openLoopTransferFunction, wBode, tRamp, tStep)
    s = tf('s');
    closedLoopTransferFunction = feedback(openLoopTransferFunction, 1);
    
    
    % Diagrama de bode
    [mag, phase] = bode(closedLoopTransferFunction, wBode);
    mag = squeeze(mag2db(mag));
    phase = squeeze(phase);

    fig1 = figure;
    ax11 = subplot(2, 1, 1);
    semilogx(wBode, mag)
    ylabel('Magnitude [dB]')
    xlabel('\omega [rad/s]')
    grid on
    title('Diagrama de Bode')
    ax12 = subplot(2, 1, 2);
    semilogx(wBode, phase)
    ylabel('Fase [°]')
    xlabel('\omega [rad/s]')
    grid on
    linkaxes([ax11,ax12],'x')


    % Resposta a rampa
    y_ramp = step(closedLoopTransferFunction/s, tRamp);  % Dividido por s
    steadyStateError = tRamp(end) - y_ramp(end);  % Referencia: r(t) = t
    
    fig2 = figure;
    plot(tRamp, tRamp, 'k--')
    hold on
    plot(tRamp, y_ramp, 'r')
    ylabel('x [m]')
    xlabel('t [s]')
    legend('Setpoint', 'Saída')
    title(sprintf('Resposta a rampa unitária - e_{rp} = %.2f%s', steadyStateError*100, '%'))
    grid on
    

    % Reposta ao degrau
    y_step = step(closedLoopTransferFunction, tStep);
    percentageOvershoot = (max(y_step) - y_step(end))*100/y_step(end);
    peakTime = tStep(y_step == max(y_step));
    peakTime = peakTime(1);  % Apenas para ter certeza de que nao vai encontrar dois valores iguais
    
    fig3 = figure;
    yline(1, 'k--')  % Referencia: r(t) = 1
    hold on
    plot(tStep, y_step, 'r')
    ylabel('x [m]')
    xlabel('t [s]')
    legend('Setpoint', 'Saída')
    title(sprintf('Resposta ao degrau unitária - p_{ss} = %.2f%s e t_p = %.2fs', percentageOvershoot, '%', peakTime))
    grid on
end

