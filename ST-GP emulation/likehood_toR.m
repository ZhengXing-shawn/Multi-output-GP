function [L]=likehood_toR(r,X,Y,H)
% Likelyhood function refer to the multi-output Gaussian Process.
% Refer to Conti's paper for more details and know more about what A,H,G
% represent.
    


%% Initialise
    Dout=size(Y,2);
    num=size(X,1);
    Din=size(X,2);
    M=size(H,2);
    
%%  calculate L   
    A=kernelmatrix_conti(X,X,r);
    invA=inv(A);
    HtinvAH=H'*invA*H;
    invHtinvAH=inv(HtinvAH);
    G=invA-invA*H*invHtinvAH*H'*invA;
    
    lnr=0;      % calculate the complexity of hyperparameters
    for i=1:length(r)
        lnr=lnr+log(1+r(i)^2);        
    end
    
    detygy=det(Y'*G*Y);
    parameters_Trick=0.7;
%     L=-lnr  -Dout/2*logdet(A)  -Dout/2*logdet(HtinvAH)  -(num-M)/2*logdet(Y'*G*Y);

    L=-lnr  -Dout/2*log(det(A))  -Dout/2*log(det(HtinvAH))  -(num-M)/2*log(det(Y'*G*Y+eye(size(Y,2)).*parameters_Trick));
%     eye(size(Y,2)).*parameters_Trick is a trick form to solve the Inf/Nan problem

    L=-L;
    
    
end