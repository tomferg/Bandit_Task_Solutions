function [armChoice] = softmaxAction(choiceArray,temperature)
    
    %Compute Softmax results
    softmaxResult = exp(choiceArray./temperature) / sum(exp(choiceArray./temperature));
    
    %Find cumulative sum
    softmaxSum = cumsum(softmaxResult);
    
    %Assign Values to softmax options
    softmaxOptions = softmaxSum > rand();
    
    %Find arm choice
    armChoice = find(softmaxOptions, 1, 'first');
    
    
end