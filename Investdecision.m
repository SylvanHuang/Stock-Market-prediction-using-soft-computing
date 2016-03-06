clear all
close all
clc
% v=[50 40 30 50 30 24 36];
% w=[5 4 6 3 2 6 7];
% W=20;
N = 3;
W = input('Enter total amount available in Rs ');
while ~(~isempty(W)  && isnumeric(W) ...
            && isreal(W) ...
            && isfinite(W) ...
            && (W == fix(W)) ...
            && (W > 0))
    W = input('Enter total amount available in Rs ');
end
% weights = randint(1,N,[1 1000])
% values = randint(1,N,[1 100])
w=[80.68 58.55 76.78];
acnp=(78.51-80.68);
adpp=(57.39-58.55);
infyp=(77.92-76.78);
v=[acnp adpp infyp];
n=length(v);
% for i=1:n+1;
%     for j=1:W+1;
%         if(i==1 | j==1)
%             V(i,j)=0;
%         end
%     end
% end
% for i=2:n+1;
%     for j=2:W+1;
%         if(w(i-1)>=j)
%             V(i,j)=V(i-1,j);
%             else
%         a=[V(i-1,j) v(i-1)+V(i-1,j-w(i-1))];
%         V(i,j)=max(a);
%         if(V(i,j)==a(2))
%         s(i,j)=1;
%         else
%             s(i,j)=0;
%     end
%         end
%    
%     end
% end
% K=W+1;
% 
% for i=n+1:-1:2
%     if(s(i,K)==1)
%          p(i-1)=1;
%             K=K-w(i-1);
%     else
%         p(i-1)=0;
%     end
% end
for i=1:length(v)
    if v(i)<=0
        sol(i)=0;
    else
        sol(i)=1;
    end
end
%opt_value=V(n+1,W+1)
for i=1:length(sol)
    if sol(i) == 1
        fprintf('Invest in %d company\n',i);
    else
        fprintf('Donot invest in %d company\n',i);
    end
end  

for i=1:length(v)
    if sol(i) == 1
            updv(i)=v(i);
    else
            updv(i)=0;
    end
        
 end
for i=1:length(sol)
    if sol(i) == 1
        invest(i) = ((updv(i))/sum(updv))*W;
    else
        invest(i)=0;
    end   
end    
invest
for i=1:length(w)
    dummy =round( invest(i)/w(i));
    if dummy*w(i) <= invest(i)
       n_stock(i)=dummy;
    else
       n_stock(i)=floor( invest(i)/w(i));
    end   
end
n_stock
%Total profit calculation
for i=1:length(v)
    if sol(i) == 1
        profit(i)=n_stock(i)*v(i);
    else
        profit(i)=0;
    end
end
fprintf('Individual profits on investment in 3 companies\n');
profit
fprintf('Total profits on investment in 3 companies\n');
sum1=sum(profit)


fileid=fopen('output.txt','w');
    fprintf(fileid,'Company 1 = Accenture \n Company 2 = Infosys \n Company 3 = ADP \n');
    fprintf(fileid,'\n Invest Amount \n');
    fprintf(fileid,'%f  ',invest);
    fprintf(fileid,'\n Number of Stocks \n');
    fprintf(fileid,'%f  ',n_stock);
    fprintf(fileid,'\n Individual profit \n');
    fprintf(fileid,'%f  ',profit);
    fprintf(fileid,'\n Total profit \n');
    fprintf(fileid,'%f  ',sum1);
    fclose(fileid);