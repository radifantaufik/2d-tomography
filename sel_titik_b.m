function [x,z,kondisi]=sel_titik_b(a_di,xa,za)
if a_di==1
    x=[xa xa+1 xa xa+1]';
    z=[za za za+1 za+1]';        
    kondisi='1';
elseif a_di==3
    x=[xa xa+1 xa xa+1]';
    z=[za-1 za-1 za za]';    
    kondisi='3';
elseif a_di==2
    x=[xa-1 xa xa-1 xa]';
    z=[za za za+1 za+1]';        
    kondisi='2';
elseif a_di==4
    x=[xa-1 xa xa-1 xa]';
    z=[za-1 za-1 za za]';    
    kondisi='4';
end


