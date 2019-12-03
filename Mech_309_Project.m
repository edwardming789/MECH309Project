%%%               MECH 309 - Numerical Methods in Mech Eng                 %%%
 
% Presented to Prof Siva Nadarajah Winter 2019 - November 22th
 
%Yiming Yao 260769906
%Zechen Ren 260765431
%Randy Li 260616586
clc
close all
clear all
%% Known Variables
 
gamma = 1.4; %specific heat ratio for air
R = 287.058; %J*kg^1*K^1 gas constant
Tinf = 293; %K freestream static temperature
Pinf = 100; %kN/m^2 freestream static pressure
C = 340; %m/s speed of sound, assumed constant ???
x = 50; %x-direction domain
y = 50; %y-direction domain
Minf = 0.8; %Mach number of freestream
Uinf = Minf*sqrt(gamma*R*Tinf); %Flow speed of freestream 
toc = 0.08; % thickness ratio
xle  = 20; % Airfoil Leading Edge
xte  = 21; % Airfoil Trailing Edge
%% Initializing Variables 
dx = 0.1; % grid discrete distance
dy = 0.1; % grid discrete distance

Nx = x/dx; % x direction grid
Ny = y/dy; % y direction grid
 
phi = zeros (Nx*Ny,1); % phi initialization
phiOld = zeros (Nx*Ny,1); % phiOld initialization
miu = zeros (Nx*Ny,1); % miu initialization
 
error = Inf; % Begining with infinite error
tol = 1E-0; % Tolerence
count = 0; % Runtime counting

xspan = linspace(0,x,Nx); % x discrete spacing
    dydx = toc * (-4 * xspan + 82); % Dy/Dx
    dydx(xspan<xle | xspan>xte ) = 0; % Zero Dy/Dx outside the airfoil range 

errorlist = nan(1,1000); % Storing error

xx = linspace(19.5,21.5,21);
yy = linspace(0,1,11);
[X,Y]=meshgrid(xx,yy);
%% Question 1
% [phi,miu,A,errorlist,count] = ...
% MurmanColeSolver(phi,miu,A,a,b,c,d,e,g,error,errorlist,tol,Nx,Ny,gamma,Uinf,Minf,dydx,dy,dx,count);


%% Problem 2
l = 1;
legends{l} = nan(1,8);
for Minf = 0.75:0.02:0.89 % grid discrete distance
    
    legends{l}=  ['Mach # = ' num2str(0.73+0.02*l)];
    l = l + 1;
    % REinitializing Variables 
    dx = 0.1; % grid discrete distance
    dy = dx; % grid discrete distance

    Nx = x/dx; % x direction grid
    Ny = y/dy; % y direction grid

    phi = zeros (Nx*Ny,1); % phi initialization
    phiOld = zeros (Nx*Ny,1); % phiOld initialization
    miu = zeros (Nx*Ny,1); % miu initialization

    % PDE Coefficient initialization
    a = zeros (Nx*Ny,1);
    b = zeros (Nx*Ny,1);
    c = zeros (Nx*Ny,1);
    d = zeros (Nx*Ny,1);
    e = zeros (Nx*Ny,1);
    f = zeros (Nx*Ny,1);
    g = zeros (Nx*Ny,1);

    m = -1; % Mech number locally
    A = zeros (Nx*Ny,1); % initialize A matrix

    error = Inf; % Begining with infinite error
    count = 0; % Runtime counting

    xspan = linspace(0,x,Nx); % x discrete spacing
    dydx = toc * (-4 * xspan + 82); % Dy/Dx
    dydx(xspan<xle | xspan>xte ) = 0; % Zero Dy/Dx outside the airfoil range 

    errorlist = nan(1,1000); % Storing error

    [plotphi,cp,p,errorlist,count] = ...
    MurmanColeSolver(phi,miu,A,a,b,c,d,e, ...
    g,error,errorlist,tol,Nx,Ny,gamma,Uinf,Minf,Pinf,dydx,dy,dx,count);

     % Error
    figure (21)
    semilogy(errorlist)
    xlabel('Interations')
    ylabel('Error')
    title('Q2 Error')
    legend(legends)
    
    hold on
    % Cp Ploting
    figure (22)
    plot (X(1,:),cp(195:215,1),'o-');
    title('cp');
    xlabel('x')
    ylabel('$C_p$','interpreter','latex')
    title('Q2 Coefficient of Pressure')
    legend(legends)
    
    hold on
    % Pressure Contour
    figure 
    contourf(X,Y,p(1:11,195:215),20);
    colorbar
    set(gca,'PlotBoxAspectRatio',[2 1 1]);
    xlabel('x')
    ylabel('$P \ \ \ \ kN/m^2$','interpreter','latex')
    str = join({'Pressure ','( Mach = ',num2str(Minf),' )'});
    title(str)
end
hold off

%% Question3
Minf = 0.8;
dx = [0.025,0.05,0.1];
q = 3;
l = 1;
legends3{l} = nan(1,8);
for dx = [0.025,0.05,0.1] % grid discrete distance
    legends3{l}=  ['Delta # = ' num2str(0.025*(2^(l-1)))];
    l = l + 1;
    dy = dx;
    % REinitializing Variables 
    Nx = x/dx; % x direction grid
    Ny = y/dy; % y direction grid

    phi = zeros (Nx*Ny,1); % phi initialization
    phiOld = zeros (Nx*Ny,1); % phiOld initialization
    miu = zeros (Nx*Ny,1); % miu initialization

    % PDE Coefficient initialization
    a = zeros (Nx*Ny,1);
    b = zeros (Nx*Ny,1);
    c = zeros (Nx*Ny,1);
    d = zeros (Nx*Ny,1);
    e = zeros (Nx*Ny,1);
    f = zeros (Nx*Ny,1);
    g = zeros (Nx*Ny,1);

    m = -1; % Mech number locally
    A = zeros (Nx*Ny,1); % initialize A matrix

    error = Inf; % Begining with infinite error
    count = 0; % Runtime counting

    xspan = linspace(0,x,Nx); % x discrete spacing
    dydx = toc * (-4 * xspan + 82); % Dy/Dx
    dydx(xspan<xle | xspan>xte ) = 0; % Zero Dy/Dx outside the airfoil range 

    errorlist = nan(1,1000); % Storing error

    [plotphi,cp,p,errorlist,count] = ...
    MurmanColeSolver(phi,miu,A,a,b,c,d,e, ...
    g,error,errorlist,tol,Nx,Ny,gamma,Uinf,Minf,Pinf,dydx,dy,dx,count);

    % Cp Ploting
    xx = linspace(19.5,21.5,2/dx+1);
    yy = linspace(0,1,1/dy+1);
    [X,Y]=meshgrid(xx,yy);
    figure (32)
    plot (X(1,:),cp(19.5/dx:21.5/dx,1),'o-');
    xlabel('x')
    ylabel('$C_p$','interpreter','latex')
    title('Q3 Coefficient of Pressure')
    legend(legends3)
    hold on
end
hold off
%% Question4
l = 1;
legends4{l} = nan(1,8);
for Minf = 0.75:0.02:0.89 % grid discrete distance
    legends4{l}=  ['Mach # = ' num2str(0.73+0.02*l)];
    l = l + 1;
    % REinitializing Variables 
    dx = 0.025; % grid discrete distance
    dy = dx; % grid discrete distance

    Nx = x/dx; % x direction grid
    Ny = y/dy; % y direction grid

    phi = zeros (Nx*Ny,1); % phi initialization
    phiOld = zeros (Nx*Ny,1); % phiOld initialization
    miu = zeros (Nx*Ny,1); % miu initialization

    % PDE Coefficient initialization
    a = zeros (Nx*Ny,1);
    b = zeros (Nx*Ny,1);
    c = zeros (Nx*Ny,1);
    d = zeros (Nx*Ny,1);
    e = zeros (Nx*Ny,1);
    f = zeros (Nx*Ny,1);
    g = zeros (Nx*Ny,1);

    m = -1; % Mech number locally
    A = zeros (Nx*Ny,1); % initialize A matrix

    error = Inf; % Begining with infinite error
    count = 0; % Runtime counting

    xspan = linspace(0,x,Nx); % x discrete spacing
    dydx = toc * (-4 * xspan + 82); % Dy/Dx
    dydx(xspan<xle | xspan>xte ) = 0; % Zero Dy/Dx outside the airfoil range 

    errorlist = nan(1,1000); % Storing error

    [plotphi,cp,p,errorlist,count] = ...
    MurmanColeSolver(phi,miu,A,a,b,c,d,e, ...
    g,error,errorlist,tol,Nx,Ny,gamma,Uinf,Minf,Pinf,dydx,dy,dx,count);

    % Cp Ploting
    figure (42)
    xx = linspace(19.5,21.5,2/dx+1);
    yy = linspace(0,1,1/dy+1);
    [X,Y]=meshgrid(xx,yy);
    plot (X(1,:),cp(19.5/dx:21.5/dx,1),'o-');
    xlabel('x')
    ylabel('$C_p$','interpreter','latex')
    title('Q4 Coefficient of Pressure')
    legend(legends4)
    hold on
end