function [actualPayouts] = dawGenerate(numArms,numTrials)

% Parameters From the Daw paper
decayParameter = 0.9836;
decayCenter = 50;
diffusionNoiseSD = 2.8;
payoutSD = 4;

% Compute mean payouts
meanPayouts = {};
for banditCounter = 1:length(numArms)
    
    %Create NaN array for number of bandits and trials
    meanPayouts = nan(numArms(banditCounter),numTrials);
    
    %Initialize first values randomly
    meanPayouts(:,1) = 100*rand(numArms(banditCounter),1);
    
    %Loop across Trials
    for trialCounter = 2:numTrials
        meanPayouts(:,trialCounter) = decayParameter*meanPayouts(:,trialCounter-1) + (1-decayParameter)*decayCenter + diffusionNoiseSD*randn(numArms(banditCounter),1);
    end
    
    %Constrain values between 1 and 100
    meanPayouts(meanPayouts < 1) = 1;
    meanPayouts(meanPayouts > 100) = 100;
    
end

% Compute actual payouts
actualPayouts = {};

%Loop across arms
for banditCounter = 1:length(numArms)
    %Assign values to new Array
    theseMeanPayouts = meanPayouts;
    
    %Modify values
    thisNoise = payoutSD.*randn(numArms(banditCounter),numTrials);
    
    %Round the values
    theseActualPayouts = round(theseMeanPayouts + thisNoise);
    
    %Contrain Values
    theseActualPayouts(theseActualPayouts<1) = 1;
    theseActualPayouts(theseActualPayouts>100) = 100;
    
    %Assign to new array
    actualPayouts = theseActualPayouts;
    
end