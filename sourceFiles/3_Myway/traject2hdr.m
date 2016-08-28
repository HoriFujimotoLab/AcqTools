function [path] = traject2hdr(signal,folder,file,format_name,array_name)
%REF2HDR Export reference vector to c# myway header file.
%   [path] = traject2hdr(signal, folder, file, array_name)
% signal    : reference vector
% folder    : subfolder from current path
% file      : name of header file, required format: R...ref.h
% format_name: format name (optional), default: 'far float'
% array_name: name of array in C-code (optional), default : refvec[NROF]
% Algorithm : low level file I/O to create header for
%             MyWay PE-Expert3 system (MWPE-C6713A DSP)
% Author    : Thomas Beauduin, University of Tokyo
%             Hori-Fujimoto lab, 08 March 2015
%%%%%

if nargin < 4
    format_name = 'far float';
end

if nargin < 5
    array_name = 'refvec';
    nrofs_name = 'NROFS';
else
    nrofs_name = ['NROFS_' array_name];
end


nrofs = size(signal,1);

fid = fopen(strcat(folder,file),'w'); % file open
%name = strrep(file,'.h','');
%array_name = strrep(name,'R','');
%nrofs_name = upper(strrep(array_name,'ref',''));
%array_name = 'refvec';
fprintf(fid,'#define %s %d \n', nrofs_name, nrofs);
fprintf(fid,[format_name ' %s [%s] = { \n'],array_name,nrofs_name);

j = 0;
for i=1 : nrofs
    if isempty(strfind(format_name,'int')) == 1
        fprintf(fid, '%.10f, ', signal(i));
    else
        fprintf(fid, '%d, ', round(signal(i)));
    end
    j=j+1;
    if j == 10
        fprintf(fid, '\n'); j = 0;
    end
end
fprintf(fid,'}; \n');

fclose(fid); %file closed

path = strcat(pwd,'\',file);
end
