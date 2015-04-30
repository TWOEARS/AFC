% afc_main - alternative forced choice procedure -
%
% Usage: afc_main(experiment, subject, [userpar1, ..., userparN, condition], [key1, value1])
%
% experiment = string containing the name of the experiment to be performed
% subject    = string containing the name of the subject
% userpar(s) = optional string(s) containing user defined parameter(s)
% condition  = optional string containing experimental condition,
%              always the last optional argument after subject and before optional key1
% key1       = optional string 'runs', expects value1 as next argument
% value1     = optional integer following key1, number of runs before AFC stops
%
% example: afc_main('example','ab','cd1')
%          starts the experiment example for subject ab and condition 1.
%
%          The experiment is defined by the files
%          - example_cfg.m
%          - example_set.m
%          - example_user.m
%
% See also help afc, example_cfg, example_set, example_user
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

% last modified 16-07-2014 16:27, 1.40.0

function afc_main(varargin)

% figure out version 08.09.2005 15:00 now in main
mstr = version;
matlabVersion = str2num(mstr(1));
% SE need more details about the version but have to keep the upper integer version for downward compatability
% store it in matlabVersionRelease
% SE moved here 31.07.2014 and fixed 7.5.x to be 7.05 so that e.g. 7.13 is
% actually higher
numChar = findstr('.',mstr);
matlabVersionMinor = str2double(mstr(numChar(1)+1:numChar(2)-1));
if matlabVersionMinor > 9
    matlabVersionRelease = str2double(mstr(1:numChar(2)-1));
else
    matlabVersionRelease = matlabVersion + matlabVersionMinor/100;
end

% 22-07-2004 10:30 allow globals to be not cleared
global def
default_cfg;
clearGlobals = def.clearGlobals;
%clear def;
if size( clearGlobals, 2 ) == 1
    clearGlobals = repmat(clearGlobals, 1, 6);
elseif size( clearGlobals, 2 ) ~= 6
    error('afc_main: def.clearGlobals must be either 1 or 6 elements vector');
end

if ( clearGlobals(1) == 1 )
    clear global def
end

if ( clearGlobals(2) == 1 )
    clear global work
end

if ( clearGlobals(3) == 1 )
    clear global set
    clear global setup
end

if ( clearGlobals(4) == 1 )
    clear global msg
end

if ( clearGlobals(5) == 1 )
    clear global simdef
end

if ( clearGlobals(6) == 1 )
    clear global simwork
end

global def
global work
global msg
%global set
%
global simdef
%global simwork

% 31.05.2007 09:44
mainDef = [];
expname = [];
vpname = [];

if isempty(varargin)
    error('afc_main: no input argument');
elseif size(varargin,2) == 1
    % check for specific commands
    switch varargin{1}
        case 'about'
            mainDef.about = 1;
        case 'setup'
            mainDef.setup = 1;
        case 'version'
            mainDef.version = 1;
        otherwise
            error('afc_main: unknown input argument or unsufficient number of input arguments');
    end
elseif size(varargin,2) > 1
    % do the normal job
    mainDef.normalJob = 1;

    expname = varargin{1};
    vpname = varargin{2};

    if size(varargin,2) > 2
        varargin = varargin(3:end);
    else
        varargin = [];
    end
end

if size(varargin,2) > 0
    match = find(strcmp(varargin,'runs'));
    if size(match) > 1
        error('afc_main: unknown input argument or unsufficient number of input arguments');
    end

    if ~isempty( match )
        if match == size(varargin,2)
            error('afc_main: expected input argument for command ''runs''');
        end
    end

    if match
        mainDef.runs = varargin{match+1};
        varargin = varargin(1:match-1);
    end
end

% 01-02-2005 09:39
% new autoexec_cfg logic, read it, then copy to a temp structure (since the values might get cleared and update def later)
%filename = [fileparts(which('afc_main')), filesep, 'autoexec_cfg.m'];
if (~(exist('autoexec_cfg') == 2) | isfield(mainDef,'setup') )
    gui_localprefs;

    h = findobj('tag','gui_localprefs');
    uiwait(h);

    if isfield(mainDef,'setup')
        return;
    end
end

if (exist('autoexec_cfg') == 2)
    autoexec_cfg;
    deftmp = def;
else
    deftmp = [];
end

default_cfg;					% constructs structure def containing all fixed variables (default values)

if isfield(mainDef,'normalJob')
    eval([expname '_cfg']);				% overloades user defined values in structure def
end

if (exist([vpname '_cfg']) == 2)
    eval([vpname '_cfg']);			% adds some vp parameters to structure def
end

if (exist([expname '_sim_cfg']) == 2)
    eval([expname '_sim_cfg']);			% adds some simulation parameters to structure def
end

modelInit = 0;

if (exist([expname '_' vpname '_cfg']) == 2)
    eval([expname '_' vpname '_cfg']);	% constructs structure simdef containing all fixed model variables
end


% 01-02-2005 09:41, now cycle the deftmp and update values if they are not existing
if ( ~isempty(deftmp) )
    names = fieldnames(deftmp);
    for ( k = 1:size(names,1) )
        if ~isfield( def, names{k} )
            eval(['def.' names{k} '= deftmp.' names{k} ';']);
        end
    end
end
%

% if old-style _cfg completely overloaded def, add missing entries again
default_cfg;

% SE load config of custom procedure if existing 10.04.2013 12:09
if (exist([def.measurementProcedure '_cfg']) == 2)
    eval([def.measurementProcedure '_cfg']);			% adds some vp parameters to structure def
end


% use expname from afc_function call 11.02.2013 16:48
if ~isfield(def,'expname')
    def.expname = expname;				% name of experiment
end

%% version string
if ~isfield(def,'version')
    def.version = '1.40 build 1';
end

%% version date string
if ~isfield(def,'versionDate')
    def.versionDate = 'February 05, 2015';
end

% new about/version 31.05.2007 10:54
if ( isfield(mainDef,'about') )
    gui_splashscreen;
    return;
end

if ( isfield(mainDef,'version') )
    disp( [ 'afc_main: This is AFC ' def.version ', ' def.versionDate ] );
    return;
end

work.matlabVersion = matlabVersion;
work.matlabVersionRelease = matlabVersionRelease;

if ( (def.variableCheck > 0) | (def.debug > 0) ) % 26.10.2010 15:21
    afc_misc( 'checkDef' );		% looks for unrecognised entries
end

afc_misc( 'checkVersionIssues' );		% looks for version issues

% randomize randseed 04-05-2005 16:54
if ( def.randStateRandomize == 1 )
    rand('state',sum(100*clock));
    % 08.09.2005 14:42
    randn('state',sum(100*clock));
end

% different languages 08.10.2003
msgstr = 'default_EN_msg';			% make sure we have all entries in english at least
if (strcmp(def.messages,'autoSelect') == 1)
    if (exist([def.expname '_' def.language '_msg']) == 2)
        msgstr = [def.expname '_' def.language '_msg'];
    elseif (exist([def.expname '_msg']) == 2)
        msgstr = [def.expname '_msg'];
    elseif (exist([def.expname '_EN_msg']) == 2)
        msgstr = [def.expname '_EN_msg'];
    elseif (exist(['default_' def.language '_msg']) == 2)
        msgstr = ['default_' def.language '_msg'];
    end
elseif (exist([def.messages '_' def.language '_msg']) == 2)
    msgstr = [def.messages '_' def.language '_msg'];
elseif (exist([def.messages '_msg']) == 2)
    msgstr = [def.messages '_msg'];
elseif (exist([def.messages '_EN_msg']) == 2)
    msgstr = [def.messages '_EN_msg'];
end
eval(msgstr);					% gets messages

% make sure we have the english windetail messages at least
if ~isfield(msg,'experiment_windetail')
    msg.experiment_windetail = 'Experiment: %s';
end

if ~isfield(msg,'measurement_windetail')
    msg.measurement_windetail = 'Measurement %d of %d';
end

if ~isfield(msg,'measurementsleft_windetail')
    msg.measurementsleft_windetail = '%d of %d measurements left';
end

% 21-02-2006 14:25 changed a whole shitload of compatibility stuff for buttonstring
nobuttonString = 0;
if ( ~isfield(msg,'buttonString') )
    nobuttonString = 1;
end

if isfield(msg,'button1_buttonstring')
    warning('msg.button1_buttonstring should be replaced by msg.buttonString{1} in the _msg file');
    if ( nobuttonString )
        msg.buttonString{1} = msg.button1_buttonstring;
    end
end

if isfield(msg,'button2_buttonstring')
    warning('msg.button2_buttonstring should be replaced by msg.buttonString{2} in the _msg file');
    if ( nobuttonString )
        msg.buttonString{2} = msg.button2_buttonstring;
    end
end

% 08.09.2005 14:42 not required anymore FIXME REMOVE
if ~isfield(msg,'button1_buttonstring')
    msg.button1_buttonstring = 'Yes (1)';
end

if ~isfield(msg,'button2_buttonstring')
    msg.button2_buttonstring = 'No (2)';
end
%
% 21-02-2006 14:47 a bit dirty but always define at least four buttons (can't hurt)
numtmp = max(def.intervalnum,4);
if ( ~isfield(msg,'buttonString') )
    msg.buttonString = cellstr(num2str([1:numtmp]'))';
elseif ( isempty( msg.buttonString ) | (length(msg.buttonString) < numtmp) )
    % 21-02-2006 14:38 obviously we have more intervals then defined buttons, replace the not defined
    % buttons by numbers
    for ( idx=length(msg.buttonString)+1:numtmp )
        msg.buttonString{idx} = num2str(idx);
    end
end

% SE FIXME 19.04.2013 11:47 what is this needed for?
if ( def.debug > 0 )
    evalin('base','global work')
    evalin('base','global set')
    evalin('base','global setup')
    evalin('base','global def')
end

if ( def.debug > 1 )
    disp('debug: Running afc_main');
end

if ( def.modelEnable > 0 )
    disp( [ 'afc_main: This is AFC-simulation ' def.version ] );
end

%%%%%%%%%%% make fields in structure def %%%%%%%%%%%%%

%% overload oldstyle default savefcn dependent on procedure
if ( strcmp( def.savefcn, 'default' ) )
    if ( strcmp( def.measurementProcedure, 'transformedUpDown' ) )
        def.savefcn = 'adaptive_mean';
        %def.savefcn = 'adaptive_psyfcn';
        %def.savefcn = 'adaptive_median';
    elseif ( strcmp( def.measurementProcedure, 'PEST' ) )
        def.savefcn = 'pest';
    elseif ( strcmp( def.measurementProcedure, 'MML' ) )
        def.savefcn = 'mml';
    elseif ( strcmp( def.measurementProcedure, 'constantStimuli' ) )
        def.savefcn = 'cs_psyfcn';
    end
end

if def.loadafcext == 1 & ~isempty(def.afcextname)	% load extension pak
    eval([def.afcextname '_ext']);
end

% count exppars
def.expparnum = 0;
isf = 1;
while isf == 1
    def.expparnum = def.expparnum + 1;
    isf = feval('isfield',def,['exppar' num2str(def.expparnum + 1)]);
end
% end count

% interprete def.expcond as def.expparN if existing (same for expcondunits)
if isfield(def,'expcond')
    def.expparnum = def.expparnum + 1;
    eval(['def.exppar' num2str(def.expparnum) '=def.expcond;']);
    if isfield(def,'expcondunit')
        eval(['def.exppar' num2str(def.expparnum) 'unit =def.expcondunit;']);
    end
end
% end interprete

% check exppartype ( 0 = number, 1 = string) and fill missing unit fields
def.exppartype = [];
for i=1:def.expparnum
    eval(['isc = iscell(def.exppar' num2str(i) ');']);
    %eval(['isc = ischar(def.exppar' num2str(i) '(1,1));']);
    def.exppartype = [def.exppartype isc];
    field = ['exppar' num2str(i) 'unit'];
    if ~isfield(def,field)
        na = 'n/a';
        eval(['def.exppar' num2str(i) 'unit = na;']);
    end
    %
    % 22-03-2004 15:00 fill missing description fields
    field = ['exppar' num2str(i) 'description'];
    if ~isfield(def,field)
        na = 'n/a';
        eval(['def.exppar' num2str(i) 'description = na;']);
    end
end
% end check type

% from psy
% generate practicenum dummy if practice disabled
if def.practice == 0;
    def.practicenum = def.expvarnum * 0;
end
% end generate

% fix path bug
if ~isempty( def.result_path )
    if max( findstr( def.result_path, '\' )) ~= length( def.result_path )
        def.result_path = [def.result_path '\'];
    end
end
if ~isempty( def.control_path )
    if max( findstr( def.control_path, '\' )) ~= length( def.control_path )
        def.control_path = [def.control_path '\'];
    end
end

if ~isempty(def.stateLogPath )
    if max( findstr( def.stateLogPath, '\' )) ~= length( def.stateLogPath )
        def.stateLogPath = [def.stateLogPath '\'];
    end
end
% end fix bug

% overload def.interleavenum if def.interleaved == 0
if def.interleaved == 0
    def.interleavenum = 1;
end
% end overload

% change some fields in def to cell arrays and set them up for interleaved if enabled
if ~iscell(def.startvar)
    startvarTmp = def.startvar;
    def=rmfield(def,'startvar');

    if ( def.interleaved )
        if size( startvarTmp, 1 ) == 1
            startvarTmp = repmat(startvarTmp, def.interleavenum, 1);
        elseif size( startvarTmp, 1 ) ~= def.interleavenum
            error('afc_main: def.startvar dimensions mismatch def.interleavenum');
        end
    end

    for ( i=1:def.interleavenum )
        def.startvar{i} = startvarTmp(i,:);
    end
end
if ~iscell(def.rule)
    ruleTmp = def.rule;
    def=rmfield(def,'rule');

    if ( def.interleaved )
        if size( ruleTmp, 1 ) == 1
            ruleTmp = repmat(ruleTmp, def.interleavenum, 1);
        elseif size( ruleTmp, 1 ) ~= def.interleavenum
            error('afc_main: def.rule dimensions mismatch def.interleavenum');
        end
    end

    for ( i=1:def.interleavenum )
        def.rule{i} = ruleTmp(i,:);
    end
    
end
if ~iscell(def.steprule)
    stepruleTmp = def.steprule;
    def=rmfield(def,'steprule');

    if ( def.interleaved )
        if size( stepruleTmp, 1 ) == 1
            stepruleTmp = repmat(stepruleTmp, def.interleavenum, 1);
        elseif size( stepruleTmp, 1 ) ~= def.interleavenum
            error('afc_main: def.steprule dimensions mismatch def.interleavenum');
        end
    end

    for ( i=1:def.interleavenum )
        def.steprule{i} = stepruleTmp(i,:);
    end
    
end
if ~iscell(def.varstep)
    varstepTmp = def.varstep;
    def=rmfield(def,'varstep');

    if ( def.interleaved )
        if size( varstepTmp, 1 ) == 1
            varstepTmp = repmat(varstepTmp, def.interleavenum, 1);
        elseif size( varstepTmp, 1 ) ~= def.interleavenum
            error('afc_main: def.varstep dimensions mismatch def.interleavenum');
        end
    end

    for ( i=1:def.interleavenum )
        def.varstep{i} = varstepTmp(i,:);
    end
   
end
if ~iscell(def.expvarnum)
    expvarnumTmp = def.expvarnum;
    def=rmfield(def,'expvarnum');

    expvarCountTmp = size(def.expvar,2);
    if ( size(expvarnumTmp, 2) == 1 )
        % only one value for all expvar entries, we assume this means all expvar values have to be presented that often,
        % so expand to size of expvar
        expvarnumTmp = repmat(expvarnumTmp,1,expvarCountTmp);
    end

    if ( def.interleaved )
        if size( expvarnumTmp, 1 ) == 1
            expvarnumTmp = repmat(expvarnumTmp, def.interleavenum, 1);
        elseif size( expvarnumTmp, 1 ) ~= def.interleavenum
            error('afc_main: def.expvarnum dimensions mismatch def.interleavenum');
        end
    end

    for ( i=1:def.interleavenum )
        def.expvarnum{i} = expvarnumTmp(i,:);
    end
    
end
if ~iscell(def.practicenum)
    practicenumTmp = def.practicenum;
    def=rmfield(def,'practicenum');

    expvarCountTmp = size(def.expvar,2);
    if ( size(practicenumTmp, 2) == 1 )
        % only one value for all expvar entries, we assume this means all expvar values have to be presented that often,
        % so expand to size of expvar
        practicenumTmp = repmat(practicenumTmp,1,expvarCountTmp);
    end

    if ( def.interleaved )
        if size( practicenumTmp, 1 ) == 1
            practicenumTmp = repmat(practicenumTmp, def.interleavenum, 1);
        elseif size( practicenumTmp, 1 ) ~= def.interleavenum
            error('afc_main: def.practicenum dimensions mismatch def.interleavenum');
        end
    end

    for ( i=1:def.interleavenum )
        def.practicenum{i} = practicenumTmp(i,:);
    end
    
end
if ~iscell(def.expvarord)
    expvarordTmp = def.expvarord;
    def=rmfield(def,'expvarord');

    if ( def.interleaved )
        if size( expvarordTmp, 1 ) == 1
            expvarordTmp = repmat(expvarordTmp, def.interleavenum, 1);
        elseif size( expvarordTmp, 1 ) ~= def.interleavenum
            error('afc_main: def.expvarord dimensions mismatch def.interleavenum');
        end
    end

    for ( i=1:def.interleavenum )
        def.expvarord{i} = expvarordTmp(i,:);
    end
    
end
if ~iscell(def.expvar)
    expvarTmp = def.expvar;
    def=rmfield(def,'expvar');

    if ( def.interleaved )
        if size( expvarTmp, 1 ) == 1
            expvarTmp = repmat(expvarTmp, def.interleavenum, 1);
        elseif size( expvarTmp, 1 ) ~= def.interleavenum
            error('afc_main: def.expvar dimensions mismatch def.interleavenum');
        end
    end

    for ( i=1:def.interleavenum )
        def.expvar{i} = expvarTmp(i,:);
    end
    
end
% end change to cell

%%%%%%%%%% end make fields in def %%%%%%%%%%%%

abortall=0;

randseed = rand('state');

work = struct(		...								% initialize structure work
    'vpname',vpname,	...						% subject name from user input
    'userstr',[]);

work.randseed = randseed;
work.matlabVersion = matlabVersion; 	% 08.09.2005 15:01
work.matlabVersionRelease = matlabVersionRelease; 	% 19.04.2013 13:12

if isempty(varargin)
    work.condition = [];
else
    work.condition = varargin{end};			% condition from user input
end

if ( def.afcwinEnable > 0 )
    % SE 05.02.2015 delete already existing afc window first, just in case
    h=findobj('Tag','afc_win');
    delete(h);
    
    feval(def.afcwin, 'open');							% opens modal window
    h=findobj('Tag','afc_win');							% handle to window

    % 02-06-2005 11:44
    % MANDATORY for Matlab 7+
    % invisible focus dummy, afc_pressfcn sets the focus to this after a button was pressed.
    % keypressfcn is same as in afc_win.
    % probably move this to main, so the user doesnt need to take care of
    %h_dummy=uicontrol('Parent',h,'Visible','off','Tag','afc_focusdummy','KeyPressFcn',get(h,'KeyPressFcn'));

    % 08.09.2005 14:57 moved to main
    if ( matlabVersion > 6 )
        % 14.09.2006 10:43 the button has to be visible
        % converted it to tiny text box with background color of afc_win, must be activated to be able to execute callback
        uicontrol('Parent',h,'position',[-5 -5 0.01 0.01],'BackGroundColor',get(h,'Color'),'Visible','on','enable','on','style','text','Tag','afc_focusdummy','KeyPressFcn',get(h,'KeyPressFcn'));
    end

end

if ( def.showEnable > 0 )
    % SE 05.02.2015 delete already existing afc windows first, just in case
    afc_show('close');
    
    afc_show('open');
end

% ------making userpar fields in structure work----------
userparnum=length(varargin)-1;
if userparnum >= 1									% variable number of userpars from user input
    for i=1:userparnum
        eval(['work.userpar' num2str(i) '= varargin{i};']);
        work.userstr=[work.userstr '_' varargin{i}]; % string containing all userpars
    end
end
%-----------------------------------------------

%def.filename = '%S_%S_%E_%U[2-]_%U[1]_%C';
%def.fileNamingScheme = '%S_%E_%U[3-]_%U[2]_%C';

% define filename based on def 16-03-2005 16:08
if ( ~isempty( def.fileNamingScheme ) )

    fname = [];

    tmpfn = findstr( def.fileNamingScheme, '%');
    for (index=1:length(tmpfn))
        %index
        addfname = [];
        switch ( def.fileNamingScheme(tmpfn(index)+1))
            case 'E'
                addfname = def.expname;
            case 'S'
                addfname = work.vpname;
            case 'U'
                if ( userparnum >= 1 )
                    if ( def.fileNamingScheme(tmpfn(index)+2) == '[' )
                        use(1) = str2num(def.fileNamingScheme(tmpfn(index)+3));
                        use(2) = use(1);
                        if ( def.fileNamingScheme(tmpfn(index)+4) == '-' )
                            if ( def.fileNamingScheme(tmpfn(index)+5) == ']' )
                                use(2) = userparnum;
                            else
                                use(2) = str2num(def.fileNamingScheme(tmpfn(index)+5));
                                use(2) = min( use(2), userparnum );
                            end
                        end
                        useVec = use(1):use(2);

                        for ( index2 = 1:length(useVec) )
                            if ( useVec(index2) <= userparnum )
                                addfname = [addfname varargin{useVec(index2)}];
                                if ( index2 < length(useVec) )
                                    addfname = [addfname '_'];
                                end
                            end
                        end

                    else
                        addfname = work.userstr(2:end);
                    end
                end
            case 'C'
                addfname = work.condition;
            otherwise
                error('invalid filename')
        end

        fname = [fname addfname];

        if ( index < length(tmpfn) & ~isempty(addfname) )
            fname = [fname '_'];
        end
    end

    work.filename = fname;
else
    % old code
    % define the file name
    if isempty( work.condition )
        work.filename = [def.expname '_' work.vpname work.userstr];
    else
        work.filename = [def.expname '_' work.vpname work.userstr '_' work.condition];
    end
end

% calibration stuff
% new 16-03-2004 16:16
calstr = [];
eq = [];
eq2 = [];
def.calScriptEnable = 0;

if (strcmp(def.calScript,'autoSelect') == 1)
    % look for calScript named like condition
    if (exist([work.condition '_calibration']) == 2)
        calstr = [work.condition '_calibration' ];
    elseif (exist(['default_calibration']) == 2)
        calstr = ['default_calibration'];
    end
elseif (strcmp(def.calScript,'') ~= 1)
    if (exist([def.calScript '_calibration']) == 2)
        calstr = [def.calScript '_calibration'];
    else
        %warning('AFC:calibration','Calibration file in ''def.calScript'' not existing. Switching to default.');
        warning('Calibration file in ''def.calScript'' not existing. Switching to default.');
        calstr = ['default_calibration'];
    end
end

if ( ~isempty(calstr))
    eval(calstr);

    def.calScriptEnable = 1;

    if (strcmp(def.calTableEqualize,'fir') == 1)
        eq2 = afc_calsettings;
    end
end

% 12-03-2004 18:38 also replacing old headphoneeq internally
if (strcmp(def.calFirEqualizeFile,'') ~= 1)
    eval(['load ' def.calFirEqualizeFile]);
end

%1.00.1 initialize sound
if ( def.soundEnable > 0 )
    afc_sound('init');
end

% 0.94.4 se open hardware
if ( def.extern_hardware )
    feval(def.extern_hardware, 'open');
end

% check some existing paths
% check whether directory exists
if ( ~isempty(def.control_path) )
    if ( exist(def.control_path) ~= 7 )
        ans=questdlg(['def.control_path as specified in ' def.expname '_cfg.m does not exist. AFC will not run properly. Do you want to create it?'],'AFC - Requester');
        if (strcmp(ans, 'Yes') == 1)
            if min( findstr( def.control_path, ':' )) == 2
                mkdir(def.control_path(1:2), def.control_path(3:end));
            elseif min( findstr( def.control_path, '\' )) == 1
                d=pwd;
                mkdir(d(1:2), def.control_path);
            else
                mkdir(def.control_path);
            end
        end
    end
end

if ( ~isempty(def.result_path) )
    if ( exist(def.result_path) ~= 7 )
        ans=questdlg(['def.result_path as specified in ' def.expname '_cfg.m does not exist. AFC will not run properly. Do you want to create it?'],'AFC - Requester');
        if (strcmp(ans, 'Yes') == 1)
            if min( findstr( def.result_path, ':' )) == 2
                mkdir(def.result_path(1:2), def.result_path(3:end));
            elseif min( findstr( def.result_path, '\' )) == 1
                d=pwd;
                mkdir(d(1:2), def.result_path);
            else
                mkdir(def.result_path);
            end
        end
    end
end
% end of check paths


%%%%%%%%%%%%%%%%%%%% now get ready for the main working loop %%%%%%%%%%%%%%%%

% initilize or read control file
control = afc_savectr(0);												% calls afc_savectr as check/generate or load function

% setup some initial values in work
work.control = control;
work.bgloopwav_old = 'fake';
% new for remote
work.remoteupdateprevious = 0;
work.remoteupdate = 0;
work.terminate = 0;
% MATLAB 7 01-04-2005 09:55
work.abortall=0;
% 31.05.2007 11:00
if ( isfield(mainDef,'runs') )
    work.numrunMax = work.numrun + mainDef.runs-1;

    if ( work.numrunMax > size(work.control,1) )
        work.numrunMax = size(work.control,1);
    end
else
    work.numrunMax = size(work.control,1);
end
work.runsFinished = 0;

work.skippedMPFlag = 0;
work.skippedMP = def.measurementProcedure;


% splashscreen 19-10-2004 10:54
% SE FIXME? why deal with splashscreen here? 19.04.2013 12:00
if ( exist('localini.mat') == 2 )
    load localini;
else
    ini = 0;
end

if ( ini < 2 )
    stay = 1;
    work.splashscreenState = 1;

    if ( ini == 0 )	% first time
        count = 100;
    else
        count = 30;
    end

    gui_splashscreen;

    while ( stay > 0  )
        pause(0.2);
        stay = stay + 1;
        if ( isempty(findobj('Tag','gui_splashscreen')) )
            stay = 0;
        end
        if ( stay > count )
            stay = 0;
        end
    end

    if ( ~isempty(findobj('Tag','gui_splashscreen')))
        close(findobj('Tag','gui_splashscreen'));
    end
    ini = work.splashscreenState;
    % save MATLAB 4 compatible, so all 5,6,7 versions can read it
    save([fileparts(which(mfilename)), filesep, 'localini'],'ini','-V4');

    % SE 14.03.2008 14:52 only if afcwin is open
    if ( def.afcwinEnable > 0 )
        % SE 14.09.2006 16:00 give focus back to dummy
        if ( matlabVersion > 6 )
            uicontrol(findobj('Tag','afc_focusdummy'));
        end
    end
end
% end of splashscreen

%%%%%%%%%%%%%%%%%%%% now enter the main loop, looping after each finished run %%%%%%%%%%%%%%%%
% 01-04-2005 09:56 changed abortall to work.abortall
while ( work.numrun <= work.numrunMax & abortall == 0)	% changed 4/7/2000 checks whether experiment is already finished

    if ( def.afcwinEnable > 0 & ~work.skippedMPFlag )
        feval(def.afcwin, 'start_ready');
        %set(hm,'string',msg.start_msg);
        %set(h,'UserData',2);
        %set(ht1,'string',['experiment: ' def.expname '_' work.vpname work.userstr '_' work.condition]);	%set(ht2,'string',[int2str(length(control) - control(1)) ' of ' int2str(length(control)-1) ' measurements left']);

        %h=findobj('Tag','afc_win');
        %set(h,'UserData',2)

        if ( def.modelEnable > 0 )
            pause(1);
            %elseif ( def.remoteCloneEnable > 0 )
            %	pause(1);
        else
            waitfor(h,'UserData',0);
        end
    end

    % SE 16.10.2012 14:24 leave the loop early if abortall is set, because closing the window leads us here without the need to finish the loop
    % moreover afc_sound('bgloopwav_restart') is called without sound having been initialized before
    if ( work.abortall )
        break;
    end

    % SE 10.01.2012 11:39 reset skipped flag
    if ( work.skippedMPFlag )
        work.skippedMPFlag = 0;
    end


    if def.loadafcext == 1 & ~isempty(def.afcextname)
        eval([def.afcextname '_init']);							% extension pak initialization script
    end

    if ( def.afcwinEnable > 0 )
        feval(def.afcwin, 'start');
    end
    % removed 4/7/2000
    dat=date;

    %%%%%%%%% read exppars from work.control %%%%%%%%%
    switch def.interleaved
        case 0
            for i=1:def.expparnum												% get work.exppar1 ... N
                eval(['work.int_exppar' num2str(i) '{1} = control{work.numrun,i};']);
                eval(['work.exppar' num2str(i) '= work.int_exppar' num2str(i) '{' num2str(1) '};']);
            end
            work.exppar = work.exppar1;									% copy work.exppar1 to work.exppar, just for the good old times
            if def.expparnum > 1												% copy work.expparN to work.expcond
                eval(['work.expcond = work.exppar' num2str(def.expparnum) ';']);
            end
        case 1
            for i=1:def.expparnum
                for k=0:def.interleavenum - 1
                    m = def.expparnum * k + i;
                    eval(['work.int_exppar' num2str(i) '{' num2str(k + 1) '} = control{work.numrun,m};']);

                    % new 12/10/2003 this line was not here, why was it running?
                    % was correct! the set script must not use exppars in a interleaved run, cause they might
                    % not be the same across tracks. Set is only executed once and would only have on exppar set then.
                    % FIXME might check whether all exppars are the same and copy it here, so _set script has excess to it.
                    %eval(['work.exppar' num2str(i) '= work.int_exppar' num2str(i) '{' num2str(1) '};']);

                    %size(control)
                    %iscell(control)

                end
            end
    end
    %%%%%%%% end read %%%%%%%%%%

    % structure work containing all changible variables
    % most turned to cell arrays for interleaving 07/07/00

    % borrowed from psy
    %%%%%%%%%%% official procedure constantStimuli %%%%%%%%%%%%%%%%%
    if ( strcmp(def.measurementProcedure, 'constantStimuli') )

        for (k=1:def.interleavenum)	% don't take care of def.interleave because def.interleavenum is forced to 1 if interleave is disabled

            % expvar to go
            work.expvargo{k} = [];

            % construct vector expvargo containing all levels of expvar
            % practice trials
            for i = 1:length(def.expvar{k})
                if def.practicenum{k}(i) > 0
                    work.expvargo{k} = [work.expvargo{k} repmat(def.expvar{k}(i),1,def.practicenum{k}(i))];
                end
            end
            % measurement
            for i = 1:length(def.expvar{k})
                work.expvargo{k} = [work.expvargo{k} repmat(def.expvar{k}(i),1,def.expvarnum{k}(i))];
            end

            % construct randomized or ordered index to expvargo
            if ( def.expvarord{k} == 0 )
                work.indexgo{k} = [randperm(sum(def.practicenum{k})) (randperm(sum(def.expvarnum{k})) + sum(def.practicenum{k}))];
            elseif ( def.expvarord{k} == 1 )
                work.indexgo{k} = [1:(sum(def.practicenum{k})+ sum(def.expvarnum{k}))];
            end

            work.expvarnext{k} = work.expvargo{k}(work.indexgo{k}(1));
        end
		%%%%%%%%%%% official procedure transformedUpDown %%%%%%%%%%%%%%%%%
    elseif ( strcmp(def.measurementProcedure, 'transformedUpDown') )
        for (i=1:def.interleavenum)
            work.expvarnext{i} = def.startvar{i};				% pre buffer (cell array) for expvaract, copied to expvaract in afc_interleave
        end
		%%%%%%%%%%% NOT YET OFFICIALLY SUPPORTED procedure PEST %%%%%%%%%%%%%%%%%
    elseif ( strcmp(def.measurementProcedure, 'PEST') )
        for (i=1:def.interleavenum)
            work.expvarnext{i} = def.startvar{i};				% pre buffer (cell array) for expvaract, copied to expvaract in afc_interleave
        end
    %%%%%%%%%%% NOT YET OFFICIALLY SUPPORTED procedure MML %%%%%%%%%%%%%%%%%
    elseif ( strcmp(def.measurementProcedure, 'MML') )
        for (i=1:def.interleavenum)
            work.expvarnext{i} = def.startvar{i};				% pre buffer (cell array) for expvaract, copied to expvaract in afc_interleave
        end
    end
    
    %work.expvaract = def.startvar;					% actual value of expvar
    work.expvar{1} = [];							% vector containing previous values of expvar
    work.expname = def.expname;						% name of the experiment
    work.vpname = vpname;							% name of the subject
    %work.userpar1 = userpar;						% userpar from user input
    %work.condition = condition;					% condition from user input
    work.date = dat;								% date
    %work.exppar = work.exppar1;					% work.exppar is the same as work.exppar1: actual experimental parameter
    %work.control = control;						% number of experiment followed by a listing of exppars
    work.answer{1} = [];							% vector of user responses
    work.correct{1} = [];							% 1 if correct response
    work.stepdirection{1} = [];						% direction in which expvar is modified
    work.stepsize{1} = def.varstep{1}(1);			% size of stepping
    work.tmp{1} = 0;								%
    work.tmp2{1} = 0;                               %
    work.tmp3 = [];									%
    work.tmp4{1} = 1;								% index into def.varstep
    work.expvarrev{1} = [];							% expvar at all reversals
    work.predict = 0;								% used for predictive signal pregeneration (not implemented yet)
    work.checktmp{1} = [];							%
    work.reachedendstepsize{1} = [];				% step number when fineal step size was reached
    work.measure{1} = 0;							% measurement phase is reached
    work.reversal{1} = [];							% vector containing information about reversals
    work.stepnum{1} = 1;							% vector of steps during threshold run
    work.position{1} = [];							% position of the signal interval

    work.trackfinished{1} = 0;						% track # finished if 1
    work.finishedcount = 0;							% number of finished tracks
    work.removetrack = 0;							% if > 0 track # to remove from work.intremain

    work.terminate = 0;								% terminates inner threshold run loop if 1
    work.abortall = 0;								% aborts session if 1
    work.pvind = [];								% index to expvar/exppar for interleaving (defaults to 1)
    work.lastpvind = [];							% backup last pvind
    work.intremain = [1:def.interleavenum];         % remaining interleaved runs
    work.intblock = [];								% block of interleaved runs
    work.signal = [];								% all signals
    work.presig = [];								%
    work.postsig = [];								%
    work.pausesig = [];								%
    work.bgsig = [];								%
    work.currentsig = [];							%
    work.eq = eq;									% headphone EQ FIR coefficients
    work.eq2 = eq2;									% EQ FIR coefficients generated from calTable
    work.minmaxcount{1} = 0;						% counts min/maxvar hits

    work.prepositionc = [];							% signal position in pregenerated correct trial
    work.prepositionf = [];
    work.precorrect = [];
    work.prefalse = [];
    work.preexpvaractc = [];
    work.preexpvaractf = [];

    % new needed for model and pregen, omitted to save memory
    %work.presignalc = [];
    %work.presignalf = [];

    work.prepvind = [];									% for pregeneration
    work.prelastpvind = [];
    work.preintremain = [];
    work.preintblock = [];

    %work.lastpvindpro = [];
    %work.pvindpro = [];

    % new for PEST
    work.PEST_DoubledTmp{1} = 0;
    work.PEST_Expvar{1} = [];

    work.MML_MuEstimate{1} = [];
    work.MML_SigmaEstimate{1} = [];
    
    % SE added tracking of presentation order across interleaved tracks, according to Dirk Oettings suggestion 22.07.2013 11:30
    work.presentationOrder{1} = [];
    work.presentationCounter = 1;

    % expand fields for interleaving
    if ( def.interleaved > 0 )
        for i=2:def.interleavenum
            %	work.expvarnext{i} = work.expvarnext{1};		% startvar
            work.expvar{i} = work.expvar{1};
            work.answer{i} = work.answer{1};
            work.correct{i} = work.correct{1};
            work.stepdirection{i} = work.stepdirection{1};
            work.stepsize{i} = def.varstep{i}(1);
            work.tmp{i} = work.tmp{1};
            work.tmp2{i} = work.tmp2{1};
            work.tmp4{i} = work.tmp4{1};
            work.expvarrev{i} = work.expvarrev{1};
            work.checktmp{i} = work.checktmp{1};
            work.reachedendstepsize{i} = work.reachedendstepsize{1};
            work.measure{i} = work.measure{1};
            work.reversal{i} = work.reversal{1};
            work.stepnum{i} = work.stepnum{1};
            work.position{i} = work.position{1};
            work.trackfinished{i} = work.trackfinished{1};
            work.minmaxcount{i} = work.minmaxcount{1};

            % new for PEST
            work.PEST_DoubledTmp{i} = work.PEST_DoubledTmp{1};
            work.PEST_Expvar{i} = work.PEST_Expvar{1};

            work.MML_MuEstimate{i} = work.MML_MuEstimate{1};
            work.MML_SigmaEstimate{i} = work.MML_SigmaEstimate{1};
            
            work.presentationOrder{i} = work.presentationOrder{1};

        end
    end
    
    % SE custom procedure 10.04.2013 16:24
    if (exist([def.measurementProcedure '_init']) == 2)
    	eval([def.measurementProcedure '_init']);
    end
    % end of expanding fields for interleaving


    eval([def.expname '_set']);					% calls set-function of the experiment

    if ( def.modelEnable > 0 )
        % new 04-05-2004 13:47
        modelInit = 1;
        if (exist([expname '_' vpname '_cfg']) == 2)
            eval([expname '_' vpname '_cfg']);	% constructs structure simdef containing all fixed model variables
        end
        %

        eval([work.vpname '_init']);	% calls init-function of the model
    end

    if ( def.soundEnable > 0 & def.continuous > 0 )
        if ( ~strcmp(work.bgloopwav_old, def.bgloopwav) | def.bgloopwav_forcerestart )
            % SE 25.02.2013 19:24:38
            afc_getCurrentCalLevel;

            afc_sound('bgloopwav_restart');
        end
    end

    def.bgsiglen = def.presiglen+def.intervalnum*def.intervallen+(def.intervalnum-1)...
        *def.pauselen+def.postsiglen;					% computing length of the background signal

    % some default
    work.blockButtonTime = def.bgsiglen/def.samplerate+0.1;	% plus 0.1 sec safety margin;

    %terminate = 0;
    %%%%%%%%%%%%%%%%%%%% now enter the main working loop, looping during experimental run %%%%%%%%%%%%%%%%
    while ( work.terminate == 0 )						% loop for experimental run

        afc_work;

        % flush the event que 24-01-2006 13:57, this is the only way to end the while loop in some cases in MATLAB 7
        % It all worked fine untill 6.5.
        % This leads to inproper termination behaviour and double result writing to disk. Obviously the updating of the global work structure is flawed in MATLAB 7, probably in combination
        % with the waitfor() and the callbacks in between. Report this?
        drawnow;
        % end MATLAB 7 fix

    end
    %%%%%%%%%%%%%%%%%%%% end of main working loop  %%%%%%%%%%%%%%%%

    % execute remote access file
    if ( def.remoteAccessEnable > 0 )
        if (exist('afc_remoteaccess') == 2)
            eval('afc_remoteaccess');	% calls remote access function if existing
        end
    end

    control=afc_savectr(0);

    % calls afc_savectr as check/generate or load function
    abortall=work.abortall; %01-04-2005 09:53 DEBUG abortall is not updated in MATLAB 7, afc_work now returns on work.terminate or work.abortall ~= 0

end
%%%%%%%%%%%%%%%%%%%% end of main loop %%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%% shut down AFC %%%%%%%%%%%%%%%%
%
% if we got here, we want to shut down
%

% window or workspace messages
if ( def.afcwinEnable > 0 )
    if ( abortall == 1 )
        feval(def.afcwin, 'close');
    else
        feval(def.afcwin, 'finished');
    end
end

if ( def.showEnable > 0 )
    % r1400 COMMENT this only needs to close if abortall == 1, otherwise the
    % response window still waits for 'end' command and the show windows should stay
    % open. They are closed if the response window is closed. Overall, the
    % whole shutting down part could be reworked using an updated afc_close
    % in a easier understandable way
    if ( abortall == 1 )
        afc_show('close');
    end
end


if ( abortall == 0 & def.modelEnable > 0 )
    % r1400 if we had show enabled, we have to close the windows, it is not closed
    % before because abortall is 0 in this case
    if ( def.showEnable > 0 )
        afc_show('close');
    end

    disp('afc_main: experiment finished');
end

% 1.001
% FIXME: quit init using 'force'?
if ( def.soundEnable > 0 )
    afc_sound('close');
end

if ( def.stateLog > 0 )
    afc_statelog('close');
end

% 0.94.4 se close hardware
if ( def.extern_hardware )
    feval(def.extern_hardware, 'close');
end

% 05.11.2010 16:33 SE close the model
if ( def.modelEnable > 0 )
    if (exist([work.vpname '_close']) == 2)
        eval([work.vpname '_close']);	% calls model close function if existing
    end
end

% eof