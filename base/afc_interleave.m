
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
% version 0.92, modified 20/07/2000

function afc_interleave

global def
global work

% work.pvind		selects line in multidimensional var/par matrices (default 1 if interleaved is disabled)
% work.intblock	remaining interleaved tracks in block
% work.intremain	remaining interleaved tracks in run

work.lastpvind = work.pvind;									% last value of pvind

switch def.interleaved
case 0																% interleaving disabled
   work.pvind = 1;
	%work.lastpvind = work.pvind;								% changes from [] to 1 after the first step   
case 1																% only block interleaving at the moment
   if work.removetrack > 0										% remove finished track from intremain
      intremain = [];
      for i=1:length(work.intremain)
         if work.intremain(i) ~= work.removetrack
            intremain = [intremain work.intremain(i)];
         end
      end
      work.intremain = intremain;
      work.removetrack = 0;
   end

   if isempty(work.intblock) == 1							% new block
      tmp = randperm(length(work.intremain));
      work.intblock = work.intremain(tmp);
   end
   
   work.pvind = work.intblock(1);
   work.intblock = work.intblock(2:end);					% remove whats done
   
   % ------------------------------------------
   % to provide full downward compatibility work.xxx was not converted to a cell array,
   % for each track in an interleaved run the variables are selected from the cell array
   % work.int_xxx{track#}
   
   for i=1:def.expparnum										% select exppars
      eval(['work.exppar' num2str(i) '= work.int_exppar' num2str(i) '{' num2str(work.pvind) '};']);
   end
   
   if def.expparnum > 1											% copy work.expparN to work.expcond
      eval(['work.expcond = work.exppar' num2str(def.expparnum) ';']);
   end
   
   work.exppar = work.exppar1;								% copy work.exppar1 to work.exppar, just for the good old times
   % ------------------------------------------
end

work.expvaract = work.expvarnext{work.pvind}(end);		% update expvaract dependent on track

%eof