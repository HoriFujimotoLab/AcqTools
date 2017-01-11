function [path] = traject2hdr(inp, file, res, nm_vec)
%REF2HDR Export reference vector to c# myway header file.
%   
% vec    : reference vector
% file   : name of header file, required format: R..._ref.h
% nm_vec : name of array in C-code (optional), default : refvec[NROF]
% Author : Thomas Beauduin, University of Tokyo
%          Hori-Fujimoto lab, December 2016
%%%%%
if ~iscell(inp), vec{1} = inp;
else             vec = inp;             end
if nargin < 3, res = '%.10f, ';         end
if nargin < 4, nm_vec{1} = 'refvec';    end
if ~iscell(nm_vec), nm_vec{1} = nm_vec; end
nm_format = 'far float';
nm_nrofs = 'NROFS';

fid = fopen(file,'w');
nrofs = length(vec{1});
fprintf(fid,'#define %s %d \n', nm_nrofs, nrofs);

nrofd = length(vec);
for d=1:nrofd
    fprintf(fid,[nm_format ' %s [%s] = { \n'],nm_vec{d},nm_nrofs);

    j = 1;
    for i=1:nrofs-1
        if strfind(res,'f'), fprintf(fid, res, vec{d}(i));
        else                 fprintf(fid, res, round(vec{d}(i)));
        end
        if j == 10,          fprintf(fid, '\n'); j = 0; end
        j=j+1;
    end
    res_e = strrep(res,',','');
    if strfind(res,'f'), fprintf(fid, res_e, vec{d}(nrofs));
    else                 fprintf(fid, res_e, round(vec{d}(nrofs)));
    end
    fprintf(fid,'\n }; \n \n');
end
fclose(fid);

path = file;
end
