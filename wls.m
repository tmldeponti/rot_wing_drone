function [u,output,W] = wls(n_u,n_v,Wv,Wu,gamma,u_current,v,B,W_init,up,uamin,uamax,imax)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
disp('--------------------------------------------------------------------------')
disp('--------------------------------------------------------------------------')
disp('NEW ITERATION')
disp('--------------------------------------------------------------------------')
disp('--------------------------------------------------------------------------')
umin = min((uamin-u_current),0)%[52,52,52,52];
umax = max((uamax-u_current),0)%[733,733,733,733];
u_guess = 0.5 * (umax-umin);
up = umin;
break_flag = false;
% n_u = 4; % size control input
% n_v = 4; % size control objective
n_c = n_u+n_v;

A = zeros(n_c,n_u);
A_free = zeros(n_c,n_u);

b = zeros(1,n_c);
d = zeros(1,n_c);

free_index = zeros(1,n_u);
free_index_lookup = zeros(1,n_u);
n_free = 0; %0
free_chk = -1;
iter = 0;
p_free = zeros(1,n_u);
p = zeros(1,n_u);
u_opt = zeros(1,n_u);
infeasible_index = zeros(1,n_u);
n_infeasible = 0;
lambda = zeros(1,n_u);
W = zeros(1,n_u);


u = u_guess;
W = W_init;
free_index_lookup = ones(1,n_u) * -1;

for i=1:n_u
    if W(1,i)== 0
        n_free = n_free+1;
        free_index_lookup(i) = n_free;
        free_index(n_free)= i;
        
    end
end

for i = 1:n_v
    b(i) = gamma * Wv(i) * v(i);
    d(i) = b(i);
    for j =1:n_u
        A(i,j) = gamma * Wv(i) * B(i,j);
        d(i) = d(i) - A(i,j) * u(j);
    end  
end

for i = (n_v+1):n_c
    A(i,:) = zeros(1,n_u);
    A(i,i-n_v) = Wu(i-n_v);
    b(i) = Wu(i-n_v)*up(i-n_v);
    d(i) = b(i) - A(i,i-n_v)* u(i-n_v);

end
disp('A =')
disp(A)
disp('b=')
disp(b)
disp('d=')
disp(d)
while (iter < imax)
    disp('--------------------------------------------------------------------------')
    fprintf('iter = %i \n',iter)
    p = zeros(1,n_u);
    u_opt = u;
    u_check = zeros(1,n_u);
    fprintf('uopt = %f %f %f %f \n',u_opt)
    if free_chk ~= n_free
        for i =1:n_c
            for j=1:n_free
                A_free(i,j) = A(i,free_index(j));
            end
        end
        free_chk = n_free;
    end
    
    if n_free>0
        % use a solver to find the solution to A_free*p_free = d
        %wapper n_c, n_free, A_free_ptr, d, p_free
        p_free= (A_free\d.').';
    else
        disp('no free actuator')
        output = -2;
        %u = zeros(1,n_u);
        break
    end
    fprintf('pfree = %f %f %f %f \n',p_free)
    for i =1:n_free
        p(free_index(i)) = p_free(i);
        u_opt(free_index(i)) = u_opt(free_index(i)) + p_free(i);
    end
    fprintf('uopt 2 = %f %f %f %f \n',u_opt)
    n_infeasible = 0;
    for i = 1:n_u
        if u_opt(i)>= (umax(i)) || u_opt(i)<= (umin(i))
            n_infeasible = n_infeasible+1;
            infeasible_index(n_infeasible) = i;
            if u_opt(i)<= (umin(i))
                u_check(i)= 1;
            end
        end
    end
    fprintf('INFEASIBLE = %i \n', n_infeasible)
    if n_infeasible == 0
        u = u_opt;
        lambda = zeros(1,n_u);
        for i =1:n_c
            for k =1:n_free
                d(i) = d(i) - A_free(i,k)*p_free(k);
            end
            for k =1:n_u
                lambda(k) = lambda(k)+A(i,k)*d(i);
            end
        end
        break_flag = true;
        %disp(lambda)
        for i = 1:n_u
            lambda(i) = lambda(i)*W(i);
            %disp('check')
            %disp(lambda(i))
            if lambda(i) < 0
                %disp('check 2')
                break_flag = false;
                W(i) = 0;

                if free_index_lookup(i) <0
                    n_free =n_free +1;
                    free_index_lookup(i) = n_free;
                    free_index(n_free) = i;
                    
                end
            end
        end

        if break_flag
            output = iter;
            break
        end
    else
        alpha = inf;
        alpha_tmp = 0;
        id_alpha = 1;
        fprintf('nfree = %i \n',n_free)
        fprintf('free_index = %i %i %i %i \n',free_index)
        fprintf('p = %f %f %f %f \n',p)
        fprintf('u = %f %f %f %f \n',u)
        fprintf('umin = %f %f %f %f \n',umin)
        fprintf('umax = %f %f %f %f \n',umax)
        for i = 1:n_free
            id=free_index(i);
            if abs(p(id))>1.1920928955078125e-7%0
                %alpha_tmp = (p(id)<0)*(umin(id)-u(id))/p(id)+ (1-(p(id)<0))*(umax(id)-u(id))/p(id);
                alpha_tmp = (u_check(id))*(umin(id)-u(id))/p(id)+ (1-u_check(id))*(umax(id)-u(id))/p(id);
                fprintf('alpha_tmp = %f \n',alpha_tmp)
            else
                alpha_tmp = inf;
                disp('WTF')
            end
            if alpha_tmp < alpha %ABSSSSSSS
                alpha =alpha_tmp;
                id_alpha = id;
                fprintf('alpha = %f \n',alpha)
                fprintf('id_alpha = %i \n',id_alpha)
            end
        end
        
        for i =1:n_u
            u(i)=u(i)+p(i)*alpha;
        end
        fprintf('u 2 = %f %f %f %f \n',u)
        for i =1:n_c
            for k =1:n_free
                d(i) = d(i) - A_free(i,k)*alpha*p_free(k);
            end
        end
        %W(id_alpha) = (p(id_alpha)>0) *1 + (1-(p(id_alpha)>0)) * -1;
        W(id_alpha) = (u_check(id_alpha)<=0) *1 + (1-(u_check(id_alpha)<=0)) * -1;
        
        fprintf('nfree 2 = %i \n',n_free)
        free_index(free_index_lookup(id_alpha)) = free_index(n_free);
        n_free = n_free -1;
        free_index_lookup(free_index(free_index_lookup(id_alpha))) = free_index_lookup(id_alpha);
        free_index_lookup(id_alpha) = -1 ;
        
    end 
    output = -1;
    
    iter = iter +1;
end
if output == -1
    disp('No solution')
elseif output == -2
    disp('All saturated')
else
    disp('Great Sucscess')
    
end
disp(u_current+u)
end