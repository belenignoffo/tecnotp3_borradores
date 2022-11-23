/*
-- Clase PLATAFORMA: carga, dibuja y anima los distintos objetos cuadrados y/o rectangulares de Física (Bolsa, bloques, piso, etcétera).
 
 int t: tamaño de los bloques
 float x_bloque, y_bloque: variables que guardan la posición inicial en X e Y de los bloques
 float x_bolsa, y_bolsa: variables que guardan la posición inicial en X e Y de la bolsa
 
 - void dibujar(x, y, nombre, valor, bloque, r): método para dibujar los bloques fijos
 - void dibujar(x, y, nombre, bolsa): método para dibujar la bolsa
 - void dibujar(x, y, name, r, sensor): método para dibujar los límites del mundo (piso, techo y bordes)
 - void dibujar(x, y, name, r): método para dibujar la bolsa
 */

class Plataforma extends FBox {

  int t;
  float x_inicial, y_inicial;
  float x_bloque, y_bloque;
  boolean derecha;

  Plataforma(float w, float h) {
    super(w, h);
    derecha = false;
    t = 500;
  }

  void dibujar(float x, float y, String nombre, boolean valor, PImage bloque, float r) {
    x_bloque = x;
    y_bloque = y;

    setPosition(x_bloque, y_bloque);
    setName(nombre);
    setGrabbable(true);
    setFillColor(color(0, 255, 0));
    //attachImage(bloque);
    setRestitution(r);
    setStatic(true);
    mundo.add(this);
  }

  void dibujar(float x, float y, String nombre) { // Método para dibujar la bolsa
    x_inicial = x;
    y_inicial = y;
    setPosition(x, y);
    setName(nombre);
    setNoStroke();
    setNoFill();
    setGrabbable(false);
    setRotatable(false);
    setRestitution(0);
    mundo.add(this);
  }

  void dibujar(float x, float y, String name, float r, boolean sensor) { // Método para dar propiedades a los límites del mundo
    setPosition(x, y);
    setName(name);
    setGrabbable(false);
    setStatic(true);
    setSensor(sensor);
    setNoFill();
    //setFillColor(color(0, 0, 0));
    setNoStroke();
    setRestitution(r);
    mundo.add(this);
  }

  void agregarImagen(PImage bolsa) {
    setSensor(false);
    attachImage(bolsa);
  }

  void borrarImagen() {
    dettachImage();
    setSensor(true);
  }

  void mover() {
    if (getX() > x_inicial + 250) {
      derecha = false;
    } else if (getX() < x_inicial - 250) {
      derecha = true;
    }
    if (derecha) {
      setVelocity(150, 0);
    } else {
      setVelocity(-150, 0);
    }
  }

  //void resetear() {
  //  bolsa.setPosition(x_inicial, 890);
  //}
}
