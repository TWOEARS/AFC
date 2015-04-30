% exampleInterleaved_cfg - example measurement configuration file -
%
% This matlab skript is called by afc_main when starting
% the experiment 'exampleInterleaved'.
% exampleInterleaved_cfg constructs a structure 'def' containing the complete
% configuration for the experiment.
% To design an own experiment, e.g., 'myexperiment'
% make changes in this file and save it as 'myexperiment_cfg.m'.
% The default values of all parameters are defined in 'default_cfg.m'
%
% See also help exampleInterleaved_set, exampleInterleaved_user, afc_main
%

% Copyright (c) 1999-2013 Stephan Ewert.

% general measurement procedure
def.measurementProcedure = 'transformedUpDown';	% measurement procedure
def.intervalnum = 2;				% number of intervals
def.rule = [1 1];				% [up down]-rule: [1 2] = 1-up 2-down
def.varstep = [8 3 1];				% [starting stepsize ... minimum stepsize] of the tracking variable
def.steprule = -1;				% stepsize is changed after each upper (-1) or lower (1) reversal
def.reversalnum = 6;				% number of reversals in measurement phase
def.repeatnum = 3;				% number of repeatitions of the experiment
def.ranpos = 0;						% interval which contains the test signal: 1 = first interval ..., 0 = random interval

% experimental variable (result of procedure yields dependent variable)
def.startvar = 0;				% starting value of the tracking variable
def.expvarunit = 'dB';				% unit of the tracking variable
def.expvardescription = 'Target level';	% description of the tracking variable

% limits for experimental variable
def.minvar = -100;				% minimum value of the tracking variable
def.maxvar = 100;					% maximum value of the tracking variable
def.terminate = 1;				% terminate execution on min/maxvar hit: 0 = warning, 1 = terminate
def.endstop = 2;				% Allows x nominal levels higher/lower than the limits before terminating (if def.terminate = 1) 

% experimental parameter (independent variable)
def.exppar1 = [0 0 0 0 1 1 1 1]';	% vector containing experimental parameters for which the exp is performed
def.exppar1unit = 'order';				% unit of experimental parameter
def.exppar1description = 'Presentation order';% description of the experimental parameter

% interface, feedback and messages 
def.mouse = 0;					% enables mouse/touch screen control (1), or disables (0) 
def.markinterval = 1;				% toggles visual interval marking on (1), off(0)
def.feedback = 0;				% visual feedback after response: 0 = no feedback, 1 = correct/false/measurement phase
def.messages = 'autoSelect';			% message configuration file, if 'autoSelect' AFC automatically selects depending on expname and language setting, fallback is 'default'. If 'default' or any arbitrary string, the respectively named _msg file is used.
def.language = 'EN';				% EN = english, DE = german, FR = french, DA = danish

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

% interleaved measurement
def.interleaved = 1;				% toggles block interleaving on (1), off (0)
def.interleavenum = 8; 			% number of interleaved runs

% The experiment uses multiple exppars (exppar1 ... exppar3).
% def.parrand has 3 elements for 3 exppars.
def.parrand = [0 0 0];     % toggles random presentation of the elements in "exppar" on (1), off(0)

% All exppar vectors are column vectors, which means that the different values in the rows
% are used for the (8) simultaneous tracks in the interleaved run. 
% Different columns would be for the
% consecutive runs. In this case, there will be only one run, repeated
% 3 times (def.repeatnum = 3), since the exppars have only one column. 
% Remember, in a non-interleaved run, exppars would be row vectors, containing
% the values for the consecutive runs. 

% The second parameter is the startvar, it overrides def.startvar in exampleInterleaved_set.
% It would have also been possible to define def.startvar as column vector 
%
% def.startvar = [55 85 55 85 55 85 55 85]';
%
% In this case the different startvars would not appear in the result file.
def.exppar2 = [55 85 55 85 55 85 55 85]';
def.exppar2unit = 'startvar/dB';

def.exppar3 = [8 8 16 16 8 8 16 16]';
def.exppar3unit = 'modfreq/Hz';

% eof
