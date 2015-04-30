% exampleIdentification_cfg - example measurement configuration file -
%
% This matlab skript is called by afc_main when starting
% the experiment 'exampleConstantStimuli'.
% 'exampleConstantStimuli_cfg.m' constructs a structure 'def' containing the complete
% configuration for the experiment.
% To design an own experiment, e.g., 'myexperiment'
% make changes in this file and save it as 'myexperiment_cfg.m'.
% The default values of all parameters are defined in 'default_cfg.m'
%
% See also help exampleIdentification_set, exampleIdentification_user, afc_main
%

% Copyright (c) 1999 - 2013 Stephan Ewert. All rights reserved.

% general measurement procedure
def.measurementProcedure = 'constantStimuli';	% measurement procedure
def.intervalnum = 1;				% number of intervals
def.repeatnum = 1;				% number of repeatitions of the experiment

% experimental variable (result of procedure yields dependent variable)
def.expvar = [1 2 3 4];		% fixed values of the variable
def.expvarunit = 'Noise type';				% unit of the tracking variable
def.expvardescription = 'Noise type';	% description of the tracking variable
def.expvarnum = [3 3 3 3];  		% number of presentations of variable, same index as in expvar 
def.practice = 1;             		% enables practice presentations
def.practicenum = [1 1 1 1];		% number of practice presentations of variable, same index as in expvar
def.expvarord = 0;				% order of presentation 0 = random, others not implemented yet

% experimental parameter (independent variable)
def.exppar1 = [1];				% vector containing experimental parameters for which the exp is performed
def.exppar1unit = 'n/a';				% unit of experimental parameter
def.exppar1description = 'n/a';% description of the experimental parameter

% experimental parameter 2...N (independent variable)
% add here if required

% interface, feedback and messages 
def.mouse = 1;					% enables mouse/touch screen control (1), or disables (0) 
def.markinterval = 0;				% toggles visual interval marking on (1), off(0)
def.feedback = 1;				% visual feedback after response: 0 = no feedback, 1 = correct/false/measurement phase
def.messages = 'autoSelect';			% message configuration file, if 'autoSelect' AFC automatically selects depending on expname and language setting, fallback is 'default'. If 'default' or any arbitrary string, the respectively named _msg file is used.
def.afcwin = 'exampleIdentification_win';		% response window 'afc_win' = default
def.windetail = 1;
def.keyboardResponseButtonMapping = {'z','a','q','1'};

% save paths and save function
def.result_path = '';				% where to save results
def.control_path = '';				% where to save control files
def.savefcn = 'default';			% function which writes results to disk

% samplerate and sound output
def.samplerate = 44100;				% sampling rate in Hz
def.intervallen = 22050;			% length of each signal-presentation interval in samples (might be overloaded in 'expname_set')
def.pauselen = 22050;				% length of pauses between signal-presentation intervals in samples (might be overloaded in 'expname_set')
def.presiglen = 100;				% length of signal leading the first presentation interval in samples (might be overloaded in 'expname_set')
def.postsiglen = 100;				% length of signal following the last presentation interval in samples (might be overloaded in 'expname_set')
def.bits = 16;					% output bit depth: 8 or 16 see def.externSoundCommand for 32 bits

% computing
def.allowpredict = 0;				% if 1 generate new stimui during sound output if def.markinterval disabled

% eof
