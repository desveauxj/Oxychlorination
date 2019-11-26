function null = plotdata(v, y, conv)
% Figure 1 -- Flowrate vs Reactor Vol
figure(1)
%y-axis left
plot(v,y(:,1),'b-',v,y(:,8),'y-',v,y(:,3),'m-',v,y(:,4),'c-',v,y(:,5),'r-',v,y(:,6),'g-',v,y(:,7),'k-')
ylabel('Molar Flowrate - mol/hr')
%y-axis right
grid
xlabel('Reactor Volume - m^3')
ylabel('Molar Flowrate - mol/hr')
title('Flowrate vs. Reactor Volume')
legend('C_2H_4','H_2O','O_2','C_2H_3Cl_3','CO_2','Cl_2','C_2H_4Cl_2','Location','northeastoutside')

%Figure 2 -- HCl Flowrate vs Reactor Vol
figure(2)
plot(v,y(:,2),'k-')
grid
xlabel('Reactor Volume - m^3')
ylabel('HCl Molar Flowrate - mol/hr')
title('HCl Flowrate vs. Reactor Volume')


% Figure 3 -- Reactor T vs Reactor Vol
figure(3)
plot(v,y(:,9),'k-')
grid
xlabel('Reactor Volume - m^3')
ylabel('Reactor Temperature - K')
title('Reactor Temperature vs. Reactor Volume')

% Figure 4 -- Coolant T vs Reactor Vol
figure(4)
plot(v,y(:,11),'k-')
grid
xlabel('Reactor Volume - m^3')
ylabel('Coolant Temperature - K')
title('Coolant Temperature vs. Reactor Volume')

% Figure 5 -- Reactor P vs Reactor Vol
figure(5)
plot(v,y(:,10),'k-')
grid
xlabel('Reactor Volume - m^3')
ylabel('Reactor Pressure - kPa')
title('Reactor Pressure vs. Reactor Volume')

%Conversion profile
figure(6)
plot(v ,conv,'k-')
grid
xlabel('Reactor Volume - m^3')
ylabel('Conversion (% of C_2H_4)')
title('Conversion profile')

end