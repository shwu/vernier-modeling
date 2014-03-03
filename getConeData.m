function coneData = getConeData(scene,imgFov,vDist,oi,nFrames)

% set scene fov
scene = sceneSet(scene, 'h fov', imgFov);
scene = sceneSet(scene, 'distance', vDist);

% Visualize scene
vcAddAndSelectObject('scene', scene); sceneWindow;

% Compute optical image
% Actually, we could wait to compute it in coneSamples
% But, we compute it here to do sanity check
oi = oiCompute(scene, oi);

% Visualize optical image
vcAddAndSelectObject('oi', oi); oiWindow;

% Create Sensor and Compute Samples
%  Create human sensor
sensor = sensorCreate('human');
sensor = sensorSetSizeToFOV(sensor, imgFov, scene, oi);

%  Init some parameters
%  These are parameters for eye movement. Eye movement is very tricky and
%  at first step, you could turn it off by setting Sigma to zeros(2).
%  In handling eye movement, you need to make sure that the classifier
%  cannot tell the difference between two groups based on eye movement
%  pattern or something related.
%  Here, I set the eye movement speed to be 10 ms. Actually, the saccade is
%  much faster than this. But for efficiency, we just compute the
%  equivalent brownian motion and do it for 10 ms. If you have enough time,
%  you could try to use 1ms eye-movement
params.center   = [0,0];
params.Sigma    = 0.01^2 * eye(2) / 5;
params.nSamples = 5*nFrames;
params.fov      = sensorGet(sensor,'fov',scene,oi);

%  Set exposure time to 10 ms
sensor = sensorSet(sensor, 'exp time', 0.01);

% Set up the eye movement properties
sensor = emInit('fixation', sensor, params);

% Compute the cone absopritons
sensor = coneAbsorptions(sensor, oi);

% Store the photon samples
pSamples = double(sensorGet(sensor, 'photons'));

% Add 5 samples to 1 to form the 50ms integration time
pSamples = RGB2XWFormat(pSamples);
szN = size(pSamples, 1);
pSamples = sum(reshape(pSamples, [szN, nFrames, 5]),3)';

coneData = sensor.data.volts;
end