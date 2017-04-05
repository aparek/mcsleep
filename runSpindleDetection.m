%% This script provides a demo for the McSleep spindle detection method
%
% Last EDIT: 4/1/17
% Ankit Parekh
% ankit.parekh@nyu.edu
%
% To run the spindle detection on your EDF, replace the filename below
% with your EDF file. 
% The sample EDF used in this script has only 3 channels. Modify the script
% accordingly for your EDF in case of more than 3 channels. 
%% Initialize
clear; close all; clc;

%% Load EDF
filename = 'excerpt2';
[data, header] = lab_read_edf([filename,'.edf']);
fs = header.samplingrate;
disp('EDF loaded')  

%% Load one multi channel epoch
epoch = 1;
channels = [2 3 14];    %Select the channels to be used for analysis
y = data(channels,(epoch-1)*30*fs+1:epoch*30*fs)';
N = length(y);
n = 0:N-1;

% Plot the multichannel data
figure(1), clf
gap = 100;
plot(n/fs, y(:,1), n/fs, y(:,2)-gap, n/fs, y(:,3)-2*gap)
box off
xlabel('Time (s)')
ylabel('\mu V')
ylim([-3*gap gap])
xlim([1 30])
set(gca,'YTick',[])
title('Raw EEG signal')
legend('Fp1-A1', 'CZ-A1', 'O1-A1')

%% Denoise using only low rank regluarizer
H = @(x,s,k) Op_A(x,s,k);
HT = @(x,s,k) Op_AT(x,s,k);

% Set the parameters for the McSleep method and run the transient
% separation method. 
param = struct('lam1',0.6, 'lam2',6.5,'lam3',38,'K',fs,'mu', 0.5,'O',fs/2,'Nit',80); 
tic, [x,s,cost] = fusedLassoLLR_doubleADMM(y', H, HT, param); toc

% Plot the cost function history
figure(1), clf
plot(cost,'k')
title('Cost function history')
box off
xlabel('Time(s)')
%% Plot the estimated signal using only low rank regularizer
figure(1), clf
gap = 60;
plot(n/fs, x(1,:), n/fs, x(2,:)-gap, n/fs, x(3,:)-2*gap)
box off
xlabel('Time (s)')
ylabel('\mu V')
ylim([-3*gap 2*gap])
xlim([0 30])
set(gca,'YTick',[])
title('Estimated Transient Component')
legend('Fp1-A1', 'CZ-A1', 'O1-A1')


figure(2), clf
gap = 60;
plot(n/fs, s(1,:), n/fs, s(2,:)-gap, n/fs, s(3,:)-2*gap)
box off
xlabel('Time (s)')
ylabel('\mu V')
ylim([-3*gap 2*gap])
xlim([0 30])
set(gca,'YTick',[])
title('Estimated Oscillatory Component ')
legend('Fp1-A1', 'CZ-A1', 'O1-A1')


% Residual
r = y'-(x+s);
figure(3), clf
gap = 60;
plot(n/fs, r(1,:), n/fs, r(2,:)-gap, n/fs, r(3,:)-2*gap)
box off
xlabel('Time (s)')
ylabel('\mu V')
ylim([-3*gap 2*gap])
xlim([0 30])
set(gca,'YTick',[])
title('Residual')
legend('Fp1-A1', 'CZ-A1', 'O1-A1')



%% Use envelope to detect start and end of spindles
c = 0.2; % Threshold for Teager operator
[B,A] = butter(4, [11 16]/(fs/2));
sig = filtfilt(B,A,s');
X = T(mean(sig,2));
bin = [0, X > c]';

% Discard spindles less than 0.5 seconds and more than 3 seconds
bin = discardSpindles(bin,fs);
figure(3), clf
gap = 60;
plot(n/fs, y(:,1), n/fs, y(:,2)-gap, n/fs, y(:,3)-2*gap, ...
    n/fs, bin*20-3*gap);
box off
xlabel('Time (s)')
ylabel('\mu V')
ylim([-4*gap 2*gap])
xlim([0 30])
set(gca,'YTick',[])
title('Spindle detection using McSleep')
legend('Fp1-A1', 'CZ-A1', 'O1-A1', 'Detected Spindles')


