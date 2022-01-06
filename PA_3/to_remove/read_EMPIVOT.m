function [output] = read_EMPIVOT(filename)
%function will read the empivot data file and return a 3D matrix with the
%values properly organized

% Open the file and read the header line
fid = fopen(filename);
header = fgetl(fid);
split = strsplit(header,',');
fclose(fid);

%% Get header parameters
N = zeros(1,length(split)-1); % N(1) = Ng - num EM markers; N(2) = Nframes
for i = 1:length(split)-1
    N(i) = str2double(split{i});
end

%%
% Store data in format of [markers,(x,y,z),frame] ie Ng X 3 X Nframes
output = zeros(N(1),3,N(2));
val = readmatrix(filename,'Range',[2 1]);

for i = 1:N(2)
    for j = 1:N(1)
        out_idx = (i-1)*N(1)+j;
        output(j,:,i) = val(out_idx,:);
    end
    
end

end

