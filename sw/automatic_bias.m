function [outputArg1,outputArg2] = automatic_bias(data_path,save_path)
%automatic_bias Automatically save bias values
%   
txtFiles = dir(fullfile(data_path,'*.txt')); 
numfiles = length(txtFiles);
items = 20;            
for k = 1:numfiles 
    fid = fopen(fullfile(data_path,txtFiles(k).name)); 
    format = sprintf('%s', repmat('%f', 1, 14));
    data = textscan(fid, format,'Delimiter', '\t');         
    fclose(fid);
    data=cell2mat(data);
    data_save = mean(data(1:items,2:7));
    name = strcat('bias_',txtFiles(k).name);
    fid = fopen(fullfile(save_path,name),'w'); 
    fprintf(fid, '%f %f %f %f %f %f \n', data_save);
    fclose(fid);
    %writetable(array2table(data_save,'VariableNames',["Fx","Fy","Fz","Mx","My","Mz"]),fullfile(save_path,name));
    %mydata{k} = txtread(); 
    %all = [all;mydata{k}];
end 


end