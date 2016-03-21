function [struct,mname] = nvacc2struct(aname)
%NVACC2STRUCT NVgate acc txt-file to data structure.
%   [struct,mname] = nvacc2struct(aname)
% aname     : directory and file name of txt-file
% struct    : measurement data vectors in structure
% mname     : directory and file name of new mat file
% algorithm : low level file I/O to create data structure 
%             from NVgate accelerometer system (time-data)
% author    : Thomas Beauduin, University of Tokyo, 2015 
%%%%%

% READ
fid = fopen(aname, 'r');
HDRS = textscan(fid,'%s%s%s%s%s',17);
DATA = textscan(fid,'%f%f%f%f','HeaderLines',1);
fclose(fid);

% PROCES
fs_nv = str2double(cell2mat(HDRS{1,2}(4)));
acc_unit = HDRS{1,2}(10);
for i = 2:length(HDRS)
    ch_name(i-1) = HDRS{1,i}(8);
end
nroft_nv = length(DATA{1});
for i=1:length(DATA)
    DATA{i} = cast(DATA{i}(1:nroft_nv),'double');
end

% EXTRACT
v = 10;
X = DATA{1};
A = zeros(1,floor(length(X)/v));
for i=v:v:length(X)
    A(i/v)=mean(X(i-v+1:i));
end
M = mean(A); S = std(A); bg=1;
while A(bg)-M <= 0.8*S; bg=bg+1; end 
nd = length(A);
while A(nd)-M <= 0.8*S; nd=nd-1; end
while A(nd)-M >= 0.8*S; nd=nd-1; end

for a=1:length(DATA)
    ACC{a} = DATA{a}(bg*v:nd*v);
end
figure; t = (bg*v:1:nd*v);
subplot(221),plot(DATA{1}),hold on, plot(t,ACC{1},'r')
subplot(222),plot(DATA{2}),hold on, plot(t,ACC{2},'r')
subplot(223),plot(DATA{3}),hold on, plot(t,ACC{3},'r')
subplot(224),plot(DATA{4}),hold on, plot(t,ACC{4},'r')

% SAVE
cells = [ACC,fs_nv];
fields = [ch_name,'fs_nv'];
struct = cell2struct(cells,fields,2);
mname = strrep(aname, '.txt', '.mat');
end

