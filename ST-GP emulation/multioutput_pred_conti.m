function [Y_pred,Y_pred_var]=multioutput_pred_conti(r,X,Y,X_pred)

    n=size(X,1);
    
for i=1:n
    H(i,:)=H_generate(X(i,:));
end
    m=size(H,2);
    
    A=kernelmatrix_conti(X,X,r);
    invA=inv(A);


% Bgls=inv(H'*invA*H+eye(size(H,2)).*0.01)*H'*invA*Y;                  %%%
Bgls=inv(H'*invA*H)*H'*invA*Y;
HtinvAH=H'*invA*H;
invHtinvAH=inv(HtinvAH);

num_pred=size(X_pred,1);

for i=1:num_pred
    hpredx=[1 X_pred(i,:)];
    tx=kernelmatrix_conti(X_pred(i,:),X,r);
    Y_pred(i,:)=Bgls'*hpredx'+(Y-H*Bgls)'*invA*tx';
    
    SigmaGLS= (n-m)^-1 * (Y-H*Bgls)'*invA*(Y-H*Bgls);
    c=kernelmatrix_conti(X_pred(i,:),X_pred(i,:),r);
    cStar=c-tx*invA*tx';
    cDoubleStar=cStar+(hpredx'-H'*invA*tx')' *invHtinvAH *(hpredx'-H'*invA*tx');
    Y_pred_var(i,:,:)=cDoubleStar*SigmaGLS;
end



end
