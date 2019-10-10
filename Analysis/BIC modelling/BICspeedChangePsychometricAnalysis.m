%Psychometric analysis file for speed change discrimination experiment
%(Experiment 2 of "Visual perception of motion: Exploring how distance and
%duration information contributes to speed and speed change
%discrimination")

clearvars;
dataDir = uigetdir();
cd(dataDir)


participantCodes = {'AW' 'AX' 'AZ' 'BA' 'BB' 'BD' 'BF'}; %participant codes
ParOrNonPar = 2; %non-parametric bootstrap for all
BootNo = 1000; %number of simulations for all bootstraps and goodness of fits

for iParticipant = 1:length(participantCodes)
    
    currParticipantCode = cell2mat(participantCodes(iParticipant));
    
    %% Balanced Slow data
        BSfileDir = strcat(dataDir,'/', 'lateralLine_speedchange_balanced_base_match_', currParticipantCode, '_*');
        
        BSfilenames = dir(BSfileDir);
        BSfilenames = {BSfilenames.name}; %makes a cell of filenames from the same
        %participant and condition to be loaded together
        
        for iBSFiles = 1:length(BSfilenames)
            BSfilenamestr = char(BSfilenames(iBSFiles));
            BSdataFile(iBSFiles) = load(BSfilenamestr); %loads all of the files to be analysed together
        end
        
        allBSExperimentData = [BSdataFile.experimentData]; %all of the experiment data in one combined struct
        allBSSessionInfo = BSdataFile.sessionInfo; %all of the session info data in one combined struct
        BSResponseTable = struct2table(allBSExperimentData); %The data struct is converted to a table
        
        %excluding invalid trials
        BSwantedData = ~(BSResponseTable.validTrial == 0); %creates a logical of which trials in the data table were valid
        BSvalidIsResponseCorrect = BSResponseTable.isResponseCorrect(BSwantedData); %
        BSvalidCondNumber = BSResponseTable.condNumber(BSwantedData);
        if iscell(BSvalidIsResponseCorrect) %if this is a cell because there were invalid responses
            BScorrectResponsesArray = cell2mat(BSvalidIsResponseCorrect); %convert to an array
            BScorrectResponsesLogical = logical(BScorrectResponsesArray); %then convert to a logical
        else
            BScorrectResponsesLogical = logical(BSvalidIsResponseCorrect); %immediately convert to a logical
        end
        
        %Calculating the number of correct responses for each condition for the
        %valid trials
        BScorrectTrials = BSvalidCondNumber(BScorrectResponsesLogical); %the conditions of each individual correct response
        BScorrectTrialConditions = unique(BScorrectTrials); %the conditions for which a correct response was made
        BSNumPos = histc(BScorrectTrials, BScorrectTrialConditions); %the total number of correct responses for each condition
        BSNumPos = BSNumPos';
        % %Finding the total number of trials for each condition for the valid trials
        BSallTrialConditions = unique(BSvalidCondNumber); %the conditions for which any response was made
        BSOutOfNum = histc(BSvalidCondNumber, BSallTrialConditions); %the total number of responses for each condition
        BSOutOfNum = BSOutOfNum';
        
        %% Balanced Fast Data
        
        BFfileDir = strcat(dataDir,'/', 'lateralLine_speedchange_balanced_max_match_', currParticipantCode, '_*');
        
        BFfilenames = dir(BFfileDir);
        BFfilenames = {BFfilenames.name}; %makes a cell of filenames from the same
        %participant and condition to be loaded together
        
        for iBFFiles = 1:length(BFfilenames)
            BFfilenamestr = char(BFfilenames(iBFFiles));
            BFdataFile(iBFFiles) = load(BFfilenamestr); %loads all of the files to be analysed together
        end
        
        allBFExperimentData = [BFdataFile.experimentData]; %all of the experiment data in one combined struct
        allBFSessionInfo = BFdataFile.sessionInfo; %all of the session info data in one combined struct
        BFResponseTable = struct2table(allBFExperimentData); %The data struct is converted to a table
        
        %excluding invalid trials
        BFwantedData = ~(BFResponseTable.validTrial == 0); %creates a logical of which trials in the data table were valid
        BFvalidIsResponseCorrect = BFResponseTable.isResponseCorrect(BFwantedData); %
        BFvalidCondNumber = BFResponseTable.condNumber(BFwantedData);
        if iscell(BFvalidIsResponseCorrect) %if this is a cell because there were invalid responses
            BFcorrectResponsesArray = cell2mat(BFvalidIsResponseCorrect); %convert to an array
            BFcorrectResponsesLogical = logical(BFcorrectResponsesArray); %then convert to a logical
        else
            BFcorrectResponsesLogical = logical(BFvalidIsResponseCorrect); %immediately convert to a logical
        end
        
        %Calculating the number of correct responses for each condition for the
        %valid trials
        BFcorrectTrials = BFvalidCondNumber(BFcorrectResponsesLogical); %the conditions of each individual correct response
        BFcorrectTrialConditions = unique(BFcorrectTrials); %the conditions for which a correct response was made
        BFNumPos = histc(BFcorrectTrials, BFcorrectTrialConditions); %the total number of correct responses for each condition
        BFNumPos = BFNumPos';
        % %Finding the total number of trials for each condition for the valid trials
        BFallTrialConditions = unique(BFvalidCondNumber); %the conditions for which any response was made
        BFOutOfNum = histc(BFvalidCondNumber, BFallTrialConditions); %the total number of responses for each condition
        BFOutOfNum = BFOutOfNum';
        
        %% Speed + distance data
        
        SdistfileDir = strcat(dataDir,'/', 'lateralLine_speedchange_fixed_duration_', currParticipantCode, '_*');
        
        Sdistfilenames = dir(SdistfileDir);
        Sdistfilenames = {Sdistfilenames.name}; %makes a cell of filenames from the same
        %participant and condition to be loaded together
        
        for iSdistFiles = 1:length(Sdistfilenames)
            Sdistfilenamestr = char(Sdistfilenames(iSdistFiles));
            SdistdataFile(iSdistFiles) = load(Sdistfilenamestr); %loads all of the files to be analysed together
        end
        
        allSdistExperimentData = [SdistdataFile.experimentData]; %all of the experiment data in one combined struct
        allSdistSessionInfo = SdistdataFile.sessionInfo; %all of the session info data in one combined struct
        SdistResponseTable = struct2table(allSdistExperimentData); %The data struct is converted to a table
        
        %excluding invalid trials
        SdistwantedData = ~(SdistResponseTable.validTrial == 0); %creates a logical of which trials in the data table were valid
        SdistvalidIsResponseCorrect = SdistResponseTable.isResponseCorrect(SdistwantedData); %
        SdistvalidCondNumber = SdistResponseTable.condNumber(SdistwantedData);
        if iscell(SdistvalidIsResponseCorrect) %if this is a cell because there were invalid responses
            SdistcorrectResponsesArray = cell2mat(SdistvalidIsResponseCorrect); %convert to an array
            SdistcorrectResponsesLogical = logical(SdistcorrectResponsesArray); %then convert to a logical
        else
            SdistcorrectResponsesLogical = logical(SdistvalidIsResponseCorrect); %immediately convert to a logical
        end
        
        %Calculating the number of correct responses for each condition for the
        %valid trials
        SdistcorrectTrials = SdistvalidCondNumber(SdistcorrectResponsesLogical); %the conditions of each individual correct response
        SdistcorrectTrialConditions = unique(SdistcorrectTrials); %the conditions for which a correct response was made
        SdistNumPos = histc(SdistcorrectTrials, SdistcorrectTrialConditions); %the total number of correct responses for each condition
        SdistNumPos = SdistNumPos';
        % %Finding the total number of trials for each condition for the valid trials
        SdistallTrialConditions = unique(SdistvalidCondNumber); %the conditions for which any response was made
        SdistOutOfNum = histc(SdistvalidCondNumber, SdistallTrialConditions); %the total number of responses for each condition
        SdistOutOfNum = SdistOutOfNum';
        
        %% Speed + duration data 
        
        SdurfileDir = strcat(dataDir,'/', 'lateralLine_speedchange_fixed_distance_', currParticipantCode, '_*');
        
        Sdurfilenames = dir(SdurfileDir);
        Sdurfilenames = {Sdurfilenames.name}; %makes a cell of filenames from the same
        %participant and condition to be loaded together
        
        for iSdurFiles = 1:length(Sdurfilenames)
            Sdurfilenamestr = char(Sdurfilenames(iSdurFiles));
            SdurdataFile(iSdurFiles) = load(Sdurfilenamestr); %loads all of the files to be analysed together
        end
        
        allSdurExperimentData = [SdurdataFile.experimentData]; %all of the experiment data in one combined struct
        allSdurSessionInfo = SdurdataFile.sessionInfo; %all of the session info data in one combined struct
        SdurResponseTable = struct2table(allSdurExperimentData); %The data struct is converted to a table
        
        %excluding invalid trials
        SdurwantedData = ~(SdurResponseTable.validTrial == 0); %creates a logical of which trials in the data table were valid
        SdurvalidIsResponseCorrect = SdurResponseTable.isResponseCorrect(SdurwantedData); %
        SdurvalidCondNumber = SdurResponseTable.condNumber(SdurwantedData);
        if iscell(SdurvalidIsResponseCorrect) %if this is a cell because there were invalid responses
            SdurcorrectResponsesArray = cell2mat(SdurvalidIsResponseCorrect); %convert to an array
            SdurcorrectResponsesLogical = logical(SdurcorrectResponsesArray); %then convert to a logical
        else
            SdurcorrectResponsesLogical = logical(SdurvalidIsResponseCorrect); %immediately convert to a logical
        end
        
        %Calculating the number of correct responses for each condition for the
        %valid trials
        SdurcorrectTrials = SdurvalidCondNumber(SdurcorrectResponsesLogical); %the conditions of each individual correct response
        SdurcorrectTrialConditions = unique(SdurcorrectTrials); %the conditions for which a correct response was made
        SdurNumPos = histc(SdurcorrectTrials, SdurcorrectTrialConditions); %the total number of correct responses for each condition
        SdurNumPos = SdurNumPos';
        % %Finding the total number of trials for each condition for the valid trials
        SdurallTrialConditions = unique(SdurvalidCondNumber); %the conditions for which any response was made
        SdurOutOfNum = histc(SdurvalidCondNumber, SdurallTrialConditions); %the total number of responses for each condition
        SdurOutOfNum = SdurOutOfNum';
        
        %% collating StimLevels, NumPos and OutOfNum for psychometric function fits
        
        StimLevels = [0 0.1818 0.3333 0.4615 0.5714 0.6667 0.75; ... %'lateralLine_speedchange_balanced_base_match' aka Balanced Slow
            0 0.1176 0.2222 0.3158 0.4 0.4762 0.5455; ... %'lateralLine_speedchange_balanced_max_match' aka Balanced Fast
            0 0.1667 0.2857 0.375 0.4444 0.5 0.5455; ... %'lateralLine_speedchange_fixed_duration' aka Speed + distance
            0 0.1667 0.2857 0.375 0.4444 0.5 0.5455]; %'lateralLine_speedchange_fixed_distance' aka Speed + duration
        
        NumPos = vertcat(BSNumPos, BFNumPos, SdistNumPos, SdurNumPos);
        OutOfNum = vertcat(BSOutOfNum, BFOutOfNum, SdistOutOfNum, SdurOutOfNum);
        
        %% Psychometric function fitting adapted from PAL_PFML_Demo
        
        options = PAL_minimize('options'); %options structure containing default
        %This sets the guess rate fixed and lets the offset/slope/lapse rate vary.
        paramsFree = [1 1 0 0];
        PF = @PAL_CumulativeNormal;
        Bmc = 1000;
        lapseLimits = [0 1];        %Range on lapse rates. Will go ignored here
        %since lapse rate is not a free parameter
        maxTries = 4;               %Try each fit at most four times
        rangeTries = [2 4 0 0];   %Range of random jitter to apply to initial
        %parameter values on retries of failed fits.
        
        results = struct();
        paramsValues = [0.2 2 .5 0];
        
        %Define fuller model
        thresholdsfuller = 'unconstrained';  %Each condition gets own threshold
        slopesfuller = 'unconstrained';      %Each condition gets own slope
        guessratesfuller = 'fixed';          %Guess rate fixed
        
        lapseratesfuller = 'fixed';    %Common lapse rate
        lapseFit = 'nAPLE';
        
        [results.paramsValues, results.LL, results.exitflag, results.output funcParams results.numParams] = ...
            PAL_PFML_FitMultiple(StimLevels, NumPos, OutOfNum, ...
            paramsValues, PF,'searchOptions',options,'lapserates',lapseratesfuller,'thresholds',thresholdsfuller,...
            'slopes',slopesfuller,'guessrates',guessratesfuller,'lapseLimits',[0 0.05],'lapseFit',lapseFit,'gammaeqlambda',1,'searchOptions',options);
        
        
        results3T3S(iParticipant).LL = results.LL;
        results3T3S(iParticipant).numParams = results.numParams;
        n  =  sum(BSOutOfNum(:));
        results3T3S(iParticipant).n = n;
        results3T3S(iParticipant).BIC       = log(n)*results.numParams - 2*results.LL;
        
        
        thresholdsfuller = 'constrained';
        slopesfuller = 'constrained';
        guessratesfuller = 'fixed';          %Guess rate fixed
        
        [results.paramsValues, results.LL, results.exitflag, results.output funcParams results.numParams] = ...
            PAL_PFML_FitMultiple(StimLevels, NumPos, OutOfNum, ...
            paramsValues, PF,'searchOptions',options,'lapserates',lapseratesfuller,'thresholds',thresholdsfuller,...
            'slopes',slopesfuller,'guessrates',guessratesfuller,'lapseLimits',[0 0.05],'lapseFit',lapseFit,'gammaeqlambda',1,'searchOptions',options);
        
        
        results1T1S(iParticipant).LL = results.LL;
        results1T1S(iParticipant).numParams = results.numParams;
        n  =  sum(BSOutOfNum(:));
        results1T1S(iParticipant).n = n;
        results1T1S(iParticipant).BIC       = log(n)*results.numParams - 2*results.LL;
        
end


%% model comparisons

ConstrainedBICs = [results1T1S.BIC];
UnconstrainedBICs = [results3T3S.BIC];

ModelComparisonBFs = ConstrainedBICs - UnconstrainedBICs; %again, negative here means adding more cues is not the favoured explanation


boxplot(ModelComparisonBFs)
set(gca,'fontsize',10)
xlabel('Model comparison', 'fontsize',12);
ylabel('Bayes Factor', 'fontsize',12);
set(gca, 'XTickLabel',{'Speed Only - Additional Cue'});


 set(gcf, 'PaperUnits', 'inches');
 x_width=6;
 y_width=5;
 set(gcf, 'PaperPosition', [0 0 x_width y_width]); %
 saveas(gcf,'modelBoxPlot.pdf');