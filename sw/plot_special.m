function [outputArg1,outputArg2] = plot_special(x,y,order,i)
%lin_plot Plot scatter data and best fit line based on the specified order
% 
pointer = ["o","*",".","+","x","p","h","d"];
colors  = [[0, 0.4470, 0.7410];[0.8500, 0.3250, 0.0980];[0.9290, 0.6940, 0.1250];[0.4940, 0.1840, 0.5560];[0.4660, 0.6740, 0.1880];[0.3010, 0.7450, 0.9330];[0.6350, 0.0780, 0.1840];[0.75, 0, 0.75]];
if order < 10
    [p,S] = polyfit(x,y,order);
else
    p = [sin(deg2rad(x)).^(order-9),ones(size(x))]\y;
end

plot(x,y,pointer(i),'color',colors(i,:))
hold on
if order < 10
    plot(x,polyval(p,x),'-','color',colors(i,:))
else
    plot(x,p(1)*sin(deg2rad(x)).^(order-9)+p(2),'-','color',colors(i,:))
end

end