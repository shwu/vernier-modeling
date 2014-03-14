% Ryan Meganck, Adam Sajdak, Stephen Wu
% Stanford University
% 2014

function [ train_db, db_labels] = train_nn(train_img, img_label, train_db, db_labels)
%NN_train takes an n x m retina image (16 x 20) and reshapes it to an
%n*m x 1 vector.  This vector is concatenated with the existing matrix
%containing a database of N training images (n*m x N).

%The function also takes in a label describing if the image corresponds to
%one or two lines.  The label concatenated with a matrix containing the
%labels for all of the training images.


%   **Inputs**
%       train_img: (n x m) A single retina image of a training example
%       img_label: (1 x 1) Binary value indicating if an image is one or
%           two lines (0 -> 2 lines; 1 -> 1 line)
%       train_db: (nm x N) Matrix containing all training images
%       db_labels: (1 x N) Vector containing labels for training images

%  **Outputs**
%       train_db: (nm x N + 1) Updated matrix containing all training images
%       train_labels: (1 x N + 1) Updated vector containing image labels

img_vector = train_img(:);
train_db = [train_db, img_vector];
db_labels = [db_labels, img_label];

end

