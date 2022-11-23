

// --- Importo las librerías
import fisica.*;
import spout.*;
import ddf.minim.*;

// --- Declaro los objetos principales de las librerías
FWorld mundo;
Minim minim;
Spout sender;
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
int frameActualPaleta;
float [] x, y;

// --- Objetos del juego
Caramelera c;
Plataforma bolsa, piso, bordeIzquierdo, bordeDerecho;
Plataforma flynnPaffRosa, flynnPaffVioleta;
Pendulo penduloIzquierda, penduloDerecha;
ArrayList <Plataforma> bloquesFijos;

// -- Imágenes y estilo
PImage [] golosina, caramelo, imgManchas;
PImage [] vidas_sprite;
PImage fondo, bolsaRoja, bolsaPuntos, imagenVidas, fondoInicio, fondoFinal, fondoInstrucciones;
PImage fondoPuntos;
ArrayList <PImage> manchas;
PFont fuente;

// -- Posición en X e Y de los bloques
float [] posicionX;
float [] posicionY;
float xfpRosa, yfpRosa, xfpVioleta, yfpVioleta;


// -- PRUEBA

PImage [] bolsaDestellos;
int bolsaDestellosFrame, bolsaDestellosLoop, bolsaDestellosDelay, bolsaDestellosValor;



void setup() {
  size( 800, 1000, P3D );

  // -- Inicializo las librerías
  Fisica.init(this);
  minim = new Minim(this);
  sender = new Spout(this);

  // -- Inicializo los objetos principales de las librerías
  mundo = new FWorld();
  mundo.setEdges();
  s = new Sonido();
  s.playMusicaFondo();
  sender.setSenderName("Trabajo final");

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

  // -- POSICIONES EN X E Y
  posicionX = new float [5];
  posicionY = new float [5];

  // -- VARIABLES PRUEBA

  bolsaDestellosFrame = 0;
  bolsaDestellosLoop = 14;
  bolsaDestellosDelay = 0;
  bolsaDestellosValor = 0;

  bolsaDestellos = new PImage[bolsaDestellosLoop];
  for ( int i = 0; i < bolsaDestellos.length; i ++) {
    bolsaDestellos[i] = loadImage("bolsapsrite_" + nf(i, 2) + ".png");
  }
}

void draw() {
  background(255);

  receptor.actualizar(mensajes);
  mundo.step();

  if (estado.equals( "inicio" )) {
    image(fondoInicio, 0, 0);

    mundo.draw();

    image(caramelo[3], 350, 402);
    image(caramelo[2], 525, 468);
    image(caramelo[0], 425, 598);
    image(caramelo[1], 635, 598);

    actualizarValoresInicio();

    // --- Posición actual de los bloques en X e Y
    for (int i = 0; i < posicionX.length; i ++) {
      posicionX[i] = bloquesFijos.get(i).getX();
    }
    for ( int i = 0; i < posicionY.length; i ++) {
      posicionY[i] = bloquesFijos.get(i).getY();
    }
    xfpRosa = flynnPaffRosa.getX();
    yfpRosa = flynnPaffRosa.getY();
    xfpVioleta = flynnPaffVioleta.getX();
    yfpVioleta = flynnPaffVioleta.getY();
    
  }
  if (estado.equals( "instrucciones" )) {
    image(fondoInstrucciones, 0, 0);

    mundo.draw();

    image(caramelo[3], 350, 402);
    image(caramelo[2], 525, 468);
    image(caramelo[0], 425, 598);
    image(caramelo[1], 635, 598);
  }
  // --- ESTADO: JUEGO
  if (estado.equals( "juego" )) {
    image(fondo, 0, 0);
    mundo.draw();

    // -- Métodos de los péndulos
    moverPendulos();

    // -- Métodos de la bolsa
    bolsa.agregarImagen(bolsaDestellos[bolsaDestellosFrame]);
    bolsa.mover();

    if ( bolsaDestellosDelay == 0 ) {
      bolsaDestellosFrame = ( bolsaDestellosFrame + bolsaDestellosValor ) % bolsaDestellosLoop ;
    }
    bolsaDestellosDelay = ( bolsaDestellosDelay + 1 ) % 4;

    if ( bolsaDestellosFrame >= 13) {
      bolsaDestellosFrame = 0;
      bolsaDestellosValor = 0;
    }

    // -- Métodos de la caramelera y caramelos
    c.dibujar();
    direccionarCaramelos();

    // -- Datos de los puntos y las vidas
    pushStyle();
    textFont(fuente);
    fill(0);
    textSize(40);
    image(bolsaPuntos, 75, 32);
    image(vidas_sprite[frameActualPaleta], 685, 40);
    if (frameActualPaleta >= vidas_sprite.length) {
      frameActualPaleta = 0;
    }
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

    for (Blob b : receptor.blobs) {
      admin.actualizarPuntero(b);
      admin.dibujar();
      if (b.entro) {
        println("entró 1");
        admin.crearPuntero(b);
        println("entró");
      }
      if (b.salio) {
        println("salió 1");
        admin.removerPuntero(b);
        println("salió");
      } else {
        //println("actualizar 1");
      }
    }
  }

  if (estado.equals( "fin" )) {
    image(fondoFinal, 0, 0);
    mundo.draw();
    bolsa.borrarImagen();
  }
  //sender.sendTexture();
}

void mouseClicked() {
  //switch( estado ) {
  //case "inicio":
  //  estado = "instrucciones";
  //  break;
  //case "instrucciones":
  //  estado = "juego";
  //  break;
  //case "juego":
  //  estado = "fin";
  //  break;
  //case "fin":
  //  estado = "inicio";
  //  break;
  //}
}
void keyPressed() {
  if ( key == 'x' || key == 'X' ) {
    println("Posición en X de los bloques: " );
    printArray(posicionX);
    println("FlynnPaff rosa: " + xfpRosa );
    println("FlynnPaff violeta: " + xfpVioleta );
  }
  if ( key == 'y' || key == 'Y' ) {
    println("Posición en Y de los bloques: " );
    printArray(posicionY);
    println("FlynnPaff rosa: " + yfpRosa );
    println("FlynnPaff violeta: " + yfpVioleta );
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
  //imagenVidas = loadImage("corazon.png");
  vidas_sprite = new PImage[11];
  for ( int i = 0; i < vidas_sprite.length; i++ ) {
    vidas_sprite[i] = loadImage( "vidas_" + nf(i, 2) + ".png" );
  }

  manchas = new ArrayList<PImage>();

  fondoPuntos = loadImage("pantalla_final.png");

  fondoInicio = loadImage("p_inicio.png");
  fondoFinal = loadImage("p_final.png");
  fondoInstrucciones = loadImage("p_reglas.png");
}

void cargarBloques() {
  bloquesFijos = new ArrayList<Plataforma>();

  for (int i = 0; i < 5; i ++) {
    Plataforma bf = new Plataforma(80, 80);
    bloquesFijos.add(bf);
  }
  // Izquierda
  //bloquesFijos.get(0).dibujar(130, 273, "fijo", false, golosina[2], 0.5);
  bloquesFijos.get(0).dibujar(310, 468, "fijo", false, golosina[7], 0.5);
  bloquesFijos.get(1).dibujar(190, 336, "fijo", false, golosina[8], 1);

  // Derecha
  bloquesFijos.get(2).dibujar(670, 403, "fijo", false, golosina[8], 1);
  //bloquesFijos.get(4).dibujar(550, 533, "fijo", false, golosina[3], 0.5);
  bloquesFijos.get(3).dibujar(430, 662, "fijo", false, golosina[6], 0.5);
  bloquesFijos.get(4).dibujar(670, 662, "fijo", false, golosina[5], 0.5);

  flynnPaffRosa = new Plataforma(80, 80);
  flynnPaffRosa.dibujar(375, 468, "fijo", false, golosina[0], 0.2);

  flynnPaffVioleta = new Plataforma(80, 80);
  flynnPaffVioleta.dibujar(130, 567, "fijo", false, golosina[1], 0.2);
}

void cargarPendulos() {
  penduloIzquierda = new Pendulo("chupetin0");
  penduloIzquierda.dibujarPendulo(580, 208);
  penduloDerecha = new Pendulo("chupetin1");
  penduloDerecha.dibujarPendulo(220, 629);
}

void cargarObjetos() {

  // -- Bordes
  bordeIzquierdo = new Plataforma(35, height);
  bordeDerecho = new Plataforma(35, height);
  bordeIzquierdo.dibujar(20, 500, "borde", 0.8, false);
  bordeDerecho.dibujar(780, 500, "borde", 0.8, false);

  // -- Bolsa
  bolsa = new Plataforma(100, 110);
  bolsa.dibujar(400, 920, "bolsaRoja");

  // -- Piso
  piso = new Plataforma(800, 15);
  piso.dibujar(400, 980, "piso", 0, false);
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

  frameActualPaleta = 0;
}

void moverPendulos() {
  if (mov0) {
    penduloIzquierda.mover(190);
  }
  if (mov1) {
    penduloDerecha.mover(170);
  }
}
