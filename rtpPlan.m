function [ rtpPlan, rtpOut ] = rtpPlan(rtpGrid, rtpBeam, rtpVectors, rtpWedge, showPlan)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% new sum of dose grid and boundaries
D = zeros(2*rtpGrid.size);

ub = rtpGrid.bound(1);%       _____ub_____
db = rtpGrid.bound(2);%      |  . . . . . |
lb = rtpGrid.bound(3);%      |  . . . . . |
rb = rtpGrid.bound(4);%   lb |  . . . . . |rb
                      %      |  . . . . . |
                      %      |  . . . . . |
                      %      ------db------


% -----------------------------------------------------
% EFFECTIVE SOURCE TO SURFACE DISTANCE METHOD 
% -----------------------------------------------------
% André Augusto de Fárias Martins and Diego Ronaldo Thomaz Sampaio

% High energy photons K value
k = 0.6;

% Beam
R = rtpBeam;

% Wedge
W = rtpWedge;

% 0 degree beam eye's (binary)
Beye = im2bw(mat2gray(rtpGrid.grid(ub:db-1,lb:rb-1)), 0.5);

% 
agonia = waitbar(0, 'TeXla ...');

for i = 1:rtpVectors.N,
    
    % beam size with 10 cm as a ref
    fw = (rtpVectors.size(i)/10);
    Hw = rtpGrid.size;
    Ww = round(rtpGrid.size*fw);
    Woff = abs(round((Ww - rtpGrid.size)/2));
    
    % Beam or Wedge
    if (rtpVectors.wedge(i)),
        B = W;
    else
        B = R;
    end
    
    % piecewise acomchambration
    if (fw > 1),
        Rsz = imresize(B, [Hw Ww]);
        Rsz = Rsz(:, Woff:end-(Woff+1));
    end
    
    if (fw < 1),
        Rsz = imresize(B, [Hw Ww]);
        Rsz = [zeros(Hw, Woff), Rsz, zeros(Hw, Woff)];
    end
    
    if (fw == 1),
        Rsz = B;
    end
        
    % beam eye's rotated target
    Beyerot = imrotate(Beye, -1 * rtpVectors.angle(i), 'crop');
    
    % borders of target
    bordas = edge(Beyerot, 'LoG');
    
    % ----------------------------------------------
    % Andre's implementation to get distances [BEGIN]  
    % ----------------------------------------------
    indes1 = zeros(length(bordas),1);
    
    for i1=1:length(bordas)%varrendo as colunas e procurando os valores não nulos
        if find(bordas(:,i1) == 1) ~= 0 %comando 'find' pode voltar matriz vazia
            indes1(i1) = find(bordas(:,i1) == 1,1);%achado o primeiro valor 1, guarda o indice
        end
    end
    
    indes12 = indes1 - min(indes1(indes1>0)); %deslocando o mínimo não nulo para zero
    
    for j=1:length(indes12)%evitando numeros negativos
        if indes12(j)<0
            indes12(j)=0;
        end
    end
    
    for i2=1:length(Beyerot)%deslocando os indeces da isodose
        for i3=1:length(Beyerot)
            indDesloca = abs(length(Rsz) - round(abs(abs(i2-indes12(i3)*k))- ...
                0));
            %floor((max(indes1)-min(indes1(indes1>0))))/2));
            if indDesloca == 0
                indDesloca =1;
            end
            isodoseCorr(indDesloca,i3) = Rsz(i2,i3);
        end
    end
    
    matrizCorr = zeros(length(isodoseCorr));
    matrizCorr(min(indes1(indes1>0)):end-1,:) = isodoseCorr(1:(length(isodoseCorr)-min(indes1(indes1>0))),:);
    
    % -----------------------------------------------
    % TODO: Generalize for uncentered target
    % Andre's distance used for computation of TMR
    % v1
    % -----------------------------------------------
    %figure(6)
    %imagesc(Beyerot);
    %x = round(length(Beyerot)/2);
    %y = round(length(Beyerot)/2);
    x = round(length(Beyerot)/2) + rtpGrid.center(1);
    y = round(length(Beyerot)/2) + rtpGrid.center(2);
    %hold on
    %plot(x,y,'y*'), plot(x,indes1(y),'r*'), line([x, x],[y indes1(y)])
    %pause(.25)
    d(i) = y - indes1(x);
    
    % -----------------------------------------------
    % Andre's implementation to get distances [END]
    % -----------------------------------------------
    
    % Contour
    Rcc = matrizCorr;
    
    % beam rotation
    Rrot = imrotate(Rcc, rtpVectors.angle(i), 'crop');
    %Rrot = imrotate(R, rtpVectors.angle(i), 'crop');
    
    % weight
    Rw = Rrot * rtpVectors.weight(i);
       
    % results
    D(ub:db-1, lb:rb-1) = D(ub:db-1, lb:rb-1) + Rw;
    
    % show Plan
    if (showPlan)
        h = figure(84);
        set(h,'menubar','none','numbertitle','off','Pointer','crosshair');
        imagesc(D);
        colormap(jet);
        %hold on, imagesc(Z*0.005), hold off;
        xlabel(colorbar, '%');
        title(sprintf('Please, press close [X] to continue...\n#%d \\psi %.2f \\theta %.2f', i, ...
            rtpVectors.weight(i), rtpVectors.angle(i)));
        %xlabel('Click to continue');
        pause(1);
    end
    
    waitbar(i/rtpVectors.N, agonia);
end

close(agonia);

if (showPlan)
    uiwait(h);
end

% Gy
rtpPlan = D;

% px
rtpOut = d;   

end

