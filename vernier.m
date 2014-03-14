% Ryan Meganck, Adam Sajdak, Stephen Wu
% Stanford University
% 2014

close all;
clear all;
clc;

algorithm = 1; % 0 = nearest neighbor, 1 = SVM
ppi = 50:25:750;
numTests = 20;
fracCorrect = -1 * ones(length(ppi), numTests);
regen = 1;
imgFov = 6/60; % visual angle (degree)
nFrames = 500; % Number of samples
vDist = 2; % viewing distance (meter)

for x = 1:length(ppi) %Iterate over viewing distances
    for y = 1:numTests % Iterate over number of tests
        
        ppi_val = ppi(x)
        testNum = y
        
        imgSz = round(tand(imgFov*ones(1,2))*vDist*39.37*ppi(x)); % number of pixels in image
        imgFov = atand(max(imgSz)/ppi(x)/39.37/vDist); % Actual fov
        
        % Create virtual display
        display = displayCreate('LCD-Apple');
        display = displaySet(display, 'dpi', ppi(x));
        
        if regen
            [aname,mname] = make_scenes(imgSz);
        else
            aname = 'scene_a.png';
            mname = 'scene_m.png';
        end
        
        % Create Human Lens
        % Create a typical human lens
        wave = 380 : 4 : 780;
        wvf = wvfCreate('wave', wave);
        pupilDiameterMm = 3; % 3 mm
        sample_mean = wvfLoadThibosVirtualEyes(pupilDiameterMm);
        wvf = wvfSet(wvf,'zcoeffs',sample_mean);
        wvf = wvfComputePSF(wvf);
        oi = wvf2oi(wvf,'shift invariant');
        
        % Aligned
        scene = sceneFromFile(aname, 'rgb', [], display);
        alignedConeData = getConeData(scene,imgFov,vDist,oi,nFrames);
        labels(1:nFrames) = 1;
        
        % Misaligned
        scene = sceneFromFile(mname, 'rgb', [], display);
        misalignedConeData = getConeData(scene,imgFov,vDist,oi,nFrames);
        labels(nFrames+1:2*nFrames) = 0;
        
        % Training
        train_db = [alignedConeData' misalignedConeData'];
        if algorithm == 1
            [model scale_factor] = train_svm(labels, train_db);
        end
        
        % Generate Test Data
        misalignedConeData = getConeData(scene,imgFov,vDist,oi,nFrames);
        scene = sceneFromFile(aname, 'rgb', [], display);
        alignedConeData = getConeData(scene,imgFov,vDist,oi,nFrames);
        
        test_set = [alignedConeData' misalignedConeData'];
        
        % Testing
        if algorithm == 1
            testlabels = test_svm(test_set, model, scale_factor);
        else % nearest neighbor
            testlabels = -1 * ones(1, 2*nFrames);
            for i = 1:nFrames
                testlabels(i) = test_nn(alignedConeData(i,:)', train_db, labels);
            end
            for i = 1:nFrames
                testlabels(nFrames + i) = test_nn(misalignedConeData(i,:)', train_db, labels);
            end
        end
        
        fracCorrect(x,y) = (sum([ones(1,nFrames) zeros(1,nFrames)] == testlabels))/(2*nFrames);
        fracCorrect_save = fracCorrect'
        save('result.mat','fracCorrect_save', 'vDist', 'ppi', 'algorithm')
        
        fprintf('correct fraction: %f\n', fracCorrect(x,y));
    end
end
