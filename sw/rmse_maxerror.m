function [rmse,me] = rmse_maxerror(x,y,p)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
yhat = polyval(p,x);
rmse = rms(y-yhat);
me   = max(abs(y-yhat));
end