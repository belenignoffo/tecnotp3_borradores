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
    chupetin.setName(nombre);
    mundo.add(chupetin);

    // --- DISTANCEJOINT
    pendulo = new FDistanceJoint(eje, chupetin);
    pendulo.setLength(pendulo_length);
    mundo.add(pendulo);
  }

  void moverPendulo(float velocidad) {
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
