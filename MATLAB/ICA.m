% FastICA algorithm pulled from wiki
function [S, W] = ICA(data, C)

[N, M] = size(data);
% center the data
data = data - sum(data, 2)/M;

% whiten the data
covar = cov(data');
[V, D] = eig(covar);
X = V * D^(-1/2) * V' * data;

% FastICA
syms g(u) gDer(u)
%g(u) = tanh(u);
%gDer(u) = 1 - (tanh(u))^2;

W = zeros(N, C);
o = ones(M, 1);
for p = 1:C
    wp = rand(N, 1);
    wp_old = zeros(N, 1);
    count = 0;
    while wp ~= wp_old
        wp_old = wp;
        
        wp = ( X * tanh(wp' * X)' - 1 - tanh(wp' * X).^2 * o * wp ) / M;
        %wp = eval((wp - mean(X * g(wp' * X)) - mean(wp' * X * g(wp' * X)) * wp)/ ...
        %            (mean(gDer(wp' * X)) - mean(wp' * X * g(wp' * X))));
        
        % decorrelate the outputs
        s = zeros(1, N);
        for j = 1:(p-1)
            s = s + wp' * W(:, j) * W(:, j)';
        end
        wp = wp - s';
        
        wp = wp / norm(wp);
        if count > 1000 
            break;
        end
        count = count + 1;
    end
    
    W(:, p) = wp;
end

S = W' * X;



        
    

