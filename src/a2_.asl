// Player 2

/* Initial beliefs */
/* 
  Es IMPORTANTE tener en cuenta las siguientes consideraciones a la hora
  de utilizar este tablero:
  
  - El modelo definido en este Blackboard introduce despu�s
   de cada jugada (put(X)), una "creencia" en ambos agentes que es
   la representacion del tablero en forma de vector, de la siguiente forma:
   
   tablero([0,16,17,0,0,...,n]).
   
   Donde:
   "N" es la longitud del vector, en nuestro caso 8x8 = 64
   El valor 16 Se corresponde con una ficha del player1
   El valor 17 Se corresponde con una ficha del player2
   
   *NOTA: Cada vez que se introcude el nuevo vector del tablero
   se borra la "creencia" (ClearPerception()) del tablero antiguo.
   
   El vector contiene todas las posiciones del tablero de la
   siguiente forma. Por ejemmplo si el tablero fuera de 4x4:
   
   Este tablero:
   0 0 0 0
   0 0 0 0
   0 0 0 0
   0 16 17 17
   
   Se representaria como:
   tablero([0,0,0,0,0,0,0,0,0,0,0,0,0,16,17,17).
    
   - La unica accion que se puede realizar sobre el modelo es:
   
   put(X).
   
   Donde X corresponde al numero de columna donde se quiere poner la ficha.
*/

/* Initial goal */
!start.

/* Plans */

// A implementar con tu estrategia!!
+?ponerFicha:estrategia(jugarAGanar) <- 
	.random(X); X1 = X * 8;
	put(X1).

+?ponerFicha:estrategia(jugarAPerder) <- 
	.random(X); X1 = X * 8;
	put(X1).

// DE AQUI PARA ABAJO NO HACE FALTA TOCAR //////////////////////////////////////
+?ponerFicha:true <- ?ponerFicha.

// Inicializar
+!start: true <- .my_name(Me);
		.print("Jugador ",Me);
		?checkTurno(Me);
	    !jugar(Me).

+!jugar(Jugador):turno(Jugador) <-
	?ponerFicha;
	!jugar(Jugador).
+!jugar(Jugador):true <- !jugar(Jugador).

// El agente espera hasta que se le asigna turno
+?checkTurno(Jugador):jugador(primero) <- 
	.print("Jugador ",Jugador," primero en jugar");
	ponerTurno(Jugador).
+?checkTurno(Jugador):true.