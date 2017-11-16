function [y_hat] = testVariable(num)
global modely
global yval
trn_data.X = load('trn_data.txt');
trn_data.y = load('trn_y.txt');

fname = sprintf('exp%d.txt', num);
tst_data.X = load(fname);
tst_data.y = load('exp_res.txt');

% Scale the data
[trn_data, tst_data, jn2] = scaleSVM(trn_data, tst_data, trn_data, 0, 1);


% MSE for test samples
[y_hat] = svmpredict(tst_data.y, tst_data.X, modely);
%modely
%size(y_hat)
%length(tst_data.y)
MSE_Test = mean((y_hat - tst_data.y).^2);
NRMS_Test = sqrt(MSE_Test) / std(tst_data.y);
%for i=1:size(tst_data.y,1)
%   disp([num2str(y_hat(i)) '       ' num2str(tst_data.y(i))]);
%end

%{
% MSE for training samples
[y_hat, AccTrain, projection] = svmpredict(trn_data.y, trn_data.X, model);
MSE_Train = mean((y_hat-trn_data.y).^2);
NRMS_Train = sqrt(MSE_Train) / std(trn_data.y);



t = timer('TimerFcn', 'stat=false; disp(''Timer!'')',... 
                 'StartDelay',10);
start(t)
k =0;
stat=true;
while(stat==true)
  disp('k')
  k= k+1
  pause(1)
end
%}

%trn_data.y



%MSE_Test
%AccTest
% not understood
X = 1:1:30;
X = X';
y = ones(length(X), 1);
y_est = svmpredict(y, X, modely);

arr = [];
for i=1:length(tst_data.y)
    arr = [arr i];
end
arr = arr';
yval = y_hat;
%size(tst_data.y)
%size(arr)
%size(y_hat)
h = plot(arr, y_hat, 'b*');

legend('Y(mm) vs Readings(0.02s)');
y1 = max([trn_data.y]);
y2 = min([trn_data.y]);
axis([1 500 y2 y1]);
%filename = 'exp_results_y.xls';

fileID = fopen('exp_results_y.txt','a');
fprintf(fileID, '%f\n', yval);
fclose(fileID);
%xlRange = 'A1';
%sheet = 1;
%xlswrite(filename, tst_data.y, sheet, xlRange);
%xlRange = 'B1';
%xlswrite(filename, y_hat, sheet, xlRange)
