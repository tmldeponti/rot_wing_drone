function [coef,y_v] = poly_gen(x,y,deg,query,debug)
coef = polyfit(x,y,deg);
y_v = polyval(coef,query);

if debug
    clf
    scatter(x,y)
    hold on 
    plot(query, y_v)
    legend('original', 'polyfit')
end