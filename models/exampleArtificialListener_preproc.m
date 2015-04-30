% revision 1.00.1 beta, 07/01/04

function out = exampleArtificialListener_preproc(in)

global def
global work
global simwork

% this is the Viemeister JASA 1979 leaky-integrator model


% 4-6 kHz four-pole Butterworth Bandpass (missing)

% halfwave rectification
tmp = max(in,0);

% first-order lowpass filter @ 65 Hz
tmp = filter(simwork.lp_b, simwork.lp_a, tmp);

% ac-coupled rms = std
out = std(tmp,1);

% that's it
% eof
