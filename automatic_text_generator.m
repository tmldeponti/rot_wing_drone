fileID_1 = fopen('rot_wing_cyberzoo_no_gps.txt','w');
fileID_2 = fopen('model.txt','r');

count=0;
tline = fgetl(fileID_2);
limit_h = 54;
actuator_axes = 3;%7
control_axes  = 1;%2;
no_chirp = true;
no_doublet = true;
no_angle = false;

angle_test    = [4,6,8,10];
doublet_amp   = [500, 450, 400; 350, 300, 250; 80 100 100; 80 100 100; 80 100 100];%[100,200,300; 50, 100, 150];
doublet_t     = [0.4, 0.5, 0.6; 0.4, 0.5, 0.6; 1.0 0.7 0.7; 1.0 0.7 0.7; 1.0 0.7 0.7];
chirp_amp     = 0.1;
chirp_t       = 5;
chirp_fs      = 0.6;
chirp_fe      = 1.7;
chirp_n_on    = 0;
chirp_n_off   = 0;
cd_t          = 6;
cd_t2          = 6;
wing_sp       = [0];%linspace(2,20,2);%linspace(0,70,8);
names         = ["Motor Front","Motor Right","Motor Back","Motor Left","Aileron Left", "Aileron Right","Elevator","Rudder"];


while ischar(tline)
  count= count+1;
  disp(tline)
  if count == limit_h
      doublet=0;
      chirp=0;
      angle=0;
      for k=1:size(wing_sp,2)
          line_10 = strcat('    <block name="Rotating wing ', num2str(wing_sp(k),'%.0f'),'">');
          line_11 = strcat('      <set var="wing_rotation.wing_angle_deg_sp" value="',num2str(wing_sp(k),'%.1f'),'"/>');
          line_12 = '    </block>';
          fprintf(fileID_1,'%s\r\n',line_10);
          fprintf(fileID_1,'%s\r\n',line_11);
          fprintf(fileID_1,'%s\r\n',line_12);
          
          line_13 = strcat('    <block name="Wait for wing ', num2str(wing_sp(k),'%.0f'),'">');
          line_14 = strcat('      <while cond="LessThan(NavBlockTime(),',num2str(round(cd_t2)),')"/>');%'      <exception cond="stage_time>2" deroute="Standby"/>';
          line_15 = '    </block>';
          fprintf(fileID_1,'%s\r\n',line_13);
          fprintf(fileID_1,'%s\r\n',line_14);
          fprintf(fileID_1,'%s\r\n',line_15);
          for i=1:size(angle_test,2)
              angle = angle + 1;
              if no_angle
                  break
              end
              line_16 = strcat('    <block name="Pitch angle ', num2str(angle,'%.0f'),'">');
              line_17 = strcat('      <set var="pitch_pref_deg" value="',num2str(angle_test(i),'%.1f'),'"/>');
              line_18 = strcat('    </block>');
              fprintf(fileID_1,'%s\r\n',line_16);
              fprintf(fileID_1,'%s\r\n',line_17);
              fprintf(fileID_1,'%s\r\n',line_18);
              line_19 = strcat('    <block name="Cool down angle ', num2str(angle,'%.0f'),'">');
              line_20 = strcat('      <go wp="STDBY"/>');
              line_20e = '      <stay wp="STDBY"/>';
              line_21 = strcat('      <while cond="LessThan(NavBlockTime(),',num2str(round(cd_t2)),')"/>');%'      <exception cond="stage_time>2" deroute="Standby"/>';
              line_21e= strcat('      <exception cond="MoreThan(NavBlockTime(),',num2str(round(cd_t2)),')" deroute="Standby"/>');
              line_22 = strcat('    </block>');
              line_23 = strcat('    <block name="Pitch reset', num2str(wing_sp(k),'%.0f'),'">');
              line_24 = strcat('      <set var="pitch_pref_deg" value="',num2str(0,'%.1f'),'"/>');
              line_25 = strcat('    </block>');
              
              fprintf(fileID_1,'%s\r\n',line_19);
              fprintf(fileID_1,'%s\r\n',line_20);
              fprintf(fileID_1,'%s\r\n',line_21);
              fprintf(fileID_1,'%s\r\n',line_22);

              if  (i==size(angle_test,2))
                  fprintf(fileID_1,'%s\r\n',line_23);
                  fprintf(fileID_1,'%s\r\n',line_24);
                  if no_chirp && no_doublet && (k==size(wing_sp,2))
                      fprintf(fileID_1,'%s\r\n',line_20e);
                      fprintf(fileID_1,'%s\r\n',line_21e);
                  else
                      fprintf(fileID_1,'%s\r\n',line_20);
                      fprintf(fileID_1,'%s\r\n',line_21);
                  end
                  fprintf(fileID_1,'%s\r\n',line_25);
              end
              
          end
          for i=0:actuator_axes
              rep = 0;
              if no_doublet
                  break
              end
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
                  line_3 = strcat('    <block name="Cool Down Doublet ',num2str(doublet),'" >');
                  line_4 = '      <go wp="STDBY"/>';
                  line_4e = '      <stay wp="STDBY"/>';
                  line_5 = strcat('      <while cond="LessThan(NavBlockTime(),',num2str(round(cd_t2+doublet_t(r,j),0)),')"/>');%'      <exception cond="stage_time>2" deroute="Standby"/>';
                  line_5e= strcat('      <exception cond="MoreThan(NavBlockTime(),',num2str(round(cd_t2+doublet_t(r,j),0)),')" deroute="Standby"/>');
                  line_6 = '    </block>';
                  fprintf(fileID_1,'%s\r\n',line_0);
                  fprintf(fileID_1,'%s\r\n',line_1);
                  fprintf(fileID_1,'%s\r\n',line_2);
                  fprintf(fileID_1,'%s\r\n',line_3);
                  if no_chirp && (i==actuator_axes) && (j==size(doublet_amp,2)) && (k==size(wing_sp,2))
                      fprintf(fileID_1,'%s\r\n',line_4e);
                      fprintf(fileID_1,'%s\r\n',line_5e);
                  else
                      fprintf(fileID_1,'%s\r\n',line_4);
                      fprintf(fileID_1,'%s\r\n',line_5);
                  end
                  fprintf(fileID_1,'%s\r\n',line_6);
              end
          end

          for i=0:control_axes
              if no_chirp
                  break
              end
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
              line_4e = '      <stay wp="STDBY"/>';
              line_5 = strcat('      <while cond="LessThan(NavBlockTime(),',num2str(round(cd_t+chirp_t,0)),')"/>');
              line_5e= strcat('      <exception cond="MoreThan(NavBlockTime(),',num2str(round(cd_t+chirp_t,0)),')" deroute="Standby"/>');
              line_6 = '    </block>';
              fprintf(fileID_1,'%s\r\n',line_0);
              fprintf(fileID_1,'%s\r\n',line_1);
              fprintf(fileID_1,'%s\r\n',line_2);
              fprintf(fileID_1,'%s\r\n',line_3);
              if (i==control_axes) && (k==size(wing_sp,2))
                  fprintf(fileID_1,'%s\r\n',line_4e);
                  fprintf(fileID_1,'%s\r\n',line_5e);
              else
                  fprintf(fileID_1,'%s\r\n',line_4);
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
