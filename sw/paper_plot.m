function [] = paper_plot(h,w,gcf,name)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
width = w;     % Width in inches
height = h;    % Height in inches
set(gcf,'InvertHardcopy','on');
set(gcf,'PaperUnits', 'inches');
papersize = get(gcf, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(gcf,'PaperPosition', myfiguresize);
export_fig(name)
end