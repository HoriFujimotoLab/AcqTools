function [struct,rname] = mwref2struct(fname)
%MWREF2STRUCT MyWay ref table hdr-file to data structure.
%   [struct,rname] = mwref2struct(fname)
% struct : structure with 1 reference array
% fname  : name of hdr file
% Author : Thomas Beauduin, University of Tokyo
%          Hori Fujimoto lab, 29 March 2015 
%%%%%

% READ
fid = fopen(fname, 'r');
data = textscan(fid,'%f','delimiter',',','HeaderLines',2);
fclose(fid);

% PROCES
nrofs = length(data{1});
fname = strrep(fname, '.h', '.mat');
rname2 = strsplit(fname,'\');
rname3 = strrep(rname2(end), 'I', 'R');
rname = strrep(rname, char(rname2(end)), char(rname3));

% SAVE
cell = [data,nrofs];
fields = {'ref','nrofs'};
struct = cell2struct(cell,fields,2);

end
