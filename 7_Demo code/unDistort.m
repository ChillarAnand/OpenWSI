function im = unDistort(im,ax,bx,camHeight,camWidth)
% function for distortion correction in OpenWSI
% Input: Idistorted -> grayscale distorted bayer image 
%        ax,bx -> distortion index by fitting 
%        camHeight,camWidth -> camera pixel number
% Output: distortion fixed bayer image
fx = 1;
fy = 1;
cx = camWidth/4;
cy = camHeight/4;
k1 = ax;
k2 = bx;


K = [fx 0 cx; 0 fy cy; 0 0 1];
im=gpuArray(single(im));
imDecomp=gpuArray(zeros(size(im,1)/2,size(im,2)/2,4,'single'));
% Decompose the bayer image into 4 channels (R/G/G/B)
imDecomp(:,:,1)=im(1:2:end,1:2:end);
imDecomp(:,:,2)=im(2:2:end,1:2:end);
imDecomp(:,:,3)=im(1:2:end,2:2:end);
imDecomp(:,:,4)=im(2:2:end,2:2:end);

I = gpuArray(zeros(size(imDecomp,1),size(imDecomp,2),'single'));
[i,j] = find(~isnan(I));

% Xp = the xyz vals of points on the z plane
Xp = inv(K)*[j i ones(length(i),1)]';

% Calculate the forward map of the distortion
r2 = Xp(1,:).^2+Xp(2,:).^2;
x = Xp(1,:);
y = Xp(2,:);

x = x.*(1+k1*r2 + k2*r2.^2);
y = y.*(1+k1*r2 + k2*r2.^2);

% Distorted coordidnates
u = reshape(x + cx,size(I));    
v = reshape(y + cy,size(I));

% Perform backward mapping to undistort the image coordinates
for i=1:size(imDecomp,3)
imDecomp(:,:,i) = interp2(imDecomp(:,:,i), u, v,'nearest');
end
im(1:2:end,1:2:end)=imDecomp(:,:,1);
im(2:2:end,1:2:end)=imDecomp(:,:,2);
im(1:2:end,2:2:end)=imDecomp(:,:,3);
im(2:2:end,2:2:end)=imDecomp(:,:,4);
end