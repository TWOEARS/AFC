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

% last modified 21-07-2010 13:34:56
% revision 0.92 beta, modified 11/02/00

function afc_pregen

global def
global work

tic;															% start stopwatch timer

if def.pre == 1
eval([def.expname '_pre;']);							% calls pre-function of the experiment
end

work.predict = 1;											% entering prediction

%disp('pregenerating ...');

%tmp = work.expvaract;									% store correct entries
%tmp2 = work.position;
worksave = work;											% complete backup of work

%%%%%%% new for interleaving %%%%%%%%%
afc_interleave												% controls interleaving

if isempty(work.position{work.pvind})				% track never called before
   if def.pre == 1
		eval([def.expname '_pre;']);							% calls pre-function of the experiment
	end
   eval([def.expname '_user;']);								% calls user-function of the experiment
   afc_ranpos;														% defines interval containing the test signal
   afc_process;													% dithering, filtering and so on
   
   worksave.precorrect = work.out;					% in this case correct or false makes no sense, write to correct
	worksave.prepositionc = work.position{work.pvind};
   worksave.preexpvaractc = work.expvaract;
   
   worksave.prepvind = work.pvind;
   worksave.prelastpvind = work.lastpvind;
	worksave.preintremain = work.intremain;
	worksave.preintblock = work.intblock;
   
   worksave.removetrack = work.removetrack;
   work = worksave;
   
else															% track was already called
   

if work.lastpvind ~= work.pvind						% track number changed ( => response already given)
   eval([def.expname '_user;']);							% calls user-function of the experiment
	afc_ranpos;													% defines interval containing the test signal
	afc_process;												% dithering, filtering and so on
   
   if work.correct{work.pvind}(end) == 1
      worksave.precorrect = work.out;
      worksave.prepositionc = work.position{work.pvind};
      worksave.preexpvaractc = work.expvaract;
   else
      worksave.prefalse = work.out;
      worksave.prepositionf = work.position{work.pvind};
      worksave.preexpvaractf = work.expvaract;
	end
   
   worksave.prepvind = work.pvind;
   worksave.prelastpvind = work.lastpvind;
	worksave.preintremain = work.intremain;
	worksave.preintblock = work.intblock;
   
   worksave.removetrack = work.removetrack;
   work = worksave;

else 
   
%fake = afc_control(work.position(end),work);		% assuming correct response
%work.expvaract = fake.expvaract;
afc_control(work.position{work.pvind}(end));

work.expvaract = work.expvarnext{work.pvind}(end);		% update expvaract dependent on track

eval([def.expname '_user;']);							% calls user-function of the experiment
afc_ranpos;													% defines interval containing the test signal
afc_process;												% dithering, filtering and so on

%work.precorrect = work.out;
%work.prepositionc = work.position;
worksave.precorrect = work.out;
worksave.prepositionc = work.position{work.pvind};
worksave.preexpvaractc = work.expvaract;

worksave.prepvind = work.pvind;
worksave.prelastpvind = work.lastpvind;
worksave.preintremain = work.intremain;
worksave.preintblock = work.intblock;

%work.expvaract = tmp;									% restore correct entries
%work.position = tmp2;									%
worksave.removetrack = work.removetrack;
work = worksave;

work.pvind = worksave.prepvind;						% instead of interleave again	
work.lastpvind = worksave.prelastpvind;
work.intremain = worksave.preintremain;
work.intblock = worksave.preintblock;

%fake = afc_control(work.position(end)+1,work);	% assuming false response
%work.expvaract = fake.expvaract;
afc_control(work.position{work.pvind}(end)+1);

work.expvaract = work.expvarnext{work.pvind}(end);		% update expvaract dependent on track

eval([def.expname '_user;']);							% calls user-function of the experiment
afc_ranpos;													% defines interval containing the test signal
afc_process;												% dithering, filtering and so on

%work.prefalse = work.out;
%work.prepositionf = work.position;
worksave.prefalse = work.out;
worksave.prepositionf = work.position{work.pvind};
worksave.preexpvaractf = work.expvaract;

%work.expvaract = tmp;									% restore correct entries
%work.position = tmp2;									%
work = worksave;
end	% if lastpvind ~=
end	% if isempty(work...)

work.predict = 0;											% leaving prediction

elapsed = toc;												% blocking until end of signal presentation is reached
%while elapsed < def.bgsiglen/def.samplerate+0.1
while elapsed < work.blockButtonTime
	pause(0.02);
	elapsed = toc;
end

% eof
