%Psychometric analysis code for generating a representative set of
%psychometric functions to use as a figure in the paper.

%use participant BB as an example, good representative of overall pattern

clearvars;
dataDir = uigetdir();
cd(dataDir)


participantCodes = {'BB'}; %participant codes
ParOrNonPar = 2; %non-parametric bootstrap for all
BootNo = 1000; %number of simulations for all bootstraps and goodness of fits

for iParticipant = 1:length(participantCodes)
    
    currParticipantCode = cell2mat(participantCodes(iParticipant));
    %experiment conditions
    conditionList = {'lateralLine_shortDuration' 'lateralLine_midDuration' 'lateralLine_longDuration'};
    
    analysisType = {'proportion'};
    
    for iAnalysis = 1:length(analysisType)
        currAnalysisType = cell2mat(analysisType(iAnalysis));
        for iCond = 1:length(conditionList)
            currCondition = cell2mat(conditionList(iCond));
            condAndParticipant = strcat(currCondition, '_', currParticipantCode);
            
            fileDir = strcat(dataDir,'/', condAndParticipant, '_*');
            
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
            validData = ~(ResponseTable.validTrial == 0); %creates a logical of which trials in the data table were valid
            validResponses = ResponseTable.response(validData); %
            validCondNumber = ResponseTable.condNumber(validData);
            
            %converting the j and f responses into a logical. J = it got faster.
            FRespCell = strfind(validResponses, 'f');
            JResponses = cellfun('isempty', FRespCell); %creates a logical where j responses are 1s and f responses are 0
            
            %need number of it got faster responses for each condition
            %need row vector of how many trials there were for each condition
            
            FasterResponses = validCondNumber(JResponses);
            allConds = unique(validCondNumber);
            
            NumPos = histc(FasterResponses, allConds)'; %the number of it got faster responses for each level in the fast condition
            OutOfNum = histc(validCondNumber,allConds)'; %the number of trials in each level in the fast condition
            
            if strcmp(currAnalysisType, 'proportion')
                
                xLabelTitle = 'Second speed (deg/s)';
                
                speedDiff = [6.7032 7.6593 8.7517 10.0000 11.4263 13.0561 14.9182];
                
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
            searchGrid.gamma = 0;  %scalar here (since fixed) but may be vector
            searchGrid.lambda = 0;  %ditto
            
            %Perform fit
            disp('Fitting function.....');
            [paramsValues, LL, exitflag] = PAL_PFML_Fit(speedDiff,NumPos, ...
                OutOfNum,searchGrid,paramsFree,PF);
            
            disp('done:')
            message = sprintf('Threshold estimate: %6.4f',paramsValues(1));
            disp(message);
            message = sprintf('Slope estimate: %6.4f\r',paramsValues(2));
            disp(message);
            
            disp('Determining standard errors.....');
            
            if ParOrNonPar == 1
                [SD, paramsSim, LLSim, converged] = PAL_PFML_BootstrapParametric(...
                    speedDiff, OutOfNum, paramsValues, paramsFree, BootNo, PF, ...
                    'searchGrid', searchGrid);
            else
                [SD, paramsSim, LLSim, converged] = PAL_PFML_BootstrapNonParametric(...
                    speedDiff, NumPos, OutOfNum, [], paramsFree, BootNo, PF,...
                    'searchGrid',searchGrid);
            end
            
            disp('done:');
            message = sprintf('Standard error of Threshold: %6.4f',SD(1));
            disp(message);
            message = sprintf('Standard error of Slope: %6.4f\r',SD(2));
            disp(message);
            
            disp('Determining Goodness-of-fit.....');
            
            [Dev, pDev] = PAL_PFML_GoodnessOfFit(speedDiff, NumPos, OutOfNum, ...
                paramsValues, paramsFree, BootNo, PF, 'searchGrid', searchGrid);
            
            disp('done:');
            
            %Put summary of results on screen
            message = sprintf('Deviance: %6.4f',Dev);
            disp(message);
            message = sprintf('p-value: %6.4f',pDev);
            disp(message);
            
            %Create simple plot
            ProportionCorrectObserved=NumPos./OutOfNum;
            StimLevelsFineGrain=[min(speedDiff):max(speedDiff)./1000:max(speedDiff)];
            ProportionCorrectModel = PF(paramsValues,StimLevelsFineGrain);
            
            if strcmp(currCondition, 'lateralLine_shortDuration')
                
                lineColour = [1,0.9,0];
                markerStyle = 'ko';
                
            elseif strcmp(currCondition, 'lateralLine_midDuration')
                
                lineColour = [1,0.6,0];
                markerStyle = 'kx';
               
            elseif strcmp(currCondition, 'lateralLine_longDuration')
                
                lineColour = [0.8,0,0];
                markerStyle = 'k+';
                
            end
            
            hold on
            plot(StimLevelsFineGrain,ProportionCorrectModel,'-', 'color', lineColour,'linewidth',4);
            plot(speedDiff,ProportionCorrectObserved, markerStyle,'markersize',10);
            set(gca, 'fontsize',12);
            set(gca, 'Xtick', [6.70 7.66 8.75 10 11.43 13.06 14.92]);
            axis([6 16 0 1]);
            xlabel(xLabelTitle);
            ylabel('Proportion "it got faster" responses');
            
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
