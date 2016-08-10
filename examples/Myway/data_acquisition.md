# FDI DATA ACQUISITION
This document aims to automate the experiment design and acquisition from experimental setup controllers 
too matlab for further data analysis. 
The necessary steps and user choices are clearly described in the assumption that a modular c-code 
structure is used where the user masters the acquisition details.

## Variables

- **Fs,ms:** sampling frequency of multisine
- **df,ms:** frequency resolution of multisine
- **nrofs:** number of samples of single multisine
- **nroft:** total number of experimental data points
- **nrofp:** number of multisine periods to be measured
- **Fs,fpga:**  sampling of FPGA func watch_data_8ch()
- **Fs,wave:**  sampling of acquisition defined in wave interface
- **Fs,data:**  sampling of reference signal data and controllers
- **msr:** integer counter used for triggering and data correction

## Procedures
Conventionally: Fs,fpga = Fs,wave = Fs,data
unfortunately this creates important data loss / distortions, hence:

1. nrofs = Fs,ms / df,ms  (matlab)  
magic number is 250 frequency lines to be measured (chose df, fl, fh appropriately)
2. nroft = nrofs * nrofp  (c-code)  
make sure to measure integer multiples of the signal to use periodic fft advantages
3. Fs,data = Fs,ms  (c-code)  
insert *ctrl_motion_ref()* function in a loop with the right sampling frequency
4. Fs,fpga = Fs,data OR = n \* Fs,data (better)  
Insert the myway *watch_data_8ch* function in same loop or higher sampling loop (better)
5. record_length = 2 \* nroft  
select in myway wave tabs the record length to be double nroft for data correction algorithm  
6. Fs,wave = 2 \* Fs,data  
select the *time/div* and triggering so that wave double samples the exact nrofp multisines
7. msr_trigger_level = 0 OR 1  
Select the triggering level on msr-channel as 1 is Fs,fpga = Fs,data OR as 0 is Fs,fpga = n \* Fs,data  
(in other words, if watch_data_8ch is in same loop as ctrl_motion_ref then 1 otherwise 0)