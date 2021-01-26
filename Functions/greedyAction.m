function [armChoice] = greedyAction(choiceArray,epsilon)
      
      %Find max choice from the Array
      [~,maxChoice] = max(choiceArray);
      
      %Assign maxChoice to arm Choice
      armChoice = maxChoice;
      
      %Randomly explore
      if epsilon > rand()
          
          %Choose Other arm
          [armChoice] = randi(length(choiceArray));
     
      end
       
end