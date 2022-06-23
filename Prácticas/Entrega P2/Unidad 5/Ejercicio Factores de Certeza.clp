;;; Ejercicio de Factores de Certeza
;;; Alumno: Gallego Menor, Francisco Javier

; Convertimos cada evidencia en una afirmacion sobre su factor de certeza
(defrule certeza_evidencias
    (declare (salience 999))
    (Evidencia ?e ?r)
    =>
    (assert (FactorCerteza ?e ?r 1))
    (assert (Motivo FactorCerteza ?e ?r 1 "me lo has dicho"))
)
; Tambien podriamos considerar evidencias con una cierta incertidumbre:
; al preguntar por la evidencia, pedir y recoger directamente el grado de certeza

;;; Funcion encadenado ;;;

(deffunction encadenado (?fc_antecedente ?fc_regla)
    (if (> ?fc_antecedente 0)
        then
            (bind ?rv (* ?fc_antecedente ?fc_regla))
        else
            (bind ?rv 0)
    )
    ?rv
)

;;; Función combinación ;;;

(deffunction combinacion (?fc1 ?fc2)
    (if (and (> ?fc1 0) (> ?fc2 0))
        then 
            (bind ?rv (- (+ ?fc1 ?fc2) (* ?fc1 ?fc2)))
    else 
            (if (and (< ?fc1 0) (< ?fc2 0))
                then 
                    (bind ?rv (+ (+ ?fc1 ?fc2) (* ?fc1 ?fc2)))
            else 
                    (bind ?rv (/ (+ ?fc1 ?fc2) (- 1 (min (abs ?fc1) (abs ?fc2)))))
            )
    )
    ?rv
)

;;; Combinar distintas deducciones ;;;

(defrule combinar
    (declare (salience 1))
    ?f <- (FactorCerteza ?h ?r ?fc1)
    ?g <- (FactorCerteza ?h ?r ?fc2)
    ?x <- (Motivo FactorCerteza ?h ?r ?fc1 ?expl1)
    ?y <- (Motivo FactorCerteza ?h ?r ?fc2 ?expl2)
    (test (neq ?fc1 ?fc2))
    =>
    (retract ?f ?g ?x ?y)
    (assert (FactorCerteza ?h ?r (combinacion ?fc1 ?fc2)))
    (assert (Motivo FactorCerteza ?h ?r (combinacion ?fc1 ?fc2) (str-cat ?expl1 " y " ?expl2)))
)

;;; Certeza de las hipotesis ;;;

(defrule combinar_signo
    (declare (salience 2))
    (FactorCerteza ?h si ?fc1)
    (FactorCerteza ?h no ?fc2)
    =>
    (assert (Certeza ?h (- ?fc1 ?fc2)))
)

;;; REGLAS QUE AÑADO PARA COMPLETAR EL EJERCICIO ;;;
;; Preguntas sobre las posibles evidencias ;;;

(defrule intenta_arrancar
    (not (Evidencia hace_intentos_arrancar ?r))
    =>
    (printout t "El motor hace intentos de arrancar ? RESPUESTAS VALIDAS: [si / no]" crlf)
    (bind ?respuesta (read))
    (assert (Evidencia hace_intentos_arrancar ?respuesta))
)

(defrule gasolina_en_deposito
    (not (Evidencia hay_gasolina_en_deposito ?r))
    =>
    (printout t "Hay gasolina en el deposito ? RESPUESTAS VALIDAS: [si / no]" crlf)
    (bind ?respuesta (read))
    (assert (Evidencia hay_gasolina_en_deposito ?respuesta))
)

(defrule encienden_luces
    (not (Evidencia encienden_las_luces ?r))
    =>
    (printout t "Se encienden las luces ? RESPUESTAS VALIDAS: [si / no]" crlf)
    (bind ?respuesta (read))
    (assert (Evidencia encienden_las_luces ?respuesta))
)

(defrule gira_motor
    (not (Evidencia gira_motor ?r))
    =>
    (printout t "El motor gira ? RESPUESTAS VALIDAS: [si / no]" crlf)
    (bind ?respuesta (read))
    (assert (Evidencia gira_motor ?respuesta))
)

; Compruebo que la entrada sea valida
(defrule comprobar_entrada
    ?f <- (Evidencia ?evidencia ?x)
    (test (and (neq ?x si) (neq ?x Si) (neq ?x SI) (neq ?x no) (neq ?x No) (neq ?x NO) )) 
    =>
    (retract ?f)
    (printout t "Introduzca una respuesta correcta. POSIBLES RESPUESTAS: [si | no]" crlf)
)

;;; TRADUCIMOS LAS REGLAS ;;; 

; R1: SI el motor obtiene gasolina Y el motor gira ENTONCES problemas con las bujias con certeza 0.7
(defrule R1
    (FactorCerteza motor_llega_gasolina si ?f1)
    (FactorCerteza gira_motor si ?f2)
    (test (and (> ?f1 0) (> ?f2 0)))
    =>
    (assert (FactorCerteza problema_bujias si (encadenado (* ?f1 ?f2) 0.7)))
    (assert (Motivo FactorCerteza problema_bujias si (encadenado (* ?f1 ?f2) 0.7) "porque llega gasolina al motor y el motor gira"))
)

; R2: SI NO gira el motor ENTONCES problema con el starter con certeza 0.8
(defrule R2
    (FactorCerteza gira_motor no ?f1)
    (test (> ?f1 0))
    => 
    (assert (FactorCerteza problema_starter si (encadenado ?f1 0.8))) 
    (assert (Motivo FactorCerteza problema_starter si (encadenado ?f1 0.8) "porque el motor no gira"))
)

; R3: SI NO encienden las luces ENTONCES problemas con la bateria con certeza 0.9
(defrule R3
    (FactorCerteza encienden_las_luces no ?f1)
    (test (> ?f1 0))
    => 
    (assert (FactorCerteza problema_bateria si (encadenado ?f1 0.9))) 
    (assert (Motivo FactorCerteza problema_bateria si (encadenado ?f1 0.9) "porque las luces no se encienden"))
)

; R4: SI hay gasolina en el deposito ENTONCES el motor obtiene gasolina con certeza 0.9
(defrule R4
    (FactorCerteza hay_gasolina_en_deposito si ?f1)
    (test (> ?f1 0))
    => 
    (assert (FactorCerteza motor_llega_gasolina si (encadenado ?f1 0.9))) 
    (assert (Motivo FactorCerteza motor_llega_gasolina si (encadenado ?f1 0.9) "porque hay gasolina en el deposito"))
)

; R5: SI hace intentos de arrancar ENTONCES problema con el starter con certeza -0.6
(defrule R5
    (FactorCerteza hace_intentos_arrancar si ?f1)
    (test (> ?f1 0))
    => 
    (assert (FactorCerteza problema_starter si (encadenado ?f1 -0.6))) 
    (assert (Motivo FactorCerteza problema_starter si (encadenado ?f1 -0.6) "porque intenta arrancar"))
)

; R6: SI hace intentos de arrancar ENTONCES problema con la bateria 0.5
(defrule R6
    (FactorCerteza hace_intentos_arrancar si ?f1)
    (test (> ?f1 0))
    => 
    (assert (FactorCerteza problema_bateria si (encadenado ?f1 0.5))) 
    (assert (Motivo FactorCerteza problema_bateria si (encadenado ?f1 0.5) "porque intenta arrancar"))
)

; Una vez hemos razonado, nos quedamos con las hipotesis con mayor certeza
(defrule hipotesis_mayor_certeza
    ; Metemos esta prioridad para que nos salgan todas las respuestas al final juntas
    (declare (salience -5))
    (FactorCerteza ?h1 ?resp1 ?f1)
    ?f <- (FactorCerteza ?h2 ?resp2 ?f2)
    (test(and (> ?f1 ?f2) (< ?f1 1)))
    =>
    (printout t "Borramos que " ?resp2 " ocurra que " ?h2 " porque tiene menor certeza (" ?f2 ")" crlf)
    (retract ?f)
)

(defrule mostrar_deducciones_por_pantalla
    ; Metemos esta prioridad para que nos salgan todas las respuestas al final juntas
    (declare (salience -10))
    ?g <- (Motivo FactorCerteza ?h ?r ?f1 ?expl)    
    ?f <- (FactorCerteza ?h ?r ?f1)
    =>
    (printout t "El factor deducido es que " ?r " ocurre que " ?h " con certeza " ?f1 " porque " ?expl crlf)
    (retract ?f ?g)
)