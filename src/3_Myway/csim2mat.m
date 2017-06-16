function [mname] = csim2mat(folder)
%CSIM2MAT - Ccode validation csv-file to data structure.
%
% cname     : directory and file name of csv file
% nrofd     : number of data vectors in csv file
% struct    : time & measurement data vectors in structure
% mname     : directory and file name of mat file
% Algorithm : low level file I/O to create data structure
%             from C# control validation
% Author    : Thomas Beauduin, University of Tokyo
%             Hori-Fujimoto lab, 09 March 2015 
%%%%%

% READ
scsv = dir(strcat(folder,'\','C*.csv'));
if exist(scsv.name,'file') == 0
    error('data file must follow convention: C*.csv');
end
cname = strcat(folder,'\',scsv.name);
fid = fopen(cname, 'r');
par = cell2mat(textscan(fid,'%f',1,'delimiter',','));
nrofd = par(1);
s = '%s'; f = '%f';
for i=1:nrofd
    s = strcat(s,'%s'); f = strcat(f,'%f');
end
HDRS = textscan(fid,s,1,'delimiter',',','HeaderLines',1);
DATA = textscan(fid,f,'delimiter',',','HeaderLines',1);
fclose(fid);

% PROCES
nroft = length(DATA{1});
fs = 1/((DATA{1,1}(2,1)));
mname = strrep(cname, '.csv', '.mat');

% SAVE
cell = [DATA,nroft,fs];
fields = [HDRS{:},'nroft','fs'];
struct = cell2struct(cell,fields,2);
save(strcat(mname),'-struct','struct');

end


