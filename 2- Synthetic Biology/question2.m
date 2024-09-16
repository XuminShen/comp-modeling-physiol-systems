%   HW2
%   Author: Xumin Shen
%   UNI: xs2484
%   2/28/2023

clc
clear

%time
tspan=0:0.01:12; %how long we want to simulate; and at what interval
%initial condition
y0= 0; 
%parameters
a_list=[5,50,100,200];
a=75;

g_list=[7,10,13,16,19,22]; %decay rate
g=25


figure(1);
for ai =a_list
    [t,y] = ode23(@(t,y)positive_feedback(t,y,ai,g), tspan, y0);
    plot(t, y(:,1), 'o-','DisplayName',['a = ',num2str(ai)])
    hold on
    ylabel('solution y') 
    xlabel('time t')
    title('Solution of positive feedback with ODE23')
    
end
legend('show')

figure(2)
for gi =g_list   
    plot(tspan,(1+a*tspan.*tspan)./(1+tspan.*tspan)-gi*tspan,'DisplayName',['g = ',num2str(gi)]);
    hold on;
    ylabel('𝑑𝑥/𝑑𝑡') 
    xlabel('x') 
end
plot(tspan,zeros(size(tspan)))
legend('show')

%gx^3-ax^2+gx-1=0
r1 = roots([g_list(1) -a g_list(1) -1]);
r2 = roots([g_list(2) -a g_list(2) -1]);
r3 = roots([g_list(3) -a g_list(3) -1]);
r4 = roots([g_list(4) -a g_list(4) -1]);
r5 = roots([g_list(5) -a g_list(5) -1]);
r6 = roots([g_list(6) -a g_list(6) -1]);

function dydt = positive_feedback(t,y,a,g)
dydt = zeros(1,1);
dydt(1) = (1+a*y(1)*y(1))/(1+y(1)*y(1))-g*y(1);
end



