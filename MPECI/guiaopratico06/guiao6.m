%% 1.
T = [0 600  0  0  0
     8  0  100 0  0
     0  5   0  20 0
     0  0   2  0  5
     0  0   0  1  0];

% a) e b)

n = length(T);

Q = T;
for i = 1:n
    Q(i,i) = -sum(T(:,i));
end

M = [Q; ones(1, n)];
x = [zeros(n, 1); 1];
u = M \ x;

fprintf('(a) Probabilidades Estacionarias e (b) Percentagem Media de Tempo \n');
for i = 1:n
    fprintf('Estado %d | Prob. Estacionaria %.10f | Percentagem: %.6f \n', i, u(i), u(i) * 100);
end

% c)
mpt = zeros(n, 1);
for i = 1:n
    rate_out = sum(T(i, :));
    mpt(i) = 1 / rate_out;
end

fprintf('\n(c) Tempo Medio de Permanencia (min) \n');
for i = 1:n
    fprintf('Estado %d | Tempo Medio (min) %.8f \n', i, mpt(i));
end

