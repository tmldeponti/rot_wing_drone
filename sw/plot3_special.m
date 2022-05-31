function [rmse_log,p_out] = plot3_special(x,y,z,order,i)
%lin_plot Plot scatter data and best fit line based on the specified order
% 
pointer = ["o","*",".","+","x","p","h","d"];
colors  = [[0, 0.4470, 0.7410];[0.8500, 0.3250, 0.0980];[0.9290, 0.6940, 0.1250];[0.4940, 0.1840, 0.5560];[0.4660, 0.6740, 0.1880];[0.3010, 0.7450, 0.9330];[0.6350, 0.0780, 0.1840];[0.75, 0, 0.75]];

%p = [sin(deg2rad(x)).^(order),y.^(order),ones(size(x))]\z;
%p = [sin(deg2rad(x)).^(order).*y.^(order),ones(size(x))]\z;
scatter3(x,y,z,pointer(i),'color',colors(i,:))
hold on
%surf(x,y,p(1)*sin(deg2rad(x)).^(order)+p(2).*y.^(order)+p(3),'FaceAlpha',0.3)
%trisurf(delaunay(x,y),x,y,p(1)*sin(deg2rad(x)).^(order)+p(2).*y.^(order)+p(3),'FaceAlpha',0.3)
x1 = linspace(min(x),max(x));
y1 = linspace(min(y),max(y));
[X,Y] = meshgrid(x1,y1);
RMSE = 1000;
case_list = ["poly 1","poly 2","poly 3","poly 4","poly 5"," sin(x) y","(sin(x) y)^2","(sin(x) y)^3","sin(x)+y","sin(x)^2+y^2","sin(x)^3+y^3"," sin(x) y+k","(sin(x) y)^2+k","(sin(x) y)^3+k","sin(x)+y+k","sin(x)^2+y^2+k","sin(x)^3+y^3+k","sin(x)^3 y^2","y^2"];
best_case = 1;
override = 1;
rmse_log = [];
for j=1:19
    if override
        i = 19;
    else
        i = j ;
    end
    p = [];
    z_i = zeros(size(x));
    Z_i = zeros(size(X));
    switch i
        case {1,2,3,4,5}
            n = 0;
            p1 = [];
            p2 = [];
            while i > n
                p1 = [p1,x.^(i-n)];
                p2 = [p2,y.^(i-n)];
                n = n+1;
            end
            %p = [p1,p2,ones(size(x))]\z;
            p = lsqr([p1,p2,ones(size(x))],z);
            %p = [p1,p2]\z;
            n = 0;
            while i > n
                z_i = z_i + p(n+1).*x.^(i-n)+p(n+i+1).*y.^(i-n);
                Z_i = Z_i + p(n+1).*X.^(i-n)+p(n+i+1).*Y.^(i-n);
                n = n+1;
            end
            z_i = z_i+p(end);
            Z_i = Z_i+p(end);
        case {6,7,8}
            p = [sin(deg2rad(x)).^(i-5).*y.^(i-5)]\z;
            z_i = p(1).*sin(deg2rad(x)).^(i-5).*y.^(i-5);
            Z_i = p(1).*sin(deg2rad(X)).^(i-5).*Y.^(i-5);
        case {9,10,11}
            p = [sin(deg2rad(x)).^(i-8),y.^(i-8)]\z;
            z_i = p(1).*sin(deg2rad(x)).^(i-8)+p(2).*y.^(i-8);
            Z_i = p(1).*sin(deg2rad(X)).^(i-8)+p(2).*Y.^(i-8);
        case {12,13,14}
            p = [sin(deg2rad(x)).^(i-11).*y.^(i-11),ones(size(x))]\z;
            z_i = p(1).*sin(deg2rad(x)).^(i-11).*y.^(i-11)+p(2);
            Z_i = p(1).*sin(deg2rad(X)).^(i-11).*Y.^(i-11)+p(2);
        case {15,16,17}
            p = [sin(deg2rad(x)).^(i-14),y.^(i-14),ones(size(x))]\z;
            z_i = p(1).*sin(deg2rad(x)).^(i-14)+p(2).*y.^(i-14)+p(3);
            Z_i = p(1).*sin(deg2rad(X)).^(i-14)+p(2).*Y.^(i-14)+p(3);
        case 18
            p = [sin(deg2rad(x)).^3.*y.^(2)]\z;
            z_i = p(1).*sin(deg2rad(x)).^(3).*y.^(2);
            Z_i = p(1).*sin(deg2rad(X)).^(3).*Y.^(i-14);
        case 19
            p = [y.^(2)]\z;
            z_i = p(1).*y.^(2);
            Z_i = p(1).*Y.^(2);
           
    end
    
    RMSE_i = rms((z-z_i)./z);
    rmse_log = [rmse_log,RMSE_i];
    if RMSE_i < RMSE
        RMSE = RMSE_i;
        best_case = i;
        Z = Z_i;
        p_out = p;
    end
end
%s=surf(X,Y,p(1).*sin(deg2rad(X)).^(order).*Y.^(order)+p(2),'FaceAlpha',0.3);
[temp, ranking] = sort(rmse_log(1,:));
rmse_log = rmse_log(:,ranking);
rmse_log = [case_list(ranking);rmse_log];
s=surf(X,Y,Z,'FaceAlpha',0.3);
s.EdgeColor = 'none';
title(case_list(best_case))
end