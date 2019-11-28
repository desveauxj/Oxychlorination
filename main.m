clear
%clc
%Species indices key:
    % 1 = c2h4
    % 2 = hcl
    % 3 = o2
    % 4 = 1,1,2-trichloroethane
    % 5 = co2
    % 6 = cl2
    % 7 = 1,2-dichloroethane
    % 8 = h2o
    
%Heats of Reaction and Cp values at 533K
H_R1 = -240.14; % units of kJ/mol
H_R2 = -149.31;
H_R3 = -1321.08;
H_R4 = -116.82;
H_tot = [-240.14, -149.31, -1321.08, -116.82]; 

Cp_1 = 0.0538; % units of kJ/mol*K
Cp_2 = 0.0292;
Cp_3 = 0.0304;
Cp_4 = 0.1050;
Cp_5 = 0.0418;
Cp_6 = 0.0351;
Cp_7 = 0.0937;
Cp_8 = 0.0345;
Cp_tot = [Cp_1 Cp_2 Cp_3 Cp_4 Cp_5 Cp_6 Cp_7 Cp_8];
sumCp = sum(Cp_tot);
 

%Main Properties, note that some of these values were taken from Aspen HYSYS
T0 = 470; % units of K
P0 = 1500; % units of kPa
D = 0.0245; % units of m; diameter of tube
L = 5.5;  % units of m
N = 1100; % number of tubes
Ac = (pi*((D^2)/4)); % units of m^2
phi = 0.4; % represents the void fraction
Dp = D/8; % units of m; diameter of particle
mu = 2.11*10^-5; % units of kg/m*s
rho0 = 8.239; % units of kg/m^3
V_r = (pi*((D^2)/4))*L; % units of m^3

%Coolant Properties
U = 0.3; % units of kJ/(m^2*K*s)
Tc0 =410; % units of K, boiling point is 530 K
flowC = 3010/3600; % units of kg/s


%Initial molar flowrates from starting material balance
 % units of mol/s
F1_0 = 10/3600; % 1 = c2h4
F2_0 = 100/3600; % 2 = hcl
F3_0 = 10/3600; % 3 = o2
F4_0 = 0/3600; % 4 = 1,1,2-trichloroethane
F5_0 = 0/3600; % 5 = co2
F6_0 = 0.1/3600; % 6 = cl2
F7_0 = 0/3600; % 7 = 1,2-dichloroethane
F8_0 = 1/3600; % 8 = h2o
F = [F1_0 F2_0 F3_0 F4_0 F5_0 F6_0 F7_0 F8_0];     
Ftotal_0 = sum(F);

%Ergun Equation Parameters
MW = [0.02805, 0.03646, 0.01600, 0.1334, 0.04401, 0.0709, 0.09896, 0.01802]; %kg/mol
G = sum(MW.*F)/Ac; % units of kg/(m^2 * s)
Beta = (((G/(Dp)) * ((1-phi)/(phi^3))) * (((150*(1-phi)*mu)/Dp) + (1.75*G)))/1000; % units of kPa*kg/(m^4)

%Logic
numElements = 1000; % number of solver iterations
dv = V_r/numElements;
vspan = linspace(0, V_r, numElements);
y0 = [F1_0 F2_0 F3_0 F4_0 F5_0 F6_0 F7_0 F8_0 T0 P0 Tc0]; % load dependent variables
handleranon = @(v,y) handler(v,y,phi,H_tot,Cp_tot,L,D,Beta,Ac,U,flowC,Ftotal_0,T0,P0,rho0); % use handler fxn
[ v, ysoln ] = ode15s(handleranon,vspan,y0);
conv = zeros(numElements,1);
for i = 1:numElements
    conv(i) = (1-ysoln(i,1)/ysoln(1,1));
end
disp(conv(numElements))

%disp('Final Conversion: '+ num2str(conv(numElements)))
plotdata(v, ysoln, conv);
