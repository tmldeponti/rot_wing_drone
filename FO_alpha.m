function [output,num,den] = FO_alpha(input)
%
A = tf(input,[1 input]);
A = c2d(A,1/500)
[num,den] = tfdata(A);
num = cell2mat(num);
output = num(end);


end

