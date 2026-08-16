% MATLAB Script: Amplitude Shift Keying (ASK) Schematic Diagram
clear; clc; close all;

% 1. Input Binary Data Sequence
bits = [1 0 1 1 0 1];
n = length(bits);

% 2. Simulation Parameters
samples_per_bit = 500;
fc = 4; % Carrier frequency (cycles per bit slot)
total_samples = n * samples_per_bit;
t = linspace(0, n, total_samples);

% 3. Generate Signals
% Message Signal (Square Waveform)
t_msg = [];
v_msg = [];
for i = 1:n
    t_msg = [t_msg, i-1, i];
    v_msg = [v_msg, bits(i), bits(i)];
end

% Carrier Signal (Continuous Sine Wave)
carrier = sin(2 * pi * fc * t);

% ASK Modulated Signal
ask_mask = zeros(1, total_samples);
for i = 1:n
    idx = (i-1)*samples_per_bit + 1 : i*samples_per_bit;
    ask_mask(idx) = bits(i);
end
ask = ask_mask .* carrier;

% 4. Baseline Offsets for Vertical Stacking
y_msg_base = 4.8;
y_car_base = 2.8;
y_ask_base = 0.8;
amp = 0.6; % Waveform amplitude scaling

% 5. Rendering the Figure Canvas
fig = figure('Color', 'w', 'Position', [100, 100, 800, 520]);
hold on; axis off;

% Draw Dark Top Banner
rectangle('Position', [-0.9, 6.4, n + 1.8, 0.6], ...
    'FaceColor', [0.12 0.10 0.10], 'EdgeColor', 'none');
text(n/2, 6.7, 'AMPLITUDE SHIFT KEYING (ASK)', ...
    'Color', 'w', 'FontSize', 12, 'FontWeight', 'bold', ...
    'HorizontalAlignment', 'center', 'FontName', 'Arial');

% Vertical Olive/Grey Dashed Grid Lines
grid_color = [0.6, 0.6, 0.45];
for i = 0:n
    line([i, i], [0.1, 6.2], 'Color', grid_color, 'LineStyle', '--', 'LineWidth', 1.2);
end

% Plot Signals (Black lines)
plot(t_msg, y_msg_base + amp * v_msg, 'k', 'LineWidth', 2);      % Message
plot(t, y_car_base + amp * carrier, 'k', 'LineWidth', 1.4);       % Carrier
plot(t, y_ask_base + amp * ask, 'k', 'LineWidth', 1.4);           % ASK Modulated

% Display Bit Digits Above Message Signal
for i = 1:n
    text(i - 0.5, 6.0, num2str(bits(i)), 'FontSize', 12, ...
        'FontWeight', 'bold', 'HorizontalAlignment', 'center');
end

% Waveform Side Labels
text(-0.15, y_msg_base + 0.3, sprintf('Message\nSignal'), 'FontSize', 10, ...
    'HorizontalAlignment', 'right', 'FontWeight', 'bold');
text(-0.15, y_car_base, sprintf('Carrier\nSignal'), 'FontSize', 10, ...
    'HorizontalAlignment', 'right', 'FontWeight', 'bold');
text(-0.15, y_ask_base, sprintf('Modulated\nSignal'), 'FontSize', 10, ...
    'HorizontalAlignment', 'right', 'FontWeight', 'bold');

% Canvas Boundaries
xlim([-0.9, n + 0.5]);
ylim([-0.2, 7.2]);
hold off;
