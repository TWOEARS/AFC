% example_set - setup function of experiment 'example' -
%
% This function is called by afc_main when starting
% the experiment 'example'. It defines elements
% of the structure 'setup'. The elements of 'setup' are used 
% by the function 'example_user.m'.
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
% See also help exampleMix_cfg, exampleMix_user, afc_main

function exampleMix_set

global def
global work
global setup

% make condition dependend entries in structure set

switch work.condition
case 'cd1'
   setup.level=75;
case 'cd2'
   setup.level=60;
otherwise
   error('condition not recognized');
end

% define the calibration level (assume 90 dB SPL for 0 dB FS)
work.currentCalLevel = 100;

% define signals in structure setup
setup.modsine = sin([0:def.intervallen-1]'*2*pi*work.exppar1/def.samplerate);
setup.hannlen = round(0.05*def.samplerate);
setup.window = hannfl(def.intervallen,setup.hannlen,setup.hannlen);

% eof