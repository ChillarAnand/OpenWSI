function [pointGT,pointDistort]=reAssignPoints(pointGT0,pointDistort0)
% Function to match points between the ground truth and distorted image
% Input: all points of the ground truth and distorted image
% Output: matched pairs of the ground truth and distorted points
pointNum=floor(size(pointGT0,1)); % Number of points
pointDistort=zeros(pointNum,2); 
pointGT=zeros(pointNum,2);
for iNum=1:size(pointGT,1)
    circleDis=abs(pointGT0(:,1)-pointDistort0(iNum,1)).^2+abs(pointGT0(:,2)-pointDistort0(iNum,2)).^2;
    circleLoc=find(circleDis==min(circleDis));
    pointDistort(iNum,:)=pointDistort0(iNum,:);
    pointGT(iNum,:)=pointGT0(circleLoc,:);
end
end