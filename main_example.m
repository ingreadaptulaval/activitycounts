% Get activity counts. Version 0.1 - 25 nov 2020
% This file is an open source draft to be improved in 2021
% Please refer to paper:
    % Poitras, I., Clouatre, J., et al. Development and Validation of
    % Open-Source Activity Intensity Count and Activity Intensity
    % Classification Algorithms from Raw Acceleration Signal of Wearable
    % Sensors. Sensors
% This file provide an example to get the activity counts from acceleration
% data.
clear all;
close all;
clc;


% Loading raw acceleration data from CSV file (first row is titles. 4 columns: time,ax,ay,az (time is ignored in this file))
    raw_acceleration = csvread('dataexample.csv',1,1);
    
% Set the acquisition rate of the selected data    
    fs = 100; %100Hz

% Get counts with Fixed Bandwidth method
    counts_fixedbandwidth = getcounts_fixedbandwidth(raw_acceleration,fs);

    figure(1)
        title('Counts with Fixed Bandwidth');
        plot(counts_fixedbandwidth);
        ylabel('Counts')
        
        
% Get counts with Modifiable Bandwidth method
    hipass = 0.305;
    lowpass = 1.615;
    counts_modifbandwidth = getcounts_modifbandwidth(raw_acceleration,fs,hipass,lowpass);

    figure(2)
        title('Counts with Modifiable Bandwidth');
        plot(counts_modifbandwidth);
        ylabel('Counts')










