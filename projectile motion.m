% Simulation of a projectile motion.
clc;
close all; 
clear; 

g = -9.81;% Acceleration due to gravity.
x0 = 0;% initial point
y0 = 0;% Vertical height of launch site.
v0 = 16;% Initial velocity at the angle of launch.
% First find the max time of flight. This will happen when the projectile is fired straight up and the angle is 90.
angle = 90;
% Get the components of velocity in the x and y directions.
v0x = v0*cosd(angle);
v0y = v0*sind(angle);

% Computing the distance along the y direction.
% y value will be zero when the projectile hits the ground.
% tmax is time when the projectile hits the groung(y=0).
% finding the roots from the equation
a = (1/2) * g;
b = v0y;
c = y0;
t = roots([a, b, c]);
tmax = max(t); % choosing the maximum time

figure(1);

t = linspace(0, tmax,100); %generates 100 values between 0 and tmax.

angle=45;

% Calculating the velocity of the x and y components.
v0x = v0*cosd(angle);
v0y = v0*sind(angle);
% Compute the distance along the x direction.
% x = x0 + x_velocity * time.
x = x0 + v0x * t;
% Computing the distance along the y direction.(height equation)
% y = y0 + y_velocity_initial * time + (1/2)*g*time^2
y = y0 + v0y * t + (1/2) * g * t .^ 2;
%Equating Y to 0 assuming that projectile stops when it hits the ground
if(y<0)
    y = 0;
end
plot(x, y);
grid on;
xlabel('Distance');
ylabel('Height');
title ('Projectile Trajectory')
legend('45 degrees');
ylim([0,10]);%setting the limit for y axis

%sampling
figure(2); 
stem(y);
title('Sampled signal');
xlabel('time');
ylabel('amplitude');
ylim([0 10])

%Quantizing the values
n1=input('Enter the number of bits per sample');
L=2^n1;
Xmax=10;
Xmin=0;
del=(Xmax-Xmin)/L;
partition=Xmin:del:Xmax;
codebook=Xmin-(del/2):del:Xmax+(del/2);
[index,quants]=quantiz(y,partition,codebook);

%Ploting the Quantized Signal.
figure(3);
stem(quants);
title('quantized signal');
xlabel('Time');
ylabel('Amplitude');
ylim([0 10]);

%Encoding
l1=length(index);
for i=1:l1
if(index(i)~=0)
index(i)=index(i)-1;
end
end

%normalization
l2=length(quants);
for i=1:l2
    if (quants(i)==Xmax-del/2)
        quants(i)=Xmax+del/2;
    end
    if (quants(i)==Xmax+del/2)
        quants(i)=Xmax-del/2;
    end
end

code=de2bi(index,'left-msb');

k=1;
for i=1:l1
    for j=1:n1
        coded(k)=code(i,j);
        j=j+1;
        k=k+1;
    end
    i=i+1;
end

%Ploting the Encoded Signal
figure(4);
stairs(coded);
title('encoded signal');
xlabel('n');
ylabel('amplitude');
xlim([0 450]);
ylim([0 2]);

%Decoding
index1=bi2de(code,'left-msb');
de_signal=(del*index1)+Xmin+(del/2);

%Ploting the Decoded Signal
figure(5);
plot(de_signal);
title('demodulated signal');
xlabel('n');
ylabel('amplitude');
