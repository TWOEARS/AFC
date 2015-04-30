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

% last modified 26-03-2014 12:16:42
% revision 0.94 beta, modified 18/03/02

function afc_2buttonwin(action)

global def
global work
global msg



% if the window is not enabled just leave here
if ( def.afcwinEnable == 0 )
	return;
end

% check whether window is still existing
% if we attempt to call a dead window with any action other than 'open'
% shut the whole thing down
if ( strcmp(action, 'open') == 0 & isempty(findobj('Tag','afc_win')) )
	work.terminate = 1;
	work.abortall = 1;
	%warning('AFC:afcwin', 'Attempt to access non existing response window. Run terminated');
	%warning('Attempt to access non existing response window. Run terminated');
	return;	
end

switch action
   case 'open'

% number of buttons equals intervals
%num=getfield(def,'intervalnum');
% 2 buttons hardwired
num=2;

h = figure('BusyAction','cancel','KeyPressFcn',...			% create modal dialog window
   ['afc_pressfcn(' num2str(num) ',0)'],'Tag','afc_win',...
   'menubar','none',...
   'Windowstyle', 'modal',...
   'Color',[0.75 0.75 0.75],...
   'Interruptible','off',...
   ... % added secure close
   'CloseRequestFcn','afc_close', ...
   ... % added Truetype
   'defaultUIControlFontname','Arial', ...
   ... % change size once to avoid Matlab 6 modal window refresh bug
   'position',def.winFigurePosition - [0 0 1 1], ...
   'Name',['AFC-measurement (' def.version ')'] );

% change to default size again
set(h,'position',def.winFigurePosition);


% 08.11.2006 09:43
% some position adjustments
yShift = 0;
yShiftButtons = 0; 

switch def.winButtonConfiguration
case 1
	% open start and end button, too
	
	b = uicontrol('Parent',h, ...										% create start button
		'Units','normalized', ...
		'FontUnits','normalized', ...
		'BusyAction','cancel', ...
		'Callback',['afc_pressfcn(' num2str(num) ',''s'')'], ...
		'FontSize',0.5, ...
		'Position',[0.1 0.85 0.35 0.1], ...
		'BackgroundColor',[0.75 0.75 0.75],...
		'String',msg.startButtonString, ...
	   'Tag','afc_startbutton');
	      
	 % 15-04-2005 14:15 check version for >=7 and add keypressfcn to buttons
   if ( work.matlabVersion > 6 ) 
   	set(b,'KeyPressFcn',['afc_pressfcn(' num2str(num) ',0)']);
   end
   
   if ( (def.mouse == 0) )
   		set(b,'Enable','off');
   end
	
	b = uicontrol('Parent',h, ...										% create end button
		'Units','normalized', ...
		'FontUnits','normalized', ...
		'BusyAction','cancel', ...
		'Callback',['afc_pressfcn(' num2str(num) ',''e'')'], ...
		'FontSize',0.5, ...
		'Position',[0.55 0.85 0.35 0.1], ...
		'BackgroundColor',[0.75 0.75 0.75],...
		'String',msg.endButtonString, ...
		'Tag','afc_endbutton');
		
		% 15-04-2005 14:15 check version for >=7 and add keypressfcn to buttons
   if ( work.matlabVersion > 6 ) 
   	set(b,'KeyPressFcn',['afc_pressfcn(' num2str(num) ',0)']);
   end
   
   if ( (def.mouse == 0) )
   		set(b,'Enable','off');
   end
   
   % some position adjustments
   yShift = 0.125;
   yShiftButtons = 0.05; 

end

switch def.windetail
case 0
b = uicontrol('Parent',h, ...										% create message display
	'Units','normalized', ...
	'FontUnits','normalized', ...
   'BackgroundColor',[0.9 0.9 0.9], ...
  	'FontSize',0.15, ...
   'Position',[0.1 0.4 0.8 0.5-yShift], ...
	'Style','text', ...
	'Tag','afc_message');
	
	% some position adjustments
   yShift = 0;
   yShiftButtons = 0; 
case 1
   t1 = uicontrol('Parent',h, ...										% create message display
	'Units','normalized', ...
	'FontUnits','normalized', ...
   'BackgroundColor',[0.9 0.9 0.9], ...
  	'FontSize',0.4, ...
   'Position',[0.1 0.85-yShift 0.35 0.075], ...
   'Style','text', ...
   'String',' ', ...
   'Tag','afc_t1');

	t2 = uicontrol('Parent',h, ...										% create message display
	'Units','normalized', ...
	'FontUnits','normalized', ...
   'BackgroundColor',[0.9 0.9 0.9], ...
  	'FontSize',0.4, ...
   'Position',[0.55 0.85-yShift 0.35 0.075], ...
   'Style','text', ...
   'String',' ', ...
	'Tag','afc_t2');

   b = uicontrol('Parent',h, ...										% create message display
	'Units','normalized', ...
	'FontUnits','normalized', ...
   'BackgroundColor',[0.9 0.9 0.9], ...
  	'FontSize',0.15, ...
   'Position',[0.1 0.4-(yShift-yShiftButtons) 0.8 0.4-yShiftButtons], ...
   'Style','text', ...
  	'Tag','afc_message');
end 

for i = 1:num															% create buttons
   bwidth = 0.8/(num+(0.5*(num-1)));
   bsepar=bwidth/4;
   
  	b = uicontrol ...
   ('Parent',h, ...
   'Units','normalized', ...
	'FontUnits','normalized', ...
	'BusyAction','cancel', ...
   'Callback',['afc_pressfcn(' num2str(num) ',' num2str(i) ')'], ...
	'FontSize',0.3, ...
	'Position',[0.1+(i-1)*(1.5*bwidth) 0.1-yShiftButtons bwidth 0.2], ...
   'BackgroundColor',[0.75 0.75 0.75],...
	'String',msg.buttonString{i}, ...
   'Tag',['afc_button' num2str(i)]);
   
    % 15-04-2005 14:15 check version for >=7 and add keypressfcn to buttons
   if ( work.matlabVersion > 6 ) 
   	set(b,'KeyPressFcn',['afc_pressfcn(' num2str(num) ',0)']);
   end
   
   if ( (def.mouse == 0) | ~( isempty(def.acceptButton) | ismember(i, def.acceptButton ) ) )
   		set(b,'Enable','off');
   end
   
end



% refresh(h)

%------------------------ end of action 'open'----------------------------

case 'close'
	h=findobj('Tag','afc_win');
   	
	% snd_pc
	%if ( def.bits > 16 )
   	%	if ( isfield(work, 'soundres' ) )
   	%		if ( sum(work.soundres) ~= 0 )
        % 			snd_stop(work.soundres);
        % 			work.soundres = 0;
   	%		end
      	%	end
   	%end
   
	delete(h);
	%close(h);
   
case 'start_ready'
  hm=findobj('Tag','afc_message');					% handle to message box
	h=findobj('Tag','afc_win');						%
	ht2=findobj('Tag','afc_t2');
	ht1=findobj('Tag','afc_t1');
   
   % Was Andy request
   % 01-08-2005 10:30 SE introduce config var for this screen skip because the start_msg
   % might be used for different msg during the experiment run
   % are we really starting the exp or do we start the next measurement?
   % 08.09.2005 14:34 added def.skipStartMessage
   if ( (work.terminate > 0) & (def.skipStartMessage == 1) )
   	set(h,'UserData',0);
		pause( 0.25);	
   else
   	set(hm,'string',msg.start_msg);
		set(h,'UserData',4);
   end
   
   set(ht1,'string',sprintf(msg.experiment_windetail, work.filename));
   set(ht2,'string',sprintf(msg.measurementsleft_windetail, size(work.control,1) + 1 - work.numrun, size(work.control,1)));
   
case 'start'
   hm=findobj('Tag','afc_message');
   ht2=findobj('Tag','afc_t2');

   set(hm,'string','');
   set(ht2,'string',sprintf(msg.measurement_windetail, work.numrun, size(work.control,1)));
   
case 'finished'
   hm=findobj('Tag','afc_message');
   h=findobj('Tag','afc_win');
	set(hm,'string',msg.finished_msg);				% called if experiment is already finished
	set(h,'UserData',-2);								% ready to get only end command

case 'correct'
   hm=findobj('Tag','afc_message');
   set(hm,'string',msg.correct_msg);
   drawnow; % flush event que 15-04-2005 13:38

case 'false'
   hm=findobj('Tag','afc_message');
   set(hm,'string',msg.false_msg);
   drawnow; % flush event que 15-04-2005 13:38

case 'clear'
   hm=findobj('Tag','afc_message');
   set(hm,'string','');
   drawnow; % flush event que 15-04-2005 13:38

case 'measure'
   hm=findobj('Tag','afc_message');
   set(hm,'string',msg.measure_msg);
   
case 'maxvar'
	hm=findobj('Tag','afc_message');
   set(hm,'string',msg.maxvar_msg);
   
case 'minvar'
   hm=findobj('Tag','afc_message');
	set(hm,'string',msg.minvar_msg);
 
case 'markint'						% must be a blocking action !!!
   tic;

	inter=max(0,def.intervallen/def.samplerate-0.02);
	paus=max(0,def.pauselen/def.samplerate-0.02);
	
	% 1.00.1
	%if ( ~(strcmp(def.externSoundCommand, 'sndmex') & def.sndmexmark) & ~((strcmp(def.externSoundCommand, 'soundmex') | strcmp(def.externSoundCommand, 'soundmexfree') | strcmp(def.externSoundCommand, 'soundmex2') | strcmp(def.externSoundCommand, 'soundmex2free') | strcmp(def.externSoundCommand, 'soundmexpro') ) & def.soundmexMark) )
	%if ((def.sndmex == 0) | (def.sndmexmark == 0))
	if ( ~afc_sound('isSoundmexMarking') )
		switch def.markinterval
	   	case 1
			pause(def.presiglen/def.samplerate)
	
			for i=1:def.intervalnum-1
	   			h=findobj('Tag',['afc_button' num2str(i)]);
	   			if ( ~isempty(h) )
	   				set(h,'backgroundcolor',[1 0 0])
	   			end
	   			pause(inter)
	   			if ( ~isempty(h) )
					set(h,'backgroundcolor',[0.75 0.75 0.75])
	   			end	
	   			pause(paus)
			end
			h=findobj('Tag',['afc_button' num2str(def.intervalnum)]);
			if ( ~isempty(h) )
				set(h,'backgroundcolor',[1 0 0])
	   		end
	   		pause(inter)
	   		if ( ~isempty(h) )
	   			set(h,'backgroundcolor',[0.75 0.75 0.75])
	  		end
	  		pause(def.postsiglen/def.samplerate)
	   
	   	case 0
	      	%pause((def.presiglen+def.postsiglen+def.intervalnum*def.intervallen+ ...
	      	%(def.intervalnum-1)*def.pauselen)/def.samplerate)   
		end
	end

	elapsed = toc;												% blocking until end of signal presentation is reached
	%while elapsed < def.bgsiglen/def.samplerate+0.1	% plus 0.1 sec safety margin 
   	while elapsed < work.blockButtonTime
   		pause(0.02);
   		elapsed = toc;
		end
   
% ------------------------- end of action 'markint' -------------------
   
case 'markpressed'
   hb=findobj('Tag',['afc_button' num2str(work.answer{work.pvind}(work.stepnum{work.pvind}(end)))]);
   
   if ( ~isempty(hb) )
   	set(hb,'backgroundcolor',[0 0 0.75]);
   	pause(0.2);
	set(hb,'backgroundcolor',[0.75 0.75 0.75]);
	pause(0.0001);
   end

case 'markcorrect'
   hb=findobj('Tag',['afc_button' num2str(work.position{work.pvind}(work.stepnum{work.pvind}(end)))]);
   
   if def.markpressed
   	pause(0.2);
   end
   
   if ( ~isempty(hb) )
	   set(hb,'backgroundcolor',[0.5 0.5 0]);
	   pause(0.2);
	   set(hb,'backgroundcolor',[0.75 0.75 0.75]);
	   pause(0.0001);
   end

case 'response_ready'
   hm=findobj('Tag','afc_message');
	set(hm,'string',msg.ready_msg);

end	% end switch

% eof