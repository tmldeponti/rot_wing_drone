function [outputArg1,outputArg2] = automatic_calibration(path)
%automatic_calibration Summary of this function goes here
% only one txt file in the data directory   

%automatic_calibration('C:\Users\Tomaso\Desktop\flight_data_VSQP\static_test_1605\OJF\calibration')
txtFiles = dir(fullfile(path,'data','*.txt'));
fid = fopen(fullfile(path,'data',txtFiles(1).name)); 
format = sprintf('%s', repmat('%f', 1, 14));
data = textscan(fid, format,'Delimiter', '\t');         
fclose(fid);
data=cell2mat(data);

txtFiles = dir(fullfile('C:\Users\Tomaso\Desktop\flight_data_VSQP\static_test_1605\OJF\calibration\data\bias','*.txt')); 
fid = fopen(fullfile('C:\Users\Tomaso\Desktop\flight_data_VSQP\static_test_1605\OJF\calibration\data\bias',txtFiles(1).name));
format = sprintf('%s', repmat('%f', 1, 6));
Bias = cell2mat(textscan(fid, format,'Delimiter', ','));
fclose(fid);
data(:,2) = data(:,2)-Bias(1);
data(:,3) = data(:,3)-Bias(2);
data(:,4) = data(:,4)-Bias(3);
data(:,5) = data(:,5)-Bias(4);
data(:,6) = data(:,6)-Bias(5);
data(:,7) = data(:,7)-Bias(6);
data(:,12) = round(data(:,12));
v = unique(data(:,12));
save = zeros(size(v,1),7);
name = strcat('calibration.txt');
fid = fopen(fullfile(path,name),'wt'); 
for i=1:size(v,1)
    save(i,1)   = v(i);
    save(i,2:7) = mean(data(data(:,12)==v(i),2:7));
    fprintf(fid, '%f %f %f %f %f %f %f \n', save(i,:));
end
fclose(fid);
end