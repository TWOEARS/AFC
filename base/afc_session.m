% afc_session - session function for AFC -
%
% Usage: afc_session( sessionName )
%
% sessionName = string containing the name of the session to be performed
%
% example: afc_session('example')
%          starts the session defined in ASCII file session_example.dat. 
%          Will call afc_main for all experiments defined in the session file
%				   for a pre-defined number of runs per experiment.
% 				 
% See also help afc_main, afc, example_session.dat
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

% last modified 19-04-2013 13:03:15
% Copyright (c) 1999 - 2007 Stephan Ewert. All rights reserved.
% $Revision: 1.10.0 beta$  $Date: 31.05.2007 09:18 $

function afc_session(sessionName)

if (exist('autoexec_cfg') == 2)
	autoexec_cfg;
end
default_cfg;

if ~isempty( def.session_path )
	if max( findstr( def.session_path, '\' )) ~= length( def.session_path )
   		def.session_path = [def.session_path '\'];
   	end
end

fileName = [def.session_path 'session_' sessionName '.dat'];

if ( ~(exist(fileName) ==  2) )
	error(['afc_session: session file ''' fileName ''' not existing. The default session path can be changed in default_cfg or autoexec_cfg.']);
end

session = textread(fileName,'%s','delimiter','\n','commentstyle','matlab');

tmp = strread(session{1},'%s','delimiter',' ');
currentLineIndex = str2num(tmp{1});
currentRun = str2num(tmp{2});

% interprete the lines
for ( i = currentLineIndex+1:size(session,1) )

		currentLine = strread(session{i},'%s','delimiter',' ');
		
    %if 1
    %    %fprintf('Messung: %.0f/%.0f, (noch %.0f Runs)...\n',currentLineIndex,size(session,1),str2num(currentLine{2})+1-currentRun)
    %    fprintf('@%s# Starte Messung: %.0f/%.0f, (noch %.0f Runs): "%s"...\n',datestr(now,'HH:MM:SS'),i-1,size(session,1)-1,str2num(currentLine{2})+1-currentRun,session{i})
    %end
    
		switch ( currentLine{1} )
		case 'run'
				execStr = ['afc_main('];
				for ( k = 3:size(currentLine,1) )
					execStr = [execStr '''' currentLine{k} ''','];
				end
				
				execStr = [execStr '''runs'',' currentLine{2}+1-currentRun ');'];	
				eval(execStr);
				
				if ( ~afc_savesession(fileName) )
					% terminate the whole session if a session line was not completely finished
					break;
				else 
					% we have successfully finished a session item
					% now we have to reset currentRun for the next item, alternatively
					% we could retrieve this info from the updated session file which was just written
					currentRun = 1;
				end
%			case 'suggestPause'
%			case 'forcePause'
%			case 'displayMessage'
		end

end

% eof