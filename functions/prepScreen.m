function scr = prepScreen(const)
%
% screen settings - double-drift with noise targets
%
% Matteo Lisi, 2014
%

HideCursor;

scr.subDist = 120;   % subject distance (cm)
scr.colDept = 32;
scr.width   = 1375;  % monitor width (mm)

% If there are multiple displays guess that one without the menu bar is the
% best choice.  Dislay 0 has the menu bar.
scr.allScreens = Screen('Screens');
scr.expScreen  = max(scr.allScreens);

% get rid of PsychtoolBox Welcome screen
%Screen('Preference', 'VisualDebugLevel',3);

Screen('Preference', 'SkipSyncTests', 1);

% set resolution
%Screen('Resolution', scr.expScreen, 1600, 900);
%Screen('Resolution', scr.expScreen, 1360, 768);

% Open a window.  Note the new argument to OpenWindow with value 2, specifying the number of buffers to the onscreen window.
[scr.main,scr.rect] = Screen('OpenWindow',scr.expScreen, [0.5 0.5 0.5],[0 0 2400 1350],scr.colDept,2);

Screen('BlendFunction',scr.main, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

% get information about  screen
[scr.xres, scr.yres]    = Screen('WindowSize', scr.main);       % heigth and width of screen [pix]

% determine th main window's center
[scr.centerX, scr.centerY] = WindowCenter(scr.main);

% refresh duration
scr.fd = Screen('GetFlipInterval',scr.main);    % frame duration [s]

% Give the display a moment to recover from the change of display mode when
% opening a window. It takes some monitors and LCD scan converters a few seconds to resync.
WaitSecs(2);