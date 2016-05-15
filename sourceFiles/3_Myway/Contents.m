% MWPE3 Data Acquisition Toolbox
% Version 1.0 (R2013a) 24-Nov-2015 
%  
% Data Acquisition
%   msr2mat - measurement files to single mat-file
%             automatically extracts all possible data from
%             current directory and run correction algorithms.
%   mdl2hdr - state-space model to header-file
%             automatically create control/plant Embedded-C parameters
%             designed to compile C just after matlab run without user.  
%   ref2hdr - reference traject to header-file
%             automatically create large trajectory reference.
%             header-files from matlab array variable. 
%   sim2mat - C# simulation (visual studio) to mat-file
%             automatically extract C# simulation csv-file data to matlab.
%   
% Auxiliary
%   mwcsv2struct - Run mlint for file or folder, reporting results in browser
%   mwref2struct - Reference header-file data extraction (security)
%   mwtrc2struct - MyWay trace data csv-file extraction & processing
%   nvacc2struct - Accelerometer data csv-file extraction & processing
%
% Author: Thomas Beauduin, University of Tokyo, 2015