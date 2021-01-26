function [armChoice] = chanceAction(armValues)
    
    %Randomly Choose an Arm
    armChoice = randi(length(armValues));
    
end