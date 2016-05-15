function [mname] = labv2mat(varagin)
%LABV2MAT Import data from labview experiment.
%
% Assembles all the data of a single experiment:
%   - bin-file  : (R) reference signal/excitation
%   - tdms-file : (T) measuments acquired by labview
%   - mat-file  : (P) experiment/excitation parameters
% into a single data (D) mat-file
%
% author : Thomas Beauduin, KULeuven, 2014
%%%%%
data_c = []; data_n = [];

% Reference Signal (binary-file)
rbin = dir(strcat(pwd,'\','R*.bin'))
if exist(rbin.name,'file') ~= 0
    fileID=fopen(rbin.name,'r');
    dini=fread(fileID,inf,'int8');
    ini=zeros(length(dini)+1,1); temp=0;
    for w=1:length(dini)
        temp=temp+dini(w);
        ini(w+1)=temp;
    end
    fclose(fileID);
    str.ref=ini;
    data_c = [data_c; struct2cell(str)];
    data_n = [data_n; fieldnames(str)];
end

% Measurement signals (tdms-file)
tdms = dir(strcat(pwd,'\','T*.tdms'));
if exist(tdms.name,'file') ~= 0
    filename=simpleConvertTDMS(strcat(pwd,'\',tdms.name));
    m=load(filename{1,1});
    tdata.set=m.UntitledSetPosition.Data;
    tdata.act=m.UntitledActPosition.Data;
    tdata.vib=m.UntitledVibrometer.Data;
    data_c = [data_c; struct2cell(tdata)];
    data_n = [data_n; fieldnames(tdata)];
    tname = strrep(tdms.name, '.tdms', '.mat');
    mname = strrep(tname, 'T', 'D');
    delete(tname);
end

% Experiment Parameters (mat-file)
pmat = dir(strcat(pwd,'\','P*.mat'));
if exist(pmat.name,'file') ~= 0
    par = load(strcat(pwd,'\',pmat.name));
    data_c = [data_c; struct2cell(par)];
    data_n = [data_n; fieldnames(par)];
end

% Assemble data (mat-file)
data_s = cell2struct(data_c,data_n,1);
save(mname, '-struct','data_s');

