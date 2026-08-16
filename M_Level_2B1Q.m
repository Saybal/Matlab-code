% MATLAB Script: 2B1Q (2 Binary 1 Quaternary) Line Encoding Diagram
clear; clc; close all;

% 1. Input Binary Data Sequence (Must have an even length)
bits = [0 0 1 0 0 1 1 1 1 0 0 1];
n_bits = length(bits);
n_symbols = n_bits / 2;

% 2. Message Signal (Binary Square Waveform)
t_msg = [];
v_msg = [];
for i = 1:n_bits
    t_msg = [t_msg, i-1, i];
    v_msg = [v_msg, bits(i), bits(i)];
end

% 3. 2B1Q Encoding Logic
% Dibit Mapping Table:
%  '00' -> +1 V
%  '01' -> +3 V
%  '10' -> -1 V
%  '11' -> -3 V

v_2b1q = zeros(1, n_symbols);
dibit_str = cell(1, n_symbols);

for i = 1:n_symbols
    b1 = bits(2*i - 1);
    b2 = bits(2*i);
    dibit_str{i} = sprintf('%d%d', b1, b2);

    if b1 == 0 && b2 == 0
        v_2b1q(i) = 1;
    elseif b1 == 0 && b2 == 1
        v_2b1q(i) = 3;
    elseif b1 == 1 && b2 == 0
        v_2b1q(i) = -1;
    elseif b1 == 1 && b2 == 1
        v_2b1q(i) = -3;
    end
end

% Construct 2B1Q Step Waveform
t_2b1q = [];
sig_2b1q = [];
for i = 1:n_symbols
    t_start = (i - 1) * 2;
    t_end   = i * 2;
    t_2b1q = [t_2b1q, t_start, t_end];
    sig_2b1q = [sig_2b1q, v_2b1q(i), v_2b1q(i)];
end

% 4. Baseline Offsets for Vertical Stacking
y_msg_base  = 5.2;
y_2b1q_base = 2.2;
amp_msg  = 0.6;
amp_2b1q = 0.45; % Scaled for 4 voltage levels

% 5. Rendering Figure Canvas
fig = figure('Color', 'w', 'Position', [100, 100, 850, 550]);
hold on; axis off;

% Draw Dark Top Banner
rectangle('Position', [-1.2, 7.0, n_bits + 2.4, 0.7], ...
    'FaceColor', [0.12 0.10 0.10], 'EdgeColor', 'none');
text(n_bits/2, 7.35, '2B1Q (2 BINARY 1 QUATERNARY) LINE ENCODING', ...
    'Color', 'w', 'FontSize', 12, 'FontWeight', 'bold', ...
    'HorizontalAlignment', 'center', 'FontName', 'Arial');

% Vertical Grid Lines
grid_symbol = [0.6, 0.6, 0.45];  % Symbol boundaries (every 2 bits)
grid_bit    = [0.85, 0.85, 0.85]; % Bit boundaries

for i = 0:n_bits
    if mod(i, 2) == 0
        line([i, i], [0.2, 6.7], 'Color', grid_symbol, 'LineStyle', '--', 'LineWidth', 1.2);
    else
        line([i, i], [0.2, 6.7], 'Color', grid_bit, 'LineStyle', ':', 'LineWidth', 1.0);
    end
end

% Level Voltage Reference Lines (+3, +1, -1, -3)
levels = [3, 1, -1, -3];
for lvl = levels
    line([0, n_bits], [y_2b1q_base + amp_2b1q*lvl, y_2b1q_base + amp_2b1q*lvl], ...
        'Color', [0.9 0.9 0.9], 'LineStyle', '-', 'LineWidth', 0.5);
    text(-0.15, y_2b1q_base + amp_2b1q*lvl, sprintf('%+dV', lvl), ...
        'FontSize', 8, 'Color', [0.5 0.5 0.5], 'HorizontalAlignment', 'right');
end

% Plot Waveforms (Black lines)
plot(t_msg, y_msg_base + amp_msg * v_msg, 'k', 'LineWidth', 2);           % Binary Message
plot(t_2b1q, y_2b1q_base + amp_2b1q * sig_2b1q, 'k', 'LineWidth', 1.8);  % 2B1Q Waveform

% Display Bit Digits Above Message Signal
for i = 1:n_bits
    text(i - 0.5, 6.5, num2str(bits(i)), 'FontSize', 11, ...
        'FontWeight', 'bold', 'HorizontalAlignment', 'center');
end

% Display Dibit Labels Above 2B1Q Signal
for i = 1:n_symbols
    text(2*i - 1, 4.0, dibit_str{i}, 'FontSize', 10, 'Color', [0.2 0.2 0.8], ...
        'FontWeight', 'bold', 'HorizontalAlignment', 'center');
end

% Side Axis Labels
text(-0.8, y_msg_base + 0.3, sprintf('Binary\nMessage'), 'FontSize', 10, ...
    'HorizontalAlignment', 'right', 'FontWeight', 'bold');
text(-0.8, y_2b1q_base, sprintf('2B1Q\nQuaternary Signal'), 'FontSize', 10, ...
    'HorizontalAlignment', 'right', 'FontWeight', 'bold');

% Canvas Boundaries
xlim([-1.2, n_bits + 0.8]);
ylim([-0.2, 7.9]);
hold off;
