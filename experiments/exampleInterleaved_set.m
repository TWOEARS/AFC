% exampleInterleaved_set - setup function of experiment 'exampleInterleaved' -
%
% This function is called by afc_main when starting
% the experiment 'exampleInterleaved'. It defines elements
% of the structure 'set'. The elements of 'set' might be used 
% by the function 'exampleInterleaved_user.m'.
% 
% If an experiments can be started with different experimental 
% conditions, e.g, presentation at different sound preasure levels,
% one might switch between different condition dependent elements 
% of structure 'set' here.
%
% For most experiments it is also suitable to pregenerate some 
% stimuli here.
% 
% To design an own experiment, e.g., 'myexperiment',
% make changes in this file and save it as 'myexperiment_set.m'.
% Ensure that this function does exist, even if absolutely nothing 
% is done here.
%
% See also help exampleInterleaved_cfg, exampleInterleaved_user, afc_main

function exampleInterleaved_set

global def
global work
global setup

% make condition dependend entries in structure set

switch work.condition
case 'cd1'
	% this uses a setup were the output for a digital signal with 0 dB FullScale rms is
   	work.currentCalLevel = 110;
case 'cd2'
   	work.currentCalLevel = 100;
otherwise
   error('condition not recognized');
end

% The level of the refernce signal in the experiment is
setup.reflevel = 70;

% override the startvar for all interleaved tracks
% WARNING: Unlike in non-interleaved experiments, you must not
% have access to any of the work.expparN directly.
% You can access work.expparN for track i using work.int_expparN{i}.
% In the _user file work.expparN can be accessed like usual and holds the correct value
% for the current run.
% Actually, this are the start levels in the different tracks 
for (i = 1:def.interleavenum)
   work.expvarnext{i} = work.int_exppar2{i};
end

% define signals in structure set

setup.hannlen = round(0.05*def.samplerate);
setup.window = hannfl(def.intervallen,setup.hannlen,setup.hannlen);

% eof