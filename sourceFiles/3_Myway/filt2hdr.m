function [path] = filt2hdr(file, title, header, filter)
%FILT2HDR controller export to MyWay C# header-file.
% [path] = ctrl2hdr(file, title, header, filter)
% file      : header-file name      (string)
% title     : header-file title     (string)
% header    : filter text headers   (cells-of-strings)
% filter    : filter matrix data    (cells-of-structures)
% author    : Wwataru Ohnishi, University of Tokyo, 2016
%%%%%

% FILE: data header-file
fid = fopen(file,'w');
fprintf(fid,strcat('//',char(title),'\n'));

% MODELS: structures with matrices
for i=1:length(filter)
    fprintf(fid,strcat('//',char(header{i}),'\n'));
    matrix_name = fieldnames(filter{i});
    
    % MATRIX: state-space data matrix
    for j=1:length(matrix_name)
        matrix_size = size(filter{i}.(char(matrix_name(j))));
        str = char(strcat('float\t',matrix_name(j),...
            '[',num2str(matrix_size(1)),']',...
            '[',num2str(matrix_size(2)),']','\t='));
        for n=1:matrix_size(1)
            if n==1; str = strcat(str,'{\n \t{');
            else     str = strcat(str,'},\n \t{');
            end
            for m=1:matrix_size(2)
                if m==1; str = strcat(str,'%.15e');
                else     str = strcat(str,',%.15e');
                end
            end
        end
        str = strcat(str,'}\n \t};\n');
        data = [];
        for k=1:matrix_size(1)
            data = [data,filter{i}.(char(matrix_name(j)))(k,:)];
        end
        fprintf(fid,str,data);
    end
    fprintf(fid,'\n');
    
end
fclose(fid);
path = strcat(pwd,'\',file);

end