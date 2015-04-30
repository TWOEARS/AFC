% revision 1.00.1 beta, 07/01/04

function response = exampleArtificialListener_main

% the model_main function must return the presentation interval selected by the model

global def
global work

% in this case the example model calls a detect routine for this, which returns 1 if the signal is detected.
detect = eval([work.vpname '_detect']);

% if detected than select the current signal position as the response interval, select a random one from the
% remaining intervals otherwise 
switch detect
case 1
	response = work.position{work.pvind}(end);
case 0
	responseTmp = randperm( def.intervalnum );
	response = work.position{work.pvind}(end);
	i = 1;
	while ( response == work.position{work.pvind}(end) )
   		response = responseTmp(i);
   		i = i + 1;
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
