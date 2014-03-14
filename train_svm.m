% Ryan Meganck, Adam Sajdak, Stephen Wu
% Stanford University
% 2014

function [ model, scale_factor ] = train_svm( training_label_vector, training_instance_matrix )
% Trains sVM model.

% training_instance_matrix: n x m where n is # of features and m is # of
% training examples
% training_label_vector: 1 x m of output labels

% normalize
scale_factor = max(training_instance_matrix(:));
training_instance_matrix = training_instance_matrix ./ scale_factor;

% default is run with flags '-s 0 -r 2' (C-SVC with radial basis
% function kernel).  These are the generally-accepted best choices for
% arbitrary data.

% Some intuition: Higher C allows us to ignore more outliers
% Lower gamma means that a feature's weight is only affected by nearby
% features.  Higher gamma means that a feature's weight may be affected
% by features which are further away.

% Default values for cost and gamma are 1 and 1/num_features
% respectively
model = svmtrain(training_label_vector', training_instance_matrix', '-c 1 -g 0.07');
end