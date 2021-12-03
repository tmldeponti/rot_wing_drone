motor_f = 50;
[motor_cont, mot_num, mot_den] = FO_alpha(motor_f);
%mot_num = cell2mat(mot_num);
mot_den = cell2mat(mot_den);
w_n = 50;
zeta = 0.55;
Ts = 1/500;
H = c2d(tf([w_n^2],[1,2*zeta*w_n,w_n^2]),Ts);
[H_z_num, H_z_den] = tfdata(H);
H_z_num = cell2mat(H_z_num);
H_z_den = cell2mat(H_z_den);

G_1 = [0,-12.8,0,12.8;2.7,0,-2.7,0;-0.115,0.115,-0.115,0.115];%[0,-12.8,0,12.8;2.7,0,-2.7,0;-0.115,0.115,-0.115,0.115;-0.3,-0.3,-0.3,-0.3]
G_2 = [0,0,0,0;0,0,0,0;-0.06,0.06,-0.06,0.06];
pseudo_g12 = pinv(G_1+G_2);
