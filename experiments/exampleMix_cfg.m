% example_cfg - example measurement configuration file -
%
% This matlab skript is called by afc_main when starting
% the experiment 'example'.
% example_cfg constructs a structure 'def' containing the complete
% configuration for the experiment.
% To design an own experiment, e.g., 'myexperiment'
% make changes in this file and save it as 'myexperiment_cfg.m'.
% Ensure that none of the entries is missing.
%
% See also help example_set, example_user, afc_main
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
def.mouse = 0;					% enables mouse/touch screen control (1), or disables (0) 
def.markinterval = 1;				% toggles visual interval marking on (1), off(0)
def.feedback = 1;				% visual feedback after response: 0 = no feedback, 1 = correct/false/measurement phase
def.messages = 'default';			% message configuration file, if 'autoSelect' AFC automatically selects depending on expname and language setting, fallback is 'default'. If 'default' or any arbitrary string, the respectively named _msg file is used.
def.language = 'EN';				% EN = english, DE = german, FR = french, DA = danish

% save paths and save function
def.result_path = '';				% where to save results
def.control_path = '';				% where to save control files
def.savefcn = 'default';			% function which writes results to disk

% samplerate and sound output
def.samplerate = 48000;				% sampling rate in Hz
def.intervallen = 24000;			% length of each signal-presentation interval in samples (might be overloaded in 'expname_set')
def.pauselen = 24000;				% length of pauses between signal-presentation intervals in samples (might be overloaded in 'expname_set')
def.presiglen = 100;				% length of signal leading the first presentation interval in samples (might be overloaded in 'expname_set')
def.postsiglen = 100;				% length of signal following the last presentation interval in samples (might be overloaded in 'expname_set')
def.bits = 16;					% output bit depth: 8 or 16 see def.externSoundCommand for 32 bits

% computing
def.allowpredict = 0;				% if 1 generate new stimui during sound output if def.markinterval disabled


% requires soundMexPro or soundMexPro4AFC
def.externSoundCommand = 'soundmexprofree';

def.bgloopwav = [fileparts(which('afc.m')) '\addons\sounds\pnoise_48k.wav'];
def.continuous = 2;                % multiplicative mixing
def.bgloopwavFullScaleLevel = 100; % for volume setting if using soundmexPro, work.currentCalLevel has to be defined either explicitely _set, or
																	% by using def.calScript

def.soundmexMark = 1;
def.allowpredict = 1;
def.bits = 32;
def.checkOutputClip = 0;

%eof