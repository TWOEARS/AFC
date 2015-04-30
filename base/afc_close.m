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

% last modified 06-06-2011 17:20:19

function afc_close

global work
global def

h=findobj('Tag','afc_win');

work.terminate=1;				% tell afc to abort and end
work.abortall=1;
set(h,'Userdata',-1);

% snd_pc
%if ( isfield(work, 'soundres' ) )
%   if ( sum(work.soundres) ~= 0 )
%      snd_stop(work.soundres);
%      work.soundres = 0;
%   end
%end

delete(h);						% delete win


% FIXME: wait for quiet init ans skip this
%if def.sndmex > 0
%	sndmex('exit');
%end

% 1.001
if ( def.soundEnable > 0 )
%	switch def.externSoundCommand
%	case 'sndmex'
%		%sndmex('stopall');
%		sndmex('exit');
%	case {'soundmex','soundmexfree'}
%		%soundmex('stopall');
%		soundmex('exit');
%	case {'soundmex2','soundmex2free'}
%		soundmex2('exit');
%	case {'soundmexpro'}
%		soundmexpro('exit');
%	case 'snd_pc'
%		if ( isfield(work, 'soundres' ) )
%	   		if ( sum(work.soundres) ~= 0 )
%	      			snd_stop(work.soundres);
%	      			work.soundres = 0;
%	   		end
%		end
%	end
	afc_sound('close');
end

if ( def.showEnable > 0 )
   	afc_show('close');
end

if ( def.stateLog > 0 )
	afc_statelog('close');
end

% 0.94.4 se close hardware
if ( def.extern_hardware )
	feval(def.extern_hardware, 'close');
end

% FIXME should this be here, usually we should not end a model simulation by closing the window (if open at all)
%% 05.11.2010 16:33 SE close the model
%if ( def.modelEnable > 0 )
%	if (exist([work.vpname '_close']) == 2)
%			eval([work.vpname '_close']);	% calls model close function if existing
%	end
%end

%eof