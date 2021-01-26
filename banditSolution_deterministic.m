function [avgReward,rpeTrack] =  banditSolution_deterministic(trialNumber,replayNumber,parameters,actionSelection,numArms) 
%Bandit Problem Solver for Deterministic Problem Solver
%Parameters for models
%     (1) Learning Rate (Greedy, Softmax, Chance)
%     (2) Epsilon (Greedy), Temperature (Softmax)
%     (3) Win Value
%     (4) Loss Value
% Action Selection options:
% (1) 'Greedy'
% (2) 'Softmax'
% (3) 'Chance'

%Add functions to path
addpath('./Functions');

%Check for errors
[errorPresent] = errorCheck(parameters,actionSelection);

if errorPresent == 1
   error('Run Error: Problem with parameters!');
   return
end


%Current To Do: 
%1. add q-learning, action observer
%2. add WSLS

%Get Softmax values
softmax.learningRate = parameters(1);
softmax.temperature = parameters(2);

%Get Epsilon values
greedy.learningRate = parameters(1);
greedy.epsilon = parameters(2);

%Get Chance model values
chance.learningRate = parameters(1);

%Assign Win or Loss Values
winReward = parameters(3);
lossReward = parameters(4);

%Initialize Values
initialValue = parameters(5);
    
for replayCounter = 1:replayNumber
    
    %Set "Actual" array values
    arrayValues = normrnd(0,1,numArms);
    
    %Set banditValues
    banditValues = zeros(1,length(arrayValues))+initialValue;
    
    %reset Values
    rpe = 0;
    
    for playCounter = 1:trialNumber
                
        %Choose action selection method
        switch actionSelection
            
            %Greedy Action Selection
            case 'Greedy'
                [armChoice] = greedyAction(banditValues,greedy.epsilon);
                learningRate = greedy.learningRate;
                %Softmax Action Selection
            case 'Softmax'
                [armChoice] = softmaxAction(banditValues,softmax.temperature);
                learningRate = softmax.learningRate;
                %Chance Action Selection
            case 'Chance'
                [armChoice] = chanceAction(banditValues);
                learningRate = chance.learningRate;
                
        end
        
        %Find if trial Rewarded or Not
        trialReward = arrayValues(armChoice);
        
        if trialReward > rand()
            reward = winReward;
        else
            reward = lossReward;
        end
        
        %Update Reward prediction error
        rpe = reward - banditValues(armChoice);
        
        %Update Bandit Values
        banditValues(armChoice) = banditValues(armChoice) + learningRate * rpe;
        
        %Constrain arm choice values
        %Keep below 1
        if banditValues(armChoice) > 1
            banditValues(armChoice) = 1;
        end
        %Keep above -1
        if banditValues(armChoice) < -1
            banditValues(armChoice) = -1;
        end
        
        %Find max value
        [~,maxChoice] = max(banditValues);
        
        %Determine if Choice was highest Value
        if maxChoice == armChoice
            optimal = 1;
        else
            optimal = 0;
        end
        
        %Assign RPE
        rpeTrack(playCounter,replayCounter) = rpe;
        
        %Assign Arm Choice
        armChoiceTrack(playCounter,replayCounter) = armChoice;
        
        %Assign Maximal Choice
        maxChoiceTrack(playCounter,replayCounter) = optimal;
        
        %Average Reward
        avgReward(playCounter,replayCounter) = reward;
        
    end
    
end



%Create Trial Array (for plotting)
trials = 1:1:trialNumber;

%Create Plots for analysis
figure
%Plot RPE
subplot(1,3,1)
plot(trials,mean(rpeTrack,2));
ylabel('Prediction Error');
xlabel('Trial Number');
xlim([-50 trialNumber])

%Percent Optimal Action
subplot(1,3,2)
plot(trials,sum(maxChoiceTrack',1)/replayCounter);
ylabel('Optimal Action (%)');
xlabel('Trial Number');
xlim([-50 trialNumber]);

% Percent Reward
subplot(1,3,3)
plot(trials,mean(avgReward,2));
ylabel('Average Reward');
xlabel('Trial Number');
xlim([-50 trialNumber]);
end