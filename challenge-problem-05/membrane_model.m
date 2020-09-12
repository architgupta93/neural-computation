classdef membrane_model < handle
    % Class definition for membrane potential.

    % Model parameters defined as properties
    properties (Access = protected)
        G_leak = 5e-9;  % Total leakage conductance
        C = 100e-12;    % Membrane capacitance
        dG_Na = 0;      % Change in Na channel conductance 
        dG_K  = 0;      % Change in K channel conductance
        dG_Cl = 0;      % Change in Cl channel conductance
        V_Na  = 0.055;      % Na reversal potential
        V_K   = -0.077;     % K reversal potential
        V_Cl  = -0.065;     % Cl reversal potential
        V_r   = -0.07;      % Membrane's resting potential
        Vm    = -0.07;      % Current membrane potential
    end

    % Class functions
    methods (Access = public)

        % Class constructor
        function mod = membrane_model(m_c, m_g_leak)
            if nargin > 1
                mod.C = m_c;
                mod.m_g_leak = m_g_leak;
            end
        end

        function set_C(model, new_C)
            model.C = new_C;
        end

        function set_G_leak(model, new_G_leak)
            model.G_leak = new_G_leak;
        end

        function set_dG_Na(model, new_dG_Na)
            model.dG_Na = new_dG_Na;
        end

        function set_dG_K(model, new_dG_K)
            model.dG_K = new_dG_K;
        end

        function set_dG_Cl(model, new_dG_Cl)
            model.dG_Cl = new_dG_Cl;
        end

        function [tau, ch_contrib] = get_channel_contrib(model)
            % Get the steady state membrane potential 
            % for the current set of parameters.
            contrib_Na = model.V_Na*model.dG_Na;
            contrib_K  = model.V_K*model.dG_K;
            contrib_Cl = model.V_Cl*model.dG_Cl;

            G_total = model.G_leak + model.dG_Na + model.dG_K + model.dG_Cl; 
            ch_contrib = (model.V_r*model.G_leak + contrib_Na + ...
                contrib_K + contrib_Cl)/G_total;
            tau = model.C/G_total;
        end

        function vm_val = get_Vm(model)
            vm_val = model.Vm;
        end

        function vm_ss = get_steady_state_vm(model)
            [~, vm_ss] = model.get_channel_contrib();
        end

        function i_contrib = get_current_input(model, t)
            i_contrib = zeros(size(t));
            i_contrib(t > 0.1) = 1e-10;
        end

        function dvdt_val = dvdt(model, t, vm)
            i_contrib = model.get_current_input(t);
            [tau, ch_contrib] = model.get_channel_contrib();
            dvdt_val = ((-vm + ch_contrib)/tau) + (i_contrib/model.C);
        end
    end
end
