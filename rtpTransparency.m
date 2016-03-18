function [ rtpTransparency ] = rtpTransparency(rtpObject, Threshold, Value)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%rtpObject = mat2gray(rtpObject);

% sizes
[N, M] = size(rtpObject);

% transparency
%Threshold = 0.05;
%Value = 0.55;

alphamap = zeros(N, M);

for i = 1:N,
    for j = 1:M,
        if(~(rtpObject(i,j) < Threshold))
             alphamap(i,j) = Value;
        end            
    end
end

rtpTransparency = alphamap;

end

