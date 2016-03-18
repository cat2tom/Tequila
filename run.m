%% Tequila running routine version 0.5
% Sampaio, D.R.T,
% 11/12/2015 15:00 
%

close all
clear all
clc

%% RT-P
%

%
% user dicom phantom
%

PhantomSlices = rtpPhantom('..\TargetPhantom\', 1);

% choose slice
Phantom = PhantomSlices(:, :, 22); % nSlice = 22 (Good choice for 2D)

% remove tabler
Phantom = Phantom .* rtpTargetBox(Phantom);

%
% user define grid
%

%posCenter = [-50, 50];     % out of isocenter
posCenter = [0, 0];         % at isocenter

%
% make grid with or without phantom
%

Grid = rtpGrid(Phantom, posCenter);

%
% user define dose or simulated dose
%

% 6MV
D.dref = 2.0; % cm
D.dose = 10^-2; % Gy

[Beam, Rad] = rtpIsoBeam('..\Simulation\06MV\06MV.txt', Grid.size, D);

% 15MV
%D.dref = 3.0; % cm
%D.dose = 10^-2; % Gy
%[Beam, Rad] = rtpIsoBeam('..\Simulation\15MV\15MV.txt', Grid.size, D);

%
% rtp make vectors 
%

Vects = rtpVectors(1);  % nBeam = 3; (Good sample)

%
% rtp make planning
%

Plan = rtpPlan(Grid, Beam, Vects, [], 1);

%
% rtp MU
%

% Dose 6MV
D.D = 2; %Gy
D.Dcal = 0.01; % Gy
D.d = 0;
D.dref = 2; % cm

% Corrections
Tables.TablesTMR = csvread('..\Tables\06MV\6MVTMR.txt');
Tables.TablesFSY = csvread('..\Tables\06MV\6MVFSY.txt');
Tables.TablesWF = csvread('..\Tables\06MV\6MVWF.txt');

% Choices
Choice(1) = 1; % Scatter
Choice(2) = 1; % Field
Choice(3) = 1; % TMR
Choice(4) = 0; % WF

MU = rtpMU(Vects, Tables, D, Choice);

%%
% display
%

close all

IMG_Grid = Grid.grid;
IMG_Plan = Plan;

figure(1)
imagesc(IMG_Grid);
title('Phantom at grid');
xlabel('x-direction');
ylabel('y-direction');
colormap(gray);
xlabel(colorbar,'Intensity (HU)');

figure(2)
imagesc(IMG_Plan);
axis image
colormap(jet);
xlabel(colorbar,'%');
title('Dose at grid');
xlabel('x-direction');
ylabel('y-direction');

% subplot(122), imagesc(IMG_MU./(10^-9));
% axis image
% colormap(jet);
% xlabel(colorbar,'Dose rate (Gy/s)');
% title('Planning dose rate at grid');
% xlabel('x-direction');
% ylabel('y-direction');

figure(3)
imagesc(mat2gray(IMG_Grid)); 
colormap(gray);
freezeColors;
hold on;
h = imagesc(mat2gray(IMG_Plan));
%hold off;
colormap(jet);
colorbar;

%
% transparency routine
% TODO: Transform into a function
%

M_50 = max(max(IMG_Grid)) .* 0.7;
%alphamap = rtpTransparency(IMG_Plan, 0.05, 0.55);
alphamap = rtpTransparency(IMG_Grid, M_50, 0.55);

contour(mat2gray(Plan), 5);
hold off;

set(h, 'AlphaData', alphamap);
title('The normalized dose overlays phantom');
xlabel('x-direction');
ylabel('y-direction');


% display results
h = figure('Position', [440 500 200 200],'Name','MU','Resize','off');
set(h,'menubar','none','numbertitle','off')
d = [Vects.angle MU.Values];
% Create the column and row names in cell arrays
cnames = {'Angle (deg)','MU'};
rnames = {1:Vects.N};
% Create the uitable
t = uitable(h,'Data',d,'ColumnName',cnames,'RowName',rnames, 'Position', [0 0 200 200]);


%
% workspace clean up
%
%
clear Choice vWedge vAngle vBeam vSizes vWeight mu_a i nPoints nBeams nDosePoints nPhantomPoints h i j alphamap alphath alphatp F posCenter N Rad M_50 IMG_Plan IMG_Grid
 

 
