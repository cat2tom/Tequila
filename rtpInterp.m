function [rtpInterpObject] = rtpInterp(rtpObj, gridSize)

% interpolated size
H_i = gridSize;
W_i = gridSize;

% 
W = size(rtpObj, 2);
H = size(rtpObj, 1);

% Scale the coordinates so that they range from 0 to 1 each.
[X1, Y1] = meshgrid( ...
                    linspace(0, 1, W_i), ...
                    linspace(0, 1, H_i));
                
[X2, Y2] = meshgrid( ...
                    linspace(0, 1, W), ...
                    linspace(0, 1, H));

% interpolate each color plane separately
rtpInterpObject = interp2(X2, Y2, double(rtpObj), X1, Y1);

end