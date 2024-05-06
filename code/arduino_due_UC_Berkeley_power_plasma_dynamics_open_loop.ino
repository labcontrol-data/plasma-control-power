// Code Arduino Due
// Author: Alessandro N. Vargas (www.anvargas.com)
// Code reads voltage1, voltage2, and V_current, and computes the power
// Last update: UC Berkeley, April 29, 2024

  unsigned int V_out;
  int a0=0; int a1=0; int a2 = 0; int q1=0; int q2=0; int q3=0;
  float volts1 = 0; float volts2 = 0; float current = 0; float power = 0; 
  float voltagelux = 0;
  const float c1 = 0.00080043337;
  const float c2 = 0.006706;
  const float c3 = 1865.823688;
  const float c4 = -1009.35;
  const float gain_probe_1 = 934.712121; // measured gain of the low-cost high-voltage probe (see the published paper for details)
  const float gain_current_sensor = 0.02;  // equals one divided by R = 50 Ohms
  float u = 0;

void setup(){
  Serial.begin(115200);
  PWMC_ConfigureClocks(16000 * PWM_MAX_DUTY_CYCLE , 0, VARIANT_MCK);
  analogWrite(DAC0, 0);
  analogWrite(DAC1, 0);
  analogWriteResolution(12);  // set the analog output resolution to 12 bit (4096 levels)
  analogReadResolution(12);   // set the analog input resolution to 12 bit
}
void loop(){

  int count=0;
  while(count<4097)
  { 
     // ==========================================================
     // Code for analog read - reads 4 elements
     // and computes its mean (doing so helps reducing noise)
     // ==========================================================
     q1=0; q2=0; q3=0;
     for (int r = 1; r <= 4; r++) {
       q1 = q1 + analogRead(A0);
       q2 = q2 + analogRead(A1);
       q3 = q3 + analogRead(A2);
     }
     a0=q1/4;
     a1=q2/4;  
     a2=q3/4;
     volts1 = float (2*( (c1*a0) + c2 )); // factor '2' because analog interface
                                          // attenuated the input signal by half
     Serial.print ("volts1 = ");
     Serial.print (volts1,6);
     
     volts2 = float (2*( (c1*a1) + c2 )); // factor '2' because analog interface
                                          // attenuated the input signal by half
     Serial.print ("; volts2 = ");
     Serial.print (volts2,6);

     current = float ( (c1*a2) + c2 );
     current = gain_current_sensor * current; 
     Serial.print ("; current = ");
     Serial.print (current, 6);
     
     power = (gain_probe_1 *(volts1-volts2)) * current;
     Serial.print ("; power = ");
     Serial.print (power, 6);
        
     // ==========================================================
     // Code for analog output
     // ==========================================================
     if ( ( count % 2) == 0){ u=1.25;}
     else { u=0.55;}
     
     V_out = (int)(c3*u+c4);
     Serial.print ("; Vout = ");
     Serial.println (u, 6);
     dacc_set_channel_selection(DACC_INTERFACE, 0);
     dacc_write_conversion_data(DACC_INTERFACE, V_out);
     
     // ==========================================================
     // Enable the next two lines to measure power through an oscilloscope
     // connected to Arduino Due terminal DAC1. Voltage and power has
     // relation of 0.25 because the line below divide power by four
     dacc_set_channel_selection(DACC_INTERFACE, 1);   
     dacc_write_conversion_data(DACC_INTERFACE, (int)(c3*(power/4)+c4)); 

     
     //delay(1);
     delay(40);
     count = count+1;
  }
}
