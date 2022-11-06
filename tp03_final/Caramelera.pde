/*
-- Clase CARAMELERA: carga, dibuja y anima la caramelera. También se encarga de agregar los caramelos.
 
 PImage [] caramelera: cargo las imágenes de la animación
 
 int currentFrame, loopFrame, delay, valorIncremento: variables para controlar la animación
 
 String direccion: lógica de estados
 int contadorCaramelos, valorIncrementoCaramelos: controla el tiempo en el que se agregan los caramelos
 int contador, contadorInicioSprite: controla el inicio de la animación
 
 Reloj r: tiempo entre un estado y otro
 
 float x0, x1, x2, y: posición de los caramelos
 
 - void dibujarCaramelera: se dibuja la caramelera y se ejecutan los demás métodos para su animación
 
 - void moverCaramelera: controla el movimiento de la animación. Los parámetros son: frame en el que se detiene el sprite,
 frame en el que se agregan los caramelos, posición en X del caramelo, posición en Y del caramelo, fuerza en X del caramelo
 
 - void cambiarDireccion: cambia la dirección de la caramelera. Los parámetros son: frame en el que se reanuda la animación,
 nuevo valor asignado a la variable 'direccion'
 
 - void agregarCaramelos: método para agregar nuevos caramelos al arraylist. Los parámetros son: posición en x, posición en y, fuerza en x del caramelo.
 
 - void resetearValores: resetea todas las variables
 
 */

ArrayList <Caramelo> cs;

class Caramelera {

  PImage [] caramelera;

  int currentFrame, loopFrame, delay, valorIncremento;

  String direccion;
  int contadorCaramelos, valorIncrementoCaramelos;
  int contador, contadorInicioSprite;

  Reloj r;

  float x0, x1, x2, y, x_c;

  FCircle fondoCaramelera;

  Caramelera() {
    currentFrame = 0;
    loopFrame = 74;
    delay = 0;
    valorIncremento = 1;

    caramelera = new PImage[loopFrame];
    for (int i = 0; i < caramelera.length; i++) {
      caramelera[i] = loadImage("caramelera_" + nf(i, 2) + ".png");
    }

    r = new Reloj();

    direccion = "";

    contadorCaramelos = 0;
    contadorInicioSprite = 0;

    contador = 0;

    x0 = 400;
    x1 = 520;
    x2 = 280;
    x_c = 400;
    y = 210;

    fondoCaramelera = new FCircle(200);
    fondoCaramelera.setStatic(true);
    fondoCaramelera.setPosition(width/2, 100);
    fondoCaramelera.setNoStroke();
    fondoCaramelera.setNoFill();
    mundo.add(fondoCaramelera);
  }

  void dibujar() {
    int i = 1;
    r.actualizar();
    contadorInicioSprite++;

    pushStyle();
    imageMode(CENTER);
    image(caramelera[currentFrame], x_c, 180);
    popStyle();
    if (contadorInicioSprite > 200) {
      contador += i;
      if (delay == 0) {
        currentFrame = (currentFrame + valorIncremento) % loopFrame;
      }
      delay = (delay + 1) % 3;
      if (currentFrame == 8) {
        direccion = "derecha";
        if (contador == 24) {
          s.playCaramelera();
        }
      }
      switch(direccion) {
      case "derecha":
        moverCaramelera(20, 45, x1, y, 10000);
        cambiarDireccion(28, "centro");
        break;
      case "centro":
        moverCaramelera(39, 50, x0, y, 0);
        moverCaramelera(72, 50, x0, y, 0);
        cambiarDireccion(45, "izquierda");
        cambiarDireccion(2, "derecha");
        break;
      case "izquierda":
        moverCaramelera(55, 20, x2, y, -10000);
        cambiarDireccion(61, "centro");
        i = 0;
        contador = 0;
        break;
      }
    }
  }

  void moverCaramelera(int actualFrame, int frameCaramelos, float x, float y, float fuerza) {
    int caramelos =  frameCaramelos;
    if (currentFrame == actualFrame) {
      valorIncremento = 0;
      valorIncrementoCaramelos = 1;
    }
    contadorCaramelos += valorIncrementoCaramelos;
    if (contadorCaramelos == caramelos) {
      agregarCaramelos(x, y, fuerza);
    }
  }

  void cambiarDireccion(int valor, String nuevaDireccion) {
    if (r.timer!= 0) {
      if (r.terminoTiempo()) {
        valorIncremento = 1;
      }
    }
    if (currentFrame == valor) {
      direccion = nuevaDireccion;
      contadorCaramelos = 0;
      s.playCaramelera();
      r.resetear();
    }
  }

  void agregarCaramelos(float x, float y, float fuerza) {
    int cantidad = floor(random(1, 5));
    for (int i = 0; i < cantidad; i++) {
      Caramelo c = new Caramelo(40);
      c.dibujar(x, y);
      cs.add(c);
      c.addForce(fuerza, 0);
    }
    if (cantidad > 3) {
      r.setTimer(5);
    } else {
      r.setTimer(10);
    }
  }

  void resetear() {
    currentFrame = 0;
    valorIncremento = 1;
    contadorCaramelos = 0;
    delay = 0;
    direccion = "";
    contador = 0;
    contadorInicioSprite = 0;
    r.resetear();
  }
}
