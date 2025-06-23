function [beta, optComp, R2, RMSE, mseLOO, Y_pred] = plsLOOCV(X, Y, maxK)
    n = length(Y);
    maxK = min([size(X,2), n - 1, maxK]);  % Avoid overfitting
    mseLOO = zeros(maxK, 1);

    for k = 1:maxK
        Ypred = zeros(n,1);
        for i = 1:n
            idx = true(n,1); idx(i)=false;
            [~,~,~,~,beta_k] = plsregress(X(idx,:), Y(idx), k);
            Ypred(i) = [1, X(i,:)] * beta_k;
        end
        mseLOO(k) = mean((Y - Ypred).^2);
    end

    [~, optComp] = min(mseLOO);
    [~,~,~,~,beta] = plsregress(X, Y, optComp);
    Y_pred = [ones(n,1), X] * beta;
    R2 = 1 - sum((Y - Y_pred).^2) / sum((Y - mean(Y)).^2);
    RMSE = sqrt(mean((Y - Y_pred).^2));
end
