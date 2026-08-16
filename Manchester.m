% MATLAB Script: Manchester Line Encoding Schematic Diagram
clear; clc; close all;

% 1. Input Binary Data Sequence
bits = [1 0 1 1 0 1];
n = length(bits);

% 2. Message Signal (Square Waveform)
t_msg = [];
v_msg = [];
for i = 1:n
    t_msg = [t_msg, i-1, i];
    v_msg = [v_msg, bits(i), bits(i)];
end

% 3. Manchester Encoding Logic (IEEE 802.3 Standard)
% Rule:
% - Bit '0': High-to-Low transition (+1 in 1st half, -1 in 2nd half)
% - Bit '1': Low-to-High transition (-1 in 1st half, +1 in 2nd half)

t_man = [];
v_man = [];

for i = 1:n
    bit = bits(i);
    
    if bit == 1
        first_half  = -1;
        second_half =  1;
    else % bit == 0
        first_half  =  1;
        second_half = -1;
    end
    
    t_start = i - 1;
    t_mid   = i - 0.5;
    t_end   = i;
    
    t_man = [t_man, t_start, t_mid, t_mid, t_end];
    v_man = [v_man, first_half, first_half, second_half, second_half];
end

% 4. Baseline Offsets for Vertical Stacking
y_msg_base = 3.8;
y_man_base = 1.2;
amp = 0.6; % Waveform scaling factor

% 5. Rendering the Figure Canvas
fig = figure('Color', 'w', 'Position', [100, 100, 800, 520]);
hold on; axis off;

% Draw Dark Top Banner
rectangle('Position', [-0.9, 5.4, n + 1.8, 0.6], ...
    'FaceColor', [0.12 0.10 0.10], 'EdgeColor', 'none');
text(n/2, 5.7, 'MANCHESTER LINE ENCODING', ...
    'Color', 'w', 'FontSize', 12, 'FontWeight', 'bold', ...
    'HorizontalAlignment', 'center', 'FontName', 'Arial');

% Vertical Olive/Grey Dashed Grid Lines (Bit Boundaries)
grid_color = [0.6, 0.6, 0.45];
for i = 0:n
    line([i, i], [0.1, 5.2], 'Color', grid_color, 'LineStyle', '--', 'LineWidth', 1.2);
end

% Mid-bit Light Dashed Grid Lines (Clock Transitions)
for i = 1:n
    line([i-0.5, i-0.5], [0.1, 5.2], 'Color', [0.85 0.85 0.85], 'LineStyle', ':', 'LineWidth', 1);
end

% Plot Signals (Black lines)
plot(t_msg, y_msg_base + amp * v_msg, 'k', 'LineWidth', 2);         % Message Signal
plot(t_man, y_man_base + amp * v_man, 'k', 'LineWidth', 1.8);       % Manchester Signal

% Display Bit Digits Above Message Signal
for i = 1:n
    text(i - 0.5, 5.0, num2str(bits(i)), 'FontSize', 12, ...
        'FontWeight', 'bold', 'HorizontalAlignment', 'center');
end

% Waveform Side Labels
text(-0.15, y_msg_base + 0.3, sprintf('Message\nSignal'), 'FontSize', 10, ...
    'HorizontalAlignment', 'right', 'FontWeight', 'bold');
text(-0.15, y_man_base + 0.2, sprintf('Manchester\nSignal'), 'FontSize', 10, ...
    'HorizontalAlignment', 'right', 'FontWeight', 'bold');

% Canvas Boundaries
xlim([-0.9, n + 0.5]);
ylim([-0.2, 6.2]);
hold off;
