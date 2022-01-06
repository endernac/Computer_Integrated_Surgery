# CIS-I

File Structures

PA_3 - includes MATLAB code for programming assignment 3

  data - all the data from the website.
    
  output - all the output files generated from the different data files.
    
  programs - all programs for PA3
  
    data_structures - folder for classes used for different search methods
    
      BoundingSphere.m - class for bounding sphere. I forget if I use this anywhere
      
      CovTreeNode.m - Covariance tree class. Implements the functions for the search as well as for tree building.
      
      Thing.m - was going to do some inheritence with Triangle.m but did not end up using this.
      
      Triangle.m - Triangle data structure
      
    test_data - folder of data used for unit testing
    
      generate_cube.m - makes a cube in 3D space ranging from (+/-1,+/-1,+/-1) and saves it to cube.mat
      
      generate_rectangular_prism_mat.m - makes a rectangular box in 3D space ranging from (+/-1,+/-2,+/-3) and saves it to rect_prism.mat
      
      cube.mat - output file from generate_cube.m
      
      rect_prism.mat - output file frome generate_rectangular_prism_mat.m
      
    unit_testing - files here are for unit testing different functions. The name is pretty self explanatory. Not all are used, I need to clean up the unimportant ones.
    
      calc_sphere_unit_test.m
      
      Class_Unit_Testing.m
      
      CovTreeNode_Unit_Testing.m
      
      CovTreeSearch_Unit_Testing.m
      
      Find_Closest_Point_Mesh_Unit_Testing.m
      
      Find_Closest_Point_Unit_Testing.m
      
      Project_On_Segment_Unit_Testing.m
      
      Triangle_Unit_Testing.m
      
    generate_outputs.m - runs the main file multiple times for all text files given 
    
    Project_On_Segment.m - 
    
    Find_Closest_Point_Triangle.m - finds closest point on a triangle
    
    Find_Closest_Point_Mesh - implements brute force search for closest point on mesh, as well as a linear search w/ bounding spheres
    
    calc_sphere.m - creates bounding sphere of a triangle
    
  util - folder of accumulated utility files for various homework assignments
  
    accuracy - functions here are for ease of report writing
      
    assert - functions here help with some unit tests (boolean)
    
    kinematic - kinematic library to make coding more like math
    
    read - functions that read from text files from the specified hw format
    
    registrations - functions used from PA#1 and PA#2 for pivot calibration or point cloud registration (least squares)
  
  init.m - This file adds all local paths to path.
  
  main.m - this file runs what is asked for by the assignment
