% afc_savesession
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

% last modified 31-05-2007 16:45:20
% Copyright (c) 1999 - 2007 Stephan Ewert. All rights reserved.
% $Revision: 1.10.0 beta$  $Date: 31.05.2007 09:18 $

function sessionEntryFinished = afc_savesession( fileName )

% uhm, dirty, but like this we can get the info we need from AFC
global work

% return a 'not done' per default which lets the session terminate
sessionEntryFinished = 0;
		
% check whether we finished at least one run and update session file if this is the case
if ( work.runsFinished > 0 )
	
	% read the session file
	session = textread(fileName,'%s','delimiter','\n');
	
	% count headerlines
	found = 1;
	headerlines = 0;
	while ( ~isempty(found) )
		found = findstr(session{headerlines+1},'%');
    if ( ~isempty(found) )
    	headerlines = headerlines + 1;
    end
	end

	% read the session file without comments
	sessionNoComments = textread(fileName,'%s','delimiter','\n','commentstyle','matlab');
	
	% were are we currently?
	tmp = strread(sessionNoComments{1},'%s','delimiter',' ');
	currentLineIndex = str2num(tmp{1});
	currentRun = str2num(tmp{2});
	
	% how many runs were on the list and how many are left?
	currentLine = strread(sessionNoComments{currentLineIndex+1},'%s','delimiter',' ');
	runsLeft = str2num(currentLine{2})+1 - (currentRun + work.runsFinished);
	
	% increment counters
	if ( runsLeft <= 0 )
		% all runs finished, done with this session entry, increase line counter, reset run counter
		session{headerlines+1} = ['   ' num2str(currentLineIndex+1) ' 1'];
		sessionEntryFinished = 1;
	else
		% still runs left, update run counter
		session{headerlines+1} = ['   ' num2str(currentLineIndex) ' ' num2str(currentRun + work.runsFinished)];
	end
	
	% write the updated session file
	fid=fopen(fileName,'w');
  for i=1:size(session,1)
  	fprintf(fid,'%s\n',session{i});
	end
  fclose(fid);
end

% eof