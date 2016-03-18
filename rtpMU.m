function [ rtpMU ] = rtpMU(rtpVectors, rtpTables, rtpD, Choice)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


% Dose
D = rtpD.D;

% Dose calculate per MU at reference
Dcal = rtpD.dose;

% reference distance
dRef = rtpD.dref;

% at distance
d = rtpD.d;

% MU
N = rtpVectors.N;
Values = zeros(N, 1);

% WITHOUT TABLES
for i = 1:rtpVectors.N,
    Values(i) = D/Dcal;
end

% Choose
A(1,1) = Choice(1);
A(2,1) = Choice(2);
%A(3,1) = get(handles.setYieldFactor,'Value');
A(3,1) = 0; % Yield is the product of A(1) and A(2)

% ----------------------------
% Table FS for MU Computation
% ----------------------------
if (~isempty(rtpTables.TablesFSY)),
    
    TablesFSY = rtpTables.TablesFSY;
    
    for i = 1:rtpVectors.N,
        
        % Eq. Size of Field
        r = rtpVectors.sizeEq(i);
        
        % find row over table
        v = find(round(r) == TablesFSY(:, 1));
        
        for j = 2:size(TablesFSY, 2),
            
            if (isempty(v)),
                
                Vm = find(TablesFSY(:, 1) < r);
                Vm = Vm(end);
                VM = find(TablesFSY(:, 1) > r);
                VM = VM(1);
                
                % average;
                %S(j-1) = (TablesFSY(Vm, j)+TablesFSY(VM, j))/2;
                
                % 1-order adjust
                px = [Vm VM];
                py = [TablesFSY(Vm, j) TablesFSY(VM, j)];
                
                % fit
                f = polyfit(px, py, 1);
                
                % linear interp
                S(j-1) = f(1)*r + f(2);
                
            else
                
                S(j-1) = TablesFSY(v, j);
                
            end
            
            % TODO: remove CPU unecessary calculation
            if(~A(j-1))
                S(j-1) = 1;
            end
            
        end
        
        % Field and Scatter
        Values(i) = Values(i)/prod(S);
        
    end
    
end

% ----------------------------
% Table TMR for MU computation
% ----------------------------
if (Choice(3)),
    if (~isempty(rtpTables.TablesTMR)),
        
        TablesTMR = rtpTables.TablesTMR;
        
        for i = 1:rtpVectors.N,
            
            % init
            TMR(i) = 1;
            
            % Field Eq. Size
            r = rtpVectors.sizeEq(i);
            
            % find col over table [FIELD SIZE]
            vr = find(round(r) == TablesTMR(1, :));
            
            if (isempty(vr)),
                
                % find values
                Vm = find(TablesTMR(1, :) < r);
                VM = find(TablesTMR(1, :) > r);
                
                % values
                %r_Vm = Vm(1);
                %r_VM = VM(end);
                
                % range of fields in table
                r_px = [Vm(end) VM(1)];
                
            else
                
                % table has this field
                r_px = vr;
                
            end
            
            % depth by Andre's algorithm
            d = rtpD.d(i);
            % TODO: cm
            %d = round(handles.D.d(i)*10)/10;
            
            % find row over table [DEPTH]
            vd = find(d == TablesTMR(:, 1));
            
            if (isempty(vd)),
                
                Vm = find(TablesTMR(:, 1) < d);
                VM = find(TablesTMR(:, 1) > d);
                
                %d_Vm = Vm(1);
                %d_VM = VM(end);
                
                d_px = [Vm(end) VM(1)];
                
            else
                
                % table has this depth
                d_px = vd;
                
            end
            
            % -------------
            % Interp
            % -------------
            
            if (length(d_px) > 1),
                
                % 1st fix r_px(1)
                py = [TablesTMR(d_px(1), r_px(1)) TablesTMR(d_px(2), r_px(1))];
                f = polyfit([TablesTMR(d_px(1),1) TablesTMR(d_px(2),1)], py, 1);
                Sd(1) = f(1)*d + f(2);
                
                if (length(r_px) > 1),
                    % 2nd fix r_VM
                    py = [TablesTMR(d_px(1), r_px(2)) TablesTMR(d_px(2), r_px(2))];
                    f = polyfit([TablesTMR(d_px(1),1) TablesTMR(d_px(2),1)], py, 1);
                    Sd(2) = f(1)*d + f(2);
                end
                
            else
                
                Sd(1) = TablesTMR(d_px(1), r_px(1));
                
                if (length(r_px) > 1),
                    Sd(2) = TablesTMR(d_px(1), r_px(2));
                end
                
            end
            
            if (length(Sd) > 1)

                f = polyfit([TablesTMR(1, r_px(1)) TablesTMR(1, r_px(2))], Sd, 1);                
                TMR(i) = f(1)*r + f(2);
                
            else
                
                TMR(i) = Sd(1);
                
            end
            
            % TMR
            Values(i) = Values(i)/TMR(i);
            
        end
        
    end
    
    
end

% ----------------------------
% Table WF for MU computation
% ----------------------------
if (Choice(4)),
    if (~isempty(rtpTables.TablesWF)),
        
        TablesWF = rtpTables.TablesWF;
                
        for i = 1:rtpVectors.N,
            
            % init
            WF(i) = 1;
            
            if (rtpVectors.wedge(i)),
                % Field Eq. Size
                r = rtpVectors.sizeEq(i);
                
                % find col over table [FIELD SIZE]
                vr = find(round(r) == TablesWF(1, :));
                
                if (isempty(vr)),
                    
                    % find values
                    Vm = find(TablesWF(1, :) < r);
                    VM = find(TablesWF(1, :) > r);
                    
                    % values
                    %r_Vm = Vm(1);
                    %r_VM = VM(end);
                    
                    % range of fields in table
                    r_px = [Vm(end) VM(1)];
                    
                else
                    
                    % table has this field
                    r_px = vr;
                    
                end
                
                % depth by Andre's algorithm
                d = rtpD.d(i);
                % TODO: cm
                %d = round(handles.D.d(i)*10)/10;
                
                % find row over table [DEPTH]
                vd = find(d == TablesWF(:, 1));
                
                if (isempty(vd)),
                    
                    Vm = find(TablesWF(:, 1) < d);
                    VM = find(TablesWF(:, 1) > d);
                    
                    %d_Vm = Vm(1);
                    %d_VM = VM(end);
                    
                    d_px = [Vm(end) VM(1)];
                    
                else
                    
                    % table has this depth
                    d_px = vd;
                    
                end
                
                % -------------
                % Interp
                % -------------
                
                if (length(d_px) > 1),
                    
                    % 1st fix r_px(1)
                    py = [TablesWF(d_px(1), r_px(1)) TablesWF(d_px(2), r_px(1))];
                    f = polyfit([TablesWF(d_px(1),1) TablesWF(d_px(2),1)], py, 1);
                    Sd(1) = f(1)*d + f(2);
                    
                    if (length(r_px) > 1),
                        % 2nd fix r_VM
                        py = [TablesWF(d_px(1), r_px(2)) TablesWF(d_px(2), r_px(2))];
                        f = polyfit([TablesWF(d_px(1),1) TablesWF(d_px(2),1)], py, 1);
                        Sd(2) = f(1)*d + f(2);
                    end
                    
                else
                    
                    Sd(1) = TablesWF(d_px(1), r_px(1));
                    
                    if (length(r_px) > 1),
                        Sd(2) = TablesWF(d_px(1), r_px(2));
                    end
                    
                end
                
                if (length(Sd) > 1)
                    
                    f = polyfit([TablesWF(1, r_px(1)) TablesWF(1, r_px(2))], Sd, 1);
                    WF(i) = f(1)*r + f(2);
                    
                else
                    
                    WF(i) = Sd(1);
                    
                end
                
            end
            
            % TMR
            Values(i) = Values(i)/WF(i);
            
        end
        
    end
    
    
end


% save user data
rtpMU.N = N;
rtpMU.Values = Values;

end

