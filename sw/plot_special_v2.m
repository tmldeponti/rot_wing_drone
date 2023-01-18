function [rmse_log,p_out,h] = plot_special_v2(x,z,order,ii,fit_visible,h)
%lin_plot Plot scatter data and best fit line based on the specified order
% 
if nargin < 5
    fit_visible = 1;
end
ws = warning('off','all');
pointer = ["o","*",".","+","x","p","h","d","s","v"];
colors  = [[0, 0.4470, 0.7410];[0.8500, 0.3250, 0.0980];[0.9290, 0.6940, 0.1250];[0.4940, 0.1840, 0.5560];[0.4660, 0.6740, 0.1880];[0.3010, 0.7450, 0.9330];[0.6350, 0.0780, 0.1840];[0.75, 0, 0.75];[1 0 0];[0 1 1]];

% hi = plot(x,z,[],colors(ii,:),pointer(ii));
hi = scatter(x,z,[],colors(ii,:),pointer(ii));
h(ii) = hi(1);
%h = [0;0];
hold on
p_out = [];
x1 = linspace(min(x),max(x));
Z = zeros(size(x1));
RMSE = 10000;
case_list = ["poly 1","poly 2","poly sin(x)","poly (sin(x))^2","cos(x)-cos(x)^3","poly cos(x)","poly (cos(x))^2","sin(x)^3","sin(x)^2","x^2","sin(x)^2+k","cos(x)","sin(x)"];
best_case = 1;
if order < 0
    override = 0;
else
    override = 1;
end

no_overfit = 1;
rmse_log = [];
opts = optimset('Display','off');
for j=1:(13-12*override)
    if override
        i = order;
    else
        i = j ;
    end
    p = [];
    z_i = zeros(size(x));
    Z_i = zeros(size(x));
    switch i
        case {1,2}
            [p,S] = polyfit(x,z,i);
            z_i = polyval(p,x);
            Z_i = polyval(p,x1);
        case {3,4}
            [p,S] = polyfit(sin(deg2rad(x)),z,i-2);
            z_i = polyval(p,sin(deg2rad(x)));
            Z_i = polyval(p,sin(deg2rad(x1)));
        case 5
%             p = lsqr([cos(deg2rad(x)),cos(deg2rad(x)).^3],z,1e-12,50);
            p = lsqr([cos(deg2rad(x))-cos(deg2rad(x)).^3],z,1e-12,50);
%             z_i = p(1).*cos(deg2rad(x))+p(2).*cos(deg2rad(x)).^3;
%             Z_i = p(1).*cos(deg2rad(x1))+p(2).*cos(deg2rad(x1)).^3;
            z_i = p(1).*(cos(deg2rad(x))-cos(deg2rad(x)).^3);
            Z_i = p(1).*(cos(deg2rad(x1))-cos(deg2rad(x1)).^3);
        case {6,7}
            [p,S] = polyfit(cos(deg2rad(x)),z,i-5);
            z_i = polyval(p,cos(deg2rad(x)));
            Z_i = polyval(p,cos(deg2rad(x1)));
        case {8}
            %p = lsqr([sin(deg2rad(x)).^3],z,1e-12,50,[],[],1);
            p = [sin(deg2rad(x)).^3]\z;
            z_i = p(1).*sin(deg2rad(x)).^3;
            Z_i = p(1).*sin(deg2rad(x1)).^3;
        case {9}
            %p = lsqr([sin(deg2rad(x)).^3],z,1e-12,50,[],[],1);
            p = [sin(deg2rad(x)).^2]\z;
            z_i = p(1).*sin(deg2rad(x)).^2;
            Z_i = p(1).*sin(deg2rad(x1)).^2;
        case {10}
            p = [x.^2]\z;
            z_i = p(1).*x.^2;
            Z_i = p(1).*x1.^2;
        case {11}
            %p = lsqr([sin(deg2rad(x)).^3],z,1e-12,50,[],[],1);
            p = [sin(deg2rad(x)).^2, ones(size(x))]\z;
            z_i = p(1).*sin(deg2rad(x)).^2 + p(2);
            Z_i = p(1).*sin(deg2rad(x1)).^2 + p(2);
        case {12}
            %p = lsqr([sin(deg2rad(x)).^3],z,1e-12,50,[],[],1);
            p = [cos(deg2rad(x))]\z;
            z_i = p(1).*cos(deg2rad(x));
            Z_i = p(1).*cos(deg2rad(x1));
        case {13}
            %p = lsqr([sin(deg2rad(x)).^3],z,1e-12,50,[],[],1);
            p = [sin(deg2rad(x))]\z;
            z_i = p(1).*sin(deg2rad(x));
            Z_i = p(1).*sin(deg2rad(x1));
           
    end
    
    RMSE_i = rms((z-z_i));
    rmse_log = [rmse_log,RMSE_i];
    if RMSE_i < RMSE
        RMSE = RMSE_i;
        best_case = i;
        Z = Z_i;
        p_out = p;
    end
end
[temp, ranking] = sort(rmse_log(1,:));
rmse_log = rmse_log(:,ranking);
rmse_log = [case_list(ranking);rmse_log];
if fit_visible
    plot(x1,Z,'-','color',colors(ii,:))
end
%title(case_list(best_case))
end