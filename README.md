# x31 lymphocytic Infiltration Analysis Script

A two‐part MATLAB script that:

1. **Quantifies** tissue infiltration from segmentation masks  
2. **Generates** QC overlay images

- Images were downloaded at 1000 dpi + 3Mpx from PathViewer (through Omero) - at 0.75xMag
---

## Part 1: Compute Metrics

- **Inputs**  
  - `imageDir` – folder of raw TIFFs (not used in loop) 
  - `objDir` – folder of mask TIFFs (labels: 1=infiltration, 2=lung, 3=background)  
    - mask TIFFs are generated with **ilastik**
    
- **Loop over** each `*.tif` in `objDir`:  
  1. Load `objIm = imread(...)`  
  2. Count pixels:  
     - `backgroundArea = sum(objIm==3)`  
     - `lungArea       = sum(objIm==2)`  
     - `infiltArea     = sum(objIm==1)`  
  3. Calculate:  
     - `infilt2lungRatio = infiltArea / lungArea`  
     - `totLungArea      = lungArea + infiltArea`  
     - `infiltPercOfLung = (infiltArea / totLungArea)*100`  
  4. Append `[filename, ratio, totArea, percent]` to `output`

---

## Part 2: Generate QC Images

- **Inputs**  
  - `imageFile` – example histology RGB TIFF  
  - `objFile` – corresponding mask TIFF  

- **Steps**:  
  1. Build logical masks:  
     - `bgMask` (background), `infiltMask`, `lungMask`  
  2. **Background removal**: set background pixels to white → save `original.png`, `image1.png`  
  3. **Overlay masks** using `insertObjectMask`:  
     - Infiltration → `image2.png`  
     - Lung          → `image3.png`  

---

## Outputs

- **`output`** cell array with per‐file metrics  
- **QC images**:  
  - `original.png`  
  - `image1.png` (bg removed)  
  - `image2.png` (infiltration mask)  
  - `image3.png` (lung mask)
