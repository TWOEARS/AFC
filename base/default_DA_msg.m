% default_DA_msg - default danisch message definition file -
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

% last modified 08-11-2006 11:17:26

msg=struct(...
'ready_msg','Hvilket interval?',		...
'measure_msg','Starter måling',	...
'correct_msg','--- KORREKT ---',			...
'false_msg','--- FORKERT ---',				...
'maxvar_msg','Maksimum niveau nået',	...
'minvar_msg','Minimum niveau nået'	...
);

msg.start_msg    = {'Du har startet en ny måling.', ...
                    'Tryk en tast for at fortsætte.'};
msg.next_msg     = {'Omgang afsluttet.', ...
                    'Tryk "s" for at starte næste', ...
                    'måling eller "e" for exit.'};
msg.finished_msg = {'Eksperimentet er slut.', ...
                    'Tryk "e" for at forlade programmet.'};
                    
msg.buttonString = {};	% Cell array of strings to display on buttons 1 ... def.intervalnum. 
												% If empty or not defined, the interval number is displayed

msg.startButtonString = 's (starte)';
msg.endButtonString = 'e (exit)';

% eof
