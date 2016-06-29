function [struct,mname] = mwcsv2struct(cname,fs_dsp)
%MWCSV2STRUCT MyWay wave csv-file to data structure.
%   [struct,mname] = mwcsv2struct(cname,fs_dsp)
% cname     : directory and file name of csv file
% fs_dsp    : sampling freq of dsp controller [Hz]
% struct    : time & measurement data vectors in structure
% mname     : directory and file name of mat file
% algorithm : low level file I/O to create data structure 
%             from MyWay PE-Expert3 wave system with wave-data 
%             loss and fluctuation correction
% author    : Thomas Beauduin, University of Tokyo, 2015 
%%%%%

% READ
% read csv file found on current path
fid = fopen(cname, 'r');
HDRS = textscan(fid,'%s%s%s%s%s%s%s%s%s',1, 'delimiter',',');
DATA = textscan(fid,'%u%f%f%f%f%f%f%f%f','delimiter',',','HeaderLines',1);
fclose(fid);

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
if mod(fs_wave,fs_dsp) ~= 0
    ts = 1e6/fs_dsp/srate;
    DATA{1}=(0:ts:nroft/fs_dsp*1e6-ts)';
end

% INIT CORRECT
% correct initial data loss from wave delay
idx = find(strcmp([HDRS{:}], 'msr'));
if DATA{idx}(1) ~= DATA{idx}(2)
    for d=2:length(HDRS)
        DATA{d}=[DATA{d}(1);DATA{d}(1:end)];
    end
end
k=DATA{idx}(1);

% DATA CORRECT
% remove data addition from fs error
% remove data loss from unsynchronisation
cnt_m=zeros(nroft,1);
for i=1:nroft
    cnt_m(i)=k;                 % reference counter
    if mod(i,srate)==0
        k=k+1;
    end
end

for d=2:length(HDRS)
    for i=1:nroft
        if DATA{idx}(i) < cnt_m(i)      % shift left
            DATA{d}=[DATA{d}(1:i-1);DATA{d}(i+1:end)];
        end
        if DATA{idx}(i) > cnt_m(i)      % shift right
            if srate == 1               % interpolate
                DATA{d}=[DATA{d}(1:i-1);mean([DATA{d}(i-1),DATA{d}(i)]);DATA{d}(i:end)];
            else                        % replace data
                DATA{d}=[DATA{d}(1:i-1);DATA{d}(i-1);DATA{d}(i:end)];
            end
        end
    end
    DATA{d}=DATA{d}(1:nroft);           % remove fake data
end

if srate == 2                           % downsample data
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

% SAVE
cells = [DATA,nroft,fs];
fields = [HDRS{:},'nroft','fs'];
struct = cell2struct(cells,fields,2);
mname = strrep(cname, '.csv', '.mat');
mname = strrep(mname, 'W', 'D');
end
