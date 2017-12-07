function [r]=optimise_conti(r,X,Y,option)
% Optimse hyperparameters in Multi-output Gaussian Process
% 
% Description:
%     Optimising bases on the matlab's Function [fmincon]
%     
% Input:
%     r   initial hyperparameters
%     X   Training input data
%     Y   Training output data
%     option.Itr Iteration times
%     
% Output:
%     r   optimised hyperparmeters
% 
% About:
%     Zheng Xing, 10/9/2017, First Edition



%% initialize 
num=size(X,1);

if ~isfield(option,'Itr')
    Itr=2000;
else
    Itr=option.Itr;
end
optionmin.MaxFunEvals = Itr;

if ~isfield(option,'H')
    for i =1:num
        H(i,:)=H_generate(X(i,:));
    end
else
    H=option.H;
end


%% Optimise

% r =fminunc('likehood_toR',r,option,X,Y,H);
r =fmincon('likehood_toR',r,[],[],[],[],[1e-10 1e-10],[1e5 1e5],[],optionmin,X,Y,H);


end