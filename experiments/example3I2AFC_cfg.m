% example2I3AFC_cfg - example measurement configuration file -
%
% This matlab skript is called by afc_main when starting
% the experiment 'example2I3AFC'.
% example2I3AFC_cfg constructs a structure 'def' containing the complete
% configuration for the experiment.
% To design an own experiment, e.g., 'myexperiment'
% make changes in this file and save it as 'myexperiment_cfg.m'.
% The default values of all parameters are defined in 'default_cfg.m'
%
% See also help example2I3AFC_set, example2I3AFC_user, example2I3AFC_msg, afc_main
%

% Copyright (c) 1999-2013 Stephan Ewert.

% general measurement procedure
def.measurementProcedure = 'transformedUpDown';	% measurement procedure
def.intervalnum = 3;				% number of intervals
def.rule = [1 2];				% [up down]-rule: [1 2] = 1-up 2-down
def.varstep = [4 2 1];				% [starting stepsize ... minimum stepsize] of the tracking variable
def.steprule = -1;				% stepsize is changed after each upper (-1) or lower (1) reversal
def.reversalnum = 6;				% number of reversals in measurement phase
def.repeatnum = 1;				% number of repeatitions of the experiment

% experimental variable (result of procedure yields dependent variable)
def.startvar = -6;				% starting value of the tracking variable
def.expvarunit = 'dB';				% unit of the tracking variable
def.expvardescription = 'Modulation index';	% description of the tracking variable

% limits for experimental variable
def.minvar = -100;				% minimum value of the tracking variable
def.maxvar = 0;					% maximum value of the tracking variable
def.terminate = 1;				% terminate execution on min/maxvar hit: 0 = warning, 1 = terminate
def.endstop = 3;				% Allows x nominal levels higher/lower than the limits before terminating (if def.terminate = 1) 

% experimental parameter (independent variable)
def.exppar1 = [8 16];				% vector containing experimental parameters for which the exp is performed
def.exppar1unit = 'Hz';				% unit of experimental parameter
def.exppar1description = 'Modulation frequency';% description of the experimental parameter

% experimental parameter 2...N (independent variable)
% add here if required

% interface, feedback and messages 
def.mouse = 1;					% enables mouse/touch screen control (1), or disables (0) 
def.markinterval = 1;				% toggles visual interval marking on (1), off(0)
def.feedback = 1;				% visual feedback after response: 0 = no feedback, 1 = correct/false/measurement phase
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


% Same as the example experiment but with the first interval beeing reference only 
% (three-interval, two-alternative forced choice). The target can only appear in intervals 2 and 3

def.ranpos = [2 3];					% The target can only appear in intervals 2 and 3
def.acceptButton = [2 3];		% Limit the valid response to intervals 2 and 3. 
def.skipStartMessage = 1;		% Requires only a single button press to start next experimental run

% Modified button strings and modified messages are in example3I2AFC_msg.m
def.messages = 'autoSelect';	% message configuration file
def.winButtonConfiguration = 1;

% eof
