% default_cfg - default and newly added fields measurement configuration file -
%
% This matlab skript is called by afc_main when starting
% the afc procedure.
%
% New fields missing in def are initialized
%	
% WARNING: THE FOLLOWING FIELDS ARE ONLY FOR DEVELOPERS USE:
%
% allowclient

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

% last modified 21-07-2014 12:45:02
% Copyright (c) 1999 - 2004 Stephan Ewert. All rights reserved.
% $Revision: 1.00.1 beta$  $Date: 2004/01/11 10:01:37 $

if ~exist('def','var')					% create empty structure 'def' if it doesn't exist already
	def = struct([]);
end
	
% now create default entries for all fields if they don't exist

% SE 11.02.2013 16:44 moved to afc_main using the expname passed by afc_main as default
%if ~isfield(def,'expname')
%   	def.expname = 'example';				% name of experiment
%end

if ~isfield(def,'intervalnum')
	def.intervalnum = 3;					% number of intervals
end

if ~isfield(def,'ranpos')
	def.ranpos = 0;						% interval which contains the test signal: 0 = random interval, 1 = first interval ...,
end								% [x y ...] any mask of intervals to contain test signal (x,y <= def.intervalnum)
								% e.g., [2 3], test signal cannot be in the first interval.
if ~isfield(def,'rule')
	def.rule = [1 2];					% [up down]-rule: [1 2] = 1-up 2-down
end

if ~isfield(def,'startvar')
	def.startvar = -6;					% starting value of the tracking variable
end

if ~isfield(def,'expvarunit')
	def.expvarunit = 'dB';					% unit of the tracking variable
end
	
if ~isfield(def,'varstep')
	def.varstep = [4 2 1];					% [starting stepsize ... minimum stepsize] of the tracking variable
end

if ~isfield(def,'minvar')
	def.minvar = -100;					% minimum value of the tracking variable
end

if ~isfield(def,'maxvar')
	def.maxvar = 0;						% maximum value of the tracking variable
end

if ~isfield(def,'steprule')
	def.steprule = -1;					% stepsize is changed after each upper (-1) or lower (1) reversal
end

if ~isfield(def,'reversalnum')
	def.reversalnum = 6;					% number of reversals in measurement phase
end

if ~isfield(def,'exppar1')					% vector containing experimental parameters for which the exp is performed
	if isfield(def,'exppar')
   		def.exppar1 = def.exppar;			% just to provide downward compatibility
   		rmfield(def,'exppar');
   	else
   		def.exppar1 = [0];
   	end
end

if ~isfield(def,'exppar1unit')					% units of experimental parameter
	if isfield(def,'expparunit')
   		def.exppar1unit = def.expparunit;		% just to provide downward compatibility
   		rmfield(def,'expparunit');
   	else
   		def.exppar1unit = 'n/a';
   	end
end

if ~isfield(def,'repeatnum')
	def.repeatnum = 1;					% number of repeatitions of the experiment
end

if ~isfield(def,'parrand')
	def.parrand = 0;					% toggles random presentation of the elements in "exppar" on (1), off(0)
end

if ~isfield(def,'mouse')
	def.mouse = 0;						% enables mouse control (1), or disables mouse control (0)  
end

if ~isfield(def,'markinterval')
	def.markinterval = 1;					% toggles visuell interval marking on (1), off(0)
end

if ~isfield(def,'feedback')
	def.feedback = 1;					% visuell feedback after response: 0 = no feedback, 1 = correct/false/measurement phase
end

if ~isfield(def,'samplerate')
	def.samplerate = 44100;					% sampling rate in Hz
end

if ~isfield(def,'intervallen')
	def.intervallen = 22050;				% length of each signal-presentation interval in samples (might be overloaded in 'expname_set')
end

if ~isfield(def,'pauselen')
	def.pauselen = 22050;					% length of pauses between signal-presentation intervals in samples (might be overloaded in 'expname_set')
end

if ~isfield(def,'presiglen')
	def.presiglen = 100;					% length of signal leading the first presentation interval in samples (might be overloaded in 'expname_set')
end

if ~isfield(def,'postsiglen')
	def.postsiglen = 100;					% length of signal following the last presentation interval in samples (might be overloaded in 'expname_set')
end

if ~isfield(def,'result_path')
	def.result_path = '';					% where to save results
end

if ~isfield(def,'control_path')
	def.control_path = '';					% where to save control files
end

if ~isfield(def,'messages')
	def.messages = 'default';				% message configuration file, if 'autoSelect' AFC automatically selects depending on expname and language setting, fallback is 'default'. If 'default' or any arbitrary string, the respectively named _msg file is used.
end

if ~isfield(def,'savefcn')
	def.savefcn = 'default';				% function which writes results to disk
end

if ~isfield(def,'debug')
	def.debug = 0;						% set 1 for debugging (displays all changible variables during measurement)
end

if ~isfield(def,'interleaved')
   def.interleaved = 0;					% toggles block interleaving on (1), off (0)
end

if ~isfield(def,'interleavenum')
   def.interleavenum = 3;				% number of interleaved runs
end   

if ~isfield(def,'dither') 		
   def.dither = 0;					% 1 = enable +- 'ditherdepth' LSB uniformly distributed dither, 0 = disable dither
end   

if ~isfield(def,'ditherdepth') 		
   def.ditherdepth = 0.5;				% defaults to +- 0.5 LSB uniformly distributed dither
end   

if ~isfield(def,'bits')
   def.bits = 16;							% output bit depth: 8 or 16 (might be used to enable 24/32-bit in future matlab versions)
end   

if ~isfield(def,'backgroundsig')
	def.backgroundsig = 0;				% allows a backgroundsignal during output: 0 = no bgs, 1 = bgs is added to the other signals, 2 = bgs and the other signals are multiplied
end   

% 12-03-2004 18:30 replaced by def.calFirEqualizeFile
%if ~isfield(def,'headphoneeq') 
%   def.headphoneeq = 0;					% toggles headphone equalization via FIR-filter on/off (1/0)
%end

%if ~isfield(def,'eqfile')
%   def.eqfile = 'fake';					% mat-file containing headphone EQ FIR coefficients as vector eq
%end

if ~isfield(def,'terminate')
   def.terminate = 0;					% terminate execution on min/maxvar hit: 0 = warning, 1 = terminate
end

if ~isfield(def,'endstop')
   def.endstop = 6;						% Allows 6 nominal levels higher/lower than the limits before terminating (if def.terminate = 1) 
end

if ~isfield(def,'allowclient')
   def.allowclient = 0;					% clients for signal pregeneration: 0 = no clients, 1 = one client, 2 = two clients !!not used
end

if ~isfield(def,'allowpredict')
   def.allowpredict = 0;				% for signal pregeneration: 0 = no pregen, 1 = pregen
end

if ~isfield(def,'minsounddelay')
   def.minsounddelay = 0.5;			% forces delay in seconds between button press and sound output (default = 0.5)
end

if ~isfield(def,'windetail')
   def.windetail = 0;					% displays additional information in the response window
end

if ~isfield(def,'pre')
   def.pre = 0;							% if 1 the '_pre' script is called prior to the '_user' script. The '_pre' skript is only called once if
   											% signal pregeneration is enabled while the '_user' script is called two times (for correct and
   											% false response). It might be very efficient to generate the reference signals only once in the '_pre' script.
end

if ~isfield(def,'markpressed')
   def.markpressed = 0;					% marks pressed button 
end

if ~isfield(def,'markcorrect')
   def.markcorrect = 0;					% marks correct button 
end

if ~isfield(def,'loadafcext')
   def.loadafcext = 0;					% do not load any afc-extension pak
end

if ~isfield(def,'afcextname')
   def.afcextname = 'pics';			% name of extension pak to be loaded if def.loadafcext == 1, default 'afc' causes afc_ext.m to be executed 
end

if ~isfield(def,'afcwin')
   def.afcwin = 'afc_win';				% default afc-window function
end

if ~isfield(def,'maxiter')
   def.maxiter = 100;					% maximum number of iterations
end

if ~isfield(def,'holdtrack')
   def.holdtrack = 0;					% if 1 all tracks are continued until the last is finished
end

%%%% sound output dependent things

% new 1.00.1
if isfield(def,'externSoundCommand')
	if isfield(def,'sndmex')
		def=rmfield(def,'sndmex');
	end
end

if ~isfield(def,'externSoundCommand')
   if isfield(def,'sndmex')
   	%warning('AFC:oldsndmex', 'def.sndmex should be replaced by def.externSoundCommand');
   	warning('def.sndmex should be replaced by def.externSoundCommand');
   	if def.sndmex == 1;
   		def.externSoundCommand = 'sndmex';
   	else
   		def.externSoundCommand = '';
   	end
   else
   	def.externSoundCommand = '';				% '' use Matlab 'sound'
   end
end								% 'snd_pc' use Torsten Marquarts GPL 'snd_pc' for up to 32 bit sound and more than 2 devices
								% 'soundmex' use Oldenburg Hoerzentrum 'SoundMex' for up to 32 bit sound and more than 2 devices and sample exact button marking, mixing etc. 
								
								% For downward compatibility
								% 'sndmex' use old Oldenburg Hoerzentrum 'sndmex' for up to 32 bit sound and more than 2 devices and sample exact button marking with old 'light' version  
%%%%% soundmex related
%if ~isfield(def,'sndmex')
%   def.sndmex = 0;						% use sndmex dll's; WARNING should not be used anymore
%end

if ~isfield(def,'sndmexmark')
   def.sndmexmark = 0;						% use sndmex interval marking; WARNING should not be used anymore
end

if ~isfield(def,'soundmexMark')
   def.soundmexMark = 0;					% use SoundMex interval marking
end
%%%%%%%%

%%%%%%%%%%% new 07.06.2011 09:58
if ~isfield(def,'internSoundCommand')			% 'sound' (was the standard for 1013 and earlier)
	def.internSoundCommand = 'audioplayer';     % but is not asynchronous anymore since MATLAB 2011.  
                                                % 'audioplayer' is not
                                                % well suited for button
                                                % marking and needs
                                                % def.markIntervalDelay as
                                                % tweak. 'wavplay' is not
                                                % supported in r2014
                                                % anymore and not on Mac
                                                % and Linux. Well, thanks
                                                % Mathworks for screwing up
                                                % 'sound'
end

if ~isfield(def,'markIntervalDelay')			% 'sound' (was the standard for 1013 and earlier) or 'audioplayer'
	if ( strcmp(def.internSoundCommand, 'audioplayer') & isempty(def.externSoundCommand) & matlabVersionRelease > 7.1 )
        def.markIntervalDelay = 0.5;            % audioplayer not suited for button marking
    else
        def.markIntervalDelay = 0;
    end
end

if ~isfield(def,'deviceID')
	if ( strcmp(def.internSoundCommand, 'audioplayer') & isempty(def.externSoundCommand) )
		def.deviceID = -1;					% standard device is -1 for audioplayer
	else
   	def.deviceID = 0;					% standard device is zero, sndmex required
	end
end

% SE 27.02.2013 14:38 fix default device ID if audioplayer is not used
if ( def.deviceID == -1 & ~isempty(def.externSoundCommand) )
	def.deviceID = 0;					% standard device is zero, sndmex required
end


if ~isfield(def,'continuous')
   def.continuous = 0;					% 0 = gated, 1 = add to background, 2 = multiply with bg, sndmex required
end

if ~isfield(def,'bgloopwav')
   def.bgloopwav = 'fake';			% wav file to loop if def.continuous > 0, sndmex required
end

if ~isfield(def,'bgloopwav_forcerestart')
   def.bgloopwav_forcerestart = 0;		% forces restart of bgloopwav before each new run
end

%%%%%%%%%%%%%%%%%%%

if ~isfield(def,'expvarunit')
   def.expvarunit = 'n/a';				% if missing
end

if ~isfield(def,'extern_hardware')
   def.extern_hardware = 'extern_defaulthardware';	% no hardware
end

if ~isfield(def,'language')
   def.language = 'EN';				% EN = english, DE = german, FR = french, DA = danish
end

% new from model re-integration

% Only used in old pemopt and only modelspecific. Let's get rid of.
%if ~isfield(def,'display')
%	def.display = 0;					% display mode 0=nothing, 1=template/actual 2=all signals
%end

% The following two might be used in models
if ~isfield(def,'modelShowEnable')
   def.modelShowEnable = 0;			% model shows model related things like templates ...
end

if ~isfield(def,'modelDisplayEnable')
   def.modelDisplayEnable = 1;			% if 0, the model_display script is not called (e.g., to suppress response in the workspace window)
end
%%%%%%

if ~isfield(def,'soundEnable')
   def.soundEnable = 1;				% enables sound output and all related things
end

if ~isfield(def,'afcwinEnable')
   def.afcwinEnable = 1;			% enables afcwin and all related things
end

if ~isfield(def,'modelEnable')
   def.modelEnable = 0;				% enables model and all related things
end

if ~isfield(def,'showEnable')
   def.showEnable = 0;				% enables show and all related things
end

if ~isfield(def,'remoteAccessEnable')
   def.remoteAccessEnable = 0;			% calls the function afc_remoteaccess if existing (after each response and when run is terminated)
end

if ~isfield(def,'checkOutputClip')
   def.checkOutputClip = 2;			% 1 = warning, 2 = error if output is clipped (work.out exceeds [-1 ... 1] range in afc_sound) 
end

% new from psy re-integration

if ~isfield(def,'measurementProcedure')
   def.measurementProcedure = 'transformedUpDown';	% transformedUpDown or constantStimuli
end

if ~isfield(def,'practice')
   def.practice = 0;				% practise for constantStimuli
end

if ~isfield(def,'expvar')
   def.expvar = -6;				% presentation levels of variable for constantStimuli
end

if ~isfield(def,'expvarnum')
   def.expvarnum = 0;				% number of presentations of variable, same index as in expvar 
end

if ~isfield(def,'expvarord')
   def.expvarord = 0;				% order of presentation: 0 = random, 1 = order as in expvar 
end

if ~isfield(def,'allterminate')
   def.allterminate = 0;			% terminate all tracks in an interleaved run if one is skipped
end

% NOT SUPPORTED SO FAR
% PEST - Parameter Estimation and Sequential testing 
if ~isfield(def,'PEST_TargetProbability')
   def.PEST_TargetProbability = 0.5;		% point of the psychometric function to converge at
   						% PEST as described in Taylor & Creelman (1967), JASA
end

if ~isfield(def,'PEST_WaldRange')
   def.PEST_WaldRange = 1;			% range for Wald sequential likelyhood test
end

if ~isfield(def,'PEST_RepeatLimit')
   def.PEST_RepeatLimit = 0;			% number of repeatitions at same level after which the stepsize is reduced
   						% should be 4 or 8 according to Findlay (1978), Percepion & Psychophysics
   						% If 0, the original PEST as described in Taylor & Creelman (1967), JASA is used
end

%%%%%%%%%%%%%%%%%%%%% for afc_show %%%%%%%%%%%%%%
if ~isfield(def,'showbothears')
	def.showbothears = 0;				% if set to 1 shows the signal for both ears (otherwise only one ear signal)
end
if ~isfield(def,'showtrial')
	def.showtrial = 0;				% shows trial signal after each presentation (0 == off, 1 == on)
end
if ~isfield(def,'showspec')
	def.showspec = 0;				% shows spectra from target and references after each trial (0 == off, 1 == on)
end
if ~isfield(def,'showstimuli')
	def.showstimuli = 0;
end
if ~isfield(def,'showspec_frange')
	def.showspec_frange = [0 def.samplerate/2];	% range of frequencies to show in Hz
end
if ~isfield(def,'showspec_dbrange')
	def.showspec_dbrange = [0 -60];			% dynamic range to show for spectra in dB re 1
end
if ~isfield(def,'showrun')
	def.showrun = 0;
end

%%%%%%%%%%%%%%%%%%%%%%%%% calibration %%%%%%%%%%%%%%%%%
if ~isfield(def,'calScript')
	def.calScript = '';				% if 'autoSelect' load 'xxx_calibration' file where xxx is the last string passed to afc_main, otherwise load default_calibration;
							% if 'xyz' load 'xyz_calibration' if existing, otherwise load the default  
end

% new 1.00.2 12-03-2004 18:23
if isfield(def,'calFirEqualizeFile')			% replaces old def.headphoneeq/def.eqfile. Loads .mat file with precomputed FIR filter. The file has to contain a column vector named 'eq'.
							% eq can be one column (both channels are filtered with the same eq) or two columns (left|right filter)
	if isfield(def,'headphoneeq')
		def=rmfield(def,'headphoneeq');
	end
	if isfield(def,'eqfile')
		def=rmfield(def,'eqfile');
	end
end

% just for downward compatibility
if ~isfield(def,'calFirEqualizeFile')
   if isfield(def,'headphoneeq')
   	%warning('AFC:oldheadphoneeq', 'def.headphoneeq/def.eqfile should be replaced by def.calFirEqualizeFile');
   	warning('def.headphoneeq/def.eqfile should be replaced by def.calFirEqualizeFile');
   	if def.headphoneeq == 1;
   		def.calFirEqualizeFile = def.eqfile;
   	else
   		def.calFirEqualizeFile = '';
   	end
   else
   	def.calFirEqualizeFile = '';
   end
end		

if ~isfield(def,'calTableEqualize')
	def.calTableEqualize = '';			% equalize based on calTable: '' = not, 'fir'. Generates an FIR filter when the experiment is started
							% You can apply two filters simultaneously, the def.calFirEqualizeFile filter and a runtime generated
							% filter based on the calTable entries
end

% parameters for runtime window FIR filter design from calTable
if ~isfield(def,'calFilterDesignLow')
	def.calFilterDesignLow	= 125;			% should be >= def.samplerate/def.calFilterDesignFirCoef
end

if ~isfield(def,'calFilterDesignUp')
	def.calFilterDesignUp = 8000;			% should be < def.samplerate/2 or depending on calTable entries
end

if ~isfield(def,'calFilterDesignFirCoef')
	def.calFilterDesignFirCoef = 128;		% number of FIR filter coefficients 64, 128, 256, 512 for runtime
end

if ~isfield(def,'calFilterDesignFirPhase')
	def.calFilterDesignFirPhase = 'minimum';	% 'minimum' for minimum Phase design, 'linear' for linear Phase design
							% 'linear' introduces def.calFilterDesignFirCoef/2 samples delay
end

if ~isfield(def,'calTableEqualizeRefFreq')
	def.calTableEqualizeRefFreq = 1000; 		% this freq remains unchanged in level if equalize
end

if ~isfield(def,'calTableLookupFreq')
	def.calTableLookupFreq = 1000; 			% lookup calTable @ specified frequency (could be override in, e.g., _set) and use this value as calibration value
							% Meaningless if def.calTableEqualize is enabled
end

if ~isfield(def,'calTable')				
	def.calTable = [1000 100 100];			% Table with calibration values in columns [freq channel1(left/mono) channel2(right) ...]
							% Calibration values are dB SPL rms for a digital dB FS (full scale) rms of 0,
							% or dB SPL peak for a digital dB FS (full scale) peak of 0, e.g., a sine with min/max = -1/1 when played
							% with sound.m
							% If just one channel is given, than it is assumed that all channels have the same calibration.
							% If just one freq is given, than it is assumed that all freqs have the same calibration.
							% Thus, def.calTable = 100 (only one scalar value) assumes 100 dB SPL rms for all channels at all freqs for a 0 dB FS rms digital signal
							% played with sound.m
							% When using calScript, the rms of digital signals in _set and _user must equal the desired output dB SPL rms.
							% A tone of 75 dB SPL rms should have in _user: 20*log10(rms(tone)) = 75.  
end

if ~isfield(def,'calTableExcessLevel')
	def.calTableExcessLevel = [0 0];		% This is the level is put on top of any selected calTable entry. It is also
							% put on top of the calTable for the reference freq when runtime
							% FIR filtering is used. Might be usefull if different hardware attenuations exist
							% that don't influence the frequency dependency in calTable.
							% It is possible to override this variable expname_set or expname_user 
end



%%%%%%%%% new 16-03-2004 10:00 %%%%%%%%%%%%%%
if ~isfield(def,'varstepApply')
	def.varstepApply = 1;				% 1 = additive (the way it was), 2 = multiplicative (multiply def.startvar with current stepsize on wrong response or divide by current stepsize on correct response, depending on steprule)
end

if ~isfield(def,'exppar1description')			% description of experimental parameter, e.g. used for auto labeling of generic plot tool
   	def.exppar1description = 'n/a';
end

if ~isfield(def,'expvardescription')
	def.expvardescription = 'n/a';				% description of the tracking variable
end

%%%%%%%%% new 16-08-2004 10:35 remoteClone/Observer related variables (experimental) %%%%%%%%%%%%

if ~isfield(def,'stateLog')
	def.stateLog = 0;				% enable state logging to disc during measurement
end                                                     % The file can be accessed from any other computer to monitor the experiment.
                                                        % The response window and the proceedure is displayed.
                                                        % Use afc_remotemonitor('path to state log file')

if ~isfield(def,'stateLogPath')
	def.stateLogPath = '';				% path where state log file 'stateLog.mat' is stored
end

%%%%%%%%% new 17-03-2005 13:30 AO request file naming

if ~isfield(def,'fileNamingScheme')
	def.fileNamingScheme = '';			% if '' the file name is constructed as always was.
							% This equals '%E_%S_%U_%C' = expname_subjectname_userpar1..._userparN_condition
							% '%E_%S_%U[3-]_%C would include only userpars >= 3 in the filename
							% %U[1-3] stands for userpar1-3, %U[2] for userpar2 only. 
end

%%%%%%%%% new 04-05-2005 16:55 finally randomize seed in main
if ~isfield(def,'randStateRandomize')
	def.randStateRandomize = 1;			% afc_main initializes rand state with rand('state',sum(100*clock)) each time it is started
																	% also initializes randn('state',sum(100*clock))
end

%%%%%% new 08.09.2005 14:37
if ~isfield(def,'acceptButton')
	def.acceptButton = [];				% Vector of intervals accepted as subject response. If empty 1:def.intervalnum is accepted.
end

if ~isfield(def,'skipStartMessage')
	def.skipStartMessage = 0;				% msg.start_msg screen is skipped during repeatitions of an experiment. Avoids that the subject has
																	% to press two buttons in order to continue the experiment
end

%%%%%% new 08.11.2006 09:34 (Lutz' munich requirements)
if ~isfield(def,'winFigurePosition')
	def.winFigurePosition = [];				% default is empty 
end

if ( isempty(def.winFigurePosition) | (length(def.winFigurePosition) ~= 4) )
	def.winFigurePosition = get(0,'defaultFigurePosition');				% if empty or ill specified use MATLABs defaultFigurePosition
end

if ~isfield(def,'winButtonConfiguration')
	def.winButtonConfiguration = 0;	% 0 is standard, 1 also shows 'start' and 'end' button
end

%%%%%%% new 07.03.2007 10:52 (Stephan Toebkens request) // Ascii Dec code 16.07.2010 14:02
if ~isfield(def, 'keyboardResponseButtonMapping')
	def.keyboardResponseButtonMapping = [];				% default is empty. List of button characters that are mapped to the intervals 1 ... N, 
end																							% e.g., {'a','d','g'} for a 3-AFC experiment. WARNING: the hardcoded 's' and 'e' (start/end) buttons
																								% must not be used here.
																								% Alternatively, a vector of ASCII codes (decimal) can be used, e.g., [ 28 30 29 ] for Arrow_left, Arrow_up, Arrow_right.
																								% A mixed usage of strings and ASCII codes is not possible.

%%%%%%% new 31.05.2007 16:37
if ~isfield(def,'session_path')
	def.session_path = '.\sessions';					% where to save session files
end

%%%%%%% new 22.04.2009 11:41
if ~isfield(def,'outputChannels')
	def.outputChannels = 2;					% number of signal output channels
end

% SE 11.03.13 decide for naming
%%%%%%% new 22.04.2009 11:41
if ~isfield(def,'outputChannels')
	if ~isfield(def,'outputChannelMap') % SE 24.04.2012 14:57
		def.outputChannels = 2;					% number of signal output channels
	else
		def.outputChannels = length(def.outputChannelMap);					% number of signal output channels
	end
end

%%%%%%%%%% SE 24.04.2012 14:30
if ~isfield(def,'trackMap')
	def.trackMap = repmat([0:def.outputChannels-1],1,2);					% how to mix internal soundmexpro tracks, 
end																															% default: first block of def.outputChannels is mixed with second block

%%%%%%%%%% SE 25.02.2013 20:21:55
if ~isfield(def,'bgloopwavFullScaleLevel')
	def.bgloopwavFullScaleLevel = [];
end

%%%%%%%%%% SE 25.02.2013 20:21:55
if ~isfield(def,'bgloopwavStartoffset')			% start offset of background loop channels, -1 means random, only used by soundmexPro so far
	def.bgloopwavStartoffset = -1;
end

%%%%%%% new 29.07.2009 14:12
if ~isfield(def,'stepruleIgnoreReversals')
	def.stepruleIgnoreReversals = 0;					% number of initial reversals during which the stepsize reduction check
end																					% is ignored. If, for example, set to 1, the stepsize cannot be reduced 
																						% on the first reversal when the subject initially responded wrong and 
																						% the very first reversal meets def.steprule = -1 (upper reversal) already

%%%%%%%%% new 21.07.2010 13:02
if ~isfield(def,'soundmexproBufferNum')			% Number of ASIO buffers used by soundmexPro. Smaller settings reduce the output delay. 
	def.soundmexproBufferNum = 10;
end

%%%%%%%%% new 21.07.2010 13:02
if ~isfield(def,'variableCheck')					% If set to 1, all entries of structure def are tested for integrity
	def.variableCheck = 1;
end

%%%%%%%%%% SE 09.01.2012 17:46
if ~isfield(def,'skippedMeasurementProcedure')
   def.skippedMeasurementProcedure = '';	% if set to 'constantStimuli' a skipped transformedUpDown measurement will be continued as constantstimuli
end

if ~isfield(def,'skippedMeasurementProcedureSavefcn')
   def.skippedMeasurementProcedureSavefcn = 'cs_psyfcn';	% save function for alternative measurement procedure
end

%%%%%%%%%% SE 24.04.2012 14:30
if ~isfield(def,'outputChannelMap')
	def.outputChannelMap = [0:def.outputChannels-1];					% number of signal output channels
end

%%%%%%%%%% SE 23.04.2013 15:27
if ~isfield(def,'controlFileGenerateOrder')
	def.controlFileGenerateOrder = 'afc';					% function to generate array of exppars to initialize control file
end

%%%%%%%%%% SE 25.04.2013 08:40
if ~isfield(def,'def.skipDefaultSoundOutput')
	def.skipDefaultSoundOutput = 0;					% if 1 skip AFC inbuild sound output, soundcard and command are still initialized
																					% used to enable custom sound output in a custom procedure
end



%%%%%%%%% new 22-07-2004 10:43 %%%%%%%%%%%%%%%%%%%%%%%%
%%%%% DEFAULT_CFG ONLY CONFIGURATION VARIABLES %%%%%%%%

def.clearGlobals = 1;					% 1 = clear all globals on startup, alternatively use bitmask for globals [def work set msg simdef simwork]
							% e.g., [1 1 0 0 0 0] clears def and work, others remain untouched
							% WARNING: this configuration variable is only valid in default_cfg
							% YOU MIGHT EXPERIENCE UNEXSPECTED OR UNWANTED BEHAVIOUR IF YOU DO NOT
							% CLEAR GLOBALS. THE CONFIGURATION VARIABLES FROM PREVIOUS SESSIONS MIGHT STILL
							% STAY IN MEMORY.
							

def.remoteObserver = 0;					% set to 1 in afc_remoteObserver DO NOT CHANGE

% SE moved from afc_misc 10.04.2013 12:02
% FIXME autoconstruct this list after first load of default cfg, however needs some tweaking anyhow
        % varname, type ( 0 = not numeric, 1 = numeric, 2 = both possible)
def.configurationVariableList = {'expname', 0; ...
            'intervalnum', 1; ...
            'ranpos', 1; ...
            'expvarunit', 0; ...
            'minvar', 1; ...
            'maxvar', 1; ...
            'reversalnum', 1; ...
            'exppar1',2; ...
            'exppar1unit',0; ...
            'exppar1description',0; ...
            'exppar2',2; ...
            'exppar2unit',0; ...
            'exppar2description',0; ...
            'exppar3',2; ...
            'exppar3unit',0; ...
            'exppar3description',0; ...
            'exppar4',2; ...
            'exppar4unit',0; ...
            'exppar4description',0; ...
            'exppar5',2; ...
            'exppar5unit',0; ...
            'exppar5description',0; ...
            'exppar6',2; ...
            'exppar6unit',0; ...
            'exppar6description',0; ...
            'exppar7',2; ...
            'exppar7unit',0; ...
            'exppar7description',0; ...
            'exppar8',2; ...
            'exppar8unit',0; ...
            'exppar8description',0; ...
            'exppar9',2; ...
            'exppar9unit',0; ...
            'exppar9description',0; ...
            'exppar10',2; ...
            'exppar10unit',0; ...
            'exppar10description',0; ...
            'exppar11',2; ...
            'exppar11unit',0; ...
            'exppar11description',0; ...
            'exppar12',2; ...
            'exppar12unit',0; ...
            'exppar12description',0; ...
            'repeatnum',1; ...
            'parrand',1; ...
            'mouse',1; ...
            'markinterval',1; ...
            'feedback',1; ...
            'samplerate',1; ...
            'intervallen',1; ...
            'pauselen',1; ...
            'presiglen',1; ...
            'postsiglen',1; ...
            'result_path',0; ...
            'control_path',0; ...
            'messages',0; ...
            'savefcn',0; ...
            'interleaved',1; ...
            'interleavenum',1; ...
            'debug',1; ...
            'dither',1; ...
            'bits',1; ...
            'backgroundsig',1; ...
            'headphoneeq',1; ...
            'eqfile',0; ...
            'terminate',1; ...
            'allowclient',1; ...
            'allowpredict',1; ...
            'showtrial',1; ...
            'showspec',1; ...
            'endstop',1; ...
            'windetail',1; ...
            'loadafcext',1; ...
            'afcextname',0; ...
            'ditherdepth',1; ...
            'minsounddelay',1; ...
            'pre',1; ...
            'markpressed',1; ...
            'markcorrect',1; ...
            'afcwin',0; ...
            'maxiter',1; ...
            'holdtrack',1; ...
            'externSoundCommand',0; ...
            'sndmexmark',1; ...
            'soundmexMark',1; ...
            'deviceID',1; ...
            'continuous',1; ...
            'bgloopwav',0; ...
            'bgloopwav_forcerestart',1; ...
            'extern_hardware',0; ...
            'language',0; ...
            'modelShowEnable',1; ...
            'modelDisplayEnable',1; ...
            'soundEnable',1; ...
            'afcwinEnable',1; ...
            'modelEnable',1; ...
            'showEnable',1; ...
            'remoteAccessEnable',1; ...
            'checkOutputClip',1; ...
            'measurementProcedure',0; ...
            'practice',1; ...
            'allterminate',1; ...
            'PEST_TargetProbability',1; ...
            'PEST_WaldRange',1; ...
            'PEST_RepeatLimit',1; ...
            'showbothears',1; ...
            'showstimuli',1; ...
            'showspec_frange',1; ...
            'showspec_dbrange',1; ...
            'showrun',1; ...
            'version',0; ...
            'expparnum',1; ...
            'exppartype',1; ...
            'startvar',1; ...
            'rule',1; ...
            'steprule',1; ...
            'varstep',1; ...
            'expvarnum',1; ...
            'practicenum',1; ...
            'expvarord',1; ...
            'expvar',1; ...
            'bgsiglen',1; ...
            'calScript',0; ...
            'calFirEqualizeFile',0; ...
            'calTableEqualize',0; ...
            'calFilterDesignLow',1; ...
            'calFilterDesignUp',1; ...
            'calFilterDesignFirCoef',1; ...
            'calFilterDesignFirPhase',0; ...
            'calTableEqualizeRefFreq',1; ...
            'calTableLookupFreq',1; ...
            'calTable',1; ...
            'calTableExcessLevel',1; ...
            'varstepApply',1; ...
            'expvardescription',0; ...
            'stateLog',1; ...
            'stateLogPath',0; ...
            'fileNamingScheme',0; ...
            'randStateRandomize',1; ...
            'acceptButton',1; ...
            'skipStartMessage',1; ...
            'winFigurePosition',1; ...
            'winButtonConfiguration',1; ...
            'keyboardResponseButtonMapping',2; ...
            'session_path',0; ...
            'outputChannels',1; ...
            'stepruleIgnoreReversals',1; ...
            'soundmexproBufferNum',1; ...
            'clearGlobals',1; ...
            'remoteObserver',1; ...
            'variableCheck',1; ...
            'internSoundCommand',0; ...
            'skippedMeasurementProcedure',0; ...
            'skippedMeasurementProcedureSavefcn',0; ...
            'outputChannelMap',1; ...
            'trackMap',1; ...
            'bgloopwavFullScaleLevel',1; ...
            'markIntervalDelay',1; ...
            'configurationVariableList',2;...
            'controlFileGenerateOrder',0; ...
            'skipDefaultSoundOutput',1; ...
            'bgloopwavStartoffset',1; ...
            'versionDate',0;...
            };


% eof

% FIXME
% alternativeChoiceNum		should be added for e.g. 1-interval 2-AFC, now you have to design your own window for this
% work.signal should become cell array of matrices for the different intervals, to (i) let signals in different intervals
% have different duration, and (ii) remove current the 2 channel limitation.
% introduce the interval mask for potential signal positions to afc_ranposs, e.g. signal can be in interval 1 and 2 only.
% calculate output signal duration from work.out.

% introduce feedback mask
% def.feedback = [correct_false   max_min_warning   measurement_phase];
% if def.feedback is scalar it assumes that all is the some 0/1 as before

% clear feedback when next presentation starts
% at the moment def.minsounddelay is 0.5 so it stays a minimum of 0.5 seconds, to short