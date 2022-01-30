%% MODEL PARAMETERS USED IN THE SIMULINK SIMULATION %%%%%%%%%%%%%%%%%
%%% MOTOR DYNAMICS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
motor_f = 18;
[motor_cont, mot_num, mot_den] = FO_alpha(motor_f);
mot_den = cell2mat(mot_den);
%%% FILTERING VALUES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
w_n = 50;
zeta = 0.55;
Ts = 1/500;
H = c2d(tf([w_n^2],[1,2*zeta*w_n,w_n^2]),Ts);
[H_z_num, H_z_den] = tfdata(H);
H_z_num = cell2mat(H_z_num);
H_z_den = cell2mat(H_z_den);
%%% MOTOR COMPENSATION METHOD %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
M= 1;%0.1*1/(1-exp(-20*Ts));
%%% INNERLOOP EFFECTIVNESS DEFINITION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Hz2rads = 6.28;
conv = (2000-1100)/((150-50)*Hz2rads);
mot_eff = -1*(16-0)/((733-52))*conv;
G_1 = [ mot_eff,mot_eff,mot_eff,mot_eff;0,-12.8,0,12.8;2.7,0,-2.7,0;-0.115,0.115,-0.115,0.115]./conv;%[0,-12.8,0,12.8;2.7,0,-2.7,0;-0.115,0.115,-0.115,0.115;-0.3,-0.3,-0.3,-0.3]
G_2 = [0,0,0,0;0,0,0,0;0,0,0,0;-0.06,0.06,-0.06,0.06]./conv;
pseudo_g12 = pinv(G_1+G_2);
%%% PHYSICAL VALUES OF THE MODEL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
g =9.81;
mass = 2.339132*1; %kg
weight = -g*mass;
v_lim = 10;
cd = 1;
rho = 1.225;
A = 0.2^2;
%%% WLS FOR INNERLOOP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Wv = [1000,10000,10000,1];
Wu = [1,1,1,1];
W_init  = [0,0,0,0];
gamma = 10000;
W_init  = [0,0,0,0];
B = G_1+G_2 ;
up = [0,0,0,0];
imax = 5;
uamin = 52;
uamax = 733;
%%% WLS FOR OUTERLOOP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Wv_o = [1,1,1];
Wu_o = [1,1,1];
W_init_o  = [0,0,0];
gamma_o = 10000;
W_init_o  = [0,0,0];

up_o = [0,0,0];
imax_o = 5;
uamin_o = [-0.4363,-0.4363, mot_eff*4*733];
uamax_o = [0.4363,0.4363, 0];

%% DERIVATION OF OUTERLOOP
syms theta phi psi m T 
c=@cos;
s=@sin;     
Rz = [c(psi) -s(psi) 0; sin(psi) cos(psi) 0; 0 0 1];
Ry = [c(theta) 0 s(theta); 0 1 0; -sin(theta) 0 c(theta)];
Rx = [1 0 0 ; 0 c(phi) -s(phi); 0 s(phi) c(phi)]; 
Mnb = Rz * Ry * Rx;
Tn(theta,phi,psi,T) = Mnb * [0 0 T].';
%matlabFunctionBlock('Quad_model/Tn', Tn);
Gt = simplify([(diff(Tn(theta,phi,psi,T),phi)).'; (diff(Tn(theta,phi,psi,T),theta)).'; (diff(Tn(theta,phi,psi,T),T)).'].');
Gn(phi,theta,psi) = Gt;
Gn_inv(phi,theta,psi) = simplify(Gn.'*(Gn*Gn.')^-1);
%matlabFunctionBlock('Quad_model/Gn_calculator/Gn_inv', Gn_inv);
%matlabFunctionBlock('Quad_model/Gn_calculator/Gn', Gn); %global Gn; and redo linking of globlal variable
%% Print views of simulink model for lit review . Open simulink model first
%ModelName = ''  % to open the model
addpath(genpath('C:\Users\Tomaso\Desktop\Thesis\main\sim_views'))
print('-sQuad_model/Flight Control System','-dpng','sim_views/fcs.png','-r300')
print('-sQuad_model/Flight Control System/outerloop','-dpng','sim_views/outerloop.png','-r300')
print('-sQuad_model/Flight Control System/outerloop/Heading controller','-dpng','sim_views/heading.png','-r300')
print('-sQuad_model/Flight Control System/outerloop/Simulation  Environment','-dpng','sim_views/sim.png','-r300')
print('-sQuad_model/Flight Control System/outerloop/Attitude Controller','-dpng','sim_views/attitude.png','-r300')
print('-sQuad_model/Flight Control System/outerloop/Attitude Controller/Inner loop','-dpng','sim_views/innerloop.png','-r300')
print('-sQuad_model/Flight Control System/outerloop/Attitude Controller/Inner loop/MAV','-dpng','sim_views/mav.png','-r300')

%%
syms u1 u2 u3 u4
Wv = [100, 0, 0, 0; 0, 1000, 0, 0; 0, 0, 1000, 0; 0, 0, 0, 1 ];
Wu = [1, 0, 0, 0; 0, 1, 0, 0; 0, 0, 1, 0; 0, 0, 0, 1];
gamma = 10000;
virtual = [1,1,1,1].';
ud = [300, 300, 300, 300].';
A = [gamma .* Wv .* (G_1+G_2) ; Wu];
b = [gamma .* Wv * virtual ; Wu * ud];
C = norm(A * [u1,u2,u3,u4].'-b)^2
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