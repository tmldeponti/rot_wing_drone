function [outputArg1] = pp_limiter(input,max_abs, min_abs, servo_delay, max_rate, fo_constant)
%UNTITLED2 Apply rate and absolute limits used in paparazzi 
outputArg1 = rate_lim(input, servo_delay, max_rate, fo_constant);
% disp('ratelim')
% disp(size(outputArg1))
outputArg1 = min(outputArg1, max_abs*ones(size(outputArg1)));
outputArg1 = max(outputArg1, min_abs*ones(size(outputArg1)));
end

