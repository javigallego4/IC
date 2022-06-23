;Las aves y los mamíferos son animales
;Los gorriones, las palomas, las águilas y los pingüinos son aves
;La vaca, los perros y los caballos son mamíferos
;Los pingüinos no vuelan

(deffacts datos
	(ave gorrion) (ave paloma) (ave aguila) (ave pinguino)
	(mamifero vaca) (mamifero perro) (mamifero caballo)
	(vuela pinguino no seguro) 
)

;;;;;;;;;;;;;; Reglas seguras ;;;;;;;;;;;;;;

; Las aves son animales
(defrule aves_son_animales
    (ave ?x)
    =>
    (assert (animal ?x))
    (bind ?expl (str-cat "sabemos que un " ?x " es un animal porque las aves son un tipo de animal"))
    (assert (explicacion animal ?x ?expl))
)
; añadimos un hecho que contiene la explicacion de la deduccion


; Los mamiferos son animales (A3)
(defrule mamiferos_son_animales
    (mamifero ?x)
    =>
    (assert (animal ?x))
    (bind ?expl (str-cat "sabemos que un " ?x " es un animal porque los mamiferos son un tipo de animal"))
    (assert (explicacion animal ?x ?expl))
)
; añadimos un hecho que contiene la explicacion de la deduccion


;;;;;;;;;;;;;;;; Regla por defecto: añade ;;;;;;;;;;;;;;;;

;;; Casi todos las aves vuela --> puedo asumir por defecto que las aves vuelan

; Asumimos por defecto
(defrule ave_vuela_por_defecto
    (declare (salience -1)) ; para disminuir probabilidad de añadir erroneamente
    (ave ?x)
    =>
    (assert (vuela ?x si por_defecto))
    (bind ?expl (str-cat "asumo que un " ?x " vuela, porque casi todas las aves vuelan"))
    (assert (explicacion vuela ?x ?expl))
)

;;;;;;;;;;;;;;;; Regla por defecto: retracta ;;;;;;;;;;;;;;;;

; Retractamos cuando hay algo en contra
(defrule retracta_vuela_por_defecto
    (declare (salience 1))  ; para retractar antes de inferir cosas erroneamente
    ?f <- (vuela ?x ?r por_defecto)
    (vuela ?x ?s seguro)
    =>
    (retract ?f)
    (bind ?expl (str-cat "retractamos que un " ?x ?r " vuela por defecto, porque sabemos seguro que " ?x ?s " vuela"))
    (assert (explicacion retracta_vuela ?x ?expl))
)
;;; COMENTARIO: esta regla tambien elimina los por defecto cuando ya esta seguro


;;;;;;;;;;;;;;;; Regla por defecto para razonar con informacion incompleta ;;;;;;;;;;;;;;;;
;;; La mayor parte de los animales no vuelan --> puede interesarme asumir por defecto que un animal no va a volar

(defrule mayor_parte_animales_no_vuelan
    (declare (salience -2))  ; es mas arriesgado, mejor despues de otros razonamientos
    (animal ?x)
    (not (vuela ?x ? ?))
    =>
    (assert (vuela ?x no por_defecto))
    (bind ?expl (str-cat "asumo que " ?x " no vuela, porque la mayor parte de los animales no vuelan"))
    (assert (explicacion vuela ?x ?expl))
)

; Completar esta base de conocimiento para que el sistema pregunte
; que de qué animal esta interesado en obtener información sobre si
; vuela y:
;;;;;;; - Si es uno de los recogidos en el conocimiento indique si vuela o no
;;;;;;; - Si no es uno de los recogidos pregunte si es un ave o un mamífero y
;;;;;;;  según la respuesta indique si vuela o no.
;;;;;;; - Si no se sabe si es un mamífero o un ave también responda según el
;;;;;;;  razonamiento por defecto indicado

; Mediante la siguiente regla preguntamos al usuario por el animal del que le interesa
; saber si vuela o no. 
(defrule pregunta
	(not (preguntado ?))
	=>
	(printout t "Introduzca informacion a cerca del animal sobre el que este interesado ... " crlf)
	(bind ?animal (read))
    (assert (preguntado ?animal)) 

)

; Con esta regla tratamos el caso de que el animal introducido no se encuentre recogido aún. 
; Entonces preguntamos el tipo de animal que es. 
(defrule animal_no_esta_recogido
	(not (animal_es ?tipo))
	(preguntado ?animal)
	(test (and 
                (neq ?animal gorrion)
                (neq ?animal paloma) 
                (neq ?animal aguila) 
                (neq ?animal pinguino) 
                (neq ?animal caballo) 
                (neq ?animal perro) 
                (neq ?animal vaca))) 
	=>
	(printout t "Dime si el/la " ?animal " es un mamifero / ave? POSIBLES RESPUESTAS: [mamifero / ave / desconocido]" crlf)
	; Introducimos el tipo del animla.
    (assert (animal_es ?animal (read)))
)

; Con esta regla comprobamos si se ha introducido bien el tipo de animal, para uno que no esté recogido. 
(defrule comprobar_entrada_tipo_animal
    ?f <- (animal_es ?animal ?tipo)
    ; Con esto comprobamos que el valor introducido no es correcto. 
    (test (and 
                (neq ?tipo mamifero) 
                (neq ?tipo ave) 
                (neq ?tipo desconocido)))
    =>
    (printout t "No has introducido un tipo de animal correcto. Introduzcalo de nuevo: POSIBLES RESPUESTAS: [mamifero / ave / desconocido]" crlf)
    ; Puesto que se introdujo un valor erróneo, se elimina el hecho de la base de hechos.
    (retract ?f)
    (assert (animal_es ?animal (read)))
)

; Con esta regla vemos que si vuela o no, sabiendo que el tipo es ave.  
(defrule es_ave_tipo
    (animal_es ?x ave)
    =>
    (assert (ave ?x))
)

; Con esta regla vemos que si vuela o no, sabiendo que el tipo es mamifero.  
(defrule es_mamifero_conocido
    (animal_es ?x mamifero)
    =>
    (assert (mamifero ?x))
)

; Con esta regla vemos que si vuela o no, sabiendo que se desconoce el tipo de animal (desconocido).  
(defrule animal_es_desconocido
    (animal_es ?x desconocido)
    =>
    (assert (animal ?x))
)

;;;;;;;;; REGLAS PARA IMPRIMIR POR PANTALLA LA RESPUESTA ;;;;;;;;;;;;;

; Con esta regla tratamos el caso de que el animal que introduce el usuario
; ya está recogido. 
(defrule salida_animal_recogido
	(preguntado ?animal)
	(test (or 
                (eq ?animal perro) 
                (eq ?animal vaca)            
                (eq ?animal paloma)             
                (eq ?animal gorrion) 
                (eq ?animal aguila) 
                (eq ?animal pinguino) 
                (eq ?animal caballo) 
            )
    )
	(vuela ?animal ?x ?certeza) 
	(explicacion vuela ?animal ?explicacion)
	=>
	(printout t ?explicacion crlf)
)

; Con esta regla damos la respuesta para un animal que no estaba almacenado, pero
; del que nos han proporcionado su tipo
(defrule salida_animal_no_recogido
    ;(not(respondido))
    (animal_es ?animal ?f)
    (vuela ?animal ?x ?y)
    (explicacion vuela ?animal ?explicacion)
    =>
    (printout t ?explicacion crlf)
)
