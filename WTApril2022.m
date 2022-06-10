classdef WTApril2022
    
    properties
        meas
        folder
        ojf
        pprz
        V
        motor_status
        skew_angle
        excitation_as
        pitch_angle
        data
        steady
        fitted
        settings
        notes
    end
    methods
        function this = WTApril2022(meas_list, apply_cal,static_test)
            if nargin < 2
                apply_cal = 0;
            end
            if nargin < 1
                do_all_meas = 1;
            else
                do_all_meas = 0;
            end
            
            this.settings.apply_cal = apply_cal;
            
            file = 'test_log.csv';
            switch static_test
                case 1
                    % First Static test
                    %folder = '/Users/tomasodeponti/Desktop/Flight data of VSQP/static_test_1605';
                    folder = 'C:\Users\Tomaso\Desktop\flight_data_VSQP\static_test_1605';
                case 2
                    % Second Static test
                    %folder = '/Users/tomasodeponti/Desktop/Flight data of VSQP/static_test_1605';
                    folder = 'C:\Users\Tomaso\Desktop\flight_data_VSQP\static_test_1805';
                case 3
                    % third Static test
                    %folder = '/Users/tomasodeponti/Desktop/Flight data of VSQP/static_test_1605';
                    folder = 'C:\Users\Tomaso\Desktop\flight_data_VSQP\static_test_1905'; 
            end
            this.folder = folder;
            
            file_path = fullfile(folder, file);
            
            fid = fopen(file_path);
            
            format = sprintf('%s', repmat('%s', 1, 9));
             
            headers = textscan(fid, format, 1, ...
                                'Delimiter', ';');
            
            data = textscan(fid, format, ...
                                'Delimiter', ';',...
                                'HeaderLines', 1);
            fclose(fid);
                  
            nnn = 1;
            for n = 1:length(data{1})
                if do_all_meas || sum(n == meas_list) > 0
                    for nn = 1:length(headers)
                        val = data{nn}{n};
                        switch headers{nn}{1}
                            case 'Measurement'
                                this.meas{nnn} = round(str2double(val));
                            case 'OJF file'
                                file_path = fullfile(folder, 'OJF', strcat(val, '.txt'));
                                this.ojf{nnn} = OJF2021(file_path);
%                             case 'PPRZ log'
%                                 if ~strcmp(val, '-')
%                                     log_nr = sprintf('%04.0f', str2double(val));
%                                     pprz_log_folder = fullfile(folder, 'PPRZ', log_nr);
% 
%                                     files = dir(pprz_log_folder);
%                                     for nnnn = 1:length(files)
%                                         file = files(nnnn);
%                                         if ~file.isdir
%                                             r = regexp(file.name, '(?<filename>\w+).(?<extension>\w+)', 'names');
%                                             if strcmp(r.extension, 'data')
%                                                 
%                                                 file_path = fullfile(folder, 'PPRZ', log_nr, file.name);
%                                             end
%                                         end 
%                                     end
%                                     this.pprz{nnn} = PPRZLog(file_path);
%                                 end
                            
                            case 'V (m/s)'
                                this.V{nnn} = val;
                            case 'Angle (deg)'
                                this.angle{nnn} = val;
                            case 'Fan thr'
                                this.fan_thr{nnn} = val;
                            case 'Notes'
                                this.notes{nnn} = val;
                        end
                    end
                    nnn = nnn + 1;
                end
            end
            
%             this = this.getConfig;
            this = this.getData;
            this = this.getSteadyData;
        end
        
            
        function this = getData(this)
            for n = 1:length(this.meas)
                
                % OJF
                this.data{n}.t = this.ojf{n}.t;
                this.data{n}.V = this.ojf{n}.V;
                this.data{n}.RPMojf = this.ojf{n}.rpm;
                this.data{n}.angle = this.ojf{n}.angle;
                this.data{n}.rho = this.ojf{n}.rho;
                this.data{n}.Fx = this.ojf{n}.Fx;
                this.data{n}.Fy = this.ojf{n}.Fy;
                this.data{n}.Fz = this.ojf{n}.Fz;
                this.data{n}.Mx = this.ojf{n}.Mx;
                this.data{n}.My = this.ojf{n}.My;
                this.data{n}.Mz = this.ojf{n}.Mz;
                
                % Apply cal
                if this.settings.apply_cal
                    calibration_name = this.mount{n};
                    file_path = fullfile(this.folder, 'Results', 'Calibration', strcat(calibration_name,'.mat'));
                    cal = open(file_path);
                    
                    this.data{n}.Fx = this.data{n}.Fx - interp2(cal.Vinf, cal.angle, cal.Fx, this.data{n}.V, this.data{n}.angle);
                    this.data{n}.Fy = this.data{n}.Fy - interp2(cal.Vinf, cal.angle, cal.Fy, this.data{n}.V, this.data{n}.angle);
                    this.data{n}.Fz = this.data{n}.Fz - interp2(cal.Vinf, cal.angle, cal.Fz, this.data{n}.V, this.data{n}.angle);
                    this.data{n}.Mx = this.data{n}.Mx - interp2(cal.Vinf, cal.angle, cal.Mx, this.data{n}.V, this.data{n}.angle);
                    this.data{n}.My = this.data{n}.My - interp2(cal.Vinf, cal.angle, cal.My, this.data{n}.V, this.data{n}.angle);
                    this.data{n}.Mz = this.data{n}.Mz - interp2(cal.Vinf, cal.angle, cal.Mz, this.data{n}.V, this.data{n}.angle);
                end
                
%                 % Lift and Drag from OJF
%                 switch this.setup{n}
%                     case 'Fuselage'
%                         switch this.mount{n}
%                             case 'Normal'
%                                 this.data{n}.alpha = zeros(size(this.data{n}.angle));
%                                 this.data{n}.beta = this.data{n}.angle;
% 
% %                                 this.data{n}.L = -this.ojf{n}.Fy .* cosd(this.ojf{n}.angle) ...
% %                                     - this.ojf{n}.Fx .* sind(this.ojf{n}.angle);
%                                 this.data{n}.L = -this.data{n}.Fz;
%                                 this.data{n}.D = this.data{n}.Fx .* cosd(this.data{n}.angle) ...
%                                     - this.data{n}.Fy .* sind(this.data{n}.angle);
% 
%                             case '90 deg roll'
%                                 this.data{n}.alpha = this.data{n}.angle;
%                                 this.data{n}.beta = zeros(size(this.data{n}.angle));
%                                 
%                                 this.data{n}.L = -this.data{n}.Fy .* cosd(this.data{n}.angle) ...
%                                      - this.data{n}.Fx .* sind(this.data{n}.angle);
%                                 this.data{n}.D = this.data{n}.Fx .* cosd(this.data{n}.angle) ...
%                                     - this.data{n}.Fy .* sind(this.data{n}.angle);
%                             case 'Normal 2'
%                                 this.data{n}.alpha = zeros(size(this.data{n}.angle));
%                                 this.data{n}.beta = this.data{n}.angle;
% 
% %                                 this.data{n}.L = -this.ojf{n}.Fy .* cosd(this.ojf{n}.angle) ...
% %                                     - this.ojf{n}.Fx .* sind(this.ojf{n}.angle);
%                                 this.data{n}.L = -this.data{n}.Fz;
%                                 this.data{n}.D = this.data{n}.Fx .* cosd(this.data{n}.angle) ...
%                                     - this.data{n}.Fy .* sind(this.data{n}.angle);
%                             case '90 deg roll 2'
%                                 this.data{n}.alpha = this.data{n}.angle;
%                                 this.data{n}.beta = zeros(size(this.data{n}.angle));
%                                 
%                                 this.data{n}.L = -this.data{n}.Fy .* cosd(this.data{n}.angle) ...
%                                      - this.data{n}.Fx .* sind(this.data{n}.angle);
%                                 this.data{n}.D = this.data{n}.Fx .* cosd(this.data{n}.angle) ...
%                                     - this.data{n}.Fy .* sind(this.data{n}.angle);
%                                 
%                         end
%                         
%                         if ~strcmp(this.fuselage{n}.name, '-')
%                             this.data{n}.CL = this.data{n}.L ./ ...
%                                         (0.5 .* this.data{n}.rho ...
%                                         .* this.data{n}.V.^2 ...
%                                         .* this.fuselage{n}.S);
%                             this.data{n}.CD = this.data{n}.D ./ ...
%                                         (0.5 .* this.data{n}.rho ...
%                                         .* this.data{n}.V.^2 ...
%                                         .* this.fuselage{n}.S);
%                                     
%                             this.data{n}.CFtot = (this.data{n}.CD.^2 + this.data{n}.CL .^2).^0.5;
%                         end
%                         
%                     case 'Wing'
%                         switch this.mount{n}
%                             case 'Normal'
%                                 this.data{n}.alpha = this.data{n}.angle;
%                                 this.data{n}.beta = 90 .* ones(size(this.data{n}.angle));
%                                 
%                                 this.data{n}.L = -this.data{n}.Fy .* cosd(this.data{n}.angle) ...
%                                      - this.data{n}.Fx .* sind(this.data{n}.angle);
%                                 this.data{n}.D = this.data{n}.Fx .* cosd(this.data{n}.angle) ...
%                                     - this.data{n}.Fy .* sind(this.data{n}.angle);
%                                 this.data{n}.Mpitch = this.data{n}.Mz;
%                                 this.data{n}.CMpitch = this.data{n}.Mz ./ ...
%                                     (0.5 .* this.data{n}.rho ...
%                                     .* this.data{n}.V.^2 ...
%                                     .* this.wing{n}.S ...
%                                     .* this.wing{n}.b);
%                                 
%                             case '90 deg'
%                                 this.data{n}.alpha = zeros(size(this.data{n}.angle));
%                                 this.data{n}.beta = this.data{n}.angle;
%                                 
% %                                 this.data{n}.L = -this.ojf{n}.Fy .* cosd(this.ojf{n}.angle) ...
% %                                      - this.ojf{n}.Fx .* sind(this.ojf{n}.angle);
%                                 this.data{n}.L = -this.data{n}.Fz;
%                                 this.data{n}.D = this.data{n}.Fx .* cosd(this.data{n}.angle) ...
%                                     - this.ojf{n}.Fy .* sind(this.data{n}.angle);
%                         end
%                         
%                         this.data{n}.CL = this.data{n}.L ./ ...
%                                     (0.5 .* this.data{n}.rho ...
%                                     .* this.data{n}.V.^2 ...
%                                     .* this.wing{n}.S);
%                         this.data{n}.CD = this.data{n}.D ./ ...
%                                     (0.5 .* this.data{n}.rho ...
%                                     .* this.data{n}.V.^2 ...
%                                     .* this.wing{n}.S);
%                                 
%                         this.data{n}.CFtot = (this.data{n}.CD.^2 + this.data{n}.CL .^2).^0.5;
%                 end 
                
%                 % From PPRZ, apply delay
%                 
%                 if ~isempty(this.pprz)
%                     
%                     this = this.det_sync;
%                     
%                     % motor 1
%                     this.data{n}.fan_thr = (interp1(this.pprz{n}.log.ACTUATORS.timestamp ...
%                         + this.data{n}.delay, ...
%                         this.pprz{n}.log.ACTUATORS.mot1, ...
%                         this.data{n}.t) - 1000)./1000.*100;
%                     
%                     % Current
%                     try
%                         this.data{n}.current = interp1(this.pprz{n}.log.ENERGY.timestamp ...
%                             + this.data{n}.delay, ...
%                             this.pprz{n}.log.ENERGY.current, ...
%                             this.data{n}.t);
%                         this.data{n}.power = interp1(this.pprz{n}.log.ENERGY.timestamp ...
%                             + this.data{n}.delay, ...
%                             this.pprz{n}.log.ENERGY.power, ...
%                             this.data{n}.t);
%                     end 
%                 end
            end
        end
        function this = getSteadyData(this)
            for n = 1:length(this.data)
                
                % Get initial data
                variable = fieldnames(this.data{n});
                for nn = 1:length(variable)
                    this.steady{n}.(variable{nn}) = this.data{n}.(variable{nn});
                end
                
                t_buffer = 0.1;
                mask = zeros(size(this.data{n}.t));
                
                dt = mean(diff(this.data{n}.t));
                
                windowSize = round(3 ./ dt);
                b = (1/windowSize)*ones(1,windowSize);

                steady_RPMojf = abs(diff(filter(b, 1, this.data{n}.RPMojf))) < 0.1;
                steady_Vinf = abs(diff(filter(b, 1, this.data{n}.V))) < 0.01;
                steady_turn_table = abs(diff(this.data{n}.angle)) < 0.1;
                
                V_above_3 = this.data{n}.V > 3;
                
                mask(steady_RPMojf == 0) = 1;
                mask(steady_Vinf == 0) = 1;
                mask(steady_turn_table == 0) = 1;
                mask(V_above_3 == 0) = 1;
                
                % Widen the mask
                a = find(abs(diff(mask)) == 1);
                
                for nn = 1:length(a)
                    id1 = a(nn) - floor(t_buffer ./ dt);
                    id2 = a(nn) + floor(t_buffer ./ dt);
                    
                    if id1 < 1
                        id1 = 1;
                    end
                    
                    mask(id1:id2) = 1;
                end

                % Apply mask
                for nn = 1:length(variable)
                    this.steady{n}.(variable{nn})(mask == 1) = NaN;
                end
            
            end 
        end
        function this = det_sync(this)
            % Try to read delay
            sync = this.read_sync;
            
            for n = 1:length(this.meas)
                
                this.data{n}.delay = [];
                
                if ~isempty(sync{n})
                    for nn = 1:length(sync{n}.pprz_file)
                        
                        if strcmp(this.pprz{n}.name, sync{n}.pprz_file{nn})
                            this.data{n}.delay = sync{n}.delay{nn};
                        end
                    end
                end
                
                if isempty(this.data{n}.delay)

                    dt = max(mean(diff(this.ojf{n}.t)), mean(diff(this.pprz{n}.log.ACTUATORS.timestamp)));
                    t = 0:dt:min(this.ojf{n}.t(end), this.pprz{n}.log.ACTUATORS.timestamp(end));

                    T1 = interp1(this.pprz{n}.log.ACTUATORS.timestamp, this.pprz{n}.log.ACTUATORS.mot1, t);
                    T2 = interp1(this.ojf{n}.t, this.ojf{n}.Fx, t);

%                     id_t_sync = floor(max(t)*dt);
                    id_t_sync = floor(30/dt);
                    
                    if id_t_sync > length(t)
                        id_t_sync = length(t);
                    end
                    
                    this.data{n}.delay = dt*finddelay(T1(1:id_t_sync), T2(1:id_t_sync));
                end
            end
        end
        function sync = read_sync(this)
            for n = 1:length(this.meas)
                sync{n} = [];
                
                % Try to read delay
                file_path = fullfile(this.ojf{n}.folder, 'delay', strcat(this.ojf{n}.name, '.txt'));
                fid = fopen(file_path, 'r');
                
                if fid > 0
                    lines = readlines(file_path);
                    
                    for nn = 1:length(lines)
                        line = lines{nn};
                        if ~isempty(line)
                            r = regexp(line, "(?<pprz_file>[a-zA-Z0-9_-]+): (?<delay>[-]*[0-9]+.[0-9]*)", 'names');
                            sync{n}.pprz_file{nn} = r.pprz_file;
                            sync{n}.delay{nn} = str2double(r.delay);
                        end
                    end
                    fclose(fid);
                end
            end
        end
        function save_sync(this)
            sync = this.read_sync;
            
            for n = 1:length(this.meas)
                sync_overwritten = 0;
                
                if ~isempty(sync{n})
                    for nn = 1:length(sync{n}.pprz_file)
                        if strcmp(this.pprz{n}.name, sync{n}.pprz_file{nn})
                            sync{n}.delay{nn} = this.data{n}.delay;
                            sync_overwritten = 1;
                        end
                    end
                end
                
                if ~sync_overwritten
                    nn = length(sync{n}.pprz_file);
                    sync{n}.pprz_file{nn+1} = this.pprz{n}.name;
                    sync{n}.delay{nn+1} = this.data{n}.delay;
                end
                
                % Write to file
                file_path = fullfile(this.ojf{n}.folder, 'delay', strcat(this.ojf{n}.name, '.txt'));
            
                fid = fopen(file_path, 'w');
            
                for nn = 1:length(sync{n}.pprz_file)
                    fprintf(fid, "%s: %.3f\n", sync{n}.pprz_file{nn}, sync{n}.delay{nn});
                end
                
                fclose(fid);
            end
        end
        function this = getFittedData(this, sp_Vinf, sp_Angle)
            sp_Vinf = unique(sp_Vinf);
            sp_angle = unique(sp_Angle);
            
            [Vinf, angle] = meshgrid(sp_Vinf, sp_angle);
            
            Temp = zeros(size(Vinf));
            
            for nn = 1:length(sp_Vinf)
                for nnn = 1:length(sp_angle)

                    Temp2 = [];
                    Vinf2 = [];
                    angle2 = [];
                    
                    for n = 1:length(this.data)
                        this.fitted{n}.Vinf = Vinf;
                        this.fitted{n}.angle = angle;
                        
                        variables = fieldnames(this.data{n});
                        
                        Vinf2 = this.data{n}.V;
                        angle2 = this.data{n}.angle;
                        
                        mask = abs(Vinf2 - sp_Vinf(nn)) < 0.5 & ...
                               abs(angle2 - sp_angle(nnn)) < 0.2;

                        for nnnn = 1:length(variables)
%                             Temp2 = [Temp2; this.data{n}.(variables{nnnn})];
                             Temp = this.data{n}.(variables{nnnn});

                            this.fitted{n}.(variables{nnnn})(nnn, nn) = mean(Temp(mask));
                        end
                    end
                end
            end
        end
        function this = select_turn_table_angle(this, angles_to_keep)
            for n = 1:length(this.steady)
                for nn = 1:length(angles_to_keep)
                    variables = fieldnames(this.data{n});
                    mask = abs(this.steady{n}.angle - angles_to_keep(nn)) > 0.1;
                    
                    for nnn = 1:length(variables)
                        this.steady{n}.(variables{nnn})(mask) = NaN;
                    end
                end
            end
        end
        function this = select_airspeed(this, airspeed_to_keep)
            for n = 1:length(this.steady)
                for nn = 1:length(airspeed_to_keep)
                    variables = fieldnames(this.data{n});
                    mask = abs(this.steady{n}.V - airspeed_to_keep(nn)) > 0.1;
                    
                    for nnn = 1:length(variables)
                        this.steady{n}.(variables{nnn})(mask) = NaN;
                    end
                end
            end
        end
        function plt(this, Xname, Yname, DataType, LineSpec)
            if nargin < 5
                LineSpec = '.';
            end
            if nargin < 4
                DataType = 'steady';
            end
            if nargin < 3
                Yname = 'V';
            end
            if nargin < 2
                Xname = 't';
            end
            
            for n = 1:length(this.meas)
                X = this.(DataType){n}.(Xname);
                Y = this.(DataType){n}.(Yname);
                DisplayName = sprintf("Meas: %.0f", this.meas{n});
            
                plot(X, Y, LineSpec, ...
                    'DisplayName', DisplayName,...
                    'LineWidth', 2,...
                    'MarkerSize', 7);
            end
            xlabel(this.getLabel(Xname))
            ylabel(this.getLabel(Yname))
            legend
        end
    end
    methods(Static)
        function label = getLabel(name)
            switch name
                case 't'
                    label = 'Time [s]';
                case 'Fx'
                    label = 'Force in x direction [N]';
                case 'Fy'
                    label = 'Force in y direction [N]';
                case 'Fz'
                    label = 'Force in z direction [N]';
                case 'Mx'
                    label = 'Moment around x axis [Nm]';
                case 'My'
                    label = 'Moment around y axis [Nm]';
                case 'Mz'
                    label = 'Moment around z axis [Nm]';
                case 'rpm'
                    label = 'Wind tunnel RPM [rev/s]';
                case 'Temp'
                    label = 'Temperature [deg C]';
                case 'p'
                    label = 'Pressure [Pa]';
                case 'dp'
                    label = 'Differential Pressure [Pa]';
                case 'V'
                    label = 'Airspeed [m/s]';
                case 'Vinf'
                    label = 'Airspeed [m/s]';
                case 'q'
                    label = 'Dynamic pressure [Pa]';
                case 'rho'
                    label = 'Air density [kg/m3]';
                case 'angle'
                    label = 'Rotation angle turn table [deg]';
                case 'alpha'
                    label = 'Angle of attack [deg]';
                case 'beta'
                    label = 'Yaw angle [deg]';
                case 'D'
                    label = 'Drag [N]';
                case 'L'
                    label = 'Lift [N]';
                case 'Mpitch'
                    label = 'Pitch moment [Nm]';
                case 'Mroll'
                    label = 'Roll moment [Nm]';
                case 'Myaw'
                    label = 'Yaw moment [Nm]';
                case 'CL'
                    label = 'Lift coefficient [-]';
                case 'CD'
                    label = 'Drag coefficient [-]';
                case 'CFtot'
                    label = 'Total force coefficient [-]';
                case 'CMpitch'
                    label = 'Pitch moment coefficient [-]';
                case 'CMroll'
                    label = 'Roll moment coefficient [-]';
                case 'CMyaw'
                    label = 'Roll moment coefficient [-]';
                case 'fan_thr'
                    label = 'Fuel cell fans throttle [%]';
                otherwise
                    label = '?';
            end
        end
    end
end