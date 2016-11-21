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

% improve by printing the name of the repeated arrays
if nrofs > 1
    [data_nu,idx1,idx2] = unique(data_n,'last');
    idx_rep = setdiff(idx2,idx1);
    if numel(data_nu) ~= numel(data_n),
        data_c = data_c(idx1,:);
        data_n = data_n(idx1,:);
        %for i=1:length(idx_rep)
        %    test = data_n{idx_rep(i)}
            %isa(test,'array')
            %fprintf();
            %fprintf(strcat('Warning: repeated fieldnames:\n\t\t',...
            %                data_n(idx_rep),...
            %               'so probably data lost in mergestruct. \n'));
        %end
    end
end
Y = cell2struct(data_c,data_n,1);

end
