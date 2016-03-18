function [ doseMask ] = rtpTargetDose(phantomSlice)
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
h1 = impoly;
pos = wait(h1);

% binary mask
doseMask = createMask(h1);

close(h);

end

