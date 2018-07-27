classdef kuram < handle
    %KURAM Kuramoto model
    %   Detailed explanation goes here
    
    properties(GetAccess = public, SetAccess = private)
        qs;
        ws;
        
        K;
        r;
    end
    
    methods(Access = public)
        function obj = kuram(qsIn, wsIn, Kin, rin)
            %KURAM Construct an instance of this class
            %   Detailed explanation goes here
            obj.qs = qsIn;
            obj.ws = wsIn;
            obj.K = Kin;
            obj.r = rin;
        end
        
        function n = N(obj)
            %N Returns the number of oscillators
            n = numel(obj.qs(:));
        end
        
        function [z, len, psi] = orderparameter(obj)
            %ORDERPARAMETER returns the order parameter
            z = 1/obj.N().*sum(exp(1i.*obj.qs));
            len = abs(z);
            psi = angle(z);
        end
        
        function update(obj, tStep)
            %UPDATE updates the state of the oscillator
            [~, ~, psi] = obj.orderparameter();
            dqs = (obj.ws + obj.K.*obj.r.*sin(psi - obj.qs)).*tStep;
            
            qs_old = obj.qs;
            qs_new = qs_old + dqs;
            
            obj.qs = qs_new;
        end
        
        function plot(obj)
            %PLOT Plots the current state
            %   Detailed explanation goes here
            xs = cos(obj.qs);
            ys = sin(obj.qs);
            
            scatter(xs, ys, 'filled');
            xlim([-1 1]);
            ylim([-1 1]);
            axis equal;
        end
        
        function plotfreq(obj)
            %PLOTFREQ plots the frequencies distribution
            hist(obj.ws);
        end
    end
end

