function [ rtpPhantomSlices, rtpPhantomInfo, nSlices ] = rtpPhantom(dicomDir, showDicom)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

dicomDir = [dicomDir '\'];

dicomFiles = struct2cell(dir(dicomDir))';

nSlices = size(dicomFiles, 1) - 2;

for i = 1:nSlices,
    
    %dicomFile = [dicomDir 'I' sprintf('%.5d',i)];
    
    rtpPhantomSlices(:, :, i) = double(dicomread([dicomDir num2str(dicomFiles{i+2, 1})]));
    
    % information
    if (i == 1),
        rtpPhantomInfo = dicominfo([dicomDir num2str(dicomFiles{i+2, 1})]);
    end
    
    if (showDicom),
        h = figure(1);
        set(h,'menubar','none','numbertitle','off','Pointer','crosshair');
        imagesc(rtpPhantomSlices(:, :,i));
        title(num2str(i));
        colorbar;
        axis off
        pause(0.2);
    end
    
end

close(h)

end

