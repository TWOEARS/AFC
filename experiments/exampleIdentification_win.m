% revision 0.94 beta, modified 18/03/02

function exampleIdentification_win(action)

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
if ( (strcmp(action, 'open') == 0) & isempty(findobj('Tag','afc_win')) )
	work.terminate = 1;
	work.abortall = 1;
	%warning('AFC:afcwin', 'Attempt to access non existing response window. Run terminated');
	%warning('Attempt to access non existing response window. Run terminated');
	return;	
end

switch action
   case 'open'

% 4 buttons hardwired !!!!!
num=4;

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
   'position',get(0,'defaultFigurePosition') - [0 0 1 1], ...
   'Name',['AFC-measurement (' def.version ')'] );

% change to default size again
set(h,'position',get(0,'defaultFigurePosition'));
   
for i = 1:num															% create buttons
   bwidth = 0.8/(num+(0.5*(num-1)));
   
  	b = uicontrol ...
   ('Parent',h, ...
   'Units','normalized', ...
	'FontUnits','normalized', ...
	'BusyAction','cancel', ...
   'Callback',['afc_pressfcn(' num2str(num) ',' num2str(i) ')'], ...
	'FontSize',0.3, ...
	'Position',[0.55 0.1+(i-1)*(1.5*bwidth) 0.35 bwidth], ...
   'BackgroundColor',[0.75 0.75 0.75],...
	'String',msg.buttonString{i}, ...
   'Tag',['afc_button' num2str(i)]);
   
    % 15-04-2005 14:15 check version for > 6 and add keypressfcn to buttons
   if ( work.matlabVersion > 6 ) 
   	set(b,'KeyPressFcn',['afc_pressfcn(' num2str(num) ',0)']);
   end
   
   if ( (def.mouse == 0) | ~( isempty(def.acceptButton) | ismember(i, def.acceptButton ) ) )
   		set(b,'Enable','off');
   end
   
end

switch def.windetail
case 0
b = uicontrol('Parent',h, ...										% create message display
	'Units','normalized', ...
	'FontUnits','normalized', ...
   'BackgroundColor',[0.9 0.9 0.9], ...
  	'FontSize',0.1, ...
   'Position',[0.1 0.2 0.4 0.6], ...
	'Style','text', ...
	'Tag','afc_message');
case 1
   t1 = uicontrol('Parent',h, ...										% create message display
	'Units','normalized', ...
	'FontUnits','normalized', ...
   'BackgroundColor',[0.9 0.9 0.9], ...
  	'FontSize',0.4, ...
   'Position',[0.1 0.825 0.4 0.075], ...
   'Style','text', ...
   'String',' ', ...
   'Tag','afc_t1');

	t2 = uicontrol('Parent',h, ...										% create message display
	'Units','normalized', ...
	'FontUnits','normalized', ...
   'BackgroundColor',[0.9 0.9 0.9], ...
  	'FontSize',0.4, ...
   'Position',[0.1 0.725 0.4 0.075], ...
   'Style','text', ...
   'String',' ', ...
	'Tag','afc_t2');

   b = uicontrol('Parent',h, ...										% create message display
	'Units','normalized', ...
	'FontUnits','normalized', ...
   'BackgroundColor',[0.9 0.9 0.9], ...
  	'FontSize',0.1, ...
   'Position',[0.1 0.1 0.4 0.55], ...
   'Style','text', ...
  	'Tag','afc_message');
end


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
   
   set(ht1,'string',sprintf(msg.experiment_windetail, work.filename ));
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
   drawnow; % flush event que 03-05-2005 09:57

case 'false'
   hm=findobj('Tag','afc_message');
   set(hm,'string',msg.false_msg);
   drawnow; % flush event que 03-05-2005 09:57

case 'clear'
   hm=findobj('Tag','afc_message');
   set(hm,'string','');
   drawnow; % flush event que 03-05-2005 09:57

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