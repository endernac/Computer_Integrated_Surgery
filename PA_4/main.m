clear all
close all
format compact
init % This function adds all local paths
clc
%% Start Script With Filename Initializations

% Arguments to Change
problemNum = '4';
sampleReadingLetter = 'A';
fileType = 'Debug';
% fileType = 'Unknown';

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

%% Find closest points c_k on surface mesh that are closest to s_k
% Using covariance tree
tic
disp("Building covariance tree...") 
Ts = cell(N_triangles, 1);
for i = 1:N_triangles
    Ts{i} = Triangle(Mesh(iMesh(i,:)+1, :));
end
% Make covariance tree
triangle_tree = CovTreeNode(Ts, N_triangles);
toc
disp("Done building covariance tree...") 

% Compute sample points s_k, given F_reg = identity
% Do ICP algorihtm.
[F_reg, s, c3, eps_avg_store, sigma_store] = ICP(eye(4), d, triangle_tree, 100, 5, true);

% Plot errors

f = figure;
title("Error Plot")
xlabel("Iteration")
yyaxis left
plot(eps_avg_store)
ylabel("Average Epsilon")
yyaxis right
plot(sigma_store)
ylabel("Sigma") 
legend("Average Epsilon", "Sigma")

plot_name = "pa" + problemNum + "-" + sampleReadingLetter + "-Error.fig";
savefig(f,plot_name)

%% Write to File
fileID = fopen(strcat(output_path, output_filename),'w');
fprintf(fileID, "%0.0f, %s\n", N_samps, output_filename); % first line

for row = 1:N_samps
    % the rest of the lines
    fprintf(fileID, "%8.2f %8.2f %8.2f     %8.2f %8.2f %8.2f     %1.3f\n", ...
        s(row, 1), s(row, 2), s(row, 3), c3(row, 1), c3(row, 2), c3(row, 3), ...
        norm(s(row,:) - c3(row,:)));
end

fclose(fileID);
