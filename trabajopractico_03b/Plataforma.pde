/*
-- Clase PLATAFORMA
  int t: tamaño de los bloques
  float x_bloque, y_bloque: variables que guardan la posición inicial en X e Y de los bloques
  float x_bolsa, y_bolsa: variables que guardan la posición inicial en X e Y de la bolsa
  
  - void dibujar(x, y, nombre, valor, bloque, r): método para dibujar los bloques fijos
  - void dibujar(x, y, nombre, bolsa): método para dibujar la bolsa
  - void dibujar(x, y, name, r): método para dibujar la bolsa
 */

class Plataforma extends FBox {

  int t;
  //float x_inicial, y_inicial;
  float x_bloque, y_bloque;

  Plataforma(float w, float h) {
    super(w, h);
    t = 50;

  }

  void dibujar(float x, float y, String nombre, boolean valor, PImage bloque, float r) {
    x_bloque = x;
    y_bloque = y;

    setPosition(x_bloque, y_bloque);
    setName(nombre);
    setGrabbable(valor);
    attachImage(bloque);
    setRestitution(r);
    setStatic(true);
    mundo.add(this);
  }

  void dibujar(float x, float y, String nombre, PImage bolsa) {
    setPosition(x, y);
    setName(nombre);
    setRestitution(0);
    attachImage(bolsa);
    mundo.add(this);
  }

  void dibujar(float x, float y, String name, float r) { // Método para dar propiedades a los límites del mundo
    setPosition(x, y);
    setName(name);
    setGrabbable(false);
    setStatic(true);
    setNoFill();
    setNoStroke();
    setRestitution(r);
    mundo.add(this);
    //inicio.add(this);
    //fin.add(this);
  }
}
