function [fig1, fig2, fig3] = plotSystemResponse(open_loop_transfer_function, w_bode, t_ramp, t_step)
    closed_loop_transfer_function = feedback(open_loop_transfer_function, 1);
    
    % Reaproveitando a implementacao da outra funcao
    [peak_time, overshoot, steady_state_error, y_step, y_ramp] = getMetrics(open_loop_transfer_function, t_ramp, t_step);
    
    % Diagrama de bode
    [mag, phase] = bode(closed_loop_transfer_function, w_bode);
    mag = squeeze(mag2db(mag));
    phase = squeeze(phase);

    fig1 = figure;
    ax11 = subplot(2, 1, 1);
    semilogx(w_bode, mag)
    ylabel('Magnitude [dB]')
    xlabel('\omega [rad/s]')
    grid on
    title('Diagrama de Bode')
    ax12 = subplot(2, 1, 2);
    semilogx(w_bode, phase)
    ylabel('Fase [°]')
    xlabel('\omega [rad/s]')
    grid on
    linkaxes([ax11,ax12],'x')


    % Resposta a rampa    
    fig2 = figure;
    plot(t_ramp, t_ramp, 'k--')
    hold on
    plot(t_ramp, y_ramp, 'r')
    ylabel('x [m]')
    xlabel('t [s]')
    legend('Setpoint', 'Saída')
    title(sprintf('Resposta a rampa unitária - e_{rp} = %.2f%s', steady_state_error*100, '%'))
    grid on
    

    % Reposta ao degrau
    fig3 = figure;
    yline(1, 'k--')  % Referencia: r(t) = 1
    hold on
    plot(t_step, y_step, 'r')
    ylabel('x [m]')
    xlabel('t [s]')
    legend('Setpoint', 'Saída')
    title(sprintf('Resposta ao degrau unitária - p_{ss} = %.2f%s e t_p = %.2fs', overshoot*100, '%', peak_time))
    grid on
end

