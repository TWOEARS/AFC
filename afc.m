%
% afc - top level function for alternative forced choice procedure -
%
% Usage: afc( commandName, [experiment/session], [subject], [userpar1, ..., userparN, condition], [key1, value1])
%
% commandName = string specifying mode of operation: 'help', 'about',
% 'setup', 'version', 'main', 'session', 'demo', 'selftest'
%
%	if commandName == 'main'
%
% experiment = string containing the name of the experiment to be performed
% subject    = string containing the name of the subject
% userpar(s) = optional string(s) containing user defined parameter(s)
% condition  = optional string containing experimental condition,
%              always the last optional argument after subject and before optional key1
% key1       = optional string 'runs', expects value1 as next argument
% value1     = optional integer following key1, number of runs before AFC stops
%
% example: afc('main','example','ab','cd1')
%          starts the experiment example for subject ab and condition 1. 
%
%	if commandName == 'session'
%
% session = string containing the name of the session to be performed
%
% example: afc('session','example')
%          starts the session defined in ASCII file session_example.dat
%
%   other commandNames
%'help'      opens this help
%'setup'     opens configuration window
%'about'     opens about window
%'demo'      starts demo
%'selftest'  starts selftest
%'version'   displays version
%
% See also help afc_main, afc_session, example_cfg, example_set, example_user
%

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

% last modified 19-04-2013 13:02:51
% $Revision: 1.20.0 beta$  $Date: 06.06.2011 13:41 $

function afc(varargin)

% figure out version
%mstr = version;
%matlabVersion = str2num(mstr(1));

if ( isempty(varargin) | strcmp( varargin{1}, 'help' ) )
    % r1400 remove about evalin('base','help afc; afc(''about'');');
    evalin('base','help afc;');
    return;
end

% add the path
afc_addpath;

switch varargin{1}
    case {'main', 'run', 'runMain'}
        if ( size(varargin, 2) < 3 )
            error('afc: experimentName and subjectName expected');
        end
        afc_main(varargin{2:end});
    case 'about'
        afc_main('about');
    case 'version'
        afc_main('version');
    case 'setup'
        afc_main('setup');
    case {'session', 'runSession'}
        if ( size(varargin, 2) < 2 )
            error('afc: sessionName expected');
        end
        afc_session(varargin{2:end});
    case 'demo'
        afc_demo;
    case 'selftest'
        afc_selftest;
    otherwise
        error(['afc: Unknown command ' varargin{1}]);
end

% eof