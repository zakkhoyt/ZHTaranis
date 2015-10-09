#define channumber 6 //Cuantos canales tiene tu radio???????/How many channels have your radio???
int channel[channumber]; //Valores de canales leidos/ readed Channel values
int PPMin = 4;

void setup()
{
 Serial.begin(9600); //Iniciamos com serial/
 pinMode(PPMin, INPUT); //Patita 4 como entrada / Pin 4 as input
}

void loop()
{
 //Espera hasta que la senal de sincronizacion llegue, debe ser > 4 milisegundos
 //waits ultil synchronize arrives > 4 miliseconds
 if(pulseIn(PPMin , HIGH) > 4000); //Si el pulso del pin 4 es > que 4 msegundos continua /If pulse > 4 miliseconds, continues
 {
   for(int i = 1; i <= channumber; i++) //lee los pulsos de los demas canales / Read the pulses of the remainig channels
   {
     channel[i-1]=pulseIn(PPMin, HIGH);
   }
   for(int i = 1; i <= channumber; i++) //Imprime los valores de todos los canales / Prints all the values readed
   {
     Serial.print("CH"); //Canal/Channel
     Serial.print(i); // Numero del canal / Channel number
     Serial.print(": "); // que te importa
     Serial.println(channel[i-1]); // Imprime el valor/ Print the value
   }
   delay(200);//Le da tiempo para imprimir los valores en el puerto/ Give time to print values.
 }  
}  



