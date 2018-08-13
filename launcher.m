%%
%
% Probe estimated direction of peripheral double-drift targets
% - the pattern is ~1/f noise and not a sinusoidal grating
% - child-friendly task: only 50 trials, and allows to run a practice block with feedback
%
% Matteo Lisi, 2018

clear all;  clear mex;  clear functions;
addpath('functions/');

home;

%% general parameters
const.gammaLinear = 0; % use monitor linearization (need also to set the path below)
const.saveMovie   = 0;
const.nTrialMovie = 5;

% gamma calibration data folders path
const.gamma    = '../gammaCalibration/TabletCalData.mat';
const.gammaRGB = '../gammaCalibration/TabletCalDataRGB.mat';

% random number generator stream (r2010a default, different command for r2014a)
% this is needed only for matlab (where the random number generator start always at the same state)
% in octave the generator is initialized from /dev/urandom (if available) otherwise from CPU time,
% wall clock time, and the current fraction of a second.
% rng('shuffle');

%% participant informations
newFile = 0;

while ~newFile
    [vpcode] = getVpCode;

    % create data file
    datFile = sprintf('%s.mat',vpcode);

    % dir names
    subDir=substr(vpcode, 0, 4);
    sessionDir=substr(vpcode, 5, 2);
    resdir=sprintf('data/%s/%s',subDir,sessionDir);

    if exist(resdir,'file')==7
        o = input('      This directory exists already. Should I continue/overwrite it [y / n]? ','s');
        if strcmp(o,'y')
            newFile = 1;
            % delete files to be overwritten?
            if exist([resdir,'/',datFile])>0;                    delete([resdir,'/',datFile]); end
            if exist([resdir,'/',sprintf('%s.edf',vpcode)])>0;   delete([resdir,'/',sprintf('%s.edf',vpcode)]); end
            if exist([resdir,'/',sprintf('%s',vpcode)])>0;       delete([resdir,'/',sprintf('%s',vpcode)]); end
        end
    else
        newFile = 1;
        mkdir(resdir);
    end
end

practice = getAddInfo;
session = str2double(sessionDir);

% prepare screens
scr = prepScreen(const);

% prepare stimuli
visual = prepStim(scr, const);

% generate design
design = genDesign(visual, scr, const, practice);

% prepare movie
if const.saveMovie
    movieName = sprintf('%s.mov',vpcode);
    % use GSstreamer ?
    %Screen('Preference', 'DefaultVideocaptureEngine', 3)
    visual.imageRect = scr.rect;
    %const.moviePtr = Screen('CreateMovie', scr.main, movieName, scr.xres, scr.yres, 60, 'CodecSettings= Videoquality=1 EncodingQuality=1');
    const.moviePtr = Screen('CreateMovie', scr.main, movieName, scr.xres, scr.yres, 60);

end

% instructions
% systemFont = 'Arial'; % 'Courier';
% systemFontSize = 19;
% GeneralInstructions = ['Welcome to our experiment. \n\n',...
%     'Session ',actualSessStr,' (',num2str(as),' of ',num2str(design.totSession),').\n\n',...
%     'Your task is to...\n\n'...
%     'Press any key when ready to begin.'];
% Screen('TextSize', scr.main, systemFontSize);
% Screen('TextFont', scr.main, systemFont);
% Screen('FillRect', scr.main, visual.bgColor);
% DrawFormattedText(scr.main, GeneralInstructions, 'center', 'center', visual.fgColor,70);

istruImage1 = imread('instructions.png');
istru1 = Screen('MakeTexture', scr.main, istruImage1);
Screen('DrawTexture', scr.main, istru1, [], [], 0);
Screen('Flip', scr.main);

SitNWait;

Screen('Close',istru1);

try
    % runtrials
    design = runTrials(design,vpcode,scr,visual,const);
catch ME
    rethrow(ME);
end

% finalize movie?
if const.saveMovie
    Screen('FinalizeMovie', const.moviePtr);
end

% save updated design information
save(sprintf('%s.mat',vpcode),'design','visual','scr','const');

% sposto i risultati nella cartella corrispondente
movefile(datFile,resdir);
movefile(vpcode,resdir);
