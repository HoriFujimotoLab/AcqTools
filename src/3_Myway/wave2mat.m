function [mname] = wave2mat(fs_dsp,varargin)
%WAVE2MAT myway measurement data to mat-file
%         processes multiple .csv files in pwd
%   [mnm] = msr2mat(fs_dsp)
% fs_dsp : sampling freq of dsp controller [Hz]
% varargin:
%  <> cname: correction counter name (default: msr)
% mnm    : name of created data mat-file [string]
% author : Wataru Ohnishi, University of Tokyo, 2018

nVarargs = length(varargin);
switch nVarargs
    case 0,     cname = 'msr';
    case 1,     cname = varargin{1};
    otherwise,  error('too much inputs')
end

% WAVE MSR DATA
% extract wave data file from current folder (W*.csv)
wcsv = dir(strcat(pwd,'/','*.csv'));
mname = cell(1,length(wcsv));
for k = 1:length(wcsv)
    if exist(wcsv(k).name,'file') == 2
        fprintf('open %s\n',wcsv(k).name);
        [W,mname{k}] = mwcsv2struct(strcat(pwd,'/',wcsv(k).name),fs_dsp,cname);
        save(mname{k},'-struct','W');
    end
end

end
