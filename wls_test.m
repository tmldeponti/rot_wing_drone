Hz2rads = 6.28;
conv = (2000-1100)/((150-50)*Hz2rads);
mot_eff = -1*(16-0)/((733-52))*conv;
G_1 = [ mot_eff,mot_eff,mot_eff,mot_eff;0,-12.8,0,12.8;2.7,0,-2.7,0;-0.115,0.115,-0.115,0.115]./conv;%[0,-12.8,0,12.8;2.7,0,-2.7,0;-0.115,0.115,-0.115,0.115;-0.3,-0.3,-0.3,-0.3]
G_2 = [0,0,0,0;0,0,0,0;0,0,0,0;-0.06,0.06,-0.06,0.06]./conv;
pseudo_g12 = pinv(G_1+G_2);
%Wv = [100, 0, 0, 0; 0, 1000, 0, 0; 0, 0, 1000, 0; 0, 0, 0, 1 ];
Wv = [100,100,100,1];
%Wu = [1, 0, 0, 0; 0, 1, 0, 0; 0, 0, 1, 0; 0, 0, 0, 1];
Wu = [1,1,1,1];
gamma = 100000000;
u_current_2 = [300,300,300,300];
W_init  = [0,0,0,0];
v       = [0,0,10,0];
B = G_1+G_2 ;
up = [72,52,52,52];
imax = 5;
uamin = 52;
uamax = 733;
%%

[u,out_res,W] = wls(4,4,Wv,Wu,gamma,u_current_2,v,B,W_init,up,uamin,uamax,imax);
%disp(u+u_current_2)
fprintf('W= %f %f %f %f \n',W);
u_current_2 = u+u_current_2;
%W_init =W;
%%
% umin = (uamin-u_current);%[52,52,52,52];
% umax = (uamax-u_current);%[733,733,733,733];
% u_guess = 0.5 * (umax-umin);
% 
% 
% brek_flag = false;
% n_u = 4; % size control input
% n_v = 4; % size control objective
% n_c = n_u+n_v;
% 
% A = zeros(n_c,n_u);
% A_free = zeros(n_c,n_u);
% % A_free_ptr = zeros(1,n_c);
% % for i =1:n_c
% %     A_free_ptr(i) = A_free(i,:);
% % end
% 
% b = zeros(1,n_c);
% d = zeros(1,n_c);
% 
% free_index = zeros(1,n_u);
% free_index_lookup = zeros(1,n_u);
% n_free = 0; %0
% free_chk = -1;
% iter = 0;
% p_free = zeros(1,n_u);
% p = zeros(1,n_u);
% u_opt = zeros(1,n_u);
% infeasible_index = zeros(1,n_u);
% n_infeasible = 0;
% lambda = zeros(1,n_u);
% W = zeros(1,n_u);
% 
% 
% u = u_guess;
% W = W_init;
% free_index_lookup = ones(1,n_u) * -1;
% 
% for i=1:n_u
%     if W(1,i)== 0
%         n_free = n_free+1;
%         free_index_lookup(i) = n_free;
%         free_index(n_free)= i;
%         
%     end
% end
% 
% for i = 1:n_v
%     b(i) = gamma * Wv(i) * v(i);
%     d(i) = b(i);
%     for j =1:n_u
%         A(i,j) = gamma * Wv(i) * B(i,j);
%         d(i) = d(i) - A(i,j) * u(j);
%     end  
% end
% 
% for i = (n_v+1):n_c
%     A(i,:) = zeros(1,n_u);
%     A(i,i-n_v) = Wu(i-n_v);
%     b(i) = Wu(i-n_v)*up(i-n_v);
%     d(i) = b(i) - A(i,i-n_v)* u(i-n_v);
% 
% end
% while (iter < imax)
%     fprintf('iter = %i \n',iter)
%     p = zeros(1,n_u);
%     u_opt = u;
% 
%     if free_chk ~= n_free
%         for i =1:n_c
%             for j=1:n_free
%                 A_free(i,j) = A(i,free_index(j));
%             end
%         end
%         free_chk = n_free;
%     end
% 
%     if n_free>0
%         % use a solver to find the solution to A_free*p_free = d
%         %wapper n_c, n_free, A_free_ptr, d, p_free
%         in = zeros(1,n_c*n_free);
%         k = 0;
% %         for j = 1:n_free
% %             for i = 1:n_c
% %                 in(k) = A_free_ptr(i,j);
% %             end
% %         end
%         %qr_solve(n_c,n_free,in,d,p_free)
%         p_free= (A_free\d.').';
%     end
% 
%     for i =1:n_free
%         p(free_index(i)) = p_free(i);
%         u_opt(free_index(i)) = u_opt(free_index(i)) + p_free(i);
%     end
% 
%     n_infeasible = 0;
%     for i = 1:n_u
%         if u_opt(i)>= (umax(i)+1) || u_opt(i)<= (umin(i)-1)
%             disp('INFEASIBLE')
%             n_infeasible = n_infeasible+1;
%             infeasible_index(n_infeasible) = i;
%             
%         end
%     end
%     
%     if n_infeasible == 0
%         u = u_opt;
%         lambda = zeros(1,n_u);
%         for i =1:n_c
%             for k =1:n_free
%                 d(i) = d(i) - A_free(i,k)*p_free(k);
%             end
%             for k =1:n_u
%                 lambda(k) = lambda(k)+A(i,k)*d(i);
%             end
%         end
%         break_flag = true;
%         disp(lambda)
%         for i = 1:n_u
%             lambda(i) = lambda(i)*W(i);
%             disp('check')
%             disp(lambda(i))
%             if lambda(i) < 0
%                 disp('check 2')
%                 break_flag = false;
%                 W(i) = 0;
% 
%                 if free_index_lookup(i) <0
%                     free_index_lookup(i) = n_free;
%                     free_index(n_free) = i;
%                     n_free =n_free +1;
%                 end
%             end
%         end
% 
%         if break_flag
%             output = iter;
%             break
%         end
%     else
%         
% 
%         alpha = inf;
%         alpha_tmp = 0;
%         id_alpha = 1;
% 
%         for i = 1:n_free
%             id=free_index(i);
%             disp('p(id)')
%             disp(p(id))
%             if abs(p(id))>1.1920928955078125e-7%0
%                 disp('alpha_check_true')
%                 disp(id)
%                 alpha_tmp = (p(id)<0)*(umin(id)-u(id))/p(id)+ (1-(p(id)<0))*(umax(id)-u(id))/p(id);
%                 disp(alpha_tmp)
%             else
%                 disp('alpha_check_false')
%                 disp(id)
%                 alpha_tmp = inf;
%             end
%             if abs(alpha_tmp) < alpha %ABSSSSSSS
%                 disp('alpha')
%                 disp(id)
%                 alpha =alpha_tmp;
%                 id_alpha = id;
%             end
%         end
%         
%         for i =1:n_u
%             u(i)=u(i)+alpha*p(i);
%         end
% 
% 
%         for i =1:n_c
%             for k =1:n_free
%                 d(i) = d(i) - A_free(i,k)*alpha*p_free(k);
%             end
%         end
%         disp('free index lookup')
%         disp(free_index_lookup)
%         disp(free_index)
%         disp(id_alpha)
% 
%         W(id_alpha) = (p(id_alpha)>0) *1 + (1- (p(id_alpha)>0)) * -1;
%         
%         disp('nfree')
%         disp(n_free)
%         free_index(free_index_lookup(id_alpha)) = free_index(n_free);
%         n_free = n_free -1;
%         free_index_lookup(free_index(free_index_lookup(id_alpha))) = free_index_lookup(id_alpha);
%         free_index_lookup(id_alpha) = -1 ;
%         
%     end 
%     output = -1;
%     
%     iter = iter +1;
% end
% if output == -1
%     disp('all saturated')
% else
%     disp('Great Sucscess')
%     disp(u_current+u)
% end






