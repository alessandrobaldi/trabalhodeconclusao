//Este programa é um software livre; você pode redistribuí-lo e/ou 
//modificá-lo dentro dos termos da Licença Pública Geral GNU como 
//publicada pela Fundação do Software Livre (FSF); na versão 3 da 
//Licença.

//Este programa é distribuído na esperança de que possa ser útil, 
//mas SEM NENHUMA GARANTIA; sem uma garantia implícita de ADEQUAÇÃO
//a qualquer MERCADO ou APLICAÇÃO EM PARTICULAR. Veja a
//Licença Pública Geral GNU para maiores detalhes.

//Você deve ter recebido uma cópia da Licença Pública Geral GNU junto
//com este programa. Se não, veja <http://www.gnu.org/licenses/>.

import neurosky.*;//biblioteca de algoritmos proprietários da empresa
import org.json.*;//biblioteca que trabalha com dados em json
import java.net.ConnectException;//biblioteca necessária para a conexão do aparelho
import eeml.*; //biblioteca necessária para o envio de dados no formato

DataOut dOut; //tipo de dados de saída
float lastUpdate; 

ThinkGearSocket neuroSocket;// conexão com eeg
int attention=10;
int meditation=10;
int piscada = 10;
int delt= 10;
int thet= 10;
int lowalph= 10;
int highalph= 10;
int lowbet= 10;
int highbet= 10;
int lowgamm= 10;
int midgamm= 10;
PFont font;
void setup() {

  dOut = new DataOut(this, " https://api.xively.com/v2/feeds/AQUI O FEED ID.xml", "AQUI A APIKEY"); 
  //  adiciona os dados para envio
  dOut.addData(0, "Nivel,atencao"); 
  dOut.addData(1, "Nivel,Meditacao"); 
  dOut.addData(2, "Forca,piscada"); 
  dOut.addData(3, "normal,Delta"); 
  dOut.addData(4, "normal,Theta"); 
  dOut.addData(5, "Low,Alpha"); 
  dOut.addData(6, "High,Alpha"); 
  dOut.addData(7, "Low,Beta"); 
  dOut.addData(8, "High,Beta"); 
  dOut.addData(9, "Low,Gamma"); 
  dOut.addData(10, "Mid,Gamma"); 

  size(20, 20);
  ThinkGearSocket neuroSocket = new ThinkGearSocket(this);
  try {
    neuroSocket.start();
  } 
  catch (ConnectException e) {//verifica se está conectado
  }
  smooth();//anti serrilhamento
  font = createFont("Verdana", 12);//aribui configurações de fonte
  textFont(font);
}

void draw() {
  //faz a atualização de dados no xively
  dOut.update(0, attention);
  dOut.update(1, meditation); 
  dOut.update(2, piscada); 
  dOut.update(3, delt);
  dOut.update(4, thet);
  dOut.update(5, lowalph); 
  dOut.update(6, highalph); 
  dOut.update(7, lowbet); 
  dOut.update(8, highbet); 
  dOut.update(9, lowgamm); 
  dOut.update(10, midgamm); 
  int response = dOut.updatePachube();//faz o envio para o xively
  
  if (response!=200)//se não houver resposta do envio de dados, ele espera para realizar nova tentativa
  {
    delay(10000);
  } else
  {
    println("Enviado");
    delay(5000);
  }
}


void poorSignalEvent(int sig) {//função para o nível de sinal do eeg (caso precise modificar para usar em algo)
}

//as funções abaixo aferem os dados e colocam-os em variáveis
public void attentionEvent(int attentionLevel) {
  attention = attentionLevel;
}
void meditationEvent(int meditationLevel) {
  meditation = meditationLevel;
}
void blinkEvent(int blinkStrength) {
  piscada=blinkStrength;
}
public void eegEvent(int delta, int theta, int low_alpha, int high_alpha, int low_beta, int high_beta, int low_gamma, int mid_gamma) {
  delt=delta;
  thet=theta;
  lowalph=low_alpha;
  highalph=high_alpha;
  lowbet=low_beta;
  highbet=high_beta;
  lowgamm=low_gamma;
  midgamm=mid_gamma;
}

void rawEvent(int[] raw) {//dados puros, caso precise usar
}  

void stop() {//para a recepção dos dados do eeg
  neuroSocket.stop();
  super.stop();
}