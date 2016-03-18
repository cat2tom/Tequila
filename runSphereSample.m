%% Tequila running routine version 0.5
% Sampaio, D.R.T,
% 11/12/2015 15:00 
%

close all
clear all
clc

%% TeXla 0.5 for 6MV
%

% number of points
N = 512;             

%
% squared sample
%

Phantom = rtpSamplePhantom(N, 0);

%
% user define phantom at grid
%

posCenter = [0, 0];

Grid = rtpGrid(Phantom, posCenter);

%
% user define dose or simulated dose 6MV
%

D.dref = 2.0; % cm
D.dose = 10^-2; % Gy
[Beam, Rad] = rtpIsoBeam('..\Simulation\06MV\06MV.txt', Grid.size, D);

%
% simulated user plan
%

F = 3/4;
nBeams = 4 * F;                      % number of beams
vWeight = ones(1, nBeams);           % weight of beams
%vWeight = round(rand(1,nBeams)*10);

%simulating planning
for i = 1:nBeams,
  vBeam(i) = vWeight(i);
  vAngle(i) = 90/F * (i-1);
  vSizes(i) = 10;
  vWedge(i) = 0;
end

%
% rtp make vectors 
%

Vects = rtpVectors(nBeams, vBeam, vAngle, vSizes, vWedge);

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


figure(3)
imagesc(mat2gray(IMG_Grid)); 
colormap(gray);
freezeColors;
hold on;
h = imagesc(mat2gray(IMG_Plan));
%hold off;
colormap(jet);
colorbar;


M_50 = max(max(IMG_Grid)) .* 0.7;
alphamap = rtpTransparency(IMG_Grid, M_50, 0.55);

contour(mat2gray(Plan), 5);
hold off;

set(h, 'AlphaData', alphamap);
title('The normalized dose overlays phantom');
xlabel('x-direction');
ylabel('y-direction');

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
clear vWedge vAngle vBeam vSizes vWeight mu_a i nPoints nBeams nDosePoints nPhantomPoints h i j alphamap alphath alphatp F posCenter N Rad M_50 IMG_Plan IMG_Grid
 
