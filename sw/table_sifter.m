function [output] = table_sifter(table,holes)
%table_sifter select only the relevant data from the table
%   table = input data table
%   holes = indicators of how to filter the data. "-1" no filter.
%   order ["ID","Item","Windspeed[m/s]","Airspeed[m/s]","Skew[deg]","Skew_sp[deg]","Mot_Status","Excitation","Mx[Nm]","My[Nm]","Mz[Nm]","Fx[N]","Fy[N]","Fz[N]","Mot_F[pwm]","Mot_R[pwm]","Mot_B[pwm]","Mot_L[pwm]","Ail_L[pwm]","Ail_R[pwm]","Elev[pwm]","Rud[pwm]","Pitch[deg]"];    
%   [-1,"Item","Windspeed[m/s]",-1,-1,"Skew_sp[deg]","Mot_Status","Excitation",-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,"Pitch[deg]"];    

n = max(size(holes));
sifter = ones(size(table,1),1);
for i=1:n
    if holes(i)>=0
        sifter = sifter.*(table.(i)==holes(i));
    end
end
output = table(sifter==1,:);
end