

// --- Importo las librerías
import fisica.*;
import spout.*;
import ddf.minim.*;

// --- Declaro los objetos principales de las librerías
FWorld mundo;
Minim minim;
Sonido s;

// --- Variable del puerto para OSC
int PUERTO_OSC = 12345;

// --- BlobObjectTracker clases
Receptor receptor;
Administrador admin, adminInicio;

// --- Variables de estado y/o tiempo
String estado;
boolean mov0, mov1;

// --- Variables numéricas
int puntos, vidas;
int contadorRosas, contadorAmarillos, contadorCelestes, contadorVioletas;
float [] x, y;

// --- Objetos del juego
Caramelera c;
Plataforma bolsa, piso, bordeIzquierdo, bordeDerecho;
Plataforma flynnPaffRosa, flynnPaffVioleta;
Pendulo penduloIzquierda, penduloDerecha;
ArrayList <Plataforma> bloquesFijos;

// -- Imágenes y estilo
PImage [] golosina, caramelo, imgManchas;
PImage fondo, bolsaRoja, bolsaPuntos, imagenVidas;
ArrayList <PImage> manchas;
PFont fuente;


void setup() {
  size( 800, 1000 );

  // -- Inicializo las librerías
  Fisica.init(this);
  minim = new Minim(this);

  // -- Inicializo los objetos principales de las librerías
  mundo = new FWorld();
  mundo.setEdges();
  s = new Sonido();
  s.playMusicaFondo();

  // --- Inicializo BlobObjectTracker clases
  setupOSC(PUERTO_OSC);
  receptor = new Receptor();
  admin = new Administrador(mundo);

  // -- Inicializo las variables de estado y/o tiempo
  estado = "inicio";
  mov0 = false;
  mov1 = false;

  // -- Cargo imágenes y estilos
  cargarImagenes();
  fuente = createFont("Gaegu-Regular.ttf", 50);

  // -- Inicializo objetos y clases del juego
  c = new Caramelera();
  cs = new ArrayList<Caramelo>();
  cargarBloques();
  cargarPendulos();
  cargarObjetos();

  // -- Inicializo las variables numéricas
  variablesNumericas();
}

void draw() {
  background(255);
  image(fondo, 0, 0);
  receptor.actualizar(mensajes);
  mundo.step();

  if (estado.equals( "inicio" )) {
    mundo.draw();
    image(caramelo[3], 350, 402);
    image(caramelo[2], 525, 468);
    image(caramelo[0], 425, 598);
    image(caramelo[1], 500, 950);
    fill(0);
    textSize(40);
    textAlign(CENTER);
    text("GOBSTOPPER", 400, 100);
    actualizarValoresInicio();
  }
  if (estado.equals( "instrucciones" )) {
    background(255);
    text("ACÁ VAN LAS INSTRUCCIONES", width/2, height/2);
  }
  // --- ESTADO: JUEGO
  if (estado.equals( "juego" )) {
    mundo.draw();

    // -- Métodos de los péndulos
    moverPendulos();

    // -- Métodos de la bolsa
    bolsa.agregarImagen(bolsaRoja);
    bolsa.mover();

    // -- Métodos de la caramelera y caramelos
    c.dibujar();
    direccionarCaramelos();

    // -- Datos de los puntos y las vidas
    pushStyle();
    textFont(fuente);
    fill(0);
    textSize(40);
    image(bolsaPuntos, 75, 32);
    image(imagenVidas, 685, 40);
    text(puntos, 160, 75);
    text(vidas, 650, 75);
    popStyle();

    // -- Manchas
    dibujarManchas(0, x[0], y[0]);
    if ( manchas.size() > 0 ) {
      for (int i = manchas.size(); i > 0; i--) {
        dibujarManchas(i, x[i], y[i]);
      }
    }
  }
  if (estado.equals( "fin" )) {
    mundo.draw();
    textSize(40);
    text("GOBSTOPPER", 400, 100);
    textSize(20);
    text("fin del juego", 400, 150);
    bolsa.borrarImagen();
  }
}

void mouseClicked() {
  switch( estado ) {
  case "inicio":
    estado = "instrucciones";
    break;
  case "instrucciones":
    estado = "juego";
    break;
  case "juego":
    estado = "fin";
    break;
  case "fin":
    estado = "inicio";
    break;
  }
}
void cargarImagenes() {
  golosina = new PImage[9];
  for (int i = 0; i < golosina.length; i++) {
    golosina[i] = loadImage("golosina" + nf(i, 2) + ".png");
  }
  caramelo = new PImage[4];
  for (int i = 0; i < caramelo.length; i++) {
    caramelo[i] = loadImage("candy" + nf(i, 2) + ".png");
  }
  imgManchas = new PImage[4];
  for (int i = 0; i < imgManchas.length; i++) {
    imgManchas[i] = loadImage("mancha_" + nf(i, 2) + ".png");
  }
  fondo = loadImage("fondojuego.png");
  bolsaRoja = loadImage("bolsa_roja.png");
  bolsaPuntos = loadImage("bolsapuntos.png");
  imagenVidas = loadImage("corazon.png");

  manchas = new ArrayList<PImage>();
}

void cargarBloques() {
  bloquesFijos = new ArrayList<Plataforma>();

  for (int i = 0; i < 7; i ++) {
    Plataforma bf = new Plataforma(60, 50);
    bloquesFijos.add(bf);
  }
  // Izquierda
  bloquesFijos.get(0).dibujar(130, 273, "fijo", false, golosina[2], 0.5);
  bloquesFijos.get(1).dibujar(310, 468, "fijo", false, golosina[4], 0.5);
  bloquesFijos.get(2).dibujar(190, 336, "fijo", false, golosina[8], 1);

  // Derecha
  bloquesFijos.get(3).dibujar(670, 403, "fijo", false, golosina[8], 1);
  bloquesFijos.get(4).dibujar(550, 533, "fijo", false, golosina[3], 0.5);
  bloquesFijos.get(5).dibujar(430, 662, "fijo", false, golosina[6], 0.5);
  bloquesFijos.get(6).dibujar(670, 662, "fijo", false, golosina[7], 0.5);

  flynnPaffRosa = new Plataforma(60, 50);
  flynnPaffRosa.dibujar(375, 468, "fijo", false, golosina[0], 0.2);

  flynnPaffVioleta = new Plataforma(60, 50);
  flynnPaffVioleta.dibujar(130, 567, "fijo", false, golosina[1], 0.2);
}

void cargarPendulos() {
  penduloIzquierda = new Pendulo("chupetin0");
  penduloIzquierda.dibujarPendulo(580, 208);
  penduloDerecha = new Pendulo("chupetin1");
  penduloDerecha.dibujarPendulo(220, 629);
}

void cargarObjetos() {
  // -- Bolsa
  bolsa = new Plataforma(100, 110);
  bolsa.dibujar(400, 930, "bolsaRoja");

  // -- Bordes
  bordeIzquierdo = new Plataforma(35, height);
  bordeDerecho = new Plataforma(35, height);
  bordeIzquierdo.dibujar(20, 500, "borde", 0.8, false);
  bordeDerecho.dibujar(780, 500, "borde", 0.8, false);

  // -- Piso
  piso = new Plataforma(width, 10);
  piso.dibujar(400, 990, "piso", 0, true);
}

void variablesNumericas() {
  puntos = 0;
  vidas = 10;
  contadorRosas = 0;
  contadorAmarillos = 0;
  contadorVioletas = 0;
  contadorCelestes = 0;

  x = new float [vidas];
  y = new float [vidas];

  for (int i = 0; i < x.length; i ++) {
    x[i] = random( 160, 640 );
  }
  for (int i = 0; i < y.length; i ++) {
    y[i] = random( 200, 800 );
  }
}

void moverPendulos() {
  if (mov0) {
    penduloIzquierda.mover(190);
  }
  if (mov1) {
    penduloDerecha.mover(170);
  }
}
