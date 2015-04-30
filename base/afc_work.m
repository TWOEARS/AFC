
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

% last modified 26-03-2014 12:46:05
% revision 0.92 beta, modified 06/07/00
% added interleaving

function afc_work

%disp('DEBUG work: entering');

global def
global work
%global msg
%
%global simdef
%global simwork

% MATLAB 7 05-04-2005 09:34
% introduced this checks to work around the MATLAB 7 while()-loop bug where the afc_work loop is executed one additional time when work.terminate is 1 already.
% It all worked fine untill 6.5.
% This leads to inproper termination behaviour and double result writing to disk. Obviously the updating of the global work structure is flawed in MATLAB 7, probably in combination
% with the waitfor() and the callbacks in between. Report this? 
if ( work.terminate ~= 0 )
	% 24-01-2006 14:01 just make sure the event que is being flushed
	drawnow;
	return;
end

if ( work.abortall ~= 0 )
	% 24-01-2006 14:01 just make sure the event que is being flushed
	drawnow;
	return;
end
% end MATLAB 7 fix

%work.lastpvindpro = [work.lastpvindpro work.lastpvind];
%work.pvindpro = [work.pvindpro work.pvind];

if ( def.afcwinEnable > 0 )
	h=findobj('Tag','afc_win');
	if ( ~isempty(h) )
		set(h,'UserData',0);
	else
	% The window is supposed to be there, but was closed in the meantime.
	% This shouldn't be the case, thus exit the main loop
	% afc_close is supposed to do these settings but somehow it doesn't work
		work.terminate = 1;
		work.abortall = 1;
		return;
	end
end											% not ready to get answer

if ( def.soundEnable > 0 & ~def.skipDefaultSoundOutput )
	%if ( ((def.markinterval == 0) | strcmp(def.externSoundCommand, 'sndmex') | strcmp(def.externSoundCommand, 'soundmex') | strcmp(def.externSoundCommand, 'soundmexfree')  | strcmp(def.externSoundCommand, 'soundmex2') | strcmp(def.externSoundCommand, 'soundmex2free') | strcmp(def.externSoundCommand, 'soundmexpro') ) & ((def.allowpredict == 1) & (def.modelEnable == 0)))
	% SE 12.02.2013 11:54
	if ( ( (def.markinterval == 0) | afc_sound('isSoundmex') ) & ((def.allowpredict == 1) & (def.modelEnable == 0)) )
	   % Retreave pre-generated signal and generate new one during sound output
	   tic;
	   afc_getpregen												% gets pregenerated signals
	   elt = toc;
	   while elt < def.minsounddelay				% force delay for output after response
	      elt = toc;
	   end
	   %afc_sound(def,work);
		afc_sound('play');										% outputs sound
		afc_pregen;														% pregenerates signals during output, must be a blocking function
	
	else
		 % Generate signal and output the sound 
	   tic;
	   afc_interleave												% controls interleaving
	   
	   if def.pre == 1
				eval([def.expname '_pre;']);						% calls pre-function of the experiment
		 end
	   
	   eval([def.expname '_user;']);							% calls user-function of the experiment
	   afc_ranpos;													% defines interval containing the test signal
	   afc_process;												% dithering, filtering and so on
	   elt = toc;

	   while elt < def.minsounddelay							% force delay for output after response
	      elt = toc;
	   end
		%afc_sound(def,work);
		afc_sound('play');
		
		if ( def.afcwinEnable > 0 )									% outputs sound
	   		feval(def.afcwin, 'markint');						% must be a blocking function
	  end
		% FIXME isnt blocking if afcwin disabled	% must be a blocking function
	end
	
	afc_sound('blockWhilePlaying');
	
	%afc_sound('stopSndPc');
	% SE 17.03.2014 12:27 renamed
	afc_sound('stop');
	

else 					
	% Sound output disabled (def.soundEnable <= 0), generate signals for model most likely
	afc_interleave												% controls interleaving
  if def.pre == 1
		eval([def.expname '_pre;']);						% calls pre-function of the experiment
	end
   	eval([def.expname '_user;']);							% calls user-function of the experiment
   	afc_ranpos;													% defines interval containing the test signal
   	afc_process;
end

% 27/08/03 --- jlv added to show some time signals and spectra  
if ( def.showEnable > 0 )
	afc_show('update');
end

%disp('DEBUG work: sound done');

% if the window is there, wait for input
if ( def.afcwinEnable > 0 )
	h=findobj('Tag','afc_win');
	if ( ~isempty(h) ) 
		set(h,'UserData',1);									% ready to get answer
		feval(def.afcwin, 'response_ready');
		
		% SE 21.06.2007 17:01 clear button focus as soon as response ready is reached
		if (work.matlabVersion > 6 )
			
            % dont ask why, otherwise 1st button cant get cleared
            uicontrol(findobj('Tag','afc_focusdummy'));

            for ( clearb = 1:def.intervalnum )
                %SE 26.03.2014 11:35 only clear enabled buttons
                if ( ~(def.mouse == 0) & ( isempty(def.acceptButton) | ismember(clearb, def.acceptButton ) ) )
                    hb=findobj('Tag',['afc_button' num2str(clearb)]);
                    set(hb,'enable','off');
                    drawnow;
                    set(hb,'enable','on');
                    drawnow;
                end
            end
        end
			
		if ( def.modelEnable == 0 ) %&& def.remoteCloneEnable == 0 )
			waitfor(h,'Userdata',-1)
		end								% what until valid user response (see afc_pressfcn)
	end
end



% if a model is running retrieve response
if ( def.modelEnable > 0 )
	response = eval([work.vpname '_main']);			% calling model and retrieve response (correct if response = work.position(end))
	
%def.allowpredict
%work
%pause
	% send response to window if enabled or directly call _control
	% don't need that since markpressed is done in _control
	% SE 30.07.2014 10:41:36 FIXME this won't work with future custom procedures which can have their own pressfcn
	if ( def.afcwinEnable > 0 )
		afc_pressfcn(def.intervalnum, response)
	else
		 % SE 30.07.2014 10:40:05 based on update to control from 05.04.2012 15:03 WARNING DIRTY
        if isfield(work,'correctResponse') % Only TRUE for 1I-2AFC Method
           work.position{work.pvind}(end) = work.correctResponse;
        end
		afc_control(response);
	end
end

%disp('DEBUG work: exiting');

% if we remote listen
%if ( def.remoteCloneEnable > 0 )
%	% check for new data
%	%while ( work.remoteupdateprevious == work.remoteupdate )
%		afc_statelog('read');	% returns on new data only
%	%	pause( 0.5 );
%	%end
%	
%	response = work.answer{work.pvind}(work.stepnum{work.pvind}(end));			
%	
%	% send response to window if enabled or directly call _control
%	% don't need that since markpressed is done in _control
%	if ( def.afcwinEnable > 0 )
%		afc_pressfcn(def.intervalnum, response)
%	else
%		afc_control(response);
%	end
%end




