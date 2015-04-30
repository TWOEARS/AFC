% exampleCalscript_set - setup function of experiment 'exampleCalscript' -
%
% This function is called by afc_main when starting
% the experiment 'exampleCalscript'. It defines elements
% of the structure 'setup'. The elements of 'setup' are used 
% by the function 'exampleCalscript_user.m'.
% 
% If an experiments can be started with different experimental 
% conditions, e.g, presentation at different sound preasure levels,
% one might switch between different condition dependent elements 
% of structure 'setup' here.
%
% For most experiments it is also suitable to pregenerate some 
% stimuli here.
% 
% To design an own experiment, e.g., 'myexperiment',
% make changes in this file and save it as 'myexperiment_set.m'.
% Ensure that this function does exist, even if absolutely nothing 
% is done here.
%
% See also help exampleCalscript_cfg, exampleCalscript_user, afc_main

function exampleCalscript_set

global def
global work
global setup

% define signals in structure set

setup.modsine = sin([0:def.intervallen-1]'*2*pi*work.exppar1/def.samplerate);
setup.hannlen = round(0.05*def.samplerate);
setup.window = hannfl(def.intervallen,setup.hannlen,setup.hannlen);

% output level in dB SPL rms

setup.level = 65; 

% eof