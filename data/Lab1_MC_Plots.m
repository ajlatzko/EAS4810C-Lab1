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

plotFigure = false;

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
        'MarkerSize',15,...
        'MarkerEdgeColor','k',...
        'MarkerFaceColor','r');

    for i = 1:10
        p(i,:) = polyfit(dPp(i,:),qp(i,:),1);
        trend(i,:) = polyval(p(i,:),dP);
        plot(dP,trend(i,:),'k');
    end
    grid on;
end

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

coeff = polyfit(dP,q,1);
trend = polyval(coeff,dP);
    
figure;
c = '#A6A6A6';
hold on;
plot(dP,q,'k.','MarkerSize',20);
plot(dP,trend,'Color',c,'LineWidth',2.5);
xlabel('dP')
ylabel('q')
grid on;
box off;
set(gca,'fontname','times');