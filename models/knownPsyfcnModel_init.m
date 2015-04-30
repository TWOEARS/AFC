% revision 1.00.1 beta, 07/01/04

function knownPsyfcnModel_init

% this file is used to initialize model parameters

global def
global work
global simwork

% the example model is so simple, there is not much to initialize.
% Some filter coefficients used in example_preproc


% define 50% point
simwork.psyfcn50 = -18;
simwork.psyfcnSlope = 0.1;%0.25;
% should result in -17.55 for 1up 2down 3 interval

%eof
