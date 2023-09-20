% EAS 4810C Lab 1
% Monte Carlo sim for uncertainty in K and plot generation

%% Monte Carlo for K uncertainty

clc; clear; close all;

dP =   [0.012713
        0.090734
        0.201955
        0.339457
        0.508927
        0.707832
        0.937834
        1.196545
        1.492607
        1.815586
        2.172384
        2.563000
        2.984124
        3.435831
        3.913188
        4.416874
        4.950815
        5.505709
        6.086506];

UdP =  [0.001971
        0.001927
        0.001957
        0.001889
        0.001861
        0.001887
        0.001976
        0.001938
        0.001969
        0.001914
        0.002032
        0.001975
        0.002020
        0.001956
        0.001981
        0.002012
        0.001990
        0.001990
        0.002057];

q =   [-0.033754
       -0.005299
        0.041000
        0.106957
        0.192977
        0.300693
        0.427998
        0.579162
        0.752444
        0.946798
        1.169706
        1.412288
        1.681641
        1.972378
        2.286226
        2.620044
        2.981083
        3.356923
        3.753616];

Uq =   [0.001908
        0.001996
        0.001887
        0.001993
        0.001909
        0.001930
        0.002762
        0.001891
        0.001978
        0.001904
        0.002061
        0.002064
        0.001978
        0.002037
        0.001986
        0.002019
        0.002015
        0.002028
        0.002017];

plotFigure = true;

coeff = polyfit(dP,q,1);
originalSlope = coeff(1)
numPts = 10000;

% Use parfor to speed up computation if necessary
for i = 1:numPts
    xptemp = zeros(1, length(dP));
    yptemp = zeros(1, length(dP));
    for j = 1:length(dP)
        xptemp(j) = norminv(rand,dP(j),UdP(j)/2);
        yptemp(j) = norminv(rand,q(j),Uq(j)/2);
    end
    coeff = polyfit(xptemp,yptemp,1);
    slope(i) = coeff(1);
    dPp(i,:) = xptemp;
    qp(i,:) = yptemp;
end

avgSlope = mean(slope)
stdDevSlope = std(slope)
uncertainty = 1.96*(stdDevSlope/sqrt(numPts))

if plotFigure
    figure;
    ax = gca;
    hold on;
    plot(dP,q,'--ro',...
        'LineWidth',2,...
        'MarkerSize',7.5,...
        'MarkerEdgeColor','k',...
        'MarkerFaceColor','r');
    
    xlabel('$dP$ (inH_2O)')
    ylabel('$q$ (inH_2O)')

    for i = 1:10
        p(i,:) = polyfit(dPp(i,:),qp(i,:),1);
        trend(i,:) = polyval(p(i,:),dP);
        plot(dP,trend(i,:),'k');
    end
    grid on;
end
matlab2tikz('monte.tex','height','\fheight','width','\fwidth')

% Calculation of K

K = -(1 - originalSlope)/originalSlope
UK = uncertainty/originalSlope^2

%% Plot dP vs q

clc; clear; close all;

dP =   [0.012713
        0.090734
        0.201955
        0.339457
        0.508927
        0.707832
        0.937834
        1.196545
        1.492607
        1.815586
        2.172384
        2.563000
        2.984124
        3.435831
        3.913188
        4.416874
        4.950815
        5.505709
        6.086506];

q =   [-0.033754
       -0.005299
        0.041000
        0.106957
        0.192977
        0.300693
        0.427998
        0.579162
        0.752444
        0.946798
        1.169706
        1.412288
        1.681641
        1.972378
        2.286226
        2.620044
        2.981083
        3.356923
        3.753616];

% Convert to Pa
%dP = dP * 249.0889;
%q = q * 249.0889;
    
coeff = polyfit(dP,q,1);
trend = polyval(coeff,dP);
    
figure;
c = '#A6A6A6';
hold on;
plot(dP,q,'k.','MarkerSize',20);
plot(dP,trend,'Color',c,'LineWidth',2.5);
xlabel('P_{amb} - P_{ts} (inH_2O)')
ylabel('q_{ts} (inH_2O)')
grid on;
box off;
matlab2tikz('dataPlot.tex','height','\fheight','width','\fwidth')

%% Plot transducer calibration curve

clc; clear; close all;

Pman = [-3.4
        -1.3
        -3.6
        -2.1
        -3.5
         3.0
         3.6
         4.0
         3.6
         2.4];

Pind = [-3.405
        -1.460
        -3.613
        -2.217
        -3.512
         3.002
         3.586
         3.922
         3.667
         2.370];

% Convert to Pa
%Pman = Pman * 249.0889;
%Pind = Pind * 249.0889;
    
coeff = polyfit(Pman,Pind,1);
trend = polyval(coeff,Pman);
    
figure;
c = '#A6A6A6';
hold on;
plot(Pman,Pind,'k.','MarkerSize',20);
plot(Pman,trend,'Color',c,'LineWidth',2.5);
xlabel('P_{man} (inH_2O)')
ylabel('P_{ind} (inH_2O)')
grid on;
box off;
matlab2tikz('calibration.tex','height','\fheight','width','\fwidth')

%% Plot velocity profile

clc; clear; close all;

pos = [1.5 3 4.5 6 7.5 9 10.5];

front = [20.09649115	22.01206383	22.01197829	21.96238566	21.99520315	22.05322900	22.06480624];

back = [16.31081300	22.32169196	22.29623036	22.30278936	22.35630252	22.42566381	22.63432919];

% Correct position
pos = pos - 1.5;

figure;
hold on;
plot(front,pos,'r.','MarkerSize',20);
plot(back,pos,'b.','MarkerSize',20);
ylim([0 10])
legend({'Front', 'Back'},'Location','northwest');
xlabel('Flow Speed (m/s)')
ylabel('Pitot Tube Position (in)')
ylim([0,12])
xlim([0,25])
grid on;
box off;
matlab2tikz('vProfile.tex','height','\fheight','width','\fwidth')

%% Plot velocity vs fan speed

clc; clear; close all;

fan =  [10
        12.5
        15
        17.5
        20
        22.5
        25
        27.5
        30
        32.5
        35
        37.5
        40
        42.5
        45
        47.5
        50];

spd =  [6.86
        8.67
        10.56
        12.54
        14.54
        16.60
        18.68
        20.77
        22.94
        25.08
        27.27
        29.44
        31.62
        33.79
        35.98
        38.14
        40.28];
    
coeff = polyfit(fan,spd,1);
trend = polyval(coeff,fan);
    
figure;
c = '#A6A6A6';
hold on;
plot(fan,spd,'k.','MarkerSize',20);
plot(fan,trend,'Color',c,'LineWidth',2.5);
xlabel('Fan Setting (Hz)')
xlim([0,50])
ylabel('Flow Speed (m/s)')
ylim([0,45])
grid on;
box off;
matlab2tikz('fanVsSpd.tex','height','\fheight','width','\fwidth')