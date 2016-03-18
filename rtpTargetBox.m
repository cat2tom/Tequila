function [ boxMask ] = rtpTargetBox(phantomSlice)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% figure
h = figure;
set(h,'menubar','none','numbertitle','off','Pointer','crosshair')

%imagesc(phantomSlice);
imshow(mat2gray(phantomSlice));
title('Please, double-click to create a selection');

% freehand
%h1 = imfreehand;

% poly
%h1 = imrect;
h1 = impoly;
%h1 = imellipse;
pos = wait(h1);

% binary mask
boxMask = createMask(h1);

close(h);

end

