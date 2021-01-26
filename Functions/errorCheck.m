function [errorMsg] = errorCheck(parameters,actionSelection)
    
    %Check Greedy Model
    if strcmp(actionSelection,'Greedy')
        %Check learning rate
        if parameters(1) > 1
            errorPresent = 1;
        %Check epsilon
        elseif parameters(2) > 1
            errorPresent = 1;
        %Or else no error
        else
            errorPresent = 0;
        end
    end
    
    %Check Softmax Model
    if strcmp(actionSelection,'Softmax')
        %Check learning rate
        if parameters(1) > 1
            errorPresent = 1;
        %Check temperature
        elseif parameters(2) > 20
            errorPresent = 1;
        %Or else no error
        else
            errorPresent = 0;
        end   
    end
    
    %Check Chance Model
    if strcmp(actionSelection,'Chance')
        %Check learning rate
        if parameters(1) > 1
            errorPresent = 1;
        else
            errorPresent = 0;
        end 
    end
    
    %Determine if there is an error
    if errorPresent == 1
        errorMsg = 1;
    else
        errorMsg = 0;
    end

end