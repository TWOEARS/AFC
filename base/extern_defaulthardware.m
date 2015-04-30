
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

% last modified 07-06-2011 14:46:42
% revision 0.94.4 beta, modified 19/04/02

function extern_defaulthardware(action)

global def
global work

switch action
case 'open'
% just play some zeros to get the DAC running
if ( def.soundEnable > 0 )
	
	afc_sound('play_warmup_zeros');
	
end
%disp('hardware open');

case 'initialize'
%disp('hardware initialize');

case 'reset'
%disp('hardware reset');

case 'close'
%disp('hardware close');
	
otherwise
disp('hardware unknown action');

end

% eof