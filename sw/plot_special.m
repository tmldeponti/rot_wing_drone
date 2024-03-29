function [rmse_log,p_out] = plot_special(x,z,order,ii,fit_visible)
%lin_plot Plot scatter data and best fit line based on the specified order
% 
if nargin < 5
    fit_visible = 1;
end
ws = warning('off','all');
pointer = ["o","*",".","+","x","p","h","d","s","v"];
colors  = [[0, 0.4470, 0.7410];[0.8500, 0.3250, 0.0980];[0.9290, 0.6940, 0.1250];[0.4940, 0.1840, 0.5560];[0.4660, 0.6740, 0.1880];[0.3010, 0.7450, 0.9330];[0.6350, 0.0780, 0.1840];[0.75, 0, 0.75];[1 0 0];[0 1 1]];
% if order < 10
%     [p,S] = polyfit(x,y,order);
% else
%     p = [sin(deg2rad(x)).^(order-9),ones(size(x))]\y;
% end
% 
% plot(x,y,pointer(i),'color',colors(i,:))
% hold on
% if order < 10
%     plot(x,polyval(p,x),'-','color',colors(i,:))
% else
%     plot(x,p(1)*sin(deg2rad(x)).^(order-9)+p(2),'-','color',colors(i,:))
% end
% plot(x,z,pointer(ii),'color',colors(ii,:))
% hold on
% 
% x1 = linspace(min(x),max(x));
% RMSE = 1000;
% case_list = ["poly 1","poly 2","poly 3","poly 4","poly 5","sin(x)","(sin(x))^2","(sin(x))^3","sin(x)^4","sin(x)^5","cos(x)-cos(x)^3","cos(x)","(cos(x))^2","(cos(x))^3","cos(x)^4","cos(x)^5"];
% best_case = 1;
% override = 0;
% no_overfit = 1;
% rmse_log = [];
% opts = optimset('Display','off');
% for j=1:16
%     if override
%         i = 11;
%     else
%         i = j ;
%     end
%     p = [];
%     z_i = zeros(size(x));
%     Z_i = zeros(size(x));
%     switch i
%         case {1,2,3,4,5}
%             [p,S] = polyfit(x,z,i);
%             z_i = polyval(p,x);
%             Z_i = polyval(p,x1);
%         case {6,7,8,9,10}
%             [p,S] = polyfit(sin(deg2rad(x)),z,i-5);
%             z_i = polyval(p,sin(deg2rad(x)));
%             Z_i = polyval(p,sin(deg2rad(x1)));
%         case 11
%             p = lsqr([cos(deg2rad(x)),cos(deg2rad(x)).^3],z,1e-12,50);
%             z_i = p(1).*cos(deg2rad(x))+p(2).*cos(deg2rad(x)).^3;
%             Z_i = p(1).*cos(deg2rad(x1))+p(2).*cos(deg2rad(x1)).^3;
%         case {12,13,14,15,16}
%             [p,S] = polyfit(cos(deg2rad(x)),z,i-11);
%             z_i = polyval(p,cos(deg2rad(x)));
%             Z_i = polyval(p,cos(deg2rad(x1)));
%            
%     end
%     
%     RMSE_i = rms((z-z_i)./z);
%     rmse_log = [rmse_log,RMSE_i];
%     if RMSE_i < RMSE
%         RMSE = RMSE_i;
%         best_case = i;
%         Z = Z_i;
%         p_out = p;
%     end
% end
% [temp, ranking] = sort(rmse_log(1,:));
% rmse_log = rmse_log(:,ranking);
% rmse_log = [case_list(ranking);rmse_log];
% plot(x1,Z,'-','color',colors(ii,:))
% title(case_list(best_case))

plot(x,z,pointer(ii),'color',colors(ii,:))
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
title(case_list(best_case))
end