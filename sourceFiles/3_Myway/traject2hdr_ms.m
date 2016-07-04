function [path] = traject2hdr_ms(signal,folder,file,harm, Hampl, options)
%REF2HDR Export reference vector to c# myway header file for multisine with options.
%   [path] = ref2hdr (type,signal,fname)
% signal    : reference vector
% folder    : subfolder from current path
% file      : name of header file, required format: R...ref.h
% Algorithm : low level file I/O to create header for
%             MyWay PE-Expert3 system (MWPE-C6713A DSP)
% Author    : Thomas Beauduin, University of Tokyo
%             Wataru Ohnishi, University of Tokyo
%             Hori-Fujimoto lab, 08 March 2015
%%%%%
fid = fopen(strcat(folder,file),'w');
nrofs = size(signal,1);


switch nargin
    case 6
        fprintf(fid, '// CREST FACTOR = %f\n',max(abs(signal)));
        fprintf(fid, '// SIGNAL LENGTH = %d [ms]\n\n',nrofs*1e3/harm.fs);
        fprintf(fid, '/* HARMONICS PARAMETERS \n');
        fprintf(fid, '** ----------------------- \n');
        fprintf(fid, '** fs = %f [Hz]: sampling frequency \n', harm.fs);
        fprintf(fid, '** df = %f [Hz]: frequency resolution \n', harm.df);
        fprintf(fid, '** fl = %f [Hz]: lowest frequency \n', harm.fl);
        fprintf(fid, '** fh = %f [Hz]: highest frequency \n', harm.fh);
        if strcmp(options.gtp,'q')
            fprintf(fid, '** fr = %f : frequency log ratio \n', harm.fr);
        end
        fprintf(fid, '*/ \n\n');
        
        fprintf(fid, '/* DESIGN OPTIONS \n');
        fprintf(fid, '** ----------------------- \n');
        fprintf(fid, '** itp = %s : init phase type:  s=schroeder/r=random \n', options.itp);
        fprintf(fid, '** ctp = %s : compression type: c=comp/n=no_comp \n', options.ctp);
        fprintf(fid, '** dtp = %s : signal type:      f=full/ O=odd-odd \n**                             o=odd / O2=special odd-odd\n', options.dtp);
        fprintf(fid, '** gtp = %s : grid type: l=linear/q=quasi-logarithmic \n', options.gtp);
        fprintf(fid, '*/ \n\n');        

        [num,den] = tfdata(minreal(Hampl),'v');
        fprintf(fid, '/* AMPLITUDE SPECTRUM \n');
        fprintf(fid, '** ----------------------- \n');
        fprintf(fid, '** tf([num,den]) \n');
        fprintf(fid, '** num = [ ');
        fprintf(fid, '%e ', num);
        fprintf(fid, ']\n');
        fprintf(fid, '** den = [ ');
        fprintf(fid, '%e ', den);
        fprintf(fid, ']\n');
        fprintf(fid, '*/ \n\n');  
end


%name = strrep(file,'.h','');
%array_name = strrep(name,'R','');
%nrofs_name = upper(strrep(array_name,'ref',''));
array_name = 'refvec';
nrofs_name = 'NROFS';
fprintf(fid,'#define %s %d \n', nrofs_name, nrofs);
fprintf(fid,'far float %s [%s] = { \n',array_name,nrofs_name);

j = 0;
for i=1 : nrofs
    fprintf(fid, '%.10f, ', signal(i));
    j=j+1;
    if j == 10
        fprintf(fid, '\n'); j = 0;
    end
end
fprintf(fid,'}; \n');
fclose(fid);

path = strcat(folder,'\',file);
end
