%% Tuning \lambda_3 and c values for best by-sample F1 score (McSleep)
%
% Repeat the procedure below for lambda_2 and lambda_1
% Or Alternatively, run the same analyses below for \lambda_i,c. i = 1,2,3.
%
% Last Edit: 6/11/2018
% Contact: Ankit Parekh (ankit.parekh@mssm.edu)
% This is part of McSleep Github repository. Please see
% github.com/aparek for citation guidelines

%% Initialize
clear; close all; clc
warning('off','all');
%% Set the parameters (see McSleep paper for details)
eegFilename = 'excerpt2';
params = struct(eegFilename,'excerpt2');
params.lam1 = 0.3;
params.lam2 = 6.5;
params.mu = 0.5;    % mu = 0.5 is preferred 
params.Nit = 85;    % Can be as low as 25, but optimal is 50
params.K = 200;     % Set it to sampling Frequenty
params.O = 100;     % Ideally set it to 50% overlapping

% Bandpass filter parameters
params.f1 = 10;     % om1 of the bandpass filter
params.f2 = 17;     % om2 of the bandpass filter
params.filtOrder = 4;   % Filter Order

%If global detection, then params.meanEnvelop = 1, 
%i.e., Spindles present in all channels
params.meanEnvelope = 1;  

% Other function parameters
params.desiredChannel = 3;
params.channels = [3 14 2];
params.plot = 0;
params.epoch = 1;
params.calculateCost = 0;   % Avoid calculating cost to speed up
params.Full = 0;
params.Entire = 0;
params.ROC = 1;
params.startEpoch = 1;
params.endEpoch = 1;

%% Load Data

[params.data, header] = lab_read_edf([eegFilename, '.edf']);
fprintf([eegFilename, '.edf loaded \n']);
params.fs = header.samplingrate;
fs = params.fs;

params.y = params.data(params.channels,...
    (params.startEpoch-1)*30*fs+1:(params.endEpoch)*fs*30);

N = fs * (params.endEpoch - params.startEpoch + 1 )*30;
visualScorer1 = load(['Visual_scoring1_',eegFilename,'.txt']);
vd1 = obtainVisualRecord(visualScorer1,fs,length(params.data));
visualScorer2 = load(['Visual_scoring2_',eegFilename,'.txt']);
vd2 = obtainVisualRecord(visualScorer2,fs,length(params.data));
%% F1 score as a function of threshold and lambda_3
Threshold = 0.1:0.1:1.3;  %Increase this range, at the expense of time for best performance
lam3 = 34:2:58;          %Increase the interval for values over a finer grid
F1_thresh = zeros(length(lam3),length(Threshold));

for i = 1:length(lam3)
    for j = 1:length(Threshold)
        params.lam3 = lam3(i);
        params.Threshold = Threshold(j);
        spindles = analyzeSpindles(params);
        Score = F1score(spindles, vd1((params.startEpoch-1)*30*fs+1:params.endEpoch*30*fs), vd2((params.startEpoch-1)*30*fs+1:params.endEpoch*30*fs));
        F1_thresh(i,j) = Score{2}(7);
    end
end

%% Plot the results

MaxF1Score = max(F1_thresh(:))

set(0,'defaultaxesfontsize',9)
figure(1), clf
surf(lam3, Threshold, F1_thresh,'FaceColor','interp')
colorbar
hold on
xlabel('\lambda_3 (In paper, \lambda_2)')
ylabel('Threshold Value (c)')
zlabel('By sample F1 Score')
grid on
box off
title('By sample F1 scores for a range of c and \lambda_3')





