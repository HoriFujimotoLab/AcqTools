function [file] = traject2hdr2(varargin)
%REF2HDR - Export reference vector to header file.
%   [file] = traject2hdr2(traject1, traject2, ... )
%
% INPUT = structure of reference trajectory data
% Multiple data structures possible, minimum 1 required
%   <>.vec  : vector containing numberic values
%   <>.res  : numerical resolution in hdr (default: '%.10f')
%   <>.fmt  : C-type numerical format     (default: 'far float')
%   <>.cmt  : comments describing vector  (default: empty)
%   <>.vnm  : vector name                 (default: struct)
%   <>.fnm  : folder name                 (default: pwd)
% Author    : Thomas Beauduin, University of Tokyo
%             Hori-Fujimoto lab, 2017
%%%%%

for i=1:nargin
    % extract data and include defaults if necessary
    d = defaults(varargin{i});
    
    % initilize header file
    if i == 1
        file = [d.fnm, '\R', d.vnm, '.h'];
        fid = fopen(file,'w');
        nrofs = length(varargin{1}.vec);
        fprintf(fid,d.cmt);
        
        fprintf(fid,'#define NROFS %d \n', nrofs);
    end
    
    % print data vector
    fprintf(fid,[d.fmt ' %s[%s] = { \n'],d.vnm,'NROFS');
    for j=1:nrofs-1
        if strfind(d.res,'f'), fprintf(fid, d.res, d.vec(j));
        else                   fprintf(fid, d.res, round(d.vec(j)));
        end
        
        if mod(j,10) == 0,   fprintf(fid, '\n');
        end
    end
    
    % print last data point
    res_end = strrep(d.res,',','');
    if strfind(d.res,'f'), fprintf(fid, res_end, d.vec(nrofs));
    else                   fprintf(fid, res_end, round(d.vec(nrofs)));
    end
    fprintf(fid,'\n }; \n \n');
end
fclose(fid);
end

function [d] = defaults(d)
    if ~isfield(d,'res'), d.res = '%.10f, ';    end
    if ~isfield(d,'fmt'), d.fmt = 'far float';  end
    if ~isfield(d,'vnm'), d.vnm = 'test';       end
    if ~isfield(d,'fnm'), d.fnm = pwd;          end
end
