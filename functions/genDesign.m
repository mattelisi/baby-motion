function design = genDesign(visual,scr, practice)
%
% generate experiment design
%
% Matteo Lisi, 2014
%

%% display parameters
design.radius = 8;
design.fixJtStd = 0; % x-y std. if you want fixation point to vary from trial to trial

%% noise parameter
design.spatFreq = 5; %
design.tempFreq = 8; % it is actually speed [dva/sec], not temporal frequency

if practice
    % 0 is catch trials; the set is repeated 2*design.rep times
  design.internalMotion = [0 0 0 0 0 0 0 0 0 0 0 0 0];
else
  design.internalMotion = [0 1 1 1 1]; %
end
design.practice = practice;

design.envSpeed = 12; % deg/sec
design.sigma = 0.35;
design.contrast = 1;    % keep 1
design.textureSize = 6; % 8 times the sigma of the envelope, so you are sure it is not clipped at edges
design.nOctaves = 2;
design.control_f = 0.5; % determine physical temporal frequency of control trials relative to double-drift

%% motion par
design.envelDir = [1 -1]; % 1 = outward; -1 = inward
design.maxTime = [0.05 0.25];    % this is the duration of the stimulus
design.alphaJitterRange = [0 45]; % range for random (uniform) deviation from perfect radial trajectory in catch trials

design.movTime = design.maxTime/2; % this determine only the relative location of start position wrt mean path eccentricity (don't change it!)

%% timing
design.soa = [0 300];
design.iti = 0.1;
design.preRelease = scr.fd/3; % half or less of the monitor refresh interval
design.adjustSoa = 0.5;       % catch stimulus takes more to compute, this approximately makes the SoA equal

%% exp structure
design.nBlocks = 1;
if practice
    design.rep = 1;
else
    design.rep = 5;
end

%% trials list
t = 0;
for fp = design.tempFreq
for es = design.envSpeed
for r = 1:design.rep
for dur = design.maxTime
for ed = design.envelDir
for sf = design.spatFreq
for im = design.internalMotion
for ctrst = design.contrast

    t = t+1;

    % trial settings
    trial(t).alpha = rand*2*pi; % in radians
    trial(t).fixLoc = [scr.centerX scr.centerY] + round(randn(1,2)*design.fixJtStd*visual.ppd);
    trial(t).soa = (design.soa(1) + rand*design.soa(2))/1000;
    if fp > 0
        trial(t).soa = trial(t).soa + design.adjustSoa;
    end

    trial(t).envDir = ed;
    trial(t).driftDir = sign(randn(1)); % -1 = CW; 1 = CCW (direction of internal pattern relative to envelope displacement)
    trial(t).internalMotion = im;

    % target parameters
    trial(t).spatFreq = sf;
    trial(t).wavelength = 1/sf * visual.ppd;
    trial(t).tempFreq = fp;
    trial(t).envSpeed = es;
    trial(t).sigma = design.sigma;
    trial(t).contrast = ctrst;
    trial(t).nOctaves = design.nOctaves;
    trial(t).duration = dur;
    trial(t).movTime = dur/2;

end
end
end
end
end
end
end
end

design.totTrials = t;

% random order
r = randperm(design.totTrials);
trial = trial(r);

% generate blocks
design.blockOrder = 1:design.nBlocks;
design.nTrialsInBlock = design.totTrials/design.nBlocks;
beginB=1; endB=design.nTrialsInBlock;
for i = 1:design.nBlocks
    design.b(i).trial = trial(beginB:endB);
    beginB  = beginB + design.nTrialsInBlock;
    endB    = endB   + design.nTrialsInBlock;
end
