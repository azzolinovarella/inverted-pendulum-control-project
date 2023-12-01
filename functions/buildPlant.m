function P = buildPlant()
    s = tf('s');
    % Parametros
    Rm = 2.6;      % [Rm] = ohm
    Jm = 3.9E-7;   % [Jm] = kg m^2
    Kt = 7.68E-3;  % [Kt] = Nm/A
    nm = 1;        % [nm] = 1 (adimensional
    Km = 7.68E-3;  % [Km] = V/(rad/s)
    Kg = 3.71;     % [Kg] = 1 (adimensional
    ng = 1;        % [ng] = 1 (adimensional
    Mc = 0.94;     % [Mc] = kg
    rmp = 0.0063;  % [rmp] = m
    Beq = 5.4;     % [Beq] = N/(m(rad/s))
    g = 9.81;      % [g] = m/s^2

    P = ng*nm*Kg*Kt/(s^2*(Rm*rmp*Mc + Rm*nm*Kg^2*Jm/rmp) + s*(Rm*rmp*Beq + ng*Kg^2*Kt*Km/rmp));
end