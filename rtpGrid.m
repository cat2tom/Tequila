function [ rtpGrid ] = rtpGrid(rtpPhantom, posPhantom)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% 

[H, W] = size(rtpPhantom);
N = max([H, W]);

%
% grid space
%
grid = zeros(2*N);

% 
% boundaries
%
ub = round(N/2);
db = round(N + (N/2));
lb = round(N/2);
rb = round(N + (N/2));

%
% phantom add
%

if (nargin == 1)
    X = lb:rb-1;
    Y = ub:db-1;    
    grid(Y, X) = rtpPhantom;
end

if (nargin == 2)
    X = lb:rb-1;
    OffX = posPhantom(1);
    Y = ub:db-1;
    OffY = posPhantom(2);
    grid(Y + OffY, X + OffX) = rtpPhantom;
end

%
% out
%
rtpGrid.size = N;
rtpGrid.center = [OffX, OffY];
rtpGrid.bound = [ub, db, lb, rb];
rtpGrid.grid = grid;

%rtpGrid.doseValue = rtpTargetDose.dose;
%rtpGrid.doseMask = rtpTargetDose.mask;

end

