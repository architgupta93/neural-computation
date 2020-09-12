%% Dynamics of membrane equation

% 1. Setup the membrane model for simulation
%    Note that the current source has been built into the model.
% Model parameters
mod = membrane_model();

% Set up an ODE solver to solve the differential equation
[t_pts, y_vals] = ode15s(@mod.dvdt, [0:0.001:0.5], [-0.07]);

% Get the input current for the ode time-points
input_current = mod.get_current_input(t_pts);

%% Plots
% First plot the current input
figure();
plot(1000 * t_pts, 1000 * y_vals, 'LineWidth', 2.4);
set(gca, 'FontSize', 16);
xlabel('Time (ms)');
ylabel('Membrane Potential (mV)');

figure();
plot(1000 * t_pts, 1e12*input_current, 'LineWidth', 2.4, 'Color', ...
    [0.5, 0.5, 0.5, 0.5]);
xlabel('Time (ms)');
ylabel('Injected Current (pA)');
set(gca, 'FontSize', 16);
ylim([0, 1.1e12 * max(input_current)]);

% Now we change the model parameters and try running the membrane dynamics again.
n_vals_to_try = 4;
C_vals = [10, 20, 100, 200] * 1e-12;
G_leak_vals = [0.5, 1, 5, 10] * 1e-9;

%% Plot results for the different capacitance values
cvar_tpts = cell(n_vals_to_try,1);
cvar_yvals = cell(n_vals_to_try,1);
figure();
hold on;
for c_idx = 1:n_vals_to_try
    % Change the model parameters
    mod.set_C(C_vals(c_idx));
    [cvar_tpts{c_idx}, cvar_yvals{c_idx}] = ode15s(@mod.dvdt, ...
        [0:0.001:0.5], [-0.07]);
    plot(cvar_tpts{c_idx}, cvar_yvals{c_idx}, 'LineWidth', 2.4);
end
set(gca, 'FontSize', 16);
xlabel('Time (ms)');
ylabel('Membrane Potential (mV)');
legend('10pF', '20pF', '100pF', '200pF', 'location', 'best');


%% Plot results for the different leakage impedance values
gvar_tpts = cell(n_vals_to_try,1);
gvar_yvals = cell(n_vals_to_try,1);
figure();
hold on;
for g_idx = 1:n_vals_to_try
    mod.set_G_leak(G_leak_vals(g_idx));
    [gvar_tpts{c_idx}, gvar_yvals{c_idx}] = ode15s(@mod.dvdt, ...
        [0:0.001:0.5], [-0.07]);
    plot(gvar_tpts{c_idx}, gvar_yvals{c_idx}, 'LineWidth', 2.4);
end
set(gca, 'FontSize', 16);
xlabel('Time (ms)');
ylabel('Membrane Potential (mV)');
legend('0.5nS', '1nS', '5nS', '10nS', 'location', 'best');

%% Change C and G in a way such that tau is preserved
cgvar_tpts = cell(n_vals_to_try,1);
cgvar_yvals = cell(n_vals_to_try,1);
figure();
hold on;
for g_idx = 1:n_vals_to_try
    mod.set_C(C_vals(g_idx));
    mod.set_G_leak(G_leak_vals(g_idx));
    [cgvar_tpts{c_idx}, cgvar_yvals{c_idx}] = ode15s(@mod.dvdt, ...
        [0:0.001:0.5], [-0.07]);
    plot(cgvar_tpts{c_idx}, cgvar_yvals{c_idx}, 'LineWidth', 2.4);
end
set(gca, 'FontSize', 16);
xlabel('Time (ms)');
ylabel('Membrane Potential (mV)');
legend('0.5nS', '1nS', '5nS', '10nS', 'location', 'best');
