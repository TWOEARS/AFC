% default_msg - default message definition file -
%
% ready_msg			displayed when ready for user response
% measure_msg		displayed when entering measurement phase
% correct_msg		displayed after correct response
% false_msg			displayed after false response
% maxvar_msg		displayed when maxvar is reached
% minvar_msg		displayed when minvar is reached
% start_msg			displayed when the experiment starts
% next_msg			displayed when the next parameter is presented
% finished_msg		displayed when the experiment is finished

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

% last modified 08-11-2006 11:12:02

msg=struct(...
'ready_msg','Bitte Taste drücken',		...
'measure_msg','Beginn der Meßphase',	...
'correct_msg','--- RICHTIG ---',			...
'false_msg','--- FALSCH ---',				...
'maxvar_msg','Obere Grenze erreicht',	...
'minvar_msg','Untere Grenze erreicht'	...
);

msg.start_msg    = {'Sie haben eine neue Messung', ...
                    'gestartet, drücken Sie eine', ...
                    'beliebige Taste zum Fortfahren.'};
msg.next_msg     = {'Sie haben die Messung', ...
                    'abgeschlossen, bitte drücken', ...
                    'Sie "s" um eine weitere', ...
                    'Messung durchzuführen', ...
                    'oder "e" zum Beenden'};
msg.finished_msg = {'Das Experiment ist abgeschlossen,', ...
                    'bitte drücken Sie "e" zum Beenden.'};

msg.experiment_windetail = 'Experiment: %s';
msg.measurement_windetail = 'Messdurchgang %d von %d';
msg.measurementsleft_windetail = '%d von %d Messdurchgängen übrig';

msg.buttonString = {};	% Cell array of strings to display on buttons 1 ... def.intervalnum. 
												% If empty or not defined, the interval number is displayed
												
msg.startButtonString = 's (Starten)';
msg.endButtonString = 'e (Beenden)';

% eof
