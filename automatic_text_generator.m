fileID_1 = fopen('rot_wing_cyberzoo_no_gps.txt','w');
fileID_2 = fopen('model.txt','r');

count=0;
tline = fgetl(fileID_2);
limit_h = 52;
actuator_axes = 7;%7
control_axes  = 1;%2;
doublet_amp   = [40, 50; 30, 40; 80 100; 80 100; 80 100];%[100,200,300; 50, 100, 150];
doublet_t     = [1.0, 0.7; 1.0, 0.7; 1.0 0.7; 1.0 0.7; 1.0 0.7];
chirp_amp     = 0.04;
chirp_t       = 15;
chirp_fs      = 0.4;
chirp_fe      = 0.8;
chirp_n_on    = 0;
chirp_n_off   = 0;
cd_t          = 15;
wing_sp       = [2,30,45];%linspace(2,20,2);%linspace(0,70,8);
names         = ["Motor Front","Motor Right","Motor Back","Motor Left","Aileron Left", "Aileron Right","Elevator","Rudder"];


while ischar(tline)
  count= count+1;
  disp(tline)
  if count == limit_h
      doublet=0;
      chirp=0;
      for k=1:size(wing_sp,2)
          line_10 = strcat('    <block name="Rotating wing ', num2str(wing_sp(k),'%.0f'),'">');
          line_11 = strcat('      <set var="wing_rotation.wing_angle_deg_sp" value="',num2str(wing_sp(k),'%.1f'),'"/>');
          line_12 = '    </block>';
          fprintf(fileID_1,'%s\r\n',line_10);
          fprintf(fileID_1,'%s\r\n',line_11);
          fprintf(fileID_1,'%s\r\n',line_12);
          
          line_13 = strcat('    <block name="Wait for wing ', num2str(wing_sp(k),'%.0f'),'">');
          line_14 = strcat('      <while cond="LessThan(NavBlockTime(),',num2str(round(cd_t)),')"/>');%'      <exception cond="stage_time>2" deroute="Standby"/>';
          line_15 = '    </block>';
          fprintf(fileID_1,'%s\r\n',line_13);
          fprintf(fileID_1,'%s\r\n',line_14);
          fprintf(fileID_1,'%s\r\n',line_15);
          for i=0:actuator_axes
              rep = 0;
              for j=1:size(doublet_amp,2)
                  %r = 1 + (i>3);
                  if i<=3
                      r = 1 + mod(i,2);
                  elseif i>3 && i<=5
                      r = 3;
                  else
                      r =i-2;
                  end
                  
                  doublet=doublet+1;
                  char_1 = '    <block name="Doublet';
                  char_2 = '" >';
                  string = strcat(char_1,num2str(doublet)," ",names(i+1),char_2);
                  fprintf(fileID_1,'%s\r\n',string);

                  char_3 = '      <call_once fun="sys_id_doublet_set_param(';
                  char_4 = ')"/>';
                  string = strcat(char_3,num2str(doublet_amp(r,j),'%.1f'),',',num2str(doublet_t(r,j),'%.1f'),',',num2str(i),char_4);
                  fprintf(fileID_1,'%s\r\n',string);
                  line_0 = '      <set var="doublet_active" value="1"/>';
                  line_1 = '      <call_once fun="sys_id_doublet_activate_handler(doublet_active)"/> ';
                  line_2 = '    </block>';
                  line_3 = strcat('    <block name="Cool Down ',num2str(doublet),'" >');
                  line_4 = '      <go wp="STDBY"/>';
                  line_5 = strcat('      <while cond="LessThan(NavBlockTime(),',num2str(round(cd_t+doublet_t(r,j),0)),')"/>');%'      <exception cond="stage_time>2" deroute="Standby"/>';
                  line_6 = '    </block>';
                  fprintf(fileID_1,'%s\r\n',line_0);
                  fprintf(fileID_1,'%s\r\n',line_1);
                  fprintf(fileID_1,'%s\r\n',line_2);
                  fprintf(fileID_1,'%s\r\n',line_3);
                  fprintf(fileID_1,'%s\r\n',line_4);
                  fprintf(fileID_1,'%s\r\n',line_5);
                  fprintf(fileID_1,'%s\r\n',line_6);
              end
          end

          for i=0:control_axes
              chirp=chirp+1;
              char_1 = '    <block name="Chirp';
              char_2 = '" >';
              string = strcat(char_1,num2str(chirp),char_2);
              fprintf(fileID_1,'%s\r\n',string);
              char_3 = '      <call_once fun="sys_id_chirp_set_param(';
              char_4 = ')"/>';
              string = strcat(char_3,num2str(chirp_amp,'%.2f'),',',num2str(chirp_t,'%.1f'),',',num2str(i),',',num2str(chirp_fs,'%.1f'),',',num2str(chirp_fe,'%.1f'),',',num2str(chirp_n_on,'%.1f'),',',num2str(chirp_n_off,'%.1f'),char_4);
              fprintf(fileID_1,'%s\r\n',string);
              line_0 = '      <set var="chirp_active" value="1"/>';
              line_1 = '      <call_once fun="sys_id_chirp_activate_handler(chirp_active)"/> ';
              line_2 = '    </block>';
              line_3 = strcat('    <block name="Cool Down Chirp ',num2str(chirp),'" >');
              line_4 = '      <go wp="STDBY"/>';
              line_5 = strcat('      <while cond="LessThan(NavBlockTime(),',num2str(round(cd_t+chirp_t,0)),')"/>');
              line_5e= strcat('      <exception cond="LessThan(NavBlockTime(),',num2str(round(cd_t+chirp_t,0)),')" deroute="Standby"/>');
              line_6 = '    </block>';
              fprintf(fileID_1,'%s\r\n',line_0);
              fprintf(fileID_1,'%s\r\n',line_1);
              fprintf(fileID_1,'%s\r\n',line_2);
              fprintf(fileID_1,'%s\r\n',line_3);
              fprintf(fileID_1,'%s\r\n',line_4);
              if (i==control_axes) && (k==size(wing_sp,2))
                  fprintf(fileID_1,'%s\r\n',line_5e);
              else
                  fprintf(fileID_1,'%s\r\n',line_5);
              end
              fprintf(fileID_1,'%s\r\n',line_6);        
          end
      end
      
  end
  fprintf(fileID_1,'%s\r\n',tline);
  tline = fgetl(fileID_2);
end



%tline = fgetl(fid01);


fclose(fileID_1);
fclose(fileID_2);
