# ARIA : Automatic Root Image Analysis

## A software to analyze crop plants seedling root images
#####Developed at: Ganapathysubramanian group ([ISU](https://www.me.iastate.edu/bglab))

Developed by: Nigel Lee, Marcus Naik, [Zaki Jubery](mailto:znjubery@gmail.com);

GUI development: Zaki Jubery


### Features
* Two steps process: image processing and trait extraction. User can include customized image segmentation script
* Successfully tested on maize and soybean roots. Fully automated process for soybean, does not need to user input to define starting point for the root
* Convert image into an equivalent graph. Query multiple traits simply as graph operations
* Extract traits related to root angles, number of secondary roots and overall shape of the root
* Modular framework that allows extensions  
* GUI based framework for ease of use
* Two companion papers to support the software

### Dependencies
* MATLAB (minimum version: 2018b with Image Processing Toolbox, Parallel Computing Toolbox and MATLAB Distributed Computing Server, Bioinformatics Toolbox)


### How to use it
#### Setting up:
* After downloading the source code. Run ARIA2.m function.

#### Image Processing (GUI):
* Image Location : select the location of the image folder.
* Output Location : select the location to save the processed images
* Need to define starting point : No for soybean and Yes for maize
* Imaging Method: If scanner is selected, no need to select any segmentation method 
* Number of Processor : supports up to 16
* Segmentation Method: User-defined(default), k-means
* User-defined segmentation method can be inputted via UserDefinedFunctions/createmask.m
* Processed image data will be saved in ProcessedImages subfolder in the selected Output Location
* QC* subfolders contain images for quality checking and Seg_image_data contains binary image data in *.mat format.

#### Trait Extraction (GUI):
* Image Data Location: select the location of the Seg_image_data folder
* Output Location: select the location to save the extracted trait data
* Output  will be saved in .xlsx files 
  * ExtractedTraits.xlsx : contains traditional traits along with number of secondary roots
  * Fourier_Shape_Descriptors_for_Boundary.xlsx : Elliptic Fourier Descriptors ( 100 harmonics) related to boundary of the root
  * Fourier_Shape_Descriptors_for_ConvexHull.xlsx : Elliptic Fourier Descriptors ( 100 harmonics) related to convexhull of the root
  * no_Root_at_different_depth_in_pixels_Y.xlsx : Number of roots at different depth
  * Angles_0_90_bin_2_degree.xlsx : Estimated root angle distribution using three different methods
* Quality of the trait extraction process can be checked via the 
  * Figures including skeletonized images and the original images saved in ExtractedTraits/QC_image
  * Skeletonized images and co-ordinate will be saved in ExtractedTraits/Skeleton
  * Simplified shape of the root will be saved in ExtractedTraits/Shape_Boundary and ExtractedTraits/Shape_ConHull
  * Figure related to root angles will be saved in ExtractedTraits/Angles

#### Image Processing (Autoencoder):
* To segment the images using Autoencoder with the MATLAB functions in  the MLbasedSegmentation folder

#### Description of the Traits:

- Please check the following papers.	

### Citations:

If you use ARIA please cite us

* Jordon Pace, Nigel Lee, Hsiang Sing Naik, Baskar Ganapathysubramanian, and Thomas Lubberstedt. "Analysis of maize (Zea mays L.) seedling roots with the high-throughput image analysis tool ARIA (Automatic Root Image Analysis)." PLoS One 9, no. 9 (2014): e108255.

* Kevin G. Falk, Talukder Z. Jubery, Seyed V. Mirnezami, Kyle A. Parmley, Soumik Sarkar, Arti Singh, Baskar Ganapathysubramanian, and Asheesh K. Singh. "Computer vision and machine learning enabled soybean root phenotyping pipeline." Plant methods 16, no. 1 (2020): 5.  

### Funding Acknowledgements
We gratefully acknowledge funding from  Presidential initiative for interdisciplinary research of Iowa State University and Plant Science Institute at Iowa State University.

### Feel free to raise issues and contribute to the Software.

##Contact:
Baskar Ganapathysubramanian

Mechanical Engineering

Iowa State University

baskarg@iastate.edu
