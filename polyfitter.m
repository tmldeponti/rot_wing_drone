function [p_T,p_Qm] = polyfitter(data,deg,debug)
pwm = [];
T=[];
Qm=[];
tests = fields(data{1,1}.perf);
Xname = 'pwm';
Yname = 'T';
Zname = 'Qm';
for n = 1:length(tests)
                pwm = [pwm; data{1,1}.('perf').(tests{n}).(Xname)];
                T = [T; data{1,1}.('perf').(tests{n}).(Yname)];
                Qm =[Qm; data{1,1}.('perf').(tests{n}).(Zname)];
end

p_T = polyfit(pwm,T,deg);
p_Qm = polyfit(pwm,Qm,deg);
pwm1= linspace(min(pwm),max(pwm));
T_f = polyval(p_T,pwm1);
Qm_f = polyval(p_Qm,pwm1);
if debug
    
    figure(101)
    clf
    scatter(pwm,T)
    hold on 
    plot(pwm1,T_f)
    xlabel('pwm')
    ylabel('Thrust[N]')
    legend('Test data','Polyfit')

    
    figure(102)
    clf
    scatter(pwm,Qm)
    hold on 
    plot(pwm1,Qm_f)
    xlabel('pwm')
    ylabel('Torque[Nm]')
    legend('Test data','Polyfit')

end