function [ rtpBeam, radiationType] = rtpSampleBeam( gridSize, decayConstant, radiationType )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% grid
rtpIsoBeam = zeros(gridSize);
ym = gridSize/2;
xm = gridSize/2;

% region
w_region = xm-xm/4:xm+xm/4;
w_size = length(xm-xm/4:xm+xm/4);

% exponencial simulation
exp_length = 1:gridSize;
exp_decay = decayConstant;

%I(:, x_center-x_center/2:x_center+x_center/2) = 1 * exp(-0.005*(1:512));
rtpIsoBeam(:, w_region) = 1 * repmat(exp(-(exp_length) * exp_decay),[w_size 1])';

rtpBeam = rtpIsoBeam * 100;

end

