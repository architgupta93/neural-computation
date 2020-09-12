%% Dynamics of membrane equation

% 1. Setup the membrane model for simulation
%    Note that the current source has been built into the model.
% Model parameters
mod = membrane_model();

% Set up an ODE solver to solve the differential equation
[t_pts, y_vals] = ode15s(@mod.dvdt, [0:0.001:0.5], [-0.07]);

% Get the input current for the ode time-points
input_current = mod.get_current_input(t_pts);

% Change the synaptic input and anlyze the resting membrane potential
dG_Na = [0:0.1:50]*1e-9;
dG_K = [0:0.1:50]*1e-9;
n_Na_vals = length(dG_Na);
n_K_vals  = length(dG_K);

vm_vals_Na = zeros(n_Na_vals,1);
for v_idx = 1:n_Na_vals
    mod.set_dG_Na(dG_Na(v_idx))
    vm_vals_Na(v_idx) = mod.get_steady_state_vm();
end
mod.set_dG_Na(0);

vm_vals_K = zeros(n_K_vals,1);
for v_idx = 1:n_K_vals
    mod.set_dG_K(dG_K(v_idx));
    vm_vals_K(v_idx) = mod.get_steady_state_vm();
end
mod.set_dG_K(0);

figure();
plot(1e9*dG_Na, 1e3*vm_vals_Na, 'Marker', '.', 'LineWidth', 2.4);
hold on;
plot(1e9*dG_K, 1e3*vm_vals_K, 'Marker', '.', 'LineWidth', 2.4);
xlabel('\Delta{G} (nS)');
ylabel('V_{m} (mV)');
set(gca, 'FontSize', 16);
legend('Na', 'K', 'location', 'best');

% Analyzing chloride channel contribution. Set the Chloride channel
% conductance and measure the output corresponding to this
no_cl_vm = mod.get_steady_state_vm();
mod.set_dG_Cl(10e-9);
cl_only_vm = mod.get_steady_state_vm();

vm_vals_Na__with_Cl = zeros(n_Na_vals,1);
for v_idx = 1:n_Na_vals
    mod.set_dG_Na(dG_Na(v_idx))
    vm_vals_Na__with_Cl(v_idx) = mod.get_steady_state_vm();
end
mod.set_dG_Na(0);

superposition_vm = cl_only_vm + vm_vals_Na - no_cl_vm;
figure();
plot(1e9*dG_Na, 1e3*vm_vals_Na__with_Cl, 'Marker', '.', 'LineWidth', 2.4);
hold on;
l_plot = plot(1e9*dG_Na, 1e3*superposition_vm, 'LineStyle', ...
    '--', 'LineWidth', 2.4);
% Make the line a little transparent
original_color = l_plot.Color;
% l_plot.Color = [original_color(:), 0.5];
xlabel('\Delta{G_{Na}} (nS)');
ylabel('V_{m} (mV)');
set(gca, 'FontSize', 16);
legend('V_{m}', 'V_{s}', 'location', 'best');
