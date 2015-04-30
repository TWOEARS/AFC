% calibration script
% if def.calSript in expname_cfg is not an empty string,
% afc looks for calibration in order
%
% def.calScript_calibration		% specified in expname_cfg and not 'autoSelect'
% work.condition_calibration		% use last parameter from afc_main() call if specified 'autoSelect' expname_cfg
% default_calibration			% otherwise use dummy default calibration which should be replaced with a 
													% setup dependent meaningful file
													%
%------------------------------------------------------------------------------
% AFC for Mathwork’s MATLAB
%
% Version 1.40.0
%
% Author(s): Stephan Ewert
%
% Copyright (c) 1999-2014, Stephan Ewert. 
% All rights reserved.
%
% This work is licensed under the 
% Creative Commons Attribution-NonCommercial-NoDerivs 4.0 International License (CC BY-NC-ND 4.0). 
% To view a copy of this license, visit
% http://creativecommons.org/licenses/by-nc-nd/4.0/ or send a letter to Creative
% Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.
%------------------------------------------------------------------------------

% last modified 13-11-2012 18:32:18


% dummy default calibration
def.calTable = [1000 100 100];
def.calTableLookupFreq = 1000; 			% lookup table @ specified frequency (override in _set)
def.calTableExcessLevel = [0 0];

% runtime FIR filter related things
def.calTableEqualize = '';			% equalize based on calTable: '' = not, 'fir'
def.calTableEqualizeRefFreq = 1000; 			% this freq remains unchanged in level if equalize

% parameters for runtime window FIR filter design from calTable
def.calFilterDesignLow	= 125;			% should be >= def.samplerate/def.calFilterDesignFirCoef
def.calFilterDesignUp = 8000;
def.calFilterDesignFirCoef = 128;		% 64, 128, 256, 512
def.calFilterDesignFirPhase = 'minimum';	% or 'minimum' for minimum Phase design

def.calDescription = 'This is just a dummy calibration.';

% eof