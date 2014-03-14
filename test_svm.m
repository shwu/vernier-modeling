% Ryan Meganck, Adam Sajdak, Stephen Wu
% Stanford University
% 2014

function [ predicted_labels ] = test_svm( testing_instance_matrix, model, scale_factor )
% Tests SVM model.

% testing_instance_matrix:  n x m where n is # of features and m is # of
% training examples
% model: output of train_svm
% scale_factor: output of train_svm

    num_tests = size(testing_instance_matrix, 2);
    % normalize
    testing_instance_matrix = testing_instance_matrix ./ scale_factor;
    predicted_labels = svmpredict(0.5*ones(num_tests, 1), testing_instance_matrix', model)';
end