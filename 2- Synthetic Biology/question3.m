% Parameters
beta = 2;
gamma = 3;
alpha1=7;
alpha3 = 7;
alpha4 = 2;


% Define nullclines
a = 0:0.01:10;
b = 0:0.01:10;
u = (alpha1)./(1+a.^beta);
v = (alpha1)./(1+b.^gamma);

% Plot nullclines
figure(1)
plot(a,u)
hold on
plot(v,b)
xlabel('u')
ylabel('v')
title('Nullclines for Bistable Toggle Switch Model')
legend('du/dt = 0', 'dv/dt = 0')

a = 0:0.01:10;
b = 0:0.01:10;
u = (alpha4)./(1+a.^beta);
v = (alpha3)./(1+b.^gamma);
figure(2)
plot(a,u)
hold on
plot(v,b)
xlabel('u')
ylabel('v')
title('Nullclines for Monostable Toggle Switch Model')
legend('du/dt = 0', 'dv/dt = 0')