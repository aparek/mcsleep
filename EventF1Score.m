function [ Score ] = EventF1Score( a,v,t )

% function [ Score ] = EventF1Score( autDet, visDet, t )
%     Computes the F1 score using by-event analysis
%     a - the automatic detection vector of start times and duration
%     v - the visually detected spindles with duration
%     t - threshold for overlap
%     
%     Score - output structure, to see scores, type Score{2}
% Ankit Parekh, NYU Poly, July 2015. 

Score = cell(2,1);
Score{1} = {'True Positive','True Negative', 'False Positive', 'False Negative', ...
            'Recall', 'Precision', 'F1 Score', 'Specificity', ...
            'Negative Predictive Value', 'Accuracy', 'Cohens Kappa', ...
            'Matthews Correlation Coefficient'};
Score{2} = zeros(12,1);      

tp = 0;
tn = 0;

a = a(:,1);
v = v(:,1);

%No TN is counted in by event analysis

for i = 1:size(a,1)
    j = 1;
    while j < size(v,1)
        if abs(v(j) - a(i)) <= t
            tp = tp + 1;
            break
        end
        j = j+1;
    end
end


fp = numel(a) - tp;
fn = numel(v) - tp;

Score{2}(1) = tp;
Score{2}(2) = tn;
Score{2}(3) = fp;
Score{2}(4) = fn;

recall = tp/(tp + fn); 
Score{2}(5) = recall;

precision = tp/(tp + fp); 
Score{2}(6) = precision;

f1 = 2*(recall*precision)/(recall + precision);
Score{2}(7) = f1;

spc = tn/(fp + tn);
Score{2}(8) = spc;

npv = tn/(tn + fn);
Score{2}(9) = npv;

n = (tp + tn + fp + fn);
acc = (tp + tn)/n;
Score{2}(10) = acc;

pr = (((tp + fn)/n)*((tp + fp)/n)) + (1-((tp + fn)/n)) * (1-((tp + fp)/n));
kappa = (((tp+tn)/n)-pr)/(1-pr);
Score{2}(11) = kappa;

mcc = (tp*tn-fp*fn)/sqrt((tp+fn)*(tp+fp)*(tn+fp)*(tn+fn));
Score{2}(12) = mcc;


end

