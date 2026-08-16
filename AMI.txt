% Exact MATLAB Code for AMI and Pseudoternary Line Encoding
clear; clc; close all;

% 1. Input Bit Sequence
bits = [0 1 0 0 1 0];
n = length(bits);

% 2. Signal Level Logic
ami_levels = zeros(1, n);
pseudo_levels = zeros(1, n);

ami_sign = 1;      % AMI starts positive for first '1'
pseudo_sign = 1;   % Pseudoternary starts positive for first '0'

for i = 1:n
    % AMI: '1' alternates (+1, -1), '0' stays 0
    if bits(i) == 1
        ami_levels(i) = ami_sign;
        ami_sign = -ami_sign;
    else
        ami_levels(i) = 0;
    end
    
    % Pseudoternary: '0' alternates (+1, -1), '1' stays 0
    if bits(i) == 0
        pseudo_levels(i) = pseudo_sign;
        pseudo_sign = -pseudo_sign;
    else
        pseudo_levels(i) = 0;
    end
end

% 3. Construct Waveform Points (With Leading Left-Extension Before Axis)
t = [];
ami_sig = [];
pseudo_sig = [];

% Pre-padding extension to the left of the vertical axis (t from -0.4 to 0)
t = [t, -0.4, 0];
ami_sig = [ami_sig, 0, 0];
pseudo_sig = [pseudo_sig, pseudo_levels(1), pseudo_levels(1)];

% Step waveform generation for bit slots
for i = 1:n
    t = [t, i-1, i];
    ami_sig = [ami_sig, ami_levels(i), ami_levels(i)];
    pseudo_sig = [pseudo_sig, pseudo_levels(i), pseudo_levels(i)];
end

% Baseline offsets for vertical stacking
y_ami_base = 3.5;
y_pseudo_base = 1.0;

% 4. Figure Rendering
figure('Color', 'w', 'Position', [100, 100, 750, 480]);
hold on; axis off;

pink_color = [0.93, 0.00, 0.45];

% Draw Vertical Dashed Lines (Bit Boundaries)
for i = 1:n
    line([i, i], [-0.2, 4.7], 'Color', [0.2 0.2 0.2], 'LineStyle', '--', 'LineWidth', 1);
end

% Plot Waveforms
plot(t, y_ami_base + ami_sig, 'Color', pink_color, 'LineWidth', 2.5);
plot(t, y_pseudo_base + pseudo_sig, 'Color', pink_color, 'LineWidth', 2.5);

% Draw Axis Arrows
quiver(-0.5, y_ami_base, n + 1.1, 0, 0, 'k', 'LineWidth', 1.2, 'MaxHeadSize', 0.18);
quiver(-0.5, y_pseudo_base, n + 1.1, 0, 0, 'k', 'LineWidth', 1.2, 'MaxHeadSize', 0.18);
quiver(0, 0.2, 0, 4.6, 0, 'k', 'LineWidth', 1.2, 'MaxHeadSize', 0.18);

% Titles & Labels
text(3.3, 5.1, 'Alternate Inversion: when gets 1', 'FontSize', 12, 'HorizontalAlignment', 'center');
text(3.3, -0.6, 'Alternate Inversion: when gets 0', 'FontSize', 12, 'HorizontalAlignment', 'center');

% Display Bit Digits
for i = 1:n
    text(i - 0.5, 4.5, num2str(bits(i)), 'Color', pink_color, 'FontSize', 12, ...
        'FontWeight', 'bold', 'HorizontalAlignment', 'center');
end

% Axis Text
text(0, 5.1, 'Amplitude', 'FontSize', 11, 'HorizontalAlignment', 'center');
text(-0.6, y_ami_base, 'AMI', 'FontSize', 11, 'HorizontalAlignment', 'right');
text(-0.6, y_pseudo_base, 'Pseudoternary', 'FontSize', 11, 'HorizontalAlignment', 'right');
text(n + 0.6, y_ami_base - 0.35, 'Time', 'FontSize', 11, 'HorizontalAlignment', 'center');
text(n + 0.6, y_pseudo_base - 0.35, 'Time', 'FontSize', 11, 'HorizontalAlignment', 'center');

xlim([-1, n + 1]);
ylim([-1, 5.8]);
hold off;
