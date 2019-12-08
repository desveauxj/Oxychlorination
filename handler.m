function outvar = handler(v,y,phi,H_tot,Cp_tot,L,D,Beta,Ac,U,flowC,Ftotal_0,T0,P0,rho0)
%Species indices key:
    % 1 = c2h4
    % 2 = hcl
    % 3 = o2
    % 4 = 1,1,2-trichloroethane
    % 5 = co2
    % 6 = cl2
    % 7 = 1,2-dichloroethane
    % 8 = h2o
    
% Unload variables
F1 = y(1); % units of mol/s
F2 = y(2);
F3 = y(3);
F4 = y(4);
F5 = y(5);
F6 = y(6);
F7 = y(7);
F8 = y(8);
T  = y(9); % units of K
P = y(10); % units of kPa

Tc = y(11); % units of K
Ftotal = (F1 + F2 + F3 + F4 + F5 + F6 + F7 + F8);
As = D * pi * L; % units of m^2
Do = D + 2*.0036; % units of m
Cpc = ((Tc - 273) * .0029 + 1.5041 + 273)/1000; % units of kJ/(kg*K)

% Calculate partial pressures for each species 
pp = [0,0,0,0,0,0,0,0];
for i = 1:length(pp)
    pp(i) = y(i)/Ftotal*P;
    %pp(i) = (y(i)/Ftotal)*(T0/T)*P; % units of kPa Old Method
end

% Rate expressions from paper
R_kinetics = 8.3144621; % units of J/(mol*K)

% a's are the pre-exponential factors from the Lakshmanan paper
a1 = 10^4.2; 
a2 = 10^13.23; 
a3 = 10^6.78;  

% E's are acivation energies from the Lakshmanan paper.
E1 = -40100; % units of J
E2 = -128080; 
E3 = -112000;

% Calculate rate constants
k(1) = a1 * exp(E1/(R_kinetics*T));
k(2) = a2 * exp(E2/(R_kinetics*T));
k(3) = a3 * exp(E3/(R_kinetics*T));
k(4) = (1000 * exp(17.13 - 13000/(1.987*T))) / exp(5.4+16000/(1.987*T));
%Rate constant units vary, see Lakshmanan paper for units

% Calculate rate equations
r1 = (k(1) * pp(1) * pp(6)^0.5/3.600) * (1-phi); % units of mol/(m^3 * s)
r2 = (k(2) * pp(7) * pp(6)^0.5/3.600) * (1-phi);
r3 = (k(3) * pp(1) * pp(3) * pp(6)^0.5)/3.600 * (1-phi);
r4 = (k(4) * pp(3) / pp(6)/3.600) * (1-phi);

% Set up differential equations
outvar(1) = -1*r1 - 1*r3;
outvar(2) = -2*r1 - 1*r2 - 4*r4;
outvar(3) = -0.5*r1 - 0.5*r2 - 3*r3 - r4;
outvar(4) = r2;
outvar(5) = 2*r3;
outvar(6) = 2*r4;
outvar(7) = r1 - r2;
outvar(8) = r1 + r2 + 2*r3 + 2*r4;

% Tube side differential equation
term1 = r1 * H_tot(1);
term1 = term1 + r2 * H_tot(2);
term1 = term1 + r3 * H_tot(3);
term1 = term1 + r4 * H_tot(4);

term2 = U * 4 / D * (T - Tc); % units of kJ/(m^3*s)

% Calculate mol fractions
molFracs = [0,0,0,0,0,0,0,0];
for i = 1:length(molFracs)
    molFracs(i) = y(i)/Ftotal;
end

term3 = 0;
for i = 1:length(molFracs)
    term3 = term3 + y(i)*Cp_tot(i); %Cp in units of kJ/mol K
end

outvar(9) = (-term1 - term2) / term3; % units of K/m^3

% Ergun differetial equation
rho = rho0 * (P/P0) * (Ftotal_0/Ftotal) * (T0/T); % units of kg/m^3
outvar(10) = -Beta * (1/(Ac*rho)); % units of kPa/m^3


% Shell side differential equations
outvar(11) = (4 * U * (T - Tc)) / (flowC * Cpc * Do); % units of K/m^3

outvar = outvar';

end
