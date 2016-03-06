%Bat algorithm implementation
tic
% function [best,fmin,N_iter]=bat_algorithm(para)
clear all
close all
clc
A=[20];
% Default parameters
para=[20 15 0.5 0.5]; 
n=para(1);      % Population size, typically 10 to 40
N_gen=para(2);  % Number of generations
A=para(3);      % Loudness  (constant or decreasing)
r=para(4); % Pulse rate (constant or decreasing)
% This frequency range determines the scalings
% You should change these values if necessary
Qmin=0;         % Frequency minimum
Qmax=2;   % Frequency maximum
% Iteration parameters
N_iter=0;       % Total number of function evaluations
% Dimension of the search variables
d=9;           % Number of dimensions 
objfun='nntrainBAT';
% Lower limit/bounds/ a vector
Lb=ones(1,d)*(-15);
% Upper limit/bounds/ a vector
Ub=ones(1,d)*15;
% Initializing arrays
Q=zeros(n,1);   % Frequency
v=zeros(n,d);   % Velocities
% Initialize the population/solutions
iter=0;
[hist_date, hist_high, hist_low, hist_open, hist_close, hist_vol]=get_hist_stock_data('ADP');
for i=1:n
  Sol(i,:)=Lb+(Ub-Lb).*rand(1,d);
%   Sol(i,:)=randn(1,d);
%   ObjVal=feval(objfun,Sol(i,:),hist_date, hist_high, hist_low, hist_open, hist_close, hist_vol,t, N_gen);
%   Fitness(i)=calculateFitness(ObjVal);
  Fitness(i)=feval(objfun,Sol(i,:),hist_date, hist_high, hist_low, hist_open, hist_close, hist_vol,5, 3);
end
% Find the initial best solution
[fmin,I]=min(Fitness);
best=Sol(I,:);
a=0.9;
y=0.9;
% Start the iterations  %
tol=0.005;
while(fmin > tol)
% Loop over all bats solutions
% for t=1:N_gen
%           A=a*A;
%           r(1)=rand;
%           r=r(1)*[1-expm(-y)];
        for i=1:n
%           A(t+1)=a*A(t);
%           r(1)=rand;
%           r(t+1)=r(1)*[1-expm(-y*t)];
          Q(i)=Qmin+(Qmin-Qmax)*rand;
%           if(t==2)
%           v(i,t)=v(i,t-1)+(Sol(i,t)+best)*Q(i);
%           end
          v(i,:)=v(i,:)+(Sol(i,:)-best)*Q(i);
%           S(i,t)=Sol(i,t-1)+v(i,t);
          S(i,:)=Sol(i,:)+v(i,:);
          
          % Apply simple bounds/limits
          Sol(i,:)=simplebounds(Sol(i,:),Lb,Ub);
          % Pulse rate
          if rand>r
          % The factor 0.01 limits the step sizes of random walks 
              Sol(i,:)=best+0.01*randn(1,d);
              e=2*rand+(-1);
              S(i,:)=S(i,:)+ e*A;
          end

     % Evaluate new solutions
%           ObjVal=feval(objfun,Sol(i,:),hist_date, hist_high, hist_low, hist_open, hist_close, hist_vol,N_iter, N_gen);
          Fnew=feval(objfun,Sol(i,:),hist_date, hist_high, hist_low, hist_open, hist_close, hist_vol,fmin, tol);
%           Fnew=calculateFitness(ObjVal);
           % Update if the solution improves, or not too loud
           if( (Fnew<=Fitness(i)) & (rand<A)) 
                Sol(i,:)=S(i,:);
                Fitness(i)=Fnew;
                A=A-1;
                r=r+1;
           end

          % Update the current best solution
          if Fnew<=fmin,
                best=S(i,:);
                fmin=Fnew;
          end
         
          
        end
        N_iter=N_iter+n;
        

end
% Output display
disp(['Number of evaluations: ',num2str(N_iter)]);
disp('Final Error=');
disp(fmin);
nntrainBAT(Sol(20,:),hist_date, hist_high, hist_low, hist_open, hist_close, hist_vol,fmin, tol);
% save test.mat 
toc


% function s=simplebounds(s,Lb,Ub)
%   % Apply the lower bound vector
%   ns_tmp=s;
%   I=ns_tmp<Lb;
%   ns_tmp(I)=Lb(I);
%   
%   % Apply the upper bound vector 
%   J=ns_tmp>Ub;
%   ns_tmp(J)=Ub(J);
%   % Update this new move 
%   s=ns_tmp;





