classdef kuram < handle
    %KURAM Kuramoto model
    %   Detailed explanation goes here
    
    properties(GetAccess = public, SetAccess = private)
        qs; % Vector of phases
        ws; % Vector of initial frequencies
        
        K; % Coupling factors
        r;
    end
    
    methods(Access = public)
        function obj = kuram(qsIn, wsIn, Kin, rin)
            %KURAM Construct an instance of this class
            %   Detailed explanation goes here
            
            % Assign vectors
            obj.qs = qsIn(:);
            obj.ws = wsIn(:);
            
            % Assign parameters
            obj.K = Kin;
            obj.r = rin;
        end
        
        function n = N(obj)
            %N Returns the number of oscillators
            n = numel(obj.qs(:));
        end
        
        function [z, len, psi] = orderparameter(obj)
            %ORDERPARAMETER returns the order parameter
            
            % The order parameter is a complex number
            z = mean(exp(1i.*obj.qs));
            
            % The length and phase are relevant individually
            len = abs(z);
            psi = angle(z);
        end
        
        function w = weff(obj)
            %WEFF returns the effective frequency
            
            % The coupling happens via the order parameter
            [~, ~, psi] = obj.orderparameter();
            
            % Compute the increment using the Euler method
            w = (obj.ws + obj.K.*obj.r.*sin(psi - obj.qs));
        end
        
        function update(obj, tStep)
            %UPDATE updates the state of the oscillator
            
            % Compute the increment using the Euler method
            dqs = obj.weff().*tStep;
            
            % Apply the increment
            obj.qs = obj.qs + dqs;
        end
        
        function [qs, zs, weffs] = sim(obj, ts)
            %SIM simulate dynamics
            
            % Initialize
            qs = NaN(obj.N(), numel(ts));
            zs = NaN(1, numel(ts));
            weffs = NaN(obj.N(), numel(ts));
            
            % Compute for initial state
            qs(:, 1) = obj.qs;
            zs(1) = obj.orderparameter();
            weffs(:, 1) = obj.weff();
            
            % Compute for future times
            for i = 2:numel(ts)
                % Update state
                tStep = ts(i)-ts(i-1);
                obj.update(tStep);
                
                % Extract information
                qs(:, i) = obj.qs;
                zs(i) = obj.orderparameter();
                weffs(:, i) = obj.weff();
            end
            
        end
        
        function plot(obj)
            %PLOT Plots the current state
            %   Detailed explanation goes here
            xs = cos(obj.qs);
            ys = sin(obj.qs);
            
            scatter(xs, ys, 'filled');
            xlim([-1 1]);
            ylim([-1 1]);
        end
        
        function plotop(obj)
            %PLOTOP Plots the order parameter
            %   Detailed explanation goes here
            z = obj.orderparameter();
            x = real(z);
            y = imag(z);
            
            scatter(x, y, 'filled');
            xlim([-1 1]);
            ylim([-1 1]);
        end
            
        
        function plotfreq(obj)
            %PLOTFREQ plots the frequencies distribution
            histogram(obj.ws, 'Normalization', 'probability');
            hold on;
            histogram(obj.weff(), 'Normalization','probability');
            hold off;
            ylim([0,1]);
        end
    end
end

