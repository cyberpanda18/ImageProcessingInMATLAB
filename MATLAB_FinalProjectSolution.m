% FINAL PROJECT
% SOLVING ORDINARY DIFFERENTIAL EQUATIONS

% Given Information
% dy/dx = (1+4*x)*sqrt(y) [differential equation]
% Initial Condition --> x = 0, y = 1
% version 1.0 on 22Aug2021

% Remember, there are many ways to put this project together!
% Don't worry if your approach differs from the below...
% But be sure your calculations/answers match!

%% Main Script
clc, clearvars, close all, format compact
tic
%%%%%% SETUP, INITIAL DEFINITIONS %%%%%%%

% Input Parameters
n_analytical = 20;
n_numeric = input('Number of Points for Numeric Solutions? ');
if isempty(n_numeric)
    n_numeric = 5;      % if no user input, default is 5 iterations
end

graph_type = input('Graph:\n[a] Euler\n[b] Heun\n[c] RK\n[d] All\n','s');
if isempty(graph_type)
    graph_type = 'd';    % if no graph_type, set default to [d] All
end

init_cond = [0 1];      % initial condition y(x=0) = 1
x_min = init_cond(1);   % lower limit x
x_max = 2;              % upper limit x

% Calc x and dx for each Numeric Method
x = linspace(x_min, x_max, n_numeric);
dx = x(2) - x(1);

% Initialize the y datasets for each Numeric Method
% Euler, Heun, Runge-Kutta
ye = init_cond(2); yh = init_cond(2); yRK = init_cond(2);


%%%%%% CALCULATE x,y FOR EACH NUMERICAL METHOD %%%%%%%
% Note: For Loops should go from 1:length(x)-1 -- WHY?
% We are calculating pt n+1 from pt n. 
% If n_numeric = 5, we start with 5 X-values.
% Thus, we should also only end with 5 Y-values.
% We are given the first y-value, y(1), provided in the intitial condition.
% And we only need to calculate y(2), y(3), y(4), and y(5).
% When i = 1, we calculate y(2). When i = 2, we calc y(3). And so on...
% Thus, we calculate y(5) when i = 4.
% So i = 4 should be the last loop. 4 = length(x) - 1.
% that is why our For Loops will go from 1: length(x) - 1

% Now onto the actual math!
% Note that calc_ode() is defined at end of script and is the ode equation
% provided in the problem statement



%%%%%% Euler's Method
for i = 1:length(x)-1
    ye(i+1) = ye(i) + dx*calc_ode(x(i),ye(i));
end


%%%%%% Heun's Method
for i = 1:length(x)-1
    A = x(i) + dx;
    B = yh(i) + dx*calc_ode(x(i),yh(i));
    slopeleft = calc_ode(x(i),yh(i));
    sloperight = calc_ode(A,B);
    yh(i+1) = yh(i) + 1/2*dx*(slopeleft + sloperight);
end


%%%%%% Runga-Kutta's Method
for i = 1:length(x) - 1
    k1 = dx * calc_ode( x(i) , yRK(i) );
    k2 = dx * calc_ode( x(i)+1/2*dx , yRK(i)+1/2*k1 );
    k3 = dx * calc_ode( x(i)+1/2*dx , yRK(i)+1/2*k2 );
    k4 = dx * calc_ode( x(i)+dx , yRK(i)+k3 );
    
    yRK(i+1) = yRK(i) + 1/6*(k1 + 2*k2 + 2*k3 + k4);  
end


%%%%%% CALCULATE x,y USING ODE45 and ANALYTICAL SOLUTION %%%%%%%


%%%%%% ode45
% define xbounds for ode45()
xbounds = [x_min x_max];
% solve with ode45()
[xODE,yODE] = ode45(@calc_ode, xbounds, init_cond);


%%%%%% Analytical Solution
% The analytical solution math is shown in the project description document
% SOLUTION -->    y = ( x^2 + 1/2*x + 1 ) ^2
x_as = linspace(x_min, x_max, n_analytical);
y_as = (x_as.^2 + x_as./2 +1).^2;


%%%%%% GENERATE FINAL PLOT %%%%%%%
figure(1)
plot(x_as ,y_as,'k','linewidth',1.5) % always plot analytical
hold on

switch graph_type
    case 'a'
        plot(x,ye,'--Vr')
        legend('Analytical','Euler')
    case 'b'
        plot(x,yh,'--og')
        legend('Analytical','Heun')
    case 'c'
        plot(x,yRK,'--sb')
        legend('Analytical','Runge-Kutta')
    case 'd'
        plot(x,ye,'--Vr'), hold on
        plot(x,yh,'--og'), hold on
        plot(x,yRK,'--sb'), hold on
        plot(xODE, yODE(:,2),'--pm')
        legend('Analytical','Euler','Heun','Runge-Kutta','ode45')
end

% final plotting touches
xlabel('x'),ylabel('y'),title('Solve ODE with Different Methods')
grid on, legend('Location','NW')
toc



function [out1] = calc_ode(x,y)
    out1 = (1+4*x)*sqrt(y);
end