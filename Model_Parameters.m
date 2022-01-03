motor_f = 18;
[motor_cont, mot_num, mot_den] = FO_alpha(motor_f);
%mot_num = cell2mat(mot_num);
mot_den = cell2mat(mot_den);
w_n = 50;
zeta = 0.55;t.m.
Ts = 1/500;
M= 0.1*1/(1-exp(-20*Ts));
H = c2d(tf([w_n^2],[1,2*zeta*w_n,w_n^2]),Ts);
[H_z_num, H_z_den] = tfdata(H);
H_z_num = cell2mat(H_z_num);
H_z_den = cell2mat(H_z_den);
Hz2rads = 6.28;
conv = (2000-1100)/((150-50)*Hz2rads);
mot_eff = -1*(16-0)/((733-52))*conv;
G_1 = [ mot_eff,mot_eff,mot_eff,mot_eff;0,-12.8,0,12.8;2.7,0,-2.7,0;-0.115,0.115,-0.115,0.115]./conv;%[0,-12.8,0,12.8;2.7,0,-2.7,0;-0.115,0.115,-0.115,0.115;-0.3,-0.3,-0.3,-0.3]
G_2 = [0,0,0,0;0,0,0,0;0,0,0,0;-0.06,0.06,-0.06,0.06]./conv;
pseudo_g12 = pinv(G_1+G_2);

g =9.81;
mass = 2.339132*1; %kg
weight = -g*mass;

%%
syms theta phi psi m T
c=@cos;
s=@sin;
Rz = [c(psi) -s(psi) 0; sin(psi) cos(psi) 0; 0 0 1];
Ry = [c(theta) 0 s(theta); 0 1 0; -sin(theta) 0 c(theta)];
Rx = [1 0 0 ; 0 c(phi) -s(phi); 0 s(phi) c(phi)]; 
Mnb = Rz * Ry * Rx;
Tn(theta,phi,psi,T) = Mnb * [0 0 T].';
Gt = simplify([(diff(Tn(theta,phi,psi,T),phi)).'; (diff(Tn(theta,phi,psi,T),theta)).'; (diff(Tn(theta,phi,psi,T),T)).'].');
Gn(phi,theta,psi) = Gt;
Gn_inv(phi,theta,psi) = simplify(Gn.'*(Gn*Gn.')^-1);
%matlabFunctionBlock('Quad_model/Gn_calculator/Gn_inv', Gn_inv);
%matlabFunctionBlock('Quad_model/Gn_calculator/Gn', Gn); %global Gn; and redo linking of globlal variable
%% 
%s = tf('s');
%% Remove Filtering if needed
H_z_den = [1];
H_z_num = [1];
%% Ideal Motors if needed
mot_den = [1];
mot_num = [1];
%% Plots for actuator test
load('actuator_test.mat')
linesize = 1.5;

figure(1)
clf

ax1 = subplot(2,1,1);
plot(actuator_test(3),'LineWidth',linesize)
hold on
plot(actuator_test(1),'LineWidth',linesize)
title('Not Compensated M = 1 ');
xlabel('Time [s]');
ylabel('Angular Acceleration [rad s^-2]');
set(gca,'fontsize',20);
ylim([-0.15,0.15]);
grid minor
grid on
legend('Reference','Actual')


ax2 = subplot(2,1,2);
plot(actuator_test(3),'LineWidth',linesize)
hold on
plot(actuator_test(2),'LineWidth',linesize)
title('Compensated M = 1/Γ');
xlabel('Time [s]');
ylabel('Angular Acceleration [rad s^-2]');
set(gca,'fontsize',20);
ylim([-0.15,0.15]);
grid minor
grid on
legend('Reference','Actual')

linkaxes([ax1,ax2],'x')
%xlim([tstart tend])