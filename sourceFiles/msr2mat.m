function [mnm] = msr2mat(fs_dsp)
%MWMSR2MAT myway measurement data to single mat-file
%   [mnm] = msr2mat(fs_dsp)
% fs_dsp : sampling freq of dsp controller [Hz]
% mnm    : name of created data mat-file [string]
% author : Thomas Beauduin, University of Tokyo, 2015
%%%%%

% WAVE MSR DATA
data_c = []; data_n = [];
wcsv = dir(strcat(pwd,'\','W*.csv'));
if exist(wcsv.name,'file') ~= 0
    [msr,mnm] = mwcsv2struct(strcat(pwd,'\',wcsv.name),fs_dsp);
    data_c = [data_c; struct2cell(msr)];
    data_n = [data_n; fieldnames(msr)];
end

% TRC MSR DATA
tcsv = dir(strcat(pwd,'\','T*.csv'));
if exist(tcsv.name,'file') ~= 0
    [trc,tnm] = mwtrc2struct(strcat(pwd,'\',tcsv.name));
    data_c = [data_c; struct2cell(trc)];
    data_n = [data_n; fieldnames(trc)];
end

% REF HDR DATA
rhdr = dir(strcat(pwd,'\','R*.h'));
if exist(rhdr.name,'file') ~= 0
    [ref,rnm] = mwref2struct(strcat(pwd,'\',rhdr.name));
    data_c = [data_c; struct2cell(ref)];
    data_n = [data_n; fieldnames(ref)];
end

% EXP PAR DATA
pmat = dir(strcat(pwd,'\','P*.mat'));
if exist(pmat.name,'file') ~= 0
    par = load(strcat(pwd,'\',pmat.name));
    data_c = [data_c; struct2cell(par)];
    data_n = [data_n; fieldnames(par)];
end

% ACC MSR DATA
atxt =  dir(strcat(pwd,'\','A*.txt'));
if exist(atxt.name,'file') ~= 0
    [acc,anm] = nvacc2struct(strcat(pwd,'\',atxt.name));
    data_c = [data_c; struct2cell(acc)];
    data_n = [data_n; fieldnames(acc)];
end

% DAT
data_s = cell2struct(data_c,data_n,1);
save(mnm, '-struct','data_s');

end
