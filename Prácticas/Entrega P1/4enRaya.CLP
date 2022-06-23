;;; FRANCISCO JAVIER GALLEGO MENOR, GRUPO 2 ;;;

;;;;;;; JUGADOR DE 4 en RAYA ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
;;;;;;;;;; Version de 4 en raya clásico: Tablero de 6x7, donde se introducen fichas por arriba
;;;;;;;;;;;;;;;;;;;;;;; y caen hasta la posicion libre mas abajo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;; Hechos para representar un estado del juego

;;;;;;; (Turno M|J)   representa a quien corresponde el turno (M maquina, J jugador)
;;;;;;; (Tablero Juego ?i ?j _|M|J) representa que la posicion i,j del tablero esta vacia (_), o tiene una ficha propia (M) o tiene una ficha del jugador humano (J)

;;;;;;;;;;;;;;;; Hechos para representar estado del analisis
;;;;;;; (Tablero Analisis Posicion ?i ?j _|M|J) representa que en el analisis actual la posicion i,j del tablero esta vacia (_), o tiene una ficha propia (M) o tiene una ficha del jugador humano (J)
;;;;;;; (Sondeando ?n ?i ?c M|J)  ; representa que estamos analizando suponiendo que la ?n jugada h sido ?i ?c M|J
;;;

;;;;;;;;;;;;; Hechos para representar una jugadas

;;;;;;; (Juega M|J ?columna) representa que la jugada consiste en introducir la ficha en la columna ?columna 


;;; ========== INICIALIZAR ESTADO ============ ;;;


(deffacts Estado_inicial
(Tablero Juego 1 1 _) (Tablero Juego 1 2 _) (Tablero Juego 1 3 _) (Tablero Juego  1 4 _) (Tablero Juego  1 5 _) (Tablero Juego  1 6 _) (Tablero Juego  1 7 _)
(Tablero Juego 2 1 _) (Tablero Juego 2 2 _) (Tablero Juego 2 3 _) (Tablero Juego 2 4 _) (Tablero Juego 2 5 _) (Tablero Juego 2 6 _) (Tablero Juego 2 7 _)
(Tablero Juego 3 1 _) (Tablero Juego 3 2 _) (Tablero Juego 3 3 _) (Tablero Juego 3 4 _) (Tablero Juego 3 5 _) (Tablero Juego 3 6 _) (Tablero Juego 3 7 _)
(Tablero Juego 4 1 _) (Tablero Juego 4 2 _) (Tablero Juego 4 3 _) (Tablero Juego 4 4 _) (Tablero Juego 4 5 _) (Tablero Juego 4 6 _) (Tablero Juego 4 7 _)
(Tablero Juego 5 1 _) (Tablero Juego 5 2 _) (Tablero Juego 5 3 _) (Tablero Juego 5 4 _) (Tablero Juego 5 5 _) (Tablero Juego 5 6 _) (Tablero Juego 5 7 _)
(Tablero Juego 6 1 _) (Tablero Juego 6 2 _) (Tablero Juego 6 3 _) (Tablero Juego 6 4 _) (Tablero Juego 6 5 _) (Tablero Juego 6 6 _) (Tablero Juego 6 7 _)
(Jugada 0)
)

(defrule Elige_quien_comienza
=>
(printout t "Quien quieres que empieze: (escribre M para la maquina o J para empezar tu) ")
(assert (Turno (read)))
)

;;; ============== MUESTRA POSICION =========== ;;;

(defrule muestra_posicion
(declare (salience 9999))   ;; he modificado la prioridad de 10 -> 9999
(muestra_posicion)
(Tablero Juego 1 1 ?p11) (Tablero Juego 1 2 ?p12) (Tablero Juego 1 3 ?p13) (Tablero Juego 1 4 ?p14) (Tablero Juego 1 5 ?p15) (Tablero Juego 1 6 ?p16) (Tablero Juego 1 7 ?p17)
(Tablero Juego 2 1 ?p21) (Tablero Juego 2 2 ?p22) (Tablero Juego 2 3 ?p23) (Tablero Juego 2 4 ?p24) (Tablero Juego 2 5 ?p25) (Tablero Juego 2 6 ?p26) (Tablero Juego 2 7 ?p27)
(Tablero Juego 3 1 ?p31) (Tablero Juego 3 2 ?p32) (Tablero Juego 3 3 ?p33) (Tablero Juego 3 4 ?p34) (Tablero Juego 3 5 ?p35) (Tablero Juego 3 6 ?p36) (Tablero Juego 3 7 ?p37)
(Tablero Juego 4 1 ?p41) (Tablero Juego 4 2 ?p42) (Tablero Juego 4 3 ?p43) (Tablero Juego 4 4 ?p44) (Tablero Juego 4 5 ?p45) (Tablero Juego 4 6 ?p46) (Tablero Juego 4 7 ?p47)
(Tablero Juego 5 1 ?p51) (Tablero Juego 5 2 ?p52) (Tablero Juego 5 3 ?p53) (Tablero Juego 5 4 ?p54) (Tablero Juego 5 5 ?p55) (Tablero Juego 5 6 ?p56) (Tablero Juego 5 7 ?p57)
(Tablero Juego 6 1 ?p61) (Tablero Juego 6 2 ?p62) (Tablero Juego 6 3 ?p63) (Tablero Juego 6 4 ?p64) (Tablero Juego 6 5 ?p65) (Tablero Juego 6 6 ?p66) (Tablero Juego 6 7 ?p67)
=>
(printout t crlf)
(printout t ?p11 " " ?p12 " " ?p13 " " ?p14 " " ?p15 " " ?p16 " " ?p17 crlf)
(printout t ?p21 " " ?p22 " " ?p23 " " ?p24 " " ?p25 " " ?p26 " " ?p27 crlf)
(printout t ?p31 " " ?p32 " " ?p33 " " ?p34 " " ?p35 " " ?p36 " " ?p37 crlf)
(printout t ?p41 " " ?p42 " " ?p43 " " ?p44 " " ?p45 " " ?p46 " " ?p47 crlf)
(printout t ?p51 " " ?p52 " " ?p53 " " ?p54 " " ?p55 " " ?p56 " " ?p57 crlf)
(printout t ?p61 " " ?p62 " " ?p63 " " ?p64 " " ?p65 " " ?p66 " " ?p67 crlf)
(printout t  crlf)
)


;;;;;;;;;;;;;;;;;;;;;;; RECOGER JUGADA DEL CONTRARIO ;;;;;;;;;;;;;;;;;;;;;;;
(defrule mostrar_posicion
(declare (salience 9999))
(Turno J)
=>
(assert (muestra_posicion))
)

(defrule jugada_contrario
?f <- (Turno J)
=>
(printout t "en que columna introduces la siguiente ficha? ")
(assert (Juega J (read)))
(retract ?f)
)

(defrule juega_contrario_check_entrada_correcta
(declare (salience 1))
?f <- (Juega J ?c)
(test (and (neq ?c 1) (and (neq ?c 2) (and (neq ?c 3) (and (neq ?c 4) (and (neq ?c 5) (and (neq ?c 6) (neq ?c 7))))))))
=>
(printout t "Tienes que indicar un numero de columna: 1,2,3,4,5,6 o 7" crlf)
(retract ?f)
(assert (Turno J))
)

(defrule juega_contrario_check_columna_libre
(declare (salience 1))
?f <- (Juega J ?c)
(Tablero Juego 1 ?c ?X) 
(test (neq ?X _))
=>
(printout t "Esa columna ya esta completa, tienes que jugar en otra" crlf)
(retract ?f)
(assert (Turno J))
)

(defrule juega_contrario_actualiza_estado
?f <- (Juega J ?c)
?g <- (Tablero Juego ?i ?c _)
(Tablero Juego ?j ?c ?X) 
(test (= (+ ?i 1) ?j))
(test (neq ?X _))
=>
(retract ?f ?g)
(assert (Turno M) (Tablero Juego ?i ?c J))
)

(defrule juega_contrario_actualiza_estado_columna_vacia
?f <- (Juega J ?c)
?g <- (Tablero Juego 6 ?c _)
=>
(retract ?f ?g)
(assert (Turno M) (Tablero Juego 6 ?c J))
)


;;;;;;;;;;; ACTUALIZAR  ESTADO TRAS JUGADA DE CLISP ;;;;;;;;;;;;;;;;;;

(defrule juega_clisp_actualiza_estado
?f <- (Juega M ?c)
?g <- (Tablero Juego ?i ?c _)
(Tablero Juego ?j ?c ?X) 
(test (= (+ ?i 1) ?j))
(test (neq ?X _))
=>
(retract ?f ?g)
(assert (Turno J) (Tablero Juego ?i ?c M))
)

(defrule juega_clisp_actualiza_estado_columna_vacia
?f <- (Juega M ?c)
?g <- (Tablero Juego 6 ?c _)
=>
(retract ?f ?g)
(assert (Turno J) (Tablero Juego 6 ?c M))
)

;;;;;;;;;;; CLISP JUEGA SIN CRITERIO ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule elegir_jugada_aleatoria
(declare (salience -9998))
?f <- (Turno M)
=>
(assert (Jugar (random 1 7)))
(retract ?f)
)

(defrule comprobar_posible_jugada_aleatoria
?f <- (Jugar ?c)
(Tablero Juego 1 ?c M|J)
=>
(retract ?f)
(assert (Turno M))
)

(defrule clisp_juega_sin_criterio
(declare (salience -9999))
?f<- (Jugar ?c)
=>
(printout t "JUEGO en la columna (sin criterio) " ?c crlf)
(retract ?f)
(assert (Juega M ?c))
(printout t "Juego sin razonar, que mal"  crlf) 
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;  Comprobar si hay 4 en linea ;;;;;;;;;;;;;;;;;;;;;

(defrule cuatro_en_linea_horizontal
(declare (salience 9999))
(Tablero ?t ?i ?c1 ?jugador)
(Tablero ?t ?i ?c2 ?jugador) 
(test (= (+ ?c1 1) ?c2))
(Tablero ?t ?i ?c3 ?jugador)
(test (= (+ ?c1 2) ?c3))
(Tablero ?t ?i ?c4 ?jugador)
(test (= (+ ?c1 3) ?c4))
(test (or (eq ?jugador M) (eq ?jugador J) ))
=>
(assert (Cuatro_en_linea ?t ?jugador horizontal ?i ?c1))
)

(defrule cuatro_en_linea_vertical
(declare (salience 9999))
?f <- (Turno ?X)
(Tablero ?t ?i1 ?c ?jugador)
(Tablero ?t ?i2 ?c ?jugador)
(test (= (+ ?i1 1) ?i2))
(Tablero ?t ?i3 ?c  ?jugador)
(test (= (+ ?i1 2) ?i3))
(Tablero ?t ?i4 ?c  ?jugador)
(test (= (+ ?i1 3) ?i4))
(test (or (eq ?jugador M) (eq ?jugador J) ))
=>
(assert (Cuatro_en_linea ?t ?jugador vertical ?i1 ?c))
)

(defrule cuatro_en_linea_diagonal_directa
(declare (salience 9999))
?f <- (Turno ?X)
(Tablero ?t ?i ?c ?jugador)
(Tablero ?t ?i1 ?c1 ?jugador)
(test (= (+ ?i 1) ?i1))
(test (= (+ ?c 1) ?c1))
(Tablero ?t ?i2 ?c2  ?jugador)
(test (= (+ ?i 2) ?i2))
(test (= (+ ?c 2) ?c2))
(Tablero ?t ?i3 ?c3  ?jugador)
(test (= (+ ?i 3) ?i3))
(test (= (+ ?c 3) ?c3))
(test (or (eq ?jugador M) (eq ?jugador J) ))
=>
(assert (Cuatro_en_linea ?t ?jugador diagonal_directa ?i ?c))
)

(defrule cuatro_en_linea_diagonal_inversa
(declare (salience 9999))
?f <- (Turno ?X)
(Tablero ?t ?i ?c ?jugador)
(Tablero ?t ?i1 ?c1 ?jugador)
(test (= (+ ?i 1) ?i1))
(test (= (- ?c 1) ?c1))
(Tablero ?t ?i2 ?c2  ?jugador)
(test (= (+ ?i 2) ?i2))
(test (= (- ?c 2) ?c2))
(Tablero ?t ?i3 ?c3  ?jugador)
(test (= (+ ?i 3) ?i3))
(test (= (- ?c 3) ?c3))
(test (or (eq ?jugador M) (eq ?jugador J) ))
=>
(assert (Cuatro_en_linea ?t ?jugador diagonal_inversa ?i ?c))
)

;;;;;;;;;;;;;;;;;;;; DESCUBRE GANADOR
(defrule gana_fila
(declare (salience 9999))
?f <- (Turno ?X)
(Cuatro_en_linea Juego ?jugador horizontal ?i ?c)
=>
(printout t ?jugador " ha ganado pues tiene cuatro en linea en la fila " ?i crlf)
(retract ?f)
(assert (muestra_posicion))
) 

(defrule gana_columna
(declare (salience 9999))
?f <- (Turno ?X)
(Cuatro_en_linea Juego ?jugador vertical ?i ?c)
=>
(printout t ?jugador " ha ganado pues tiene cuatro en linea en la columna " ?c crlf)
(retract ?f)
(assert (muestra_posicion))
) 

(defrule gana_diagonal_directa
(declare (salience 9999))
?f <- (Turno ?X)
(Cuatro_en_linea Juego ?jugador diagonal_directa ?i ?c)
=>
(printout t ?jugador " ha ganado pues tiene cuatro en linea en la diagonal que empieza la posicion " ?i " " ?c   crlf)
(retract ?f)
(assert (muestra_posicion))
) 

(defrule gana_diagonal_inversa
(declare (salience 9999))
?f <- (Turno ?X)
(Cuatro_en_linea Juego ?jugador diagonal_inversa ?i ?c)
=>
(printout t ?jugador " ha ganado pues tiene cuatro en linea en la diagonal hacia arriba que empieza la posicin " ?i " " ?c   crlf)
(retract ?f)
(assert (muestra_posicion))
) 


;;;;;;;;;;;;;;;;;;;;;;;  DETECTAR EMPATE

(defrule empate
(declare (salience -9999))
(Turno ?X)
(Tablero Juego 1 1 M|J)
(Tablero Juego 1 2 M|J)
(Tablero Juego 1 3 M|J)
(Tablero Juego 1 4 M|J)
(Tablero Juego 1 5 M|J)
(Tablero Juego 1 6 M|J)
(Tablero Juego 1 7 M|J)
=>
(printout t "EMPATE! Se ha llegado al final del juego sin que nadie gane" crlf)
)

;;;;;;;;;;;;;;;;;;;;;; CONOCIMIENTO EXPERTO ;;;;;;;;;;
;;
;; Antes de nada comentar que he modificado la prioridad de la regla muestra_posicion, con el fin de que en la ejecución las salidas por pantalla 
;; aparezcan de forma más coherente. Esto es, sin mezclar razonamientos de la máquina y estados de juego tras jugada del jugador.

;; La extensión del sistema experto que he creado, se divide en 2 partes principalmente:
;;
;; 1) Deducciones básicas. Esta es la parte que corresponde con las respuestas a los ejercicios propuestos, antes de iniciar la práctica. 
;; En esta parte se deducen hechos que nos serán útiles en las siguientes dos partes, como por ejemplo cuaáles son las posiciones siguientes
;; y anteriores en cierta dirección, cuando las fichas están conectadas en 2/3 en raya, ... etc
;; 
;; 2) Reglas que indican como sería mi juego. En esta parte encontraremos: 
;;      
;;      1.- Como iniciaria una partida. Esto es, jugando en la columna central si es posible. 
;;      2.- En que columna jugaría, priorizando aquellas que me permitan obtener una combinación de un mayor número de fichas conectadas de 
;;          forma consecutiva. Es decir, si puedo ganar jugando en una columna su prioridad será mayor que otra en la que solo consigo una
;;          combinación de 3 fichas consecutivas. Así mismo, cuando no tenga opción de ganar, priorizaré aquellas columnas que me permitan
;;          obtener una combinación de 3 fichas, antes que una de 2.



;;; ========== Primera Parte: Respuestas a los Ejercicios Propuestos. ===========


;;; Respuesta al ejercicio 1: Crear reglas para que el sistema deduzca la posición siguiente 
;;; y anterior a una posición. 

;;;=================== HORIZONTAL ======================;;;

;;; Esta regla deduce cuál es la siguiente posición en horizontal.
;;; En primer lugar, comprobamos que la columna no puede ser la última (7a en nuestro caso)
;;; Entonces, si la fila es la misma y c2 == c1+1 introducimos en la base de hechos
;;; que las posiciones son contiguas horizontalmente

(defrule siguiente_horizontal
(Turno M)
(Tablero Juego ?f1 ?c1 ?v1)
(Tablero Juego ?f2 ?c2 ?v2)
(test (neq ?c1 7)) 
(test
    (and 
        (= ?f1 ?f2) 
        (= ?c2 (+ ?c1 1)) 
    )
)
=>
(assert (siguiente ?f2 ?c2 h ?f1 ?c1))
)

;;; Esta regla deduce cuál es la posición anterior en horizontal.
;;; En primer lugar, comprobamos que la columna no puede ser la primera (1a en nuestro caso)
;;; Entonces, si la fila es la misma y c2 == c1-1 introducimos en la base de hechos
;;; que las posiciones son contiguas horizontalmente

(defrule anterior_horizontal
(Turno M)
(Tablero Juego ?f1 ?c1 ?v1)
(Tablero Juego ?f2 ?c2 ?v2)
(test (neq ?c1 1)) 
(test
    (and 
        (= ?f1 ?f2) 
        (= ?c2 (- ?c1 1)) 
    )
)
=>
(assert (anterior ?f2 ?c2 h ?f1 ?c1))
)

;;;================ VERTICAL ==================;;; 

;;; Esta regla deduce cuál es la siguiente posición en vertical.
;;; En primer lugar, comprobamos que la fila no puede ser la última (1a en nuestro caso)
;;; Entonces, si la columna es la misma y f2 == f1-1 introducimos en la base de hechos
;;; que las posiciones son contiguas verticalmente

(defrule siguiente_vertical
(Turno M)
(Tablero Juego ?f1 ?c1 ?v1)
(Tablero Juego ?f2 ?c2 ?v2)
(test (neq ?f1 1)) 
(test
    (and 
        (= ?c1 ?c2) 
        (= ?f2 (- ?f1 1)) 
    )
)
=>
(assert (siguiente ?f2 ?c2 v ?f1 ?c1))
)

;;; Esta regla deduce cuál es la posición anterior en vertical.
;;; En primer lugar, comprobamos que la fila no puede ser la primera (6a en nuestro caso)
;;; Entonces, si la columna es la misma y f2 == f1+1 introducimos en la base de hechos
;;; que las posiciones son contiguas verticalmente.

(defrule anterior_vertical
(Turno M)
(Tablero Juego ?f1 ?c1 ?v1)
(Tablero Juego ?f2 ?c2 ?v2)
(test (neq ?f1 6)) 
(test
    (and 
        (= ?c1 ?c2) 
        (= ?f2 (+ ?f1 1)) 
    )
)
=>
(assert (anterior ?f2 ?c2 v ?f1 ?c1))
)

;;;================ DIAGONAL ==================;;; 

;;; Esta regla deduce cuál es la siguiente posición en diagonal.
;;; En primer lugar, comprobamos que la fila no puede ser la última (1a en nuestro caso)
;;; y que la columna no puede ser la 7a.
;;; Entonces, si c2 == c1+1 y f2 == f1-1 introducimos en la base de hechos
;;; que las posiciones son contiguas en diagonal.

(defrule siguiente_diagonal
(Turno M)
(Tablero Juego ?f1 ?c1 ?v1)
(Tablero Juego ?f2 ?c2 ?v2)
(test
    (or
        (neq ?f1 1)  
        (neq ?c1 7) 
    )
)
(test
    (and 
        (= ?c2 (+ ?c1 1)) 
        (= ?f2 (- ?f1 1)) 
    )
)
=>
(assert (siguiente ?f1 ?c1 d1 ?f2 ?c2))
)

;;; Esta regla deduce cuál es la posición anterior en diagonal.
;;; En primer lugar, comprobamos que la fila no puede ser la primera (6a en nuestro caso)
;;; y que la columna no puede ser la 1a.
;;; Entonces, si c2 == c1-1 y f2 == f1+1 introducimos en la base de hechos
;;; que las posiciones son contiguas en diagonal.

(defrule anterior_diagonal
(Turno M)
(Tablero Juego ?f1 ?c1 ?v1)
(Tablero Juego ?f2 ?c2 ?v2)
(test
    (or
        (neq ?f1 6) 
        (neq ?c1 1) 
    )
)
(test
    (and 
        (= ?c2 (- ?c1 1)) ; c1 es la siguiente columna
        (= ?f2 (+ ?f1 1)) ; f2 es la fila de abajo
    )
)
=>
(assert (anterior ?f1 ?c1 d1 ?f2 ?c2))
)

;;;================ DIAGONAL INVERSA ==================;;; 

;;; Esta regla deduce cuál es la siguiente posición en diagonal inversa.
;;; En primer lugar, comprobamos que la fila no puede ser la última (1a en nuestro caso)
;;; y que la columna no puede ser la 7a.
;;; Entonces, si c2 == c1+1 y f2 == f1-1 introducimos en la base de hechos
;;; que las posiciones son contiguas en diagonal inversa.

(defrule siguiente_diagonal_inversa
(Turno M)
(Tablero Juego ?f1 ?c1 ?v1)
(Tablero Juego ?f2 ?c2 ?v2)
(test
    (or
        (neq ?f1 1) 
        (neq ?c1 1) 
    )
)
(test
    (and 
        (= ?c2 (- ?c1 1)) 
        (= ?f2 (- ?f1 1)) 
    )
)
=>
(assert (siguiente ?f1 ?c1 d2 ?f2 ?c2))
)

;;; Esta regla deduce cuál es la posición anterior en diagonal inversa.
;;; En primer lugar, comprobamos que la fila no puede ser la primera (6a en nuestro caso)
;;; y que la columna no puede ser la 7a.
;;; Entonces, si c2 == c1+1 y f2 == f1+1 introducimos en la base de hechos
;;; que las posiciones son contiguas en diagonal inversa.

(defrule anterior_diagonal_inversa
(Turno M)
(Tablero Juego ?f1 ?c1 ?v1)
(Tablero Juego ?f2 ?c2 ?v2)
(test
    (or
        (neq ?f1 6) 
        (neq ?c1 7) 
    )
)
(test
    (and 
        (= ?c2 (+ ?c1 1)) 
        (= ?f2 (+ ?f1 1)) 
    )
)
=>
(assert (anterior ?f1 ?c1 d2 ?f2 ?c2))
)

;;; Respuesta al ejercicio 2: Crear reglas para que el sistema deduzca (y mantenga) 
;;; donde caería una ficha si se juega en la columna c.

;;; En primer lugar, estudiamos el caso de que la f1 sea la última fila,
;;; o que ambas filas sean contiguas.  Entonces, presentamos dos casos: 
;;; 1º: La última fila está vacía. 
;;; 2º: (La última fila no está vacía). La casilla correspondiente a la f2 está ocupada, 
;;; mientras que la de la f1 no. 
;;; Para concluir, añadimos a la base de hechos que la ficha caerá en la posicion 'f1', 'c'

(defrule deduccion_donde_cae
(declare (salience 999))
(Turno M)
(Tablero Juego ?f1 ?c ?v1)
(Tablero Juego ?f2 ?c ?v2)
(test
    (or
        (= ?f1 6) 
        (= (+ ?f1 1) ?f2) 
    )
)
(test
    (or
        (and
            (= ?f1 6) 
            (eq ?v1 _) 
        )
        (and
            (neq ?v2 _) 
            (eq ?v1 _) 
        )
    )          
)
=>
(assert (caeria ?f1 ?c))
)

;;; Ejercicio 3: Crear reglas para que el sistema deduzca que hay dos fichas de
;;; un mismo jugador en línea en una dirección y posiciones concretas.

;;; En primer lugar, comprobamos que hay una ficha en la casilla 'f1', 'c1'.
;;; Seguidamente, verificaremos que se cumplan dos condiciones: 
;;; 1º: Que las columnas sean contiguas.
;;; 2º Que las fichas en ambas posiciones, pertenezcan al mismo jugador. 
;;; De ser así, introducimos en la base de hechos que el jugador posee fichas
;;; conectadas de forma horizontal. 
(defrule conectado_horizontal
(declare (salience 998))
(Turno M)
(Tablero Juego ?f1 ?c1 ?v1)
(Tablero Juego ?f1 ?c2 ?v2)
(test
    (neq ?v1 _)
)
(test
    (and
        (= ?c2 (+ ?c1 1)) 
        (eq ?v1 ?v2) 
    )
)
=>
(assert (conectado Juego h ?f1 ?c1 ?f1 ?c2 ?v1))
)

;;; Procedemos a realizar lo mismo, pero esta vez para las combinaciones
;;; conectadas de forma vertical, en diagonal o en diagonal inversa. Puesto que 
;;; son análogas a la regla realizada anteriormente, omitiremos su comentario inicial. 
;;; (Solo hay que cambiar condiciones en cuanto a filas/columnas).

(defrule conectado_vertical
(declare (salience 998))
(Turno M)
(Tablero Juego ?f1 ?c1 ?v1)
(Tablero Juego ?f2 ?c1 ?v2)
(test
    (neq ?v1 _) 
)
(test
    (and
        (= ?f1 (+ ?f2 1)) 
        (eq ?v1 ?v2) 
    )
)
=>
(assert (conectado Juego v ?f1 ?c1 ?f2 ?c1 ?v1))
)

(defrule conectado_diagonal
(declare (salience 998))
(Turno M)
(Tablero Juego ?f1 ?c1 ?v)
(Tablero Juego ?f2 ?c2 ?v)
(test
    (neq ?v _) 
)
(test 
    (and 
        (= ?f1 (+ ?f2 1) ) 
        (= ?c2 (+ ?c1 1) ) 
    ) 
)
=>
(assert (conectado Juego d1 ?f1 ?c1 ?f2 ?c2 ?v))
)

(defrule conectado_diagonal_inversa
(declare (salience 998))
(Turno M)
(Tablero Juego ?f1 ?c1 ?v)
(Tablero Juego ?f2 ?c2 ?v)
(test
    (neq ?v _) 
)
(test 
    (and 
        (= ?f1 (+ ?f2 1) ) 
        (= ?c1 (+ ?c2 1) ) 
    ) 
)
=>
(assert (conectado Juego d2 ?f1 ?c1 ?f2 ?c2 ?v))
)

;;; Ejercicio 4:  Crear reglas para deducir que un jugador tiene 3 en
;;; línea en una dirección y posiciones concretas.

;;; En el caso de tener dos combinaciones de 2 fichas horizontales consecutivas, es decir hay una ficha que es común para ambas
;;; combinaciones, tendremos una combinación de 3 en raya. 
(defrule 3_en_linea_horizontal
(declare (salience 999))
(Turno M)
?h1 <- (conectado Juego h ?f1 ?c1 ?f1 ?c2 ?v) 
?h2 <- (conectado Juego h ?f1 ?c2 ?f1 ?c3 ?v)
=>
(assert (3_en_linea Juego h ?f1 ?c1 ?f1 ?c3 ?v))
(retract ?h1) 
(retract ?h2) 
)

;;; Procedemos a realizar lo mismo, pero esta vez para las combinaciones
;;; conectadas de forma vertical, en diagonal o en diagonal inversa. Puesto que 
;;; son análogas a la regla realizada anteriormente, omitiremos su comentario inicial. 
;;; (Solo hay que cambiar condiciones en cuanto a filas/columnas).

(defrule 3_en_linea_vertical
(declare (salience 999))
(Turno M)
?h1 <- (conectado Juego v ?f1 ?c1 ?f2 ?c2 ?v)
?h2 <- (conectado Juego v ?f2 ?c2 ?f3 ?c3 ?v)
=>
(assert (3_en_linea Juego v ?f1 ?c1 ?f3 ?c3 ?v))
(retract ?h1) 
(retract ?h2)
)


(defrule 3_en_linea_diagonal
(declare (salience 999))
(Turno M)
?h1 <- (conectado Juego d1 ?f1 ?c1 ?f2 ?c2 ?v)
?h2 <- (conectado Juego d1 ?f2 ?c2 ?f3 ?c3 ?v)
=>
(assert (3_en_linea Juego d1 ?f1 ?c1 ?f3 ?c3 ?v))
(retract ?h1) 
(retract ?h2)
)

(defrule 3_en_linea_diagonal_inversa
(declare (salience 999))
(Turno M)
?h1 <- (conectado Juego d2 ?f1 ?c1 ?f2 ?c2 ?v)
?h2 <- (conectado Juego d2 ?f2 ?c2 ?f3 ?c3 ?v)
=>
(assert (3_en_linea Juego d2 ?f1 ?c1 ?f3 ?c3 ?v))
(retract ?h1) 
(retract ?h2) 
)


;;; Ejercicio 5: Añadir reglas para que el sistema deduzca (y mantenga) que un jugador ganaría si jugase en una columna.

;;; Mediante esta regla obtenemos una combinación de 4 en raya de forma horizontal, a partir de una de 3 ya existente. Para ello, comprobamos que existe esta,
;;; y que exista una posicion vacia en una de las columnas contiguas de la misma fila.  
(defrule ganaria_horizontal
(declare (salience 999))
(Turno M)
(3_en_linea Juego h ?f1 ?c1 ?f2 ?c2 ?v)
(Tablero Juego ?f3 ?c3 ?val)
(caeria ?f3 ?c3)
(test (eq ?val _))
(test
    (or
        (= ?c1 (+ ?c3 1)) 
        (= ?c2 (- ?c3 1)) 
    )
)
(test
    (and
        (= ?f1 ?f2) 
        (= ?f2 ?f3) 
    )
)
=>
(assert (ganaria ?v ?c3))
)

;;; Esta regla se va a diferenciar un poco de la anterior. En este caso vamos a hacer 4 en raya horizontalmente pero partiendo de otro caso. 
;;; En este caso vamos a tener una combinación de 2 en raya, una posicion vacia justamente a su derecha y otra ficha del jugador justo a la derecha
;;; de esta última. Es decir, tendriamos lo siguiente en la fila i-ésima: M M _ M.
(defrule ganaria_horizontal_echando_en_medio
(declare (salience 999))
(Turno M)
(conectado Juego h ?f1 ?c1 ?f1 ?c2 ?v)
(Tablero Juego ?f1 ?c3 ?v)

;;; Casilla vacia en mitad
(Tablero Juego ?f1 ?c4 _)
(caeria ?f1 ?c4)

;;; Comprobaciones
(test
    (and
        (= ?c3 (+ ?c2 2)) 
        (= ?c4 (+ ?c2 1)) 
    )
)
=>
(assert (ganaria ?v ?c4))
)

;;; Mismo caso que el anterior, pero invirtiendo el orden. Ahora se nos presentaría el siguiente caso: M _ M M
(defrule ganaria_horizontal_echando_en_medio_2
(declare (salience 999))
(Turno M)
(conectado Juego h ?f1 ?c1 ?f1 ?c2 ?v)
(Tablero Juego ?f1 ?c3 ?v)

;;; Casilla vacia en mitad
(Tablero Juego ?f1 ?c4 _)
(caeria ?f1 ?c4)

;;; Comprobaciones
(test
    (and
        (= ?c3 (- ?c1 2)) 
        (= ?c4 (- ?c1 1)) 
    )
)
=>
(assert (ganaria ?v ?c4))
)

;;; Procedemos a realizar lo mismo, pero esta vez para las combinaciones
;;; conectadas de forma vertical, en diagonal o en diagonal inversa. Puesto que 
;;; son análogas a la regla realizada anteriormente, omitiremos su comentario inicial. 
;;; (Solo hay que cambiar condiciones en cuanto a filas/columnas).

(defrule ganaria_vertical
(declare (salience 999))
(Turno M)
(3_en_linea Juego v ?f1 ?c1 ?f2 ?c2 ?v)
(Tablero Juego ?f3 ?c3 ?val)
(caeria ?f3 ?c3)
(test (eq ?val _))
(test (= ?f2 (+ ?f3 1))) ; las filas f2 y f3 son contiguas
(test
    (and
        (= ?c1 ?c2) ; las columnas c1 y c2 son las mismas
        (= ?c2 ?c3) ; las columnas c2 y c3 son las mismas
    )
)
=>
(assert (ganaria ?v ?c3))
)

(defrule ganaria_diagonal
(declare (salience 999))
(Turno M)
(3_en_linea Juego d1 ?f1 ?c1 ?f2 ?c2 ?v)
(Tablero Juego ?f3 ?c3 ?val)
(caeria ?f3 ?c3)
(test (eq ?val _))
(test
    (or
        (and
            (= ?f1 (- ?f3 1))
            (= ?c1 (+ ?c3 1))
        )
        (and
            (= ?f2 (+ ?f3 1))
            (= ?c2 (- ?c3 1))
        )
    )
)
=>
(assert (ganaria ?v ?c3))
)

(defrule ganaria_diagonal_inversa
(declare (salience 999))
(Turno M)
(3_en_linea Juego d2 ?f1 ?c1 ?f2 ?c2 ?v)
(Tablero Juego ?f3 ?c3 ?val)
(caeria ?f3 ?c3)
(test (eq ?val _))
(test
    (or
        (and
            (= ?f1 (- ?f3 1))
            (= ?c1 (- ?c3 1))
        )
        (and
            (= ?f2 (+ ?f3 1))
            (= ?c2 (+ ?c3 1))
        )
    )
)
=>
(assert (ganaria ?v ?c3))
)

;;; ========== Segunda Parte: Reglas que indican cómo sería mi juego. ===========

;;; ========== INICIO DE PARTIDA ========== ;;;

;;; Con esta regla, jugaremos en la columna central en caso de ser el 
;;; jugador M quien empieza jugando. Los antecedentes consisten en comprobar
;;; que no hay ninguna ficha en la fila 6 (equivalente a que M empieza la partida).

(defrule empieza_M
?f <- (Turno M)
(Tablero Juego 6 1 _)
(Tablero Juego 6 2 _)
(Tablero Juego 6 3 _)
(Tablero Juego 6 4 _)
(Tablero Juego 6 5 _)
(Tablero Juego 6 6 _)
(Tablero Juego 6 7 _)
=>
(assert (Juega M 4))
(printout t "Razonamiento: estadisticamente hay una mayor probabilidad de ganar si se empieza jugando en la columna central. Por tanto, M juega en la columna 4." crlf)
(retract ?f)
)

;;; Con esta regla, jugaremos en la columna central en caso de que haya comenzado
;;; jugando el jugador J, pero no haya colocado ficha ahí. Los antecedentes consisten en comprobar
;;; que solo hay una única ficha en la fila 6, de J, (equivalente a que J empieza la partida).
;;; Así mismo, dicha ficha no puede estar en la columna 4.

(defrule empieza_J_no_centro
?f <- (Turno M)
(Tablero Juego 6 ?c J)
(Tablero Juego 6 ?c1 _)
(Tablero Juego 6 ?c2 _)
(Tablero Juego 6 ?c3 _)
(Tablero Juego 6 ?c4 _)
(Tablero Juego 6 ?c5 _)
(Tablero Juego 6 ?c6 _)
(test
    (neq ?c 4)
)
=>
(assert (Juega M 4))
(printout t "Razonamiento: estadisticamente hay una mayor probabilidad de ganar si se empieza jugando en la columna central. Por tanto, M juega en la columna 4." crlf)
(retract ?f)
)

;;; Con esta regla, jugaremos en la columna 5 en caso de que haya comenzado
;;; jugando el jugador J, y haya colocado ficha ahí. Los antecedentes consisten en comprobar
;;; que solo hay una única ficha en la fila 6, de J. Concretamente en la columna 4 (equivalente a que J empieza la partida).

(defrule empieza_J_centro
?f <- (Turno M)
(Tablero Juego 6 ?c J)
(Tablero Juego 6 ?c1 _)
(Tablero Juego 6 ?c2 _)
(Tablero Juego 6 ?c3 _)
(Tablero Juego 6 ?c4 _)
(Tablero Juego 6 ?c5 _)
(Tablero Juego 6 ?c6 _)
(test
    (eq ?c 4)
)
=>
(assert (Juega M 5))
(printout t "Razonamiento: El jugador J comienza jugando en la columna central. Por tanto, M juega en la columna contigua a esta." crlf)
(retract ?f)
)

;;; ======== COMBINACIONES DE 2 FICHAS =========== ;;;

;;; En el caso de que no tengamos ninguna combinación de 2 fichas consecutivas, buscamos la posibilidad de hacer una
;;; de forma horizontal, si es posible.

(defrule conectar_2_horizontal
(declare (salience 600))
?f <- (Turno M)
(Tablero Juego ?f1 ?c1 M)
(caeria ?f1 ?c2)
(Tablero Juego ?f1 ?c2 _) 
(test    
    (or
        (= ?c2 (- ?c1 1)) 
        (= ?c2 (+ ?c1 1)) 
    )    
)
=>
(assert (Juega M ?c2))
(printout t "Turno de M. Juego en la columna " ?c2 ". Razonamiento: conectar 2 fichas horizontalmente." crlf)
(retract ?f)
)

;;; En el caso de que no tengamos ninguna combinación de 2 fichas consecutivas, buscamos la posibilidad de hacer una
;;; de forma vertical, si es posible.

(defrule conectar_2_vertical
(declare (salience 599))
?f <- (Turno M)
(Tablero Juego ?f1 ?c1 M)
(caeria ?f2 ?c1)
(Tablero Juego ?f2 ?c1 _) 
(test (= ?f2 (- ?f1 1)))
=>
(assert (Juega M ?c1))
(printout t "Turno de M. Juego en la columna " ?c1 ". Razonamiento: conectar 2 fichas verticalmente." crlf)
(retract ?f)
)

;;; En el caso de que no tengamos ninguna combinación de 2 fichas consecutivas, buscamos la posibilidad de hacer una
;;; en diagonal, si es posible.

(defrule conectar_2_diagonal
(declare (salience 598))
?f <- (Turno M)
(Tablero Juego ?f1 ?c1 M)
(caeria ?f2 ?c2)
(Tablero Juego ?f2 ?c2 _) 
(test
    (and
        (= ?f1 (+ ?f2 1)) 
        (= ?c2 (+ ?c1 1)) 
    )
)
=>
(assert (Juega M ?c2))
(printout t "Turno de M. Juego en la columna " ?c2 ". Razonamiento: conectar 2 fichas en diagonal principal." crlf)
(retract ?f)
)

;;; En el caso de que no tengamos ninguna combinación de 2 fichas consecutivas, buscamos la posibilidad de hacer una
;;; en diagonal inversa, si es posible.

(defrule conectar_2_diagonal_inversa
(declare (salience 597))
?f <- (Turno M)
(Tablero Juego ?f1 ?c1 M)
(caeria ?f2 ?c2)
(Tablero Juego ?f2 ?c2 _) 
(test
    (and
        (= ?f1 (+ ?f2 1)) 
        (= ?c2 (- ?c1 1)) 
    )
)
=>
(assert (Juega M ?c2))
(printout t "Turno de M. Juego en la columna " ?c2 ". Razonamiento: conectar 2 fichas en diagonal inversa." crlf)
(retract ?f)
)

;;; ======== COMBINACIONES DE 3 FICHAS =========== ;;;

;;; En el caso de que tengamos una combinación de 2 fichas consecutivas
;;; horizontalmente, si es posible, jugamos para convertirla en una combinación de 3. 

(defrule conectar_3_horizontal
(declare (salience 700))
?f <- (Turno M)
(conectado Juego h ?f1 ?c1 ?f2 ?c2 M)
(caeria ?f1 ?c3)
(Tablero Juego ?f1 ?c3 _) 
(test
    (or
        (= ?c3 (+ ?c2 1)) 
        (= ?c3 (- ?c1 1)) 
    )
)
=>
(assert (Juega M ?c3))
(printout t "Turno de M. Juego en la columna " ?c3 ". Razonamiento: conectar 3 fichas horizontalmente." crlf)
(retract ?f)
)

;;; Si tenemos dos fichas que horizontalmente están separadas por una posición vacía, entonces echamos en esa casilla
;;; intermedia para generar una combinación de 3 en raya
(defrule conectar_3_horizontal_2
(declare (salience 700))
?f <- (Turno M)
(Tablero Juego ?f1 ?c1 M) 
(Tablero Juego ?f1 ?c2 M) 
(test
    (= ?c2 (+ ?c1 2))
)
(caeria ?f1 ?c3)
(Tablero Juego ?f1 ?c3 _) 
(test
    (= ?c3 (+ ?c1 1)) 
)
=>
(assert (Juega M ?c3))
(printout t "Turno de M. Juego en la columna " ?c3 ". Razonamiento: conectar 3 fichas horizontalmente." crlf)
(retract ?f)
)

;;; En el caso de que tengamos una combinación de 2 fichas consecutivas
;;; verticalmente, si es posible, jugamos para convertirla en una combinación de 3.

(defrule conectar_3_vertical
(declare (salience 699))
?f <- (Turno M)
(conectado Juego v ?f1 ?c1 ?f2 ?c2 M)
(caeria ?f3 ?c1)
(Tablero Juego ?f3 ?c1 _) 
(test
    (= ?f2 (+ ?f3 1)) 
)
=>
(assert (Juega M ?c1))
(printout t "Turno de M. Juego en la columna " ?c1 ". Razonamiento: conectar 3 fichas verticalmente." crlf)
(retract ?f)
)

;;; En el caso de que tengamos una combinación de 2 fichas consecutivas
;;; en diagonal, si es posible, jugamos para convertirla en una combinación de 3.

(defrule conectar_3_diagonal
(declare (salience 698))
?f <- (Turno M)
(conectado Juego d1 ?f1 ?c1 ?f2 ?c2 M)
(caeria ?f3 ?c3)
(Tablero Juego ?f3 ?c3 _) 
(test
    (and
        (= ?f2 (+ ?f3 1)) 
        (or
            (= ?c3 (+ ?c2 1)) 
            (= ?c3 (- ?c1 1)) 
        )
    )
)
=>
(assert (Juega M ?c3))
(printout t "Turno de M. Juego en la columna " ?c3 ". Razonamiento: conectar 3 fichas en diagonal principal." crlf)
(retract ?f)
)

;;; En el caso de que tengamos una combinación de 2 fichas consecutivas
;;; en diagonal inversa, si es posible, jugamos para convertirla en una combinación de 3.

(defrule conectar_3_diagonal_inversa
(declare (salience 697))
?f <- (Turno M)
(conectado Juego d2 ?f1 ?c1 ?f2 ?c2 M)
(caeria ?f3 ?c3)
(Tablero Juego ?f3 ?c3 _) 
(test
    (and
        (= ?f2 (+ ?f3 1)) 
        (= ?c3 (- ?c2 1)) 
    )
)
=>
(assert (Juega M ?c3))
(printout t "Turno de M. Juego en la columna " ?c3 ". Razonamiento: conectar 3 fichas en diagonal inversa." crlf)
(retract ?f)
)

;;; ========= VICTORIA / EVITAR DERROTA =========== ;;;

;;; Si hay una posibilidad de ganar la partida jugando en la columna 'c', 
;;; jugamos en dicha columna. 

(defrule victoria
(declare (salience 900))
?f <- (Turno M)
?g <-(ganaria M ?c)
=>
(assert (Juega M ?c))
(printout t "Turno de M. Juego en la columna " ?c ". Razonamiento: M gana la partida." crlf)
(retract ?f ?g)
)

;;; Si hay una posibilidad de que el jugador contrario, J, gane la partida 
;;; en su próximo movimiento jugando en la columna 'c', jugamos a dicha 
;;; columna para evitar que nos gane. Todo esto si no podemos ganar nostros, claro esta. 

(defrule evitar_derrota
(declare (salience 800))
?f <- (Turno M)
?g <- (ganaria J ?c)
=>
(assert (Juega M ?c))
(printout t "Turno de M. Juego en la columna " ?c ". Razonamiento: M evita la victoria de J." crlf)
(retract ?f ?g)
)