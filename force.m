function [output] = force(axis,nominal,angle)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
output = round(nominal.*cos(angle)+cross(axis,nominal).*sin(angle)+axis.*dot(axis,nominal)*(1-cos(angle)),3);
end

