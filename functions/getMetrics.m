function [peak_time, overshoot, steady_state_error, y_step, y_ramp] = getMetrics(open_loop_transfer_function, t_ramp, t_step)
    s = tf('s');
    closed_loop_transfer_function = feedback(open_loop_transfer_function, 1);

    % Reposta ao degrau
    y_step = step(closed_loop_transfer_function, t_step);
    peak_time = t_step(y_step == max(y_step));
    peak_time = round(peak_time(1), 4);  % Apenas para ter certeza de que nao vai encontrar dois valores iguais
    overshoot = round((max(y_step) - y_step(end))/y_step(end), 4);

    % Resposta a rampa
    y_ramp = step(closed_loop_transfer_function/s, t_ramp);  % Dividido por s
    steady_state_error = round(t_ramp(end) - y_ramp(end), 4);  % Referencia: r(t) = t
end

