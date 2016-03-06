
function [Employers Obj Fit Bas]= ScoutSelection(ABCOpts,employers,Bas,xd)
Employers=employers;
ind=find(Bas==max(Bas));
ind=ind(end);
if (Bas(ind)>ABCOpts.Limit)
Bas(ind)=0;
Employers(ind,:)=(ABCOpts.ub-ABCOpts.lb)*(0.5-rand(1,ABCOpts.Dim))*2;%+ABCOpts.lb;
%message=strcat('burada',num2str(ind))
end;
[Obj Fit]=evaluate(Employers,ABCOpts,xd);


