
%load data
%ptbCorgiData = uiGetPtbCorgiData();
% loadGroupedData;
% ptbCorgiData{1} = ptbCorgiDataShort;
% ptbCorgiData{2} = ptbCorgiDataMid;
% ptbCorgiData{3} = ptbCorgiDataLong;

nP = ptbCorgiDataShort.nParticipants
nGroup = 3;

for iP = 1:nP,
    
    for iGroup = 1:nGroup,
        participantData = ptbCorgiData{iGroup}.participantData(iP);
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



