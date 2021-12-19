function [idx] = t_finder(time_array,time_value)
% find index of time array where first the value is found
idx = find(time_array>=time_value,1,'first');
end