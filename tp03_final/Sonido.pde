class Sonido {
  AudioPlayer musica;
  AudioSample fin, caramelera, puntos, mancha, chupetin;

  float valor;

  Sonido() {
    musica = minim.loadFile("musica_fondo.wav", 2048);
    fin = minim.loadSample("fin_2.wav", 512);
    caramelera = minim.loadSample("candymachine.mp3", 512);
    puntos = minim.loadSample("puntos.wav", 512);
    mancha = minim.loadSample("sonidomancha.mp3", 512);
    chupetin = minim.loadSample("chupetin.mp3", 512);
  }

  void playMusicaFondo() {
    musica.loop();
  }

  void playFin() {
    musica.pause();
    musica.rewind();
    fin.trigger();
  }

  void playPuntos() {
    puntos.trigger();
  }

  void playMancha() {
    mancha.trigger();
  }

  void playCaramelera() {
    caramelera.trigger();
  }

  void playReboteChupetin() {
    chupetin.trigger();
  }
}
