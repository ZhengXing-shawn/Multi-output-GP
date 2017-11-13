function [Y_pred,Y_pred_var,r,option]=BEDM_conti(X_Train,Y_Train,X_pred,option)
% Multi-output Gaussian Process 
% Beyesian emualtion of Dynamic model(BEDM)
% 
% Description:
%     This Function is implementation of Multi-output Gaussian Process. The input
%     data X_Train, Y_Train are used to optimise r(hyperparameters) and then predict 
%     with the new input X_pred to gain Y_pred. Both X and Y could be multi dimensions.
% 
%     WARNING: If Number_Y < Dim_Y, then the result would possibly be wrong!!! 
%     
% Input:
%     X [Num_data x dim]    Training input data 
%     Y [Num_data x dim]    Training output data
%     X_pred [Num_data x dim]   Test/predict input data
% 
%     option      .Itr            Iteration time,default for 2000
%                 .r              Define good hypermeters would help to reduce the calculation time,default for ones vertor 
%                 .onlyPredict    Set 1 to pass the optimization and get prediction
%   
% 
% Output:
%     Y_pred [Num_data x dim]   Test/predict input data
%     r [1 x (X_dim + 1)]   save hyperparameters,used for predicting again without
%                       optimising 
%     
% see also
%     optimise_conti
%     multioutput_pred_conti
%     
% About:
%     Zheng Xing, 10/9/2017,First Edition
%     
% Reference:
%     Conti, Stefano, and Anthony O’Hagan. "Bayesian emulation of complex multi-output 
%     and dynamic computer models." Journal of statistical planning and inference 
%     140.3 (2010): 640-651.
    

%% Initialization and Parameters

% set_Train=size(X_Train,1);
% set_Test=size(X_pred,1);

% for i=1:set_Train
%     Y(i,:)=reshape(Y_Train(:,:,i),[],1);
% end

if ~isfield(option,'r')
    r=[ones(size(X_Train,2),1)' 0.1];   % Default hyperparameters if no r was define
end


X=X_Train;
Y=Y_Train;



%% optimise hyperparameters
if ~isfield(option,'onlyPredict') 
    if option.onlyPredict==1
        [r]=optimise_conti(r,X,Y,option);
    end
end

%% predict 
[Y_pred,Y_pred_var]=multioutput_pred_conti(r,X,Y,X_pred);
Y_pred=Y_pred';



end

