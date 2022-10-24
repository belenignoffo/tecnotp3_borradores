class Borde {

  float x, y;
  int currentFrame, loopFrame, delay;
  PImage [] borde;

  Plataforma b1, b2;

  Borde(float x, float y) {
    this.x = x;
    this.y = y;
    currentFrame = 0;
    loopFrame = 8;
    delay = 0;
    borde = new PImage[loopFrame];

    for (int i = 0; i < borde.length; i++) {
      borde[i] = loadImage("borde" + nf(i, 2) + ".png");
    }

    b1 = new Plataforma(35, height);
    b2 = new Plataforma(35, height);
    b1.dibujar(20, height/2, "borde", 0.8);
    b2.dibujar(width-20, height/2, "borde", 0.8);
  }

  void dibujar() {
    image(borde[currentFrame], x, y);
    display();
  }

  void display() {
    if (delay == 0) {
      currentFrame = (currentFrame + 1) % loopFrame;
    }
    delay = (delay + 1) % 10;
  }
}
