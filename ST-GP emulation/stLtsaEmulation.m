% function [] = stLtsaEmulation()
% 1d Spatial-temporial data generation using 1D Richard1d solver funtion.
% with heterogeneous permeability field as inputs.
% load data by Richard1dDataGen_Script() and run LTSA+ temporal emulation
%
% Input parameters:
%
% Output parameters:
%
% Examples:
%
% See also: 
% Author:   Wei Xing
% History:  02/09/2017 create
clear
close all
%%
filename='/Users/Wayne/Desktop/stgp-Data/data';
load(filename)



%% Define Train & Test data
num_set=size(hRecord,3);
TrainTestradio=0.8;
num_Test=round(num_set*TrainTestradio);
num_Train=num_set-num_Test;
num_Time=size(hRecord,2);
X_Train=sample(:,1:num_Train)';
Y_Train=hRecord(:,:,1:num_Train);
X_Test=sample(:,num_set-num_Test:num_set)';
Y_Test=hRecord(:,:,num_set-num_Test:num_set);


%% LTSA
options.neighbor=10;
options.new_dim=5;

Y_Train=reshape(Y_Train,[nZ,nTime*num_Train]);
[T_Train,model] = LTSA( Y_Train',options );

[Y_TrainStar,model_2] = LTSA_preimage3( T_Train,model );
Y_TrainStar=reshape(Y_TrainStar,[nZ,nTime,num_Train]);


%% GP

%     T_pred=BEDM_conti(X_Train,T_Train,X_Test);
%     
%     [Y_pred,model_3] = LTSA_preimage3( T_pred,model);
%     Y_pred = reshape(Y_pred,[nz,nTime,num_Test]); 

%% Compare Plot
ifPlot=1;
if ifPlot==1

nZShow=100;
zShow=1:round(nZ/nZShow):nZ;
for t=1:1:nTime
    figure(1)
    plot(squeeze( Y_Train(zShow,t,:)),'-')
    ylim([-80,20])
    hold on 
    plot(squeeze( Y_TrainStar(zShow,t,:)),'--')
    hold off
    
    title(sprintf('time=%i',t))
%     legend('All KL basis','Truncation KL basis')
    drawnow
%     frame(t)=getframe;    %comment to save cpu time and memory
end

end



















%% Auxiliary function
% function [n]=energy2n(allEigenvalues,energy)
% KlEnergy=diag(klEigenValue);
% cumulatedKlEnergy= cumsum(allEigenvalues)./sum(energy);
% [~,n]=min(abs(cumulatedKlEnergy-klEnergyKeep));
% end