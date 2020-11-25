function [u_filt]  = teamat_filter_ab_offline(b,a,order,init_val,u)
%Created by MBoyer, 2019
%Adapted by ACampeau-Lecours, 2020-06-05

%init_val: 0:Part à zéro. 1: Part à la valeur initiale du signal. 2: Mélange(pour hi-pass) qui commence à zéro. ;
%Lowpass: normalement 1. Hipass: normalement 2. Bandpass:normalement 2.  Stopband: valider si 1 ou 2

Y=zeros(1,order+1);
Z=zeros(1,order+1);
for i=1:length(u)%on part dès le début
    if init_val == 0
        Y(1)=u(i);
    elseif init_val == 1
        Y(1)=u(i)-u(1);
    else
        Y(1)=u(i)-u(1);
    end
    
    if order==2
        Z=Z(1,1:3);
        Y=Y(1,1:3);
        Z(1)=b*Y'-(a(1,2)*Z(1,2) + a(1,3)*Z(1,3));
    elseif order==4
        Z=Z(1,1:5);
        Y=Y(1,1:5);
        Z(1)=b*Y'-(a(1,2)*Z(1,2) + a(1,3)*Z(1,3) + a(1,4)*Z(1,4) + a(1,5)*Z(1,5));
    elseif order==7
         Z=Z(1,1:8);
         Y=Y(1,1:8);
         Z(1)=b*Y'-(a(1,2)*Z(1,2) + a(1,3)*Z(1,3) + a(1,4)*Z(1,4) + a(1,5)*Z(1,5)+ a(1,6)*Z(1,6) + a(1,7)*Z(1,7) + a(1,8)*Z(1,8));
    elseif order==8
         Z=Z(1,1:9);
         Y=Y(1,1:9);
         Z(1)=b*Y'-(a(1,2)*Z(1,2) + a(1,3)*Z(1,3) + a(1,4)*Z(1,4) + a(1,5)*Z(1,5)+ a(1,6)*Z(1,6) + a(1,7)*Z(1,7) + a(1,8)*Z(1,8) + a(1,9)*Z(1,9));
    elseif order==16
        Z=Z(1,1:17);
        Y=Y(1,1:17);
        Z(1)=b*Y'-(a(1,2)*Z(1,2) + a(1,3)*Z(1,3) + a(1,4)*Z(1,4) + a(1,5)*Z(1,5)+ a(1,6)*Z(1,6) + a(1,7)*Z(1,7) + a(1,8)*Z(1,8) + a(1,9)*Z(1,9)+ a(1,10)*Z(1,10) + a(1,11)*Z(1,11) + a(1,12)*Z(1,12) + a(1,13)*Z(1,13)+ a(1,14)*Z(1,14) + a(1,15)*Z(1,15) + a(1,16)*Z(1,16) + a(1,17)*Z(1,17));
    else
        Z(1) = Y(1);
    end

     Y_temp=Y;
     Y(2:end)=Y_temp(1:end-1);
     Z_temp=Z;
     
    if init_val==0
        u_filt(i,1)=Z(1);
    elseif init_val == 1
        u_filt(i,1)=Z(1)+u(1);
    else
        u_filt(i,1) = Z(1);
    end
    Z(2:end)=Z_temp(1:end-1);
end




