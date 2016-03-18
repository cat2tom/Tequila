function [rtpBeamPerMU, rtpRadType] = rtpIsoBeam(fileLocation, gridSize, D)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


%[fFile, fPath] = uigetfile('*.txt');
Beam = importdata(fileLocation);
rtpRadType = fileLocation(end-7:end-6);

% size in px
[Hf, Wf] = size(Beam);

if (gridSize > max([Hf, Wf]))
    rtpBeamPerMU = rtpInterp(Beam, gridSize);
else
    rtpBeamPerMU = Beam;
end

%  TODO: simulation parameters should be loaded from the same file
% new size
[Hf, Wf] = size(rtpBeamPerMU);

% Reg of water
RegHeight = 45; % cm
RegWidth = 45;  % cm

% field at iso
FieHeight = 10; % cm
FieWidth = 10;  % cm

PonitRef = Hf - round((D.dref * Hf)/RegHeight);

% Gy
if (D.dose ~= 0), % dref given in cm
    
    % maximum dose position and value
    %[valMaxDose, distMaxDose] = max(rtpBeamPerMU(PRef,round(gridSize/2)));
    valRefDose = rtpBeamPerMU(PonitRef, round(gridSize/2));
    
    % Dose calculate at maximum dose
    rtpBeamPerMU = rtpBeamPerMU .* D.dose/valRefDose;
    
else
    
    % raw dose
    [D.dose] = max(max(rtpBeamPerMU));   
    
end

% normalization
rtpBeamPerMU = rtpBeamPerMU * 100/D.dose;

end

