classdef kuram < handle
    %KURAM Kuramoto model
    %   Based on Strogatz SH. From Kuramoto to Crawford: 
    % exploring the onset of synchronization in populations of coupled oscillators. 
    % Phys D Nonlinear Phenom. 2000;143(1):1–20. https://doi.org/10.1016/S0167-2789(00)00094-4
    %
    % Pablo Rodríguez-Sánchez
    % Wageningen University and Research 
    % https://pabrod.github.io
    
    properties(GetAccess = public, SetAccess = private)
        qs; % Vector of phases
        ws; % Vector of initial frequencies
        
        K; % Coupling factors
        r;
    end
    
    methods(Access = public)
        
        %% Constructor
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
        
        %% Calculations
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
            
            % The effective frequency is built with the Kuramoto diff. eq.
            w = (obj.ws + obj.K.*obj.r.*sin(psi - obj.qs));
        end
        
        %% Simulation
        function update(obj, tStep)
            %UPDATE updates the state of the oscillator
            
            % Compute the increment using the Euler method
            dqs = obj.weff().*tStep;
            
            % Apply the increment
            obj.qs = obj.qs + dqs;
        end
        
        function [qs, zs, weffs] = sim(obj, ts)
            %SIM simulate dynamics and store results
            %
            %   Returns states, order parameters and effective frequencies
            %
            %   Oscillators as rows
            %   Times as columns
            
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
        
        %% Plotting
        function plot(obj)
            %PLOT Plots the current state

            xs = cos(obj.qs);
            ys = sin(obj.qs);
            
            scatter(xs, ys, 'filled');
            xlim([-1 1]);
            ylim([-1 1]);
        end
        
        function plotop(obj)
            %PLOTOP Plots the order parameter

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

