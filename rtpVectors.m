function [ rtpVectors ] = rtpVectors(nBeams, vWeight, vAngles, vSizes, vWedge)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here


%
% user from mouse
%

switch nargin
    case 0
        return;
        
    case 1
        %
        % beam weight
        %
        
        prompt = {'Beam weight:'};
        dlg_title = 'Vectors';
        num_lines = 1;
        defaultans = {'1.0'};
        answer = inputdlg(prompt, ...
            dlg_title, ...
            num_lines, ...
            defaultans);
        
        %
        % (r,theta) coordinades
        %
        
        h = figure(666);
        set(h,'menubar','none','numbertitle','off','Pointer','crosshair')
        theta = 0:pi/6:2*pi;                    % reference angles
        rho = str2double(answer{1}) * (sin(theta).^2 + cos(theta).^2);
        polar(theta, rho, '.');
        hold on;
        polar(0,0,'o');
        hold off;
        view(-90,90);                           % move 0 to upper position
        ylabel('Choose beam angles');
        text(0, 0, '  iso');
        set(gca, 'FontWeight', 'bold');
                
        % allocation
        vWeight = zeros(nBeams, 1);              % weight vector
        vAngles = zeros(nBeams, 1);              % angles vector
        vSizes = zeros(nBeams, 1);
        vSizesEq = zeros(nBeams, 1);
        vWedge = zeros(nBeams, 1);
        
        % conversion constant
        Krd = 180/pi();                         % radians to degree
        
        for i = 1:nBeams,
            
            
            prompt = {'Beam height:', 'Beam width:'};
            dlg_title = 'Vectors';
            num_lines = 1;
            defaultans = {'10','10'};
            
            answer = inputdlg(prompt, ...
                dlg_title, ...
                num_lines, ...
                defaultans);
            
            f = str2double(answer);
            
            % restore POLAR
            %minfig(h,0);
            
            % squared field
            %vSizes(i) = str2double(answer{1});
            
            % equiv. squared field
            vSizes(i) = (f(1));
            
            %
            vSizesEq(i) = 4 * (f(1) * f(2))/(2*(f(1)+f(2)));
            
            
            [x, y] = ginput(1);                 % collect clicks
            
            vWeight(i) = sqrt(x^2+y^2);         % intuitive weight
            
            theta = round(Krd*atan(y/x));       % angle
            
            if (x>0 && y<0)                     % quarters correction
                theta = theta + 360;
            end
            
            if (x<0 && y<0)
                theta = theta + 180;
            end
            
            if (x<0 && y>0)
                theta = theta + 180;
            end
            
            if (theta == 360),
                theta = 0;
            end
            
            vAngles(i) = theta;
            
            %
            % beam weight based on input user
            %
            %
            %             prompt = {'Beam weight range:'};
            %             dlg_title = 'Vectors';
            %             num_lines = 1;
            %             defaultans = {'1.0'};
            %             answer = inputdlg(prompt, ...
            %                 dlg_title, ...
            %                 num_lines, ...
            %                 defaultans);
            %
            %             vWeight(i) = str2double(answer{1});
            
        end
        
        close(h)
        
    otherwise
        vAngles = vAngles';
        vSizes = vSizes';
        vSizesEq = vSizes;
        vWeight = vWeight';
        vWedge = vWedge';
        
        
end

%
rtpVectors.N = nBeams;
rtpVectors.angle = vAngles;
rtpVectors.weight = vWeight;
rtpVectors.size = vSizes;
rtpVectors.sizeEq = vSizesEq;
rtpVectors.wedge = vWedge;

end

