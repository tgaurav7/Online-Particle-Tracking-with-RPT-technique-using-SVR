function[traindat,validation]=k_FoldCV_SPLIT(data,k_fold,fold_num)
%-------------------------------------------------------------------%--- K Fold Cross Validation----------------------------------------%----------------------------------------------------------------------% OUTPUT
% train:Train data for the fold number
% validation: Validation data for the fold number
%-------------------------------------------------------------------------% INPUT
% data: The array of dataset(with the last value as the class 
%labels)
% k_fold: Number of Folds
% fold_num: The fold number
%--------------------------------------------------------------------------%

n_samples=size(data,1);
fold_length=k_fold;
fold_index_max=ceil(n_samples/k_fold);
for fold_index=1:fold_index_max
    fold_start(fold_index)=(fold_index-1)*fold_length+1;
end
index=fold_start+fold_num-1;
index=index(find(index<=n_samples)); % Check if the Index Bound Exceeds
traindat=[];
validation=[];
for i=1:n_samples
    if any(index==i)
        validation=[validation;data(i,:)];
    else
        traindat=[traindat;data(i,:)];
    end
end