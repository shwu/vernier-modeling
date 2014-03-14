% Ryan Meganck, Adam Sajdak, Stephen Wu
% Stanford University
% 2014

function [ result ] = test_nn( test_img, train_db, db_labels )
%NN_test takes a test image and compares it to the database of training
%images to find the 1-nearest neighbor.  The label of the nearest neighbor
%is assigned to the test_image.


%   **Inputs**
%       test_img: (dim x 1) A single retina test image
%       train_db: (dim x N) Database of training images
%       db_labels: (1 x N) Labels corresponding to training images

%  **Outputs**
%       result: (1 x 1) Output value corresponding to the label of the
%       nearest neighbor (0 -> 2 lines; 1 -> 1 line)
        

% Calculate distances from test vector to all training images and determine
% nearest neighbor

distances = pdist2(train_db', test_img'); % Use for PCA NN
[~, indexOfClosest] = min(distances);

result = db_labels(indexOfClosest);

end

