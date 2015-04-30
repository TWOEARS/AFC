
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

% v 1.40.0
% SE verified reference1-3 against afc1013beta from 2006 on Matlab
% 7.5.0/Win7 64-bit 30.07.2014
% reference4 is a new experiment in AFC 1.3+
%
% TODO also verify the exact order of stepsizes
% TODO add checksum test for all files

function afc_selftest

reference1 = [...
    8.0000  -22.5000    0.5000; ...
   16.0000  -22.5000    0.5000; ...
   ];

reference2 = [...
    1.0000         0   55.0000    8.0000   69.8333    0.8975; ...
    2.0000         0   85.0000    8.0000   70.0000    0.8165; ...
    3.0000         0   55.0000   16.0000   70.3333    0.7454; ...
    4.0000         0   85.0000   16.0000   70.5000    0.5000; ...
    5.0000    1.0000   55.0000    8.0000   70.1667    0.8975; ...
    6.0000    1.0000   85.0000    8.0000   70.0000    0.8165; ...
    7.0000    1.0000   55.0000   16.0000   70.0000    0.8165; ...
    8.0000    1.0000   85.0000   16.0000   70.0000    0.8165; ...
    1.0000         0   55.0000    8.0000   70.3333    0.7454; ...
    2.0000         0   85.0000    8.0000   69.5000    0.5000; ...
    3.0000         0   55.0000   16.0000   70.3333    0.7454; ...
    4.0000         0   85.0000   16.0000   70.3333    0.7454; ...
    5.0000    1.0000   55.0000    8.0000   70.5000    0.5000; ...
    6.0000    1.0000   85.0000    8.0000   70.0000    1.0000; ...
    7.0000    1.0000   55.0000   16.0000   70.0000    0.8165; ...
    8.0000    1.0000   85.0000   16.0000   70.1667    0.8975; ...
    1.0000         0   55.0000    8.0000   70.0000    0.8165; ...
    2.0000         0   85.0000    8.0000   70.0000    1.0000; ...
    3.0000         0   55.0000   16.0000   70.1667    0.8975; ...
    4.0000         0   85.0000   16.0000   69.8333    0.6872; ...
    5.0000    1.0000   55.0000    8.0000   69.6667    0.7454; ...
    6.0000    1.0000   85.0000    8.0000   69.8333    0.8975; ...
    7.0000    1.0000   55.0000   16.0000   70.1667    0.8975; ...
    8.0000    1.0000   85.0000   16.0000   69.6667    0.7454; ...
   ];

reference3 = [...
     1     1     8   -24     9     0; ...
     1     1     8   -20     9     0; ...
     1     1     8   -16     9     9; ...
     1     1     8   -12     9     9; ...
     1     1     8    -8     9     9; ...
     2     1    16   -24     9     0; ...
     2     1    16   -20     9     0; ...
     2     1    16   -16     9     9; ...
     2     1    16   -12     9     9; ...
     2     1    16    -8     9     9; ...
     ];
 
reference4 = [... 
      1     1     1     1     3     3; ...
     1     1     1     2     3     0; ...
     1     1     1     3     3     0; ...
     1     1     1     4     3     3; ...
     ];
 
 failCount = 0;
 
disp(' ');
disp('Welcome to AFC selftest.');
disp('A number of experiments will be performed by included models.');
%disp('A list of the results and the reference values is reported.');
disp('The selftest will indicate whether it was passed successfully.');
disp('Press any key to continue.');
pause

% example experiment with selftestAMModel
% check whether control and results exits and delete them
if ( exist('example_selftestAMModel_cd1.dat') == 2)
    delete(which('example_selftestAMModel_cd1.dat'));
end
if ( exist('control_example_selftestAMModel_cd1.dat') == 2)
    delete(which('control_example_selftestAMModel_cd1.dat'));
end

afc_main('example','selftestAMModel','cd1');
results1 = datread('example_selftestAMModel_cd1.dat');

if ( min(results1 == reference1) )
    disp('Passed.');
else
    disp('Failed.');
     failCount = failCount + 1;
end

% exampleInterleaved with selftestLevelModel
% check whether control and results exits and delete them
if ( exist('exampleInterleaved_selftestLevelModel_cd1.dat') == 2)
    delete(which('exampleInterleaved_selftestLevelModel_cd1.dat'));
end
if ( exist('control_exampleInterleaved_selftestLevelModel_cd1.dat') == 2)
    delete(which('control_exampleInterleaved_selftestLevelModel_cd1.dat'));
end

afc_main('exampleInterleaved','selftestLevelModel','cd1');
results2 = datread('exampleInterleaved_selftestLevelModel_cd1.dat');
m2 = mean(results2(:,5));

if ( min(results2(:,1:4) == reference2(:,1:4)) & (abs(m2-70) < 2) )
    disp('Passed.');
else
    disp('Failed.');
    failCount = failCount + 1;
end


% exampleConstantStimuli with selftestPsyfcnModel
% check whether control and results exits and delete them
if ( exist('exampleConstantStimuli_selftestPsyfcnModel_cd1.dat') == 2)
    delete(which('exampleConstantStimuli_selftestPsyfcnModel_cd1.dat'));
end
if ( exist('control_exampleConstantStimuli_selftestPsyfcnModel_cd1.dat') == 2)
    delete(which('control_exampleConstantStimuli_selftestPsyfcnModel_cd1.dat'));
end

afc_main('exampleConstantStimuli','selftestPsyfcnModel','cd1');
results3 = datread('exampleConstantStimuli_selftestPsyfcnModel_cd1.dat');

if ( min(results3 == reference3) )
    disp('Passed.');
else
    disp('Failed.');
    failCount = failCount + 1;
end


% exampleIdentification with selftestIdentifyModel
% check whether control and results exits and delete them
if ( exist('exampleIdentification_selftestIdentifyModel_cd1.dat') == 2)
    delete(which('exampleIdentification_selftestIdentifyModel_cd1.dat'));
end
if ( exist('control_exampleIdentification_selftestIdentifyModel_cd1.dat') == 2)
    delete(which('control_exampleIdentification_selftestIdentifyModel_cd1.dat'));
end

afc_main('exampleIdentification','selftestIdentifyModel','cd1');
results4 = datread('exampleIdentification_selftestIdentifyModel_cd1.dat');

if ( min(results4 == reference4) )
    disp('Passed.');
else
    disp('Failed.');
    failCount = failCount + 1;
end

% final result
disp(' ');
disp('AFC selftest is finished.');
if ( failCount == 0 )
    disp('All tests passed.');
else
    disp('WARNING: one or more tests failed.');
end


% eof