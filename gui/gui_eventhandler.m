
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

% last modified 01-03-2013 19:00:48

function gui_eventhandler( action )

global work

switch ( action )

case 'splashscreen_checkbox'
	work.splashscreenState = 2;
	
	h = findobj('Tag','gui_splashscreen');
	
	close(h);
	
case 'localprefs_okbutton'
	% retrieve settings
	h = findobj('tag','gui_localprefs');
	
	if ( ~isempty(h) )
		work.localprefs.useSoundmex = get(findobj('tag','localprefs_usesoundmex'),'value');
		work.localprefs.useSoundmexFree = get(findobj('tag','localprefs_usesoundmexfree'),'value');
		work.localprefs.useSoundmex2 = get(findobj('tag','localprefs_usesoundmex2'),'value');
		work.localprefs.useSoundmexPro = get(findobj('tag','localprefs_usesoundmexpro'),'value');
		work.localprefs.useSoundmexProFree = get(findobj('tag','localprefs_usesoundmexprofree'),'value');
		work.localprefs.useStatelog = get(findobj('tag','localprefs_usestatelog'),'value');
		work.localprefs.statelogPath = get(findobj('tag','localprefs_statelogpath'),'string');
		v = get(findobj('tag','localprefs_language'),'value');
		st = get(findobj('tag','localprefs_language'),'string');
		work.localprefs.language = st{v};
		
		gui_writeautoexec;
		
		close(h);
	end 
	
case 'localprefs_cancelbutton'
	h = findobj('tag','gui_localprefs');
	close(h);
end

