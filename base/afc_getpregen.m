
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
% revision 0.93 beta, modified 28/09/00

function afc_getpregen

global def
global work

if isempty(work.pvind)	% changed 28/09 (work.lastpvind)										% true for the first trial
   afc_interleave;
   if def.pre == 1
		eval([def.expname '_pre;']);							% calls pre-function of the experiment
	end
   eval([def.expname '_user;']);								% calls user-function of the experiment
   afc_ranpos;														% defines interval containing the test signal
   afc_process;													% dithering, filtering and so on
   
else																	% true for all other trial
   
   %work.removetrack = work.preremovetrack;
   work.pvind = work.prepvind;								% update from pregeneration	
   work.lastpvind = work.prelastpvind;
   work.intremain = work.preintremain;
	work.intblock = work.preintblock;
      
   if isempty(work.correct{work.pvind})					% track was never called before, pregen wrote signals to correct
   	work.out=work.precorrect;
      work.position{work.pvind}=work.prepositionc;
      work.expvaract = work.preexpvaractc;

   else																% track was already called
   
	switch work.correct{work.pvind}(end)					% get precorrect
	case 1
   	if ~isempty(work.precorrect)							% makes no sense anymore, since pvind already updated from pregen
      	work.out=work.precorrect;
         work.position{work.pvind}=work.prepositionc;
         work.expvaract = work.preexpvaractc;
   	else   
         if def.pre == 1
				eval([def.expname '_pre;']);					% calls pre-function of the experiment
			end
         eval([def.expname '_user;']);						% calls user-function of the experiment
   		afc_ranpos;												% defines interval containing the test signal
   		afc_process;											% dithering, filtering and so on
   	end
	case 0															% get prefalse
      if ~isempty(work.prefalse)
         work.out=work.prefalse;
         work.position{work.pvind}=work.prepositionf;
         work.expvaract = work.preexpvaractf;
   	else   
         if def.pre == 1
				eval([def.expname '_pre;']);							% calls pre-function of the experiment
			end
         eval([def.expname '_user;']);						% calls user-function of the experiment
   		afc_ranpos;												% defines interval containing the test signal
   		afc_process;											% dithering, filtering and so on
   	end
   end	% switch correct/false
   end	% if isempty(work.position)/else
end

% eof