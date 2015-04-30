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

% last modified 08-11-2006 11:18:23

msg=struct(...
'ready_msg','Quel intervalle?',		...
'measure_msg','Début de la mesure',	...
'correct_msg','--- CORRECT ---',			...
'false_msg','--- FAUX ---',				...
'maxvar_msg','Niveau maximal atteint',	...
'minvar_msg','Niveau minimal atteint'	...
);

msg.start_msg    = {'Vous avez commencé une nouvelle mesure.', ...
                    'Appuyez sur une touche pour continuer.'};
msg.next_msg     = {'Fin de la mesure.', ...
                    'Appuyez sur "s" pour lancer une nouvelle mesure ou sur "e" pour terminer.'};
msg.finished_msg = {'Fin de l´expérience.', ...
                    'Appuyez sur "e" pour terminer.'};

msg.experiment_windetail = 'Expérience: %s';
msg.measurement_windetail = 'Mesure %d sur %d';
msg.measurementsleft_windetail = '%d mesures restantes sur %d';

msg.buttonString = {};	% Cell array of strings to display on buttons 1 ... def.intervalnum. 
												% If empty or not defined, the interval number is displayed

msg.startButtonString = 's (lancer)';
msg.endButtonString = 'e (terminer)';

% eof