%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code written Alessandro N. Vargas
% Last update: May 6, 2024
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
for ps=1:8
    textoPequeno = sprintf("20240502-%04d.mat",ps);
    nome{count} = sprintf('%s',textoPequeno)
    
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
title('data for open loop process')
axis([0 0.2002 0.4 1.5]),grid

savefile = 'data_uc_berkeley_plasma_current.mat';
save(savefile,'heap_Vref','heap_V1','t','heap_V2','heap_Vcurrent','Ts','-v7');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% procedure to process and interpret the original data in meaningful way
% data for 'CLOSED LOOP (CONTROL)' with Arduino
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
count=1;
for ps=1:4
    for ax=1:24
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

figure(2)
subplot(3,1,1)
hold on
plot(t,heap_V1{1})
plot(t,heap_V2{1})
hold off
legend('V1','V2'), title('data for controlled process')

subplot(3,1,2)
hold on
plot(t,heap_power{1})
legend('plasma power measured in Arduino')
hold off

subplot(3,1,3)
hold on
plot(t,heap_Vcurrent{1},'k')
legend('Voltage drop on shunt resistor')
hold off
xlabel('time (s)'), 
savefile = 'data_uc_berkeley_plasma_power_control_data.mat';
save(savefile,'heap_Vcurrent','heap_power','t','heap_V1','heap_V2','Ts','-v7');
