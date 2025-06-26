%% Canopy CBC Mapping Using Trained PLSR Model

% Load trained model variables from your PLSR workflow
load('CanCBC_PLSR_results.mat', ...
    'selectedBands', 'beta_VIP', 'mu_train', 'sigma_train');

% 1. Read the clipped hyperspectral image (GeoTIFF or similar)
[img, R] = geotiffread('ClipForest_All425Bands.tif');
[rows, cols, nbands] = size(img);
fprintf('Loaded image with %d rows, %d columns, %d bands\n', rows, cols, nbands);

% 2. Reshape the 3D image cube into 2D matrix:
%    - Each row = one pixel spectrum of length "nbands"
X = reshape(img, rows * cols, nbands);

% 3. Select only the VIP bands used in the model:
%    - This matches what you used during model training
Xvip = X(:, selectedBands);

% 4. Normalize each pixel:
%    - Use the same mean & std values from training (mu_train, sigma_train)
%    - Ensures consistency between training and prediction phases
Xn = (Xvip - mu_train(selectedBands)) ./ sigma_train(selectedBands);

% 5. Add a column of ones to include the PLSR intercept term (beta_0):
Xn = [ones(size(Xn,1), 1), Xn];

% 6. Apply the trained model coefficients to compute predictions:
%    - Matrix multiplication yields predicted CanCBC per pixel
Yhat = Xn * beta_VIP;  % [numPixels x 1] vector of CanCBC predictions

% 7. Reshape predictions back into the original image dimensions:
CanCBC_map = reshape(Yhat, rows, cols);

% 8. Save the predicted map as a GeoTIFF with geospatial referencing:
coordRefSysCode = 'EPSG:32633';  % Adjust to match your data's CRS
geotiffwrite('CanCBC_map_estimated.tif', CanCBC_map, R, 'CoordRefSysCode', coordRefSysCode);
fprintf('Canopy CBC map exported as CanCBC_map_estimated.tif\n');

% 9. Visualize the result:
figure;
imagesc(R.XWorldLimits, R.YWorldLimits, flipud(CanCBC_map));
axis image;  % Keep aspect ratio
set(gca, 'YDir', 'reverse');  % Align y-axis correctly
colormap(jet); colorbar;
title('Predicted Canopy CBC Map');
xlabel('Easting (m)');
ylabel('Northing (m)');
