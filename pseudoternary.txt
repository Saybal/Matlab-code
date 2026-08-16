% MATLAB Script: Pseudoternary Line Encoding Schematic Diagram
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

% 3. Pseudoternary Line Encoding Logic
% Rule:
% - Bit '1': Represented by zero voltage (0V)
% - Bit '0': Represented by alternating positive (+1V) and negative (-1V) voltages

t_pseudo = [];
v_pseudo = [];
pseudo_sign = 1; % Polarity starts positive for the first binary '0'

for i = 1:n
    if bits(i) == 0
        level = pseudo_sign;
        pseudo_sign = -pseudo_sign; % Alternate polarity for the next '0'
    else
        level = 0; % Zero voltage level for binary '1'
    end
    
    t_pseudo = [t_pseudo, i-1, i];
    v_pseudo = [v_pseudo, level, level];
end

% 4. Baseline Offsets for Vertical Stacking
y_msg_base    = 3.8;
y_pseudo_base = 1.2;
amp = 0.6; % Waveform scaling factor

% 5. Rendering Figure Canvas
fig = figure('Color', 'w', 'Position', [100, 100, 800, 520]);
hold on; axis off;

% Draw Dark Top Banner
rectangle('Position', [-0.9, 5.4, n + 1.8, 0.6], ...
    'FaceColor', [0.12 0.10 0.10], 'EdgeColor', 'none');
text(n/2, 5.7, 'PSEUDOTERNARY LINE ENCODING', ...
    'Color', 'w', 'FontSize', 12, 'FontWeight', 'bold', ...
    'HorizontalAlignment', 'center', 'FontName', 'Arial');

% Vertical Olive/Grey Dashed Grid Lines (Bit Boundaries)
grid_color = [0.6, 0.6, 0.45];
for i = 0:n
    line([i, i], [0.1, 5.2], 'Color', grid_color, 'LineStyle', '--', 'LineWidth', 1.2);
end

% Zero Voltage Reference Line for Pseudoternary
line([0, n], [y_pseudo_base, y_pseudo_base], 'Color', [0.8 0.8 0.8], 'LineStyle', ':', 'LineWidth', 1);

% Plot Signals (Black lines)
plot(t_msg, y_msg_base + amp * v_msg, 'k', 'LineWidth', 2);            % Binary Message
plot(t_pseudo, y_pseudo_base + amp * v_pseudo, 'k', 'LineWidth', 1.8); % Pseudoternary Signal

% Display Bit Digits Above Message Signal
for i = 1:n
    text(i - 0.5, 5.0, num2str(bits(i)), 'FontSize', 12, ...
        'FontWeight', 'bold', 'HorizontalAlignment', 'center');
end

% Side Axis Labels
text(-0.15, y_msg_base + 0.3, sprintf('Message\nSignal'), 'FontSize', 10, ...
    'HorizontalAlignment', 'right', 'FontWeight', 'bold');
text(-0.15, y_pseudo_base + 0.2, sprintf('Pseudoternary\nSignal'), 'FontSize', 10, ...
    'HorizontalAlignment', 'right', 'FontWeight', 'bold');

% Canvas Boundaries
xlim([-0.9, n + 0.5]);
ylim([-0.2, 6.2]);
hold off;
