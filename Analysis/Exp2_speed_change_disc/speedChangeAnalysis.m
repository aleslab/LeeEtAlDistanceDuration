%Psychometric analysis file for speed change discrimination experiment
%(Experiment 2 of "Visual perception of motion: Exploring how distance and
%duration information contributes to speed and speed change
%discrimination")

clearvars;
cd /Users/aril/Documents/Experiment_7 %


participantCodes = {'AW' 'AX' 'AZ' 'BA' 'BB' 'BD' 'BF'}; %participant codes
ParOrNonPar = 2; %non-parametric bootstrap for all
BootNo = 1000; %number of simulations for all bootstraps and goodness of fits

for iParticipant = 1:length(participantCodes)
    
    currParticipantCode = cell2mat(participantCodes(iParticipant));
    %experiment conditions
    conditionList = {'lateralLine_speedchange_fixed_duration'; ...
        'lateralLine_speedchange_fixed_distance'; 'lateralLine_speedchange_balanced_max_match'; ...
        'lateralLine_speedchange_balanced_base_match'};
    
    analysisType = {'proportionb_a_b'};
    
    for iAnalysis = 1:length(analysisType)
        currAnalysisType = cell2mat(analysisType(iAnalysis));
        for iCond = 1:length(conditionList)
            currCondition = cell2mat(conditionList(iCond));
            condAndParticipant = strcat(currCondition, '_', currParticipantCode);
            
            fileDir = strcat('/Users/aril/Documents/Experiment_7/', condAndParticipant, '_*');
            
            filenames = dir(fileDir);
            filenames = {filenames.name}; %makes a cell of filenames from the same
            %participant and condition to be loaded together
            
            for iFiles = 1:length(filenames)
                filenamestr = char(filenames(iFiles));
                dataFile(iFiles) = load(filenamestr); %loads all of the files to be analysed together
            end
            
            allExperimentData = [dataFile.experimentData]; %all of the experiment data in one combined struct
            allSessionInfo = dataFile.sessionInfo; %all of the session info data in one combined struct
            ResponseTable = struct2table(allExperimentData); %The data struct is converted to a table
            
            %excluding invalid trials
            wantedData = ~(ResponseTable.validTrial == 0); %creates a logical of which trials in the data table were valid
            validIsResponseCorrect = ResponseTable.isResponseCorrect(wantedData); %
            validCondNumber = ResponseTable.condNumber(wantedData);
            if iscell(validIsResponseCorrect) %if this is a cell because there were invalid responses
                correctResponsesArray = cell2mat(validIsResponseCorrect); %convert to an array
                correctResponsesLogical = logical(correctResponsesArray); %then convert to a logical
            else
                correctResponsesLogical = logical(validIsResponseCorrect); %immediately convert to a logical
            end
            
            %Calculating the number of correct responses for each condition for the
            %valid trials
            correctTrials = validCondNumber(correctResponsesLogical); %the conditions of each individual correct response
            correctTrialConditions = unique(correctTrials); %the conditions for which a correct response was made
            condCorrectNumbers = histc(correctTrials, correctTrialConditions); %the total number of correct responses for each condition
            condCorrectNumbers = condCorrectNumbers';
            % %Finding the total number of trials for each condition for the valid trials
            allTrialConditions = unique(validCondNumber); %the conditions for which any response was made
            allTrialNumbers = histc(validCondNumber, allTrialConditions); %the total number of responses for each condition
            allTrialNumbers = allTrialNumbers';
            %allCorrectPercentages = (condCorrectNumbers./allTrialNumbers); %creates a double of the percentage correct responses for every condition
            
            
            if strcmp(currAnalysisType, 'proportionb_a_b')
                
                xLabelTitle = 'Proportion speed change ((b-a)/b)';
                
                if strfind(currCondition, 'lateralLine_speedchange_balanced_base_match')
                    
                    speedDiff = [0 0.1818 0.3333 0.4615 0.5714 0.6667 0.75];
                    
                elseif strfind(currCondition, 'lateralLine_speedchange_balanced_max_match')
                    
                    speedDiff = [0 0.1176 0.2222 0.3158 0.4 0.4762 0.5455];
                    
                elseif strfind(currCondition, 'lateralLine_speedchange_fixed_duration')
                    
                    speedDiff = [0 0.1667 0.2857 0.375 0.4444 0.5 0.5455];
                    
                elseif strfind(currCondition, 'lateralLine_speedchange_fixed_distance')
                    
                    speedDiff = [0 0.1667 0.2857 0.375 0.4444 0.5 0.5455];
                    
                end
                
            end
            
            %% Psychometric function fitting adapted from PAL_PFML_Demo
            
            tic
            
            PF = @PAL_CumulativeNormal;
            
            %Threshold and Slope are free parameters, guess and lapse rate are fixed
            paramsFree = [1 1 0 0];  %1: free parameter, 0: fixed parameter
            
            %Parameter grid defining parameter space through which to perform a
            %brute-force search for values to be used as initial guesses in iterative
            %parameter search.
            searchGrid.alpha = linspace(min(speedDiff),max(speedDiff),101);
            searchGrid.beta = linspace(0,(30/max(speedDiff)),101);
            searchGrid.gamma = 0.5;  %scalar here (since fixed) but may be vector
            searchGrid.lambda = 0;  %ditto
            
            %Perform fit
            disp('Fitting function.....');
            [paramsValues, LL, exitflag] = PAL_PFML_Fit(speedDiff,condCorrectNumbers, ...
                allTrialNumbers,searchGrid,paramsFree,PF);
            
            disp('done:')
            message = sprintf('Threshold estimate: %6.4f',paramsValues(1));
            disp(message);
            message = sprintf('Slope estimate: %6.4f\r',paramsValues(2));
            disp(message);
            
            disp('Determining standard errors.....');
            
            if ParOrNonPar == 1
                [SD, paramsSim, LLSim, converged] = PAL_PFML_BootstrapParametric(...
                    speedDiff, allTrialNumbers, paramsValues, paramsFree, BootNo, PF, ...
                    'searchGrid', searchGrid);
            else
                [SD, paramsSim, LLSim, converged] = PAL_PFML_BootstrapNonParametric(...
                    speedDiff, condCorrectNumbers, allTrialNumbers, [], paramsFree, BootNo, PF,...
                    'searchGrid',searchGrid);
            end
            
            disp('done:');
            message = sprintf('Standard error of Threshold: %6.4f',SD(1));
            disp(message);
            message = sprintf('Standard error of Slope: %6.4f\r',SD(2));
            disp(message);
            
            disp('Determining Goodness-of-fit.....');
            
            [Dev, pDev] = PAL_PFML_GoodnessOfFit(speedDiff, condCorrectNumbers, allTrialNumbers, ...
                paramsValues, paramsFree, BootNo, PF, 'searchGrid', searchGrid);
            
            disp('done:');
            
            %Put summary of results on screen
            message = sprintf('Deviance: %6.4f',Dev);
            disp(message);
            message = sprintf('p-value: %6.4f',pDev);
            disp(message);
            
            %Create simple plot
            ProportionCorrectObserved=condCorrectNumbers./allTrialNumbers;
            StimLevelsFineGrain=[min(speedDiff):max(speedDiff)./1000:max(speedDiff)];
            ProportionCorrectModel = PF(paramsValues,StimLevelsFineGrain);
            
            figure;
            axes
            hold on
            plot(StimLevelsFineGrain,ProportionCorrectModel,'-','color',[0 .7 0],'linewidth',4);
            plot(speedDiff,ProportionCorrectObserved,'-k.','markersize',40);
            set(gca, 'fontsize',16);
            set(gca, 'Xtick', speedDiff);
            axis([min(speedDiff) max(speedDiff) .4 1]);
            xlabel(xLabelTitle);
            ylabel('proportion correct');
            title(condAndParticipant, 'interpreter', 'none');
            
            figFileName = strcat('psychometric_', currAnalysisType, '_', condAndParticipant, '.pdf');
            saveas(gcf, figFileName);
            
            RawDataExcelFileName = strcat('raw_data_', condAndParticipant, '.csv');
            writetable(ResponseTable, RawDataExcelFileName);
            
            stimAt75PercentCorrect = PAL_CumulativeNormal(paramsValues, 0.75, 'Inverse');
            slopeAt75PercentThreshold = PAL_CumulativeNormal(paramsValues, stimAt75PercentCorrect, 'Derivative');
            % this slope value might not be particularly close to the beta
            %value that comes out of the paramsValues things as with the
            %cumulative normal function the beta value is the inverse of
            %the standard deviation, which is related/proportional to the
            %slope but not actually the slope.
            
            for iBoot = 1:BootNo
                boot75Threshold(iBoot) = PAL_CumulativeNormal(paramsSim(iBoot,:), 0.75, 'Inverse');
                bootSlopeAt75Threshold(iBoot) = PAL_CumulativeNormal(paramsSim(iBoot,:), boot75Threshold(iBoot), 'Derivative');
            end
            
            thresholdSE = std(boot75Threshold);
            slopeSE = std(bootSlopeAt75Threshold);
            
            sortedThresholdSim = sort(boot75Threshold);
            sortedSlopeSim = sort(bootSlopeAt75Threshold);
            thresholdCI = [sortedThresholdSim(25) sortedThresholdSim(BootNo-25)];
            slopeCI = [sortedSlopeSim(25) sortedSlopeSim(BootNo-25)];
            
            psychInfo(iCond).condition = currCondition;
            %correct values that i've calculated
            psychInfo(iCond).stimAt75PercentCorrect = stimAt75PercentCorrect;
            psychInfo(iCond).slopeAt75PercentThreshold = slopeAt75PercentThreshold;
            psychInfo(iCond).alphaCI = thresholdCI;
            psychInfo(iCond).betaCI = slopeCI;
            psychInfo(iCond).thresholdSE = thresholdSE;
            psychInfo(iCond).slopeSE = slopeSE;
            %the original parameters, standard errors from bootstrapping
            %and values from goodness of fit (dev and pdev).
            psychInfo(iCond).condParamsValues = paramsValues;
            psychInfo(iCond).condParamsSE = SD;
            psychInfo(iCond).condParamsDev = Dev;
            psychInfo(iCond).condParamsPDev = pDev;
            
            toc
            
            
        end
        psychTable = struct2table(psychInfo);
        psychExcelFileName = strcat('psychometric_data_', currAnalysisType, '_', currParticipantCode, '.csv');
        writetable(psychTable, psychExcelFileName);
        
    end
end
