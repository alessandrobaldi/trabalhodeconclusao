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

import eeml.*; //biblioteca necessária para a recepção de dados no formato

DataIn dIn;//tipo de dados


//variáveis para guardar os dados recebidos
float atencao = 0;
float meditacao = 0;
float delta =0;
float theta = 0;
float lowalpha = 0;
float highalpha = 0;
float lowbeta = 0;
float highbeta = 0;
float lowgamma =0;
float midgamma = 0;
float maxatencao = 0;
float maxmeditacao = 0;
float maxdelta =0;
float maxtheta = 0;
float maxlowalpha = 0;
float maxhighalpha = 0;
float maxlowbeta = 0;
float maxhighbeta = 0;
float maxlowgamma =0;
float maxmidgamma = 0;

void setup() {
  size(800, 800);  // tamanho inicial
  if (frame != null) {
    frame.setResizable(true);//para que tamanho da janela seja ajustável
  }
  dIn = new DataIn(this, "https://api.xively.com/v1/feeds/COLOQUE AQUI O FEED ID.xml", "COLOQUE AQUI A APIKEY", 5000);//para conectar a base de dados do xively, basta preencher com o feed id e api key
}

void draw()
{
  background(0);
  int tamanx = width;
  int tamany = height;
  //para receber os maiores valores e fazer porcentagem
  if (maxatencao<atencao)
  {
    maxatencao=atencao;
  }
  if (maxmeditacao<meditacao)
  {
    maxmeditacao=meditacao;
  }
  if (maxdelta<delta)
  {
    maxdelta=delta;
  }
  if (maxtheta<theta)
  {
    maxtheta=theta;
  }
  if (maxlowalpha<lowalpha)
  {
    maxlowalpha=lowalpha;
  }
  if (maxhighalpha<highalpha)
  {
    maxhighalpha=highalpha;
  }
  if (maxlowbeta<lowbeta)
  {
    maxlowbeta=lowbeta;
  }
  if (maxhighbeta<highbeta)
  {
    maxhighbeta=highbeta;
  }
  if (maxlowgamma<lowgamma)
  {
    maxlowgamma=lowgamma;
  }
  if (maxmidgamma<midgamma)
  {
    maxmidgamma=midgamma;
  }
  //aqui é feita a montagem do gráfico
  fill(255, 0, 0);
  rect(0, map(atencao, 0, maxatencao, tamany,0), tamanx/10, tamany);
  fill(255);
  textSize(15);
  text("Atenção", 0, map(atencao, 0, maxatencao, tamany, tamany/2)); 
  fill(204, 102, 0);
  rect(tamanx/10, map(meditacao, 0, maxmeditacao, tamany, 0), tamanx/10, tamany);
  fill(255);
  textSize(15);
  text("Meditação", tamanx/10, map(meditacao, 0, maxmeditacao, tamany, tamany/2)); 
  fill(200, 247, 12);
  rect(2*tamanx/10, map(delta, 0, maxdelta, tamany, 0), tamanx/10, tamany);
  fill(255);
  textSize(15);
  text("Delta", 2*tamanx/10, map(delta, 0, maxdelta, tamany, tamany/2)); 
  fill(247, 12, 294);
  rect(3*tamanx/10, map(theta, 0, maxtheta, tamany, 0), tamanx/10, tamany);
  fill(255);
  textSize(15);
  text("Theta", 3*tamanx/10, map(theta, 0, maxtheta, tamany, tamany/2)); 
  fill(0, 255, 0);
  rect(4*tamanx/10, map(lowalpha, 0, maxlowalpha, tamany, 0), tamanx/10, tamany);
  fill(255);
  textSize(15);
  text("Alpha-", 4*tamanx/10, map(lowalpha, 0, maxlowalpha, tamany, tamany/2)); 
  fill(12, 247, 241);
  rect(5*tamanx/10, map(highalpha, 0, maxhighalpha, tamany, 0), tamanx/10, tamany);
  fill(255);
  textSize(15);
  text("Alpha+", 5*tamanx/10, map(highalpha, 0, maxhighalpha, tamany, tamany/2)); 
  fill(27, 12, 247);
  rect(6*tamanx/10, map(lowbeta, 0, maxlowbeta, tamany, 0), tamanx/10, tamany);
  fill(255);
  textSize(15);
  text("Beta-", 6*tamanx/10, map(lowbeta, 0, maxlowbeta, tamany, tamany/2)); 
  fill(121, 12, 247);
  rect(7*tamanx/10, map(highbeta, 0, maxhighbeta, tamany, 0), tamanx/10, tamany);
  fill(255);
  textSize(15);
  text("Beta+", 7*tamanx/10, map(highbeta, 0, maxhighbeta, tamany, tamany/2)); 
  fill(#FF5050);
  rect(8*tamanx/10, map(lowgamma, 0, maxlowgamma, tamany, 0), tamanx/10, tamany);
  fill(255);
  textSize(15);
  text("Gamma-", 8*tamanx/10, map(lowgamma, 0, maxlowgamma, tamany, tamany/2)); 
  fill(#50FF6B);
  rect(9*tamanx/10, map(midgamma, 0, maxmidgamma, tamany, 0), tamanx/10, tamany);
  fill(255);
  textSize(15);
  text("Gamma+", 9*tamanx/10, map(midgamma, 0, maxmidgamma, tamany, tamany/2)); 
}

// função para receber valores
void onReceiveEEML(DataIn d) { 
  atencao = d.getValue(0);
  meditacao = d.getValue(1);
  delta = d.getValue(3);
  theta = d.getValue(4);
  lowalpha = d.getValue(5);
  highalpha = d.getValue(6);
  lowbeta = d.getValue(7);
  highbeta = d.getValue(8);
  lowgamma = d.getValue(9);
  midgamma = d.getValue(10);
}