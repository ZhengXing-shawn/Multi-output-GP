
format long

clear;
% global USE_GAMMA_PRIOR  % gamma prior for dynamics, only works with RBF kernel
% global GAMMA_ALPHA % defines shape of the gamma prior
% global USE_LAWRENCE % fix dynamics HPs, as Lawrence suggested (use with thetad = [0.2 0.01 1e6];) 
% global FIX_HP % fix all HPs
% global MARGINAL_W % marginalize over W while learning X
% global MARGINAL_DW % marginalize over scale in dynamics while learning X
% global LEARN_SCALE % use different scales for different output dimensions
% global REMOVE_REDUNDANT_SCALE % let W absorb the overall scale of reconstruction
% global W_VARIANCE % kappa^2 in the paper, not really the variance though
% global M_CONST % M value in Jack's master's thesis
% global BALANCE % Constant in front of dynamics term, set to D/q for the B-GPDM
% global SUBSET_SIZE % Number of data to select for EM, set -1 for all data. 
% global USE_OLD_MISSING_DATA
% 
% M_CONST = 1; 
% REMOVE_REDUNDANT_SCALE = 0 ;
% LEARN_SCALE = 1; 
MARGINAL_W = 0; 
% MARGINAL_DW = 0; 
% W_VARIANCE = 0; 
% FIX_HP = 0; 
% USE_GAMMA_PRIOR = 0; 
% GAMMA_ALPHA = [5 10 2.5]; 
% USE_LAWRENCE = 0;
% BALANCE = 1;                  % p(x|alpha) weight in likehood contrast with p(y|x,beta)
% SUBSET_SIZE = -1; 


opt = foptions;
opt(1) = 1;
opt(9) = 0;
if MARGINAL_W == 1
    opt(14) = 100; % total number of iterations
    extItr = 1; 
else
    opt(14) = 10; % rescaling every 10 iterations
    extItr =10; % do extItr*opt(14) iterations in total
end 

load('data.mat')

setall=size(sample,2);
% test=round(setall/10);
test=50;
set=setall-test;
y_length=size(hRecord,1);
X=sample(:,1:set)';
% time_tr=size(hRecord,2);

for i=1:set
    Y(i,:)=reshape(hRecord(1:101,:,i),[],1);
end

%% initial 



cov='cotilikehood';
grad='contigradient';
X=X;
Y=Y;
[Y,meanY]=central(Y);
r=[1,1];           % length equal to x dimension
Itr=1000;
[r]=optimise_conti(r,X,Y,Itr);

X_pred=sample(:,set-3:set)';
[Y_pred]=multioutput_pred_conti(r,X,Y,X_pred);
Y_pred=Y_pred+repmat(meanY,size(Y_pred,1),1);
Y=Y+repmat(meanY,size(Y,1),1);
% time_tr=100;
% test=4;
% for i=1:test
%     for t=1:time_tr
%         figure(1)
%         plot(1:101,Y_pred(i,1+(t-1)*101:101+(t-1)*101),'--')
%         hold on
%         plot(1:101,hRecord(:,t,set-3+i-1),'-')
%         title(sprintf('set=%i time=%i',i,t))
%         hold off
%         drawnow
%         pause(0.1)
%     end
% end