%Przedmiot: Geomatyka Górnicza (GIS)
%Temat: "Temat 10 - Filtrowanie roślinności/klasyfikacja chmur punktów”
%Autorzy: Tymoteusz Maj, Hubert Dębowski
%Numery albumu: 401370, 407955
%Kierunek: Geoinformacja, semestr 6

%% Wyczyszczenie środowiska
clc;
clear;

%% Wczytanie chmur punktów
fileName = 'ZIEM_202210_CLOUD.laz';
lasReader = lasFileReader(fileName);
ptCloud = readPointCloud(lasReader);

%% Rozrzedzenie chmury
gridStep = 0.2;
ptCloudOut = pcdownsample(ptCloud, 'gridAverage', gridStep);

%% Wyswietlenie chmury
pcshow(ptCloudOut)

%% Podzial chmury na skladowe
x= ptCloudOut.Location(:,1);
y= ptCloudOut.Location(:,2);
z= ptCloudOut.Location(:,3);

%% zmiana na klasie single z unit16 i normalizacja
R = single(ptCloudOut.Color(:,1))/2^16;
G = single(ptCloudOut.Color(:,2))/2^16;
B = single(ptCloudOut.Color(:,3))/2^16;

%% obliczenia wymaganych skladowych
rr = R./(R+G+B);
gg = G./(R+G+B);
bb = B./(R+G+B);

%% Obliczenie indexów
%GB diff 
indexGB = (G-B)./(R+G+B);

%% ExB
indexExB = 2*gg-rr-bb;%nwm czy to jest dobrze

%% ExB classification
min(indexExB)
mean(indexExB)
median(indexExB)
max(indexExB)

%% Threshold
% Define a threshold for each class
waterThresholdMin = -0.6;
waterThresholdMax = -0.4;

builtUpThresholdMin = -0.30;
builtUpThresholdMax = 0.04;

dryVegetationThresholdMin = 0.061;
dryVegetationThresholdMax = 0.09;

healthyVegetationThresholdMin = 0.1;
healthyVegetationThresholdMax = 0.83;

% Create a mask for each class
water = indexExB >= waterThresholdMin & indexExB < waterThresholdMax;
builtUp = indexExB >= builtUpThresholdMin & indexExB < builtUpThresholdMax;
dryVegetation = indexExB >= dryVegetationThresholdMin & indexExB < dryVegetationThresholdMax;
healthyVegetation = indexExB >= healthyVegetationThresholdMin & indexExB < healthyVegetationThresholdMax;


%% Wyswietl 
ptCloudFilt = select(ptCloudOut, water);
ptCloudFilt.Color(:,1)=0;
ptCloudFilt.Color(:,1)=0;
pcshow(ptCloudFilt)

hold on 

ptCloudFilt = select(ptCloudOut, builtUp);
ptCloudFilt.Color(:,2)=0;
ptCloudFilt.Color(:,3)=0;
pcshow(ptCloudFilt)

hold on 
ptCloudFilt = select(ptCloudOut, dryVegetation);
ptCloudFilt.Color(:,3)=0;
ptCloudFilt.Color(:,3)=0;
pcshow(ptCloudFilt)

hold on 
ptCloudFilt = select(ptCloudOut, healthyVegetation);
ptCloudFilt.Color(:,1)=0;
ptCloudFilt.Color(:,3)=0;
pcshow(ptCloudFilt)

%% Classification statistics
clound_length = size(healthyVegetation);
water_percent = (sum(water)/clound_length(1, 1))*100;
builtUp_percent = (sum(builtUp)/clound_length(1, 1))*100;
dryVegetation_percent = (sum(dryVegetation)/clound_length(1, 1))*100;
healthyVegetation_percent = (sum(healthyVegetation)/clound_length(1, 1))*100;
correct_classification = water_percent+builtUp_percent+dryVegetation_percent+healthyVegetation_percent;
without_classification = 100 - correct_classification;


fprintf('Water: %.2f%% \n', water_percent);
fprintf('Built up: %.2f%% \n', builtUp_percent);
fprintf('Dry vegetation: %.2f%% \n', dryVegetation_percent);
fprintf('Healthy vegetation: %.2f%% \n', healthyVegetation_percent);
fprintf('Sum of correct classification: %.2f%% \n', correct_classification);
fprintf('Without classification: %.2f%% \n', without_classification);

%% GLI
indexGLI = (2*G-R-B)./(2*G+R+B);

%% GLI classification
min(indexGLI)
mean(indexGLI)
median(indexGLI)
max(indexGLI)

%% Threshold
% Define a threshold for each class
waterThresholdMin = -0.6;
waterThresholdMax = -0.45;

builtUpThresholdMin = -0.44;
builtUpThresholdMax = 0.035;

dryVegetationThresholdMin = 0.036;
dryVegetationThresholdMax = 0.15;

healthyVegetationThresholdMin = 0.16;
healthyVegetationThresholdMax = 0.52;

% Create a mask for each class
water = indexGLI >= waterThresholdMin & indexGLI < waterThresholdMax;
builtUp = indexGLI >= builtUpThresholdMin & indexGLI < builtUpThresholdMax;
dryVegetation = indexGLI >= dryVegetationThresholdMin & indexGLI < dryVegetationThresholdMax;
healthyVegetation = indexGLI >= healthyVegetationThresholdMin & indexGLI < healthyVegetationThresholdMax;

%% Wyswietl 
ptCloudFilt = select(ptCloudOut, water);
ptCloudFilt.Color(:,1)=0;
ptCloudFilt.Color(:,1)=0;
pcshow(ptCloudFilt)

hold on 

ptCloudFilt = select(ptCloudOut, builtUp);
ptCloudFilt.Color(:,2)=0;
ptCloudFilt.Color(:,3)=0;
pcshow(ptCloudFilt)

hold on 
ptCloudFilt = select(ptCloudOut, dryVegetation);
ptCloudFilt.Color(:,3)=0;
ptCloudFilt.Color(:,3)=0;
pcshow(ptCloudFilt)

hold on 
ptCloudFilt = select(ptCloudOut, healthyVegetation);
ptCloudFilt.Color(:,1)=0;
ptCloudFilt.Color(:,3)=0;
pcshow(ptCloudFilt)

%% Classification statistics
clound_length = size(healthyVegetation);
water_percent = (sum(water)/clound_length(1, 1))*100;
builtUp_percent = (sum(builtUp)/clound_length(1, 1))*100;
dryVegetation_percent = (sum(dryVegetation)/clound_length(1, 1))*100;
healthyVegetation_percent = (sum(healthyVegetation)/clound_length(1, 1))*100;
correct_classification = water_percent+builtUp_percent+dryVegetation_percent+healthyVegetation_percent;
without_classification = 100 - correct_classification;


fprintf('Water: %.2f%% \n', water_percent);
fprintf('Built up: %.2f%% \n', builtUp_percent);
fprintf('Dry vegetation: %.2f%% \n', dryVegetation_percent);
fprintf('Healthy vegetation: %.2f%% \n', healthyVegetation_percent);
fprintf('Sum of correct classification: %.2f%% \n', correct_classification);
fprintf('Without classification: %.2f%% \n', without_classification);

%% CIVE
indexCIVE = 0.4412*rr-0.811*gg+0.385*bb+18.78745;


%% Threshold
% Define a threshold for each class
waterThresholdMin = 18.40;
waterThresholdMax = 18.55;

builtUpThresholdMin = 18.79;
builtUpThresholdMax = 19.30;

dryVegetationThresholdMin = 18.70;
dryVegetationThresholdMax = 18.75;

healthyVegetationThresholdMin = 18.5;
healthyVegetationThresholdMax = 18.70;

% Create a mask for each class
water = indexCIVE >= waterThresholdMin & indexCIVE < waterThresholdMax;
builtUp = indexCIVE >= builtUpThresholdMin & indexCIVE < builtUpThresholdMax;
dryVegetation = indexCIVE >= dryVegetationThresholdMin & indexCIVE < dryVegetationThresholdMax;
healthyVegetation = indexCIVE >= healthyVegetationThresholdMin & indexCIVE < healthyVegetationThresholdMax;



%% Wyswietl 
ptCloudFilt = select(ptCloudOut, water);
ptCloudFilt.Color(:,1)=0
ptCloudFilt.Color(:,1)=0
pcshow(ptCloudFilt)

hold on 

ptCloudFilt = select(ptCloudOut, builtUp);
ptCloudFilt.Color(:,2)=0
ptCloudFilt.Color(:,3)=0
pcshow(ptCloudFilt)

hold on 
ptCloudFilt = select(ptCloudOut, dryVegetation);
ptCloudFilt.Color(:,3)=0
ptCloudFilt.Color(:,3)=0
pcshow(ptCloudFilt)

hold on 
ptCloudFilt = select(ptCloudOut, healthyVegetation);
ptCloudFilt.Color(:,1)=0
ptCloudFilt.Color(:,3)=0
pcshow(ptCloudFilt)

%% Classification statistics
clound_length = size(healthyVegetation);
water_percent = (sum(water)/clound_length(1, 1))*100;
builtUp_percent = (sum(builtUp)/clound_length(1, 1))*100;
dryVegetation_percent = (sum(dryVegetation)/clound_length(1, 1))*100;
healthyVegetation_percent = (sum(healthyVegetation)/clound_length(1, 1))*100;
correct_classification = water_percent+builtUp_percent+dryVegetation_percent+healthyVegetation_percent;
without_classification = 100 - correct_classification;


fprintf('Water: %.2f%% \n', water_percent);
fprintf('Built up: %.2f%% \n', builtUp_percent);
fprintf('Dry vegetation: %.2f%% \n', dryVegetation_percent);
fprintf('Healthy vegetation: %.2f%% \n', healthyVegetation_percent);
fprintf('Sum of correct classification: %.2f%% \n', correct_classification);
fprintf('Without classification: %.2f%% \n', without_classification);