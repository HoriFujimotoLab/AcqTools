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
wcsv = dir(strcat(pwd,'\','W*.csv'));
NROFF = length(wcsv);
if NROFF ~= 0
    for kk = 1:1:NROFF
        [W,mname] = mwcsv2struct(strcat(pwd,'\',wcsv(kk).name),fs_dsp,cname);
        % MERGE DATA
        % concatenate all structures into single file (D*.mat)
        S = mergestruct(W,T,R,P,A);
        save(mname,'-struct','S');
        fprintf('%s',mname);
    end
end

% TRC MSR DATA
% extract trace data file from current folder (T*.csv)
tcsv = dir(strcat(pwd,'\','T*.csv'));
NROFF = length(tcsv);
if NROFF ~= 0
    for kk = 1:1:NROFF
        [T,tname] = mwtrc2struct(strcat(pwd,'\',tcsv(kk).name));
        % MERGE DATA
        % concatenate all structures into single file (D*.mat)
        S = mergestruct(W,T,R,P,A);
        save(mname,'-struct','S');
        fprintf('%s',mname);
    end
end

% REF HDR DATA
% extract reference data file from current folder (R*.hdr)
rhdr = dir(strcat(pwd,'\','R*.h'));
NROFF = length(rhdr);
if NROFF ~= 0
    for kk = 1:1:NROFF
        [R,rname] = mwref2struct(strcat(pwd,'\',rhdr(kk).name));
        % MERGE DATA
        % concatenate all structures into single file (D*.mat)
        S = mergestruct(W,T,R,P,A);
        save(mname,'-struct','S');
        fprintf('%s',mname);
    end
end

% EXP PAR DATA
% extract parameters data file from current folder (P*.mat)
pmat = dir(strcat(pwd,'\','P*.mat'));
NROFF = length(pmat);
if NROFF ~= 0
    for kk = 1:1:NROFF
        P = load(strcat(pwd,'\',pmat(kk).name));
        % MERGE DATA
        % concatenate all structures into single file (D*.mat)
        S = mergestruct(W,T,R,P,A);
        save(mname,'-struct','S');
        fprintf('%s',mname);
    end
end

% ACC MSR DATA
% extract nvgate data file from current folder (A*.txt)
atxt =  dir(strcat(pwd,'\','A*.txt'));
NROFF = length(atxt);
if NROFF ~= 0
    for kk = 1:1:NROFF
        [A,anm] = nvacc2struct(strcat(pwd,'\',atxt(kk).name));
        % MERGE DATA
        % concatenate all structures into single file (D*.mat)
        S = mergestruct(W,T,R,P,A);
        save(mname,'-struct','S');
        fprintf('%s',mname);
    end
end

end

