%BIC model comparisons - negative numbers mean evidence for speed only
%BIC values are HARD CODED - extracted from BICpsychometricAnalysis

% c = constrained
% u = unconstrained
% f = fixed

% alpha beta gamma lambda

%ccff %speed only
speedOnlyBIC = [350.412458665384;290.742203241341;474.326788158224;306.274977760802;316.783268739827;386.836580550426;320.346446839125;571.591409708810;312.579707907907];

%cuff %old speed + duration
cuffBIC = [363.010842523389;303.586628569471;485.990962428701;308.381006417365;328.570038024243;399.271113127660;332.156374510745;584.074458856142;323.860425143544];

cuffBF = speedOnlyBIC - cuffBIC;

cuffMedian = median(cuffBF);

%ucff %old speed + distance

ucffBIC = [357.279948718516;290.932174482721;486.896612910260;315.245656037475;328.156044625275;397.611761224530;331.023897724428;583.667936499769;323.629098189190];

ucffBF = speedOnlyBIC - ucffBIC;

ucffMedian = median(ucffBF);

%uuff % old all cues

uuffBIC = [369.136925653134;303.048146736926;498.498709680581;314.845895905232;340.228981332447;409.706895710113;343.184246800597;596.146386685132;334.536848741735];

uuffBF = speedOnlyBIC - uuffBIC;

uuffMedian = median(uuffBF);

%ccuu %new "speed + duration"

ccuuBIC = [374.259612659398;329.348956114280;505.795803455780;336.613644057034;355.277472388719;412.242396792595;354.930590047601;610.125846471224;342.415840882894];

ccuuBF = speedOnlyBIC - ccuuBIC;

ccuuMedian = median(ccuuBF);

%cuuu

cuuuBIC = [387.350241714168;342.459330477673;520.699736388739;346.946337795798;367.652208774785;423.551052155132;364.872088496357;621.391243788967;355.378612392839];

cuuuBF = speedOnlyBIC - cuuuBIC;

cuuuMedian = median(cuuuBF);

%ucuu %new "all cues"

ucuuBIC = [392.400960642495;329.701577742042;523.795060742336;347.794569852047;366.946531996028;424.265321489204;363.704701113353;621.434539460026;353.286506646012];

ucuuBF = speedOnlyBIC - ucuuBIC;

ucuuMedian = median(ucuuBF);

%uuuu

uuuuBIC = [403.889409030460;354.501299282209;530.176571630432;349.007918868211;378.548190410088;435.012956593382;370.282922474944;631.713054225865;363.768395219697];

uuuuBF = speedOnlyBIC - uuuuBIC;

uuuuMedian = median(uuuuBF);


%figure

allmodels = [cuffBF, ucffBF, uuffBF, ccuuBF, cuuuBF, ucuuBF, uuuuBF];

boxplot(allmodels)
set(gca,'fontsize',8)
xlabel('Comparison with speed only model', 'fontsize',12);
ylabel('Bayes Factor', 'fontsize',12);
set(gca, 'XTickLabel',{'cuff', 'ucff', 'uuff', 'ccuu', 'cuuu', 'ucuu', 'uuuu'});


 set(gcf, 'PaperUnits', 'inches');
 x_width=6;
 y_width=5;
 set(gcf, 'PaperPosition', [0 0 x_width y_width]); %
 saveas(gcf,'newerModelBoxPlot.pdf');