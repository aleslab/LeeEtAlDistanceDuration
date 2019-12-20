
dataDir = uigetdir();
cd(dataDir)

participants = {'AS' 'AW' 'AX' 'AZ' 'BA' 'BB' 'BD' 'BE' 'BF'};

for iParticipant = 1:length(participants)
    
    currParticipantCode = cell2mat(participants(iParticipant));
    
  
    %load short duration data
    shortfileDir = fullfile(dataDir, ['lateralLine_shortDuration_', currParticipantCode, '_*']);
    
    shortfilenames = dir(shortfileDir);
    
    if isempty(shortfilenames)
        error(['Cannot find files ' shortfileDir ])
    end
    
    shortfilenames = {shortfilenames.name}; %makes a cell of filenames from the same
    %participant and condition to be loaded together
    
    for iSFiles = 1:length(shortfilenames)
        shortfilenamestr = char(shortfilenames(iSFiles));
        shortDataFile(iSFiles) = load(shortfilenamestr); %loads all of the files to be analysed together
    end
        
    shortExperimentData = [shortDataFile.experimentData]; %all of the experiment data in one combined struct
    allShortSessionInfo = shortDataFile.sessionInfo; %all of the session info data in one combined struct
    shortResponseTable = struct2table(shortExperimentData);
    
        %excluding invalid trials
    validshortData = ~(shortResponseTable.validTrial == 0); %creates a logical of which trials in the data table were valid
    validshortResponses = shortResponseTable.response(validshortData); %
    validshortCondNumber = shortResponseTable.condNumber(validshortData);
    
    %converting the j and f responses into a logical. J = it got faster.
    shortFRespCell = strfind(validshortResponses, 'f');
    shortJResponses = cellfun('isempty', shortFRespCell); %creates a logical where j responses are 1s and f responses are 0
    
    %need number of it got faster responses for each condition
    %need row vector of how many trials there were for each condition
    
    shortFasterResponses = validshortCondNumber(shortJResponses);
    allConds = unique(validshortCondNumber);
    
    shortNumPos = histc(shortFasterResponses, allConds)'; %the number of it got faster responses for each level in the short duration condition
    shortOutOfNum = histc(validshortCondNumber,allConds)'; %the number of trials in each level in the short duration condition 
    
    
    %load mid duration data
    midfileDir = fullfile(dataDir, ['lateralLine_midDuration_', currParticipantCode, '_*']);
    
    midfilenames = dir(midfileDir);
    midfilenames = {midfilenames.name}; %makes a cell of filenames from the same
    %participant and condition to be loaded together
    
    for iMFiles = 1:length(midfilenames)
        midfilenamestr = char(midfilenames(iMFiles));
        midDataFile(iMFiles) = load(midfilenamestr); %loads all of the files to be analysed together
    end
    
        midExperimentData = [midDataFile.experimentData]; %all of the experiment data in one combined struct
    allMidSessionInfo = midDataFile.sessionInfo; %all of the session info data in one combined struct
    midResponseTable = struct2table(midExperimentData);
    
        %excluding invalid trials
    validmidData = ~(midResponseTable.validTrial == 0); %creates a logical of which trials in the data table were valid
    validmidResponses = midResponseTable.response(validmidData); %
    validmidCondNumber = midResponseTable.condNumber(validmidData);
    
    %converting the j and f responses into a logical. J = it got faster.
    midFRespCell = strfind(validmidResponses, 'f');
    midJResponses = cellfun('isempty', midFRespCell); %creates a logical where j responses are 1s and f responses are 0
    
    %need number of it got faster responses for each condition
    %need row vector of how many trials there were for each condition
    
    midFasterResponses = validmidCondNumber(midJResponses);
    allConds = unique(validmidCondNumber);
    
    midNumPos = histc(midFasterResponses, allConds)'; %the number of it got faster responses for each level in the mid duration condition
    midOutOfNum = histc(validmidCondNumber,allConds)'; %the number of trials in each level in the mid duration condition
    
     
    %load long duration data
    longfileDir = fullfile(dataDir, ['lateralLine_longDuration_', currParticipantCode, '_*']);
    
    longfilenames = dir(longfileDir);
    longfilenames = {longfilenames.name}; %makes a cell of filenames from the same
    %participant and condition to be loaded together
    
    for iLFiles = 1:length(longfilenames)
        longfilenamestr = char(longfilenames(iLFiles));
        longDataFile(iLFiles) = load(longfilenamestr); %loads all of the files to be analysed together
    end
    
    longExperimentData = [longDataFile.experimentData]; %all of the experiment data in one combined struct
    allLongSessionInfo = longDataFile.sessionInfo; %all of the session info data in one combined struct
    longResponseTable = struct2table(longExperimentData);
    
        %excluding invalid trials
    validlongData = ~(longResponseTable.validTrial == 0); %creates a logical of which trials in the data table were valid
    validlongResponses = longResponseTable.response(validlongData); %
    validlongCondNumber = longResponseTable.condNumber(validlongData);
    
    %converting the j and f responses into a logical. J = it got faster.
    longFRespCell = strfind(validlongResponses, 'f');
    longJResponses = cellfun('isempty', longFRespCell); %creates a logical where j responses are 1s and f responses are 0
    
    %need number of it got faster responses for each condition
    %need row vector of how many trials there were for each condition
    
    longFasterResponses = validlongCondNumber(longJResponses);
    allConds = unique(validlongCondNumber);
    
    longNumPos = histc(longFasterResponses, allConds)'; %the number of it got faster responses for each level in the long duration condition
    longOutOfNum = histc(validlongCondNumber,allConds)'; %the number of trials in each level in the long duration condition

StimLevels = repmat([6.70320000000000 7.65930000000000 8.75170000000000 10 11.4263000000000 13.0561000000000 14.9182000000000], 3,1);
NumPos = vertcat(shortNumPos, midNumPos, longNumPos);
OutOfNum = vertcat(shortOutOfNum, midOutOfNum, longOutOfNum);
    
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
    
    
    results3T3S(iParticipant).LL = results.LL;
    results3T3S(iParticipant).numParams = results.numParams;
    n  =  sum(OutOfNum(:));
    results3T3S(iParticipant).n = n;
    results3T3S(iParticipant).BIC       = log(n)*results.numParams - 2*results.LL;
    
    
    %Define fuller model %cuff
    thresholdsfuller = 'constrained';  %Each condition gets own threshold
    slopesfuller = 'unconstrained';      %Each condition gets own slope
    guessratesfuller = 'fixed';          %Guess rate fixed
    
    [results.paramsValues, results.LL, results.exitflag, results.output funcParams results.numParams] = ...
        PAL_PFML_FitMultiple(StimLevels, NumPos, OutOfNum, ...
        paramsValues, PF,'searchOptions',options,'lapserates',lapseratesfuller,'thresholds',thresholdsfuller,...
        'slopes',slopesfuller,'guessrates',guessratesfuller,'lapseLimits',[0 0.05],'lapseFit',lapseFit,'gammaeqlambda',1,'searchOptions',options);
    
    
    results1T3S(iParticipant).LL = results.LL;
    results1T3S(iParticipant).numParams = results.numParams;
    n  =  sum(OutOfNum(:));
    results1T3S(iParticipant).n = n;
    results1T3S(iParticipant).BIC       = log(n)*results.numParams - 2*results.LL;
    
    %Define fuller model
    thresholdsfuller = 'unconstrained';  %Each condition gets own threshold
    slopesfuller = 'constrained';      %Each condition gets own slope
    guessratesfuller = 'fixed';          %Guess rate fixed
    
    [results.paramsValues, results.LL, results.exitflag, results.output funcParams results.numParams] = ...
        PAL_PFML_FitMultiple(StimLevels, NumPos, OutOfNum, ...
        paramsValues, PF,'searchOptions',options,'lapserates',lapseratesfuller,'thresholds',thresholdsfuller,...
        'slopes',slopesfuller,'guessrates',guessratesfuller,'lapseLimits',[0 0.05],'lapseFit',lapseFit,'gammaeqlambda',1,'searchOptions',options);
    
    
    results3T1S(iParticipant).LL = results.LL;
    results3T1S(iParticipant).numParams = results.numParams;
    n  =  sum(OutOfNum(:));
    results3T1S(iParticipant).n = n;
    results3T1S(iParticipant).BIC       = log(n)*results.numParams - 2*results.LL;
    %Define fuller model
    thresholdsfuller = 'constrained';  %Each condition gets own threshold
    slopesfuller = 'constrained';      %Each condition gets own slope
    guessratesfuller = 'fixed';          %Guess rate fixed
    
    [results.paramsValues, results.LL, results.exitflag, results.output funcParams results.numParams] = ...
        PAL_PFML_FitMultiple(StimLevels, NumPos, OutOfNum, ...
        paramsValues, PF,'searchOptions',options,'lapserates',lapseratesfuller,'thresholds',thresholdsfuller,...
        'slopes',slopesfuller,'guessrates',guessratesfuller,'lapseLimits',[0 0.05],'lapseFit',lapseFit,'gammaeqlambda',1,'searchOptions',options);
    
    
    results1T1S(iParticipant).LL = results.LL;
    results1T1S(iParticipant).numParams = results.numParams;
    n  =  sum(OutOfNum(:));
    results1T1S(iParticipant).n = n;
    results1T1S(iParticipant).BIC       = log(n)*results.numParams - 2*results.LL;
    
    %Add a bit of x offset to make things visible
   
    x = linspace(6,15,100);
%     figure;hold on;
%           y = PAL_CumulativeNormal(results.paramsValues(i,:),x);
%         plot(x,y,'k--','linewidth',2)
%     for i=1:3,
%         
%         %Dray psychometric fit. 
%   
%         set(gca,'ColorOrderIndex',i); %Set the color order index so colors match on plots  
%         
%         %drww data
%         nTrials = OutOfNum(i,:);
%         percentCorrect = NumPos(i,:)./OutOfNum(i,:);
%         lowerCi = percentCorrect - binoinv(.025,OutOfNum(i,:),percentCorrect)./OutOfNum(i,:);
%         upperCi = binoinv(.975,nTrials,percentCorrect)./OutOfNum(i,:) - percentCorrect;
%         xJit = (i-2)/10; %Add a little x offset for visibility of markers. 
%         errorbarHandle=errorbar(StimLevels(i,:)+xJit,percentCorrect,lowerCi,upperCi,'o','markersize',10,'linewidth',2);
%              
%        
%     end
    box(gca,'off');
    
    legendItems = findobj(gca,'type','errorbar'); %Choose the error bar plot to make a legend for
    legend(legendItems,'short','mid','long'); %I think this is right order. 
    
     %Define fuller model
    thresholdsfuller = 'constrained';  %Each condition gets own threshold
    slopesfuller = 'constrained';      %Each condition gets own slope
    guessratesfuller = 'unconstrained';          %Guess rate fixed
    lapseratesfuller= 'unconstrained';
    [results.paramsValues, results.LL, results.exitflag, results.output funcParams results.numParams] = ...
        PAL_PFML_FitMultiple(StimLevels, NumPos, OutOfNum, ...
        paramsValues, PF,'searchOptions',options,'lapserates',lapseratesfuller,'guessLimits',[0 1],'thresholds',thresholdsfuller,...
        'slopes',slopesfuller,'guessrates',guessratesfuller,'lapseLimits',[0 1],'lapseFit',lapseFit,'gammaeqlambda',false,'searchOptions',options);
    
    
    resultsDur(iParticipant).LL = results.LL;
    resultsDur(iParticipant).numParams = results.numParams;
    n  =  sum(OutOfNum(:));
    resultsDur(iParticipant).n = n;
    resultsDur(iParticipant).BIC       = log(n)*results.numParams - 2*results.LL;
    
         %Define fuller model
    thresholdsfuller = 'unconstrained';  %Each condition gets own threshold
    slopesfuller = 'constrained';      %Each condition gets own slope
    guessratesfuller = 'unconstrained';          %Guess rate fixed
    lapseratesfuller= 'unconstrained';
    [results.paramsValues, results.LL, results.exitflag, results.output funcParams results.numParams] = ...
        PAL_PFML_FitMultiple(StimLevels, NumPos, OutOfNum, ...
        paramsValues, PF,'searchOptions',options,'lapserates',lapseratesfuller,'guessLimits',[0 1], 'thresholds',thresholdsfuller,...
        'slopes',slopesfuller,'guessrates',guessratesfuller,'lapseLimits',[0 1],'lapseFit',lapseFit,'gammaeqlambda',false,'searchOptions',options);
    
    
    resultsDurDistSpeed(iParticipant).LL = results.LL;
    resultsDurDistSpeed(iParticipant).numParams = results.numParams;
    n  =  sum(OutOfNum(:));
    resultsDurDistSpeed(iParticipant).n = n;
    resultsDurDistSpeed(iParticipant).BIC       = log(n)*results.numParams - 2*results.LL;
    resultsDurDistSpeed(iParticipant).paramsValues       = results.paramsValues;
    

        x = linspace(6,15,100);
    
%     for i=1:3,      
%         set(gca,'ColorOrderIndex',i); %Set the color order index so colors match on plots  
%         %Dray psychometric fit. 
%         y = PAL_CumulativeNormal(results.paramsValues(i,:),x);
%         plot(x,y,'linewidth',2)        
%                 
%     end
%     
    
         %Define fuller model
    thresholdsfuller = 'unconstrained';  %Each condition gets own threshold
    slopesfuller = 'unconstrained';      %Each condition gets own slope
    guessratesfuller = 'unconstrained';          %Guess rate fixed
    lapseratesfuller= 'unconstrained';
    [results.paramsValues, results.LL, results.exitflag, results.output funcParams results.numParams] = ...
        PAL_PFML_FitMultiple(StimLevels, NumPos, OutOfNum, ...
        paramsValues, PF,'searchOptions',options,'lapserates',lapseratesfuller,'guessLimits',[0 1], 'thresholds',thresholdsfuller,...
        'slopes',slopesfuller,'guessrates',guessratesfuller,'lapseLimits',[0 1],'lapseFit',lapseFit,'gammaeqlambda',false,'searchOptions',options);
    
    
    resultsAllUncon(iParticipant).LL = results.LL;
    resultsAllUncon(iParticipant).numParams = results.numParams;
    n  =  sum(OutOfNum(:));
    resultsAllUncon(iParticipant).n = n;
    resultsAllUncon(iParticipant).BIC       = log(n)*results.numParams - 2*results.LL;
    resultsAllUncon(iParticipant).paramsValues       = results.paramsValues;
    
 %Define fuller model
    thresholdsfuller = 'constrained';  %Each condition gets own threshold
    slopesfuller = 'unconstrained';      %Each condition gets own slope
    guessratesfuller = 'unconstrained';          %Guess rate fixed
    lapseratesfuller= 'unconstrained';
    [results.paramsValues, results.LL, results.exitflag, results.output funcParams results.numParams] = ...
        PAL_PFML_FitMultiple(StimLevels, NumPos, OutOfNum, ...
        paramsValues, PF,'searchOptions',options,'lapserates',lapseratesfuller,'guessLimits',[0 1], 'thresholds',thresholdsfuller,...
        'slopes',slopesfuller,'guessrates',guessratesfuller,'lapseLimits',[0 1],'lapseFit',lapseFit,'gammaeqlambda',false,'searchOptions',options);
    
    
    resultscuuu(iParticipant).LL = results.LL;
    resultscuuu(iParticipant).numParams = results.numParams;
    n  =  sum(OutOfNum(:));
    resultscuuu(iParticipant).n = n;
    resultscuuu(iParticipant).BIC       = log(n)*results.numParams - 2*results.LL;
    resultscuuu(iParticipant).paramsValues       = results.paramsValues;
    



end

%Bayes factor for duration vs. 1T1S (e.g. just speed)
%[results1T1S.BIC]-[resultsDur.BIC]

%Bayes factor for full model with duration distance and speed, vs just
%speed
%[results1T1S.BIC]-[resultsDurDistSpeed.BIC]


