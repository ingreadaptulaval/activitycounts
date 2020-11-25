function counts = getcounts_fixedbandwidth(data,sf)

data = data*0.93;

deadband = 0.068;       %acc (g) min
peakThreshold = 2.13;   %acc (g) max

acc_to_count = 0.001664;%1 count = 0.001664g

% filesf=sf;
% sf=30;
% data = resample(data2,sf,filesf);
% integN = 30; %nb de points sommés sur une seconde (ex: 100 pour 100Hz)
integN = sf;      


x=[-31.3940162417693,-21.7141289079222,-0.127443338931798,-14.1434350848343,-30.0662809956398,-0.125444206373455,-2.20651019375653,-15.8876340276044,-9.37189209930238,-15.8151114392739,-1.28639405209429,-0.522474363749989,-13.5879415289231,-3.39437212818040,-0.0621284949038277];
        
z1= x(1) + x(2)*1i;
z2= x(1) - x(2)*1i;
z3 = x(3);
z4= x(4) + x(5)*1i;
z5= x(4) - x(5)*1i;
z6= x(6);
z7 = x(7);

p1= x(8) + x(9)*1i;
p2= x(8) - x(9)*1i;
p3 = x(10);
p4= x(11) + x(12)*1i;
p5= x(11) - x(12)*1i;
p6= x(13);
p7 = x(14);

z=[z1;z2;z3;z4;z5;z6;z7];
p=[p1;p2;p3;p4;p5;p6;p7];

k=x(15);
[b,a]=zp2tf(z,p,k);
tf1 = tf(b,a);

tf1_d=c2d(tf1,1/sf); 

b2=tf1_d.numerator{1};
a2=tf1_d.denominator{1};

for n=1:3 %trois colonnes: x,y,z

    %filter
    filt  = teamat_filter_ab_offline(b2,a2,7,2,data(:,n));
    
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
    counts_xyz=tot_counts_per_sec/sf;
    
    counts = sqrt(counts_xyz(:,1).^2+counts_xyz(:,2).^2+counts_xyz(:,3).^2);

end

