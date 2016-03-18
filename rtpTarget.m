function [ rtpTargetSlices, rtpTargetInfo, nSlices ] = rtpTarget(showDicom)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

[name, caminho] = uigetfile('*.*','MultiSelect','on'); %pode-se selecinar tudo

nSlices = length(name);

for i = 1:nSlices,
	
    rtpTargetSlices(:,:,i) = double(dicomread([caminho name{i}]));
    
    
    % information
    if (i == 1),
        rtpTargetInfo = dicominfo([caminho name{i}]);
    end
    
    
    if (showDicom),
        h = figure(1);
        set(h,'menubar','none','numbertitle','off','Pointer','crosshair');
        imagesc(rtpTargetSlices(:, :,i));
        title(num2str(i));
        axis off
        colorbar;
        pause(0.2);
    end

end

end

