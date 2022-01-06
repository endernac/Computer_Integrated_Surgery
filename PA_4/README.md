# CIS-I

File Structures

PA_4 - includes MATLAB code for programming assignment 4

  data - all the data from the website.
    
  output - all the output files generated from the different data files.
    
  main.m - File the grader should run to execute the ICP algorithm. Edit the inputs near the top to change the files used. problemNumfor PA #4 will always be 4, sampleReadingLetter corresponds to the dierent scenarios posed by the text files, and fileType can be either "debug" or "unknown." The output will be savedin the output folder with the designated file name.
    
  init.m - This file adds all files and les in sub-directories to the path. It is run at the beginning of main to initialize the paths needed.

  programs - all programs for PA4

    generate_outputs.m - runs the main le multiple times for all text files given.

    ICP.m - Performs the ICP algorithm.

    CalcStats.m - Calculates the standard deviation, maximum error, and average error given a residual matrix.

    TerminationTest.m - Contains a termination criteria to determine when the ICP algorithm has converged.

    test data - Folder of data used for unit testing.

      generate_cube.m - makes a cube in 3D space ranging from (+/-1,+/-1,+/-1) and saves it to cube.mat
      
      generate_rectangular_prism_mat.m - makes a rectangular box in 3D space ranging from (+/-1,+/-2,+/-3) and saves it to rect_prism.mat
      
      cube.mat - output file from generate_cube.m
      
      rect_prism.mat - output file frome generate_rectangular_prism_mat.m

    unit testing - Files here are for unit testing different functions. We will go into more depth in the testing section.

      ICP_Box_Unit_Testing.m - Tests that the ICP algorithm can correctly reconstruct three transformations on a box mesh: rotation, translation, and rotation + translation.

      ICP_Box_Unit_Testing.m - Tests that the ICP algorithm can correctly reconstruct three transformations on the Problem4MeshFile.sur mesh: rotation, translation, and rotation + translation.

    util - Files here are general usage functions used throughout main.m as well as the unit tests, all from previous programming assignments.

      kinematic - kinematic library to make coding more like math

      registrations - functions used from PA#1 and PA#2 for pivot calibration or point cloud registration (least squares)

      read - functions that read from text files from the specified hw format

      tree_search - functions and data structures from HW3 that build a triangular mesh, and allow for the rapid searching of points close to the mesh via a covariance tree
