classdef PhaseShiftController
    
    properties (Access = private)
        sys
        K
        alpha
        T
        transferFunction
    end
    
    methods
        function obj = PhaseShiftController(sys, errorConstant, phaseMargin, tolerance)
            obj = obj.setSys(sys);
            obj = obj.setK(errorConstant);
            obj = obj.setAlpha(phaseMargin + tolerance);
            obj = obj.setT();
            obj = obj.setTransferFunction();
        end
        
        % Getters
        function K = getK(obj)
            K = obj.K;
        end

        function alpha = getAlpha(obj)
            alpha = obj.alpha;
        end

        function T = getT(obj)
            T = obj.T;
        end

        function transferFunction = getTransferFunction(obj)
            transferFunction = obj.transferFunction;
        end
        
    end

    methods (Access = private)
        % Auxiliares
        function sysType = getSysType(obj)
            sysType = sum(pole(obj.sys) == 0);
        end

        function wcg = getWcg(obj)
            [sysMag, ~, w, ~, ~] = bode(obj.sys*obj.K);
            sysMag = squeeze(mag2db(sysMag));
            alphaLoss = -20*log10(1/sqrt(obj.alpha));
            absDelta = abs((sysMag - alphaLoss));

            wcg = w(absDelta == min(absDelta));
        end
        
        % Setters
        function obj = setSys(obj, sys)
            obj.sys = sys;  % So para manter o padrao
        end
        
        function obj = setK(obj, newErrorConstant)
            s = tf('s');

            sysType = obj.getSysType();
            errorConstant = evalfr(obj.sys*(s^sysType), eps);
            
            obj.K = newErrorConstant/errorConstant;
        end

        function obj = setAlpha(obj, newPhaseMargin)
            [~, phaseMargin] = margin(obj.sys*obj.K);
            phi = deg2rad(newPhaseMargin - phaseMargin);
            
            obj.alpha = (1 - sin(phi))/(1 + sin(phi));
        end

        function obj = setT(obj)
            wcg = obj.getWcg();
            
            obj.T = 1/(wcg*sqrt(obj.alpha));
        end

        function obj = setTransferFunction(obj)
            s = tf('s');

            obj.transferFunction = obj.K*(1 + obj.T*s)/(1 + obj.alpha*obj.T*s);
        end
    end
end

