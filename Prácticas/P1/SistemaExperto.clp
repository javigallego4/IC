;;; FRANCISCO JAVIER GALLEGO MENOR, GRUPO 2 ;;;

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

; Mostrar el consejo final
(defrule fin
    (declare (salience 9999))
    (Modulo MConsejo)
    (Rama ?rama)
    (Consejo ?rama ?motivo ?experto)
    =>
    (printout t "El consejo del experto " ?experto " es que deberias escoger la rama " ?rama " porque " ?motivo crlf)
)