function [Y,meanY]=central(Y)

num=size(Y,1);
meanY=mean(Y);
Y=Y-repmat(meanY,num,1);

end
