
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

% last modified 29-06-2006 15:37:51

function afc_remoteclone( statelogpath )

% 22-07-2004 10:30 allow globals to be not cleared
global def
default_cfg;
clearGlobals = def.clearGlobals;
%clear def;
if size( clearGlobals, 2 ) == 1
   	clearGlobals = repmat(clearGlobals, 1, 6);
elseif size( clearGlobals, 2 ) ~= 6
   	error('afc_main: def.clearGlobals must be either 1 or 6 elements vector');
end

if ( clearGlobals(1) == 1 )
	clear global def
end

if ( clearGlobals(2) == 1 )
	clear global work
end

if ( clearGlobals(3) == 1 )
%	clear global set
end

if ( clearGlobals(4) == 1 )
	clear global msg
end

if ( clearGlobals(5) == 1 )
	clear global simdef
end

if ( clearGlobals(6) == 1 )
	clear global simwork
end


global def
global work
global msg
%global set
%
global simdef
%global simwork


default_cfg;					% constructs structure def containing all fixed variables (default values)
%eval([expname '_cfg']);				% overloades user defined values in structure def

%if (exist([vpname '_cfg']) == 2)
%	eval([vpname '_cfg']);			% adds some vp parameters to structure def
%end
%
%if (exist([expname '_sim_cfg']) == 2)
%	eval([expname '_sim_cfg']);			% adds some simulation parameters to structure def
%end
%
%modelInit = 0;
%
%if (exist([expname '_' vpname '_cfg']) == 2)
%	eval([expname '_' vpname '_cfg']);	% constructs structure simdef containing all fixed model variables
%end

% if old-style _cfg completely overloaded def, add missing entries again

default_cfg;
default_EN_msg;

def.stateLogPath = statelogpath;
%def.remoteCloneEnable = 1;
def.stateLog = 0;
%def.stateLogPath = '';
def.markpressed = 1;
def.afcwinEnable = 1;
def.soundEnable = 0;
def.modelDisplayEnable = 0;
def.modelShowEnable = 0;
def.windetail = 1;
def.remoteObserver = 1;

def.showEnable = 1;
def.showrun = 1;

% figure out version 14.11.2005 14:31
mstr = version;
work.matlabVersion = str2num(mstr(1));

if ~isempty(def.stateLogPath )
	if max( findstr( def.stateLogPath, '\' )) ~= length( def.stateLogPath )
   		def.stateLogPath = [def.stateLogPath '\'];
   	end
end

%% version string
if ~isfield(def,'version')
   def.version = 'beta 1.01 build 2';
end

abortall = 0;
win_initialized = 0;
wasFinished = 0;
currentSnap = 0;
started = 0;

while (abortall == 0 )

	work.remoteupdateprevious = 0;
	work.remoteupdate = 0;
	work.remoteshutdown = 0;
	work.terminate = 0;
	work.predict = 0;
	
	while ( work.remoteshutdown == 0 ) 
		
		afc_statelog('read');
		
		if ( work.remoteshutdown == 1 )
			break;
		end
		
		
		
		if ( ~win_initialized )
			if ( def.afcwinEnable > 0 )
				feval(def.afcwin, 'open');							% opens modal window
				h=findobj('Tag','afc_win');							% handle to window
			
				set(h,'Name',['AFC-remoteMonitor (' def.version ')']);
				set(h,'Windowstyle','normal');
			end
			
			if ( def.showEnable > 0 )
				afc_show('open');
			end
			if ( def.afcwinEnable > 0 )
				%h=findobj('Tag','afc_win');
				if ( ~isempty(h) ) 
					feval(def.afcwin, 'start_ready');
					feval(def.afcwin, 'start');
					feval(def.afcwin, 'response_ready');
					set(h,'UserData',1);
					
				end
				
			end
			win_initialized = 1;
		end
		
		if (wasFinished == 1 & work.terminate == 0 & work.remoteupdate ~= currentSnap )
			wasFinished = 0;
			started = 1;
			if ( def.afcwinEnable > 0 )
				if ( ~isempty(h) ) 
					% we started a new one
					feval(def.afcwin, 'start_ready');
					
				end	
			end
			currentSnap = work.remoteupdate;
		elseif ( work.remoteupdate ~= currentSnap )
			response = work.answer{work.pvind}(work.stepnum{work.pvind}(end));	
						
			set(h,'UserData',1);
			% send response to window if enabled or directly call _control
			% don't need that since markpressed is done in _control
			if ( def.afcwinEnable > 0 )
				if (started == 1)
					if ( ~isempty(h) ) 
						% we started a new one
						feval(def.afcwin, 'start');
					end
					started = 0;	
				end
					
				afc_pressfcn(def.intervalnum, response)
			else
				afc_control(response);
			end
			
			if ( def.showEnable > 0 )
				afc_show('update');
			end
		end
		
		% delay next try for estimated presentation time
		tmp_delay = max(work.blockButtonTime, 0.5);
		
		pause( tmp_delay );
		
		if ( work.remoteupdate ~= currentSnap )
			if ( def.afcwinEnable > 0 )
				%h=findobj('Tag','afc_win');
				if ( ~isempty(h) ) 
					% if we are finished
					%if (work.terminate == 1 & wasFinished == 0 )
					%	feval(def.afcwin, 'start_ready');
					%else
					if ( work.terminate < 1 )
						feval(def.afcwin, 'response_ready');
					end
				end	
			end
		end
		
		if (work.terminate == 1)
			wasFinished = 1;
		end
		
		currentSnap = work.remoteupdate;
	end
	
	abortall = work.abortall;

end

% window or workspace messages
if ( def.afcwinEnable > 0 )
	if ( abortall == 1 )
   		feval(def.afcwin, 'close');
	else
   		feval(def.afcwin, 'finished');
	end
end

if ( def.showEnable > 0 )
	if ( abortall == 1 )
   		afc_show('close');
	end
end

% eof




