% revision 1.00.1 beta, 07/01/04

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

function response = selftestPsyfcnModel_main

% the model_main function must return the presentation interval selected by the model

global def
global work
global simwork


if def.intervalnum > 1
	floorProb = 1/def.intervalnum;
else
	floorProb = 0;
end

value = mml_psyfcn( work.expvaract, floorProb, simwork.psyfcn50, simwork.psyfcnSlope );

if ( 0.5 < value )
	detect = 1;
else 
	detect = 0;
end

% if detected than select the current signal position as the response interval, select a random one from the
% remaining intervals otherwise 
switch detect
case 1
	response = work.position{work.pvind}(end);
case 0	
	if def.intervalnum > 1
		responseTmp = randperm( def.intervalnum );
		response = work.position{work.pvind}(end);
		i = 1;
		while ( response == work.position{work.pvind}(end) )
	   		response = responseTmp(i);
	   		i = i + 1;
	   	end
	else
		response = 2;
	end
end

% the model also displays some info in the matlab workspace window
% might also go to an extra function "example_display"

if ( def.modelDisplayEnable )
	if detect == 1		
	   	r = 'correct';															% correct response
	else
	   	r = 'false';																% false response
	end
	
	if ( work.stepnum{work.pvind}(end) == 1 )
		disp('starting new run ...');
	end
	
	disp(['step ' num2str(work.stepnum{work.pvind}(end)) '   ' r]);
end

% eof
