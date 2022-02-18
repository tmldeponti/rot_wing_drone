function [output, sf] = diff_scaled(target, time)
%
sf = get_sf(time);
diffmult = 1/sf;
output = diff(target)/diffmult;
%output = diff(target,time);
end

