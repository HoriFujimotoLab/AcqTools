function Y = mergestruct(varargin)
% MERGESTRUCT - merge multiple different structures.
%       X = CATSTRUCT(S1,S2,S3,...) 
% Sx    : structures to concatenate
% A     : structure with merged fields
% note  : if a fieldname is not unique among structures, 
%         only value from last structure with this field is used.
% author: Thomas Beauduin, University of Tokyo, 2016

data_c = []; 
data_n = [];
nrofs = 0;

for ii=1:nargin,
    X = varargin{ii};
    if ~isempty(X),
        if ~isstruct(X),
            error('catstruct:InvalidArgument',...
                 ['Argument #' num2str(ii) ' is not a structure.']) ;
        else
            data_c = [data_c; struct2cell(X)];
            data_n = [data_n; fieldnames(X)];
            nrofs = nrofs+1;
        end
    end
end

if nrofs > 1
    [data_nu,idx] = unique(data_n,'last');
    if numel(data_nu) ~= numel(data_n),
        data_c = data_c(idx,:) ;
        data_n = data_n(idx,:) ;
        disp('catstruct: Fieldnames not unique between structures.');
    end
end
Y = cell2struct(data_c,data_n,1);

end
