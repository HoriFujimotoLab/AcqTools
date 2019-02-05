function [mname] = myway2mat_all(fs_dsp,varargin)
%MWMSR2MAT myway measurement data to single mat-file
%   [mnm] = msr2mat(fs_dsp)
% fs_dsp : sampling freq of dsp controller [Hz]
% varargin:
%  <> cname: correction counter name (default: msr)
% mnm    : name of created data mat-file [string]
% author : Thomas Beauduin, University of Tokyo, 2015

nVarargs = length(varargin);
switch nVarargs
    case 0,     cname = 'msr';
    case 1,     cname = varargin{1};
    otherwise,  error('too much inputs')
end

W=[];
% WAVE MSR DATA
% extract wave data file from current folder (W*.csv)
wcsv = dir(strcat(pwd,'/','*.csv'));
N = length(wcsv);
for k = 1:N
    [W,mname] = mwcsv2struct(strcat(pwd,'/',wcsv(k).name),fs_dsp,cname);
    save(mname,'-struct','W');
end
end
