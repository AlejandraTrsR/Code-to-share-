# Canopy CBC Estimation using PLSR and AVIRIS Hyperspectral Data

This MATLAB project implements a full pipeline to estimate canopy Carbon-Based Compounds (CanCBC) from AVIRIS hyperspectral reflectance data using Partial Least Squares Regression (PLSR) and VIP-based band selection. The goal is to build accurate, interpretable models for vegetation biochemical traits.

---

## 📁 Files and Structure

- `main_CanCBC_model.m`: Main script performing the full analysis workflow.
- `plsLOOCV.m`: Modular function for PLSR with Leave-One-Out Cross-Validation.
- `vipBandSelection.m`: Function to compute VIP scores and select informative spectral bands.

---

## 🚀 Workflow Overview

1. **Data Loading**
   - Inputs: 
     - `Rmes1` — Reflectance matrix
     - `CanCBC_mes` — Biochemical trait (target)
     - `R` — Wavelength vector
   - Shape: `X = [samples x bands]`, `Y = [samples x 1]`

2. **Step 1: Outlier Detection**
   - Z-score method: removes rows with extreme spectral values.

3. **Step 1.5: Normalization**
   - Z-score normalization applied column-wise to reflectance data.

4. **Step 2: PLSR with LOOCV**
   - Determines optimal number of components for regression.

5. **Step 3: VIP-Based Band Selection**
   - Selects bands with VIP > 1 to reduce dimensionality and focus on informative wavelengths.

6. **Step 4: Reduced PLSR Model**
   - PLSR model built using only VIP-selected bands.

7. **Step 5: Model Comparison**
   - Outputs and compares R², RMSE, and band reduction between full and VIP models.

---

## 📊 Outputs

- Predicted vs actual scatter plots
- Mean Squared Error (MSE) vs components
- Cumulative variance explained
- Model metrics: R², RMSE, selected band count

---

## 🛠 Requirements

- MATLAB R2022b or newer (recommended)
- Statistics and Machine Learning Toolbox

---

## 📎 Notes

- Script is adaptable to estimate other leaf traits (e.g., LMA, protein, nitrogen).
- Modular design enables rapid testing and extension to other datasets or sensors.
- ⚠️ **No input data is provided** due to academic data-sharing constraints. The workflow remains reproducible with user-supplied data.

---
