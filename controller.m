function [sol,exitflag] = controller(wanted_acc,tensor,pwm,f,cons1,cons2)
tn = tensor * wanted_acc;
prob = optimproblem;
x = optimvar('x',5,1,'LowerBound',min(pwm),'UpperBound',max(pwm));
prob.Constraints.cons1= cons1;
prob.Constraints.cons2= cons2;
prob.Objective = f*x;
x0.x= ones(5,1)*0.8*max(pwm); 
[sol,fval1,exitflag,output1] = solve(prob,x0,"Options",optimoptions('fmincon','Display','none'));
end

