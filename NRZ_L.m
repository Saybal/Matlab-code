% MATLAB Script: NRZ-L (Non-Return-to-Zero Level) Line Encoding Diagram
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

% 3. NRZ-L Line Encoding Logic
% Rule:
% - Bit '1': High positive voltage level (+1V)
% - Bit '0': Low negative voltage level (-1V)

t_nrzl = [];
v_nrzl = [];

for i = 1:n
    if bits(i) == 1
        level = 1;  % Positive voltage for '1'
    else
        level = -1; % Negative voltage for '0'
    end
    
    t_nrzl = [t_nrzl, i-1, i];
    v_nrzl = [v_nrzl, level, level];
end

% 4. Baseline Offsets for Vertical Stacking
y_msg_base  = 3.8;
y_nrzl_base = 1.2;
amp = 0.6; % Waveform scaling factor

% 5. Rendering Figure Canvas
fig = figure('Color', 'w', 'Position', [100, 100, 800, 520]);
hold on; axis off;

% Draw Dark Top Banner
rectangle('Position', [-0.9, 5.4, n + 1.8, 0.6], ...
    'FaceColor', [0.12 0.10 0.10], 'EdgeColor', 'none');
text(n/2, 5.7, 'NRZ-L (NON-RETURN-TO-ZERO LEVEL) ENCODING', ...
    'Color', 'w', 'FontSize', 12, 'FontWeight', 'bold', ...
    'HorizontalAlignment', 'center', 'FontName', 'Arial');

% Vertical Olive/Grey Dashed Grid Lines (Bit Boundaries)
grid_color = [0.6, 0.6, 0.45];
for i = 0:n
    line([i, i], [0.1, 5.2], 'Color', grid_color, 'LineStyle', '--', 'LineWidth', 1.2);
end

% Zero Voltage Reference Line for NRZ-L
line([0, n], [y_nrzl_base, y_nrzl_base], 'Color', [0.8 0.8 0.8], 'LineStyle', ':', 'LineWidth', 1);

% Plot Signals (Black lines)
plot(t_msg, y_msg_base + amp * v_msg, 'k', 'LineWidth', 2);         % Binary Message
plot(t_nrzl, y_nrzl_base + amp * v_nrzl, 'k', 'LineWidth', 1.8);    % NRZ-L Signal

% Display Bit Digits Above Message Signal
for i = 1:n
    text(i - 0.5, 5.0, num2str(bits(i)), 'FontSize', 12, ...
        'FontWeight', 'bold', 'HorizontalAlignment', 'center');
end

% Side Axis Labels
text(-0.15, y_msg_base + 0.3, sprintf('Message\nSignal'), 'FontSize', 10, ...
    'HorizontalAlignment', 'right', 'FontWeight', 'bold');
text(-0.15, y_nrzl_base + 0.2, sprintf('NRZ-L\nSignal'), 'FontSize', 10, ...
    'HorizontalAlignment', 'right', 'FontWeight', 'bold');

% Canvas Boundaries
xlim([-0.9, n + 0.5]);
ylim([-0.2, 6.2]);
hold off;
