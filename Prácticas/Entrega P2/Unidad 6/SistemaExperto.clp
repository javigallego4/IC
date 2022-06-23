;;; FRANCISCO JAVIER GALLEGO MENOR, GRUPO 2 ;;;

; Esta práctica consta de dos partes principales: 
;   1.- El Apartado A), el cual fue ya implementado y entregado en la primera entrega. 
;       Dicho apartado se encuentra al comienzo de este archivo. 
;   2.- El Apartado B), el cual es el que se nos pide implementar. Dicho apartado, se encuentra
;       a partir de la línea 1030. 

;;;;;;;;;;;;;;;;;;;;;;;;; APARTADO A ;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; ========== PROPIEDADES QUE VOY A USAR ========== ;;; 

;;; Nuestro sistema experto tendrá en cuenta si al estudiante le gustan las matemáticas. 
;;; Los posibles valores que tomará son: SI, NO, NS (no lo sé)
;;; La representación será la siguiente: (gusta Matemáticas SI | NO | NS)

;;; Nuestro sistema experto tendrá en cuenta qué tipo de trabajo prefiere el estudiante. 
;;; Los posibles valores que tomará son: EMPRESA PRIVADA, EMPRESA PUBLICA, DOCENCIA, NS (no lo sé)
;;; La representación será la siguiente: (rTrabajo EMPRESA_PUBLICA | EMPRESA_PRIVADA | DOCENCIA | NS)

;;; Nuestro sistema experto tendrá en cuenta la nota media del estudiante. 
;;; Los posibles valores que tomará son: BAJA, MEDIA, ALTA, NS (no lo sé)
;;; La representación será la siguiente: (rNota BAJA | MEDIA | ALTA | NS)

;;; Nuestro sistema experto tendrá en cuenta si al estudiante le apasiona lo relacionado con hardware. 
;;; Los posibles valores que tomará son: SI, NO, NS (no lo sé)
;;; La representación será la siguiente: (gusta Hardware SI | NO | NS)

;;; Nuestro sistema experto tendrá en cuenta cómo de trabajador se considera el estudiante a sí mismo. 
;;; Los posibles valores que tomará son: POCO, NORMAL, MUCHO, NS (no lo sé)
;;; La representación será la siguiente: (rTrabajador POCO | NORMAL | MUCHO | NS)

;;; Nuestro sistema experto tendrá en cuenta si al estudiante le apasiona la programación. 
;;; Los posibles valores que tomará son: SI, NO, NS (no lo sé)
;;; La representación será la siguiente: (gusta programacion SI | NO | NS)

;;; Nuestro sistema experto tendrá en cuenta si a nuestro estudiante le llama más la atención la teoría, o la práctica. 
;;; Los posibles valores que tomará son: TEORIA, PRACTICA, NS (no lo sé)
;;; La representación será la siguiente: ;;;; (rTipoClases TEORIA | PRACTICAS | NS)

;;; Hecho para representar que el sistema aconseja elegir una rama por un motivo
;;; (Consejo <nombre de la rama> "<texto del motivo>" "apodo del experto")

;;; RAMAS OPTATIVAS INFORMATICA
(deffacts Ramas
    (Rama Computacion_y_Sistemas_Inteligentes)
    (Rama Ingenieria_del_Software)
    (Rama Ingenieria_de_Computadores)
    (Rama Sistemas_de_Informacion)
    (Rama Tecnologias_de_la_Informacion)
)

;;; ========= INICIO DEL PROGRAMA ========== ;;; 

(defrule inicio_programa
    (declare (salience 9999))    
    =>    
    (printout t "Hola, mi funcion es aconsejarte que rama optativa escoger." crlf)
    (printout t "Para ello, voy a realizarte una serie de preguntas y en base a tus respuestas deducire cual es la rama mas apropiada para ti." crlf)
    (printout t "Si en algun momento no te apetece seguir respondiendo a mis preguntas, escribe PARAR." crlf)
    (focus ModuloPreguntas)
)

;;; ========= MODULO PREGUNTAS ============ ;;;

(defmodule ModuloPreguntas (export ?ALL))

;;; PREGUNTAS
(deffacts Preguntas
    (Modulo ModPreg)
    (pregunta sobre matematicas)
    (pregunta sobre trabajo)
    (pregunta sobre nota)
    (pregunta sobre hardware)
    (pregunta sobre trabajador)
    (pregunta sobre programacion)
    (pregunta sobre tipoClases)
)

;;; ========= PREGUNTAS SOBRE SI LE GUSTA _ AL ESTUDIANTE =========== ;;;

;;; Mediante esta regla comprobaremos que las preguntas que tienen como respuesta
;;; SI | NO | NS, reciben una respuesta válida. En caso contrario, se le indica al
;;; usuario que introduzca de nuevo la respuesta. 

(defrule respuesta_preguntas_SiNoNS
    (declare (salience 999))
    (Modulo ModPreg)
    ?f <- (gusta ?pregunta ?respuesta)
    (test
        (or
            (and
                (neq ?respuesta SI)
                (and
                    (neq ?respuesta NO)
                    (neq ?respuesta NS) 
                )
            )
            (neq (type ?respuesta) SYMBOL)
        )
    )
    =>
    (printout t "Debe introducir una respuesta valida: SI | NO | NS: " crlf)
    (retract ?f)
    (assert (pregunta sobre ?pregunta))
)

;;; Con esta regla, comprobaremos si el usuario decide parar las preguntas. 
;;; En concreto, esta regla sirve para aquellas preguntas que se responden con
;;; SI | NO | NS.

(defrule parar_preguntas_SiNoNS
    (declare (salience 9999))
    ?f <- (gusta ?pregunta ?respuesta)
    (test (eq ?respuesta PARAR))
    =>
    (retract ?f)
    (printout t "Vale, no hare mas preguntas. ")
    (assert (rParar SI))
)

;;; Mediante esta regla obtendremos respuesta a la pregunta de si le gustan 
;;; las matemáticas al estudiante o no (o no sé).

(defrule preg_Mates
    (declare (salience 9))
    (Modulo ModPreg)
    ?f <- (pregunta sobre matematicas)
    =>
    (retract ?f)
    (printout t "¿Te gustan las matematicas? RESPUESTAS POSIBLES: (SI | NO | NS)" crlf)
    (assert (gusta matematicas (upcase (read))))
)

;;; Mediante esta regla obtendremos respuesta a la pregunta de si le gusta 
;;; lo relacionado con hardware al estudiante o no (o no sé).

(defrule preg_Hardware
    (declare (salience 10))
    (Modulo ModPreg)
    ?f <- ( pregunta sobre hardware)
    =>
    (retract ?f)
    (printout t "¿Te gusta lo relacionado con el hardware? RESPUESTAS POSIBLES: (SI | NO | NS)" crlf)
    (assert (gusta hardware (upcase (read))))
)

;;; Mediante esta regla obtendremos respuesta a la pregunta de si le gusta 
;;; la programacion al estudiante o no (o no sé).

(defrule preg_Programar
    (declare (salience 7))
    (Modulo ModPreg)
    ?f <- (pregunta sobre programacion)
    =>
    (retract ?f)
    (printout t "¿Te gusta programar? RESPUESTAS POSIBLES: (SI | NO | NS)" crlf)
    (assert (gusta programacion (upcase (read))))
)

;;; ========= PREGUNTAS SOBRE PREFERENCIAS DEL ESTUDIANTE (NO SE RESPONDEN CON SI | NO | NS) =========== ;;;

;;; Mediante esta regla obtendremos respuesta a la pregunta de qué tipo de trabajo
;;; prefiere el estudiante.

(defrule preg_Trabajo
    (declare (salience 5))
    (Modulo ModPreg)
    ?f <- (pregunta sobre trabajo)
    =>
    (retract ?f)
    (printout t "¿De que te gustaria trabajar? RESPUESTAS POSIBLES: (Docencia | Empresa_publica | Empresa_privada | Igual | NS)" crlf)
    (assert (rTrabajo (upcase (read))))
)

;;; A diferencia de las preguntas con respuesta SI | NO | NS, para las de esta sección
;;; hemos de crear una regla que compruebe las respuestas de cada pregunta, pues las 
;;; posibles repsuestas varían de una a otra. 

(defrule respuestaTrabajo
    (declare (salience 999))
    (Modulo ModPreg)
    ?f <- (rTrabajo ?tr)
    (test
        (and
            (neq ?tr DOCENCIA)
            (and
                (neq ?tr EMPRESA_PUBLICA)
                (and
                    (neq ?tr EMPRESA_PRIVADA)
                    (and
                        (neq ?tr IGUAL)
                        (neq ?tr NS)
                    )
                )
            )
        )
    )
    =>
    (retract ?f)
    (printout t "Debe introducir una respuesta valida: (Docencia | Empresa_publica | Empresa_privada | Igual | NS): " crlf)
    (assert (pregunta sobre trabajo))
)

;;; Regla para comprobar si decide parar al perguntar sobre el trabajo

(defrule parar_pregunta_trabajo
    (declare (salience 9999))
    ?f <- (rTrabajo ?tr)
    (test (eq ?tr PARAR))
    =>
    (retract ?f)
    (printout t "Vale, no hare mas preguntas. ")
    (assert (rParar SI))
)

;;; Mediante esta regla obtendremos respuesta a la pregunta de qué nota media
;;; posee el estudiante.

(defrule preg_NotaMedia
    (declare (salience 6))
    (Modulo ModPreg)
    ?f <- (pregunta sobre nota)
    =>
    (retract ?f)
    (printout t "¿Cual es tu calificacion media? POSIBLES RESPUESTAS (Numero | Alta | Media | Baja | NS)" crlf)
    (assert (rNota (read)))
)

;;; Regla para comprobar si decide parar al perguntar sobre la nota media

(defrule parar_pregunta_nota
    (declare (salience 9999))
    ?f <- (rNota ?nota)
    (test (eq (type ?nota) SYMBOL))
    (test (eq (upcase ?nota) PARAR))
    =>
    (retract ?f)
    (printout t "Vale, no hare mas preguntas. ")
    (assert (rParar SI))
)

;;; A diferencia de las preguntas con respuesta SI | NO | NS, para las de esta sección
;;; hemos de crear una regla que compruebe las respuestas de cada pregunta, pues las 
;;; posibles repsuestas varían de una a otra. 

(defrule respuestaNota
    (declare (salience 999))
    (Modulo ModPreg)
    ?f <- (rNota ?nota)
    (test (eq (type ?nota) SYMBOL))
    (test 
        (and 
            (neq (upcase ?nota) ALTA) 
            (and
                (neq (upcase ?nota) MEDIA)
                (and
                    (neq (upcase ?nota) BAJA)
                    (neq (upcase ?nota) NS)
                )
            )
        )
    )
    =>
    (retract ?f)
    (printout t "Debe introducir una respuesta valida: (Numero | Alta | Media | Baja | NS):" ?nota  (type ?nota) crlf)
    (assert (pregunta nota))
)

;;; Mediante esta regla, pasaremos a mayusculas la respuesta sobre
;;; la pregunta de la nota media. Para ello, primero hemos de comprobar que
;;; la respuesta introducida es válida. 

(defrule ajustar_Mayusculas_Nota
    (declare (salience 998))
    (Modulo ModPreg)
    ?f <- (rNota ?nota)
    ; respuesta si es alta, media o baja
    (test (eq (type ?nota) SYMBOL))
    (test 
        (or 
            (eq (upcase ?nota) ALTA) 
            (or
                (eq (upcase ?nota) MEDIA)
                (or
                    (eq (upcase ?nota) BAJA)
                    (eq (upcase ?nota) NS)
                )
            )
        )
    )
    =>
    (assert (rNota (upcase ?nota) ))
)

;;; En el caso de que la respuesta introducida sea un número, 
;;; comprobamos si es válida. 
(defrule respuesta_Nota_Numerica
    (declare (salience 999))
    (Modulo ModPreg)
    ?f <- (rNota ?nota)
    (test 
        (or 
            (eq (type ?nota) INTEGER) 
            (eq (type ?nota) FLOAT)
        )
    )
    (test 
        (or
            (> ?nota 10.0) 
            (< ?nota 0.0)
        )
    )
    =>
    (retract ?f)
    (printout t "Si la respuesta es numerica, introduzca un numero del siguiente intervalo: [0, 10] " crlf)
    (assert (pregunta nota))
)

;;; A continuación, implementare reglas que me permitan distinguir el tipo de nota 
;;; media (Alta, Media, Baja), en funcion de una respuesta numerica. 
(defrule ajustar_Nota_Baja
    (declare (salience 998))
    (Modulo ModPreg)
    ?f <- (rNota ?nota)
    ; Solo si es un numero
    (test 
        (or 
            (eq (type ?nota) INTEGER) 
            (eq (type ?nota) FLOAT)
        )
    )
    (test 
        (and
            (> ?nota 0.0)
            (<= ?nota 6.0)
        )
    )
    =>
    (retract ?f)
    (assert (rNota BAJA))
)

(defrule ajustar_Nota_Media
    (declare (salience 998))
    (Modulo ModPreg)
    ?f <- (rNota ?nota)
    (test 
        (or 
            (eq (type ?nota) INTEGER) 
            (eq (type ?nota) FLOAT)
        )
    )
    (test 
        (and
            (> ?nota 6.0)
            (<= ?nota 8.0)
        )
    )
    =>
    (retract ?f)
    (assert (rNota MEDIA))
)

(defrule ajustar_Nota_Alta
    (declare (salience 998))
    (Modulo ModPreg)
    ?f <- (rNota ?nota)
    (test 
        (or 
            (eq (type ?nota) INTEGER) 
            (eq (type ?nota) FLOAT)
        )
    )
    (test 
        (and
            (> ?nota 8.0)
            (<= ?nota 10.0)
        )
    )
    =>
    (retract ?f)
    (assert (rNota ALTA))
)

;;; ¿ ESTUDIANTE TRABAJOR ? ;;;

;;; Mediante esta regla obtenemos la respuesta a la pregunta sobre cuanto 
;;; de trabajador se considera el estudiante. 

(defrule preg_Trabajador
    (declare (salience 8))
    (Modulo ModPreg)
    ?f <- (pregunta sobre trabajador)
    =>
    (retract ?f)
    (printout t "¿Te consideras trabajador? POSIBLES RESPUESTAS (Mucho | Normal | Poco | NS)" crlf)
    (assert (rTrabajador (upcase (read))))
)

;;; Regla para comprobar si decide parar al perguntar sobre la nota media

(defrule comprobarPararTrabajador
    (declare (salience 9999))
    ?f <- (rTrabajador ?tr)
    (test (eq ?tr PARAR))
    =>
    (retract ?f)
    (printout t "Vale, no hare mas preguntas. ")
    (assert (rParar SI))
)


;;; A diferencia de las preguntas con respuesta SI | NO | NS, para las de esta sección
;;; hemos de crear una regla que compruebe las respuestas de cada pregunta, pues las 
;;; posibles repsuestas varían de una a otra. 

(defrule respuestaTrabajador
    (declare (salience 999))
    (Modulo ModPreg)
    ?f <- (rTrabajador ?tr)
    (test
        (and
            (neq  ?tr MUCHO)
            (and
                (neq ?tr NORMAL)
                (and
                    (neq ?tr POCO)
                    (neq ?tr NS)
                )
            )
        )
    )
    =>
    (retract ?f)
    (printout t "Debe introducir una respuesta valida: (Mucho | Normal | Poco | NS):" crlf)
    (assert (pregunta sobre trabajador))
)

;;; ¿ QUE TIPO DE CLASES PREFIERE EL ESTUDIANTE ? ;;; 

;;; Mediante esta regla obtendremos respuesta a la pregunta sobre
;;; que tipo de clases prefiere el estudiante

(defrule pTipoClases
    (Modulo ModPreg)
    ?f <- (pregunta sobre tipoClases)
    =>
    (retract ?f)
    (printout t "¿Te gustan las clases teoricas o practicas? RESPUESTA POSIBLES (Teoricas | Practicas | NS)" crlf)
    (assert (rTipoClases (upcase (read))))
)

;;; Regla para comprobar si decide parar al perguntar sobre el tipo de clases

(defrule comprobarPararTipoClases
    (declare (salience 9999))
    ?r <- (rTipoClases ?tr)
    (test (eq ?tr PARAR))

    =>

    (retract ?r)
    (printout t "Vale, no te hare mas preguntas...")
    (assert (rParar SI))
)

;;; A diferencia de las preguntas con respuesta SI | NO | NS, para las de esta sección
;;; hemos de crear una regla que compruebe las respuestas de cada pregunta, pues las 
;;; posibles repsuestas varían de una a otra. 

(defrule respuestaTipoClases
    (declare (salience 999))
    (Modulo ModPreg)
    ?f <- (rTipoClases ?tc)
    (test
        (and
            (neq ?tc TEORICAS)
            (and
                (neq ?tc PRACTICAS)
                (neq ?tc NS)
            )
        )
    )
    =>
    (retract ?f)
    (printout t "Debe introducir una respuesta valida: (Teoricas | Practicas | NS):" crlf)
    (assert (pregunta sobre tipoClases))
)

;;; ================ TERMINA DE PREGUNTAR ============== ;;; 

;;; Mediante esta regla comprobaremos si no quedan mas
;;; preguntas por responder. 

(defrule no_quedan_pregs
    (declare (salience 100))
    ?f <- (Modulo ModPreg)
    (gusta matematicas ?r1)
    (gusta programacion ?r2)
    (gusta hardware ?r3)
    (rTrabajo ?r4)
    (rNota ?r5)
    (rTrabajador ?r6)
    (rTipoClases ?r7)
    =>
    (retract ?f)
    (focus ModuloCalcular)
    (assert (Modulo MCalcular))
)

;;; Mediante esta regla comprobamos si el usuario ha decidido
;;; parar las rpeguntas. 

(defrule preg_parar
    (declare (salience 9999))
    ?f <- (Modulo ModPreg)
    (rParar SI)
    =>
    (retract ?f)
    (focus ModuloCalcular)
    (assert (Modulo MCalcular))
)

;;; ========= CALCULO DE LA RAMA OPTATIVA MAS ACONSEJABLE ============ ;;;

(defmodule ModuloCalcular (export ?ALL) (import ModuloPreguntas ?ALL))

;;; RAMA CSI (COMPUTACION Y SISTEMAS INTELIGENTES) ;;;

;;; Mediante esta regla aconsejaremos la rama de CSI a aquellos estudiantes que: 
;;; 1º No les guste el hardware (O no lo saben). 
;;; 2º Les gusten las mates. 
;;; 3º Sean muy trabajadores

(defrule CSI_1
    (declare (salience 100))
    (Modulo MCalcular)
    (gusta hardware ?n)
    (test
        (or 
            (eq ?n NO)
            (eq ?n NS)
        )
    )
    (gusta matematicas SI)
    (rTrabajador MUCHO)
    =>
    (assert (Rama Computacion_y_Sistemas_Inteligentes))
    (assert (Consejo Computacion_y_Sistemas_Inteligentes "Esta rama esta muy relacionada con las matematicas. Esta enfocada en software, y requiere de mucho trabajo por parte del estudiante. Por tanto, considero que encajas a la perfeccion con el perfil de estudiante recomendado para esta rama." "FJGALLEGO"))
)

;;; Mediante esta regla aconsejaremos la rama de CSI a aquellos estudiantes que: 
;;; 1º No les guste el hardware. 
;;; 2º Les gusten las mates. 
;;; 3º Sean trabajadores 'normales'.
;;; 4º Les guste programar
;;; 5º Tengan una nota media ALTA | MEDIA

(defrule CSI_2
    (declare (salience 100))
    (Modulo MCalcular)
    (gusta hardware ?n)
    (test
        (or 
            (eq ?n NO)
            (eq ?n NS)
        )
    )
    (gusta matematicas SI)
    (rTrabajador NORMAL)
    (gusta programacion SI)
    (rNota ?n)
    (test
        (or 
            (eq ?n MEDIA)
            (eq ?n ALTA)
        )
    )
    =>
    (assert (Rama Computacion_y_Sistemas_Inteligentes))
    (assert (Consejo Computacion_y_Sistemas_Inteligentes "Esta rama esta muy relacionada con las matematicas. Esta enfocada en software, y requiere de mucho trabajo por parte del estudiante. Debido a tu gusto por las matematicas, que eres buen trabajador y sobre todo, por tus buenas notas, esta rama es la mas indicada." "FJGALLEGO"))
)

;;; RAMA IS (Ingeniera del Sotware) ;;;

;;; Mediante esta regla aconsejaremos la rama de IS a aquellos estudiantes que: 
;;; 1º No les guste el hardware. 
;;; 2º No le gustan las mates (O no lo saben). 
;;; 3º Quieren trabajar en la empresa PUBLICA | DOCENCIA | NS.
;;; 4º Son muy trabajadores

(defrule IS
    (declare (salience 100))
    (Modulo MCalcular)
    (gusta hardware ?n)
    (test
        (or 
            (eq ?n NO)
            (eq ?n NS)
        )
    )
    (gusta matematicas ?n)
    (test
        (or 
            (eq ?n NO)
            (eq ?n NS)
        )
    )
    (rTrabajo ?n)
    (test
        (or 
            (eq ?n DOCENCIA)
            (or
                (eq ?n EMPRESA_PUBLICA)
                (eq ?n NS)
            )            
        )
    )
    (rTrabajador MUCHO)    
    =>
    (assert (Rama Ingenieria_del_Software))
    (assert (Consejo Ingenieria_del_Software "Esta rama no esta muy relacionada con las matematicas. Asi mismo, requiere trabajo y puede estar relacionada con el tipo de trabajo que te gusta." "FJGALLEGO"))
)

;;; RAMA SI (SISTEMAS DE INFORMACION) ;;;

;;; Mediante esta regla aconsejaremos la rama de SI a aquellos estudiantes que: 
;;; 1º No les guste el hardware (O no lo saben). 
;;; 2º No le gustan las mates (O no lo saben). 
;;; 3º Quieren trabajar en la EMPRESA PRIVADA.

(defrule SI_1
    (declare (salience 100))
    (Modulo MCalcular)
    (gusta hardware ?n)
    (test
        (or 
            (eq ?n NO)
            (eq ?n NS)
        )
    )
    (gusta matematicas ?n)
    (test
        (or 
            (eq ?n NO)
            (eq ?n NS)
        )
    )
    (rTrabajo EMPRESA_PRIVADA)
    =>
    (assert (Rama Sistemas_de_Informacion))
    (assert (Consejo Sistemas_de_Informacion "Esta rama puede estar relacionada con el tipo de trabajo que buscas. Asi mismo, puesto que no has presentado un gran interes por las matematicas y el hardware, la veo como la ideal para ti." "FJGALLEGO"))
)

;;; Mediante esta regla aconsejaremos la rama de SI a aquellos estudiantes que: 
;;; 1º No les guste el hardware (O no lo saben). 
;;; 2º No le gustan las mates (O no lo saben). 
;;; 3º Quieren trabajar en la EMPRESA PRIVADA.
;;; 4º Poco trabajador

(defrule SI_2
    (declare (salience 100))
    (Modulo MCalcular)
    (gusta hardware ?n)
    (test
        (or 
            (eq ?n NO)
            (eq ?n NS)
        )
    )
    (gusta matematicas ?n)
    (test
        (or 
            (eq ?n NO)
            (eq ?n NS)
        )
    )
    (rTrabajo ?n)
    (test
        (or 
            (eq ?n DOCENCIA)
            (or
                (eq ?n EMPRESA_PUBLICA)
                (eq ?n NS)
            )            
        )
    )
    (rTrabajador ?n)
    (test
        (or 
            (eq ?n POCO)
            (eq ?n NS)
        )
    )
    =>
    (assert (Rama Sistemas_de_Informacion))
    (assert (Consejo Sistemas_de_Informacion "Esta rama puede estar relacionada con el tipo de trabajo que buscas. Asi mismo, puesto que no has presentado un gran interes por las matematicas y el hardware, y eres poco trabajador, la veo como la ideal para ti." "FJGALLEGO"))
)

;;; Mediante esta regla aconsejaremos la rama de SI a aquellos estudiantes que: 
;;; 1º No les guste el hardware (O no lo saben). 
;;; 2º Les gustan las mates 
;;; 3º Trabajador NORMAL
;;; 4º Le gusta programar
;;; 5º Nota Media BAJA (o no sabe)

(defrule SI_3
    (declare (salience 100))
    (Modulo MCalcular)
    (gusta hardware ?n)
    (test
        (or 
            (eq ?n NO)
            (eq ?n NS)
        )
    )
    (gusta matematicas SI)
    (rTrabajador NORMAL)
    (gusta programar SI)
    (rNota ?n)
    (test
        (or 
            (eq ?n BAJA)
            (eq ?n NS)
        )
    )
    =>
    (assert (Rama Sistemas_de_Informacion))
    (assert (Consejo Sistemas_de_Informacion "Esta rama esta relacionada con el software. Aunque tus notas no sean excelentes, como te gusta programar y eres algo trabajador, la considero la ideal." "FJGALLEGO"))
)

;;; Mediante esta regla aconsejaremos la rama de SI a aquellos estudiantes que: 
;;; 1º No les guste el hardware (O no lo saben). 
;;; 2º Les gustan las mates 
;;; 3º Trabajador NORMAL
;;; 4º NO les gusta programar (o no saben)

(defrule SI_4
    (declare (salience 100))
    (Modulo MCalcular)
    (gusta hardware ?n)
    (test
        (or 
            (eq ?n NO)
            (eq ?n NS)
        )
    )
    (gusta matematicas SI)
    (rTrabajador NORMAL)
    (gusta programar ?n)
    (test
        (or 
            (eq ?n NO)
            (eq ?n NS)
        )
    )
    =>
    (assert (Rama Sistemas_de_Informacion))
    (assert (Consejo Sistemas_de_Informacion "Debido a que eres algo trabajador, pese a que no te guste programar en exceso, recomiendo que la mejor rama es esta." "FJGALLEGO"))
)

;;; Mediante esta regla aconsejaremos la rama de SI a aquellos estudiantes que: 
;;; 1º No les guste el hardware (O no lo saben). 
;;; 2º Les gustan las mates 
;;; 3º Trabajador POCO | NS 

(defrule SI_5
    (declare (salience 100))
    (Modulo MCalcular)
    (gusta hardware ?n)
    (test
        (or 
            (eq ?n NO)
            (eq ?n NS)
        )
    )
    (gusta matematicas SI)
    (rTrabajador ?n)
    (test
        (or 
            (eq ?n POCO)
            (eq ?n NS)
        )
    )
    (rTrabajador POCO)
    =>
    (assert (Rama Sistemas_de_Informacion))
    (assert (Consejo Sistemas_de_Informacion "Puesto que eres poco trabajador y te gustan las mates y lo relacionado con el sotfware, recomiendo esta rama." "FJGALLEGO"))
)

;;; RAMA TI (Tecnologias de la informacion) ;;;

;;; Mediante esta regla aconsejaremos la rama de SI a aquellos estudiantes que: 
;;; 1º No les guste el hardware (O no lo saben). 
;;; 2º No le gustan las mates (O no lo saben). 
;;; 3º Quieren trabajar en la EMPRESA PRIVADA.
;;; 4º Trabajador NORMAL

(defrule TI
    (declare (salience 100))
    (Modulo MCalcular)
    (gusta hardware ?n)
    (test
        (or 
            (eq ?n NO)
            (eq ?n NS)
        )
    )
    (gusta matematicas ?n)
    (test
        (or 
            (eq ?n NO)
            (eq ?n NS)
        )
    )
    (rTrabajo ?n)
    (test
        (or 
            (eq ?n DOCENCIA)
            (or
                (eq ?n EMPRESA_PUBLICA)
                (eq ?n NS)
            )            
        )
    )
    (rTrabajador NORMAL)
    =>
    (assert (Rama Tecnologias_de_la_Informacion))
    (assert (Consejo Tecnologias_de_la_Informacion "Esta rama puede estar relacionada con el tipo de trabajo que buscas. Asi mismo, puesto que no has presentado un gran interes por las matematicas y el hardware, y eres poco trabajador, la veo como la ideal para ti." "FJGALLEGO"))
)

;;; RAMA IC (INGENIERIA DE COMPUTADORES) ;;; 

;;; Aconseja la rama IC por gustarle el hardware
(defrule IC
    (declare (salience 101))
    (Modulo MCalcular)
    (gusta hardware SI)
    =>
    (assert (Rama Ingenieria_de_Computadores))
    (assert (Consejo Ingenieria_de_Computadores "es la mejor opcion si te gusta el hardware." "FJGALLEGO"))    
)

;;; ========= REGLAS PARA CUANDO SE PARAN LAS PREGUNTAS ========== ;;; 

;;; Ninguna respuesta ;;;

(defrule ninguna_resp
    (declare (salience -50))
    (Modulo MCalcular)
    (rParar SI)   
    =>
    (assert (Rama Tecnologias_de_la_Informacion))
    (assert (Consejo Tecnologias_de_la_Informacion ", aunque no me hayas proporcionado demasiada informacion esta suele ser la opcion mas segura" "FJGALLEGO"))
)

;;; Solo 1 respuesta ;;;

(defrule solo_1_resp
    (declare (salience -49))
    (Modulo MCalcular)
    (gusta hardware ?n)
    (test
        (or 
            (eq ?n NO)
            (eq ?n NS)
        )
    )    
    (rParar SI)
    =>
    (assert (Rama Tecnologias_de_la_Informacion))
    (assert (Consejo Tecnologias_de_la_Informacion ", aunque no me hayas proporcionado demasiada informacion esta suele ser la opcion mas segura" "FJGALLEGO"))
)

;;; Solo 2 respuestas ;;;

(defrule solo_2_resp_matesSI
    (declare (salience -48))
    (Modulo MCalcular)
    (gusta hardware ?n)
    (test
        (or 
            (eq ?n NO)
            (eq ?n NS)
        )
    )    
    (gusta matematicas SI)
    (rParar SI)
    =>
    (assert (Rama Sistemas_de_Informacion))
    (assert (Consejo Sistemas_de_Informacion ", aunque no me hayas proporcionado demasiada informacion, puesto que te gustan las mates y no el hardware esta es la mejor opcion." "FJGALLEGO"))
)

(defrule solo_2_resp_matesNONS
    (declare (salience -48))
    (Modulo MCalcular)
    (gusta hardware ?n)
    (test
        (or 
            (eq ?n NO)
            (eq ?n NS)
        )
    )    
    (gusta matematicas ?n)
    (test
        (or 
            (eq ?n NO)
            (eq ?n NS)
        )
    )   
    (rParar SI)
    =>
    (assert (Rama Tecnologias_de_la_Informacion))
    (assert (Consejo Tecnologias_de_la_Informacion ", aunque no me hayas proporcionado demasiada informacion, puesto que no te gustan las mates ni el hardware, esta es la mas recomendada en mi opinion." "FJGALLEGO"))
)

;;; Solo 3 respuestas ;;;

(defrule solo_3_resp_Trabajo_NOPriv
    (declare (salience -47))
    (Modulo MCalcular)
    (gusta hardware ?n)
    (test
        (or 
            (eq ?n NO)
            (eq ?n NS)
        )
    )    
    (gusta matematicas ?n)
    (test
        (or 
            (eq ?n NO)
            (eq ?n NS)
        )
    )   
    (rTrabajo ?n)
    (test
        (or 
            (eq ?n DOCENCIA)
            (or
                (eq ?n EMPRESA_PUBLICA)
                (eq ?n NS)
            )            
        )
    )
    (rParar SI)
    =>
    (assert (Rama Tecnologias_de_la_Informacion))
    (assert (Consejo Tecnologias_de_la_Informacion "con todo lo que me has dicho, aunque no me hayas proporcionado toda la informacion, puesto que no te gustan las mates ni el hardware, y quizas esta mas relacionada con el trabajo que deseas, esta es tu rama." "FJGALLEGO"))
)

(defrule solo_3_resp_Trabajador_Normal
    (declare (salience -47))
    (Modulo MCalcular)
    (gusta hardware ?n)
    (test
        (or 
            (eq ?n NO)
            (eq ?n NS)
        )
    )    
    (gusta matematicas SI)
    (rTrabajador NORMAL)
    (rParar SI)
    =>
    (assert (Rama Sistemas_de_Informacion))
    (assert (Consejo Sistemas_de_Informacion "con todo lo que me has dicho, aunque no me hayas proporcionado toda la informacion, esta es la mejor rama para ti. Esto es porque es una rama relacionada con el software, donde se tiene que trabajar bastante (pero sin excederse) ." "FJGALLEGO"))
)

;;; Solo responde 4 preguntas ;;; 

(defrule solo_4_resp
    (declare (salience -46))
    (Modulo MCalcular)
    (gusta hardware ?n)
    (test
        (or 
            (eq ?n NO)
            (eq ?n NS)
        )
    )    
    (gusta matematicas SI)
    (rTrabajador NORMAL)
    (gusta programar SI)
    (rParar SI)
    =>
    (assert (Rama Computacion_y_Sistemas_Inteligentes))
    (assert (Consejo Computacion_y_Sistemas_Inteligentes "puesto que es una rama muy relacionada con las matematicas. Ademas, tiene muchas asignaturas con practicas de programacion y requiere de bastante trabajo." "FJGALLEGO"))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Fin de calcular la rama ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Terminar si ya se ha aconsejado
(defrule noHayMasCalculos
    (declare (salience 200))
    ?m <- (Modulo MCalcular)
    (Rama ?rama)
    (Consejo ?rama ?motivo ?experto)
    =>
    (retract ?m)
    (focus ModuloConsejo)
    (assert (Modulo MConsejo))
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; CONSEJO FINAL ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmodule ModuloConsejo (import ModuloCalcular ?ALL))

; Mediante esta regla se muestra el consejo final del experto. 
(defrule consejo_final
    (declare (salience 9999))
    (Modulo MConsejo)
    (Rama ?rama)
    (Consejo ?rama ?motivo ?experto)
    =>
    (printout t "El consejo del experto " ?experto " es que deberias escoger la rama " ?rama " porque " ?motivo crlf)
    (focus ModuloAsig)
)






;;;;;;;;;;;;;;;;;;;;;;;;; APARTADO B ;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmodule ModuloAsig (export ?ALL))

; Para esta parte se nos pide incluir al menos un tipo de razonamiento con incertidumbre. 
; Así mismo, el sistema debe ser capaz de justificar de forma clara al usuario el razonamiento
; que se ha seguido

; Asignaturas del Grado de Ing. Informática
(deffacts Asignaturas
    ; Asignaturas Basicas -> Primer Curso todas
    (Asignatura Basica FP "Fundamentos de programacion")
    (Asignatura Basica TOC "Tecnologia y organizacion de computadores")
    (Asignatura Basica CAL "Calculo")
    (Asignatura Basica ALEM "Algebra lineal y estructuras matematicas")
    (Asignatura Basica MP "Metodologia de la programacion")
    (Asignatura Basica FFT "Fundamentos fisicos y tecnologicos")
    (Asignatura Basica EST "Estadistica")
    (Asignatura Basica IES "Ingenieria, empresa y sociedad")
    (Asignatura Basica FS "Fundamentos del software")
    (Asignatura Basica LMD "Logica y metodos discretos")
    
    ; Asignaturas Obligatorias -> Segundo y tercer curso
    (Asignatura Obligatoria DDSI "Diseño y desarrollo de sistemas de informacion")
    (Asignatura Obligatoria PDOO "Programacion y diseño orientado a objetos")
    (Asignatura Obligatoria ISE "Ingenieria de servidores")
    (Asignatura Obligatoria SO "Sistemas operativos")
    (Asignatura Obligatoria SCD "Sistemas concurrentes y distribuidos")
    (Asignatura Obligatoria AC "Arquitectura de computadores")
    (Asignatura Obligatoria ED "Estructuras de datos")
    (Asignatura Obligatoria FBD "Fundamentos de bases de datos")
    (Asignatura Obligatoria FIS "Fundamentos de ingenieria del software")
    (Asignatura Obligatoria EC "Estructura de Computadores")
    (Asignatura Obligatoria FR "Fundamentos de redes")
    (Asignatura Obligatoria IG "Informatica grafica")
    (Asignatura Obligatoria IA "Inteligencia artificial")
    (Asignatura Obligatoria MC "Modelos de computacion")  
    (Asignatura Obligatoria ALG "Algoritmica")

    ; Asignaturas Optativas -> Tercer y cuarto Curso
    
    ; Rama Optativa de Ingeniería de Computadores
    (Asignatura Optativa AS "Arquitectura de sistemas")
    (Asignatura Optativa ACAP "Arquitectura y computacion de altas prestaciones")
    (Asignatura Optativa DHD "Desarrollo de hardware digital")
    (Asignatura Optativa DSE "Diseño de sistemas electronicos")
    (Asignatura Optativa SCM "Sistemas con microprocesadores")
    (Asignatura Optativa CPD "Centros de procesamiento de datos")
    (Asignatura Optativa SE "Sistemas empotrados")
    (Asignatura Optativa TR "Tecnologias de red")

    ; Rama Optativa de Sistemas de la Información
    (Asignatura Optativa ABD "Administracion de bases de datos")
    (Asignatura Optativa ISI "Ingenieria de sistemas de informacion")
    (Asignatura Optativa PW "Programacion web")
    (Asignatura Optativa SIE "Sistemas de informacion para empresas")
    (Asignatura Optativa SM "Sistemas multidimensionales")
    (Asignatura Optativa BDD "Bases de datos distribuidas")
    (Asignatura Optativa IN "Inteligencia de negocio")
    (Asignatura Optativa RI "Recuperacion de la informacion")

    ; Rama Optativa de Tecnologías de la Información
    (Asignatura Optativa CUIA "Computacion ubicua e inteligencia ambiental")
    (Asignatura Optativa SWAP "Servidores web de altas prestaciones")
    (Asignatura Optativa SMM "Sistemas multimedia")
    (Asignatura Optativa TW "Tecnologias web")
    (Asignatura Optativa TDRC "Transmision de datos y redes de computadores")
    (Asignatura Optativa DAI "Desarrollo de aplicaciones para internet")
    (Asignatura Optativa IV "Infraestructura virtual")
    (Asignatura Optativa SPSI "Seguridad y proteccion de sistemas informaticos")

    ; Rama Optativa de Ingeniería de Software
    (Asignatura Optativa DSD "Desarrollo de sistemas distribuidos")
    (Asignatura Optativa DS "Desarrollo de software")
    (Asignatura Optativa DIU "Diseño de interfaces de usuario")
    (Asignatura Optativa SIBW "Sistemas de informacion basados en web")
    (Asignatura Optativa SG "Sistemas graficos")
    (Asignatura Optativa DBA "Desarrollo basado en agentes")
    (Asignatura Optativa DGP "Direccion y gestion de proyectos")
    (Asignatura Optativa MDA "Metodologias de desarrollo agiles")

    ; Rama Optativa de Computacion y Sistemas Inteligentes
    (Asignatura Optativa AA "Aprendizaje automatico")
    (Asignatura Optativa IC "Ingenieria del conocimiento")
    (Asignatura Optativa MH "Metaheuristicas")
    (Asignatura Optativa MAC "Modelos avanzados de computacion")
    (Asignatura Optativa TSI "Tecnicas de los sistemas inteligentes")
    (Asignatura Optativa NPI "Nuevos paradigmas de interaccion")
    (Asignatura Optativa PL "Procesadores de lenguajes")
    (Asignatura Optativa VC "Vision por computador")    
)


(defrule comienzoApartadoB    
    (declare (salience 9999))    
    =>    
    (printout t crlf)
    (printout t crlf)
    (printout t crlf)
    (printout t "Vamos ahora con el APARTADO B). En este apartado tengo que recomendarte una asignatura." crlf)
    (printout t "Para ello, al igual que antes, te voy a realizar un par de preguntas." crlf)
    (printout t "Te recuerdo, si en algun momento no te apetece seguir respondiendo a mis preguntas, escribe PARAR." crlf)
    (focus ModuloPregAsig)
)

; A continuación vamos a realizar las preguntas por las posibles evidencias
(defmodule ModuloPregAsig (export ?ALL) (import ModuloAsig ?ALL))

; En primer lugar, añadimos la regla que nos permite preguntar que dos asignaturas desea escoger el usuario. 
(defrule preguntar_asignaturas
    (declare (salience 10000))
    (not (asignatura_1 ?x))
    (not (asignatura_2 ?y))
    =>
    (printout t crlf)
    (printout t crlf)
    (printout t "Elige cualesquiera dos asignaturas de las que te voy a mostrar a continuacion." crlf)
    (printout t "Asignaturas Basicas:                    ALEM, CAL, FS, FP, MP, TOC, FFT, EST, IES, LMD" crlf)
    (printout t "Asignaturas Obligatorias del 2o Curso:  ALG, ED, PDOO, IA, AC, FBD, FIS, SCD, SO, EC" crlf)
    (printout t "Asignaturas Obligatorias del 3er Curso: MC, IG, ISE, FR, DDSI" crlf)
    (printout t "Asignaturas de la rama de TI:           CUIA, SWAP, SMM, TW, TDRC, DAI, IV, SPSI" crlf)
    (printout t "Asignaturas de la rama de SI:           ABD, ISI, PW, SIE, SM, BDD, IN, RI" crlf)
    (printout t "Asignaturas de la rama de IC:           AS, ACAP, DHD, DSE, SCM, CPD, SE, TR" crlf)
    (printout t "Asignaturas de la rama de IS:           DSD, DS, DIU, SIBW, SG, DBA, DGP, MDA" crlf)
    (printout t "Asignaturas de la rama de CSI:          IC, MH, TSI, AA, VC, MAC, PL, NPI" crlf)
    (printout t "Es IMPORTANTE que dejes un espacio entre ambas (tecla ENTER)." crlf)

    (assert (asignatura_1 (upcase (read))))
    (assert (asignatura_2 (upcase (read))))
    (assert (eleccion_asignaturas))
)

; A continuación, añadimos una regla para comprobar que se han introducido las dos asignaturas correctamente. 
(defrule comprobar_entrada_asignaturas
    (declare (salience 10000))
    ?a <- (eleccion_asignaturas)
    ?b <- (asignatura_1 ?x)
    ?c <- (asignatura_2 ?y)
    (or (test (eq ?x ?y)) (or (not (Asignatura ? ?x ?)) (not (Asignatura ? ?y ?))))
    =>
    (retract ?a ?b ?c)
    (printout t "Debes introducir dos asignaturas de la lista mostrada." crlf)
    (printout t crlf)
)

; Por úlitmo, en el caso de que se hayan introducido correctamente las asignaturas, las asignamos.
(defrule asignar_asignaturas_correctas
    (declare (salience 10000))
    (asignatura_1 ?x)
    (asignatura_2 ?y)
    (Asignatura ?tipo1 ?x ?nombre_completo1)
    (Asignatura ?tipo2 ?y ?nombre_completo2)
    =>
    (assert (Asignatura_escogida ?tipo1 ?x ?nombre_completo1))
    (assert (Asignatura_escogida ?tipo2 ?y ?nombre_completo2))
    (assert (asignaturas escogidas correctamente))
)

; Para el razonamiento con incertudimbre, partiremos del ejercicio realizado sobre factores de certeza en la unidad 5. 

; En nuestro caso, las posibles evidencias que se pueden dar son las siguientes: 
;   1.- Al alumno si/no/ns le gustan las matematicas 
;   2.- Al alumno si/no/ns le gusta el hardware
;   3.- Al alumno si/no/ns le gusta programar
;   4.- La asignatura es optativa
;   5.- La asignatura es obligatoria
;   6.- La asignatura es basica
;   7.- El alumno (no) prefiere las clases teoricas
;   8.- El alumno si/no/ns le gustan las bases de datos y/o los SI

; A continuación añadimos las reglas necesarias para llevar a cabo el manejo de la incertidumbre
; mediante factores de certeza. Estas reglas han sido cogidas directamente del ejemplo proporcionado
; por el profesor. 

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

; Convertimos cada tipo de asignatura en una afirmacion sobre su factor de certeza
(defrule certeza_evidencias_asignatura_basica
    (declare (salience 1000))
    (Asignatura_escogida Basica ?a ?)
    =>
    (assert (FactorCerteza asignatura_basica si 1))
    (assert (FactorCerteza asignatura_obligatoria no 1))
    (assert (FactorCerteza asignatura_optativa no 1))
    (assert (Motivo FactorCerteza asignatura_basica si 1 "es una asignatura de tipo basica"))
)

(defrule certeza_evidencias_asignatura_obligatoria
    (declare (salience 1000))
    (Asignatura_escogida Obligatoria ?a ?)
    =>
    (assert (FactorCerteza asignatura_basica no 1))
    (assert (FactorCerteza asignatura_obligatoria si 1))
    (assert (FactorCerteza asignatura_optativa no 1))
    (assert (Motivo FactorCerteza asignatura_obligatoria si 1 "es una asignatura de tipo obligatoria"))
)

(defrule certeza_evidencias_asignatura_optativa
    (declare (salience 1000))
    (Asignatura_escogida Optativa ?a ?)
    =>
    (assert (FactorCerteza asignatura_basica no 1))
    (assert (FactorCerteza asignatura_obligatoria no 1))
    (assert (FactorCerteza asignatura_optativa si 1))
    (assert (Motivo FactorCerteza asignatura_optativa si 1 "es una asignatura de tipo optativa"))
)


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

;;; ================ PREGUNTAS SOBRE LAS POSIBLES EVIDENCIAS ================ ;;;

;;; PREGUNTAS
(deffacts Preguntas
    (pregunta sobre matematicas)
    (pregunta sobre hardware)
    (pregunta sobre programacion)
    (pregunta sobre teoria)
    (pregunta sobre bases_datos)
)

;;; Con esta regla, comprobaremos si el usuario decide parar las preguntas. 
(defrule parar_preguntas_asignaturas
    (declare (salience 10000))
    ?f <- (Evidencia ?e ?respuesta)
    (test (eq ?respuesta PARAR))
    =>
    (retract ?f)
    (printout t "Vale, no hare mas preguntas. ")
    (assert (rParar SI))
)

;;; Mediante esta regla comprobaremos que las preguntas que tienen como respuesta
;;; SI | NO | NS, reciben una respuesta válida. En caso contrario, se le indica al
;;; usuario que introduzca de nuevo la respuesta. 

(defrule comprobar_respuesta_asignaturas
    (declare (salience 10000))
    ?f <- (Evidencia ?e ?respuesta)
    (test
        (and
            (neq ?respuesta SI)
            (and
                (neq ?respuesta NO)
                (neq ?respuesta NS) 
            )
        )        
    )
    =>
    (printout t "Debe introducir una respuesta valida: SI | NO | NS: " crlf)
    (retract ?f)
    (assert (pregunta sobre ?e))
)

(defrule preguntar_evidencia_matematicas
    (declare (salience 500))
    (not (rParar SI))
    (not (Evidencia matematicas ?a))
    (asignaturas escogidas correctamente)
    ?x <- (pregunta sobre matematicas)
    =>
    (retract ?x)
    (printout t "¿Te gustan las matematicas? RESPUESTAS POSIBLES: (SI | NO | NS)" crlf)
    (assert (Evidencia matematicas (upcase (read))))
)

(defrule preguntar_evidencia_hardware
    (declare (salience 500))
    (not (rParar SI))
    (not (Evidencia hardware ?a))
    (asignaturas escogidas correctamente)
    ?x <- (pregunta sobre hardware)
    =>
    (retract ?x)
    (printout t "¿Te gusta el hardware? RESPUESTAS POSIBLES: (SI | NO | NS)" crlf)
    (assert (Evidencia hardware (upcase (read))))
)

(defrule preguntar_evidencia_programacion
    (declare (salience 500))
    (not (rParar SI))
    (not (Evidencia programacion ?a))
    (asignaturas escogidas correctamente)
    ?x <- (pregunta sobre programacion)
    =>
    (retract ?x)
    (printout t "¿Te gusta la programación? RESPUESTAS POSIBLES: (SI | NO | NS)" crlf)
    (assert (Evidencia programacion (upcase (read))))
) 

(defrule preguntar_evidencia_teoria
    (declare (salience 500))
    (not (rParar SI))
    (not (Evidencia teoria ?a))
    (asignaturas escogidas correctamente)
    ?x <- (pregunta sobre teoria)
    =>
    (retract ?x)
    (printout t "¿Te gusta que la asignatura sea mas teorica? RESPUESTAS POSIBLES: (SI | NO | NS)" crlf)
    (assert (Evidencia teoria (upcase (read))))
)

(defrule preguntar_evidencia_bd
    (declare (salience 500))
    (not (rParar SI))
    (not (Evidencia bases_datos ?a))
    (asignaturas escogidas correctamente)
    ?x <- (pregunta sobre bases_datos)
    =>
    (retract ?x)
    (printout t "¿Te gustan las bases de datos y/o los sistemas de informacion? RESPUESTAS POSIBLES: (SI | NO | NS)" crlf)
    (assert (Evidencia bases_datos (upcase (read))))
)

;;; ================ TERMINA DE PREGUNTAR ============== ;;; 

;;; Mediante esta regla comprobaremos si no quedan mas
;;; preguntas por responder. 

(defrule no_quedan_pregs
    (declare (salience 100))
    (Evidencia programacion ?a)
    (Evidencia matematicas ?b)
    (Evidencia hardware ?c)
    (Evidencia teoria ?d)
    (Evidencia bases_datos ?e)
    =>
    (focus ModuloCalcAsig)
)

;;; Mediante esta regla comprobamos si el usuario ha decidido
;;; parar las rpeguntas. 

(defrule preg_parar
    (declare (salience 10000))
    (rParar SI)
    =>
    (focus ModuloCalcAsig)
)

;;; ================ CALCULAMOS LA ASIGNATURA A ESCOGER ================ ;;;

(defmodule ModuloCalcAsig (export ?ALL) (import ModuloPregAsig ?ALL))

; 1er Tipo de Reglas: las dos asignaturas elegidas poseen tipos distintos. 
; En dicho caso, las básicas tienen mayor preferencia y después las obligatorias. 

; R1: Si solo una de las asignaturas elegidas es básica, entonces escogemos esa
;     independientemente del tipo de la otra. 
(defrule R1    
    (Asignatura_escogida Basica ?x ?nombre)
    (Asignatura_escogida ?tipo2 ?y ?nombr2)
    (test (neq ?tipo2 Basica))
    (FactorCerteza asignatura_basica si 1)
    (FactorCerteza asignatura_basica no 1)
    =>
    (assert (FactorCerteza ?nombre si (encadenado 1 0.95)))
    (assert (Motivo FactorCerteza ?nombre si (encadenado 1 0.95) "es una asignatura de tipo Basica"))
)

; R2: En caso de haber elegido una asignatura obligatoria y una optativa, recomendamos la obligatoria. 
(defrule R2    
    (Asignatura_escogida Obligatoria ?x ?nombre)
    (Asignatura_escogida Optativa ?y ?nombre2)
    (FactorCerteza asignatura_obligatoria si 1)
    (FactorCerteza asignatura_optativa si 1)
    =>
    (assert (FactorCerteza ?nombre si (encadenado 1 0.9)))
    (assert (Motivo FactorCerteza ?nombre si (encadenado 1 0.9) "es una asignatura de tipo Obligatoria"))
)

;;; ====== REGLAS RELACIONADAS CON EL GUSTO POR LAS MATEMATICAS ====== ;;;;

; R3: En el caso de que una de las asignaturas este relacionada con las mates
;     y el usuario haya respondido que le gustan las mates -> escogemos la asignatura
;     relacionada con las matematicas 

(defrule R3
    (FactorCerteza matematicas SI ?f)
    (Asignatura_escogida ?tipo ALEM|CAL|EST|LMD|AA|VC|MH|MAC|SG|NPI|PL|SPSI|ISI ?nombre)
    (Asignatura_escogida ?tipo2 ?y ?nombre2)
    (test (neq ?y ALEM))
    (test (neq ?y CAL))
    (test (neq ?y EST))
    (test (neq ?y LMD))
    (test (neq ?y AA))
    (test (neq ?y VC))
    (test (neq ?y MAC))
    (test (neq ?y MH))
    (test (neq ?y SG))
    (test (neq ?y NPI))
    (test (neq ?y PL))
    (test (neq ?y SPSI))
    (test (neq ?y ISI))
    
    =>
    (assert (FactorCerteza ?nombre si (encadenado ?f 0.75)))
    (assert (Motivo FactorCerteza ?nombre si (encadenado ?f 0.75) "te gustan las matematicas"))
)

; R4: En el caso de que una de las asignaturas este relacionada con las mates
;     y el usuario haya respondido que no le gustan las mates -> escogemos la asignatura
;     que no este relacionada con las matematicas 

(defrule R4
    (FactorCerteza matematicas NO ?f)
    (Asignatura_escogida ?tipo ALEM|CAL|EST|LMD|AA|VC|MH|MAC ?nombre)
    (Asignatura_escogida ?tipo2 ?y ?nombre2)
    (test (neq ?y ALEM))
    (test (neq ?y CAL))
    (test (neq ?y EST))
    (test (neq ?y LMD))
    (test (neq ?y AA))
    (test (neq ?y VC))
    (test (neq ?y MAC))
    (test (neq ?y MH))
    (test (neq ?y SG))
    (test (neq ?y NPI))
    (test (neq ?y PL))
    (test (neq ?y SPSI))
    (test (neq ?y ISI))
    =>
    (assert (FactorCerteza ?nombre2 si (encadenado ?f 0.85)))
    (assert (Motivo FactorCerteza ?nombre2 si (encadenado ?f 0.85) "no te gustan las matematicas"))
)

; R4: En el caso de que una de las asignaturas este relacionada con las mates
;     y el usuario haya respondido NS si le gustan las mates -> escogemos la asignatura
;     que no este relacionada con las matematicas

(defrule R5
    (FactorCerteza matematicas NS ?f)
    (Asignatura_escogida ?tipo ALEM|CAL|EST|LMD|AA|VC|MH|MAC ?nombre)
    (Asignatura_escogida ?tipo2 ?y ?nombre2)
    (test (neq ?y ALEM))
    (test (neq ?y CAL))
    (test (neq ?y EST))
    (test (neq ?y LMD))
    (test (neq ?y AA))
    (test (neq ?y VC))
    (test (neq ?y MAC))
    (test (neq ?y MH))
    (test (neq ?y SG))
    (test (neq ?y NPI))
    (test (neq ?y PL))
    (test (neq ?y SPSI))
    (test (neq ?y ISI))
    =>
    (assert (FactorCerteza ?nombre2 si 0.55))
    (assert (Motivo FactorCerteza ?nombre2 si 0.55 "no sabes si te gustan las matematicas"))
)

; R4: En el caso de que una de las asignaturas este relacionada con las mates
;     y el usuario ni siquiera haya respondido si le gustan las mates -> escogemos la asignatura
;     que no este relacionada con las matematicas

(defrule R6
    (not (Evidencia matematicas ?a))
    (Asignatura_escogida ?tipo ALEM|CAL|EST|LMD|AA|VC|MH|MAC ?nombre)
    (Asignatura_escogida ?tipo2 ?y ?nombre2)
    (test (neq ?y ALEM))
    (test (neq ?y CAL))
    (test (neq ?y EST))
    (test (neq ?y LMD))
    (test (neq ?y AA))
    (test (neq ?y VC))
    (test (neq ?y MAC))
    (test (neq ?y MH))
    (test (neq ?y SG))
    (test (neq ?y NPI))
    (test (neq ?y PL))
    (test (neq ?y SPSI))
    (test (neq ?y ISI))
    =>
    (assert (FactorCerteza ?nombre2 si 0.5))
    (assert (Motivo FactorCerteza ?nombre2 si 0.5 ", al no haberme respondido sobre tus gustos por las mates, no se si te gustan o no"))
)

;;; ====== REGLAS RELACIONADAS CON EL GUSTO POR LA PROGRAMACION ====== ;;;;

; R7: En el caso de que una de las asignaturas este relacionada con la programacion
;     y el usuario haya respondido que le gustan la programacion -> escogemos la asignatura
;     relacionada con la programacion 

(defrule R7
    (FactorCerteza programacion SI ?f)
    (Asignatura_escogida ?tipo MP|FP|ED|PDOO|IA|ALG|IG|PW|MH|TSI|AA|VC|DDSI|DAI|DIU ?nombre)
    (Asignatura_escogida ?tipo2 ?y ?nombre2)
    (test (neq ?y MP))
    (test (neq ?y FP))
    (test (neq ?y PDOO))
    (test (neq ?y IA))
    (test (neq ?y ALG))
    (test (neq ?y IG))
    (test (neq ?y PW))
    (test (neq ?y MH))
    (test (neq ?y TSI))
    (test (neq ?y AA))
    (test (neq ?y VC))
    (test (neq ?y DDSI))
    (test (neq ?y DAI))
    (test (neq ?y DIU))
    =>
    (assert (FactorCerteza ?nombre si (encadenado ?f 0.775)))
    (assert (Motivo FactorCerteza ?nombre si (encadenado ?f 0.775) "te gustA la programacion"))
)

; R8: En el caso de que una de las asignaturas este relacionada con la programacion
;     y el usuario haya respondido que no le gustan la programacion -> escogemos la asignatura
;     que no este relacionada con programar 

(defrule R8
    (FactorCerteza programacion NO ?f)
    (Asignatura_escogida ?tipo MP|FP|ED|PDOO|IA|ALG|IG|PW|MH|TSI|AA|VC|DDSI|DAI|DIU ?nombre)
    (Asignatura_escogida ?tipo2 ?y ?nombre2)
    (test (neq ?y MP))
    (test (neq ?y FP))
    (test (neq ?y PDOO))
    (test (neq ?y IA))
    (test (neq ?y ALG))
    (test (neq ?y IG))
    (test (neq ?y PW))
    (test (neq ?y MH))
    (test (neq ?y TSI))
    (test (neq ?y AA))
    (test (neq ?y VC))
    (test (neq ?y DDSI))
    (test (neq ?y DAI))
    (test (neq ?y DIU))
    =>
    (assert (FactorCerteza ?nombre2 si (encadenado ?f 0.835)))
    (assert (Motivo FactorCerteza ?nombre2 si (encadenado ?f 0.835) "no te gusta programar"))
)

; R9: En el caso de que una de las asignaturas este relacionada con la programacion
;     y el usuario haya respondido NS si le gustaprogramar -> escogemos la asignatura
;     que no este relacionada con programar

(defrule R9
    (FactorCerteza programacion NS ?f)
    (Asignatura_escogida ?tipo MP|FP|ED|PDOO|IA|ALG|IG|PW|MH|TSI|AA|VC|DDSI|DAI|DIU ?nombre)
    (Asignatura_escogida ?tipo2 ?y ?nombre2)
    (test (neq ?y MP))
    (test (neq ?y FP))
    (test (neq ?y PDOO))
    (test (neq ?y IA))
    (test (neq ?y ALG))
    (test (neq ?y IG))
    (test (neq ?y PW))
    (test (neq ?y MH))
    (test (neq ?y TSI))
    (test (neq ?y AA))
    (test (neq ?y VC))
    (test (neq ?y DDSI))
    (test (neq ?y DAI))
    (test (neq ?y DIU))
    =>
    (assert (FactorCerteza ?nombre2 si 0.525))
    (assert (Motivo FactorCerteza ?nombre2 si 0.525 "no sabes si te gusta programar"))
)

; R10: En el caso de que una de las asignaturas este relacionada con la programacion
;     y el usuario ni siquiera haya respondido si le gusta programar -> escogemos la asignatura
;     que no este relacionada con programar

(defrule R10
    (not (Evidencia programacion ?a))
    (Asignatura_escogida ?tipo MP|FP|ED|PDOO|IA|ALG|IG|PW|MH|TSI|AA|VC|DDSI|DAI|DIU ?nombre)
    (Asignatura_escogida ?tipo2 ?y ?nombre2)
    (test (neq ?y MP))
    (test (neq ?y FP))
    (test (neq ?y PDOO))
    (test (neq ?y IA))
    (test (neq ?y ALG))
    (test (neq ?y IG))
    (test (neq ?y PW))
    (test (neq ?y MH))
    (test (neq ?y TSI))
    (test (neq ?y AA))
    (test (neq ?y VC))
    (test (neq ?y DDSI))
    (test (neq ?y DAI))
    (test (neq ?y DIU))
    =>
    (assert (FactorCerteza ?nombre2 si 0.5))
    (assert (Motivo FactorCerteza ?nombre2 si 0.5 ", al no haberme respondido sobre tus gustos por la programacion, no se si te gusta programar o no"))
)

;;; ====== REGLAS RELACIONADAS CON EL GUSTO POR EL HARDWARE ====== ;;;;

; R11: En el caso de que una de las asignaturas este relacionada con el hardware
;     y el usuario haya respondido que le gustan la hardware -> escogemos la asignatura
;     relacionada con el hardware 

(defrule R11
    (FactorCerteza hardware SI ?f)
    (Asignatura_escogida ?tipo AC|EC|TOC|AS|ACAP|DHD|DSE|SCM|CPD|SE|TR ?nombre)
    (Asignatura_escogida ?tipo2 ?y ?nombre2)
    (test (neq ?y AC))
    (test (neq ?y EC))
    (test (neq ?y TOC))
    (test (neq ?y AS))
    (test (neq ?y ACAP))
    (test (neq ?y DHD))
    (test (neq ?y DSE))
    (test (neq ?y SCM))
    (test (neq ?y CPD))
    (test (neq ?y SE))
    (test (neq ?y TR))
    =>
    (assert (FactorCerteza ?nombre si (encadenado ?f 0.7675)))
    (assert (Motivo FactorCerteza ?nombre si (encadenado ?f 0.7675) "te gustA el hardware"))
)

; R12: En el caso de que una de las asignaturas este relacionada con el hardware
;     y el usuario haya respondido que no le gustael hardware -> escogemos la asignatura
;     que no este relacionada con el hardware 

(defrule R12
    (FactorCerteza hardware NO ?f)
    (Asignatura_escogida ?tipo AC|EC|TOC|AS|ACAP|DHD|DSE|SCM|CPD|SE|TR ?nombre)
    (Asignatura_escogida ?tipo2 ?y ?nombre2)
    (test (neq ?y AC))
    (test (neq ?y EC))
    (test (neq ?y TOC))
    (test (neq ?y AS))
    (test (neq ?y ACAP))
    (test (neq ?y DHD))
    (test (neq ?y DSE))
    (test (neq ?y SCM))
    (test (neq ?y CPD))
    (test (neq ?y SE))
    (test (neq ?y TR))
    =>
    (assert (FactorCerteza ?nombre2 si (encadenado ?f 0.8835)))
    (assert (Motivo FactorCerteza ?nombre2 si (encadenado ?f 0.8835) "no te gusta el hardware"))
)

; R13: En el caso de que una de las asignaturas este relacionada con el hardware
;     y el usuario haya respondido NS si le gusta el hardware -> escogemos la asignatura
;     que no este relacionada con el hardware

(defrule R13
    (FactorCerteza hardware NS ?f)
    (Asignatura_escogida ?tipo AC|EC|TOC|AS|ACAP|DHD|DSE|SCM|CPD|SE|TR ?nombre)
    (Asignatura_escogida ?tipo2 ?y ?nombre2)
    (test (neq ?y AC))
    (test (neq ?y EC))
    (test (neq ?y TOC))
    (test (neq ?y AS))
    (test (neq ?y ACAP))
    (test (neq ?y DHD))
    (test (neq ?y DSE))
    (test (neq ?y SCM))
    (test (neq ?y CPD))
    (test (neq ?y SE))
    (test (neq ?y TR))
    =>
    (assert (FactorCerteza ?nombre2 si 0.5925))
    (assert (Motivo FactorCerteza ?nombre2 si 0.5925 "no sabes si te gusta el hardware"))
)

; R14: En el caso de que una de las asignaturas este relacionada con el hardware
;     y el usuario ni siquiera haya respondido si le gusta el hardware -> escogemos la asignatura
;     que no este relacionada con el hardware

(defrule R14
    (not (Evidencia hardware ?a))
    (Asignatura_escogida ?tipo AC|EC|TOC|AS|ACAP|DHD|DSE|SCM|CPD|SE|TR ?nombre)
    (Asignatura_escogida ?tipo2 ?y ?nombre2)
    (test (neq ?y AC))
    (test (neq ?y EC))
    (test (neq ?y TOC))
    (test (neq ?y AS))
    (test (neq ?y ACAP))
    (test (neq ?y DHD))
    (test (neq ?y DSE))
    (test (neq ?y SCM))
    (test (neq ?y CPD))
    (test (neq ?y SE))
    (test (neq ?y TR))
    =>
    (assert (FactorCerteza ?nombre2 si 0.51))
    (assert (Motivo FactorCerteza ?nombre2 si 0.51 ", al no haberme respondido sobre tus gustos por el hardware, no se si te gusta o no"))
)

;;; ====== REGLAS RELACIONADAS CON LAS ASIGNATURAS TEORICAS ====== ;;;;

; R15: En el caso de que el alumno haya contestado que prefiere las asignaturas teoricas,
;      y de que una de las asignaturas escogidas sea bastante teorica -> la escogemos
(defrule R15
    (FactorCerteza teoria SI ?f)
    (Asignatura_escogida ?tipo AC|TOC|LMD|FFT|CAL|EC|SO|FR|MC|ALG ?nombre)
    (Asignatura_escogida ?tipo2 ?y ?nombre2)
    (test (neq ?y AC))
    (test (neq ?y EC))
    (test (neq ?y TOC))
    (test (neq ?y LMD))
    (test (neq ?y FFT))
    (test (neq ?y CAL))
    (test (neq ?y DSE))
    (test (neq ?y SO))
    (test (neq ?y MC))
    (test (neq ?y FR))
    (test (neq ?y ALG))
    =>
    (assert (FactorCerteza ?nombre si (encadenado ?f 0.435)))
    (assert (Motivo FactorCerteza ?nombre si (encadenado ?f 0.435) "prefieres las asignaturas mas teoricas"))
)

; R16: En el caso de que el alumno haya contestado que no prefiere las asignaturas teoricas,
;      y de que una de las asignaturas escogidas sea bastante teorica -> escogemos la otra 
(defrule R16
    (FactorCerteza teoria NO ?f)
    (Asignatura_escogida ?tipo AC|TOC|LMD|FFT|CAL|EC|SO|FR|MC|ALG ?nombre)
    (Asignatura_escogida ?tipo2 ?y ?nombre2)
    (test (neq ?y AC))
    (test (neq ?y EC))
    (test (neq ?y TOC))
    (test (neq ?y LMD))
    (test (neq ?y FFT))
    (test (neq ?y CAL))
    (test (neq ?y DSE))
    (test (neq ?y SO))
    (test (neq ?y MC))
    (test (neq ?y FR))
    (test (neq ?y ALG))
    =>
    (assert (FactorCerteza ?nombre2 si (encadenado ?f 0.35)))
    (assert (Motivo FactorCerteza ?nombre2 si (encadenado ?f 0.35) "prefieres las asignaturas menos teoricas"))
)

; R17: En el caso de que el alumno haya contestado que no sabe si prefiere las asignaturas teoricas,
;      y de que una de las asignaturas escogidas sea bastante teorica -> escogemos la otra 
(defrule R17
    (FactorCerteza teoria NS ?f)
    (Asignatura_escogida ?tipo AC|TOC|LMD|FFT|CAL|EC|SO|FR|MC|ALG ?nombre)
    (Asignatura_escogida ?tipo2 ?y ?nombre2)
    (test (neq ?y AC))
    (test (neq ?y EC))
    (test (neq ?y TOC))
    (test (neq ?y LMD))
    (test (neq ?y FFT))
    (test (neq ?y CAL))
    (test (neq ?y DSE))
    (test (neq ?y SO))
    (test (neq ?y MC))
    (test (neq ?y FR))
    (test (neq ?y ALG))
    =>
    (assert (FactorCerteza ?nombre2 si (encadenado ?f 0.25)))
    (assert (Motivo FactorCerteza ?nombre2 si (encadenado ?f 0.25) "no sabes si prefieres las asignaturas mas o menos teoricas"))
)

; R18: En el caso de que el alumno no haya contestado si prefiere las asignaturas teoricas,
;      y de que una de las asignaturas escogidas sea bastante teorica -> escogemos la otra 
(defrule R18
    (not (Evidencia teoria ?a))
    (Asignatura_escogida ?tipo AC|TOC|LMD|FFT|CAL|EC|SO|FR|MC|ALG ?nombre)
    (Asignatura_escogida ?tipo2 ?y ?nombre2)
    (test (neq ?y AC))
    (test (neq ?y EC))
    (test (neq ?y TOC))
    (test (neq ?y LMD))
    (test (neq ?y FFT))
    (test (neq ?y CAL))
    (test (neq ?y DSE))
    (test (neq ?y SO))
    (test (neq ?y MC))
    (test (neq ?y FR))
    (test (neq ?y ALG))
    =>
    (assert (FactorCerteza ?nombre2 si 0.45))
    (assert (Motivo FactorCerteza ?nombre2 si 0.45 ", al no haberme contestado, no se si prefieres las asignaturas mas o menos teoricas"))
)

;;; ====== REGLAS RELACIONADAS CON LAS BASES DE DATOS Y LOS SI ====== ;;;;

; R19: En el caso de que el alumno haya contestado que le gustan las bases de datos,
;      y de que una de las asignaturas este relacionada -> la escogemos
(defrule R19
    (FactorCerteza bases_datos SI ?f)
    (Asignatura_escogida ?tipo FBD|ABD|ISI|SIE|SM|BDD|IN|RI ?nombre)
    (Asignatura_escogida ?tipo2 ?y ?nombre2)
    (test (neq ?y FBD))
    (test (neq ?y ABD))
    (test (neq ?y ISI))
    (test (neq ?y SIE))
    (test (neq ?y SM))
    (test (neq ?y BDD))
    (test (neq ?y IN))
    (test (neq ?y RI))
    =>
    (assert (FactorCerteza ?nombre si (encadenado ?f 0.33)))
    (assert (Motivo FactorCerteza ?nombre si (encadenado ?f 0.33) "te gustan las bases de datos y los SI."))
)

; R16: En el caso de que el alumno haya contestado que no le gustan las BD,
;      y de que una de las asignaturas escogidas este relacionada -> escogemos la otra 
(defrule R20
    (FactorCerteza bases_datos NO ?f)
    (Asignatura_escogida ?tipo FBD|ABD|ISI|SIE|SM|BDD|IN|RI ?nombre)
    (Asignatura_escogida ?tipo2 ?y ?nombre2)
    (test (neq ?y FBD))
    (test (neq ?y ABD))
    (test (neq ?y ISI))
    (test (neq ?y SIE))
    (test (neq ?y SM))
    (test (neq ?y BDD))
    (test (neq ?y IN))
    (test (neq ?y RI))
    =>
    (assert (FactorCerteza ?nombre2 si (encadenado ?f 0.375)))
    (assert (Motivo FactorCerteza ?nombre2 si (encadenado ?f 0.375) "no te gustan las bases de datos y los sistemas de informacion."))
)

; R17: En el caso de que el alumno haya contestado que no sabe si prefiere las asignaturas teoricas,
;      y de que una de las asignaturas escogidas sea bastante teorica -> escogemos la otra 
(defrule R21
    (FactorCerteza bases_datos NS ?f)
    (Asignatura_escogida ?tipo FBD|ABD|ISI|SIE|SM|BDD|IN|RI ?nombre)
    (Asignatura_escogida ?tipo2 ?y ?nombre2)
    (test (neq ?y FBD))
    (test (neq ?y ABD))
    (test (neq ?y ISI))
    (test (neq ?y SIE))
    (test (neq ?y SM))
    (test (neq ?y BDD))
    (test (neq ?y IN))
    (test (neq ?y RI))
    =>
    (assert (FactorCerteza ?nombre2 si (encadenado ?f 0.285)))
    (assert (Motivo FactorCerteza ?nombre2 si (encadenado ?f 0.285) "no sabes si te gustan o no las BD"))
)

; R18: En el caso de que el alumno no haya contestado si prefiere las asignaturas teoricas,
;      y de que una de las asignaturas escogidas sea bastante teorica -> escogemos la otra 
(defrule R22
    (not (Evidencia bases_datos ?a))
    (Asignatura_escogida ?tipo FBD|ABD|ISI|SIE|SM|BDD|IN|RI ?nombre)
    (Asignatura_escogida ?tipo2 ?y ?nombre2)
    (test (neq ?y FBD))
    (test (neq ?y ABD))
    (test (neq ?y ISI))
    (test (neq ?y SIE))
    (test (neq ?y SM))
    (test (neq ?y BDD))
    (test (neq ?y IN))
    (test (neq ?y RI))
    =>
    (assert (FactorCerteza ?nombre2 si 0.4755))
    (assert (Motivo FactorCerteza ?nombre2 si 0.4755 ", al no haberme contestado, no se si te gustan o no las BD"))
)



;;; Las siguientes reglas han sido cogidas directamente del ejercicio de factores de certeza
;;; entregado para la unidad 5.

;;; Tras razonar nos quedamos con la hipótesis que mayor certeza tenga ;;;
(defrule hipotesis_mayor_certeza
    ; Metemos esta prioridad para que nos salgan todas las respuestas al final juntas
    (declare (salience -5))
    (FactorCerteza ?h1 ?resp1 ?f1)
    ?f <- (FactorCerteza ?h2 ?resp2 ?f2)
    (Motivo FactorCerteza ?h2 ?resp2 ?f2 ?expl)
    (test(and (> ?f1 ?f2) (< ?f1 1)))
    =>
    (printout t "Borramos que " ?resp2 " ocurra que " ?h2 " ( debido a que " ?expl " ) porque tiene menor certeza (" ?f2 ")" crlf)
    (retract ?f)
)

; Una vez no hya mas calculos, terminar
(defrule fin_calculos
    (declare (salience -10))
    (FactorCerteza ?h1 ?r1 ?f1)
    (Motivo FactorCerteza ?h1 ?r1 ?f1 ?expl1)
    =>
    (focus ModuloConsAsig)
)

(defmodule ModuloConsAsig (import ModuloCalcAsig ?ALL))

;;; Deducciones ;;;
(defrule deducciones
    ; Metemos esta prioridad para que nos salgan todas las respuestas al final juntas
    (declare (salience -10))
    ?g <- (Motivo FactorCerteza ?h ?r ?f1 ?expl)    
    ?f <- (FactorCerteza ?h ?r ?f1)
    =>
    (printout t "El factor deducido es que " ?r " ocurre que " ?h " con certeza " ?f1 " porque " ?expl crlf)
    (retract ?f ?g)
)