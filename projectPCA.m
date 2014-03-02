function [ proj_img ] = projectPCA( test_img, prinComponents, meanImg)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

test_vector = test_img(:);
test_vector = test_vector - meanImg;

test_vector_short = zeros(1, size(prinComponents,2));

for i = 1:size(prinComponents,2)
    temp = dot(prinComponents(:,i),test_vector);
    test_vector_short(i) = temp;
end

proj_img = test_vector_short';

end


