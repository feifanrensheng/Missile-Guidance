%% AE 410 Assignment -2
% Submitted by : Ram Milan Verma; 150010037
%% Q3(b). RTPN(Realistic True Proportional Navigation)
clear; close all;
% for different values of heading error and N just keep replacing the
% values of HE and N variables
HE=-20; %Heading error of launched missile
N=10; % Navigation gain 
gamaT=90; VT=300; VM(1)=500;
r(1)=15000;
theta(1)=0;
gamaM(1)=asin(3/5) + HE;
Vr0=VT*cosd(gamaT-theta(1))-VM(1)*cosd(gamaM(1)-theta(1));
tf =100;
dt=1e-3;  % integration time step
Ns=floor(tf/dt); % number of samples
t=linspace(0,tf,Ns);
xM(1)=0; yM(1)=0; %missile's initial coordinate assumed to (0,0) WLOG
xT(1)=r(1)*cosd(theta(1)); yT(1)=r(1)*sind(theta(1)); % initial position of target w.r.t. missile
for i=1:Ns
    % rate calculatio step
    rdot= VT*cosd(gamaT-theta(i)) - VM(i)*cosd(gamaM(i)-theta(i));
    theta_dot=(VT*sind(gamaT-theta(i))-VM(i)*sind(gamaM(i)-theta(i)))/r(i); %rad / sec
    Vr=rdot;
    aM(i)=-N*Vr*theta_dot;
    VM_dot=aM(i)*sind(gamaM(i)-theta(i));
    gamaM_dot=aM(i)*cosd(gamaM(i)-theta(i))/VM(i); % rad /sec
    % update step
    r(i+1)=r(i) + rdot*dt;
    theta(i+1)=theta(i) + theta_dot*dt*180/pi;
    gamaM(i+1)= gamaM(i) +gamaM_dot*dt*180/pi;
    VM(i+1)=VM(i) + VM_dot*dt;
    xM(i+1)=xM(i)+ VM(i+1)*cosd(gamaM(i+1))*dt;
    yM(i+1)=yM(i)+ VM(i+1)*sind(gamaM(i+1))*dt;
    xT(i+1)=xT(i)+ VT*cosd(gamaT)*dt;
    yT(i+1)= yT(i)+VT*sind(gamaT)*dt;
    if r(i)<=0 
        break
    end
end
% plotting of trajectory and guidance command
figure
plot(xM,yM,xT,yT), xlabel('x(in m)'),ylabel('y(in m)'),legend('missile', 'target'), title('trajectory'), grid on
annotation('textbox', [0.5, 0.2, 0.1, 0.1], 'String',strcat('tf= ',num2str(i*dt), ' sec'));
dim = [.1 .4 .2 .2];
str = strcat('collision @ x= ',num2str(xM(i)),' ,y= ',num2str(yM(i)));
str1=strcat('For RTPN Guidance Law with HE= ',num2str(HE),'^o','and N= ',num2str(N) );suptitle(str1);
annotation('textbox',dim,'String',str,'FitBoxToText','on');
figure
plot(t(1:i),aM),xlabel('time(sec)'),ylabel('Missile acceleration(m/sec^2)'),legend('aM'), title('Guidance command'); grid on
suptitle(str1);


