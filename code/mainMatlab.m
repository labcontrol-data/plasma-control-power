%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code written Alessandro N. Vargas
% Last update: May 20, 2024
% Motivation: experimental data collected from
% a plasma kit.
% E-mail: avargas@utfpr.edu.br
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc, clear all, close all,

gain_probe_1 = 934.712121; % measured gain of the low-cost high-voltage 
                           % probe (see the published paper for details)

                           
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% procedure to check the 'rise time' of MOSFET with 'step' command u(t)
% vontage-controlled current source (no Arduino)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

count=1;
for ps=1:1
    textoPequeno = sprintf("20240502-%04d.mat",ps);
    nome{count} = sprintf('%s',textoPequeno);
    
    eval(sprintf("load %s",nome{count}));
    
    Ts = Tinterval;
    
    t = Ts*[1:max(size(A))];
    %
    heap_Vref{count} = C;        % voltage command in u(t)  
    heap_V1{count} = A; % high-voltage should be multiplied later by "gain_probe_1"
    heap_V2{count} = B; % high-voltage should be multiplied later by "gain_probe_1"
    heap_Vcurrent{count} =  D;   % voltage on the shunt resistor (R=50 Ohms)
    
    count = count+1;
end


figure(1)
hold on
plot(t,heap_Vref{1},'LineWidth',2)
plot(t,heap_Vcurrent{1})
hold off
legend('Vref','Voltage drop on shunt resistor')
title('data for control of current')
axis([0 0.2002 0.4 1.5]),grid

savefile = 'data_uc_berkeley_plasma_current.mat';
save(savefile,'heap_Vref','heap_V1','t','heap_V2','heap_Vcurrent','Ts','-v7');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% procedure to process and interpret the original data in meaningful way
% data for 'CLOSED LOOP (CONTROL) of power' with Arduino
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
count=1;
for ps=2:2
    for ax=4:4
        textoPequeno = sprintf("20240426-%04d_%02d.mat",ps,ax);
        nome{count} = sprintf('%s',textoPequeno);
        
        eval(sprintf("load %s",nome{count}));
        
        Ts = Tinterval;
        
        t = Ts*[1:max(size(A))];
        
        power = 4*C;    % adjusted because Arduino Due reduced the corrected value by 1/4
                        % adjusted because Arduino Due generated pulses "low" and "high" that 
                        % corresponds to "Pref=6 Watts" and "Pref=10 Watts", respectively.
       
        heap_V1{count} = A; % high-voltage should be multiplied later by "gain_probe_1"
        heap_V2{count} = B; % high-voltage should be multiplied later by "gain_probe_1"
        heap_Vcurrent{count} =  D;   % voltage on the shunt resistor (R=50 Ohms)
        heap_power{count} = power;
        
        count = count+1;
    end
end


% c2=1;
% for k=1:max(size(t))
%     if (0.4999<t(k))&& (t(k)<1.70642)
%         c2 = c2+1;
%     end
% end

vecPref = 6*ones(1,99980);
vecPref = [vecPref 10*ones(1,241304)];
vecPref = [vecPref 6*ones(1,241304)];
vecPref = [vecPref 10*ones(1,241304)];
vecPref = [vecPref 6*ones(1,241304)];

heap_pref{1} = vecPref(1:max(size(t)));

figure(2)
subplot(3,1,1)
hold on
plot(t,heap_V1{1})
plot(t,heap_V2{1})
hold off
legend('V1','V2'), title('data for control of power')

subplot(3,1,2)
hold on
plot(t,heap_power{1})
plot(t,vecPref(1:max(size(t))),'g')
legend('plasma power measured in Arduino')
hold off

subplot(3,1,3)
hold on
plot(t,heap_Vcurrent{1},'k')
legend('Voltage drop on shunt resistor')
hold off
xlabel('time (s)'), 
savefile = 'data_uc_berkeley_plasma_power_control_data.mat';
save(savefile,'heap_Vcurrent','heap_power','t','heap_V1','heap_V2','heap_pref','Ts','-v7');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% data to check the frequency that Arduino Due run
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
count=1; vec_TimeStamp =[];
for ps=1:1
    for ax=1:2
        textoPequeno = sprintf("20240520-%04d_%01d.mat",ps,ax);
        nome{count} = sprintf('%s',textoPequeno);
        
        eval(sprintf("load %s",nome{count}));
        
        Ts = Tinterval;
        
        t = Ts*[1:max(size(A))];
        
        vecPulses = D;   % vector of pulses
        
        for k=1:(max(size(vecPulses))-1)
            
            if (vecPulses(k)<1.5)&&(1.5<vecPulses(k+1))
                markInit = k;
            end
            if (vecPulses(k)>1.5)&&(1.5>vecPulses(k+1))
                markEnd = k;
                vec_TimeStamp = [vec_TimeStamp (markEnd - markInit)*Ts];
            end
        end
        count = count+1;
    end
end
format long
period_Arduino = mean(vec_TimeStamp)
frequency_Arduino = 1/period_Arduino 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% data to check the current measured directly from the resistor
% and compare it with current taken from Arduino Due
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
count=1; vec_TimeStamp =[];
for ps=2:2
    for ax=1:4
        textoPequeno = sprintf("20240520-%04d_%01d.mat",ps,ax);
        nome{count} = sprintf('%s',textoPequeno);
        
        eval(sprintf("load %s",nome{count}));
        
        Ts = Tinterval;
        
        t = Ts*[1:max(size(A))];
               
        heap_V1{count} = A; % high-voltage should be multiplied later by "gain_probe_1"
        heap_V2{count} = B; % high-voltage should be multiplied later by "gain_probe_1"
        heap_Vcurrent{count} =  D;   % voltage on the shunt resistor (R=50 Ohms)
        heap_VcurrentArduino{count} = C;  % voltage on the shunt resistor that Arduino Due knows
       
        count = count+1;
    end
end

figure(3)

for p=1:4
    
    subplot(4,1,p)
    hold on
    plot(t,heap_Vcurrent{1})
    plot(t,heap_VcurrentArduino{1})
    hold off
    legend('current Resistor','current Arduino'),
end

for i=1:max(size(heap_Vcurrent))
    percent_mean_error = mean(abs(heap_Vcurrent{i}-heap_VcurrentArduino{i}));
    percent_std_error = std(abs(heap_Vcurrent{i}-heap_VcurrentArduino{i}));
    percent_overall_error = max(abs( (heap_Vcurrent{i}-heap_VcurrentArduino{i})./heap_Vcurrent{i}) ) 
end
