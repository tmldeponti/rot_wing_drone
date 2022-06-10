function [] = plot3_light(p,x,y,z,k,j,b,cmd,i)
%plot3_special Plot scatter data and best fit line based on the specified order
% 
pointer = ["o","*",".","+","x","p","h","d"];
colors  = [[0, 0.4470, 0.7410];[0.8500, 0.3250, 0.0980];[0.9290, 0.6940, 0.1250];[0.4940, 0.1840, 0.5560];[0.4660, 0.6740, 0.1880];[0.3010, 0.7450, 0.9330];[0.6350, 0.0780, 0.1840];[0.75, 0, 0.75]];
x = deg2rad(x);
x1 = linspace(min(x),max(x));
y1 = linspace(min(y),max(y));
[X,Y] = meshgrid(x1,y1);

if k < 2
    if j ==9
        f_skew = sin(X).^3;
    elseif j==10
        f_skew = cos(X)-cos(X).^3;
    elseif j==11
        f_skew = ones(size(X));
    else
        disp('Wrong index of Moment')
        return 
    end

else
    f_skew = ones(size(X));
end

Z = p.*f_skew.*Y.^2.*b.*cmd;
scatter3(rad2deg(x),y,z,pointer(i),'color',colors(i,:))
hold on
s=surf(rad2deg(X),Y,Z,'FaceAlpha',0.3);
s.EdgeColor = 'none';
%title(case_list(best_case))
end
