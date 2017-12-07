function [A]=kernelmatrix_conti(X,X2,r)

    num1=size(X,1);
    num2=size(X2,1);
    Din=size(X,2);

    for i=1:num1
        for j=1:num2
            A(i,j)=exp(- (X(i,:)-X2(j,:))*diag(r(1:end-1))*(X(i,:)-X2(j,:))');            
        end
    end
    if size(X,1)==size(X2,1)
        if X==X2
        A=A+eye(size(X,1))*r(end);
%         A=A+eye(size(X,1))*0.05;
        end
    end
        A=A.*0.5;
end