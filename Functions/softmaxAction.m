function [armChoice] = softmaxAction(choiceArray,temperature)
    
    %Compute Softmax results
    softmaxResult = exp(choiceArray./temperature) / sum(exp(choiceArray./temperature));
    
    %Find cumulative sum
    cumsum(softmaxResult);
    
    %Create random choice
    randomChoice = rand;
    
    %Find max choice according to softmax rule
    [maxValue,maxChoice] = max(softmaxResult);
    
    %Assign max choice to arm choice
    armChoice = maxChoice;
    
    %Randomly explore other options
    if randomChoice > maxValue
        
        %Choose Other arm
        [armChoice] = randi(length(choiceArray));
    end
    
    
end