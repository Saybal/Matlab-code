% MATLAB Script: NRZ-I (Non-Return-to-Zero Inverted) Line Encoding Diagram
clear; clc; close all;

% 1. Input Binary Data Sequence
bits = [1 0 1 1 0 1];
n = length(bits);

% 2. Message Signal (Binary Square Waveform)
t_msg = [];
v_msg = [];
for i = 1:n
    t_msg = [t_msg, i-1, i];
    v_msg = [v_msg, bits(i), bits(i)];
end

% 3. NRZ-I Line Encoding Logic
% Rule:
% - Bit '1': Invert voltage level at the beginning of the bit slot.
% - Bit '0': Maintain current voltage level (no transition).

t_nrzi = [];
v_nrzi = [];
current_level = 1; % Initial voltage state (+1V)

for i = 1:n
    if bits(i) == 1
        current_level = -current_level; % Invert level on '1'
    end
    % For bit '0', level remains unchanged
    
    t_nrzi = [t_nrzi, i-1, i];
    v_nrzi = [v_nrzi, current_level, current_level];
end

% 4. Baseline Offsets for Vertical Stacking
y_msg_base  = 3.8;
y_nrzi_base = 1.2;
amp = 0.6; % Waveform scaling factor

% 5. Rendering Figure Canvas
fig = figure('Color', 'w', 'Position', [100, 100, 800, 520]);
hold on; axis off;

% Draw Dark Top Banner
rectangle('Position', [-0.9, 5.4, n + 1.8, 0.6], ...
    'FaceColor', [0.12 0.10 0.10], 'EdgeColor', 'none');
text(n/2, 5.7, 'NRZ-I (NON-RETURN-TO-ZERO INVERTED) ENCODING', ...
    'Color', 'w', 'FontSize', 12, 'FontWeight', 'bold', ...
    'HorizontalAlignment', 'center', 'FontName', 'Arial');

% Vertical Olive/Grey Dashed Grid Lines (Bit Boundaries)
grid_color = [0.6, 0.6, 0.45];
for i = 0:n
    line([i, i], [0.1, 5.2], 'Color', grid_color, 'LineStyle', '--', 'LineWidth', 1.2);
end

% Zero Voltage Reference Line for NRZ-I
line([0, n], [y_nrzi_base, y_nrzi_base], 'Color', [0.8 0.8 0.8], 'LineStyle', ':', 'LineWidth', 1);

% Plot Signals (Black lines)
plot(t_msg, y_msg_base + amp * v_msg, 'k', 'LineWidth', 2);         % Binary Message
plot(t_nrzi, y_nrzi_base + amp * v_nrzi, 'k', 'LineWidth', 1.8);    % NRZ-I Signal

% Display Bit Digits Above Message Signal
for i = 1:n
    text(i - 0.5, 5.0, num2str(bits(i)), 'FontSize', 12, ...
        'FontWeight', 'bold', 'HorizontalAlignment', 'center');
end

% Side Axis Labels
text(-0.15, y_msg_base + 0.3, sprintf('Message\nSignal'), 'FontSize', 10, ...
    'HorizontalAlignment', 'right', 'FontWeight', 'bold');
text(-0.15, y_nrzi_base + 0.2, sprintf('NRZ-I\nSignal'), 'FontSize', 10, ...
    'HorizontalAlignment', 'right', 'FontWeight', 'bold');

% Canvas Boundaries
xlim([-0.9, n + 0.5]);
ylim([-0.2, 6.2]);
hold off;
