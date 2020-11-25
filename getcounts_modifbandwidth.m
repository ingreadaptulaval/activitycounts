function counts = getcounts_modifbandwidth(data,sf,fcutlow,fcuthigh)

data = data*0.96;

deadband = 0.068;       %acc (g) min
peakThreshold = 2.13;   %acc (g) max

acc_to_count = 0.001664; %1 count = 0.001664g
integN = sf; %nb de points sommés sur une seconde (ex: 100 pour 100Hz)

m = 2; %order=2m 
[b2,a2]=butter(m,[fcutlow,fcuthigh]/(sf/2),'bandpass');


for n=1:3 %trois colonnes: x,y,z

    %filter
    filt  = teamat_filter_ab_offline(b2,a2,4,2,data(:,n));
    
    %treshold
    I = find(filt > peakThreshold);
    filt(I) = peakThreshold;
    I = find(filt < -peakThreshold);
    filt(I) = -peakThreshold;

    %deadband
    filt=abs(filt);
    I = find(filt < deadband);
    filt(I) = 0;

    %acc (g) to counts for each point
    count_each_point=filt./acc_to_count;

    %total counts on 1 sec
    nb_sec = ceil (length(count_each_point) / integN);
    rs = zeros(nb_sec,1);

    for j=1:nb_sec
        for pts_interv=1+integN*(j-1):integN*j
            if (pts_interv <= length(count_each_point))
                rs(j) = rs(j) + count_each_point(pts_interv);
            end 
        end
    end

    tot_counts_per_sec(:,n)=rs;
end
    
    %mean counts for each sec
    counts_xyz = tot_counts_per_sec/sf;
    
    counts = sqrt(counts_xyz(:,1).^2+counts_xyz(:,2).^2+counts_xyz(:,3).^2);
end