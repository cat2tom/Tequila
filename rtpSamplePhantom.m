function [ rtpPhantom ] = rtpSamplePhantom(phantomSize, type )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

% phantom
P = zeros(phantomSize);

if (nargin > 1),
    switch type
        case 0
            CentroX =  + 0;
            CentroY =  + 0;
            Raio = 50; 
            [rr cc] = meshgrid(1:phantomSize);
            P = sqrt((rr-(round(phantomSize)/2 - CentroX)).^2+(cc-(round(phantomSize)/2-CentroY)).^2) <= Raio;
            P = P;
        case 1
            Lx = 50;
            Ly = 50;
            P(round(phantomSize/2)-Ly:round(phantomSize/2)+Ly,round(phantomSize/2)-Lx:round(phantomSize/2)+Lx) = 1;
        otherwise
            errordlg('NO PHANTOM');
    end
else
    P = phantom(phantomSize);
end
                          
% threshold
%TH = 0.8;

% mask
%MASK = (P > TH);

%rtpPhantom = mat2gray(P .* MASK);
rtpPhantom = mat2gray(P) * 1000;

end

