clear all
clc

regen = 0;
ppi = 500;
ntrainingsamples = 25;
ntestsamples = 100;

imgFov = [6 6]/60; % visual angle (degree)
nFrames = 1000;  % Number of samples

vDist  = 1.0;                                   % viewing distance (meter)
vDistMin = 0.1;
vDistMax = 10;
fracCorrect = 0;
eps = .05;
test_temp = 1;

% while abs(fracCorrect - .75) > eps
while test_temp == 1
    imgSz  = round(tand(imgFov)*vDist*39.37*ppi);   % number of pixels in image
    imgFov = atand(max(imgSz)/ppi/39.37/vDist);     % Actual fov
    
    % Create virtual display
    display = displayCreate('LCD-Apple');
    display = displaySet(display, 'dpi', ppi);
    
    if regen
        [aname,mname] = make_scenes(imgSz);
    else
        aname = 'scene_a.png';
        mname = 'scene_m.png';
    end
    
    % Create Human Lens
    %  Create a typical human lens
    wave   = 380 : 4 : 780;
    wvf    = wvfCreate('wave', wave);
    pupilDiameterMm = 3; % 3 mm
    sample_mean = wvfLoadThibosVirtualEyes(pupilDiameterMm);
    wvf    = wvfSet(wvf,'zcoeffs',sample_mean);
    wvf    = wvfComputePSF(wvf);
    oi     = wvf2oi(wvf,'shift invariant');
    
    % Aligned
    scene = sceneFromFile(aname, 'rgb', [], display);
    alignedConeData = getConeData(scene,imgFov,vDist,oi,nFrames);
    ind = round(linspace(1,size(alignedConeData,3),ntrainingsamples));
    alignedConeData = alignedConeData(:,:,ind);
    labels(1:ntrainingsamples) = 1;
    
    % Misaligned
    scene = sceneFromFile(mname, 'rgb', [], display);
    misalignedConeData = getConeData(scene,imgFov,vDist,oi,nFrames);
    misalignedConeData = misalignedConeData(:,:,ind);
    labels(ntrainingsamples+1:end) = 0;
    
    % Training
    train_db = [reshape(alignedConeData, 320, ntrainingsamples) reshape(misalignedConeData, 320, ntrainingsamples)];
    
    % Generate Test Data 
    misalignedConeData = getConeData(scene,imgFov,vDist,oi,nFrames); % use old scene
    ind = round(linspace(1,size(alignedConeData,3),ntestsamples));
    misalignedConeData = misalignedConeData(:,:,ind);
    scene = sceneFromFile(aname, 'rgb', [], display);
    alignedConeData = getConeData(scene,imgFov,vDist,oi,nFrames);
    alignedConeData = alignedConeData(:,:,ind);
   
    test_set = [reshape(alignedConeData, 320, ntestsamples) reshape(misalignedConeData, 320, ntestsamples)];
 
    % Testing
    testlabels = -1 * ones(1, 2*ntestsamples);
    for i = 1:ntestsamples
        testlabels(i) = NN_test(reshape(alignedConeData(:,:,i), 320, 1), train_db, labels);
    end
    for i = 1:ntestsamples
        testlabels(ntestsamples + i) = NN_test(reshape(misalignedConeData(:,:,i), 320, 1), train_db, labels);
    end
    %testlabels = randi([0,1],1,2*ntestsamples); % dummy
    
    fracCorrect = (sum([zeros(1,ntestsamples) ones(1,ntestsamples)] == testlabels))/(2*ntestsamples);
    
    fprintf('correct fraction: %f\n', fracCorrect);

    if abs(fracCorrect-.75) > eps
        if fracCorrect > .75
            vDist = (vDist + vDistMax)/2;
            vDistMin = vDist;
        else
            vDist = (vDist + vDistMin)/2;
            vDistMax = vDist;
        end
    end
    test_temp = 0;
end
