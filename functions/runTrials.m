function design = runTrials(design, datFile,  scr, visual, const)
% run experimental blocks

% hide cursor
HideCursor;

% preload important functions
Screen(scr.main, 'Flip');
GetSecs;
WaitSecs(.2);
FlushEvents('keyDown');

% create data fid
datFid = fopen(datFile, 'w');

% unify keynames for different operating systems
KbName('UnifyKeyNames');

for b = 1:design.nBlocks

    ntt = length(design.b(b).trial);

    % instructions
    systemFont = 'Arial'; % 'Courier';
    systemFontSize = 19;
    GeneralInstructions = ['Block ',num2str(b),' of ',num2str(design.nBlocks),'. \n\n',...
        'Press any key to start.'];
    Screen('TextSize', scr.main, systemFontSize);
    Screen('TextFont', scr.main, systemFont);
    Screen('FillRect', scr.main, visual.bgColor);

    DrawFormattedText(scr.main, GeneralInstructions, 'center', 'center', visual.fgColor,70);
    Screen('Flip', scr.main);

    SitNWait;

    t = 0;
    while t < ntt
        t = t + 1;
        td = design.b(b).trial(t);

        [data, sacRT] = runSingleTrial(td, scr, visual, const, design);

        dataStr = sprintf('%i\t%i\t%s\n',b,t,data); % print data to string

        fprintf(datFid,dataStr);                    % write data to datFile

        WaitSecs(design.iti);

        if const.saveMovie
            if t > const.nTrialMovie
                return
            end
        end

    end
end

fclose(datFid); % close datFile

Screen('FillRect', scr.main,visual.bgColor);
Screen(scr.main,'DrawText','Thanks, you have finished this part of the experiment.',100,100,visual.fgColor);
Screen(scr.main,'Flip');

ShowCursor;

waitsecs(1);
cleanScr;
