function [outputD,outputH] = read_OPTPIVOT(filename)
%function will read the optpivot data file and return a 3D matrix with the
%values properly organized

% Open the file and read the header line
fid = fopen(filename);
header = fgetl(fid);
split = strsplit(header,',');
fclose(fid);

% Get header parameters
 % N(1) = Nd - num opt markers base
 % N(2) = Nh - num opt markers probe
 % N(3) = Nframes
N = zeros(1,length(split)-1);
for i = 1:length(split)-1
    N(i) = str2double(split{i});
end
disp(N)
% Store data in format of [markers,(x,y,z),frame] ie N X 3 X Nframes
outputD = zeros(N(1),3,N(3)); % N_D, N_F 
outputH = zeros(N(2),3,N(3)); % N_H, N_F 
val = readmatrix(filename,'Range',[2 1]);

h_in = 0;
for i = 1:N(3)
    for j = 1:N(1)
        d_in = j + h_in;
        outputD(j,:,i) = val(d_in,:);    
    end
    for k = 1:N(2)
        h_in = d_in + k;
        outputH(k,:,i) = val(h_in,:);
    end
end

end