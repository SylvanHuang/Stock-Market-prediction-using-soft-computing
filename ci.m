PREDICTION_ACN_ABC=[85.758147  85.758052  85.758406  85.758010];
PREDICTION_ACN_BAT=[85.816855  85.816855  85.816855  85.816855];

PREDICTION_INFY_ABC=[51.825106  51.512957  49.854772  51.096708];
PREDICTION_INFY_BAT=[56.327736  55.529116  53.745463  53.836576];

PREDICTION_ADP_ABC=[83.087548  83.050852  83.149433  83.179130];
PREDICTION_ADP_BAT=[83.101133  83.152984  82.591069  82.139787];

for i=1:4
AVG_ACN(i)= (PREDICTION_ACN_ABC(i)+PREDICTION_ACN_BAT(i))/2;
AVG_INFY(i)= (PREDICTION_INFY_ABC(i)+PREDICTION_INFY_BAT(i))/2;
AVG_ADP(i)= (PREDICTION_ADP_ABC(i)+PREDICTION_ADP_BAT(i))/2;
end

disp('Accenture Prediction:');
disp(AVG_ACN);

disp('Infosys Prediction:');
disp(AVG_INFY);

disp('ADP Prediction:');
disp(AVG_ADP);

fileid=fopen('output.txt','w');
fprintf(fileid,'ACCENTURE \n');
fprintf(fileid,'%f  ',AVG_ACN);
fprintf(fileid,'\n INFOSYS \n');
fprintf(fileid,'%f  ',AVG_INFY);
fprintf(fileid,'\n ADP \n');
fprintf(fileid,'%f  ',AVG_ADP);
fclose(fileid);