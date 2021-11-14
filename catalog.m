classdef catalog
    % This class defines the airframe characteristics of the chosen drone
    enumeration 
        Nedjet (1,'NederJet', 8, 50, 18, 5, [2,1,-3], 9600, 123, 0, 0.09516,1/256*[256,162,-162,-256,-256,-162,162,256;256,256,256,256,-256,-256,-256,-256;-256,256,-256,256,-256,256,-256,256;256,256,256,256,256,256,256,256],[0,0,0,0,0,0,0,0;-2,-2,2,2,-2,-2,2,2;2,-2,-2,2,2,-2,-2,2;0,0,0,0,0,0,0,0]);
        Neddrone (2,'Nederdrone', 12, 50, 18, 5, [1,2,3], 9600, 123, 0, 0.1,1/256*[256,157,56,-56,-157,-256,256,157,56,-56,-157,-256;256,256,256,256,256,256,-256,-256,-256,-256,-256,-256;256,256,256,256,256,256,-256,-256,-256,-256,-256,-256;256,256,256,256,256,256,256,256,256,256,256,256],[0,0,0,0,0,0,0,0;-2,-2,2,2,-2,-2,2,2;2,-2,-2,2,2,-2,-2,2;0,0,0,0,0,0,0,0]);
    end
    properties
        AC_ID
        Full_name
        Number_Motors
        AS_f
        Motor_f
        Butter_f
        IMU_Orientation
        PP_ABS_LIM
        PP_RT_LIM
        PP_SRV_DLY
        PP_FO
        MOT_MAT
        AS_MAT
    end
    
    methods
        function obj = airframe(ac_id, full_name, number_motors,as_f, motor_f,butter_f,imu_orientation, pp_abs_lim,pp_rt_lim, pp_srv_dly, pp_fo, mot_mat, as_mat)
            %Return the settings of the chosen airframe
            obj.AC_ID=ac_id;
            obj.Full_name=full_name;
            obj.Number_Motors=number_motors;
            obj.AS_f=as_f;
            obj.Motor_f=motor_f;
            obj.Butter_f= butter_f;
            obj.IMU_Orientation=imu_orientation;
            obj.PP_ABS_LIM=pp_abs_lim;
            obj.PP_RT_LIM=pp_rt_lim;
            obj.PP_SRV_DLY=pp_srv_dly;
            obj.PP_FO=pp_fo;
            obj.MOT_MAT=mot_mat;
            obj.AS_MAT=as_mat;
        end

    end
end

