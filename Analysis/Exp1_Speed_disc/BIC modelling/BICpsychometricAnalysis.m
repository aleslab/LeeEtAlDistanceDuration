
dataDir = uigetdir();
cd(dataDir)

participants = {'AS' 'AW' 'AX' 'AZ' 'BA' 'BB' 'BD' 'BE' 'BF'};

for iParticipant = 1:length(participants)
    
    currParticipantCode = cell2mat(participants(iParticipant));
    
    %load short duration data
    shortfileDir = fullfile(dataDir, ['lateralLine_shortDuration_', currParticipantCode, '_*']);
    
    shortfilenames = dir(shortfileDir);
    shortfilenames = {shortfilenames.name}; %makes a cell of filenames from the same
    %participant and condition to be loaded together
    
    for iSFiles = 1:length(shortfilenames)
        shortfilenamestr = char(shortfilenames(iSFiles));
        shortDataFile(iSFiles) = load(shortfilenamestr); %loads all of the files to be analysed together
    end
        
    
    %load mid duration data
    midfileDir = fullfile(dataDir, ['lateralLine_midDuration_', currParticipantCode, '_*']);
    
    midfilenames = dir(midfileDir);
    midfilenames = {midfilenames.name}; %makes a cell of filenames from the same
    %participant and condition to be loaded together
    
    for iMFiles = 1:length(midfilenames)
        midfilenamestr = char(midfilenames(iMFiles));
        midDataFile(iMFiles) = load(midfilenamestr); %loads all of the files to be analysed together
    end
    
    
    %load long duration data
    longfileDir = fullfile(dataDir, ['lateralLine_longDuration_', currParticipantCode, '_*']);
    
    longfilenames = dir(longfileDir);
    longfilenames = {longfilenames.name}; %makes a cell of filenames from the same
    %participant and condition to be loaded together
    
    for iLFiles = 1:length(longfilenames)
        longfilenamestr = char(longfilenames(iLFiles));
        longDataFile(iLFiles) = load(longfilenamestr); %loads all of the files to be analysed together
    end
    
    ptbCorgiData{1} = shortDataFile;
    ptbCorgiData{2} = midDataFile;
    ptbCorgiData{3} = longDataFile;
    
    allData(iParticipant).participantData = ptbCorgiData';
    
end


nP = length(participants);
nGroup = 3;

% need to extract nCorrect, nTrials, StimLevels, NumPos and OutOfNum for
% every condition ('group'), for every participant.

for iP = 1:nP
    
    for iGroup = 1:nGroup
        participantData = allData(iP).participantData{iGroup};
        [nCorrect, nTrials] = build2AfcResponseMatrix(participantData.sessionInfo,participantData.experimentData);
        xVal = ([participantData.sessionInfo.conditionInfo(:).velocityDegPerSecSection2]);
        StimLevels(iGroup,:) = xVal;
        NumPos(iGroup,:)   = nCorrect;%nCorrect(condList(sortIdx));
        OutOfNum(iGroup,:) = nTrials;%(condList(sortIdx));
    end
    
    
    %If options for the search aren't specified lets make one up with some
    %heuristics.
    %         %alpha is the offset parameter so lets use a search space that goes
    %         %from the limits of x xaxis.
    %         searchGrid.alpha  = linspace(min(StimLevels),max(StimLevels),101);
    %         %beta corresponds to the slope.  The magnitude of these can be very
    %         %different depending on the chosen psychometric function!
    %         searchGrid.beta   = linspace(0,(30/max(xVal)),101);
    %         %Gamma is the guess rate. Going to set it to 50% for now
    %         searchGrid.gamma  = .03;
    %         %For fitting the lapse rate we'll use a 0 to 6% range.
    %         searchGrid.lambda = linspace(0,.05,61);
    %
    %Now lets do the fit. Returning all results as cell arrays.
    %All outputs here are named consistent with Palamedes naming
    %conventions
    %Consider changing both names and type.
    
    %Define fuller model
    thresholdsfuller = 'unconstrained';  %Each condition gets own threshold
    slopesfuller = 'unconstrained';      %Each condition gets own slope
    guessratesfuller = 'fixed';          %Guess rate fixed
    
    lapseratesfuller = 'fixed';    %Common lapse rate
    %lapseratesfuller = 'fixed';    %Common lapse rate
    lapseFit = 'nAPLE';
    options = PAL_minimize('options'); %options structure containing default
    %This sets the guess rate fixed and lets the offset/slope/lapse rate vary.
    paramsFree = [1 1 0 0];
    PF = @PAL_CumulativeNormal;
    Bmc = 1000;
    lapseLimits = [0 1];        %Range on lapse rates. Will go ignored here
    %since lapse rate is not a free parameter
    maxTries = 4;               %Try each fit at most four times
    rangeTries = [2 1.9 0 0];   %Range of random jitter to apply to initial
    %parameter values on retries of failed fits.
    
    results = struct();
    paramsValues = [10 .5 0 0];
    
    [results.paramsValues, results.LL, results.exitflag, results.output funcParams results.numParams] = ...
        PAL_PFML_FitMultiple(StimLevels, NumPos, OutOfNum, ...
        paramsValues, PF,'searchOptions',options,'lapserates',lapseratesfuller,'thresholds',thresholdsfuller,...
        'slopes',slopesfuller,'guessrates',guessratesfuller,'lapseLimits',[0 0.05],'lapseFit',lapseFit,'gammaeqlambda',1,'searchOptions',options);
    
    %   [TLR pTLR paramsL paramsF TLRSim converged] = ...
    %     PAL_PFLR_ModelComparison(StimLevels, NumPos, OutOfNum, paramsValues, Bmc, ...
    %     PF, 'lesserSlopes','unconstrained','maxTries',maxTries, ...
    %     'rangeTries',rangeTries,'lapseLimits', lapseLimits,'searchOptions',...
    %     options);
    
    
    results3T3S(iP).LL = results.LL;
    results3T3S(iP).numParams = results.numParams;
    n  =  sum(OutOfNum(:));
    results3T3S(iP).n = n;
    results3T3S(iP).BIC       = log(n)*results.numParams - 2*results.LL;
    
    
    %Define fuller model
    thresholdsfuller = 'constrained';  %Each condition gets own threshold
    slopesfuller = 'unconstrained';      %Each condition gets own slope
    guessratesfuller = 'fixed';          %Guess rate fixed
    
    [results.paramsValues, results.LL, results.exitflag, results.output funcParams results.numParams] = ...
        PAL_PFML_FitMultiple(StimLevels, NumPos, OutOfNum, ...
        paramsValues, PF,'searchOptions',options,'lapserates',lapseratesfuller,'thresholds',thresholdsfuller,...
        'slopes',slopesfuller,'guessrates',guessratesfuller,'lapseLimits',[0 0.05],'lapseFit',lapseFit,'gammaeqlambda',1,'searchOptions',options);
    
    
    results1T3S(iP).LL = results.LL;
    results1T3S(iP).numParams = results.numParams;
    n  =  sum(OutOfNum(:));
    results1T3S(iP).n = n;
    results1T3S(iP).BIC       = log(n)*results.numParams - 2*results.LL;
    
    %Define fuller model
    thresholdsfuller = 'unconstrained';  %Each condition gets own threshold
    slopesfuller = 'constrained';      %Each condition gets own slope
    guessratesfuller = 'fixed';          %Guess rate fixed
    
    [results.paramsValues, results.LL, results.exitflag, results.output funcParams results.numParams] = ...
        PAL_PFML_FitMultiple(StimLevels, NumPos, OutOfNum, ...
        paramsValues, PF,'searchOptions',options,'lapserates',lapseratesfuller,'thresholds',thresholdsfuller,...
        'slopes',slopesfuller,'guessrates',guessratesfuller,'lapseLimits',[0 0.05],'lapseFit',lapseFit,'gammaeqlambda',1,'searchOptions',options);
    
    
    results3T1S(iP).LL = results.LL;
    results3T1S(iP).numParams = results.numParams;
    n  =  sum(OutOfNum(:));
    results3T1S(iP).n = n;
    results3T1S(iP).BIC       = log(n)*results.numParams - 2*results.LL;
    %Define fuller model
    thresholdsfuller = 'constrained';  %Each condition gets own threshold
    slopesfuller = 'constrained';      %Each condition gets own slope
    guessratesfuller = 'fixed';          %Guess rate fixed
    
    [results.paramsValues, results.LL, results.exitflag, results.output funcParams results.numParams] = ...
        PAL_PFML_FitMultiple(StimLevels, NumPos, OutOfNum, ...
        paramsValues, PF,'searchOptions',options,'lapserates',lapseratesfuller,'thresholds',thresholdsfuller,...
        'slopes',slopesfuller,'guessrates',guessratesfuller,'lapseLimits',[0 0.05],'lapseFit',lapseFit,'gammaeqlambda',1,'searchOptions',options);
    
    
    results1T1S(iP).LL = results.LL;
    results1T1S(iP).numParams = results.numParams;
    n  =  sum(OutOfNum(:));
    results1T1S(iP).n = n;
    results1T1S(iP).BIC       = log(n)*results.numParams - 2*results.LL;
    
end



