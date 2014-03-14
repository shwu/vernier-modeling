% Ryan Meganck, Adam Sajdak, Stephen Wu
% Stanford University
% 2014

function [ prinComponents, weightCols, meanImg ] = doPCA( train_db, dimToKeep )
% Use principle component analysis to reduce dimensionality
    
    % Subtract the mean row from the test image
    % a zero-mean database matrix
    meanImg = mean(train_db,2);
    meanMatrix = repmat(meanImg, 1, size(train_db,2));
    train_db = train_db - meanMatrix;

    [u, s, v] = svd(train_db, 'econ');
    prinComponents = u(:,1:dimToKeep);
    s_short = s(1:dimToKeep,1:dimToKeep);
    v = v';
    v_short = v(1:dimToKeep,:);
    weightCols = s_short * v_short;

end

