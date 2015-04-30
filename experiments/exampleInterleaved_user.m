% example_user - stimulus generation function of experiment 'example' -
%
% This function is called by afc_main when starting
% the experiment 'example'. It generates the stimuli which
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
% See also help example_cfg, example_set, afc_main

function example_user

global def
global work
global setup

% 1000 ... 4000 Hz bandlimited Gaussian noise
% The experiment is meant to be 2-interval 2-alternative forced choice, so we need 2 signals.
tref1 = real(ifft(scut(fft(randn(def.intervallen,1)),1000,4000,def.samplerate)));
tuser = real(ifft(scut(fft(randn(def.intervallen,1)),1000,4000,def.samplerate)));

switch work.exppar3	% generate sinusoidal modulator
	case 8
	tuser = tuser .* (1 + ssin(def.intervallen,8,0,def.samplerate));
	case 16
	tuser = tuser .* (1 + ssin(def.intervallen,16,0,def.samplerate));
end

if work.exppar1 == 1	% exchange order of the stimulus being adjusted in level
	tmp = tuser;
	tuser = tref1;
	tref1 = tmp;
end

% normalize to rms = 1;
tuser = tuser/(rms(tuser));
tref1 = tref1/(rms(tref1));

% adjust level of the user signal
tuser = tuser * 10^((work.expvaract-work.currentCalLevel)/20);
tref1 = tref1 * 10^((setup.reflevel-work.currentCalLevel)/20);


% Hanning windows
tref1 = tref1 .* setup.window;
tuser = tuser .* setup.window;

% pre-, post- and pausesignals (all zeros)
presig = zeros(def.presiglen,2);
postsig = zeros(def.postsiglen,2);
pausesig = zeros(def.pauselen,2);

% make required fields in work
work.signal = [tuser tuser tref1 tref1];	% left = right (diotic) first two columns holds the test signal (left right)
work.presig = presig;											% must contain the presignal
work.postsig = postsig;											% must contain the postsignal
work.pausesig = pausesig;										% must contain the pausesignal

% eof