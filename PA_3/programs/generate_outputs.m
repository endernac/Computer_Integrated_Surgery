clear all
close all
format compact
init % This function adds all local paths
clc
%% Start Script With Filename Initializations

% Arguments to Change
problemNum = '3';
sampleReadingLettersDebug = ['A','B','C','D','E','F'];
sampleReadingLettersUnknown = ['G','H','J'];

%% Run main for debug files
fileType = 'Debug';
for i = 1:length(sampleReadingLettersDebug)
    main(problemNum, sampleReadingLettersDebug(i), fileType)
end

%% Run main for unknown files
fileType = 'Unknown';
for i = 1:length(sampleReadingLettersUnknown)
    main(problemNum, sampleReadingLettersUnknown(i), fileType)
end

function main(problemNum, sampleReadingLetter, fileType)
    % Create Input Filenames From Input
    bodyAFilename = "Problem" + problemNum + "-BodyA.txt";
    bodyBFilename = "Problem" + problemNum + "-BodyB.txt";
    meshFilename = "Problem" + problemNum + "MeshFile.sur";
    sampleReadingFilename = "PA" + problemNum + '-' + sampleReadingLetter ...
        + '-' + fileType + "-SampleReadingsTest.txt";

    % Create Output filenames
    output_filename = "pa" + problemNum + "-" + sampleReadingLetter ...
        + "-Output.txt";
    output_path = "./output/";
    %% Read in files

    [N_A, A, A_tip] = read_ProblemX_BodyY(bodyAFilename);
    [N_B, B, B_tip] = read_ProblemX_BodyY(bodyBFilename);
    [N_vertices, N_triangles, Mesh, iMesh] = read_ProblemXMesh(meshFilename);
    [N_D, N_samps, a, b, ~] = ...
        read_SampleReadings(sampleReadingFilename, N_A, N_B);

    %% Find F_{A,k} and F_{B,k}
    F_A = zeros(4,4,N_samps);
    F_B = zeros(4,4,N_samps);
    d = zeros(N_samps, 3);
    % Calculate F_A and F_B with respect to the tracker, as well as d.
    for i = 1:N_samps
        F_A(:,:,i) = Point_Cloud_Registration(A, a(:,:,i));
        F_B(:,:,i) = Point_Cloud_Registration(B, b(:,:,i));
        d(i, :) = homoify(SE3_INV(F_B(:,:,i)) * F_A(:,:,i) * homoify(A_tip).').';
    end

    %% Compute sample points s_k, given F_reg
    F_reg = eye(4);
    s = homoify(F_reg * homoify(d).');

    %% Find closest points c_k on surface mesh that are closest to s_k
    % Using brute force search
    disp("Conducting brute force search...") 
    tic
    c1 = zeros(N_samps, 3);
    for i = 1:N_samps
        c1(i,:) = Find_Closest_Point_Mesh(s(i,:), Mesh, iMesh);
    end
    toc
    disp("Brute force search done")

    % Using covariance tree
    tic
    disp("Building covariance tree...") 
    c3 = zeros(N_samps, 3);
    N_triangles = length(iMesh);
    Ts = cell(N_triangles, 1);
    for i = 1:N_triangles
        Ts{i} = Triangle(Mesh(iMesh(i,:)+1, :));
    end
    % Make covariance tree
    triangle_tree = CovTreeNode(Ts, N_triangles);
    toc
    disp("Done building covariance tree...") 

    % Search tree for point closes to s_k
    disp("Searching covariance tree...") 
    tic
    % [d, c_] = triangle_tree.FindClosestPoint(Ts{152}.center, bound, closest)
    for i = 1:N_samps
        bound = realmax;
        closest = [realmax, realmax, realmax];
        [~, c3(i,:)] = triangle_tree.FindClosestPoint(s(i,:), bound, closest);
    end
    toc
    disp("Done searching covariance tree...") 

    disp("The average difference between the brute force and covariance tree search is: ")
    disp(mean(c3-c1, 1))

    %% Write to File
    fileID = fopen(strcat(output_path, output_filename),'w');
    fprintf(fileID, "%0.0f, %s\n", N_samps, output_filename); % first line

    for row = 1:N_samps
        % the rest of the lines
        fprintf(fileID, "%8.2f %8.2f %8.2f     %8.2f %8.2f %8.2f     %1.3f\n", ...
            d(row, 1), d(row, 2), d(row, 3), c3(row, 1), c3(row, 2), c3(row, 3), ...
            norm(d(row,:) - c3(row,:)));
    end

    fclose(fileID);
end