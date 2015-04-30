% exampleConstantStimuli_user - stimulus generation function of experiment 'exampleConstantStimuli' -
%
% This function is called by afc_main when starting
% the experiment 'exampleConstantStimuli'. It generates the stimuli which
% are presented during the experiment.
% The stimuli must be elements of the structure 'work' as follows:
%
% work.signal = def.intervallen by 2 times def.intervalnum matrix.
%               The first two columns must contain the test signal
%               (column 1 = left, column 2 = right) ...
% 
% work.presig = def.presiglen by 2 matrix.
%               The pre-signal. 
%               (column 1 = left, column 2 = right).
%
% work.postsig = def.postsiglen by 2 matrix.
%                The post-signal. 
%               ( column 1 = left, column 2 = right).
%
% work.pausesig = def.pausesiglen by 2 matrix.
%                 The pause-signal. 
%                 (column 1 = left, column 2 = right).
% 
% To design an own experiment, e.g., 'myexperiment',
% make changes in this file and save it as 'myexperiment_user.m'.
% Ensure that the referenced elements of structure 'work' are existing.
%
% See also help exampleConstantStimuli_cfg, exampleConstantStimuli_set, afc_main

function exampleConstantStimuli_user

global def
global work
global setup


% 1000 ... 4000 Hz bandlimited modulated Gaussian noise 
% The experiment is meant to be 1-interval 2-alternative forced choice, so we need only 1 signal.
% work.expvaract holds the current value of the tracking variable of the experiment.

tuser = real(ifft(scut(fft(randn(def.intervallen,1)),1000,4000,def.samplerate))) * 10^((setup.level - work.currentCalLevel)/20) .* ... // holds the target signal
   (1 + (10^(work.expvaract/20) * setup.modsine));

% Hanning windows

tuser = tuser .* setup.window;

% pre-, post- and pausesignals (all zeros here)

presig = zeros(def.presiglen,2);
postsig = zeros(def.postsiglen,2);
pausesig = zeros(def.pauselen,2);

% make required fields in work

work.signal = [tuser tuser];	% left = right (diotic) first two columns holds the test signal (left right)
work.presig = presig;											% must contain the presignal
work.postsig = postsig;											% must contain the postsignal
work.pausesig = pausesig;										% must contain the pausesignal

% eof