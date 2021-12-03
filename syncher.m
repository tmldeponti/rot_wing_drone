function [delay] = syncher(t_w,T_w,t_rc,T_rc,debug)

t_lim = [max(min(t_w),min(t_rc)) min(max(t_w),max(t_rc))];
t_q = linspace(t_lim(1),t_lim(2),10000);
[~, I_rc]= unique(t_rc,'first');
[~, I_w]= unique(t_w,'first');

Trc = interp1(t_rc(I_rc),T_rc(I_rc),t_q);
Tw  = interp1(t_w(I_w),T_w(I_w),t_q);


delay= mean(gradient(t_q))*finddelay(Tw,Trc);

if debug
    figure(2)
    clf
    plot(t_rc-delay,T_rc)
    hold on 
    plot(t_w,T_w)
    title('figure 2')
    grid on
    grid minor
    xlabel('Time [s]')
    ylabel('Thrust [N]')
    legend('RC BenchMark','Balance Wind Tunnel','Location','northwest')
end
end

