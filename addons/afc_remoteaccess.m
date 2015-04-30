% If def.remoteAccessEnable == 1, and this function is existing and in the MATLAB search path,
% than it is called after each retrieved response or simulation step and when the current run
% is finished. It can execute arbitrary code. Usually it is used to let the operator interrupt
% a measurement session or to send messages to the subject.
% The given example interrupts the measurement session after the current run is finished. 
% The subject is ask to confirm and to contact the operator. The function might be copied
% via network access to the folder from where the measurement is started at any time.   

global work

% send message to response window when run is terminated
if ( work.terminate == 1 )

	% open the response window if not existing
	if isempty( findobj('Tag','afc_win') )
		afc_win('open');
	end
	
	h=findobj('Tag','afc_win');
	hm = findobj('Tag','afc_message');
	
	% display a message
	string_msg = {'Experiment interrupted by Operator.', ...
	              'Press any button to end.', ...
	              'Please contact your Operator'};
	
	set(hm,'string', string_msg );
	
	% let the window accept any button ans set userdata to 0 when pressed 
	set(h,'Userdata',4);
	
	% wait for any button to be pressed
	waitfor(h,'UserData',0);
	
	% tell afc to exit
	work.abortall = 1;
	work.terminate = 1;
	
	% close the window if winEnable is off
	if ( def.afcwinEnable == 0 )
	   	afc_win('close');
	end
end
