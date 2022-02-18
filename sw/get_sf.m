function [output] = get_sf(time)
%
output = round(1/mean(diff(time)),0);%1/(time(10)-time(9));
end

