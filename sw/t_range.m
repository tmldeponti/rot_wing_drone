function [output] = t_range(time_array,lim)
%return time range based on limits
idx_1 = t_finder(time_array,lim(1));
idx_2 = t_finder(time_array,lim(2));
output = idx_1:idx_2;
end