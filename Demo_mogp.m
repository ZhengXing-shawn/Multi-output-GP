% Demo for multi-output Gaussian process
%   This demo runs the multi-output GP code for the RichardPoFlow 1d problem. 
% The computation is simplfied with a PCA code(linear dimension reduction),
% Removing the PCA code will delay the computing time but will improve the 
% precision.
%   The result is shown compared with the original data. 
%
% Input parameters:
%       X_Train         using for training model (optimise r)
%       Y_Train         using for training model 
%       X_Test          using to predict
%       Y_Test          using to predict
%       num_Train       number of train data, fitted with X_Train/Y_Train
%       num_Test        number of test data, fitted with X_Test/Y_Test
%
% Output parameters:
%       Y_predStar      prediction based on the optimesd r and the test dat
%       r               (available) using to predict without repeating optimising 

% Author:   Zheng Xing
% History:  02/09/2017 create
%           07/12/2017 update


clear
close all
%%
filename='/Users/lumian/Desktop/stgp-Data/data';
% filename='/Users/lumian/Desktop/stgp-Data/350Tr_20Te_3nKl_05timestep_R.mat';
load(filename)


%% Define Train & Test data
num_set=size(hRecord,3);
% TrainTestradio=0.05;
% num_Test=round(num_set*TrainTestradio);
% num_Train=num_set-num_Test;
num_Train=350;
num_Test=20; 
nkl=size(sample,1);
Timesteps=size(hRecord,2);
X_Train=sample(:,1:num_Train)';
Y_Train=hRecord(:,:,1:num_Train);
X_Test=sample(:,num_set-num_Test:num_set)';
Y_Test=hRecord(:,:,num_set-num_Test:num_set);
BEDMoption=[];
% BEDMoption.Itr=2000;      % option could be default
% BEDMoption.r=[ones(size(X_Train,2),1)' 0.1]; 
% BEDMoption.onlyPredict=1;


%% PCA
EnergyKeepRatio=0.99;
[basis,eigValue,~]=svd(reshape(Y_Train,[nZ,nTime*num_Train]),'econ');

Energy=diag(eigValue);
cumulatedKlEnergyRatio= cumsum(Energy)./sum(Energy);
[~,nPca]=min(abs(cumulatedKlEnergyRatio-EnergyKeepRatio));

basis=basis(:,1:nPca);


%% Get latent z
% Z=pagefun(@mtimes,basis,hRecord);   %CUDA accerate

for i =1:num_Train
    zY_Train(:,:,i)=basis'*Y_Train(:,:,i);    
    Y_TrainStar(:,:,i)=basis*zY_Train(:,:,i);
end


%% Dependent GP 
% for i=1;
%     zY_pred(:,:,:)=BEDM_conti(X_Train,zY_Train(:,:,:),X_Test);
% end
%     
% dim_z=size(zY_Train,1);
% for i=1:size(zY_pred,2)
%     for t=1:num_Time
%         zY_predtemp(:,t,i)= zY_pred(1+(t-1)*dim_z:t*dim_z,i);
%     end
% end
%         
% for i =1:size(zY_predtemp,3)
%     Y_predStar(:,:,i)=basis*zY_predtemp(:,:,i);    
% end


%% Independent GP
h=waitbar(0,'GP progress');

for i=1:nPca
    zY_Train_reshape=[];
    zY_Train_reshape(:,:)=zY_Train(i,:,:);
    zY_Train_reshape=zY_Train_reshape';
    
    [zY_pred(i,:,:),zY_pred_var(i,:,:,:),r,BEDMoption]=BEDM_conti(X_Train,zY_Train_reshape,X_Test,BEDMoption);
    waitbar(i/nPca)
end
close(h)

for i =1:size(zY_pred,3)
    Y_predStar(:,:,i)=basis*zY_pred(:,:,i);    
end

%% UQ precess

for i=1:size(Y_predStar,3)
    mean_YpredStar = mean(Y_predStar,3);
    var_YpredStar = std(Y_predStar,0,3);
    mid_YpredStar = median(Y_predStar,3);

    mean_YTest = mean(Y_Test,3);
    var_YTest = std(Y_Test,0,3);
    mid_YTest = median(Y_Test,3);

end



%% Compare Plot
iPlot=1;
if iPlot==1
    nZShow=size(Y_Test,1);
%     nZShow=100;
    zShow=1:round(nZ/nZShow):nZ;
    for t=1:1:nTime
%     figure(1)
%     plot(squeeze( Y_Train(zShow,t,:)),'-')
%     ylim([-80,20])
%     hold on 
%     plot(squeeze( Y_TrainStar(zShow,t,:)),'--')
%     hold off
    
        figure(2)
        plot(squeeze( Y_Test(zShow,t,:)),'-')
        xlim([0,105])
        ylim([-70,-10])
        hold on
        plot(squeeze( Y_predStar(zShow,t,:)),'--')
        hold off
        
        title(sprintf('time=%i',t))
%     legend('All KL basis','Truncation KL basis')
        drawnow
%     frame(t)=getframe;    %comment to save cpu time and memory

        frame=getframe;
        im=frame2im(frame);
        [I,map]=rgb2ind(im,256);
        if t==1
            imwrite(I,map,'ex.gif','gif','Loopcount',1,'DelayTime',0.05);
        else
            imwrite(I,map,'ex.gif','gif','WriteMode','append','DelayTime',0.05);  
        end
    end


    
elseif iPlot==2
    
    nZShow=size(Y_Test,1);
    zShow=1:round(nZ/nZShow):nZ;
    for t=1:1:nTime
        figure(3)
        errorbar(zShow,mean_YTest(zShow,t),var_YTest(zShow,t),'-')
        hold on 
        plot(zShow,mid_YTest(zShow,t),'-')
        hold on
        errorbar(zShow,mean_YpredStar(zShow,t),var_YpredStar(zShow,t),'--')
        hold on 
        plot(zShow,mid_YpredStar(zShow,t),'--')
        hold off
        
        title(sprintf('Mean Variance and Median @t=%i nkl=%i tr=%i',t,nkl,num_Train))
        
        drawnow
          
        frame=getframe;
        im=frame2im(frame);
        [I,map]=rgb2ind(im,256);
        if t==1
            imwrite(I,map,'ex.gif','gif','Loopcount',1,'DelayTime',0.05);
        else
            imwrite(I,map,'ex.gif','gif','WriteMode','append','DelayTime',0.05);  
        end
        
    end  
    
end

