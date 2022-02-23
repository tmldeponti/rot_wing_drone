function [output] = FO_alpha(input)
%
A = tf(input,[1 input]);
A = c2d(A,1/500);
[num,~] = tfdata(A);
num = cell2mat(num);
output = num(end);


end

