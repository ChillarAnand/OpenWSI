close all
clear
clc
% Step 1: Load feature points (Ground truth/distorted)
load('points.mat');
% Step 2: Reassign and match the feature points
[pointGT,pointDistort]=reAssignPoints(pointGT0,pointDistort0);
figure;
plot(pointGT(:,1),pointGT(:,2),'r*');hold on;
plot(pointDistort(:,1),pointDistort(:,2),'b*');
% Step 3: Distortion fitting
camHeight=3648;
camWidth=5472;
fitResult=distortFit(pointGT,pointDistort,camHeight,camWidth);
% Step 4: Distortion correction (Note: Please input a grayscale bayer image)
im=imread('05.tif');
tic
Idistorted = unDistort(im,fitResult.a,fitResult.b,camHeight,camWidth);
toc
im_unDistort=demosaic(uint8(gather(Idistorted)),'rggb');
figure;imshow(im,[]);title('Raw bayer image');
figure;imshow(im_unDistort,[]);title('Undistorted RGB image');