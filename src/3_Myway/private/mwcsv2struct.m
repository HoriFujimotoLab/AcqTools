function [struct,mname] = mwcsv2struct(fname,fs_dsp,cname)
%MWCSV2STRUCT MyWay wave csv-file to data structure.
%   [struct,mname] = mwcsv2struct(cname,fs_dsp)
% fname     : directory and file name of csv file
% fs_dsp    : sampling freq of dsp controller [Hz]
% cname     : counter header name
% struct    : time & measurement data vectors in structure
% mname     : directory and file name of mat file
% algorithm : low level file I/O to create data structure 
%             from MyWay PE-Expert3 wave system with wave-data 
%             loss and fluctuation correction
% author    : Thomas Beauduin, University of Tokyo, 2015 
%%%%%

% READ
% read csv file found on current path
fid = fopen(fname, 'r');
s = '%s'; f = '%d';
for i=1:8, s = strcat(s,'%s'); f = strcat(f,'%f'); end
HDRS = textscan(fid,s,1, 'delimiter',',');
DATA = textscan(fid,f,'delimiter',',','HeaderLines',1);
fclose(fid);

% PRE-PROCES for MSR
[~,idx] = min(abs(DATA{2}(end)-1-DATA{2}));
idx = floor(idx/2+1)*2+1;
if length(DATA{1}) ~= idx
   warning('msr ~= idx'); 
end
for k = 1:length(DATA)
    DATA{k} = DATA{k}(1:idx);
end

% PROCES
% process header names back to wave names
nroft_wave = length(DATA{1})-1;
for i = 1:length(HDRS)
    HDRS{i} = strrep(HDRS{i}, '(', '');
    HDRS{i} = strrep(HDRS{i}, ')', '');
    HDRS{i} = strrep(HDRS{i}, 'T', 't');
    HDRS{i} = strrep(HDRS{i}, '[usec]', '');
    if isempty(cell2mat(strfind(HDRS{i},'IRQ'))) == 1
        HDRS{i} = strrep(HDRS{i}, 'CH', '');
        HDRS{i} = strrep(HDRS{i}, num2str(i-1), '');
    end
    DATA{i} = cast(DATA{i}(1:nroft_wave),'double');
end
fs_wave = 1/((DATA{1}(2,1))*1e-6);
nroft = ceil(nroft_wave-mod(fs_wave,fs_dsp)*nroft_wave/fs_wave);
srate = floor(fs_wave/fs_dsp);

% TIME CORRECT
% correct time vector for required fs
% if mod(fs_wave,fs_dsp) ~= 0
%     ts = 1e6/fs_dsp/srate;
%     DATA{1} = (0:ts:nroft/fs_dsp*1e6-ts)';
% end
idx = find(strcmp([HDRS{:}], cname));

% INIT CORRECT
% correct initial data loss from wave delay
if DATA{idx}(1) ~= DATA{idx}(2)
    for d = 2:length(HDRS)
        DATA{d} = [DATA{d}(1);DATA{d}(1:end)];
    end
end
msr_first = DATA{idx}(1);

% DATA CORRECT
% remove data addition from fs error
% remove data loss from unsynchronisation
cnt_m = zeros(nroft,1);
k = msr_first;
for i=1:nroft
    cnt_m(i) = k;               % reference counter
    if mod(i,srate)==0
        k = k + 1;
    end
end
j=1; loss=0; fake=0;
for i=1:nroft
    if DATA{idx}(i) < cnt_m(i)  % shift left
        for d=2:length(HDRS)
            DATA{d}=[DATA{d}(1:i-1);DATA{d}(i+1:end)];
        end
        fake = fake + 1;
    end
    if DATA{idx}(i) > cnt_m(i)  % shift right
        for d=2:length(HDRS)
            if srate == 1       % interpolate
                DATA{d}=[DATA{d}(1:i-1);mean([DATA{d}(i-1),DATA{d}(i)]);DATA{d}(i:end)];
            else                % replace data
                DATA{d}=[DATA{d}(1:i-1);DATA{d}(i-1);DATA{d}(i:end)];
            end
        end
        loss = loss + 1;
    end
    if j > 0.1*nroft            % report progress
        fprintf('Progress: %g%% ... removed: %g, repaired: %g \n',...
                 round(100*i/nroft),fake, loss)
         j = 0;
    else j = j+1;
    end
end
fprintf('Completed!\n excess data removed: %g, lost data repaired: %g\n\n',...
         fake, loss)

for d=2:length(HDRS)            % remove excess data
    DATA{d}=DATA{d}(1:nroft);
end
if srate == 2                   % downsample data
    DATA_2 = cell(size(HDRS));      
    for d=1:length(HDRS)
        DATA_2{1,d}=zeros(nroft/2,1); k=1;
        for i=1:nroft
            if mod(i,2)~=0
                DATA_2{1,d}(k,1)=DATA{1,d}(i,1);
                k=k+1;
            end
        end
    end
    DATA = DATA_2;
end
nroft = length(DATA{1});
fs = round(double(1/((DATA{1}(2,1))*1e-6)));

% TRIGGER CORRECTION
% shift periods for trigger delay correction
while msr_first > 1
    for d=2:length(HDRS)
        DATA{d} = [DATA{d}(1); DATA{d}(1:nroft-1)];
    end
    DATA{idx}(1) = msr_first - 1;
    msr_first = msr_first - 1;
end

% SAVE
cells = [DATA,nroft,fs];
fields = [HDRS{:},'nroft','fs'];
struct = cell2struct(cells,fields,2);
struct.time = struct.time*1e-6; % usec to sec
mname = strrep(fname, '.csv', '.mat');
mname2 = strsplit(mname,'\');
mname3 = strrep(mname2(end), 'W', 'D');
mname = strrep(mname, char(mname2(end)), char(mname3));

end
