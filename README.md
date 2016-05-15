AcqTools
==========

Experimental Data Acquisition Matlab Toolbox.

## Overview

Keeping track of experimental parameters, references, data etc. of measurements is a detailed and time consuming task, which is - if not automated - clearly bug-prone. This toolbox aims to automate the acquisition from experimental setup controllers too matlab for further data analysis. The main types of setup controllers commonly used for research and development purposes are considered; ranging from Labview, Dspace and Myway Power Electronics.

## Guidelines

All subtoolboxes are based on the main principal; a single user-command to combine the data of several sources (measurment, reference, ...) to be called with the concerned data files in the same folder (pwd). The user-command searches the folder for the different files and merges the data into a single mat-file. To simplify the process, the search process is based on a naming convention for the different files based on the first letter of the file-name (written in UpperCase).

## Filenames & Extensions

1. **Dspace**
   * **D*.mat** : Dspace data mat-file
   * **R*.mat** : Reference trajectory mat-file

2. **MyWay**
   * **W*.csv** : PEView Wave csv-file
   * **T*.csv** : PEview Trace csv-file
   * **R*.h** : Embedded-C reference header-file

3. **Labview**
   * **L*.tdms** : NIlabview data tdms-file

4. **Gereral**
   * **P*.mat** : Experimental parameters mat-folder

## Versions
This toolbox has been tested for the following system versions:

* **Dspace** : Control box v1.2
* **Labview** : v2012
* **Myway** : PEview 9
