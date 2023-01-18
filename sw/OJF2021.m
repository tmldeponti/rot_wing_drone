classdef OJF2021
    
    properties
        name
        folder
        t
        Fx
        Fy
        Fz
        Mx
        My
        Mz
        rpm
        Temp
        p
        dp
        V
        q
        angle
        bias
    end
    methods
        function this = OJF2021(file_path, det_bias, save_bias)
            if nargin < 3
                save_bias = 0;
            end
            if nargin < 2
                det_bias = 1;
            end
    
            fid = fopen(file_path);
            format = sprintf('%s', repmat('%f', 1, 14));
            if fid > 0
                data = textscan(fid, format, ...
                    'Delimiter', '\t');

                [this.folder, this.name, ~] = fileparts(file_path); 

                this.t = data{1};
                this.Fx = data{2};
                this.Fy = data{3};
                this.Fz = data{4};
                this.Mx = data{5};
                this.My = data{6};
                this.Mz = data{7};
                this.rpm = data{8};
                this.Temp = data{9};
                this.p = data{10};
                this.dp = data{11};
                this.V = data{12};
                this.q = data{13};
                this.angle = data{14};

                if det_bias
                    this = this.det_bias;
                end

                if save_bias
                    this.save_bias;
                end
            else
                warning('Could not open file: %s', file_path)
            end
        end
        function rho = rho(this)
            R = 287;
            rho = this.p ./(R * (this.Temp + 273.15));
        end
        function this = det_bias(this)
            
            % Try to read bias
            file_path = fullfile(this.folder, 'bias', strcat(this.name, '.txt'));
            fid = fopen(file_path, 'r');
            
            if fid > 0
                lines = readlines(file_path);
                
                for n = 1:length(lines)
                    line = lines{n};
                    if ~isempty(line)
                        r = regexp(line, "(?<force>\w+): (?<value>[-]*[0-9]+.[0-9]*)", 'names');
                    
                        this.bias.(r.force) = str2double(r.value);
                    end
                end
                fclose(fid);
            else
                dt = mean(gradient(this.t));
                t_buffer = 2;

                variable = {'Fx', 'Fy', 'Fz', 'Mx', 'My', 'Mz'};

                g = zeros(size(this.(variable{1})));
                
                for n = 1:length(variable)
                    g = g + (this.(variable{n})).^2;
                end
                
                g_limit = [5, 15, 100];
%                 g_limit = 10;
                
                for n = 1:length(g_limit)
                
                    a = find((diff(g)./dt <= g_limit(n)) == 0);
                
                    if ~isempty(a)
                        a_id_t1 = a(1) - floor(t_buffer / dt);
                        a_id_t2 = a(end) + floor(t_buffer /dt);
                    else
                        a_id_t1 = NaN;
                        a_id_t2 = NaN;
                    end
                    
                    if a_id_t1 > 0
                        break
                    end
                end
                
                % For determining bias manually:
%                 figure; t = this.t(1:end-1); plot(t, diff(g)./dt)
%                 a_id_t0 = floor(5/dt);
                a_id_t1 = floor(3/dt);
                
                for n = 1:length(variable)
                    if a_id_t1 > 0
                        a_avg = mean(this.(variable{n})(1:a_id_t1));
%                         a_avg = mean(this.(variable{n})(a_id_t0:a_id_t1));
                    elseif a_id_t2 < length(g)
                        a_avg = mean(this.(variable{n})(a_id_t2:end));
                    elseif isnan(a_id_t1) && isnan(a_id_t2)
                        a_avg = mean(this.(variable{n}));
                    else
                        warning('Could not find bias.')
                        a_avg = 0;
                    end

                   this.bias.(variable{n}) = a_avg;
                end
            end
            
            % Apply bias
            variable = fieldnames(this.bias);
            for n = 1:length(variable)
                this.(variable{n}) = this.(variable{n}) - this.bias.(variable{n});
            end
        end
        function save_bias(this)
            
            file_path = fullfile(this.folder, 'bias', strcat(this.name, '.txt'));
            
            fid = fopen(file_path, 'w+');
            
            variables = fieldnames(this.bias);
            
            for n = 1:length(variables)
                fprintf(fid, "%s: %.3f\n", variables{n}, this.bias.(variables{n}));
            end
            fclose(fid);
        end
            
        function plt(this, Xname, Yname, LineSpec, DisplayName)
            if nargin < 5
                DisplayName = this.name;
            end
            if nargin < 4
                LineSpec = '-';
            end
            
            X = this.(Xname);
            Y = this.(Yname);
            
            plot(X, Y, LineSpec, ...
                'DisplayName', DisplayName);
            xlabel(this.getLabel(Xname))
            ylabel(this.getLabel(Yname))
            legend
        end
        function pltforces(this)
            this.plt('t', 'Fx', '-', 'Fx')
            this.plt('t', 'Fy', '-', 'Fy')
            this.plt('t', 'Fz', '-', 'Fz')
        end
        function pltmoments(this)
            this.plt('t', 'Mx', '-', 'Mx')
            this.plt('t', 'My', '-', 'My')
            this.plt('t', 'Mz', '-', 'Mz')
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
                case 'q'
                    label = 'Dynamic pressure [Pa]';
                case 'rho'
                    label = 'Air density [kg/m3]';
                case 'angle'
                    label = 'Rotation angle turn table [deg]';
                case 'alpha'
                    label = 'Angle of attack [deg]';
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
                case 'CMpitch'
                    label = 'Pitch moment coefficient [-]';
                case 'CMroll'
                    label = 'Roll moment coefficient [-]';
                case 'CMyaw'
                    label = 'Roll moment coefficient [-]';
                otherwise
                    label = '?';
            end
        end
    end
end
