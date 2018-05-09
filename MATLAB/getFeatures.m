% Returns features of component
function features = getFeatures(W, S)
% Normalised weights
if min(W) < 0
    W = W + abs(min(W));
else
    W = W - min(W);
end
W = W / max(W);

%% Other parameters
outer = [43, 41, 39, 30, 25, 22, 23, 24, 29, 38, 40, 44, 42, 46, 55, 60, ...
            63, 62, 64, 61, 56, 47, 45];
inner = [1:21, 26:28, 31:37, 48:54, 57:59];
  
features = [kurtosis(W); var(W); mean(W); mean(W(22:29)); mean(W(outer)); ...
            mean(W(inner)); max(W(outer)); skewness(W)];
