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

function response = selftestIdentifyModel_main

% the model_main function must return the presentation interval selected by the model

global def
global work
global simwork

% we don't use the actual signals, we only detect the sine or the broadband noise in
% exampleIdentification
if ( any(work.expvaract == [1 4]) )
	detect = 1;
else 
	detect = 0;
end

%work.expvaract
%detect

% if detected than select the current signal position as the response interval, select a random one from the
% remaining intervals otherwise 
switch detect
    case 1
        response = work.correctResponse;
    case 0
        responseTmp = randperm( 4 );
        response = work.correctResponse;
        i = 1;
        while ( response == work.correctResponse )
            response = responseTmp(i);
            i = i + 1;
        end
end

%work.correctResponse
%response
%pause

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
