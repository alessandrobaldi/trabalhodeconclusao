//Este programa é um software livre; você pode redistribuí-lo e/ou  //<>//
//modificá-lo dentro dos termos da Licença Pública Geral GNU como 
//publicada pela Fundação do Software Livre (FSF); na versão 3 da 
//Licença.

//Este programa é distribuído na esperança de que possa ser útil, 
//mas SEM NENHUMA GARANTIA; sem uma garantia implícita de ADEQUAÇÃO
//a qualquer MERCADO ou APLICAÇÃO EM PARTICULAR. Veja a
//Licença Pública Geral GNU para maiores detalhes.

//Você deve ter recebido uma cópia da Licença Pública Geral GNU junto
//com este programa. Se não, veja <http://www.gnu.org/licenses/>.

#define LED 13
#define DEBUGOUTPUT 0

// variáveis de checksun
byte generatedChecksum = 0;
byte checksum = 0; 
int payloadLength = 0;
byte payloadData[64] = {
  0};
byte poorQuality = 0;
byte attention = 0;
byte meditation = 0;

// variáveis de funcionamento do sistema
long lastReceivedPacket = 0;
boolean bigPacket = false;


void setup() {
  pinMode(LED, OUTPUT);
  Serial.begin(57600); //abre uma porta serial virtual no USB com o 

}

//lê os dados do bluetooth conectado na porta 0 (RX)
byte ReadOneByte() {
  int ByteRead;

  while(!Serial.available());
  ByteRead = Serial.read();

#if DEBUGOUTPUT  
  Serial.print((char)ByteRead);
#endif

  return ByteRead;
}


void loop() {


  // O código abaixo faz a leitura do eletroencefalograma conectado no arduino a partir do bluetooth HC-05 e envia para a porta serial virtual usb. Foi modificado do código original disponível em http://developer.neurosky.com/docs/doku.php?id=mindwave_mobile_and_arduino
  if(ReadOneByte() == 170) {
    if(ReadOneByte() == 170) {

      payloadLength = ReadOneByte();
      if(payloadLength > 169)
          return;

      generatedChecksum = 0;        
      for(int i = 0; i < payloadLength; i++) {  
        payloadData[i] = ReadOneByte();
        generatedChecksum += payloadData[i];
      }   

      checksum = ReadOneByte();   
      generatedChecksum = 255 - generatedChecksum; 

        if(checksum == generatedChecksum) {    

        poorQuality = 200;
        attention = 0;
        meditation = 0;

        for(int i = 0; i < payloadLength; i++) { 
          switch (payloadData[i]) {
          case 2:
            i++;            
            poorQuality = payloadData[i];
            bigPacket = true;            
            break;
          case 4:
            i++;
            attention = payloadData[i];                        
            break;
          case 5:
            i++;
            meditation = payloadData[i];
            break;
          case 0x80:
            i = i + 3;
            break;
          case 0x83:
            i = i + 25;      
            break;
          default:
            break;
          }
        }

#if !DEBUGOUTPUT

        if(bigPacket) {
          if(poorQuality == 0)
            digitalWrite(LED, HIGH);
          else
            digitalWrite(LED, LOW);
          Serial.print(attention, DEC);//passa o valor de atenção para a porta serial
          Serial.print("\n");                     
        }
#endif        
        bigPacket = false;        
      }
      else {
      }
    }
  } 
}
