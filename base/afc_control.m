% afc_control - handling of measurement procedures

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

% last modified 24-07-2013 10:37, 1.30.1
% revision 0.93 beta, modified 17/06/01

% added pressed button marking (23/02/00)

% for pregeneration (work is no longer global)
% wieder global 11/02

%function work = afc_control(answer,work)
function afc_control(answer)

global def
global work
%global msg

global simwork % only mueact, probact for display used

%len_pos = length(work.position{work.pvind})
%len_step = length(work.stepnum{work.pvind})
%len_ans = length(work.answer{work.pvind})

% SE 22.07.2010 11:32 added check sanity here:
% on mad button tabbing, afc_control could get called multiple times, a) a second time when the first execution is still running 
% (in which case answer is already incremented) or b) when afc_control was already finished but ranpos was not executed yet 
% (in which case position lags on step behind). Case a) can be removed by setting Userdata to 0 right before afc_control is called in afc_pressfcn.
%
% when entering in a healthy state stepnum and position have to be same length
if ( length(work.position{work.pvind}) ~= length(work.stepnum{work.pvind}) )
	%warning('afc_control: work.position and work.stepnum mismatch');
	% this needs to be checked if Userdata is set to 0 in afc_pressfn right before calling afc_control
	%if ( work.predict == 0 & def.afcwinEnable > 0 )
	%	h=findobj('Tag','afc_win');	
	%	if ( get(h,'UserData') == 0 )
	%		set(h,'Userdata',1);
	%	end
	%end
	return;
end
% moreover, answer has to lag one step behind
if ( length(work.answer{work.pvind}) ~= length(work.position{work.pvind})-1 )
	%warning('afc_control: work.answer and work.position mismatch');
	return;
end

if work.predict == 0;
	worksave=work;																	% backup
end

% SE 22.07.2013 11:33
work.presentationOrder{work.pvind}(work.stepnum{work.pvind}(end)) = work.presentationCounter;
if work.predict == 0 
	work.presentationCounter = work.presentationCounter + 1;
end


work.answer{work.pvind}(work.stepnum{work.pvind}(end)) = answer;

% Append the current value of the experimental variable to the history
% SE 23.04.2013 16:37 pulled out of methods
work.expvar{work.pvind}=[work.expvar{work.pvind} work.expvarnext{work.pvind}];

% new 21-07-2004 09:33
if ( work.predict == 0 )
	work.randseed = rand('state');
	if ( def.stateLog > 0 )
		afc_statelog('write');
	end
end

if ( def.afcwinEnable > 0 )
	h=findobj('Tag','afc_win');												% for Userdata
end

%work.answer{work.pvind}
%work.position{work.pvind}

%------------------------- up-down procedure ------------------------
len=work.stepnum{work.pvind}(end);
checklast=work.answer{work.pvind}(len) == work.position{work.pvind}(len);					% checks last answer
work.correct{work.pvind} = [work.correct{work.pvind} checklast];
work.checktmp{work.pvind} = [work.checktmp{work.pvind} checklast];

if work.predict == 0
   
	% window messages
	if ( def.afcwinEnable > 0 ) 
   		if ( (def.markpressed > 0) | (def.modelEnable > 0) )														% mark pressed button
      			feval(def.afcwin, 'markpressed');
		end
   
   		if def.markcorrect														% mark pressed button
      			feval(def.afcwin, 'markcorrect');
   		end

   		if checklast == 1 & def.feedback > 0								% displays response
      			feval(def.afcwin, 'correct');
      			%set(hm,'string',msg.correct_msg);
		elseif checklast == 0 & def.feedback > 0
      			feval(def.afcwin, 'false');
      			
      			%set(hm,'string',msg.false_msg);
   		else
      			feval(def.afcwin, 'clear');
      			
   			%set(hm,'string','');
		end
	end
   	
   	
   % FIXME whole thing has to go to model files
	if ( def.modelEnable > 0 )
		if (exist([work.vpname '_display']) == 2)
			eval([work.vpname '_display']);	% calls model display function if existing
		end
	end
end


%%%%%%%%%%%%%%%%%%%%%% now switch to the measurement procedure %%%%%%%%%%%%%%%%%%%%%

% OFFICIALLY SUPPORTED transformedUpDown
if ( strcmp(def.measurementProcedure, 'transformedUpDown') )
	len=length(work.checktmp{work.pvind});
	
	startp=max(len-def.rule{work.pvind}(1)+1,1);
	valid=len - def.rule{work.pvind}(1) >= 0;
	checkup=valid * prod(double(work.checktmp{work.pvind}(startp:end) == 0*work.checktmp{work.pvind}(startp:end)));
	
	valid=len - def.rule{work.pvind}(2) >= 0;
	startp=max(len-def.rule{work.pvind}(2)+1,1);
	checkdown=valid * prod(double(work.checktmp{work.pvind}(startp:end) == 0 * work.checktmp{work.pvind}(startp:end) + 1));
	
	stepdirection = checkup - checkdown;									% -1,0 or 1: -1 decreases expvar 
	if abs(stepdirection) == 1
		work.checktmp{work.pvind}=[];
	end
	%---------------------------------------------------------------------
	
	%----------------------- reversals ------------------------------------
	reversal=round((stepdirection-work.tmp{work.pvind})/3);							% -1,0 or 1: -1 upper reversal ...
	if stepdirection == 0
		tmp=work.tmp{work.pvind};
	else
		tmp=stepdirection;
	end
	
	if reversal ~= 0
		work.tmp2{work.pvind}=work.tmp2{work.pvind}+1;
	   	% changed 6/17/01 only update expvarrev if track is not finished
	   	if ~work.trackfinished{work.pvind}													% counts number of reversals
	   		work.expvarrev{work.pvind}=[work.expvarrev{work.pvind} work.expvarnext{work.pvind}];  
		end
	end
	work.stepdirection{work.pvind} = [work.stepdirection{work.pvind} stepdirection];
	work.tmp{work.pvind} = tmp;
	work.reversal{work.pvind} = [work.reversal{work.pvind} reversal];
	%----------------------------------------------------------------------

	%----------------------- change expvar --------------------------------
	if or(reversal == def.steprule{work.pvind}, 2*abs(reversal) == def.steprule{work.pvind}) 		% added stepsizereduction after each reversal
   		
   		%SE 29.07.2009 13:53 ignore a given number of reversals at the beginning
   		if ( sum(abs(work.reversal{work.pvind})) > def.stepruleIgnoreReversals )
   		
	   		% 16-03-2004 08:58 tmp4 can be used as an index to the varstep vector but wasnt so far
	 		% now use it, see below 
	   		work.tmp4{work.pvind} = work.tmp4{work.pvind}+1; 
	   		
	   		work.stepsize{work.pvind} = def.varstep{work.pvind}(min(work.tmp4{work.pvind},length(def.varstep{work.pvind})));	% change stepsize  
			%disp(['redstep hit: stepsize' num2str(work.stepsize)]);   
			
			end
	end
	%work.expvar{work.pvind}=[work.expvar{work.pvind} work.expvaract];
	%work.expvarnext{work.pvind}=work.expvaract + work.stepsize{work.pvind} * stepdirection;	% copied to expvaract in afc_interleave
	
	% Append the current value of the experimental variable to the history
	% SE 23.04.2013 16:32 moved up
	%work.expvar{work.pvind}=[work.expvar{work.pvind} work.expvarnext{work.pvind}];

	% 16-03-2004 09:32 introduce multiplicative use of work.stepsize
	if ( def.varstepApply == 2 )
		if stepdirection > 0
			work.expvarnext{work.pvind}=work.expvarnext{work.pvind} * work.stepsize{work.pvind};
		elseif stepdirection < 0
			work.expvarnext{work.pvind}=work.expvarnext{work.pvind} / work.stepsize{work.pvind};
		end
	else
		% old additive code
		work.expvarnext{work.pvind}=work.expvarnext{work.pvind} + work.stepsize{work.pvind} * stepdirection;	% copied to expvaract in afc_interleave
	end

	if work.expvarnext{work.pvind} > def.maxvar
		work.expvarnext{work.pvind} = def.maxvar;
		work.minmaxcount{work.pvind} = work.minmaxcount{work.pvind} + 1;
		if ( work.predict == 0 & def.afcwinEnable > 0 )
			feval(def.afcwin, 'maxvar');
			%set(hm,'string',msg.maxvar_msg);
		end
	elseif work.expvarnext{work.pvind} < def.minvar
		work.expvarnext{work.pvind} = def.minvar;
		work.minmaxcount{work.pvind} = work.minmaxcount{work.pvind} + 1;
		if ( work.predict == 0 & def.afcwinEnable > 0 )
	   		feval(def.afcwin, 'minvar');
	      		%set(hm,'string',msg.minvar_msg);
	   	end
	end
	%----------------------------------------------------------------------

	if ( def.debug == 1 & work.predict == 0 )			% for debugging
		work	
	end   
   
	%----------------------- experimental run -----------------------------
	if work.predict == 0   
		%%%%%%% track already terminated but was called again (due to interleaving) %%%%%%%%
		if work.trackfinished{work.pvind}==1	% undo changes in work
			%disp('kdgfsdlkgjösdgjösdgjösdg');
	      
			% changed 4/17/01 undo only if tracks are not to be continued
			if ~def.holdtrack
		      		work = worksave;
			else		% otherwise fake continue
		      		work.stepnum{work.pvind}=[work.stepnum{work.pvind} max(work.stepnum{work.pvind})+1];
		      	end
		else   
	   		%%%%%%% track termination on minmaxcount %%%%%%%%%
			if work.minmaxcount{work.pvind} * def.terminate >= def.endstop				
	      
	      if ~def.allterminate
					work.trackfinished{work.pvind} = 1;						% was work.terminate before
					work.finishedcount = work.finishedcount + 1;
				      
					% changed 4/17/01 remove track if hold off
					if ~def.holdtrack 
				      		work.removetrack = work.pvind;
					else		% otherwise fake continue
				      		work.stepnum{work.pvind}=[work.stepnum{work.pvind} max(work.stepnum{work.pvind})+1];
					end
				      
					%disp('track skipped');
					work.expvarrev{work.pvind} = ones(1,def.reversalnum) * 0.12345678;
				      
					%afc_result;					% moved to main
					%work.writeresult =1;
				      
				% else part from allterminate
				else
				     for i = 1:def.interleavenum
				         work.trackfinished{i} = 1;                                         % was work.terminate before
				         work.finishedcount = work.finishedcount + 1;
				         work.removetrack = i;
				         %disp('track skipped');
				         work.expvarrev{i} = ones(1,def.reversalnum) * 0.12345678;
				     end
        end
        
        % SE 10.01.2012 13:22
				if ( strcmp( def.skippedMeasurementProcedure, 'constantStimuli' ) & work.skippedMPFlag == 0 )
						work.skippedMPFlag = 1;
				end
	      
        if ( work.skippedMPFlag == 0 )
						if ( ~def.allterminate | def.interleavenum < 2 )
							disp('track skipped');
						else
							disp('all tracks skipped');
						end 
				end
         
			      
			%%%%%%% track termination on maxiter %%%%%%%%%%%
			elseif work.stepnum{work.pvind}(end) > def.maxiter
				work.trackfinished{work.pvind} = 1;													% terminate on to many iterations
				work.finishedcount = work.finishedcount + 1;

				% changed 4/17/01 remove track if hold off
				if ~def.holdtrack 
					work.removetrack = work.pvind;
				else		% otherwise fake continue
					work.stepnum{work.pvind}=[work.stepnum{work.pvind} max(work.stepnum{work.pvind})+1];
				end
				
				disp(['track skipped: more than ' int2str(def.maxiter) ' iterations']);     
				work.expvarrev{work.pvind}=zeros(1,def.reversalnum) + 0.12345678; 	% dummy value indicating run termination
				  
				%afc_result;
			
			%%%%%%% go on (measurement phase reached) reversal %%%%%%%%%
			% new 16-03-2004 09:05 check for last index to def.varstep using work.tmp4, too.
			% this makes work.stepsize == def.varstep(end) unnecessary 
			elseif work.stepsize{work.pvind} == def.varstep{work.pvind}(end) & work.tmp4{work.pvind} >= length(def.varstep{work.pvind}) & work.measure{work.pvind} < def.reversalnum & abs(reversal) == 1
				work.measure{work.pvind}=work.measure{work.pvind}+1;
				
				if work.measure{work.pvind} == 1							% store stepnum
					work.reachedendstepsize{work.pvind} = work.stepnum{work.pvind}(end);
				end
				
				if work.measure{work.pvind} == 1 & def.feedback > 0 & def.interleaved == 0 & def.afcwinEnable > 0
					feval(def.afcwin, 'measure');
					%set(hm,'string',msg.measure_msg);
				end
				work.stepnum{work.pvind}=[work.stepnum{work.pvind} max(work.stepnum{work.pvind})+1];
				%set(h,'Userdata',-1);

			%%%%%%% track termination on reversalnum %%%%%%%%%
			elseif work.stepsize{work.pvind} == def.varstep{work.pvind}(end) & work.tmp4{work.pvind} >= length(def.varstep{work.pvind}) & work.measure{work.pvind} == def.reversalnum & abs(reversal) == 1
				work.trackfinished{work.pvind}=1;						% end of threshold run
				work.finishedcount = work.finishedcount + 1;
				  
				  % changed 4/17/01
				  work.reachedendreversalnum{work.pvind} = work.stepnum{work.pvind}(end);
				
				  % changed 4/17/01 remove track if hold off
				if ~def.holdtrack 
					work.removetrack = work.pvind;
				else		% otherwise fake continue
					work.stepnum{work.pvind}=[work.stepnum{work.pvind} max(work.stepnum{work.pvind})+1];
				end
				
				%afc_result;					% moved to main
				%work.writeresult =1;

	   		%%%%%%% go on %%%%%%%%
	   		else
	   			work.stepnum{work.pvind}=[work.stepnum{work.pvind} max(work.stepnum{work.pvind})+1];
				%set(h,'Userdata',-1);
		
			end
		end % if already terminated
	end % predict
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% WARNING TEST. NOT SUPPORTED %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% method of maximum likelyhood %%%%%%%%%%%%%%%%%%%%%%%%%
elseif ( strcmp(def.measurementProcedure, 'MML') )
	len=length(work.checktmp{work.pvind});
	
	% FIXME TEST
	
	% we need
	def.MML_MuInitial = -18;
	def.MML_SigmaInitial = 0.2;
	def.MML_MuMax = 0;
	def.MML_MuMin = -30;
	def.MML_SigmaMax = 0.5;
	def.MML_SigmaMin = 0.05;
	def.MML_InitialPsyfcnSteps = 8;
	def.MML_SigmaRandomRange = 1;
	
	% terminate on
	
	def.MML_MaxSteps = 50;
	% def.MML_MuChangeLimit
	def.MML_MuStdLimit = 0.5;
	def.MML_MuStdNum = 12;
	def.MML_TargetProb = 0.707;
	
	def.MML_SigmaInitialMinimize = 0.01;
	
	
	%----------------------- change expvar --------------------------------
	% SE 23.04.2013 16:32 moved up
	% work.expvar{work.pvind}=[work.expvar{work.pvind} work.expvarnext{work.pvind}];
	
	stdTmp = def.MML_MuStdLimit + 1;
	floorProb = 0;
	if ( def.intervalnum > 1 )
		floorProb = 1/def.intervalnum;
	end
	
	if ( 1 )%work.measure{work.pvind} > 0 )
		% Initial solution: always add one intervalnum positive and intervalnum-1 negative and 1 positive response to data
		
		expvarTmp = [work.expvar{work.pvind} ones(1,def.intervalnum)*def.MML_MuMin ones(1,def.intervalnum)*def.MML_MuMax];
		
		if ( def.intervalnum > 1 )
			correctTmp = [work.correct{work.pvind} zeros(1,def.intervalnum-1) ones(1,1) ones(1,def.intervalnum)];
		else
			correctTmp = [work.correct{work.pvind} zeros(1,def.intervalnum) ones(1,def.intervalnum)];
		end
		
		% TEST new estimate point with mml
		%[xfTmp,blaTmp,exitFlag] = fminsearch('mml_costfcn',[def.MML_MuInitial def.MML_SigmaInitialMinimize],[],work.expvar{work.pvind},work.correct{work.pvind},floorProb);
		
		[xfTmp,blaTmp,exitFlag] = fminsearch('mml_costfcn',[def.MML_MuInitial def.MML_SigmaInitialMinimize],[],expvarTmp,correctTmp,floorProb);
		
		
		if ( 0 & exitFlag )
			% check boundaries
			if (xfTmp(1) > def.MML_MuMax)
				xfTmp(1) = def.MML_MuMax;
			elseif (xfTmp(1) < def.MML_MuMin)
				xfTmp(1) = def.MML_MuMin;
			end
			
			if (xfTmp(2) > def.MML_SigmaMax)
				xfTmp(2) = def.MML_SigmaMax;
			elseif (xfTmp(2) < def.MML_SigmaMin)
				xfTmp(2) = def.MML_SigmaMin;
			end
		end
		
		if ( ~exitFlag )
			% use initial estimate
			xfTmp = [def.MML_MuInitial def.MML_SigmaInitial];
		else
			work.MML_MuEstimate{work.pvind}=[work.MML_MuEstimate{work.pvind} xfTmp(1)];
			work.MML_SigmaEstimate{work.pvind}=[work.MML_SigmaEstimate{work.pvind} xfTmp(2)];
		end
		
		if ( length(work.MML_MuEstimate{work.pvind}) > def.MML_MuStdNum )
			stdTmp = std(work.MML_MuEstimate{work.pvind}(end-def.MML_MuStdNum+1:end));
		end
	
	else
		% if we are not in measurement phase use initial psyfcn
		xfTmp = [def.MML_MuInitial def.MML_SigmaInitial];
	end
	
	
	work.tmp{work.pvind} = xfTmp;
	%xfTmp
	
	% new estimate point @ prob
	work.expvarnext{work.pvind} = mml_psyfcninv(def.MML_TargetProb,floorProb,xfTmp(1),xfTmp(2));
	
	% random variation
	dirTmp = 1;
	if rand > 0.5
		dirTmp = -1;
	end
	
	% currently the same independent of measurement phase or not
	if ( work.measure{work.pvind} > 0 )
		work.expvarnext{work.pvind} = work.expvarnext{work.pvind} + def.MML_SigmaRandomRange*dirTmp*1;%/xfTmp(2);
	else
		work.expvarnext{work.pvind} = work.expvarnext{work.pvind} + def.MML_SigmaRandomRange*dirTmp*4;%/1/xfTmp(2);
	end
	
	if work.expvarnext{work.pvind} > def.maxvar
		work.expvarnext{work.pvind} = def.maxvar;
		work.minmaxcount{work.pvind} = work.minmaxcount{work.pvind} + 1;
		if ( work.predict == 0 & def.afcwinEnable > 0 )
			feval(def.afcwin, 'maxvar');
			%set(hm,'string',msg.maxvar_msg);
		end
	elseif work.expvarnext{work.pvind} < def.minvar
		work.expvarnext{work.pvind} = def.minvar;
		work.minmaxcount{work.pvind} = work.minmaxcount{work.pvind} + 1;
		if ( work.predict == 0 & def.afcwinEnable > 0 )
	   		feval(def.afcwin, 'minvar');
	      		%set(hm,'string',msg.minvar_msg);
	   	end
	end

	%----------------------------------------------------------------------

	if ( def.debug == 1 & work.predict == 0 )			% for debugging
		work	
	end   
   
	%----------------------- experimental run -----------------------------
	if work.predict == 0   
		%%%%%%% track already terminated but was called again (due to interleaving) %%%%%%%%
		if work.trackfinished{work.pvind}==1	% undo changes in work
			%disp('kdgfsdlkgjösdgjösdgjösdg');
	      
			% changed 4/17/01 undo only if tracks are not to be continued
			if ~def.holdtrack
		      		work = worksave;
			else		% otherwise fake continue
		      		work.stepnum{work.pvind}=[work.stepnum{work.pvind} max(work.stepnum{work.pvind})+1];
		      	end
		else   
	   		%%%%%%% track termination on minmaxcount %%%%%%%%%
			if work.minmaxcount{work.pvind} * def.terminate >= def.endstop				
	      
	      			if ~def.allterminate
					work.trackfinished{work.pvind} = 1;						% was work.terminate before
					work.finishedcount = work.finishedcount + 1;
					
					% changed 4/17/01 remove track if hold off
					if ~def.holdtrack 
						work.removetrack = work.pvind;
					else		% otherwise fake continue
						work.stepnum{work.pvind}=[work.stepnum{work.pvind} max(work.stepnum{work.pvind})+1];
					end
					
					disp('track skipped');
					%work.expvarrev{work.pvind} = ones(1,def.reversalnum) * 0.12345678;
					work.MML_MuEstimate{work.pvind}=zeros(1,def.MML_MuStdNum) + 0.12345678; 	% dummy value indicating run termination
					work.MML_SigmaEstimate{work.pvind}=zeros(1,def.MML_MuStdNum) + 0.12345678;
					
					%afc_result;					% moved to main
					%work.writeresult =1;
									
				% else part from allterminate
				else
				     for i = 1:def.interleavenum
				         work.trackfinished{i} = 1;                                         % was work.terminate before
				         work.finishedcount = work.finishedcount + 1;
				         work.removetrack = i;
				         disp('track skipped');
				         work.expvarrev{i} = ones(1,def.reversalnum) * 0.12345678;
				     end
				end
			      
			%%%%%%% track termination on maxiter %%%%%%%%%%%
			elseif work.stepnum{work.pvind}(end) > def.maxiter
				work.trackfinished{work.pvind} = 1;													% terminate on to many iterations
				work.finishedcount = work.finishedcount + 1;

				% changed 4/17/01 remove track if hold off
				if ~def.holdtrack 
					work.removetrack = work.pvind;
				else		% otherwise fake continue
					work.stepnum{work.pvind}=[work.stepnum{work.pvind} max(work.stepnum{work.pvind})+1];
				end
				
				disp(['track skipped: more than ' int2str(def.maxiter) ' iterations']);     
				%work.expvarrev{work.pvind}=zeros(1,def.reversalnum) + 0.12345678; 	% dummy value indicating run termination
				 
				work.MML_MuEstimate{work.pvind}=zeros(1,def.MML_MuStdNum) + 0.12345678; 	% dummy value indicating run termination
				work.MML_SigmaEstimate{work.pvind}=zeros(1,def.MML_MuStdNum) + 0.12345678;
				%afc_result;
			
			%%%%%%% go on (measurement phase reached) %%%%%%%%%
			elseif ( work.stepnum{work.pvind}(end) == def.MML_InitialPsyfcnSteps )
				work.measure{work.pvind} = work.measure{work.pvind}+1;
				
				if work.measure{work.pvind} == 1							% store stepnum
					work.reachedendstepsize{work.pvind} = work.stepnum{work.pvind}(end);
				%	
				%	% new estimate point with mml
				%	[xfTmp,blaTmp,exitFlag] = fminsearch('mml_costfcn',[-6 1],[],work.expvar{work.pvind},work.correct{work.pvind},floorProb);
		%
		%			if ( exitFlag )
		%				work.expvarnext{work.pvind} = mml_psyfcninv(0.707,floorProb,xfTmp(1),xfTmp(1));
		%			end
				end
				
				if work.measure{work.pvind} == 1 & def.feedback > 0 & def.interleaved == 0 & def.afcwinEnable > 0
					feval(def.afcwin, 'measure');
					%set(hm,'string',msg.measure_msg);
				end
				work.stepnum{work.pvind}=[work.stepnum{work.pvind} max(work.stepnum{work.pvind})+1];
				%set(h,'Userdata',-1);
				
			%%%%%%% track termination on reversalnum %%%%%%%%%
			elseif ( stdTmp <= def.MML_MuStdLimit )
				work.trackfinished{work.pvind}=1;						% end of threshold run
				work.finishedcount = work.finishedcount + 1;
				  
				  % changed 4/17/01
				  work.reachedendreversalnum{work.pvind} = work.stepnum{work.pvind}(end);
				
				  % changed 4/17/01 remove track if hold off
				if ~def.holdtrack 
					work.removetrack = work.pvind;
				else		% otherwise fake continue
					work.stepnum{work.pvind}=[work.stepnum{work.pvind} max(work.stepnum{work.pvind})+1];
				end
				
				%afc_result;					% moved to main
				%work.writeresult =1;

	   		%%%%%%% go on %%%%%%%%
	   		else
	   			work.stepnum{work.pvind}=[work.stepnum{work.pvind} max(work.stepnum{work.pvind})+1];
				%set(h,'Userdata',-1);
		
			end
		end % if already terminated
	end % predict

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% WARNING TEST. NOT SUPPORTED %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% parameter estimation by sequential testing %%%%%%%%%%%%%%%%%%%%%%%%%
elseif ( strcmp(def.measurementProcedure, 'PEST') )
	len=length(work.checktmp{work.pvind});	% checktmp holds correct or wrong for same presentation level
		
	%def.PEST_RepeatLimit = 5;	% increase effective reversal number when the same level is presented
					% an integer number of times this constant (Perc.&Psychophys. Findley 1978)
	
	if ( def.PEST_RepeatLimit > 0)
		if ( len > 0 & mod(len,def.PEST_RepeatLimit) == 0 )
			work.tmp4{work.pvind} = work.tmp4{work.pvind}+1;
			%disp('increased effective n');
		end
	end
	
	stepdirection = 0;

	% compute probability
	correctTmp = sum(work.checktmp{work.pvind});
	
	%% TEST SE
	%if ( correctTmp > 2 )
	%	scaleTmp = 1/sqrt(len/2)
	%else 
		scaleTmp = 1;
	%end
	
	% Wald sequential likelyhood-ratio test
	if ( correctTmp >= ((def.PEST_TargetProbability * len) + def.PEST_WaldRange*scaleTmp) )
		% we have to reduce and reset checktmp
		stepdirection = -1;
	elseif ( correctTmp <= ((def.PEST_TargetProbability * len) - def.PEST_WaldRange*scaleTmp) )
		% we have to increase and reset checktmp
		stepdirection = 1;
	end
	
	if abs(stepdirection) == 1
		work.checktmp{work.pvind}=[];
	end
	%---------------------------------------------------------------------
	
	%----------------------- reversals of stepdirection ------------------------------------
	reversal = 0;
	
	if ( (stepdirection * work.tmp{work.pvind}) < 0 )	% stepdirection changed
		% store it
		work.tmp{work.pvind} = stepdirection;
		
		% reduce stepsize here, i.e., use the next varstep
		work.tmp4{work.pvind} = work.tmp4{work.pvind}+1;
		
		% indicate that stepsize wasnt doubled
		%work.PEST_DoubledTmp{work.pvind} = 0;
		
		reversal = stepdirection;	% -1 upper reversal
		
		% reset counter for steps in same direction
		work.tmp2{work.pvind} = 1;
		
	elseif ( (stepdirection * work.tmp{work.pvind}) > 0 )	% stepdirection unchanged
		% count how often
		work.tmp2{work.pvind}=work.tmp2{work.pvind}+1;
		
		% increase stepsize with the third step in the same direction if it was not increased before
		if ( work.tmp2{work.pvind} == 3 )
			% step where last reversal
			lastrevTmp = max(find(abs(work.reversal{work.pvind})));
			stepsTmp = find(abs(work.stepdirection{work.pvind}(1:lastrevTmp)));
			
			if ( work.PEST_DoubledTmp{work.pvind} > 0 )
				if ( work.PEST_DoubledTmp{work.pvind} == stepsTmp(end-1) )
					%disp(['prevented from doubling' num2str(work.stepnum{work.pvind}(end))]);
				else
					if ( work.tmp4{work.pvind} > 1 )
						work.tmp4{work.pvind} = work.tmp4{work.pvind}-1;
						
						% store the step when doubling actually occured
						work.PEST_DoubledTmp{work.pvind} = work.stepnum{work.pvind}(end);
						%work.stepnum{work.pvind}(end)
					end
			
				end
			elseif ( work.PEST_DoubledTmp{work.pvind} == 0 )
			 	% double anyhow
			 	if ( work.tmp4{work.pvind} > 1 )
					work.tmp4{work.pvind} = work.tmp4{work.pvind}-1;
					
					% store the step when doubling occured
					work.PEST_DoubledTmp{work.pvind} = work.stepnum{work.pvind}(end);
					%work.stepnum{work.pvind}(end)
				end
			
			end

		elseif ( work.tmp2{work.pvind} > 3 )
			if ( work.tmp4{work.pvind} > 1 )
				work.tmp4{work.pvind} = work.tmp4{work.pvind}-1;
				
				% store the step when doubling occured
				work.PEST_DoubledTmp{work.pvind} = work.stepnum{work.pvind}(end);
				%work.stepnum{work.pvind}(end)
			end
		end
	end
	
	if ( work.tmp{work.pvind} == 0 & abs(stepdirection) > 0 )
		% store it for the first time (work.tmp is initialized with 0)
		work.tmp{work.pvind} = stepdirection;
	end
		
	work.stepdirection{work.pvind} = [work.stepdirection{work.pvind} stepdirection];
	work.reversal{work.pvind} = [work.reversal{work.pvind} reversal];
	%----------------------------------------------------------------------

	%----------------------- change expvar --------------------------------
	if ( abs(stepdirection) )
   		work.stepsize{work.pvind} = def.varstep{work.pvind}(min(work.tmp4{work.pvind},length(def.varstep{work.pvind})));	% change stepsize  
		%disp(['redstep hit: stepsize' num2str(work.stepsize)]);   
	end
	%work.expvar{work.pvind}=[work.expvar{work.pvind} work.expvaract];
	%work.expvarnext{work.pvind}=work.expvaract + work.stepsize{work.pvind} * stepdirection;	% copied to expvaract in afc_interleave
	
	% SE 23.04.2013 16:31 moved up
	% work.expvar{work.pvind}=[work.expvar{work.pvind} work.expvarnext{work.pvind}];
	
	work.expvarnext{work.pvind}=work.expvarnext{work.pvind} + work.stepsize{work.pvind} * stepdirection;	% copied to expvaract in afc_interleave


	if work.expvarnext{work.pvind} > def.maxvar
		work.expvarnext{work.pvind} = def.maxvar;
		work.minmaxcount{work.pvind} = work.minmaxcount{work.pvind} + 1;
		if ( work.predict == 0 & def.afcwinEnable > 0 )
			feval(def.afcwin, 'maxvar');
			%set(hm,'string',msg.maxvar_msg);
		end
	elseif work.expvarnext{work.pvind} < def.minvar
		work.expvarnext{work.pvind} = def.minvar;
		work.minmaxcount{work.pvind} = work.minmaxcount{work.pvind} + 1;
		if ( work.predict == 0 & def.afcwinEnable > 0 )
	   		feval(def.afcwin, 'minvar');
	      		%set(hm,'string',msg.minvar_msg);
	   	end
	end
	%----------------------------------------------------------------------

	if ( def.debug == 1 & work.predict == 0 )			% for debugging
		work	
	end   
   
	%----------------------- experimental run -----------------------------
	if work.predict == 0   
		%%%%%%% track already terminated but was called again (due to interleaving) %%%%%%%%
		if work.trackfinished{work.pvind}==1	% undo changes in work
			%disp('kdgfsdlkgjösdgjösdgjösdg');
	      
			% changed 4/17/01 undo only if tracks are not to be continued
			if ~def.holdtrack
		      		work = worksave;
			else		% otherwise fake continue
		      		work.stepnum{work.pvind}=[work.stepnum{work.pvind} max(work.stepnum{work.pvind})+1];
		      	end
		else   
	   		%%%%%%% track termination on minmaxcount %%%%%%%%%
			if work.minmaxcount{work.pvind} * def.terminate >= def.endstop				
	      
	      			if ~def.allterminate
					work.trackfinished{work.pvind} = 1;						% was work.terminate before
					work.finishedcount = work.finishedcount + 1;
				      
					% changed 4/17/01 remove track if hold off
					if ~def.holdtrack 
				      		work.removetrack = work.pvind;
					else		% otherwise fake continue
				      		work.stepnum{work.pvind}=[work.stepnum{work.pvind} max(work.stepnum{work.pvind})+1];
					end
				      
					disp('track skipped');
					work.PEST_Expvar{work.pvind} = 0.12345678;
				      
					%afc_result;					% moved to main
					%work.writeresult =1;
			      
				% else part from allterminate
				else
				     for i = 1:def.interleavenum
				         work.trackfinished{i} = 1;                                         % was work.terminate before
				         work.finishedcount = work.finishedcount + 1;
				         work.removetrack = i;
				         disp('track skipped');
				         work.expvarrev{i} = ones(1,def.reversalnum) * 0.12345678;
				     end
				end
			      
			%%%%%%% track termination on maxiter %%%%%%%%%%%
			elseif work.stepnum{work.pvind}(end) > def.maxiter
				work.trackfinished{work.pvind} = 1;													% terminate on to many iterations
				work.finishedcount = work.finishedcount + 1;

				% changed 4/17/01 remove track if hold off
				if ~def.holdtrack 
					work.removetrack = work.pvind;
				else		% otherwise fake continue
					work.stepnum{work.pvind}=[work.stepnum{work.pvind} max(work.stepnum{work.pvind})+1];
				end
				
				disp(['track skipped: more than ' int2str(def.maxiter) ' iterations']);     
				work.PEST_Expvar{work.pvind} = 0.12345678; 	% dummy value indicating run termination
				  
				%afc_result;

			%%%%%%% track termination on endstepsize %%%%%%%%%
			elseif ( work.tmp4{work.pvind} == length(def.varstep{work.pvind}) ) 
				work.trackfinished{work.pvind}=1;						% end of threshold run
				work.finishedcount = work.finishedcount + 1;
				  
				work.PEST_Expvar{work.pvind} = work.expvarnext{work.pvind};
				
				  % changed 4/17/01 remove track if hold off
				if ~def.holdtrack 
					work.removetrack = work.pvind;
				else		% otherwise fake continue
					work.stepnum{work.pvind}=[work.stepnum{work.pvind} max(work.stepnum{work.pvind})+1];
				end
				
				%afc_result;					% moved to main
				%work.writeresult =1;

	   		%%%%%%% go on %%%%%%%%
	   		else
	   			work.stepnum{work.pvind}=[work.stepnum{work.pvind} max(work.stepnum{work.pvind})+1];
				%set(h,'Userdata',-1);
		
			end
		end % if already terminated
	end % predict

%%%%%%%%%%%%%%%%%%%%%%%% OFFICIALLY SUPPORTED constant stimuli %%%%%%%%%%%%%%%%%%%%%%%%%
elseif ( strcmp(def.measurementProcedure, 'constantStimuli') )

%----------------------- change expvar --------------------------------
	% SE 23.04.2013 16:32 moved up
	% work.expvar{work.pvind}=[work.expvar{work.pvind} work.expvarnext{work.pvind}];	

%----------------------------------------------------------------------

	if ( def.debug == 1 & work.predict == 0 )			% for debugging
   		work	
	end   
   
%----------------------- experimental run -----------------------------
	if work.predict == 0
   		%%%%%%% track already terminated but was called again (due to interleaving) %%%%%%%%
   		if work.trackfinished{work.pvind}==1	% undo changes in work
      			work = worksave;			
   		else      
	   		%%%%%%% track termination on expvargo %%%%%%%%%
			if work.stepnum{work.pvind}(end) == length(work.expvargo{work.pvind})
   				work.trackfinished{work.pvind} = 1;						% end of threshold run
      				work.finishedcount = work.finishedcount + 1;
      				work.removetrack = work.pvind;      
   			%%%%%%% go on %%%%%%%%
   			else
         			work.stepnum{work.pvind}=[work.stepnum{work.pvind} max(work.stepnum{work.pvind})+1];
				%set(h,'Userdata',-1);
				work.expvarnext{work.pvind}=work.expvargo{work.pvind}(work.indexgo{work.pvind}(work.stepnum{work.pvind}(end)));			% next expvar      
         
         			% indicate measurement phase
         			if work.stepnum{work.pvind}(end) == (sum(def.practicenum{work.pvind}) + 1) & def.feedback > 0 & def.interleaved == 0 & def.afcwinEnable > 0
            				feval(def.afcwin, 'measure');
  				end 
      			end
		end % if already terminated
	end % predict
	
%%%%%%%%%%%%%%%%%%%%%%%% custom procedure (see folder \procedures %%%%%%%%%%%%%%%%%%%%%%%%%
else
		% SE 10.04.2013 16:06 call custom procedure
		eval([def.measurementProcedure '_procedure']);	
    
end % end measurement procedure

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SE 26.06.2009 14:01
% SIAM Kaernbach ?
%
% SIUD from Declyse & Meddis 2009
%
% Modified SIUD incraese catch trial probability from 20 converging to 100% after each correct response
% If a catch trial results in false alarm, set the catch trial prob again to 60, and increase expvar one step up. If the a number of x false alarms during consecutive 
% catch trials appears terminate. If the catch trial is detected correcly do not change expvar and clear the flase alarm buffer.
% report the false alarm rate at the end
%
% Cued SIUD same as above with a preceeding reference interval.
%
% 2-Interval 4-Alternative
% Either none, the first, the second or both intervals hold the stimulus and these four alternatives can be the response. 
% Normal 1-up/1-down (guess rate is 25%), probably weighted as in Kaernbach weighted UD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if work.predict == 0

	if ( def.showEnable > 0 )
		afc_show('runUpdate');
	end
	
	% execute remote access file
	if ( def.remoteAccessEnable > 0 )
		if (exist('afc_remoteaccess') == 2)
			eval('afc_remoteaccess');	% calls remote access function if existing
		end
	end
	
	%%%%%%% check for end run %%%%%%%%%%%
	if def.interleaved > 0
		if work.finishedcount >= def.interleavenum
			work.terminate = 1;
			
			afc_result;
		else
			if ( def.afcwinEnable > 0 )
	      			set(h,'Userdata',-1);
			end
   	end
	else
     if work.finishedcount > 0
     			work.terminate = 1;
         		
         	afc_result;
     else
				if ( def.afcwinEnable > 0 )
         			set(h,'Userdata',-1);
				end
     end
  end   
end % end predict

% eof
