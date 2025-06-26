# Canopy CBC Estimation & Mapping using PLSR and AVIRIS Hyperspectral Data

This MATLAB project implements a full pipeline to estimate canopy Carbon-Based Compounds (CanCBC) from AVIRIS hyperspectral reflectance data using Partial Least Squares Regression (PLSR) and VIP-based band selection. The goal is to build accurate, interpretable models for vegetation biochemical traits.

---

📝 Interested reviewers — begin with main_CanCBC_model.m to run the modeling pipeline, then try map_CanCBC_fullscene.m to see the spatial application in action.

## 📁 Files and Structure

- `main_CanCBC_model.m`: Main script performing the full analysis workflow.
- `plsLOOCV.m`: Modular function for PLSR with Leave-One-Out Cross-Validation.
- `vipBandSelection.m`: Function to compute VIP scores and select informative spectral bands.

---

## 🚀 Workflow Overview

A) Training phase: 
Script: main_CanCBC_model.m

- Steps 1–5 are Model Training

1. **Data Loading**
   - Inputs: 
     - `Rmes1` — Reflectance matrix
     - `CanCBC_mes` — Biochemical trait (target)
     - `R` — Wavelength vector
   - Shape: `X = [samples x bands]`, `Y = [samples x 1]`

2. **Step 1: Outlier Detection**
   - Z-score method: removes rows (samples) with extreme spectral values.

3. **Step 1.5: Normalization**
   - Z-score normalization applied column-wise to reflectance data. In this step it is standardizes each spectral band (zero mean, unit variance).

4. **Step 2: PLSR with LOOCV**
   - Determines optimal number of components for regression (through leave-one-out cross-validation method). 

5. **Step 3: VIP-Based Band Selection**
   - Identifies and selects bands with (Variable Importance in Projection) VIP > 1 to reduce dimensionality and focus on the most informative wavelengths to explain the trait we are focusing on. 
 
6. **Step 4: Reduced PLSR Model**
   - PLSR model built using only VIP-selected bands.

7. **Step 5: Model Comparison**
   - Outputs and compares R², RMSE, and band reduction between full and VIP models.


B) Mapping phase 
Script: map_CanCBC_fullscene.m

Step 6: Mapping CanCBC Across the Full Scene (NEW)
Workflow:
- Load the trained PLSR outputs: beta_VIP, selectedBands, mu_train, sigma_train.
- Read the clipped AVIRIS hyperspectral image (GeoTIFF).
- Reshape the 3D image into a 2D pixel-by-band matrix.
- Extract and normalize VIP-selected bands using training statistics.
- Apply the PLSR model to compute CanCBC for each pixel (Yhat = [1, Xn] * beta_VIP).
- Reconstruct the predicted values into a 2D map.
- Export the map as a georeferenced GeoTIFF and visualize the results.

---

## 📊 Outputs

A) Training phase (main_CanCBC_model): 

Scatter plots:  (predicted vs actual), error curves, cumulative variance, and model metrics.

Saved File --> CanCBC_PLSR_results.mat containing:
- R2, RMSE: Full model metrics
- R2_VIP, RMSE_VIP: VIP-reduced model metrics
- selectedBands: Indices of VIP-selected spectral bands
- beta_optimal, beta_VIP: PLS regression coefficients

B) Mapping phase (map_CanCBC_fullscene.m):

CanCBC_map_estimated.tif — georeferenced canopy CBC raster
Quick visualization preview using MATLAB plotting

---

## 🛠 Requirements

- MATLAB R2022b or newer (recommended)
- Statistics and Machine Learning Toolbox
- Mapping Toolbox

---

## 📎 Notes

- Script is adaptable to estimate other leaf traits (e.g., LMA, protein, nitrogen).
- Modular design enables rapid testing and extension to other sensors (not just AVIRIS).
 **Ensure proper spatial referencing (e.g. EPSG code) when creating GeoTIFF outputs.
- Modular scripts allow batch processing or integration into web GIS platforms (Leaflet, GBIF portals).
- The mapping step is optimized for large images using block or parallel processing strategie
- **No input data is provided** due to academic data-sharing constraints. The workflow remains reproducible with user-supplied data.
-

---
