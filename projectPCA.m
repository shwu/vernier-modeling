% Ryan Meganck, Adam Sajdak, Stephen Wu
% Stanford University
% 2014

function [ proj_img ] = projectPCA( test_img, prinComponents, meanImg)
% PROJ_IMG gives the weights of the principal components which yield
% TEST_IMG when summed together.

test_vector = test_img(:);
test_vector = test_vector - meanImg;

test_vector_short = zeros(1, size(prinComponents,2));

for i = 1:size(prinComponents,2)
    temp = dot(prinComponents(:,i),test_vector);
    test_vector_short(i) = temp;
end

proj_img = test_vector_short';

end