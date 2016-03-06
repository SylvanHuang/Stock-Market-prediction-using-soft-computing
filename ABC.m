tic
clear all
close all
clc
%Here objective function is weight matrix of neural network
%Update weight matrix using ABC algorithm
tol=0.005;
CS=50; % The number of colony size (employed bees+onlooker bees)
FoodNumber=CS/2; %The number of food sources equals the half of the colony size. Also is no of solutions for problem
maxCycle=15; %The number of cycles for foraging {a stopping criteria}



objfun='nntrainABC'; %cost function to be optimized
D=9; %The number of parameters of the problem to be optimized
ub=ones(1,D)*10; %lower bounds of the parameters. Between range 10 and -10
lb=ones(1,D)*(-10);%upper bound of the parameters.
limit=FoodNumber*D; %A food source which could not be improved through "limit" trials is abandoned by its employed bee
runtime=1;%Algorithm can be run many times 



%Foods [FoodNumber][D]; /*Foods is the population of food sources. Each row of Foods matrix is a vector holding D parameters to be optimized. The number of rows of Foods matrix equals to the FoodNumber*/
%ObjVal[FoodNumber];  /*f is a vector holding objective function values associated with food sources */
%Fitness[FoodNumber]; /*fitness is a vector holding fitness (quality) values associated with food sources*/
%trial[FoodNumber]; /*trial is a vector holding trial numbers through which solutions can not be improved*/
%prob[FoodNumber]; /*prob is a vector holding probabilities of food sources (solutions) to be chosen*/
%solution [D]; /*New solution (neighbour) produced by v_{ij}=x_{ij}+\phi_{ij}*(x_{kj}-x_{ij}) j is a randomly chosen parameter and k is a randomlu chosen solution different from i*/
%ObjValSol; /*Objective function value of new solution*/
%FitnessSol; /*Fitness value of new solution*/
%neighbour, param2change; /*param2change corrresponds to j, neighbour corresponds to k in equation v_{ij}=x_{ij}+\phi_{ij}*(x_{kj}-x_{ij})*/
%GlobalMin; /*Optimum solution obtained by ABC algorithm*/
%GlobalParams[D]; /*Parameters of the optimum solution*/
%GlobalMins[runtime]; /*GlobalMins holds the GlobalMin of each run in multiple runs*/

GlobalMins=zeros(1,runtime);%Global Mins will store errors of each runtime

for r=1:runtime
  
% /*All food sources are initialized */
%/*Variables are initialized in the range [lb,ub]. If each parameter has different range, use arrays lb[j], ub[j] instead of lb and ub */
iter=1;
Range = repmat((ub-lb),[FoodNumber 1]);
Lower = repmat(lb, [FoodNumber 1]);
Foods = rand(FoodNumber,D) .* Range + Lower;
[hist_date, hist_high, hist_low, hist_open, hist_close, hist_vol]=get_hist_stock_data('ADP');
ObjVal=feval(objfun,Foods,hist_date, hist_high, hist_low, hist_open, hist_close, hist_vol,GlobalMins, tol);
Fitness=calculateFitness(ObjVal);


%reset trial counters
trial=zeros(1,FoodNumber);

%/*The best food source is memorized*/
BestInd=find(ObjVal==min(ObjVal));%Find the minimum objvalue from ObjVal matrix. Returns location of minimum element
BestInd=BestInd(end);
GlobalMin=ObjVal(BestInd);%Error is returned
GlobalParams=Foods(BestInd,:);

while ((GlobalMin >= tol)),

% EMPLOYED BEE PHASE 
    for i=1:(FoodNumber)
        
        %/*The parameter to be changed is determined randomly*/
        Param2Change=fix(rand*D)+1;
        
        %/*A randomly chosen solution is used in producing a mutant solution of the solution i*/
        neighbour=fix(rand*(FoodNumber))+1;
       
        %/*Randomly selected solution must be different from the solution i*/        
            while(neighbour==i)
                neighbour=fix(rand*(FoodNumber))+1;
            end;
        
       sol=Foods(i,:);
       %  /*v_{ij}=x_{ij}+\phi_{ij}*(x_{kj}-x_{ij}) */
       sol(Param2Change)=Foods(i,Param2Change)+(Foods(i,Param2Change)-Foods(neighbour,Param2Change))*(rand-0.5)*2;
        
       %  /*if generated parameter value is out of boundaries, it is shifted onto the boundaries*/
        ind=find(sol<lb);
        sol(ind)=lb(ind);
        ind=find(sol>ub);
        sol(ind)=ub(ind);
        
        %evaluate new solution
        ObjValSol=feval(objfun,sol,hist_date, hist_high, hist_low, hist_open, hist_close, hist_vol, GlobalMin, tol);
        FitnessSol=calculateFitness(ObjValSol);
        
       % /*a greedy selection is applied between the current solution i and its mutant*/
       if (FitnessSol>Fitness(i)) %/*If the mutant solution is better than the current solution i, replace the solution with the mutant and reset the trial counter of solution i*/
            Foods(i,:)=sol;
            Fitness(i)=FitnessSol;
            ObjVal(i)=ObjValSol;
            trial(i)=0;
        else
            trial(i)=trial(i)+1; %/*if the solution i can not be improved, increase its trial counter*/
       end;
         
         
    end;
% CalculateProbabilities 
%/* A food source is chosen with the probability which is proportioal to its quality*/
%/*Different schemes can be used to calculate the probability values*/
%/*For example prob(i)=fitness(i)/sum(fitness)*/
%/*or in a way used in the metot below prob(i)=a*fitness(i)/max(fitness)+b*/
%/*probability values are calculated by using fitness values and normalized by dividing maximum fitness value*/

prob=(0.9.*Fitness./max(Fitness))+0.1;
  
% ONLOOKER BEE PHASE 

i=1;
t=0;
while(t<FoodNumber)
    if(rand<prob(i))
        t=t+1;
        %/*The parameter to be changed is determined randomly*/
        Param2Change=fix(rand*D)+1;
        
        %/*A randomly chosen solution is used in producing a mutant solution of the solution i*/
        neighbour=fix(rand*(FoodNumber))+1;
       
        %/*Randomly selected solution must be different from the solution i*/        
            while(neighbour==i)
                neighbour=fix(rand*(FoodNumber))+1;
            end;
        
       sol=Foods(i,:);
       %  /*v_{ij}=x_{ij}+\phi_{ij}*(x_{kj}-x_{ij}) */
       sol(Param2Change)=Foods(i,Param2Change)+(Foods(i,Param2Change)-Foods(neighbour,Param2Change))*(rand-0.5)*2;
        
       %  /*if generated parameter value is out of boundaries, it is shifted onto the boundaries*/
        ind=find(sol<lb);
        sol(ind)=lb(ind);
        ind=find(sol>ub);
        sol(ind)=ub(ind);
        
        %evaluate new solution
        ObjValSol=feval(objfun,sol,hist_date, hist_high, hist_low, hist_open, hist_close, hist_vol,GlobalMin,tol);
        FitnessSol=calculateFitness(ObjValSol);
        
       % /*a greedy selection is applied between the current solution i and its mutant*/
       if (FitnessSol>Fitness(i)) %/*If the mutant solution is better than the current solution i, replace the solution with the mutant and reset the trial counter of solution i*/
            Foods(i,:)=sol;
            Fitness(i)=FitnessSol;
            ObjVal(i)=ObjValSol;
            trial(i)=0;
        else
            trial(i)=trial(i)+1; %/*if the solution i can not be improved, increase its trial counter*/
       end;
    end;
    
    i=i+1;
    if (i==(FoodNumber)+1) 
        i=1;
    end;   
end; 


%/*The best food source is memorized*/
         ind=find(ObjVal==min(ObjVal));
         ind=ind(end);
         if (ObjVal(ind)<GlobalMin)
         GlobalMin=ObjVal(ind);
         GlobalParams=Foods(ind,:);
         end;
         
         
% SCOUT BEE PHASE 

%/*determine the food sources whose trial counter exceeds the limit value. 


ind=find(trial==max(trial));
ind=ind(end);
if (trial(ind)>limit)
    Bas(ind)=0;
    sol=(ub-lb).*rand(1,D)+lb;
    ObjValSol= feval(objfun,sol,hist_date, hist_high, hist_low, hist_open, hist_close, hist_vol,GlobalMin,tol);
    FitnessSol=calculateFitness(ObjValSol);
    Foods(ind,:)=sol;
    Fitness(ind)=FitnessSol;
    ObjVal(ind)=ObjValSol;
end;




fprintf('Iter=%d Error=%g\n',iter,GlobalMin);
iter=iter+1;

end % End of ABC
 if(GlobalMin<=tol)
    feval(objfun,sol,hist_date, hist_high, hist_low, hist_open, hist_close, hist_vol,GlobalMin,tol); 
 end   
GlobalMins(r)=GlobalMin;
end; %end of runs
toc