function [p] = tot_lsqr(skew,v,cmd,j,b,k,y)
%tot_lsqr this function returns the general function approximation of the
%control moment exerted by a AS accounting for all relevant variables
%  
skew = deg2rad(skew);
if k < 2
    if j ==9
        f_skew = sin(skew).^3;
    elseif j==10
        f_skew = cos(skew)-cos(skew).^3;
    elseif j==11
        f_skew = ones(size(skew));
    else
        disp('Wrong index of Moment')
        return 
    end

else
    f_skew = ones(size(skew));
end
p = [f_skew.*v.^2.*b.*cmd]\y;
end