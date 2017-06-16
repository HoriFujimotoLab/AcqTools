function Ename = dspace2mat(path)
%DSPACE2MAT - Dspace experiment to single mat-file.
%
% path  : folder path containing relevant files
% Ename : name of the created data mat-file
% Author: Thomas Beauduin, University of Tokyo, 2016
%%%%%

D=[]; R=[]; P=[];
% DSPACE MSR DATA
% extract dspace data file from current folder (D*.mat)
dmat = dir(strcat(path,'\','D*.mat'));
if exist(dmat.name,'file') ~= 0
    D = dspace2struct(strcat(pwd,'\',dmat.name));
end

% REF MAT DATA
% extract reference signal file from current folder (R*.mat)
rmat = dir(strcat(path,'\','R*.mat'));
if exist(rmat.name,'file') ~= 0
    R = load(strcat(pwd,'\',rmat.name));
end

% EXP PAR DATA
% extract parameters data file from current folder (P*.mat)
pmat = dir(strcat(path,'\','P*.mat'));
if exist(pmat.name,'file') ~= 0
    P = load(strcat(pwd,'\',pmat.name));
end

% MERGE EXPERIMENT DATA
% concatenate all structures into single file (E*.mat)
S = mergestruct(D,R,P);
Ename = strrep(dmat.name,'D','E');
save(Ename,'-struct','S');

end
