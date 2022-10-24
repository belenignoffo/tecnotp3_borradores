/*
COMISIÓN: LISANDRO & ABRIL
 TRABAJO PRÁCTICO 03
 */
GestorSenial gX, gY;

// -- Importo las distintas librerías
import fisica.*;

// -- Creo los objetos de las lib
FWorld mundo, inicio;

// -- Declara la variable del puerto para OSC
int PUERTO_OSC = 12345;

// -- Clases BBtracker
Receptor receptor;
Administrador admin, adminInicio;

// -- Variables de estado / tiempo
String estado;
boolean mov0, mov1;
Reloj r;

// Variables del juego
int puntos, vidas;
float x0, x1, x2, x3, y0, y1, y2, y3;
int contador_rosas, contador_amarillos, contador_celestes, contador_violetas;

// -- Clases y objetos del juego
Caramelera c;
Pendulo p, p1;
Borde bordeizq, bordeder;
Plataforma bolsa, piso, flynnPaffRosa, flynnPaffVioleta;
FBox ppuntos, pvidas;
FCircle ccaramelera;
ArrayList <Plataforma> bloquesFijos;

// -- Imágenes
PImage [] golosina;
PImage bolsaRoja, bolsaPuntos, imagenVidas;
PImage fondoJuego;
PImage [] imgManchas;
ArrayList <PImage> manchas;
PFont font;

void setup() {
  size(800, 1000);

  // -- Inicializo las librerías
  Fisica.init(this);

  // -- Inicializo los objetos de las lib
  mundo = new FWorld();
  mundo.setEdges();
  inicio = new FWorld();
  inicio.setEdges();

  // -- Inicializo los objetos de OSC y BBtracker
  setupOSC(PUERTO_OSC);
  receptor = new Receptor();
  admin = new Administrador(mundo);
  adminInicio = new Administrador(inicio);

  // -- Inicializo variables de estado / tiempo
  estado = "inicio";
  mov0 = false;
  mov1 = false;
  r = new Reloj();

  // -- Inicializo variables del juego
  puntos = 0;
  vidas = 5;
  x0 = random(140, width-140); // -- de x0 a x3 - y0 a y3, son las posiciones de las manchas
  x1 = random(140, width-140);
  x2 = random(140, width-140);
  x3 = random(140, width-140);
  y0 = random(100, height-200);
  y1 = random(100, height-200);
  y2 = random(100, height-200);
  y3 = random(100, height-200);
  contador_rosas = 0;
  contador_amarillos = 0;
  contador_celestes = 0;
  contador_violetas = 0;

  // -- Métodos para carga de imágenes y objetos
  cargarImagenes();
  cargarBloques();
  cargarPendulo();

  // -- Inicializo clases y objetos del juego
  c = new Caramelera();
  cs = new ArrayList<Caramelo>();
  bolsa = new Plataforma(100, 110);
  bolsa.dibujar(width/2, height-70, "bolsaRoja", bolsaRoja);
  bordeder = new Borde(0, 0);
  bordeizq = new Borde(width-39, 0);
  piso = new Plataforma(width, 10);
  piso.dibujar(width/2, height-10, "piso", 0);
  cargarObjetosInvisibles(); // Estos objetos ocupan el espacio de los puntos, la caramelera y los puntos, es para que los caramelos no los "traspasen" y reboten contra ellos
}

void draw() {

  receptor.actualizar(mensajes);


  switch(estado) {
  case "inicio":
    background(255);
    inicio.step();
    inicio.draw();
    bordeder.dibujar();
    bordeizq.dibujar();
    resetearVariables();
    pushStyle();
    textFont(font);
    fill(0);
    text("INICIO", width/2-70, height/2);
    popStyle();
    line(width/2, 0, width/2, height);
    for (Blob b : receptor.blobs) {
      if (b.entro) {
        adminInicio.crearPuntero(b);
      }
      if (b.salio) {
        adminInicio.removerPuntero(b);
      }
      adminInicio.actualizarPuntero(b);
      adminInicio.dibujar();
      if ((b.centroidX * width > 380 && b.centroidX < 420 * width)
        && (b.centroidY * height > 480 && b.centroidY * height < 520)) {
        estado = "instrucciones";
      }
    }
    break;
  case "instrucciones":
    background(255);
    r.actualizar();
    r.setTimer(4);
    bordeder.dibujar();
    bordeizq.dibujar();
    pushStyle();
    textFont(font);
    fill(0);
    text("INSTRUCCIONES", width/2-180, height/2);
    popStyle();
    if (r.timer < 1) {
      estado = "juego";
      break;
    }
    break;
  case "juego":
    background(255);
    image(fondoJuego, 0, 0);
    mundo.step();
    mundo.draw();
    bordeder.dibujar();
    bordeizq.dibujar();
    direccionarCaramelos();
    pushStyle();
    textFont(font);
    fill(0);
    textSize(40);
    image(bolsaPuntos, 75, 32);
    image(imagenVidas, width-115, 40);
    text(puntos, 145, 75);
    text(vidas, width-150, 75);
    popStyle();
    if (mov0) {
      p.moverPendulo(180);
    }
    if (mov1) {
      p1.moverPendulo(170);
    }
    c.dibujarCaramelera();
    dibujarManchas(0, x0, y0);
    dibujarManchas(1, x1, y1);
    dibujarManchas(2, x2, y2);
    dibujarManchas(3, x3, y3);

    for (Blob b : receptor.blobs) {
      if (b.entro) {
        admin.crearPuntero(b);
        println("--> entro blob: " + b.id);
      }
      if (b.salio) {
        admin.removerPuntero(b);
        println("<-- salio blob: " + b.id);
      }

      admin.actualizarPuntero(b);
      admin.dibujar();
    }
    break;
  case "fin":
    background(255);
    resetearPosiciones();
    r.actualizar();
    r.setTimer(4);
    bordeder.dibujar();
    bordeizq.dibujar();
    pushStyle();
    textFont(font);
    fill(0);
    text("FIN", width/2-60, 100);
    textSize(40);
    text("Caramelos rosas", 100, 200);
    text("Caramelos amarillos", 100, 280);
    text("Caramelos celestes", 100, 360);
    text("Caramelos violetas", 100, 440);
    text(contador_rosas, width/2+200, 200);
    text(contador_amarillos, width/2+200, 280);
    text(contador_celestes, width/2+200, 360);
    text(contador_violetas, width/2+200, 440);
    popStyle();
    if (r.timer < 1) {
      estado = "inicio";
      break;
    }
    break;
  }
  for (Blob b : receptor.blobs) {
    if (b.salio) {
      admin.removerPuntero(b);
      adminInicio.crearPuntero(b);
    }
    admin.actualizarPuntero(b);
    adminInicio.actualizarPuntero(b);
  }
  println(r.timer);
}

void cargarImagenes() {
  golosina = new PImage[9];
  for (int i = 0; i < golosina.length; i++) {
    golosina[i] = loadImage("golosina" + nf(i, 2) + ".png");
  }
  bolsaRoja = loadImage("bolsa_roja.png");
  fondoJuego = loadImage("fondojuego.png");
  fondoJuego.resize(800, 1000);
  bolsaPuntos = loadImage("bolsapuntos.png");
  imagenVidas = loadImage("corazon.png");
  font = createFont("Gaegu-Regular.ttf", 50);
  imgManchas = new PImage[4];
  for (int i = 0; i < imgManchas.length; i++) {
    imgManchas[i] = loadImage("mancha_" + nf(i, 2) + ".png");
  }
  manchas = new ArrayList<PImage>();
}

void cargarBloques() {
  bloquesFijos = new ArrayList<Plataforma>();

  for (int i = 0; i < 7; i ++) {
    Plataforma bf = new Plataforma(60, 50);
    bloquesFijos.add(bf);
  }
  // Izquierda
  bloquesFijos.get(0).dibujar(width/2-270, (height/2-32)-195, "fijo", true, golosina[2], 0.5);
  bloquesFijos.get(1).dibujar(width/2-90, (height/2-32), "fijo", true, golosina[4], 0.5);
  bloquesFijos.get(2).dibujar(width/2-270, (height/2+32)+35, "fijo", true, golosina[8], 1);

  // Derecha
  bloquesFijos.get(3).dibujar(width/2+270, (height/2-32)-65, "fijo", true, golosina[8], 1);
  bloquesFijos.get(4).dibujar(width/2+150, (height/2-32)+65, "fijo", true, golosina[3], 0.5);
  bloquesFijos.get(5).dibujar(width/2+30, (height/2+32)+130, "fijo", true, golosina[6], 0.5);
  bloquesFijos.get(6).dibujar(width/2+270, (height/2+32)+130, "fijo", true, golosina[7], 0.5);

  flynnPaffRosa = new Plataforma(60, 50);
  flynnPaffRosa.dibujar(width/2-25, (height/2-32), "fijo", true, golosina[0], 0.2);

  flynnPaffVioleta = new Plataforma(60, 50);
  flynnPaffVioleta.dibujar(width/2-210, (height/2-32)-132, "fijo", true, golosina[1], 0.2);
}

void cargarPendulo() {
  p = new Pendulo("chupetin0");
  p.dibujarPendulo(width/2+180, (height/2-32)-260);

  p1 = new Pendulo("chupetin1");
  p1.dibujarPendulo(width/2-180, (height/2+32)+97);
}

void cargarObjetosInvisibles() {
  ppuntos = new FBox(100, 50);
  ppuntos.setStatic(true);
  ppuntos.setPosition(120, 65);
  ppuntos.setNoStroke();
  ppuntos.setNoFill();
  mundo.add(ppuntos);

  pvidas = new FBox(100, 50);
  pvidas.setStatic(true);
  pvidas.setPosition(width-120, 60);
  pvidas.setNoStroke();
  pvidas.setNoFill();
  mundo.add(pvidas);

  ccaramelera = new FCircle(150);
  ccaramelera.setStatic(true);
  ccaramelera.setPosition(width/2, 75);
  ccaramelera.setNoStroke();
  ccaramelera.setNoFill();
  mundo.add(ccaramelera);
}
