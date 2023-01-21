clc
close all
clearvars
%%

% Folder in which all test data folders are located
rcbench_folder = 'C:\Users\Tomaso\Downloads\RC Testbench Data\RC Testbench Data';

% List of folders of the specific tests
test_folder = {...'T-motor F80 Pro 1900 kv - GemFan 6030 4R(green) - 4S'
              ...'T-motor F80 Pro 1900 kv - Qprop 5x4x3 (pink) - 4S'
              ...'T-motor F80 Pro 1900 kv 7x4R (orange) - 4S'
              ...'T-motor MN3515 400 kv - APC 13x10EP - 6S - Pusher'
              ...'T-motor MN3515 400 kv - APC 14x8.5EP - 6S - Pusher'
              ...'T-motor MN3515 400 kv - APC 16x10EP - 6S - Pusher'
              ...'T-motor MN3510 360 kv - APC 11x5.5 EP - 4S'
              ...'T-motor MN3510 360 kv - APC 12x6 EP - 4S'
              ...'T-motor MN3510 360 kv - APC 12x12 EP - 4S'
              ...'T-motor MN3510 360 kv - APC 11x5.5 EP - 6S'
              ...'T-motor MN3510 360 kv - APC 12x6 EP - 6S'
              ...'T-motor MN3510 360 kv - APC 12x12 EP - 6S'
              ...'T-motor MN3510 360 kv - APC 13x10 EP - 6S'
              ...'T-motor MN3510 360 kv - APC 13x10 EP - 6S - Pusher'
              ...'T-motor MN3510 360 kv - APC 14x8.5 EP - 6S'
              ...'T-motor MN3510 360 kv - APC 16x10 EP - 6S'
              'T-motor MN3510 360 kv - MF1302R - 4S'
              ...'T-motor MN3510 360 kv - MF1302R - 4S - Pusher'
              'T-motor MN3510 360 kv - MF1302R - 6S'
              ...'T-motor MN3510 360 kv - MF1302R - 6S - Pusher'
              ...'T-motor MN3510 360 kv - MF1302R - 6S - pusher - esc settings'
              ...'T-motor MN3510 360 kv - MF1302R - 6S - Pusher - ESC 48 khz'
              ...'T-motor MN3510 360 kv - MF1302R FW folding hub - 6S - Pusher'
              };

%% Get the data
for n = 1:length(test_folder)
    folder = fullfile(rcbench_folder, test_folder{n});
    data{n} = RCTestbench.getData(folder);
%     data{n} = data{n}.getFOM;
end

%% Plot
% Usage:
% data{1}.perfplt('Xvariable', 'Yvariable')
% To get available variables, use data{1}.getVariables

figure; hold on; grid on;
for n = 1:length(data)
    data{n}.perfplt('RPM', 'T')
end

%%

figure; hold on; grid on;
for n = 1:length(data)
    data{n}.perfplt('RPM', 'Eff_prop')
end

%%

figure; hold on; grid on;
for n = 1:length(data)
    data{n}.perfplt('pwm', 'Qm') 
end
