/**
Controlando braço robótico MeArM
Usando qualquer controle compatível
Processing, Firmata e Game Control Plus
by Davi Colares
*/

//Importa as bibliotecas necessárias
import cc.arduino.*;
import processing.serial.*;
import org.gamecontrolplus.gui.*;
import org.gamecontrolplus.*;
import net.java.games.input.*;

//Define algumas coisas úteis para GCP e Firmata
ControlIO control;
ControlDevice stick;
Arduino arduino;

//Define as variáveis
//Valores que recebe do Joystick
//Pinos dos servos e valores iniciais
float c_base, c_left, c_right, c_claw;
int base = 8, 
    left = 13,
    right = 7,
    claw = 12,
    initial_base = 90,
    initial_left = 90,
    initial_right = 90,
    initial_claw = 90;

public void setup()
{
  //Printa as portas disponíveis
  println(Serial.list());
  //Define a porta do Arduino
  //Começando do 0
  //Troque port pela porta
  arduino = new Arduino(this, Arduino.list()[port], 57600);
  
  //Define os pinos do servos
  arduino.pinMode(base, Arduino.SERVO);
  arduino.pinMode(left, Arduino.SERVO);
  arduino.pinMode(right, Arduino.SERVO);
  arduino.pinMode(claw, Arduino.SERVO);
  
  //Coloca eles na posição inicial
  arduino.servoWrite(base, initial_base);
  arduino.servoWrite(left, initial_left);
  arduino.servoWrite(right, initial_right);
  arduino.servoWrite(claw, initial_claw);
  
  //Abre a tela de selação de controle do GCP
  surface.setTitle("PS4 com MeArm by Davi Colares");
  control = ControlIO.getInstance(this);
  stick = control.filter(GCP.STICK).getMatchedDevice("nome_do_arquivo");
  if (stick == null){
    println("Nenhum dispositivo configurado");
    System.exit(-1);
  }
}

//Função que pega os valores do joystick
public void getUserInput(){
  c_base = map(stick.getSlider("nome_X").getValue(), -1, 1, 0, width);
  c_left = map(stick.getSlider("nome_Y").getValue(), -1, 1, 0, height);
  c_right = map(stick.getSlider("nome_Z").getValue(), -1, 1, 0, width);
  c_claw = map(stick.getSlider("nome_W").getValue(), -1, 1, 0, height);
  
  //Usando as mesmas configurações
  //O valor 50 vai ser dado quando
  //o analógico estiver parado
  //Multiplicando por 1.8 temos 90
  c_base = c_base *1.8;
  c_left = c_left *1.8;
  c_right = c_right *1.8;
  c_claw = c_claw *1.8;
}

public void draw(){
  //Printa os valores do joystick
  println(int(c_base), int(c_left), int(c_right), int(c_claw));
  //Chama a função do joystick
  getUserInput();
  //Controla os servos de acordo com o joystick
  arduino.servoWrite(base, int(c_base));
  arduino.servoWrite(left, int(c_left));
  arduino.servoWrite(right, int(c_right));
  arduino.servoWrite(claw, int(c_claw));

  //Delay para não sobrecarregar o arduino
  //E não queimar os servos
  delay(5);
}
