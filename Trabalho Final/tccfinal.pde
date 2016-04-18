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

import processing.serial.*; //biblioteca necessária para comunicação serial com Arduino 
import processing.video.*; //biblioteca necessária para visualização de vídeo

Serial myPort;

int capitulo = 1;//capítulo inicial do software
int correto=0;//variável para verificar se a resposta do questionário foi correta
//variáveis para fazer o sorteio da ordem de respostas no questionário
int sorteio1;
int sorteio2;
int sorteio3;
int sorteio4;

int mediaatencao=0;//variável para guardar a média da atenção do indivíduo
//variáveis para saber a posição clicada do mouse
int clicadox = 0;
int clicadoy = 0;
//variáveis de média para cada tipo de objeto de aprendizagem
int medi=0;
int medt=0;
int medv=0;

int cal=0;//variável para indicar modo de calibração
int leitura=0;//variável para guardar a leitura de atenção
//variáveis de controle dos arquivos de entrada .txt
String fluxo[];
String fluxopassado[]; 
String foradefluxo[];
String atual;//variável temporária
char tipo;//variável temporária de tipo
int acertou=0;//variável para verificar taxa de acerto

Movie movie;//criação de variável de vídeo para exibição
void setup() {
  size(800, 800);//tamanho inicial 800x800
  if (frame != null) {
    surface.setResizable(true);//função que permite redimensionar
  }
  myPort = new Serial(this, Serial.list()[0], 57600);//varre a porta serial virtual em busca do arduino conectado em 57600 baud rates
  fluxo= loadStrings("fluxo.txt");//abre o arquivo txt de fluxo inicial para calibragem
  fluxopassado = loadStrings("fluxopassado.txt");//abre o arquivo txt de fluxo passado
  foradefluxo = loadStrings("foradefluxo.txt");//abre o arquivo txt de fluxos retirados
}


void draw()//draw é a função principal, que é um loop infinito
{
  sensoriamento();//chamada do módulo de sensoriamento
  dados("ini");//chamada do módulo de dados
  pedagogico();//chamada do módulo pedagógico
}


void mostratexto()//carrega o objeto de texto do módulo de conteúdo (pasta data) e mostra na interface
{
  String local= "texto/"+capitulo+".txt";
  String carregar[] = loadStrings(local);
  String texto="";
  for (int i = 0; i < carregar.length; i++) {
    texto = texto + carregar[i] + " ";
  }
  background(255);
  stroke(150);
  strokeWeight(5);
  line(0, (height/2)+(height/10), width/20, (height/2)+(height/10));
  line(width, (height/2)+(height/10), width-width/20, (height/2)+(height/10));
  line(width/20, (height/2)+(height/10), width/15, (height/2)+(height/10)-(height/20));
  line(width/20, (height/2)+(height/10), width/15, (height/2)+(height/10)+(height/20));
  line(width-width/20, (height/2)+(height/10), width-width/15, (height/2)+(height/10)-(height/20));
  line(width-width/20, (height/2)+(height/10), width-width/15, (height/2)+(height/10)+(height/20));
  line(width/15, (height/2)+(height/10)-(height/2), width-width/15, (height/2)+(height/10)-(height/2));
  line(width/15, (height/2)+(height/3)+(height/20), width-width/15, (height/2)+(height/3)+(height/20));
  line(width/15, (height/10), width/15, (height/2)+(height/3)+(height/20));
  line(width-width/15, (height/10), width-width/15, (height/2)+(height/3)+(height/20));
  noStroke();
  fill(255);
  triangle(width/20, (height/2)+(height/10), width/15, (height/2)+(height/10)-(height/20), width/15, (height/2)+(height/10)+(height/20));
  triangle(width-width/20, (height/2)+(height/10), width-width/15, (height/2)+(height/10)-(height/20), width-width/15, (height/2)+(height/10)+(height/20));
  rectMode(CORNERS);
  rect(width/15, (height/2)+(height/10)-(height/20), width-width/15, (height/2)+(height/10)+(height/20));
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(height/50);
  if (texto.length()>width/12)
  {
    int repete=texto.length()/(width/12);
    int contador=1;
    while (contador<=repete)
    {
      int percorre=contador*width/12;
      while (percorre>=texto.length ())
      {
        percorre=percorre-1;
      }
      while (texto.charAt (percorre)!=' ')
      {
        percorre=percorre-1;
        if (percorre<=0)
        {
          break;
        }
      }
      contador=contador+1;
      texto=espaco(percorre, texto);
    }
  }
  text(texto, width/2, (height/2)+(height/10));
  dados("texto");
}

String espaco(int local, String texto)//responsável por ajustar o texto no redimensionamento da tela
{
  String parte1=texto.substring(0, local);
  String parte2=texto.substring(local+1);
  String novo=parte1+"\n"+parte2;
  return novo;
}

void mostrapergunta()//carrega o objeto de pergunta do módulo de conteúdo (pasta data) e mostra na interface
{
  sorteia();
  String local= "quest/"+capitulo+".txt";
  String carregar[] = loadStrings(local);
  String texto = carregar[0] + " ";
  String op1 = carregar[sorteio1] + " ";
  String op2 = carregar[sorteio2] + " ";
  String op3 = carregar[sorteio3] + " ";
  String op4 = carregar[sorteio4] + " ";
  background(0);
  stroke(150);
  strokeWeight(5);
  line(0, (height/10), width/20, (height/10));
  line(width, (height/10), width-width/20, (height/10));
  line(width/20, (height/10), width/15, (height/10)-(height/20));
  line(width/20, (height/10), width/15, (height/10)+(height/20));
  line(width-width/20, (height/10), width-width/15, (height/10)-(height/20));
  line(width-width/20, (height/10), width-width/15, (height/10)+(height/20));
  line(width/15, (height/10)-(height/20), width-width/15, (height/10)-(height/20));
  line(width/15, (height/10)+(height/20), width-width/15, (height/10)+(height/20));
  noStroke();
  fill(255);
  triangle(width/20, (height/10), width/15, (height/10)-(height/20), width/15, (height/10)+(height/20));
  triangle(width-width/20, (height/10), width-width/15, (height/10)-(height/20), width-width/15, (height/10)+(height/20));
  rectMode(CORNERS);
  rect(width/15, (height/10)-(height/20), width-width/15, (height/10)+(height/20));
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(height/50);
  if (texto.length()>width/12)
  {
    int repete=texto.length()/(width/12);
    int contador=1;
    while (contador<=repete)
    {
      int percorre=contador*width/12;
      while (percorre>=texto.length ())
      {
        percorre=percorre-1;
      }
      while (texto.charAt (percorre)!=' ')
      {
        percorre=percorre-1;
        if (percorre<=0)
        {
          break;
        }
      }
      contador=contador+1;
      texto=espaco(percorre, texto);
    }
  }
  text(texto, width/2, (height/10));
  opcoes(op1, op2, op3, op4);
}



void opcoes(String op1, String op2, String op3, String op4)//responsável por mostrar as opções das perguntas
{
  fill(#0d47a1);
  stroke(150);
  rect(width/10, (height/5), width-width/10, (height/5)+(height/10), 7);
  rect(width/10, 2*(height/5), width-width/10, (2*(height/5))+(height/10), 7);
  rect(width/10, 3*(height/5), width-width/10, (3*(height/5))+(height/10), 7);
  rect(width/10, 4*(height/5), width-width/10, (4*(height/5))+(height/10), 7);
  textAlign(CENTER, CENTER);
  textSize(height/50);
  fill(255);
  if (op1.length()>width/12)
  {
    int repete=op1.length()/(width/12);
    int contador=1;
    while (contador<=repete)
    {
      int percorre=contador*width/12;
      while (percorre>=op1.length ())
      {
        percorre=percorre-1;
      }
      while (op1.charAt (percorre)!=' ')
      {
        percorre=percorre-1;
        if (percorre<=0)
        {
          break;
        }
      }
      contador=contador+1;
      op1=espaco(percorre, op1);
    }
  }
  text(op1, width/2, (height/5)+(height/10/2));
  if (op2.length()>width/12)
  {
    int repete=op2.length()/(width/12);
    int contador=1;
    while (contador<=repete)
    {
      int percorre=contador*width/12;
      while (percorre>=op2.length ())
      {
        percorre=percorre-1;
      }
      while (op2.charAt (percorre)!=' ')
      {
        percorre=percorre-1;
        if (percorre<=0)
        {
          break;
        }
      }
      contador=contador+1;
      op2=espaco(percorre, op2);
    }
  }
  text(op2, width/2, 2*(height/5)+(height/10/2));
  if (op3.length()>width/12)
  {
    int repete=op3.length()/(width/12);
    int contador=1;
    while (contador<=repete)
    {
      int percorre=contador*width/12;
      while (percorre>=op3.length ())
      {
        percorre=percorre-1;
      }
      while (op3.charAt (percorre)!=' ')
      {
        percorre=percorre-1;
        if (percorre<=0)
        {
          break;
        }
      }
      contador=contador+1;
      op3=espaco(percorre, op3);
    }
  }
  text(op3, width/2, 3*(height/5)+(height/10/2)); 
  if (op4.length()>width/12)
  {
    int repete=op4.length()/(width/12);
    int contador=1;
    while (contador<=repete)
    {
      int percorre=contador*width/12;
      while (percorre>=op4.length ())
      {
        percorre=percorre-1;
      }
      while (op4.charAt (percorre)!=' ')
      {
        percorre=percorre-1;
        if (percorre<=0)
        {
          break;
        }
      }
      contador=contador+1;
      op4=espaco(percorre, op4);
    }
  }
  text(op4, width/2, 4*(height/5)+(height/10/2));
}

void mostraimagem()//carrega o objeto de imagem do módulo de conteúdo (pasta data) e mostra na interface
{
  String local= "imagens/"+capitulo+".jpg";
  background(0);
  PImage imagem = loadImage(local);
  image(imagem, 0, 0, width, height);
  dados("imagem");
}

void sorteia()//função de sorteio de posição das respostas
{
  if (correto==0)
  {
    do {
      sorteio1 =(int)random(5);
    } while (sorteio1==0);
    do {
      sorteio2=(int)random(5);
    } while (sorteio2==0||sorteio2==sorteio1);
    do {
      sorteio3=(int)random(5);
    } while (sorteio3==0||sorteio3==sorteio1||sorteio3==sorteio2);
    do {
      sorteio4=(int)random(5);
    } while (sorteio4==0||sorteio4==sorteio1||sorteio4==sorteio2||sorteio4==sorteio3);
  }
  if (sorteio1==1)
  {
    correto=1;
  }
  if (sorteio2==1)
  {
    correto=2;
  }
  if (sorteio3==1)
  {
    correto=3;
  }
  if (sorteio4==1)
  {
    correto=4;
  }
}

void mostravideo()//carrega o objeto de vídeo do módulo de conteúdo (pasta data) e mostra na interface
{
  movie = new Movie(this, "video/1.mov");
  movie.loop();
  image(movie, 0, 0, width, height);
  dados("video");
}


void sensoriamento()//módulo de sensoriamento - faz a recepção da atenção do indivíduo através da seleção de porta COM automaticamente do arduino
{
  while (myPort.available() > 0) {
    String inBuffer = myPort.readStringUntil('\n');   
    if (inBuffer != null) {
      String sensor = trim(inBuffer);
      leitura=Integer.parseInt(sensor);
    }
  }
}


void mouseClicked() {//módulo de sensoriamento - faz a verificação de cliques do mouse
  clicadox=mouseX;
  clicadoy=mouseY;
}

void pedagogico()//módulo pedagógico - responsável pela adequação do fluxo de ensino através das regras adaptativas
{
  if (fluxo.length>0)
  {
    atual=fluxo[0];
    tipo=atual.charAt(0);
    capitulo=atual.charAt(1)-48;
    if (tipo=='I')
    {
      mostraimagem();
    }
    if (tipo=='T')
    {
      mostratexto();
    }
    if (tipo=='V')
    {
      mostravideo();
    }
    if (tipo=='Q')
    {
      mostrapergunta();
    }
    regras();
  } else
  {
    maisregras();
  }
}

void regras()//regras de modificação do fluxo
{
  if (clicadox!=0)
  {
    if (tipo=='Q')
    {
      confereresposta();
      cal=1;
    } else
    {
      if (cal==0)
      {
        apagalinha();
      } else
      {
        if (tipo=='T')
        {
          if (medt<mediaatencao)
          {
            removelinha();
          } else
          {
            apagalinha();
          }
        }
        if (tipo=='I')
        {
          if (medi<mediaatencao)
          {
            removelinha();
          } else
          {
            apagalinha();
          }
        }
        if (tipo=='V')
        {
          if (medv<mediaatencao)
          {
            removelinha();
          } else
          {
            apagalinha();
          }
        }
      }
    }
  }
}

void maisregras()//mais regras de modificação do fluxo
{
  if (acertou==0)
  {
    foradefluxo = loadStrings("foradefluxo.txt");
    if (foradefluxo.length>0)
    {
      fluxopassado = loadStrings("fluxopassado.txt");
      String[] temp = new String[fluxopassado.length+1];
      String[] temp2=new String[foradefluxo.length-1];
      String[] temp3= new String[0];
      temp[0]=foradefluxo[0];
      arrayCopy(fluxopassado, 0, temp, 1, fluxopassado.length); //<>//
      arrayCopy(foradefluxo, 1, temp2, 0, foradefluxo.length-1);//aqui
      for (int cont=0; cont<temp.length; cont++)
      { 
        char lic = temp[cont].charAt(0);
        String nova= lic+""+capitulo;
        temp[cont]= nova;
      }
      saveStrings("data/fluxo.txt", temp);
      saveStrings("data/foradefluxo.txt", temp2);
      saveStrings("data/fluxopassado.txt", temp3);
fluxo= loadStrings("fluxo.txt");
  fluxopassado = loadStrings("fluxopassado.txt");
  foradefluxo = loadStrings("foradefluxo.txt");
    } else
    {
      fluxo = loadStrings("fluxo.txt");
      fluxopassado = loadStrings("fluxopassado.txt");
      String[] temp = new String[fluxopassado.length];
      String[] temp2 = new String[fluxo.length];
      arrayCopy(fluxopassado, temp);
      arrayCopy(fluxo, temp2);
      for (int cont=0; cont<temp.length; cont++)
      { 
        char lic = temp[cont].charAt(0);
        String nova= lic+""+capitulo;
        temp[cont]= nova;
      }
      saveStrings("data/fluxo.txt", temp);
      saveStrings("data/fluxopassado.txt", temp2);
      fluxo = loadStrings("fluxo.txt");
      fluxopassado = loadStrings("fluxopassado.txt");
    }
  } else
  {
    fluxo = loadStrings("fluxo.txt");
    fluxopassado = loadStrings("fluxopassado.txt");
    String[] temp = new String[fluxopassado.length];
    String[] temp2 = new String[fluxo.length];
    arrayCopy(fluxopassado, temp);
    arrayCopy(fluxo, temp2);
    for (int cont=0; cont<temp.length; cont++)
    { 
      char lic = temp[cont].charAt(0);
      capitulo = temp[cont].charAt(1)-48+1;
      String nova= lic+""+capitulo;
      temp[cont]= nova;
    }
    saveStrings("data/fluxo.txt", temp);
    saveStrings("data/fluxopassado.txt", temp2);
    fluxo = loadStrings("fluxo.txt");
    fluxopassado = loadStrings("fluxopassado.txt");
  }
}

void confereresposta()//confere se a resposta foi correta, parte do módulo de sensoriamento
{
  if (clicadox<width-width/10&&clicadox>width/10&&clicadoy>(height/5)&&clicadoy<(height/5)+(height/10))
  {
    if (correto==1)
    {
      acertou=1;
    } else
    {
      acertou=0;
    }
    apagalinha();
  }
  if (clicadox<width-width/10&&clicadox>width/10&&clicadoy>2*(height/5)&&clicadoy<(2*(height/5))+(height/10))
  {
    if (correto==2)
    {
      acertou=1;
    } else
    {
      acertou=0;
    }
    apagalinha();
  }
  if (clicadox<width-width/10&&clicadox>width/10&&clicadoy>3*(height/5)&&clicadoy<(3*(height/5))+(height/10))
  {
    if (correto==3)
    {
      acertou=1;
    } else
    {
      acertou=0;
    }
    apagalinha();
  }
  if (clicadox<width-width/10&&clicadox>width/10&&clicadoy>4*(height/5)&&clicadoy<(4*(height/5))+(height/10))
  {
    if (correto==4)
    {
      acertou=1;
    } else
    {
      acertou=0;
    }
    apagalinha();
  }
  clicadox=0;
  clicadoy=0;
}


void apagalinha()//responsável por apagar linha do documento de texto que representa o fluxo e colocar no fluxo passado
{
  fluxo = loadStrings("fluxo.txt");
  fluxopassado = loadStrings("fluxopassado.txt");
  if (fluxo.length>0)
  {
    String[] temp = new String[fluxo.length - 1];
    String[] temp2 = new String[fluxopassado.length + 1];
    arrayCopy(fluxopassado, temp2);
    temp2[fluxopassado.length]=fluxo[0];
    arrayCopy(fluxo, 1, temp, 0, temp.length);
    saveStrings("data/fluxo.txt", temp);
    saveStrings("data/fluxopassado.txt", temp2);
  }
  fluxo = loadStrings("fluxo.txt");
  fluxopassado = loadStrings("fluxopassado.txt");
  clicadox=0;
}

void removelinha()//responsável por remover a linha do fluxo e tirá-la do fluxo posterior
{
  fluxo = loadStrings("fluxo.txt");
  foradefluxo = loadStrings("foradefluxo.txt");
  if (fluxo.length>0)
  {
    String[] temp = new String[fluxo.length - 1];
    String[] temp2 = new String[foradefluxo.length + 1];
    arrayCopy(foradefluxo, temp2);
    temp2[foradefluxo.length]=fluxo[0];
    arrayCopy(fluxo, 1, temp, 0, temp.length);
    saveStrings("data/fluxo.txt", temp);
    saveStrings("data/foradefluxo.txt", temp2);
  }
  fluxo = loadStrings("fluxo.txt");
  foradefluxo = loadStrings("foradefluxo.txt");
  clicadox=0;
}

void dados(String modo)//módulo de dados, que extrai características do sensoriamento
{
  if(modo.equals("ini"))
  {
   mediaatencao=(mediaatencao+leitura)/2;
  }
  if(modo.equals("texto"))
  {
    medt=(medt+leitura)/2;
  }
  if(modo.equals("imagem"))
  {
    medi=(medi+leitura)/2;
  }
  if(modo.equals("video"))
  {
    medv=(medv+leitura)/2;
  }
}

void movieEvent(Movie m) {//função para leitura de vídeo
  m.read();
}