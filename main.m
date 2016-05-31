function main
close all;
clear;
clc;
%se inicia el c?lculo de tiempo computacional
tiempo_inicio = cputime;

%se definen variables globales para la lectura de archivo
global features;
global class;
global feat1;
global feat2;
global feat3;
global feat4;
global feat5;
global feat6;
global feat7;
global feat8;
global feat9;
global feat10;
global feat11;
global feat12;
global feat13;
global feat14;
global feat15;
global feat16;
global feat17;
global feat18;
global feat19;
global feat20;
global feat21;
global feat22;
global feat23;
global feat24;
%global feat25;
%global feat26;
%global feat27;
%global feat28;
%global feat29;
%global feat30;
%global feat31;
%global feat32;
%global feat33;
%global feat34;
%global id;
%Se realiza la lectura de los distintos data set

%pima indians
%[feat1,feat2,feat3,feat4,feat5,feat6,feat7,feat8,class] = textread('pima-indians-diabetes.data.txt' ,'%d%d%d%d%d%f%f%d%d','delimiter', ',');

%wisconsin breast cancer
%[id,class,feat1,feat2,feat3,feat4,feat5,feat6,feat7,feat8,feat9,feat10,feat11,feat12,feat13,feat14,feat15,feat16,feat17,feat18,feat19,feat20,feat21,feat22,feat23,feat24,feat25,feat26,feat27,feat28,feat29,feat30] = textread('wdbc.data.txt' ,'%d%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','delimiter', ',');

%inosfera
%[feat1,feat2,feat3,feat4,feat5,feat6,feat7,feat8,feat9,feat10,feat11,feat12,feat13,feat14,feat15,feat16,feat17,feat18,feat19,feat20,feat21,feat22,feat23,feat24,feat25,feat26,feat27,feat28,feat29,feat30,feat31,feat32,feat33,feat34,class] = textread('ionosphere.data.txt' ,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%s','delimiter', ',');

%australian
%[feat1,feat2,feat3,feat4,feat5,feat6,feat7,feat8,feat9,feat10,feat11,feat12,feat13,feat14,class] = textread('australian.dat.txt' ,'%d%f%f%d%d%d%f%d%d%d%d%d%d%d%d','delimiter', ' ');

%german ver cual es el delimitador
[feat1,feat2,feat3,feat4,feat5,feat6,feat7,feat8,feat9,feat10,feat11,feat12,feat13,feat14,feat15,feat16,feat17,feat18,feat19,feat20,feat21,feat22,feat23,feat24,class] = textread('german.data-numeric.txt' ,'%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d','delimiter', ' ');

%Se definen par?metros del algoritmo gen?tico
tournamentSize = 5; %Tama?o del torneo
features = 24; %N?mero de features
parameters = 2; %N?mero de parametros de la svm. Se multiplica por 8 para generar los vectores necesarios.
popSize = 50; %Tama?o poblaci?n inicial

% Poblaci?n Inicial. Primeros n bits corresponden a los features. Y los
% ultimos 16 bits corresponden a los par?metros C y sigma de la SVM.
initialPop = (rand(popSize, (features+(parameters*8)))> rand);

options = gaoptimset;
% Par?metros de la poblaci?n
options = gaoptimset(options,'PopulationSize' , popSize); %Tama?o de poblaci?n
options = gaoptimset(options, 'PopulationType' , 'bitstring'); %Tipo de poblaci?n
options = gaoptimset(options, 'InitialPopulation', initialPop); %Poblaci?n inicial

% Criterios de parada
options = gaoptimset(options, 'Generations', 100); %Verificar si sirve con 100...
options = gaoptimset(options,'StallGenLimit', 100); %Verificar si sirve con 100...

% Operador de selecci?n
options = gaoptimset(options, 'SelectionFcn', {@selectiontournament,tournamentSize}); %Selecci?n por torneo
options = gaoptimset(options, 'EliteCount', 2); %Considerar 2 individuos para el elitismo

% Algoritmo de cruce
options = gaoptimset(options, 'CrossoverFcn', {@crossoverscattered}); %Cruce manteniendo una parte del padre y otra de la madre
options = gaoptimset(options, 'CrossoverFraction', 0.9); %90% de la siguiente poblaci?n es generada a partir de los hijos

% Algoritmo de mutaci?n
options = gaoptimset(options ,'MutationFcn', {@mutationuniform, 0.1}); %Muta de forma uniforme con ratio de 0.1

%Salida
options = gaoptimset(options, 'Display', 'iter'); %No muestra ejecuci?n de algoritmo.
options = gaoptimset(options, 'PlotInterval', 1); %Por cada generaci?n muestra un ploteo
options = gaoptimset(options,'PlotFcns',{@gaplotbestf @gaplotbestindiv}); %Se plotea el mejor fitness y el fitness medio

[x, Fval, ~, Output, population, ~]= ga(@fitness,features+(parameters*8),options);

fprintf('The best gen was : \n');
disp(x)
%fprintf('The final population was: \n');
%disp(population)
fprintf('The number of generations was : %d\n', Output.generations);
fprintf('The number of function evaluations was : %d\n', Output.funccount);
fprintf('The best function value found was : %g\n', Fval);

%se calcula el tiempo total de computo en CPU
total = cputime - tiempo_inicio;
fprintf('The computational time is : %g\n', total);
end

%Funci?n de fitness que se basa en el performance logrado por la SVM.
function val = fitness(x) 

%se llaman las variables globales
global features;
global class;
global feat1;
global feat2;
global feat3;
global feat4;
global feat5;
global feat6;
global feat7;
global feat8;
global feat9;
global feat10;
global feat11;
global feat12;
global feat13;
global feat14;
global feat15;
global feat16;
global feat17;
global feat18;
global feat19;
global feat20;
global feat21;
global feat22;
global feat23;
global feat24;
%global feat25;
%global feat26;
%global feat27;
%global feat28;
%global feat29;
%global feat30;
%global feat31;
%global feat32;
%global feat33;
%global feat34;

%se crea la matriz de caracter?sticas considerando la representaci?n del
%string del algoritmo gen?tico
if any(x(1:features))
    data   = [feat1,feat2,feat3,feat4,feat5,feat6,feat7,feat8,feat9,feat10,feat11,feat12,feat13,feat14,feat15,feat16,feat17,feat18,feat19,feat20,feat21,feat22,feat23,feat24];
    data_new = [];
    for i=1:features
        %se a?ade la caracter?stica en caso que sea 1 en el string del GA
        if(x(i) == 1);
            data_new = [data_new data(:,i)];
        end
    end
    c = 1;
    sigma = 1;
    %c?lculo de parametro C de la SVM
    vec_c = x(features+1:features+8);
    for i = 1:length(vec_c)
        c = c + 2^(i-1)*vec_c(i);
    end
    %en caso que C pueda ser 0 se iguala por 1
    if (c == 0);
        c = 1;
    end
    
    %calculo del par?metro sigma del kernel de base radial
    vec_sigma = x(features+9:features+16);
    for i = 1:length(vec_sigma)
        sigma = sigma + 2^(i-1)*vec_sigma(i);
    end
    
    val = svm_classifier(data_new,class,sigma,c);
    %Se multiplica por -1 para transformar el problema de minimizaci?n en
    %maximizaci?n del performance
    val = -val;
else
   val = 0;%Castigo para los que son puros 0 >D
end
end