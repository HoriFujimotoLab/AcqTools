function struct = dspace2struct(dname)
%DSPACE2STRUCT - Complex dspace mat-file to structure.
%   [struct,cname] = dspace2struct(dname)
% dname     : name of the dspace file (D*.mat)
% struct    : struct containing the data vectors
% Author    : Thomas Beauduin, University of Tokyo, 2016
%%%%%

load(dname); clear dname
structName=char(who);
time = eval([structName,'.X(1).Data;']);
nrofd = size(eval([structName,'.Y']),2);
for k=1:nrofd
    fullName = eval([structName,'.Y(k).Name']);
    index = find(fullName == '/');
    fields{k} = fullName(index(end-1)+2:index(end)-2);
    cells{k} = eval([structName,'.Y(k).Data;']);
end
struct = cell2struct(cells,fields,2);

end

