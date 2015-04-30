
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

% last modified 21-07-2014 10:47:14
% 07/01/04 -- se based on 27/08/03 -- jlv
% show signals during run of experiment

function afc_demo

disp(' ');
disp('Welcome to AFC demo. First the basic example experiment is started.');
disp('You should have sound output and the buttons are highlighted during playback.');
disp('Run a few trials or the whole experiment.');
disp('You can close the experiment response window at any time to continue with the next demo.');
disp('Press any key to continue.');
pause

afc_main('example','demo','cd1');

% FIXME iritating when the experiment was already finished
% disp(' ');
% disp('Next the example experiment will be perfomed by a computer model and the responses are shown.');
% disp('Press any key to continue')
% pause
% 
% afc_main('exampleCustomized','exampleModel','cd1');

disp(' ');
disp('Now the AFC selftest is performed');

afc_selftest;

disp(' ');
disp('The AFC demo is finished.');

% eof