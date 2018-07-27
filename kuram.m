classdef kuram < handle
    %KURAM Kuramoto model
    %   Detailed explanation goes here
    
    properties(GetAccess = public, SetAccess = private)
        qs; % Vector of phases
        ws; % Vector of frequencies
        
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
            z = 1/obj.N().*sum(exp(1i.*obj.qs));
            
            % The length and phase are relevant individually
            len = abs(z);
            psi = angle(z);
        end
        
        function update(obj, tStep)
            %UPDATE updates the state of the oscillator
            
            % The coupling happens via the order parameter
            [~, ~, psi] = obj.orderparameter();
            
            % Compute the increment using the Euler method
            dqs = (obj.ws + obj.K.*obj.r.*sin(psi - obj.qs)).*tStep;
            
            % Apply the increment
            obj.qs = obj.qs + dqs;
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
        
        function plotfreq(obj)
            %PLOTFREQ plots the frequencies distribution
            hist(obj.ws);
        end
    end
end

