function [struct,mname] = mwtrc2struct(cname)
%MWTRC2STRUCT MyWay trace csv-file to data structure.
%   [struct,mname] = mwtrc2struct(cname)
% cname     : name of trace data csv-file [string]
% struct    : time array and measurement data arrays [structure]
% mname     : directory and file name of mat file [string]       
% Author    : Thomas Beauduin, University of Tokyo
%             Hori-Fujimoto Lab, 09 March 2015 
%%%%%

% READ
fid = fopen(cname, 'r');
HDRS = textscan(fid,'%s%s%s%s%s%s%s%s%s',1, 'delimiter',',');
DATA = textscan(fid,'%u%f%f%f%f%f%f%f%f','delimiter',',','HeaderLines',1);
fclose(fid);

% PROCES
HDRS(:,1) = []; DATA(:,1) = []; j=0;
for i = 1:length(HDRS)
    HDRS{i-j} = strrep(HDRS{i-j}, '(', '');
    HDRS{i-j} = strrep(HDRS{i-j}, ')', '');
    HDRS{i-j} = strrep(HDRS{i-j}, 'w', 't');
    HDRS{i-j} = strrep(HDRS{i-j}, 'CH', '');
    HDRS{i-j} = strrep(HDRS{i-j}, num2str(i-j), '');
    if  cell2mat(strfind(HDRS{i-j},'****')) > 0
        HDRS(:,i-j) = []; DATA(:,i-j) = [];
        j=j+1;
    end
end
mname = strrep(cname, '.csv', '.mat');

% SAVE
struct = cell2struct(DATA,[HDRS{:}],2);
end


