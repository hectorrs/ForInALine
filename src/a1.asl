// Player 1

/* Initial beliefs */
/* 
  Es IMPORTANTE tener en cuenta las siguientes consideraciones a la hora
  de utilizar este tablero:
  
  - El modelo definido en este Blackboard introduce despus
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
   tablero([0,0,0,0,0,0,0,0,0,0,0,0,0,16,17,17]).
    
   - La unica accion que se puede realizar sobre el modelo es:
   
   put(X).
   
   Donde X corresponde al numero de columna donde se quiere poner la ficha.
*/

/* Devuelve el codigo correspondiente al jugador actual en cada caso.
 */
jugador(player1, 16).
jugador(player2, 17).
/* Devuelve el codigo correspondiente al jugador rival en cada caso.
 */
adversario(player1, 17).
adversario(player2, 16).

/* Indica, en cada turno, a que jugador le toca jugar, en funcion del nivel de profundidad en
 * el algoritmo Minimax en el que nos encontremos. Si es par, devuelve el jugador actual, mientras
 * que si es impar, debe devolver el jugador adversario.
 */
jugador_siguiente(Lvl, Player) :- Lvl mod 2==0 & .my_name(Me) & jugador(Me, Player).
jugador_siguiente(Lvl, Player) :- Lvl mod 2==1 & .my_name(Me) & adversario(Me, Player).

/* Indica la profundidad maxima del arbol generado como resultado de aplicar el algoritmo Minimax.
 * Un valor de 3 o superior en este punto provocaria mejores resultados predictivos en el algoritmo,
 * aunque la lentitud en el programa es notable.
 */
profundidad_maxima(2).

/* Nodo corresponde a una estructura de datos, en forma de predicado, formada por un estado (que
 * representa el tablero), el estado del que este derivo (estado anterior), un movimiento que indica
 * la columna en la que se introdujo una ficha para dar lugar al estado actual, y un valor determinado
 * mas adelante resultado de aplicar la funcion heuristica definida.
 */
nodo(EstadoActual, EstadoAnterior, Movimiento, Valor).

/* Determina el peso o valor que tiene cada ficha puesta en el tablero en funcion de su posicion en este,
 * tomandolo como un vector unidimensional. Los pesos estan determinados a priori de manera arbitraria.
 *
 * Fila 0			Fila 1 				Fila 2 				Fila 3 */
peso_ficha(0, 0).	peso_ficha(8, 3).	peso_ficha(16, 4).	peso_ficha(24, 5).
peso_ficha(1, 1).	peso_ficha(9, 4).	peso_ficha(17, 6).	peso_ficha(25, 8).
peso_ficha(2, 2).	peso_ficha(10, 5).	peso_ficha(18, 8).	peso_ficha(26, 11).
peso_ficha(3, 4).	peso_ficha(11, 7).	peso_ficha(19, 10).	peso_ficha(27, 13).
peso_ficha(4, 4).	peso_ficha(12, 7).	peso_ficha(20, 10).	peso_ficha(28, 13).
peso_ficha(5, 2).	peso_ficha(13, 5).	peso_ficha(21, 8).	peso_ficha(29, 11).
peso_ficha(6, 1).	peso_ficha(14, 4).	peso_ficha(22, 6).	peso_ficha(30, 8).
peso_ficha(7, 0).	peso_ficha(15, 3).	peso_ficha(23, 4).	peso_ficha(31, 5).
/* Fila 4 			Fila 5 				Fila 6 				Fila 7 */
peso_ficha(32, 5).	peso_ficha(40, 4).	peso_ficha(48, 3).	peso_ficha(56, 0).
peso_ficha(33, 8).	peso_ficha(41, 6).	peso_ficha(49, 4).	peso_ficha(57, 1).
peso_ficha(34, 11).	peso_ficha(42, 8).	peso_ficha(50, 5).	peso_ficha(58, 2).
peso_ficha(35, 13).	peso_ficha(43, 10).	peso_ficha(51, 7).	peso_ficha(59, 4).
peso_ficha(36, 13).	peso_ficha(44, 10).	peso_ficha(52, 7).	peso_ficha(60, 4).
peso_ficha(37, 11).	peso_ficha(45, 8).	peso_ficha(53, 5).	peso_ficha(61, 2).
peso_ficha(38, 8).	peso_ficha(46, 6).	peso_ficha(54, 4).	peso_ficha(62, 1).
peso_ficha(39, 5).	peso_ficha(47, 4).	peso_ficha(55, 3).	peso_ficha(63, 0).

/* Obtiene el valor de la ficha en la posicion del tablero pasada como parametro. Los posibles valores
 * son 16, 17 (correspondientes a cada jugador) o 0 (ningun jugador a puesto aun).
 */
obtener_valor(X, Y, _, DimensionTablero, 0) :- X >= DimensionTablero | Y >= DimensionTablero.
obtener_valor(X, Y, Tablero, DimensionTablero, Valor) :-
	Y<DimensionTablero & X<DimensionTablero &
    Pos = Y*DimensionTablero + X & // Devuelve el valor correspondiente a la posicion en un tablero unidimensional.
	bucle_tablero(Pos, Tablero, Valor).

/* Modifica el valor de la posicion del tablero pasada como parametro (X, Y), devolviendo el tablero modificado.
 */
modificar_valor(X, Y, Valor, Tablero, Dimension, TableroResultante) :-
	Cont = Y*Dimension + X & // Devuelve el valor correspondiente a la posicion en un tablero unidimensional.
	modificar_valor(Cont, Valor, Tablero, Dimension, TableroResultante).

/* Recorre todo el tablero hasta encontrar la posicion que deseamos modificar, devolviendola al predicado
 * desde el que fue llamado.
 */
modificar_valor(0, Valor, [_|Cdr], Dimension, [Valor|Cdr]).
modificar_valor(Cont, Valor, [Car|Cdr], Dimension, [Car|Resultado]) :-
	not Cont==0 & // Mientras no sea 0 (caso base) seguir restando
	NewCont = Cont - 1 &
	modificar_valor(NewCont, Valor, Cdr, Dimension, Resultado).

/* Predicado que recorre recursivamente el tablero (considerado con una sola dimension) hasta la posicion
 * pasada como parametro. Luego, devuelve el valor de la ficha en esa posicion.
 */
bucle_tablero(0, [Car|_], Car).
bucle_tablero(Pos, [_|Cdr], ValorFicha) :- bucle_tablero(Pos-1, Cdr, ValorFicha).

/* Verifica si el tablero esta lleno y, por lo tanto, si se pueden o no seguir colocando fichas en el.
 */
tablero_lleno([]). // Caso base
tablero_lleno([Car|Cdr]) :- not Car==0 & tablero_lleno(Cdr).

/* Comprueba el estado del tablero y determina si, tras haber jugado, el jugador rival ha ganado, y
 * en consecuencia el ha perdido.
 */
es_perdedor(EstadoTablero) :- .my_name(Me) & adversario(Me, Num) &
	( fichas_4_vertical(EstadoTablero, Num) | fichas_4_horizontal(EstadoTablero, Num) | fichas_4_diagonal(EstadoTablero, Num) ).

/* Comprueba el estado del tablero y determina si, tras haber jugado, el jugador ha ganado.
 */
es_ganador(EstadoTablero) :- .my_name(Me) & jugador(Me, Num) &
	( fichas_4_vertical(EstadoTablero, Num) | fichas_4_horizontal(EstadoTablero, Num) | fichas_4_diagonal(EstadoTablero, Num) ).

/* Comprueba el estado del tablero y determina si, tras haber jugado, hay un empate (el tablero se ha
 * llenado sin que nadie haya hecho 4 en linea).
 */
hay_empate(EstadoTablero) :- not es_perdedor(EstadoTablero, Player) &
							 not es_ganador(EstadoTablero, Player) &							 
							 tablero_lleno(EstadoTablero).

/* Cambia la forma en la que se reprenta el tablero para adaptarlo a nuestras necesidades (desde una lista,
 * unidemensional, a una lista formada a su vez por listas, de 8 elementos cada una, representando las filas
 * y las columnas de cada fila).
 */
tablero_a_lista([], []).
tablero_a_lista([Col0,Col1,Col2,Col3,Col4,Col5,Col6,Col7|Cdr], EstadoResultado) :- 
	tablero_a_lista(Cdr, ResultadoParcial) &
	.concat([[Col0,Col1,Col2,Col3,Col4,Col5,Col6,Col7]], ResultadoParcial, EstadoResultado).

/* Comprueba si en algun lugar del tablero hay tres fichas en linea en horizontal.
 */
fichas_3_horizontal(EstadoTablero, Ficha) :-
	fichas_3_horizontal(EstadoTablero, Ficha, _, 0, 0). // Anade los contadores necesarios

fichas_3_horizontal(_, _, _, _, 3). // Caso base de parada
fichas_3_horizontal(EstadoTablero, Ficha, _, Y, 0) :- // Comprueba el valor de las posiciones del tablero (estado) tres a tres
	((obtener_valor(0, Y, EstadoTablero, 8, Ficha) & obtener_valor(1, Y, EstadoTablero, 8, Ficha) & obtener_valor(2, Y, EstadoTablero, 8, Ficha))|
	 (obtener_valor(1, Y, EstadoTablero, 8, Ficha) & obtener_valor(2, Y, EstadoTablero, 8, Ficha) & obtener_valor(3, Y, EstadoTablero, 8, Ficha))|
	 (obtener_valor(2, Y, EstadoTablero, 8, Ficha) & obtener_valor(3, Y, EstadoTablero, 8, Ficha) & obtener_valor(4, Y, EstadoTablero, 8, Ficha))|
	 (obtener_valor(3, Y, EstadoTablero, 8, Ficha) & obtener_valor(4, Y, EstadoTablero, 8, Ficha) & obtener_valor(5, Y, EstadoTablero, 8, Ficha))|
	 (obtener_valor(4, Y, EstadoTablero, 8, Ficha) & obtener_valor(5, Y, EstadoTablero, 8, Ficha) & obtener_valor(6, Y, EstadoTablero, 8, Ficha))|
	 (obtener_valor(5, Y, EstadoTablero, 8, Ficha) & obtener_valor(6, Y, EstadoTablero, 8, Ficha) & obtener_valor(7, Y, EstadoTablero, 8, Ficha)))
	& fichas_3_horizontal(EstadoTablero, Ficha, _, Y, 3).
fichas_3_horizontal(EstadoTablero, Ficha, _, Y, 0) :-
	Y<7 & fichas_3_horizontal(EstadoTablero, Ficha, _, Y+1, 0).

/* Comprueba si en algun lugar del tablero hay tres fichas en linea en vertical (analogo al anterior).
 */
fichas_3_vertical(EstadoTablero, Ficha) :-
	fichas_3_vertical(EstadoTablero, Ficha, 0, _, 0).

fichas_3_vertical(_, _, _, _, 3).
fichas_3_vertical(EstadoTablero, Ficha, X, _, 0) :- 
	((obtener_valor(X, 0, EstadoTablero, 8, Ficha) & obtener_valor(X, 1, EstadoTablero, 8, Ficha) & obtener_valor(X, 2, EstadoTablero, 8, Ficha))|
	 (obtener_valor(X, 1, EstadoTablero, 8, Ficha) & obtener_valor(X, 2, EstadoTablero, 8, Ficha) & obtener_valor(X, 3, EstadoTablero, 8, Ficha))|
	 (obtener_valor(X, 2, EstadoTablero, 8, Ficha) & obtener_valor(X, 3, EstadoTablero, 8, Ficha) & obtener_valor(X, 4, EstadoTablero, 8, Ficha))|
	 (obtener_valor(X, 3, EstadoTablero, 8, Ficha) & obtener_valor(X, 4, EstadoTablero, 8, Ficha) & obtener_valor(X, 5, EstadoTablero, 8, Ficha))|
	 (obtener_valor(X, 4, EstadoTablero, 8, Ficha) & obtener_valor(X, 5, EstadoTablero, 8, Ficha) & obtener_valor(X, 6, EstadoTablero, 8, Ficha))|
	 (obtener_valor(X, 5, EstadoTablero, 8, Ficha) & obtener_valor(X, 6, EstadoTablero, 8, Ficha) & obtener_valor(X, 7, EstadoTablero, 8, Ficha)))
	& fichas_3_vertical(EstadoTablero, Ficha, X, _, 3).
fichas_3_vertical(EstadoTablero, Ficha, X, _, 0) :-
	X<7 & fichas_3_vertical(EstadoTablero, Ficha, X+1, _, 0).

/* Comprueba si en algun lugar del tablero hay tres fichas en linea en diagonal, abstrayendo el calculo a diagonales
 * ascendentes y descendentes.
 */
fichas_3_diagonal(EstadoTablero, Ficha) :-
	fichas_3_diagonal_ascendente(EstadoTablero, Ficha, _, 0, 0) | fichas_3_diagonal_descendente(EstadoTablero, Ficha, _, 0, 0).

fichas_3_diagonal_ascendente(_, _, _, _, 3).
fichas_3_diagonal_ascendente(EstadoTablero, Ficha, _, Y, 0) :-  
	((obtener_valor(0, Y, EstadoTablero, 8, Ficha) & obtener_valor(1, Y+1, EstadoTablero, 8, Ficha) & obtener_valor(2, Y+2, EstadoTablero, 8, Ficha))|
	 (obtener_valor(1, Y, EstadoTablero, 8, Ficha) & obtener_valor(2, Y+1, EstadoTablero, 8, Ficha) & obtener_valor(3, Y+2, EstadoTablero, 8, Ficha))|
	 (obtener_valor(2, Y, EstadoTablero, 8, Ficha) & obtener_valor(3, Y+1, EstadoTablero, 8, Ficha) & obtener_valor(4, Y+2, EstadoTablero, 8, Ficha))|
	 (obtener_valor(3, Y, EstadoTablero, 8, Ficha) & obtener_valor(4, Y+1, EstadoTablero, 8, Ficha) & obtener_valor(5, Y+2, EstadoTablero, 8, Ficha))|
	 (obtener_valor(4, Y, EstadoTablero, 8, Ficha) & obtener_valor(5, Y+1, EstadoTablero, 8, Ficha) & obtener_valor(6, Y+2, EstadoTablero, 8, Ficha))|
	 (obtener_valor(5, Y, EstadoTablero, 8, Ficha) & obtener_valor(6, Y+1, EstadoTablero, 8, Ficha) & obtener_valor(7, Y+2, EstadoTablero, 8, Ficha))) &
	fichas_3_diagonal_ascendente(EstadoTablero, Ficha, _, Y, 3).
fichas_3_diagonal_ascendente(EstadoTablero, Ficha, _, Y, 0) :-
	Y<7 & fichas_3_diagonal_ascendente(EstadoTablero, Ficha, _, Y+1, 0).

fichas_3_diagonal_descendente(_, _, _, _, 3).
fichas_3_diagonal_descendente(EstadoTablero, Ficha, _, Y, 0) :-  
	((obtener_valor(0, Y, EstadoTablero, 8, Ficha) & obtener_valor(1, Y-1, EstadoTablero, 8, Ficha) & obtener_valor(2, Y-2, EstadoTablero, 8, Ficha))|
	 (obtener_valor(1, Y, EstadoTablero, 8, Ficha) & obtener_valor(2, Y-1, EstadoTablero, 8, Ficha) & obtener_valor(3, Y-2, EstadoTablero, 8, Ficha))|
	 (obtener_valor(2, Y, EstadoTablero, 8, Ficha) & obtener_valor(3, Y-1, EstadoTablero, 8, Ficha) & obtener_valor(4, Y-2, EstadoTablero, 8, Ficha))|
	 (obtener_valor(3, Y, EstadoTablero, 8, Ficha) & obtener_valor(4, Y-1, EstadoTablero, 8, Ficha) & obtener_valor(5, Y-2, EstadoTablero, 8, Ficha))|
	 (obtener_valor(4, Y, EstadoTablero, 8, Ficha) & obtener_valor(5, Y-1, EstadoTablero, 8, Ficha) & obtener_valor(6, Y-2, EstadoTablero, 8, Ficha))|
	 (obtener_valor(5, Y, EstadoTablero, 8, Ficha) & obtener_valor(6, Y-1, EstadoTablero, 8, Ficha) & obtener_valor(7, Y-2, EstadoTablero, 8, Ficha))) &
	fichas_3_diagonal_descendente(EstadoTablero, Ficha, _, Y, 3).
fichas_3_diagonal_descendente(EstadoTablero, Ficha, _, Y, 0) :-
	Y<7 & fichas_3_diagonal_descendente(EstadoTablero, Ficha, _, Y+1, 0).

/* Comprueba si en algun lugar del tablero hay cuatro fichas en linea en horizontal.
 */
fichas_4_horizontal(EstadoTablero, Ficha) :-
	fichas_4_horizontal(EstadoTablero, Ficha, _, 0, 0).

fichas_4_horizontal(_, _, _, _, 4).
fichas_4_horizontal(EstadoTablero, Ficha, _, Y, 0) :-
	((obtener_valor(0, Y, EstadoTablero, 8, Ficha) & obtener_valor(1, Y, EstadoTablero, 8, Ficha) & obtener_valor(2, Y, EstadoTablero, 8, Ficha) & obtener_valor(3, Y, EstadoTablero, 8, Ficha))|
	 (obtener_valor(1, Y, EstadoTablero, 8, Ficha) & obtener_valor(2, Y, EstadoTablero, 8, Ficha) & obtener_valor(3, Y, EstadoTablero, 8, Ficha) & obtener_valor(4, Y, EstadoTablero, 8, Ficha))|
	 (obtener_valor(2, Y, EstadoTablero, 8, Ficha) & obtener_valor(3, Y, EstadoTablero, 8, Ficha) & obtener_valor(4, Y, EstadoTablero, 8, Ficha) & obtener_valor(5, Y, EstadoTablero, 8, Ficha))|
	 (obtener_valor(3, Y, EstadoTablero, 8, Ficha) & obtener_valor(4, Y, EstadoTablero, 8, Ficha) & obtener_valor(5, Y, EstadoTablero, 8, Ficha) & obtener_valor(6, Y, EstadoTablero, 8, Ficha))|
	 (obtener_valor(4, Y, EstadoTablero, 8, Ficha) & obtener_valor(5, Y, EstadoTablero, 8, Ficha) & obtener_valor(6, Y, EstadoTablero, 8, Ficha) & obtener_valor(7, Y, EstadoTablero, 8, Ficha))) &
	fichas_4_horizontal(EstadoTablero, Ficha, _, Y, 4).
fichas_4_horizontal(EstadoTablero, Ficha, _, Y, 0) :-
	Y<7 & fichas_4_horizontal(EstadoTablero, Ficha, _, Y+1, 0).

/* Comprueba si en algun lugar del tablero hay cuatro fichas en linea en vertical (analogo al anterior).
 */
fichas_4_vertical(EstadoTablero, Ficha) :-
	fichas_4_vertical(EstadoTablero, Ficha, 0, _, 0).

fichas_4_vertical(_, _, _, _, 4).
fichas_4_vertical(EstadoTablero, Ficha, X, _, 0) :-
	((obtener_valor(X, 0, EstadoTablero, 8, Ficha) & obtener_valor(X, 1, EstadoTablero, 8, Ficha) & obtener_valor(X, 2, EstadoTablero, 8, Ficha) & obtener_valor(X, 3, EstadoTablero, 8, Ficha))|
	 (obtener_valor(X, 1, EstadoTablero, 8, Ficha) & obtener_valor(X, 2, EstadoTablero, 8, Ficha) & obtener_valor(X, 3, EstadoTablero, 8, Ficha) & obtener_valor(X, 4, EstadoTablero, 8, Ficha))|
	 (obtener_valor(X, 2, EstadoTablero, 8, Ficha) & obtener_valor(X, 3, EstadoTablero, 8, Ficha) & obtener_valor(X, 4, EstadoTablero, 8, Ficha) & obtener_valor(X, 5, EstadoTablero, 8, Ficha))|
	 (obtener_valor(X, 3, EstadoTablero, 8, Ficha) & obtener_valor(X, 4, EstadoTablero, 8, Ficha) & obtener_valor(X, 5, EstadoTablero, 8, Ficha) & obtener_valor(X, 6, EstadoTablero, 8, Ficha))|
	 (obtener_valor(X, 4, EstadoTablero, 8, Ficha) & obtener_valor(X, 5, EstadoTablero, 8, Ficha) & obtener_valor(X, 6, EstadoTablero, 8, Ficha) & obtener_valor(X, 7, EstadoTablero, 8, Ficha))) &
	fichas_4_vertical(EstadoTablero, Ficha, X, _, 4).
fichas_4_vertical(EstadoTablero, Ficha, X, _, 0) :-
	X<7 & fichas_4_vertical(EstadoTablero, Ficha, X+1, _, 0). 

/* Comprueba si en algun lugar del tablero hay cuatro fichas en linea en diagonal, abstrayendo el calculo a diagonales
 * ascendentes y descendentes.
 */
fichas_4_diagonal(EstadoTablero, Ficha) :-
	diagonal_ascendente(EstadoTablero, Ficha, _, 0, 0) | diagonal_descendente(EstadoTablero, Ficha, _, 0, 0).

diagonal_ascendente(_, _, _, _, 4).
diagonal_ascendente(EstadoTablero, Ficha, _, Y, 0) :-  
	((obtener_valor(0, Y, EstadoTablero, 8, Ficha) & obtener_valor(1, Y+1, EstadoTablero, 8, Ficha) & obtener_valor(2, Y+2, EstadoTablero, 8, Ficha) & obtener_valor(3, Y+3, EstadoTablero, 8, Ficha))|
	 (obtener_valor(1, Y, EstadoTablero, 8, Ficha) & obtener_valor(2, Y+1, EstadoTablero, 8, Ficha) & obtener_valor(3, Y+2, EstadoTablero, 8, Ficha) & obtener_valor(4, Y+3, EstadoTablero, 8, Ficha))|
	 (obtener_valor(2, Y, EstadoTablero, 8, Ficha) & obtener_valor(3, Y+1, EstadoTablero, 8, Ficha) & obtener_valor(4, Y+2, EstadoTablero, 8, Ficha) & obtener_valor(5, Y+3, EstadoTablero, 8, Ficha))|
	 (obtener_valor(3, Y, EstadoTablero, 8, Ficha) & obtener_valor(4, Y+1, EstadoTablero, 8, Ficha) & obtener_valor(5, Y+2, EstadoTablero, 8, Ficha) & obtener_valor(6, Y+3, EstadoTablero, 8, Ficha))|
	 (obtener_valor(4, Y, EstadoTablero, 8, Ficha) & obtener_valor(5, Y+1, EstadoTablero, 8, Ficha) & obtener_valor(6, Y+2, EstadoTablero, 8, Ficha) & obtener_valor(7, Y+3, EstadoTablero, 8, Ficha))) &
	diagonal_ascendente(EstadoTablero, Ficha, _, Y, 4).
diagonal_ascendente(EstadoTablero, Ficha, _, Y, 0) :-
	Y<7 & diagonal_ascendente(EstadoTablero, Ficha, _, Y+1, 0). 

diagonal_descendente(_, _, _, _, 4).
diagonal_descendente(EstadoTablero, Ficha, _, Y, 0) :-  
	((obtener_valor(0, Y, EstadoTablero, 8, Ficha) & obtener_valor(1, Y-1, EstadoTablero, 8, Ficha) & obtener_valor(2, Y-2, EstadoTablero, 8, Ficha) & obtener_valor(3, Y-3, EstadoTablero, 8, Ficha))|
	 (obtener_valor(1, Y, EstadoTablero, 8, Ficha) & obtener_valor(2, Y-1, EstadoTablero, 8, Ficha) & obtener_valor(3, Y-2, EstadoTablero, 8, Ficha) & obtener_valor(4, Y-3, EstadoTablero, 8, Ficha))|
	 (obtener_valor(2, Y, EstadoTablero, 8, Ficha) & obtener_valor(3, Y-1, EstadoTablero, 8, Ficha) & obtener_valor(4, Y-2, EstadoTablero, 8, Ficha) & obtener_valor(5, Y-3, EstadoTablero, 8, Ficha))|
	 (obtener_valor(3, Y, EstadoTablero, 8, Ficha) & obtener_valor(4, Y-1, EstadoTablero, 8, Ficha) & obtener_valor(5, Y-2, EstadoTablero, 8, Ficha) & obtener_valor(6, Y-3, EstadoTablero, 8, Ficha))|
	 (obtener_valor(4, Y, EstadoTablero, 8, Ficha) & obtener_valor(5, Y-1, EstadoTablero, 8, Ficha) & obtener_valor(6, Y-2, EstadoTablero, 8, Ficha) & obtener_valor(7, Y-3, EstadoTablero, 8, Ficha))) &
	diagonal_descendente(EstadoTablero, Ficha, _, Y, 4).
diagonal_descendente(EstadoTablero, Ficha, _, Y, 0) :-
	Y<7 & diagonal_descendente(EstadoTablero, Ficha, _, Y+1, 0).  

/* Indica si hay tres fichas seguidas en el tablero, tanto en vertical como en horizontal, como diagonal, para determinar a continuacion el
 * valor que tiene que dar la funcion de evaluacion. Que haya tres fichas consecutivas significa que es un estado muy malo, y que hay colocar
 * la siguiente ficha de forma que se evite este problema para tratar de no perder la partida.
 */
tres_en_linea(EstadoTablero, Player, PesoFinal) :- // Si se cumplen las 3 condiciones, debe corresponderle un peso muy alto.
	(fichas_3_horizontal(EstadoTablero, Player) & fichas_3_vertical(EstadoTablero, Player) & fichas_3_diagonal(EstadoTablero, Player))
	& obtener_peso(EstadoTablero, Player, Peso) & .my_name(Me) & PesoFinal = 4096.

tres_en_linea(EstadoTablero, Player, PesoFinal) :- // Si se cumplen 2 de las condiciones, le corresponde un peso medianamente alto.
	((fichas_3_horizontal(EstadoTablero, Player) & fichas_3_vertical(EstadoTablero, Player))|
	(fichas_3_horizontal(EstadoTablero, Player) & fichas_3_diagonal(EstadoTablero, Player))|
	(fichas_3_diagonal(EstadoTablero, Player) & fichas_3_vertical(EstadoTablero, Player)))
	& obtener_peso(EstadoTablero, Player, Peso) & .my_name(Me) & PesoFinal = 2048.

tres_en_linea(EstadoTablero, Player, PesoFinal) :- // Si se cumplen al menos 1 de las condiciones, se devuelve un peso ligera pero suficientemente alto.
	(fichas_3_horizontal(EstadoTablero, Player) | fichas_3_vertical(EstadoTablero, Player) | fichas_3_diagonal(EstadoTablero, Player))
	& obtener_peso(EstadoTablero, Player, Peso) & .my_name(Me) & PesoFinal = 1024.

/* La funcion de evaluacion o heuristica evalua, segun el estado del tablero, como de bueno es un estado y lo necesario para poder ganar.
 * En base a eso, genera un valor para indicarlo.
 */
funcion_evaluacion(EstadoTablero, Player, ValorFinal) :-
	.my_name(Me) & jugador(Me, Jugador) &
	tres_en_linea(EstadoTablero, Jugador, ValorParcial1) &
	funcion_evaluacion(EstadoTablero, ValorParcial2) &
	ValorFinal = ValorParcial2 + ValorParcial1. // En caso de tratarse del jugador propiamente, calcular la suma

funcion_evaluacion(EstadoTablero, Player, ValorFinal) :-
	.my_name(Me) & adversario(Me, Adversario) &
	tres_en_linea(EstadoTablero, Adversario, ValorParcial1) &
	funcion_evaluacion(EstadoTablero, ValorParcial2) &
	ValorFinal = ValorParcial2 - ValorParcial1.

funcion_evaluacion(EstadoTablero, Player, ValorF) :- funcion_evaluacion(EstadoTablero, ValorF).

funcion_evaluacion(EstadoTablero, ValorFinal) :-
	.my_name(Me) & adversario(Me, Adversario) & jugador(Me, Jugador) &
	obtener_peso(EstadoTablero, Jugador, ValorJugador) &
	obtener_peso(EstadoTablero, Adversario, ValorAdversario) &
	ValorFinal = ValorJugador - ValorAdversario. // Si se trata del oponente, calcular la diferencia

/* Obtiene y devuelve una lista de las posiciones en el tablero de las fichas del jugador pasado como parametro.
 */
obtener_posiciones(EstadoTablero, Player, Posiciones) :-
	obtener_posiciones(EstadoTablero, Player, -1, Posiciones).
obtener_posiciones([], Player, _, []).
obtener_posiciones([Car|Cdr], Player, Contador, [Contador+1|Posiciones]) :-
	Car==Player & obtener_posiciones(Cdr, Player, Contador+1, Posiciones).
obtener_posiciones([Car|Cdr], Player, Contador, Posiciones) :-
	not Car==Player & obtener_posiciones(Cdr, Player, Contador+1, Posiciones).

/* Obtiene la suma de valores correspondientes a la posicion de la ficha en el tablero.
 */
obtener_peso(EstadoTablero, Player, Peso) :-
	obtener_posiciones(EstadoTablero, Player, Posiciones) & obtener_peso(Posiciones, Peso).
obtener_peso([], 0).
obtener_peso([Car|Cdr], Peso) :-
	peso_ficha(Car, Valor1) & obtener_peso(Cdr, Valor2) & Peso = Valor1 + Valor2.

/* Indica si el nodo del nivel que estamos viendo es maximo o minimo.
 */
es_nodo_max(Lvl) :- Lvl mod 2==0.
es_nodo_min(Lvl) :- Lvl mod 2==1.

/* Genera una lista de nodos sucesores a partir del estado en que se encuentre, con todas las opciones posibles
 * (esto es, introduciendo ficha en cualquiera de las columnas aun no llenas). 
 */
obtener_sucesores(EstadoTablero, Player, Sucesores) :-
	// .my_name(Player) &
	obtener_sucesor(EstadoTablero, 0, Player, TableroResultado0) &
	obtener_sucesor(EstadoTablero, 1, Player, TableroResultado1) &
	obtener_sucesor(EstadoTablero, 2, Player, TableroResultado2) &
	obtener_sucesor(EstadoTablero, 3, Player, TableroResultado3) &
	obtener_sucesor(EstadoTablero, 4, Player, TableroResultado4) &
	obtener_sucesor(EstadoTablero, 5, Player, TableroResultado5) &
	obtener_sucesor(EstadoTablero, 6, Player, TableroResultado6) &
	obtener_sucesor(EstadoTablero, 7, Player, TableroResultado7) &
	Suc = [ nodo(TableroResultado0,EstadoTablero,0,_), nodo(TableroResultado1,EstadoTablero,1,_),
			nodo(TableroResultado2,EstadoTablero,2,_), nodo(TableroResultado3,EstadoTablero,3,_),
			nodo(TableroResultado4,EstadoTablero,4,_), nodo(TableroResultado5,EstadoTablero,5,_),
			nodo(TableroResultado6,EstadoTablero,6,_), nodo(TableroResultado7,EstadoTablero,7,_)]
	& controlar_columnas(Suc, Sucesores).

/* No tiene en cuenta los nodos generados a partir de un movimiento que intentaba colocar
 * ficha en una columna ya llena (indicados con -1 en el momento de generarlos como sucesores).
 */
controlar_columnas([], Posiciones).
controlar_columnas([nodo(-1, _, _, _)|Cdr], Posiciones) :- controlar_columnas(Cdr, Posiciones).
controlar_columnas([Car|Cdr], [Car|Posiciones]) :- controlar_columnas(Cdr, Posiciones).
		
/* Predicado auxiliar que devuelve el tablero con los valores modificados segun los sucesores generados.
 */
obtener_sucesor(Tablero, Columna, Player, TableroFinal) :-
	( (obtener_valor(Columna, 0, Tablero, 8, Val0) & if_then(Val0, N0))
	& (obtener_valor(Columna, 1, Tablero, 8, Val1) & if_then(Val1, N1))
	& (obtener_valor(Columna, 2, Tablero, 8, Val2) & if_then(Val2, N2))
	& (obtener_valor(Columna, 3, Tablero, 8, Val3) & if_then(Val3, N3))
	& (obtener_valor(Columna, 4, Tablero, 8, Val4) & if_then(Val4, N4))
	& (obtener_valor(Columna, 5, Tablero, 8, Val5) & if_then(Val5, N5))
	& (obtener_valor(Columna, 6, Tablero, 8, Val6) & if_then(Val6, N6))
	& (obtener_valor(Columna, 7, Tablero, 8, Val7) & if_then(Val7, N7)) )
	& NumFichasTemp = N0 +N1 +N2 +N3 +N4 +N5 +N6 +N7
	& NumFichasTemp < 8	& NTemp2 = 7-NumFichasTemp
	& modificar_valor(Columna, NTemp2, Player, Tablero, 8, TableroFinal).
	
obtener_sucesor(Tablero, Columna, Player, TableroFinal) :-
	( (obtener_valor(Columna, 0, Tablero, 8, Val0) & if_then(Val0, N0))
	& (obtener_valor(Columna, 1, Tablero, 8, Val1) & if_then(Val1, N1))
	& (obtener_valor(Columna, 2, Tablero, 8, Val2) & if_then(Val2, N2))
	& (obtener_valor(Columna, 3, Tablero, 8, Val3) & if_then(Val3, N3))
	& (obtener_valor(Columna, 4, Tablero, 8, Val4) & if_then(Val4, N4))
	& (obtener_valor(Columna, 5, Tablero, 8, Val5) & if_then(Val5, N5))
	& (obtener_valor(Columna, 6, Tablero, 8, Val6) & if_then(Val6, N6))
	& (obtener_valor(Columna, 7, Tablero, 8, Val7) & if_then(Val7, N7)) )
	& NumFichasTemp = N0 +N1 +N2 +N3 +N4 +N5 +N6 +N7 & NumFichasTemp >= 8
	& TableroFinal = -1. // Anadido para controlar cuando el sucesor no es valido (por estar fuera de rango).

/* Estructura condicional particularizada para nuestro caso.
 */
if_then(0, 0).
if_then(P, 1) :- not P==0.

/* Encuentra el nodo cuyo estado devuelve el valor mas grande en la lista de nodos pasada como parametro.
 */
nodo_maximo(Nodos, NodoMaximo) :- nodo_maximo(Nodos, Nodos, [], NodoMaximo). // Duplicar Nodos para conservar la lista original

nodo_maximo([Car|Cdr], Nodos, Pesos, NodoMaximo) :-
	Car = nodo(_, _, _, Peso) &
	.concat([Peso], Pesos, ListaPesos) &
	nodo_maximo(Cdr, Nodos, ListaPesos, NodoMaximo).

nodo_maximo([], Nodos, ListaPesos, NodoMaximo) :-
	.reverse(ListaPesos, Inversa) & .max(ListaPesos, PesoMaximo) & // Es necesario dar la vuelta a la lista de pesos.
	obtener_posiciones(Inversa, PesoMaximo, Lista) & .length(Lista, Long) &
	.nth(0, Lista, Elem) & .nth(Elem, Nodos, NodoMaximo). // Predicado que devuelve el elemento de la lista que se encuentra
														  // en la posición pasada como primer parámetro.
/* Encuentra el nodo cuyo estado devuelve el valor mas pequeno en la lista de nodos pasada como parametro.
 */
nodo_minimo(Nodos,NodoMinimo) :- nodo_minimo(Nodos, Nodos, [], NodoMinimo).

nodo_minimo([Car|Cdr], Nodos, Pesos, NodoMinimo) :-
	Car = nodo(_, _, _, Peso) &
	.concat([Peso], Pesos, Resultado) &
	nodo_minimo(Cdr, Nodos, Resultado, NodoMinimo).
	
nodo_minimo([], Nodos, Resultado, NodoMinimo) :-
	.reverse(Resultado, Inversa) & .min(Resultado, PesoMinimo) &
	obtener_posiciones(Inversa, PesoMinimo, Lista) &
	.nth(0, Lista, Elem) & .nth(Elem, Nodos, NodoMinimo).
	
/* Initial goal */
!start.

/* Plans */

/* Coloca las fichas con una estrategia a ganar.
 */
+?ponerFicha:estrategia(jugarAGanar) <- 
	?tablero(EstadoTablero) ;
	NodoActual = nodo(EstadoTablero, _, 0, 0) ;
	?minimax(NodoActual, 0, NodoSiguiente) ;
	NodoSiguiente = nodo(_, _, Movimiento, _) ;
	put(Movimiento) ;
	.abolish(nodo(_, _, _, _)).

/* Coloca las fichas con una estrategia a perder. En este caso, coloca las fichas de forma aleatoria.
 */
+?ponerFicha:estrategia(jugarAPerder) <-
	.random(X); X1 = X * 8;
	put(X1).

/* Implementacion del algoritmo Minimax. Rrecibe el tablero actual en forma de nodo, y devuelve el nodo
 * resultante de aplicar el algoritmo, es decir, el mejor nodo en cada caso.
 */
+?minimax(NodoActual, Lvl, NodoSiguiente) <-
	NodoActual = nodo(EstadoTablero, EstadoAnterior, Movimiento,_) ;
	if( es_ganador(EstadoTablero) ){
		NodoSiguiente = nodo(EstadoTablero, EstadoAnterior, Movimiento, 9999) ; // Si es ganador, devolvemos un valor elevado.
	} else { if( es_perdedor(EstadoTablero) ){
			NodoSiguiente = nodo(EstadoTablero, EstadoAnterior, Movimiento, -9999) ; // Si es ganador, devolvemos un valor reducido.
		} else { if( hay_empate(EstadoTablero) ){
				NodoSiguiente = nodo(EstadoTablero, EstadoAnterior, Movimiento, 0) ; // Si hay una sitiacion de tablas, devolvemos 0
			} else { if( profundidad_maxima(Prof) & Prof==Lvl ){ // Habiendo llegado al ultimo nivel del arbol generado por el
																 // algoritmo, se evalua lo bueno que es ese estado para ganar.
					?adversario(Me, Player);
					?funcion_evaluacion(EstadoTablero, Player, Peso) ;
					NodoSiguiente = nodo(EstadoTablero, EstadoAnterior, Movimiento, Peso) ;
				} else {
					?jugador_siguiente(Lvl, Player) ;
					?obtener_sucesores(EstadoTablero, Player, EstadosSucesores) ;

					for( .member(EstadoSucesor, EstadosSucesores) )
					{
						?minimax(EstadoSucesor, Lvl+1, SucesorFinal) ; // Evalua lo bueno que es cada sucesor.
						+SucesorFinal; // Anade como hechos los sucesores que ya han sido evaluados.
					}
					if( es_nodo_max(Lvl) )
					{
						// Recupera de la base de hechos los estados sucesores generados.
						.findall(nodo(EstadoActual,EstadoTablero,Mov,Pes), nodo(EstadoActual,EstadoTablero,Mov,Pes), EstadosSucesoresFin) ;
						.length(EstadosSucesoresFin, Long) ;
						.delete(Long-1, EstadosSucesoresFin, NodoSucesorFin) ;
						?nodo_maximo(NodoSucesorFin, NodoMaximo) ;
						NodoMaximo = nodo(_, EstadoAnteriorActual, Movim, PesoFin) ;
						NodoSiguiente = nodo(EstadoAnteriorActual, EstadoAnterior, Movim, PesoFin) ;
						// Elimina de la base de hechos nodos que ya no son de utilidad.
						.abolish(nodo(EstadoTablero, _, _, _)) ;
					}
					if( es_nodo_min(Lvl) )
					{
						// Recupera de la base de hechos los estados sucesores generados.
						.findall(nodo(EstadoActual,EstadoTablero,Mov,Pes), nodo(EstadoActual,EstadoTablero,Mov,Pes), EstadosSucesoresFin) ;
						.length(EstadosSucesoresFin, Long) ;
						.delete(Long-1, EstadosSucesoresFin, NodoSucesorFin) ;
						?nodo_minimo(NodoSucesorFin, NodoMinimo) ;
						NodoMinimo = nodo(_, EstadoAnteriorActual, _, PesoFin) ;
						NodoSiguiente = nodo(EstadoAnteriorActual, EstadoAnterior, Movimiento, PesoFin) ;
						// Elimina de la base de hechos nodos que ya no son de utilidad.
						.abolish(nodo(EstadoTablero, _, _, _)) ;
					}
				}
			}
		}
	}.

// DE AQUI PARA ABAJO NO HACE FALTA TOCAR //////////////////////////////////////

+?ponerFicha:true <- ?ponerFicha. // (true innecesario)

// Inicializar
+!start:true <- .my_name(Me);
		.print("Jugador ",Me);
		?checkTurno(Me);
	    !jugar(Me).

+!jugar(Player):turno(Player) <-
	?ponerFicha;
	!jugar(Player).
+!jugar(Player):true <- !jugar(Player).

// El agente espera hasta que se le asigna turno
+?checkTurno(Player):jugador(primero) <- 
	.print("Jugador ",Player," primero en jugar");
	ponerTurno(Player).
+?checkTurno(Player):true.