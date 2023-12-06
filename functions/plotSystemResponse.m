function [fig1, fig2, fig3, fig4] = plotSystemResponse(open_loop_transfer_function, w_bode, t_ramp, t_step)    
    % Reaproveitando a implementacao da outra funcao
    [peak_time, overshoot, steady_state_error, y_step, y_ramp] = getMetrics(open_loop_transfer_function, t_ramp, t_step);

    % Diagrama de bode em malha aberta
    % [mag, phase] = bode(closed_loop_transfer_function, w_bode);  % Devemos pegar em malha aberta ou fechada?
    [mag_ol, phase_ol] = bode(open_loop_transfer_function, w_bode);
    mag_ol = squeeze(mag2db(mag_ol));
    phase_ol = squeeze(phase_ol);
    [~, phase_margin, ~, wcg] = margin(open_loop_transfer_function);
    fig1 = figure;
    ax11 = subplot(2, 1, 1);
    semilogx(w_bode, mag_ol)
    ylabel('Magnitude [dB]')
    xlabel('\omega [rad/s]')
    grid on
    title(sprintf('Diagrama de Bode de malha aberta - MF = %.2f ° (em %.2f rad/s)', phase_margin, wcg))
    ax12 = subplot(2, 1, 2);
    semilogx(w_bode, phase_ol)
    ylabel('Fase [°]')
    xlabel('\omega [rad/s]')
    grid on
    linkaxes([ax11,ax12],'x')

    % Diagrama de bode em malha fechada
    closed_loop_transfer_function = feedback(open_loop_transfer_function, 1);
    [mag_cl, phase_cl] = bode(closed_loop_transfer_function, w_bode);  % Devemos pegar em malha aberta ou fechada?
    mag_cl = squeeze(mag2db(mag_cl));
    BW = bandwidth(closed_loop_transfer_function);
    phase_cl = squeeze(phase_cl);
    fig2 = figure;
    ax11 = subplot(2, 1, 1);
    semilogx(w_bode, mag_cl)
    ylabel('Magnitude [dB]')
    xlabel('\omega [rad/s]')
    grid on
    title(sprintf('Diagrama de Bode de malha fechada - BW = %.2f rad/s', BW))
    ax12 = subplot(2, 1, 2);
    semilogx(w_bode, phase_cl)
    ylabel('Fase [°]')
    xlabel('\omega [rad/s]')
    grid on
    linkaxes([ax11,ax12],'x')

    % Resposta a rampa    
    fig3 = figure;
    plot(t_ramp, y_ramp, 'r')
    hold on
    plot(t_ramp, t_ramp, 'k--')
    ylabel('x [m]')
    xlabel('t [s]')
    legend('Saída', 'Setpoint')
    title(sprintf('Resposta a rampa unitária - e_{rp} = %.2f%s', steady_state_error*100, '%'))
    grid on
    
    % Reposta ao degrau
    fig4 = figure;
    plot(t_step, y_step, 'r')
    hold on
    plot([t_step(1) t_step(end)], [1, 1], 'k--')  % Referencia: r(t) = 1
    ylabel('x [m]')
    xlabel('t [s]')
    legend('Saída', 'Setpoint')
    if round(overshoot, 4) == 0  % Indica que nao houve overshoot (ou muito baixo/desconsideravel)
        title('Resposta ao degrau unitário - p_{ss} = N/A e t_p = N/A')
    else
        title(sprintf('Resposta ao degrau unitário - p_{ss} = %.2f%s e t_p = %.2fs', overshoot*100, '%', peak_time))
    end
    grid on
end

