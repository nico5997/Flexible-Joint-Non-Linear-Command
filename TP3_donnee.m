%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Commande Non Lineaire 
%   TP 3
%
%   Supprimer les %%% et remplacer les ...... par ce qu'il convient!
%
%   philippe.muellhaupt@epfl.ch
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all

% Declarer les symboles utilises
syms x1 x2 x3 x4 u I J M G L K k real

% QUESTIONs 1-6
% Definir les fonctions pour le crochet de Lie et la derivee de Lie
LieBr = @(f1,f2) simplify(jacobian(f2, [x1 x2 x3 x4])*f1 - jacobian(f1, [x1 x2 x3 x4])*f2);
LieDer = @(f,v) simplify(jacobian(f, [x1 x2 x3 x4])*v);

% QUESTION 1
% D�finir les champs de vecteurs f et g
f = [x2;
     -((M*G*L)/I)*sin(x1) - (1/I)*(k + (x1-x3)^2)*(x1-x3);
     x4;
     (1/J)*(k + (x1-x3)^2)*(x1-x3)];

g = [0;
     0;
     0;
     1/J];

% QUESTION 2
% Construire les distributions C et Cbar
Cbar = [g, LieBr(f, g), LieBr(f, LieBr(f,g))];
C = [g, LieBr(f, g), LieBr(f, LieBr(f, g)), LieBr(f, LieBr(f, LieBr(f,g)))];

% V�rifier l'accessibilit� (rang de C)
'Acessibility check:'

R = subs(C, [x1 x2 x3 x4 u I J M G L K k], [0 0 0 0 u I J M G L K k]);
R = rank(C);

% V�rifier l'involutivit� de Cbar
'Involutivity check:'

Cbar_check = [LieBr(Cbar(:, 1), Cbar(:, 2)), LieBr(Cbar(:, 1), Cbar(:, 3)), ...
    LieBr(Cbar(:, 2), Cbar(:, 3))];

dtemp = 0;
for i = 1 : 3
    d = simplify(det([Cbar_check(:, i), Cbar]));
    
    if (d == 0)
        dtemp = dtemp + 1;
    end
end

disp('Déterminant: '); disp(d);

% QUESTION 3
% Construire la forme qui annule Cbar
N = null(Cbar');

% QUESTION 4
% Int�grer omeg "� la main" (facile!)
'Integral of omega:'

h =x1;

% Construire le changement de coordonn�es z = Phi(x)
'Change of coordinates:'
z1 = h;
z2 = LieDer(h, f);
z3 = LieDer(z2, f);
z4 = LieDer(z3, f);
z = [z1; z2; z3; z4];

% Gains sur le syst�me lin�aire
k = [1 4 6 4];
v = -k * z;

% QUESTION 5
% Fonction de bouclage pour le système non-linéaire:
% beta =  1/( LieDer(g, LieDer(h, LieDer(h, LieDer(h, f)))) );
beta =  1/(LieDer(LieDer(LieDer(LieDer(h, f), f), f), g));
alpha = LieDer(LieDer(LieDer(LieDer(h, f), f), f), f);


u =  beta*(v - alpha);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Simulation

%Parametres
I=0.1;         %inertie du bras articule
J=0.001;       %inertie du premier axe de rotation
K=0.1;          %constante de rappel du ressort
M=0.1;          %Masse de la sortie
L=0.3;          %1/2 longueur de l objet en sortie
G=10;           %gravite terrestre
k=1;

% Substituer les valeurs num�riques des param�tres dans les expressions
us = subs(u);
fs = subs(f);
gs = subs(g);

% Creer une fonction � partir de ces expressions
dynamique = matfunc(fs+gs*us,'vars',[x1 x2 x3 x4]); % MATLAB >= R2008b
%%% dynamique = matfunc(fs+gs*us,'vars',[x1 x2 x3 x4]);     % MATLAB < R2008b

% Conditions initiales
x0 = [.1,-.1,.2,0.1];
tspan=[0 25];

% Simulation num�rique du syst�me boucl�
[t,xx] = ode45(@(t,x) dynamique(x(1),x(2),x(3),x(4)),tspan,x0);

plot(t,xx)
title('Syst�me boulc�')
xlabel('t')
ylabel('x_1(t), x_2(t), x_3(t), x_4(t)')

