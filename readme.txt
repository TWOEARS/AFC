
=================================================
AFC SOFTWARE PACKAGE FOR MATHWORKS MATLAB
=================================================

AFC - A modular framework for running psychoacoustic experiments and computational perception models

Version 1.40 Build 0

Copyright (c) 1999 - 2014 Stephan Ewert. All rights reserved. 

Author:
Stephan Ewert
email: stephan.ewert@uni-oldenburg.de
web:   www.aforcedchoice.com

==================================================================
What's in the distribution?
==================================================================

This distribution adds an user-configurable framework for performing
psychoacoustic experiments and computational perception models to your
Matlab installation.
Example experiments and models are included.

Included Files
--------------
ADDONS/AFC_REMOTEACCES.M   - Let Operator gain remote access to running measurent 
BASE/*.M                   - AFC core files *
CALIBRATION/*M        - Files and examples for calibration
DOCS/*.TXT            - Documentation
EXPERIMENTS/*.M       - Collection of example experiments
GUI/*.*               - Graphical user interface
MODELS/*.M            - Collection of example models
PROCEDURES/*.M        - Custom measurement procedures
SCRIPTS/*.M           - Supplementary scripts
SESSIONS/*.DAT        - Session files
SOUNDMEXPRO/*.*       - SoundMexPro files
AFC_HELP.PDF          - Detailed documentation
CHANGES.TXT           - List of changes and bug fixes
DISCLAIMER.TXT        - Disclaimer of warranties and limitation on liability
LICENSE.TXT           - Product license
PRODUCT.TXT           - Product information
README.TXT            - This file

* These files are required to run the afc procedure and must not be changed as also not permitted
by AFC's license. Changes might moreover harm proper function of this distribution.

==================================================================
License & permissions
==================================================================

Unless otherwise stated, the AFC distribution, including all files is licensed 
under Creative Commons Attribution-NonCommercial-NoDerivs 4.0 International (CC BY-NC-ND 4.0). 
In short, this means that you are free to use and share (copy, distribute and transmit) 
the AFC distribution under the following conditions:

 Attribution - You must attribute the AFC distribution by acknowledgement of the author 
               if it appears or if was used in any form in your work. The attribution must 
               not in any way that suggests that the author endorse you or your use of the work.

 Noncommercial - You may not use AFC for commercial purposes.
 
 No Derivative Works - You may not alter, transform, or build upon AFC.

The experiment files, model files, calibration files, and measurements procedure files, 
their interfaces and their structure, as defined by the included examples, 
are licensed under Creative Commons Attribution 4.0 International (CC BY 4.0).

Users are thus explicitly permitted to create custom experiments, models, calibration files, 
and measurements procedures or to derive them from included examples, and to distribute their 
own creations independent of AFC provided they are attributed as custom content for AFC 
and acknowledge the original author.

See also license.txt

==================================================================
Installation
==================================================================

Requirements
------------

- Windows 95/98, Windows NT/2000/XP/Vista/7/8, or MAC OSX, or Linux
- Mathwork's MATLAB Version 5.0 or higher
- Sound device

Installation
------------

- Unzip all included files to your Matlab directory.
  This will create the subdirectory afc/ containing the referenced
  files and folders.
  
- If you want to use SoundMexPro unpack the included archive in the folder
  soundmexpro, for details and the license see soundmexpro4afc.txt.

- Optionally include AFC's subfolder to your Matlab search path,
	can be temporally done by using the afc_addpath command.

==================================================================
Getting Started
==================================================================

In the following introduction it is assumed that you are familar
with adaptive forced-choice tasks.

Starting the included example measurement
-----------------------------------------

This distribution comes with a number of example measurement which can be
used as a guideline for designing own experiments.
How to start the basic example experiment (experiments/example_*.m) is decribed here.
The example experiment estimates the modulation detection threshold 
for a 8- and 16-Hz sinusoidal amplitude modulation applied to a
broadband Gaussian noise carrier.
An adaptive 3-interval 3-AFC method (1-up-2-down rule) is used.

The measurement is started with the command:

afc('main','example','subject','condition');

or

afc_main('example','subject','condition');

in the matlab workspace. If afc_main is used afc_addpath has to be run first or
AFC's folder were added to Matlab's search path beforehand.
'example' is the name of the included
example experiment, 'subject' may be 'se' for Stephan Ewert and
'condition' can be 'cd1' or 'cd2'. With these both conditions the
same experiment is performed at two different overall stimulus
levels (With 'cd2' the overall level is 12 dB lower than with 'cd1').

The function afc_main opens a modal measurement window during the run of the experiment.
Instructions are displayed guiding you to the experiment.  
Please follow the instructions by pressing the number of
the interval in which the amplitude modulation was presented on your keyboard.
After finishing a run, the measurement procedure can be restarted by pressing the 's'
button on your keyboard and can be finished by pressing the 'e' button.

After two threshold runs the measurement is completely finished and cannot be
restarted one more time. Please press 'e' to end the session.

View the results
----------------

The ASCII file 'example_subject_cd1.dat' in the current directory (use pwd command in Matlab)
contains the measurement results. Typically this might be the Matlab standard working
directory (e.g., matlab/work/, matlab/bin/). 

==================================================================
The Example Experiment
==================================================================

The example experiment is defined by the three following m-files:
(Use the Matlab Editor or another appropriate application to open the files.)

EXAMPLE_CFG.M  - This file contains the configuration of the experiment.
	         Here the number of intervals, the length of
		 the stimuli, ... are defined.

EXAMPLE_SET.M  - Here condition dependent variables are defined and stimuli
	         that do not change during a single threshold run are pre-generated.

EXAMPLE_USER.M - The stimuli which are presented and are changed in the consecutive
                 presentation intervals of a threshold run are generated here.

When starting the experiment the first time an ASCII control file
'control_example_subject_condition.dat' is automatically written
to Matlab's standard working directory (the path is defined by
'control_path' in example_cfg). Below two comment lines the first integer entry in this file
is the current run number of the experiment. This counter is incremented after finishing a run.
The entries below are listing the parameters (defined by the exppar(s) in example_cfg)
for which the experiment is performed (top-bottom order).
In the example experiment 'exppar1' has a value of 8 and 16 (repeated 1 time as defined
by 'repeatnum' in example_cfg). Both values of the parameter are presented in random order
('parrand' = 1 in example_cfg). The control file might be edited by the user to repeat
'exppar1' = 8 a further time or to add 'exppar1' = 32.

The measurement results are saved as an ASCII file 'example_subject_condition.dat'
in Matlab's standard working directory (the path is defined by 'result_path' in example_cfg).

Additional help is provided in afc_main.m, example_cfg.m, example_set.m, example_user.m.

==================================================================
The Example Experiment and Example Model
==================================================================

The folders experiments/ and models/ hold a number of different example experiment and models using
a variety of features. You can run the example experiment with a model instead of a human subject.

Use the command:

afc_main('example','exampleModel','cd1');

In this case the configuration file 'exampleModel_cfg.m' tells the procedure that the subject
'exampleModel' is a model and does not need a response box. Please browse to the respective m-files
for more information. Generally the configuration file 'subjectname_cfg' can be used for any subject
independent whether human or model for subject dependent configurations. In case of human subjects this
might be the language setting of the response box (e.g. def.language = DE for german).

Please have a look at the other examples and models to become familiar with AFC.

Further documentation is provided in AFC_help.pdf
