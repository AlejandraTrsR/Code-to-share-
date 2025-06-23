function [VIP, selectedBands, X_vip] = vipBandSelection(Xn, Y, ncomp, R, vipThresh)
    % Calculate VIP scores and select bands with VIP > vipThresh
    % Inputs:
    % - Xn: normalized predictor matrix
    % - Y: response vector
    % - ncomp: number of PLS components (from prior LOOCV)
    % - R: wavelength vector
    % - vipThresh: threshold for VIP (default = 1)

    if nargin < 5, vipThresh = 1; end

    [~,~,XS,YS,~,~,~,stats] = plsregress(Xn, Y, ncomp);
    W0 = stats.W ./ sqrt(sum(stats.W.^2,1));  % normalize weights
    sumSq = sum(XS.^2,1) .* sum(YS.^2,1);
    VIP = sqrt(size(Xn,2) * sum(W0.^2 .* sumSq,2) / sum(sumSq));

    % Select bands with VIP > threshold
    selectedBands = find(VIP > vipThresh);
    X_vip = Xn(:, selectedBands);

    % Plot VIP scores
    figure;
    bar(R, VIP);
    hold on;
    yline(vipThresh, '--k', 'VIP = 1');
    xlabel('Wavelength (nm)');
    ylabel('VIP Score');
    title('VIP Scores Across Spectral Bands');
    grid on;
    hold off;
end
