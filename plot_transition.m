clear all
addpath(genpath(fullfile(pwd,'sw')))
p = parselog(fullfile(fileparts(pwd),'Data\flight_data_VSQP\17_24_32\17_24_32\80_01_09__03_22_34_SD.data'));

data = p.aircrafts.data.EFF_FULL_INDI;
act = cellfun(@(S) sscanf(S, '%f,').', data.u, 'Uniform', 0);
act = cell2mat(act);

thrust_quad = sum(act(:,1:4),2);
sf = get_sf(data.timestamp);
f_filter = 0.4;%0.2;
order = 4;

f = figure(1);
clf
tiledlayout(5,1);%,'TileSpacing','compact','Padding','tight')
%tiledlayout('flow')

ax1=nexttile;
plot(data.timestamp,low_butter(thrust_quad/4,f_filter,sf,0,order))
hold on
ylim([1000,2000]);
grid on
grid minor
title("Thrust of Quad [pwm]")
% lgd=legend('Actual');
% lgd.Layout.Tile = 3;
hold off
%nexttile([1 1])

ax2=nexttile;
plot(data.timestamp,low_butter(data.theta_alt,f_filter,sf,0,order))
hold on
plot(data.timestamp,low_butter(data.theta_ref_alt,f_filter,sf,0,order))
grid on
grid minor
yline([-3,10],'--',{'min','max'})
title("Pitch [deg]")
lgd=legend('\theta','\theta_{ref}','location','northwest');
lgd.ItemTokenSize = [10,8];
% lgd.Layout.Tile = 6;
ylim([-6 18]);
xlim([230,295]);
hold off
%nexttile([1 1])

% ax3=nexttile;
% plot(data.timestamp,low_butter(data.phi_alt,f_filter,sf,0,order))
% hold on
% plot(data.timestamp,low_butter(data.phi_ref_alt,f_filter,sf,0,order))
% grid on
% grid minor
% yline([-12,12],'--',{'min','max'})
% title("Roll [deg]")
% lgd=legend('\phi','\phi_{ref}','location','northwest');
% % lgd.Layout.Tile = 6;
% ylim([-16 16]);
% hold off
% %nexttile([1 1])

ax4=nexttile;
plot(data.timestamp,data.wing_angle_deg)
ylim([-10 110]);
hold on
yline([0 80],'--',{'Quad-Mode','FWD-Mode'})
grid on
grid minor
title("Skew Angle [deg]")
hold off
%nexttile([1 1])

ax5=nexttile;
plot(data.timestamp,-1*data.position_D)
hold on
%plot(data.timestamp,-1*data.position_D_ref)
title("Vertical position [m]")
yline([3],'--','target')
ylim([0,6])
grid on
grid minor
hold off
% lgd=legend('Actual','Reference');
% lgd.Layout.Tile = 12;
%nexttile([1 1])

ax6=nexttile;
plot(data.timestamp,low_butter(data.airspeed,f_filter,sf,0,order))
title("Airspeed [m/s]")
ylim([0,20]);
linkaxes([ax1,ax2,ax4,ax5,ax6],'x');
xlim([230,295]);
xlabel("Time [s]")
grid on
grid minor
hold off
%nexttile([1 1])

f.Units = 'inches';
%f.OuterPosition = [0.25 0.25 10 8];
f.OuterPosition = [0 0 5.5 7.5];
folder = fullfile(pwd,'plots_single');
%export_fig(fullfile(folder,strcat('transition','.pdf')),'-transparent')
exportgraphics(f,fullfile(folder,strcat('transition2','.pdf')),'ContentType','vector')