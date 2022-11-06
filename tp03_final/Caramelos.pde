/*
-- Clase CARAMELO: carga, dibuja y asigna las distintas propiedades a cada tipo de caramelo.
 
 PImage [] caramelo: cargo las imágenes de los distintos caramelos
 
 - void dibujar: dibujo los caramelos y le asigno las propiedades según su color.
 - void borrar: elimino los caramelos del FWorld.
 */

class Caramelo extends FCircle {

  PImage [] caramelo;
  Caramelo(float r) {
    super(r);

    caramelo = new PImage[4];
    for (int i = 0; i < caramelo.length; i++) {
      caramelo[i] = loadImage("candy" + nf(i, 2) + ".png");
    }
  }

  void dibujar(float x, float y) {
    setPosition(x, y);
    addImpulse(0, 6000);
    //setGrabbable(false);
    float porcentaje = random(100);
    // -- CARAMELO ROSA
    if (porcentaje > 0 && porcentaje < 25) {
      attachImage(caramelo[0]);
      setDensity(0.2);
      setName("caramelo_rosa");
    }
    // -- CARAMELO VIOLETA
    else if (porcentaje > 25 && porcentaje < 50) {
      attachImage(caramelo[1]);
      setDensity(0.4);
      setName("caramelo_violeta");
    }
    // -- CARAMELO AMARILLO
    else if (porcentaje > 50 && porcentaje < 75) {
      attachImage(caramelo[2]);
      setDensity(0.7);
      setName("caramelo_amarillo");
    }
    // -- CARAMELO CELESTE
    else if (porcentaje > 75) {
      attachImage(caramelo[3]);
      setDensity(1);
      setName("caramelo_celeste");
    }
    mundo.add(this);
  }

  void borrar() {
    mundo.remove(this);
  }
}
