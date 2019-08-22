%BIC model comparisons - negative numbers mean evidence for speed only

% alpha (weber) change = duration
%beta (PSE) change = distance

%model1
%[constrained alpha and constrained beta] - [constrained alpha and
%unconstrained beta]
%speed only - speed + distance
%negative = evidence for speed only, positive = evidence for speed +
%distance
model1 =  [-12.5984  -12.8444  -11.6642   -2.1060  -11.7868  -12.4345  -11.8099  -12.4830  -11.2807]';

%model2
%[constrained alpha and constrained beta] - [unconstrained alpha and
%constrained beta]
%speed only - speed + duration
%negative = evidence for speed only, positive = evidence for speed +
%duration
model2 =  [-6.8675   -0.1900  -12.5698   -8.9707  -11.3728  -10.7752  -10.6775  -12.0765  -11.0494]';

%model3
%%[constrained alpha and constrained beta] - [unconstrained alpha and
%unconstrained beta]
%speed only - speed + distance + duration
%negative = evidence for speed only, positive = evidence for speed +
%distance + duration
model3 =  [-18.7245  -12.3059  -24.1719   -8.5709  -23.4457  -22.8703  -22.8378  -24.5550  -21.9571]';

allmodels = [model1, model2, model3];

boxplot(allmodels)
set(gca,'fontsize',8)
xlabel('Model comparison', 'fontsize',12);
ylabel('Bayes Factor', 'fontsize',12);
set(gca, 'XTickLabel',{'Speed only - speed & distance', 'Speed only - speed & duration', 'speed only - all cues'});


 set(gcf, 'PaperUnits', 'inches');
 x_width=6;
 y_width=5;
 set(gcf, 'PaperPosition', [0 0 x_width y_width]); %
 saveas(gcf,'modelBoxPlot.pdf');