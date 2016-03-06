function ObjVal = nntrainABC(Chrom,~, hist_high, hist_low, hist_open, hist_close, hist_vol,Error,maxError)
[Nind Nvar]=size(Chrom);
for i = 1:size(hist_high,1)
    hi(i)=(hist_high(i)-min(hist_high))/(max(hist_high)-min(hist_high));
    ho(i)=(hist_open(i)- min(hist_open))/(max(hist_open)-min(hist_open));
    hc(i)=(hist_close(i)-min(hist_close))/(max(hist_close)-min(hist_close));
    
end
for k=1:1000
trin=[hc(k) ho(k); hc(k+2)  ho(k+2); hc(k+4)  ho(k+4); hc(k+6)  ho(k+6)];
trout = [ hi(k+1)  hi(k+3)  hi(k+5)  hi(k+7)]';
inp=size(trin,2);
out=size(trout,2);
hidden=2;

for i=1:Nind
    
x=Chrom(i,:);

    iw = reshape(x(1:hidden*inp),hidden,inp);
    b1 = reshape(x(hidden*inp+1:hidden*inp+hidden),hidden,1);
    lw = reshape(x(hidden*inp+hidden+1:hidden*inp+hidden+hidden*out),out,hidden);
    b2 = reshape(x(hidden*inp+hidden+hidden*out+1:hidden*inp+hidden+hidden*out+out),out,1);
    
    y = logsig(logsig(trin*iw'+repmat(b1',size(trin,1),1))*lw'+repmat(b2',size(trin,1),1));


    ObjVal(i)=mse(trout-y);
    

end;
end
if(Error<=maxError)
    iw
    b1
    lw
    b2
   %Test data
    trin=[hc(2537) ho(2537); hc(2538)  ho(2538); hc(2539)  ho(2539); hc(2540)  ho(2540)];
    y = logsig(logsig(trin*iw'+repmat(b1',size(trin,1),1))*lw'+repmat(b2',size(trin,1),1));
    o=y';
    for i=1:4
   o(i)=(o(i)*(max(hist_high)-min(hist_high)))+min(hist_high);
    end
    o
    t=[((hi(2538)*(max(hist_high)-min(hist_high)))+min(hist_high)) ((hi(2539)*(max(hist_high)-min(hist_high)))+min(hist_high)) ((hi(2540)*(max(hist_high)-min(hist_high)))+min(hist_high)) ((hi(2541)*(max(hist_high)-min(hist_high)))+min(hist_high))]'
    tar=[hi(2538) hi(2539) hi(2540) hi(2541)];
    
    disp('MSE of normalized data');
    f_error=mse(tar'-y);
    disp(f_error);
    
    disp('Target and Prediction');
    disp(t');
    disp(o);
    
    disp('Pricce error');
     actual=t';
    er=(actual-o);
    for i=1:4
        er(i)=er(i)/actual(i);
    end
    er=er*100;
    disp(er);
         
    fileid=fopen('output.txt','w');
    fprintf(fileid,'TARGET \n');
    fprintf(fileid,'%f  ',t);
    fprintf(fileid,'\n PREDICTION \n');
    fprintf(fileid,'%f  ',o);
    fprintf(fileid,'\n ERROR \n');
    fprintf(fileid,'%f  ',er);
    fclose(fileid);
   
end




