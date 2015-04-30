
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

% last modified 19-04-2013 13:17:34
% revision 0.92 beta, modified 06/07/00
% added interleaving

function afc_statelog( action )

global def
global work
global msg
%
%global simdef
%global simwork

%work.lastpvindpro = [work.lastpvindpro work.lastpvind];
%work.pvindpro = [work.pvindpro work.pvind];

elapsed = 0;
wait = 0.5;

% new 21-07-2004 09:33
switch ( action )
case 'read'
	% read the remote log file
	
	while ( work.remoteupdateprevious == work.remoteupdate )
	
		% break in case of local termination, e.g., window closed
		if ( work.terminate == 1 )
			work.remoteshutdown = 1;
			break;
		end
		
		if ( exist([def.stateLogPath 'statelog.mat']) )
		
			if ( work.remoteupdateprevious == 0 )
				disp( ['monitoring ' def.stateLogPath 'statelog.mat ...']);
			end
			
			
		
			eval( ['load ' def.stateLogPath 'statelog'] );
			
			% fill the work fields
			work.remoteupdate = stateLog.remoteupdate;
			work.filename = stateLog.filename;
			
			work.pvind = stateLog.pvind;
			work.randseed = stateLog.randseed;
			work.control = stateLog.control;
			work.numrun = stateLog.numrun;
			
			work.expvarnext = stateLog.expvarnext;				
			work.expvar = stateLog.expvar;
			work.answer = stateLog.answer;
			work.correct = stateLog.correct;
			work.stepdirection = stateLog.stepdirection;
			work.stepsize = stateLog.stepsize;
			work.tmp = stateLog.tmp;
			work.tmp2 = stateLog.tmp2;
			work.tmp3 = stateLog.tmp3;
			work.tmp4 = stateLog.tmp4;
			work.expvarrev = stateLog.expvarrev;
			
			work.checktmp = stateLog.checktmp;
			work.reachedendstepsize = stateLog.reachedendstepsize; 
			work.measure = stateLog.measure;
			work.reversal = stateLog.reversal;
			work.stepnum = stateLog.stepnum;
			work.position = stateLog.position;
			
			work.trackfinished = stateLog.trackfinished;
			work.finishedcount = stateLog.finishedcount;
			work.removetrack = stateLog.removetrack;
			
			work.terminate = stateLog.terminate;
			work.abortall = stateLog.abortall;
			work.lastpvind = stateLog.lastpvind;
			work.intremain = stateLog.intremain;
			work.intblock = stateLog.intblock;
			
			work.minmaxcount = stateLog.minmaxcount;
			work.blockButtonTime = stateLog.blockButtonTime;
			
			% new for PEST
			work.PEST_DoubledTmp = stateLog.PEST_DoubledTmp;
			work.PEST_Expvar = stateLog.PEST_Expvar;
			
			work.MML_MuEstimate = stateLog.MML_MuEstimate;
			work.MML_SigmaEstimate = stateLog.MML_SigmaEstimate;
			
			% def entries
			def.rule = stateLog.def.rule;
			def.measurementProcedure = stateLog.def.measurementProcedure;
			def.steprule = stateLog.def.steprule;
			def.varstep = stateLog.def.varstep;
			def.startvar = stateLog.def.startvar;
			def.varstepApply = stateLog.def.varstepApply;
			def.maxvar = stateLog.def.maxvar;
			def.minvar = stateLog.def.minvar;
			def.holdtrack = stateLog.def.holdtrack;
			def.reversalnum = stateLog.def.reversalnum;
			def.interleavenum = stateLog.def.interleavenum;
			def.terminate = stateLog.def.terminate;
			def.endstop = stateLog.def.endstop;
			def.allterminate = stateLog.def.allterminate;
			def.maxiter = stateLog.def.maxiter;
			def.intervalnum = stateLog.def.intervalnum;
			
			def.expparnum = stateLog.def.expparnum;
			def.exppartype = stateLog.def.exppartype;
			
			% new 14.11.2005 14:22
	    msg.buttonString = stateLog.msg.buttonString;
			
			% cycle through exppars
			for i=1:def.expparnum
				eval(['def.exppar' num2str(i) 'unit = stateLog.def.exppar' num2str(i) 'unit;']);
		      		eval(['work.int_exppar' num2str(i) ' = stateLog.int_exppar' num2str(i) ';']);		
		     	end
			
			
			% if new
			if ( work.remoteupdateprevious < work.remoteupdate )
				% set the seed
				rand('state', work.randseed);
				work.remoteupdateprevious = work.remoteupdate;
				
				if ( wait > 0.5 )
					disp( ['statelog updated, monitoring ' def.stateLogPath 'statelog.mat ...']);
				end
				
				wait = 0.5;
				elapsed = 0;
				break;
			end
			
			if ( elapsed == 15 ) 
				disp( 'no action within the last 15 seconds, delaying next try 15 secs ...' );
				wait = 15;
				elapsed = 0;
			end
			
			
		else 
			if ( work.remoteupdate > 0 )
				disp( 'specified statelog was deleted ... exiting');
				work.remoteupdateprevious = 0;									% terminates inner threshold run loop if 1 
				work.remoteupdate = 0;
				work.remoteshutdown = 1;
				
				
				break;
			end
			
			disp( 'specified statelog not existing, delaying next try 15 secs ...');
			pause( 14.5 );
			work.remoteupdateprevious = 0;									% terminates inner threshold run loop if 1 
			work.remoteupdate = 0;
			work.stepnum{1} = 1;
			wait = 0.5;
			elapsed = 0;
				
			%return;
		end
		
		pause( wait );
		elapsed = elapsed + wait;
	end

case 'write'
	work.remoteupdate = work.remoteupdate + 1;
	

	% grab the work fields
	stateLog.remoteupdate = work.remoteupdate;
	stateLog.filename = work.filename;
	
	stateLog.pvind = work.pvind;
	stateLog.randseed = work.randseed;
	stateLog.control = work.control;
	stateLog.numrun = work.numrun;
	
	stateLog.expvarnext = work.expvarnext;				
	stateLog.expvar = work.expvar;
	stateLog.answer = work.answer;
	stateLog.correct = work.correct;
	stateLog.stepdirection = work.stepdirection;
	stateLog.stepsize = work.stepsize;
	stateLog.tmp = work.tmp;
	stateLog.tmp2 = work.tmp2;
	stateLog.tmp3 = work.tmp3;
	stateLog.tmp4 = work.tmp4;
	stateLog.expvarrev = work.expvarrev;
	
	stateLog.checktmp = work.checktmp;
	stateLog.reachedendstepsize = work.reachedendstepsize; 
	stateLog.measure = work.measure;
	stateLog.reversal = work.reversal;
	stateLog.stepnum = work.stepnum;
	stateLog.position = work.position;
	
	stateLog.trackfinished = work.trackfinished;
	stateLog.finishedcount = work.finishedcount;
	stateLog.removetrack = work.removetrack;
	
	stateLog.terminate = work.terminate;
	stateLog.abortall = work.abortall;
	stateLog.lastpvind = work.lastpvind;
	stateLog.intremain = work.intremain;
	stateLog.intblock = work.intblock;
	
	stateLog.minmaxcount = work.minmaxcount;
	stateLog.blockButtonTime = work.blockButtonTime;
	
	% new for PEST
	stateLog.PEST_DoubledTmp = work.PEST_DoubledTmp;
	stateLog.PEST_Expvar = work.PEST_Expvar;
	
	stateLog.MML_MuEstimate = work.MML_MuEstimate;
	stateLog.MML_SigmaEstimate = work.MML_SigmaEstimate;
	
	% def entries
	stateLog.def.rule = def.rule;
	stateLog.def.measurementProcedure = def.measurementProcedure;
	stateLog.def.steprule = def.steprule;
	stateLog.def.varstep = def.varstep;
	stateLog.def.startvar = def.startvar;
	stateLog.def.varstepApply = def.varstepApply;
	stateLog.def.maxvar = def.maxvar;
	stateLog.def.minvar = def.minvar;
	stateLog.def.holdtrack = def.holdtrack;
	stateLog.def.reversalnum = def.reversalnum;
	stateLog.def.interleavenum = def.interleavenum;
	stateLog.def.terminate = def.terminate;
	stateLog.def.endstop = def.endstop;
	stateLog.def.allterminate = def.allterminate;
	stateLog.def.maxiter = def.maxiter;
	stateLog.def.intervalnum = def.intervalnum;
	
	stateLog.def.expparnum = def.expparnum;
	stateLog.def.exppartype = def.exppartype;
	
	% new 14.11.2005 14:22
	stateLog.msg.buttonString = msg.buttonString;
	
	% cycle through exppars
	for i=1:def.expparnum
		eval(['stateLog.def.exppar' num2str(i) 'unit = def.exppar' num2str(i) 'unit;']);
      		eval(['stateLog.int_exppar' num2str(i) ' = work.int_exppar' num2str(i) ';']);		
     	end
	
	
	  % 14.11.2005 14:27 check version for >=7 and add -V6
   if ( work.matlabVersion > 6 ) 
      eval( ['save ' def.stateLogPath 'statelog stateLog -V6'] );
   else
   	eval( ['save ' def.stateLogPath 'statelog stateLog'] );
   end
	

case 'close'
	if ( exist([def.stateLogPath 'statelog.mat']) )
		delete([def.stateLogPath 'statelog.mat']);
		%disp('deleted');
	end
end

% eof




