%Back Propagation Network for XOR function with Binary Input and Output
clc;
clear;
%Initialize weights and bias
v=[0.197 0.3191 -0.1448 0.3394;0.3099 0.1904 -0.0347 -0.4861];
v1=zeros(2,4);
b1=[-0.3378 0.2771 0.2859 -0.3329];
b2=-0.1401;
w=[0.4919;-0.2913;-0.3979;0.3581];
w1=zeros(4,1);
[hist_date, hist_high, hist_low, hist_open, hist_close, hist_vol]=get_hist_stock_data('INFY');
for i = 1:size(hist_high,1)
    hi(i)=(hist_high(i)-min(hist_high))/(max(hist_high)-min(hist_high));

end
for i = 1:size(hist_open,1)
    ho(i)=(hist_open(i)- min(hist_open))/(max(hist_open)-min(hist_open));
    
end
for i = 1:size(hist_close,1)
    
    hc(i)=(hist_close(i)-min(hist_close))/(max(hist_close)-min(hist_close));
    
end
for inpdata = 1:1000
x=[hc(inpdata) ho(inpdata) hc(inpdata+1)  ho(inpdata+1); hc(inpdata+2)  ho(inpdata+2) hc(inpdata+3)  ho(inpdata+3)];
t = [ hi(inpdata+1)  hi(inpdata+2)  hi(inpdata+3)  hi(inpdata+4)]';
alpha=0.02;
mf=0.9;
con=1;
epoch=0;
while con
    e=0;
    for I=1:4
        %Feed forward
        for j=1:4
            zin(j)=b1(j);
            for i=1:2
                zin(j)=zin(j)+x(i,I)*v(i,j);
            end
            z(j)=binsig(zin(j));
        end
        yin=b2+z*w;
        y(I)=binsig(yin);
        %Backpropagation of Error
        delk=(t(I)-y(I))*binsig1(yin);
        delw=alpha*delk*z'+mf*(w-w1);
        delb2=alpha*delk;
        delinj=delk*w;
        for j=1:4
            delj(j,1)=delinj(j,1)*binsig1(zin(j));
        end
        for j=1:4
            for i=1:2
                delv(i,j)=alpha*delj(j,1)*x(i,I)+mf*(v(i,j)-v1(i,j));
            end
        end
        delb1=alpha*delj;
        w1=w;
        v1=v;
        %Weight updation
        w=w+delw;
        b2=b2+delb2;
        v=v+delv;
        b1=b1+delb1';
        e=e+(t(I)-y(I))^2;
    end
    if e<0.05
        con=0;
    end
    epoch=epoch+1;
end
end
disp('BPN for XOR funtion with Binary input and Output');
disp('Total Epoch Performed');
disp(epoch);
disp('Error');
disp(e);
disp('Final Weight matrix and bias');
v
b1
w
b2
%Test data sets
x=[hc(2537) ho(2537) hc(2538)  ho(2538); hc(2539)  ho(2539) hc(2540)  ho(2540)];
for I=1:4
        %Feed forward
        for j=1:4
            zin(j)=b1(j);
            for i=1:2
                zin(j)=zin(j)+x(i,I)*v(i,j);
            end
            z(j)=binsig(zin(j));
        end
        yin=b2+z*w;
        out(I)=binsig(yin);
        y(I)=((binsig(yin))*(max(hist_high)-min(hist_high)))+min(hist_high);
end
y
o=[((hi(2539)*(max(hist_high)-min(hist_high)))+min(hist_high)) ((hi(2540)*(max(hist_high)-min(hist_high)))+min(hist_high)) ((hi(2541)*(max(hist_high)-min(hist_high)))+min(hist_high)) ((hi(2542)*(max(hist_high)-min(hist_high)))+min(hist_high))]'
t=[hi(2539) hi(2540) hi(2541) hi(2542)];

disp('Final MSE Error');
f_err=mse(t-out);
disp(f_err);

disp('Target and Prediction');
    disp(o');
    disp(y);
    
    disp('Pricce error');
     actual=o;
    er=(actual'-y);
    for i=1:4
        er(i)=er(i)/actual(i);
    end
    er=er*100;
    disp(er);
    
% t=[9 11 14 15];
% plotyy(y,t,o,t);
fileid=fopen('output_plot.txt','w');
fprintf(fileid,'TARGET \n');
fprintf(fileid,'%f  ',o);
fprintf(fileid,'\n PREDICTION \n');
fprintf(fileid,'%f  ',y);
fprintf(fileid,'\n ERROR \n');
fprintf(fileid,'%f  ',er);
fclose(fileid);
