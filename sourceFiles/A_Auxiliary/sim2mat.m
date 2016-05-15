function [mname] = sim2mat(cname)
%SIM2MAT C#-code validation csv-file to data structure.
%   [mname] = sim2mat(cname)
% cname     : directory and file name of csv file
% mname     : directory and file name of mat file
% Author    : Thomas Beauduin, University of Tokyo
%             Hori-Fujimoto lab, 09 March 2015
%%%%%

% READ
fid = fopen(cname, 'r');
par=cell2mat(textscan(fid,'%f%f',1,'delimiter',','));
nrofd = par(1); nrofs=par(2);
s = '%s'; f = '%f';
for i=1:nrofd
    s=strcat(s,'%s'); f=strcat(f,'%f');
end
HDRS = textscan(fid,s,1,'delimiter',',','HeaderLines',1);
DATA = textscan(fid,f,'delimiter',',','HeaderLines',1);
fclose(fid);

% PROCES
nroft = length(DATA{1});
fs = 1/((DATA{1,1}(2,1)));
mname = strrep(cname, '.csv', '.mat');

% SAVE
cell = [DATA,nrofs,nroft,fs];
fields = [HDRS{:},'nrofs','nroft','fs'];
struct = cell2struct(cell,fields,2);
save(strcat(mname),'-struct','struct');

end


