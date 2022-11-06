/*
-- Clase PENDULO: carga, dibuja y anima a los chupetines en forma de péndulo.
 
 FBox eje: esta caja en Física determina el eje/ubicación en X de los péndulos
 FCircle chupetin: es el círculo del péndulo
 FDistanceJoint pendulo: es el joint que usamos para unir los dos cuerpos de física y generar el movimiento pendular
 
 float tam_eje, tam_chupetin, pendulo_length, y_chupertin, x_chupetin: es el tamaño de los objetos y su ubicación
 boolean derecha: variable que nos va a indicar si el movimiento es (o no) hacia la derecha
 PImage img_chupetin: imagen del FCircle del péndulo
 String nombre: nombre que se le va a asignar a cada objeto Pendulo
 
 - void dibujarPendulo(x, y): dibujamos cada parte del objeto (eje, círculo y distancejoint) y lo ubicamos en las posiciones asignadas por parámetro.
 - void moverPendulo(velocidad): es un método para darle movimiento al objeto. La velocidad está determinada por el parámetro.
 - void resetearPendulo(): método para volver los valores a los iniciales y dejarlo estático nuevamente.
 */

class Pendulo {

  FBox eje;
  FCircle chupetin;
  FDistanceJoint pendulo;

  float tam_eje, tam_chupetin, pendulo_length, y_chupetin, x_chupetin;
  boolean derecha;
  PImage img_chupetin;
  String nombre;

  Pendulo(String nombre) {
    this.nombre = nombre;

    tam_eje = 20;
    tam_chupetin = 70;
    pendulo_length = 90;
    img_chupetin = loadImage("chupetin.png");
    derecha = false;
  }

  void dibujarPendulo(float x, float y) {
    x_chupetin = x;
    y_chupetin = (y + 100) - (tam_chupetin/2);

    // --- EJE
    eje = new FBox(tam_eje, tam_eje);
    eje.setGrabbable(false);
    eje.setPosition(x, y);
    eje.setStatic(true);
    eje.setSensor(true);
    eje.setNoFill();
    eje.setNoStroke();
    mundo.add(eje);

    // --- CHUPETIN
    chupetin = new FCircle(tam_chupetin);
    chupetin.setPosition(x_chupetin, y_chupetin);
    chupetin.attachImage(img_chupetin);
    chupetin.setRestitution(1);
    chupetin.setRotatable(false);
    chupetin.setName(nombre);
    mundo.add(chupetin);

    // --- DISTANCEJOINT
    pendulo = new FDistanceJoint(eje, chupetin);
    pendulo.setLength(pendulo_length);
    mundo.add(pendulo);
  }

  void mover(float velocidad) {
    if (chupetin.getX() > x_chupetin + 90) {
      derecha = false;
    } else if (chupetin.getX() < x_chupetin - 90) {
      derecha = true;
    }
    if (derecha) {
      chupetin.setVelocity(velocidad, 0);
    } else {
      chupetin.setVelocity(-(velocidad), 0);
    }
  }

  void resetearPendulo() {
    if (derecha) {
      chupetin.setPosition(x_chupetin, y_chupetin);
      chupetin.setVelocity(0, 0);
    } else {
      chupetin.setPosition(x_chupetin, y_chupetin);
      chupetin.setVelocity(0, 0);
    }
  }
  
}
