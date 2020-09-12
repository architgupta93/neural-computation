function current_input = current_source(total_time, on_time, off_time, t_step)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function current_input = current_source()
% Author: Archit Gupta
% Date: September 08, 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A simple current source model that generates an input from the given
% parameters. These parameters are inputs to the system:
%
% INPUTS:
%   - total_time: Total time duration for which the input is needed.
%   - on_time: Time at which the current source turns on.
%   - off_time: Time at which the current source turns off.
%   - t_step: Temporal resolution of the source.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    t_pts = 0:t_step:total_time;
    n_tpts = length(t_pts);
    on_time_idx = round(on_time/t_step);
    off_time_idx = round(off_time/t_step);

    % Make sure that the on and off time are less than the total time.
    assert(on_time_idx <= n_tpts);
    assert(off_time_idx <= n_tpts);

    % Generate the current input based on these values.
    current_input = zeros(n_tpts, 1);
    current_input(on_time_idx:off_time_idx) = 1;
end
