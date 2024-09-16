%%   Homework 2
%%   Author: Xumin Shen
%%   UNI: xs2484
%%   4/5/2023
clc
clear
close all

%% Question 1
% plot 1
v = (-40:0.1:60);
alpha = 0.01*(10-v)./(exp((10-v)/10)-1);
beta = 0.125*exp(-v/80);
n = alpha./(alpha+beta);
Df = - 1./(100*(exp(-v/80)/8 - (v/100 - 1/10)./(exp(1 - v/10) - 1)).*(exp(1 - v/10) - 1)) - ((v/100 - 1/10).*(exp(-v/80)/640 + 1./(100*(exp(1 - v/10) - 1)) + (exp(1 - v/10).*(v/100 - 1/10))./(10*(exp(1 - v/10) - 1).^2)))./((exp(-v/80)/8 - (v/100 - 1/10)./(exp(1 - v/10) - 1)).^2.*(exp(1 - v/10) - 1)) - (exp(1 - v/10).*(v/100 - 1/10))./(10*(exp(-v/80)/8 - (v/100 - 1/10)./(exp(1 - v/10) - 1)).*(exp(1 - v/10) - 1).^2);

figure("Name","Question 1 Plot 1")
subplot(1,2,1)
plot(v,alpha,"LineWidth",1.2)
hold on
plot(v,beta,"LineWidth",1.2)
hold on
plot(v,n,"LineWidth",1.2)
legend({'alpha','beta','n'},"Location","best")
xlim([-40 60])
ylabel('units 1/ms for alpha and beta, unitless for n_{inf}')
xlabel('V = V_m-V_r(mV)')
hold off
subplot(1,2,2)
plot(v,Df,"LineWidth",1.2)
xlim([-40 60])
legend({'dn_{inf}/dv'},"Location","best")
ylabel('units (1/mV)')
xlabel('V = V_m-V_r(mV)')

% plot 2
omega = (0:2*pi:200*2*pi);
V_K = -12E-3;
V_L = 10.6E-3;
g_K_hat = 30E-3;
g_L_hat = 0.3E-3;
C = 1E-6;
R = 1/(g_L_hat+g_K_hat*n(401)^4);
r = 1/(g_K_hat*4*n(401)^3*(v(401)-V_K)*Df(401))/1000;
L = r/(alpha(401)+beta(401))/1000;
% R = 1/0.6055E-3;
% r = 1413;
% L = 7.71;
% C = 1E-6;
fprintf('Q1: C:\t%3.6f; R:\t%3.3f; r:\t%3.3f; L:\t%3.3f\n',C,R,r,L)
z = (r+omega*1i*L)./((1-omega.^2*L*C+r/R)+1i*(omega*L/R+omega*r*C));

x_axis = (0:200);
figure("Name","Question 1 Plot 2","Position",[616   94  402  647]);
subplot(2,1,1)
magnitude = abs(z);
plot(x_axis,magnitude)
omega_peak = round(1/sqrt(L*C));
peak_x = round(omega_peak/(2*pi));
text(peak_x,magnitude(peak_x),'max is 1361 ohms at 71 Hz')
annotation('doublearrow',[.22 .744],[.813 .813])
text(peak_x,magnitude(peak_x)/sqrt(2),'1361/sqrt(2) \approx 962')
ylim([0 1400])
xlabel('frequency(Hz)')
ylabel('Magnitude of Z (ohms)')
grid on

subplot(2,1,2)
plot(x_axis,angle(z)*60)

xlabel('frequency(Hz)')
ylabel('Phase of Z (degrees)')
grid on


%% Question 2

V_K = -12E-3;
V_L = 10.6E-3;
g_K_hat = 30E-3;
g_L_hat = 0.3E-3;
C_m = 1E-6;
R_2 = 1/(g_L_hat+g_K_hat*n(401)^4);
r_2 = 1/(g_K_hat*4*n(401)^3*(v(401)-V_K)*Df(401))/1000;
L_2 = r_2/(alpha(401)+beta(401))/1000;
omega_0 = sqrt(1/(C_m*L_2));
Q = omega_0/(r_2/L_2+1/(R_2*C_m));

alpha = 0.01*(10-v)./(exp((10-v)/10)-1);
beta = 0.125*exp(-v/90);
n = alpha./(alpha+beta);
Df_new = - 1./(100*(exp(-v/70)/8 - (v/100 - 1/10)./(exp(1 - v/10) - 1)).*(exp(1 - v/10) - 1)) - ((v/100 - 1/10).*(exp(-v/70)/560 + 1./(100*(exp(1 - v/10) - 1)) + (exp(1 - v/10).*(v/100 - 1/10))./(10*(exp(1 - v/10) - 1).^2)))./((exp(-v/70)/8 - (v/100 - 1/10)./(exp(1 - v/10) - 1)).^2.*(exp(1 - v/10) - 1)) - (exp(1 - v/10).*(v/100 - 1/10))./(10*(exp(-v/70)/8 - (v/100 - 1/10)./(exp(1 - v/10) - 1)).*(exp(1 - v/10) - 1).^2);

disp('Q2-i: I changed the beta function to:')
disp('Beta = 0.125*exp(-v/90)')
disp('alpha function remains the same: alpha = 0.01*(10-v)./(exp((10-v)/10)-1)')
fprintf('And then dn/dv increased from %4.5f to %4.5f\n',Df(401),Df_new(401))

R_2 = 1/(g_L_hat+g_K_hat*n(401)^4);
r_2 = 1/(g_K_hat*4*n(401)^3*(v(401)-V_K)*Df_new(401))/1000;
L_2 = r_2/(alpha(401)+beta(401))/1000;
omega_0_new = sqrt(1/(C_m*L_2));
Q_new = omega_0_new/(r_2/L_2+1/(R_2*C_m));
fprintf('old omega_0 is %4.2f and old Q is %4.5f \n',omega_0,Q)
fprintf('new omega_0 is %4.2f and new Q is %4.5f \n',omega_0_new,Q_new)
disp('Thus, it is possible to increase Q and ωo by increase dn/dv')

figure("Name","Question 2 Plot 1")
subplot(1,2,1)
plot(v,alpha,"LineWidth",1.2)
hold on
plot(v,beta,"LineWidth",1.2)
hold on
plot(v,n,"LineWidth",1.2)
legend({'alpha','beta','n'},"Location","best")
xlim([-40 60])
ylabel('units 1/ms for alpha and beta, unitless for n_{inf}')
xlabel('V = V_m-V_r(mV)')
hold off
subplot(1,2,2)
plot(v,Df_new,"LineWidth",1.2)
xlim([-40 60])
legend({'dn_{inf}/dv'},"Location","best")
ylabel('units (1/mV)')
xlabel('V = V_m-V_r(mV)')

fprintf('Q2-ii: My L is %4.5f and r is %4.2f\n',L_2,r_2)
f_0 = round(omega_0_new/(2*pi));
fprintf('Q2-iii: My Q is %4.5f and ωo is %4.2f and f_0 is %d\n',Q_new,omega_0_new,f_0)

% plot 2
omega = (0:2*pi:200*2*pi);

z = (r_2+omega*1i*L_2)./((1-omega.^2*L_2*C+r_2/R)+1i*(omega*L_2/R+omega*r_2*C));

x_axis = (0:200);
figure("Name","Question 2 Plot 2","Position",[616   94  402  647]);
subplot(2,1,1)
magnitude = abs(z);
plot(x_axis,magnitude)
text(f_0,magnitude(f_0),'max is 1360 ohms at 72 Hz')
annotation('doublearrow',[.22 .744],[.813 .813])
text(f_0,magnitude(f_0)/sqrt(2),'1360/sqrt(2) \approx 962')
ylim([0 1400])
xlabel('frequency(Hz)')
ylabel('Magnitude of Z (ohms)')
grid on

subplot(2,1,2)
plot(x_axis,angle(z)*60)
xlabel('frequency(Hz)')
ylabel('Phase of Z (degrees)')
grid on

%% Question 3

%(i)
v = (-40:0.1:60);
alpha_n = 0.01*(10-v)./(exp((10-v)/10)-1);
alpha_m = 0.1*(25-v)./(exp((25-v)/10)-1);
alpha_h = 0.07*exp(-v/18);

beta_n = 0.125*exp(-v/80);
beta_m = 4*exp(-v/18);
beta_h = 1./(exp((30-v)/10)+1);

n_inf = alpha_n./(alpha_n+beta_n);
Df_n_inf = - 1./(100*(exp(-v/80)/8 - (v/100 - 1/10)./(exp(1 - v/10) - 1)).*(exp(1 - v/10) - 1)) - ((v/100 - 1/10).*(exp(-v/80)/640 + 1./(100*(exp(1 - v/10) - 1)) + (exp(1 - v/10).*(v/100 - 1/10))./(10*(exp(1 - v/10) - 1).^2)))./((exp(-v/80)/8 - (v/100 - 1/10)./(exp(1 - v/10) - 1)).^2.*(exp(1 - v/10) - 1)) - (exp(1 - v/10).*(v/100 - 1/10))./(10*(exp(-v/80)/8 - (v/100 - 1/10)./(exp(1 - v/10) - 1)).*(exp(1 - v/10) - 1).^2);
m_inf = alpha_m./(alpha_m+beta_m);
Df_m_inf = - 1./(10*(4*exp(-v/18) - (v/10 - 5/2)./(exp(5/2 - v/10) - 1)).*(exp(5/2 - v/10) - 1)) - ((v/10 - 5/2).*((2*exp(-v/18))/9 + 1./(10*(exp(5/2 - v/10) - 1)) + (exp(5/2 - v/10).*(v/10 - 5/2))./(10*(exp(5/2 - v/10) - 1).^2)))./((4*exp(-v/18) - (v/10 - 5/2)./(exp(5/2 - v/10) - 1)).^2.*(exp(5/2 - v/10) - 1)) - (exp(5/2 - v/10).*(v/10 - 5/2))./(10*(4*exp(-v/18) - (v/10 - 5/2)./(exp(5/2 - v/10) - 1)).*(exp(5/2 - v/10) - 1).^2);

V_K = -12E-3;
V_L = 10.6E-3;
V_Na = 115E-3;
g_K_hat = 30E-3;
g_L_hat = 0.3E-3;
g_Na_hat = 90E-3;
C = 1E-6;
h_v = 0.79;

r_n = 1/(g_K_hat*4*n_inf(401)^3*(0-V_K)*Df_n_inf(401))/1000;
r_m = 1/(g_Na_hat*3*m_inf(401)^2*h_v*(0-V_Na)*Df_m_inf(401))/1000;

L_n = r_n/(beta_n(401)+alpha_n(401))/1000;

R_point = (R*r_m)/(R+r_m);
fprintf("q3-i: R' = %4.3f\n",R_point)

%(ii)
omega_0 = sqrt(1/(C*L_n));
Q = omega_0/(r_n/L_n+1/(R_point*C));
f_0 = round(omega_0/(2*pi));
fprintf('q3-ii: calculated Q is %4.5f and ωo is %4.2f and f_0 is %d\n',Q,omega_0,f_0)

%(iii)
z = (r_n+omega*1i*L_n)./((1-omega.^2*L_n*C+r_n/R_point)+1i*(omega*L_n/R_point+omega*r_n*C));

x_axis = (0:200);
figure("Name","Question 2 Plot 2","Position",[616   94  402  647]);
subplot(2,1,1)
magnitude = abs(z);
plot(x_axis,magnitude)
text(f_0,magnitude(f_0),'max is 3062 ohms at 62 Hz')
annotation('doublearrow',[.28 .50],[.813 .813])
text(f_0,magnitude(f_0)/sqrt(2),'3062/sqrt(2) \approx 2165')
ylim([0 3200])
xlabel('frequency(Hz)')
ylabel('Magnitude of Z (ohms)')
grid on

subplot(2,1,2)
plot(x_axis,angle(z)*60)
xlabel('frequency(Hz)')
ylabel('Phase of Z (degrees)')
grid on
disp('q3-iii: From the graph, measured Q = 1.069, ωo = 396, f_0 = 63')

%(iv)
disp("q3-iv: r_m should be -808 ohms be make Q = 3")
% r_m_4 = -808;
R_point_4 = -15824;
fprintf("R' = %4.3f\n",R_point_4)

z = (r_n+omega*1i*L_n)./((1-omega.^2*L_n*C+r_n/R_point_4)+1i*(omega*L_n/R_point_4+omega*r_n*C));

x_axis = (0:200);
figure("Name","Question 3 Plot 2","Position",[616   94  402  647]);
subplot(2,1,1)
magnitude = abs(z);
plot(x_axis,magnitude)
text(f_0,magnitude(f_0),'max is 9446 ohms at 55 Hz')
annotation('doublearrow',[.30 .40],[.813 .813])
text(f_0,magnitude(f_0)/sqrt(2),'9446/sqrt(2) \approx 6680')
ylim([0 9500])
xlabel('frequency(Hz)')
ylabel('Magnitude of Z (ohms)')
grid on

subplot(2,1,2)
plot(x_axis,angle(z)*60)
xlabel('frequency(Hz)')
ylabel('Phase of Z (degrees)')
grid on
disp('From the graph, measured Q = 2.89, ωo = 346, f_0 = 55')