%% Task 2

%1.3
%{
nLista= 1e4;
t= tic;
lista= randperm(nLista);
tempo= toc(t);
fprintf('Running time= %.2f msec.\n',tempo*1000)
%}

% 1.4
nIter= 1e5;     % numero de listas
nLista= 1e5;    % numero de elementos
tempos= zeros(1,nIter);     % Vetor com os tempos
for i= 1:nIter
     t= tic;
     lista= randperm(nLista);   % Cria lista
     tempos(i)= toc(t);         % Adiciona ao vetor o tempo para fazer a lista
end
avTime= mean(tempos);           % media dos tempos
maxTime= max(tempos);           % tempo maximo
temposOrdenados= sort(tempos);  % ordena os tempos
perTime= temposOrdenados(round(0.95*nIter));    % variavel para calcular o percentil 95% dos tempos
fprintf('Average time = %.2f msec\n',avTime*1000);
fprintf('95%% perc. time = %.2f msec\n',perTime*1000);
fprintf('Maximum time = %.2f msec\n',maxTime*1000);


