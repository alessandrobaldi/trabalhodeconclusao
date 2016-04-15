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

import neurosky.*;//biblioteca do EEG
import org.json.*;//biblioteca que trabalha com dados em json
import java.net.ConnectException;//necessária para a conexão do aparelho
import processing.serial.*;//biblioteca necessária para a conexão do aparelho
import pt.citar.diablu.processing.nxt.*;//biblioteca necessária para o controle do lego NXT
  PFont font;
  int at = 0;//variável para guardar nível de atenção
  int med = 0;//variável para guardar nível de meditação
  int atmov = 80;//movimento inicial de atenção (frente)
  int medmov = 80;//movimento inicial de meditação (ré)
ThinkGearSocket neuroSocket; //criação de socket com o EEG
int power = 0;//variável para guardar velocidade do robô
LegoNXT lego; //criação de controle lego
void setup() {
  size(800, 800);//janela 800x800
  ThinkGearSocket neuroSocket = new ThinkGearSocket(this);//início de socket EEG
  try {
    neuroSocket.start();
  } 
  catch (ConnectException e) {
    println("ThinkGear está sendo executado?");//caso não consiga se conectar ao EEG
  }
  smooth();//mostra objetos sem serrilhado (anti-aliasing)
  font = createFont("Verdana", 25);
  textFont(font);
  lego = new LegoNXT(this, "COM7");//conexão bluetooth com lego - mude a porta para executar(lego na COM7)
}

void draw() {
  noStroke(); //sem linha na tela
  background(0);//plano de fundo preto (cor 0)
  fill(255);
  //desenha interface
  rect(300,300,200,200,10);//a função rect desenha quadrados
  fill(#F4A460);//a função fill preenche com cores os objetos geométricos
  rect(350,300,100,50,0,0,10,10);
  fill(#B22222);
  float nivat = map(at, 0, 100, 0, 300);//a função map faz o cálculo matemático proporcional - atenção em relação a tela
  rect(325,300-nivat,150,nivat);
  fill(#000080);
  float nivmed = map(med, 0, 100, 0, 300);
  rect(325,500,150,nivmed);
  
  fill(0);
  ellipse(300,350,25,35);//a função ellipse desenha objetos redondos
  ellipse(300,450,25,35);
  ellipse(500,350,25,35);
  ellipse(500,450,25,35);
  
  fill(255);
  textAlign(CENTER, CENTER);//centraliza o texto
  text(at+"%",400,300-nivat/2); //apresenta o texto na tela
  text(med+"%",400,500+nivmed/2); 
  
  fill(#DC143C);
  rect(625,map(atmov, 0, 100, 300, 0),25,5);
  rect(625,map(medmov, 0, 100, 500, 800),25,5);
  
  
  if(at>=atmov)
  {
    //robô anda pra frente
    println("Robô indo para frente");
    //desenha setas na tela
    stroke(0);
    strokeWeight(10); 
    line(400,400,400,450);
    stroke(255);
    line(400,450,380,425);
    line(400,450,420,425);
    stroke(0);
    line(400,400,380,425);
    line(400,400,420,425);
    power=-1*at/2;//velocidade para andar
    lego.motorForward(LegoNXT.MOTOR_B, power);//envio de comandos ao robô
    lego.motorForward(LegoNXT.MOTOR_C, power);
  }
  else if(med>=medmov)
  {
    //robô anda pra trás
    println("Robô indo para trás");
    //desenha setas na tela
    stroke(0);
    strokeWeight(10); 
    line(400,400,400,450);
    stroke(255);
    line(400,400,380,425);
    line(400,400,420,425);
    stroke(0);
    line(400,450,380,425);
    line(400,450,420,425);
    power=1*at/2;//velocidade para andar
    lego.motorForward(LegoNXT.MOTOR_B, power);//envio de comandos ao robô
    lego.motorForward(LegoNXT.MOTOR_C, power);
  }
  if(at<atmov&&med<medmov)
  {
    //robô para
    println("Robô parado");
    //tira a seta da tela
    stroke(0);
    strokeWeight(10); 
    line(400,400,400,450);
    stroke(255);
    line(400,450,380,425);
    line(400,450,420,425);
    stroke(255);
    line(400,400,380,425);
    line(400,400,420,425);
    lego.motorHandBrake(LegoNXT.MOTOR_B);//envio de comandos ao robô
    lego.motorHandBrake(LegoNXT.MOTOR_C);
  }
  delay(250);
}


void poorSignalEvent(int sig) {//função para verificar o nível de sinal do EEG - Caso necessite
}

public void attentionEvent(int attentionLevel) {//função para verificar nível de atenção
  at = attentionLevel;//pega o nível de atenção
}


void meditationEvent(int meditationLevel) {//função para verificar nível de meditação
  med = meditationLevel;//pega o nível de meditação
}

void blinkEvent(int blinkStrength) {//função para verificar piscada de olhos - Caso necessite
}

public void eegEvent(int delta, int theta, int low_alpha, int high_alpha, int low_beta, int high_beta, int low_gamma, int mid_gamma) {
//função para verificar outros dados do EEG - Caso necessite
}

void rawEvent(int[] raw) {//função para verificar dados puros do EEG - Caso necessite
}  

void stop() {//função para parar eeg
  neuroSocket.stop();
  super.stop();
}

void mouseDragged() //função para verificar clique do mouse (interagir com a barra para que o robô ande)
{
  if(mouseY<300)
  {
    atmov=(int)map(mouseY,300,0,0,100);
  }
  if(mouseY>500)
  {
    medmov=(int)map(mouseY,500,800,0,100);
  }
}