
td = design.b(1).trial(1)
step = visual.ppd*(td.tempFreq*scr.fd) * design.control_f
nFrames = round(design.maxTime/scr.fd)
tsize = 58;
noiseimg = (255*fractionalNoise3(zeros(tsize, tsize, nFrames), td.wavelength, td.nOctaves, step)) -visual.bgColor;
