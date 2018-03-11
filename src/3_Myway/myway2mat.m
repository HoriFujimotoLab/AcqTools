function [mname] = myway2mat(fs_dsp,varargin)
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

W=[]; T=[]; R=[]; P=[]; A=[];
% WAVE MSR DATA
% extract wave data file from current folder (W*.csv)
wcsv = dir(strcat(pwd,'/','W*.csv'));
if exist(wcsv.name,'file') == 2
    [W,mname] = mwcsv2struct(strcat(pwd,'/',wcsv.name),fs_dsp,cname);
end

% TRC MSR DATA
% extract trace data file from current folder (T*.csv)
tcsv = dir(strcat(pwd,'/','T*.csv'));
if exist(tcsv.name,'file') == 2
    [T,tname] = mwtrc2struct(strcat(pwd,'/',tcsv.name));
end

% REF HDR DATA
% extract reference data file from current folder (R*.hdr)
rhdr = dir(strcat(pwd,'/','R*.h'));
if exist(rhdr.name,'file') == 2
    [R,rname] = mwref2struct(strcat(pwd,'/',rhdr.name));
end

% EXP PAR DATA
% extract parameters data file from current folder (P*.mat)
pmat = dir(strcat(pwd,'/','P*.mat'));
if exist(pmat.name,'file') == 2
    P = load(strcat(pwd,'/',pmat.name));
end

% ACC MSR DATA
% extract nvgate data file from current folder (A*.txt)
atxt =  dir(strcat(pwd,'/','A*.txt'));
if exist(atxt.name,'file') == 2
    [A,anm] = nvacc2struct(strcat(pwd,'/',atxt.name));
end

% MERGE DATA
% concatenate all structures into single file (D*.mat)
S = mergestruct(W,T,R,P,A);
save(mname,'-struct','S');

end

