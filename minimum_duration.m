function [DD,begins,ends] = minimum_duration(DD,begins,ends,min_dur,fs)
% MINIMUM_DURATION - checks the sample duration of the spindles.
% Input is a vector containing ones in the interval where the spindle is
% and indexs describing the start and end of the spindle. The last two
% inputs are the minimum duration given in seconds and the sampling
% frequency given in Hz.
% Output is a vector containing ones in the interval where the spindle with
% duration longer than or equal to the minimum duration is and indexs
% describing the start and end of the spindle.
% 
% Source code from: 
% http://www.nature.com/nmeth/journal/v11/n4/abs/nmeth.2855.html
% Please cite accordingly. 

duration_samples = ends-begins+1;
for k = 1:length(begins)
    if duration_samples(k) < min_dur*fs
        DD(begins(k):ends(k)) = 0;
        begins(k) = 0;
        ends(k) = 0;
    end
end
begins = begins(begins~=0);
ends = ends(ends~=0);
end

