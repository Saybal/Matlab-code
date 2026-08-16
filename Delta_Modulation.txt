% MATLAB Script: Delta Modulation (DM) Schematic Diagram
clear; clc; close all;

% 1. Simulation Parameters
fm = 1;                  % Message signal frequency (Hz)
fs = 16;                 % Sampling frequency (samples per cycle)
t_max = 1.0;             % Total duration (seconds)
delta = 0.35;            % Step size (Delta)

num_samples = round(fs * t_max);
dt = 1 / fs;
t_sample = (0:num_samples-1) * dt;

% Continuous high-resolution time vector for smooth analog signal
t_analog = linspace(0, t_max, 1000);
m_analog = sin(2 * pi * fm * t_analog);
m_sample = sin(2 * pi * fm * t_sample);

% 2. Delta Modulation Logic
bits = zeros(1, num_samples);
u_sample = zeros(1, num_samples);
u_prev = 0;

for i = 1:num_samples
    if m_sample(i) >= u_prev
        bits(i) = 1;
        u_prev = u_prev + delta;
    else
        bits(i) = 0;
        u_prev = u_prev - delta;
    end
    u_sample(i) = u_prev;
end

% 3. Construct Step Waveforms for Plotting
% Staircase approximation u(t)
t_stair = [0];
u_stair = [0];
for i = 1:num_samples
    t_stair = [t_stair, t_sample(i), t_sample(i)];
    if i == 1
        u_stair = [u_stair, 0, u_sample(i)];
    else
        u_stair = [u_stair, u_sample(i-1), u_sample(i)];
    end
end

% DM Pulse/Digital Output Waveform
t_pulse = [];
v_pulse = [];
for i = 1:num_samples
    t_start = (i-1) * dt;
    t_end = i * dt;
    t_pulse = [t_pulse, t_start, t_end];
    v_pulse = [v_pulse, bits(i), bits(i)];
end

% 4. Baseline Offsets for Vertical Stacking
y_stair_base = 3.6;
y_dm_base = 0.8;
amp = 0.7; % Waveform scaling factor

% 5. Figure Canvas Setup
fig = figure('Color', 'w', 'Position', [100, 100, 850, 540]);
hold on; axis off;

% Draw Dark Top Banner
rectangle('Position', [-0.15 * t_max, 6.2, 1.3 * t_max, 0.6], ...
    'FaceColor', [0.12 0.10 0.10], 'EdgeColor', 'none');
text(t_max / 2, 6.5, 'DELTA MODULATION (DM)', ...
    'Color', 'w', 'FontSize', 12, 'FontWeight', 'bold', ...
    'HorizontalAlignment', 'center', 'FontName', 'Arial');

% Vertical Dashed Grid Lines (Sampling Instants)
grid_color = [0.65, 0.65, 0.50];
for i = 0:num_samples
    t_line = i * dt;
    line([t_line, t_line], [0.1, 5.9], 'Color', grid_color, 'LineStyle', '--', 'LineWidth', 1);
end

% Plot Signals
% Smooth Analog Input Signal (Blue)
plot(t_analog, y_stair_base + amp * m_analog, 'Color', [0 0.447 0.741], 'LineWidth', 2);

% Staircase Approximation u(t) (Red/Magenta Step Line)
plot(t_stair, y_stair_base + amp * u_stair, 'Color', [0.85 0.1 0.1], 'LineWidth', 1.8);

% DM Digital Output Sequence (Black Square Pulse)
plot(t_pulse, y_dm_base + amp * v_pulse, 'k', 'LineWidth', 1.6);

% Display Bit Digits Above Sampling Intervals
for i = 1:num_samples
    text((i - 0.5) * dt, 5.8, num2str(bits(i)), 'FontSize', 11, ...
        'FontWeight', 'bold', 'HorizontalAlignment', 'center');
end

% Signal Side Labels
text(-0.02, y_stair_base + 0.3, sprintf('Analog Signal m(t)\n& Staircase u(t)'), ...
    'FontSize', 10, 'HorizontalAlignment', 'right', 'FontWeight', 'bold');
text(-0.02, y_dm_base + 0.3, sprintf('DM Output\nPulse Train'), ...
    'FontSize', 10, 'HorizontalAlignment', 'right', 'FontWeight', 'bold');

% Canvas Boundaries
xlim([-0.18 * t_max, 1.12 * t_max]);
ylim([-0.2, 7.0]);
hold off;
