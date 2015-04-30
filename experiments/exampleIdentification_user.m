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

function exampleIdentification_user

global def
global work
global setup
global msg

% generate different types of stimulus
switch work.expvaract
	case 1
	% random phase tone
	tuser = ssin(def.intervallen,1000,-1,def.samplerate);
	case 2
	% 50-Hz wide noise
	tuser = bpnoise(def.intervallen,975,1025,def.samplerate);
	case 3
	% 1-octave noise
	tuser = bpnoise(def.intervallen,700,1400,def.samplerate);
	case 4
	% wide band noise
	tuser = bpnoise(def.intervallen,100,16000,def.samplerate);
end

% normalize to desired level
tuser = tuser/rms(tuser) * 10^((setup.level - work.currentCalLevel)/20);

% random permutation of the response buttons
randIndVec=randperm(4);

for idx=1:length(randIndVec)

	h=findobj('Tag',['afc_button' num2str(idx)]);
	set( h,'String', msg.buttonString{randIndVec(idx)} );
end

% store the correctResponse 
work.correctResponse = find(randIndVec==work.expvaract);

% apply Hanning windows
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