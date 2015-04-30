% revision 1.00.1 beta, 07/01/04

function exampleModel_init

% this file is used to initialize model parameters

global def
global work
global simwork

% the example model is so simple, there is not much to initialize.
% Some filter coefficients used in example_preproc

% 4-6 kHz four-pole Butterworth Bandpass (missing)

% first-order lowpass filter @ 65 Hz
[simwork.lp_b,simwork.lp_a] = folp(65,def.samplerate);

%eof
