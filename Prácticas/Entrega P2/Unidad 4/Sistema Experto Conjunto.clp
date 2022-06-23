;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                      ;;
;;  ASESORAMIENTO DE LA RAMA DE INGENIERÍA INFORMÁTICA  ;;
;;                                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Alumno: José Miguel González Cañadas
;; DNI: 77184606X

;; Para la implementación de este programa se ha hecho uso del ejercicio
;; de Adquisición del Conocimiento hecho en teoría. Así, los atributos
;; de los que vamos a requerir información serán:
;;  - Gustan matemáticas (sí/no). HECHOS: (matematicas Si), (matematicas No)
;;  - Quiere trabajar en (Empresa Publica/Empresa Privada/Docencia/Le da igual). HECHOS: (trabajar 1), (trabajar 2), (trabajar 3), (trabajar 4)
;;  - Nota media (alta/media/baja). HECHOS: (notamedia Alta), (notamedia Media), (notamedia Baja)
;;  - Gusta el hardware (sí/no). HECHOS: (hardware Si), (hardware No)
;;  - Es trabajador (mucho/normal/poco). HECHOS: (trabajdor Mucho), (trabajador Normal), (trabajador Poco)
;;
;; El árbol que se obtuvo fue un árbol en el que no se usaban dos de las variables
;; propuestas, por lo tanto he suprimido estas variables para la práctica.
;; Se han hecho algunas modificaciones mínimas en esta práctica ya que hay reglas que
;; coNCideraba que no tenían mucho sentido.
;;
;; Para ello entrevistaremos al usuario sacándole la información necesaria conforme
;; sea necesario. Haremos preguntas genéricas en algún tramo para hacer que el usuario
;; se meta más en el papel y coNCiga tener en cuenta todos los factores influyentes,
;; y en una entrevista fluida coNCeguiremos los datos que nos ayudarán para decidir
;; cada rama.
;;
;;
;; FUNCIONAMIENTO DE LA BASE DE CONOCIMIENTO:
;; Comienzo de la entrevista: Estará marcada por los hechos (Comienzo Si) y seguidamente por (introduccion 1). Al terminar el comienzo
;; se inicia la entrevista. Este inicio viene marcado por el hecho (entrevista 1). En esta primera versión de la base de conocimiento
;; solo se ha incluido el hecho (entrevista 1), pero este hecho está creado con la intención de realizar varias "sesiones", utilizando
;; los hechos (entrevista ?n) con ?n un número que indica el nº de la sesión. Esto vendría bien por si en algún momento no hemos cogido
;; la información necesaria en la primera sesión: bien sea por una pregunta no contestada, ambigua, o incluso por si el usuario en ese
;; momento no sabe dar respuesta.
;;
;;    Sabremos que hemos cogido bien la información de un atributo cuando el hecho (?atributo ?valor) esté en nuestro conocimiento. Una
;; forma para ver si es necesario hacer otra sesión, es comprobar que existe un hecho de cada atributo.
;; Para esta primera versión se ha coNCiderado el árbol que se ha explicado antes, en donde las respuestas a las preguntas sobre atributos
;; serán siempre recogidas, luego nunca nos será necesario en esta versión hacer otra sesión.
;;
;; El código está estructurado en los siguientes bloques:
;;  1.- Entrevista: conversación con el usuario y preguntas.
;;  2.- Conclusiones: se recogen las reglas que recomiendan una rama a partir de los atributos.
;;  3.- Comprobación de respuestas: reglas que analizan la respuesta del usuario y añaden los hechos.
;;  4.- Borrado de conocimiento: borra todo el conocimiento aportado en la entrevista. Se lanzan cuando ya hemos hecho una recomendacion
;;      para así terminar el programa.


;;; ========== PROPIEDADES QUE VOY A USAR SERGIO ========== ;;; 


;; El sistema utiliza los gustos del alumno, tomando valores de SI, NO o NC (no contesta) 
;; La respuesta se representa por (me_gusta ?pregunta SI|NO|NC) 
;;Donde ?pregunta representa aquello que le gusta
;; Estas preguntas serán si le gusta programar, las matemáticas, el hardware, administrar sistemas y la dirección de proyectos


;; El sistema utiliza el ámbito en el que desea trabajar el alumno cuando acabe la carrera, tomando valores de DOCENCIA, PÚBLICA, PRIVADA o NC (no contesta) 
;; y se representa por (resptuesta trabajo DOCENCIA|PÚBLICA|PRIVADA|NC) 

;; El sistema utiliza por último la capacidad de razonamiento del alumno teniendo que responder este con un valor del 1 al 5 
;; y se representa por (resptuesta razonamiento 1|2|3|4|5) 


;;; ========== PROPIEDADES QUE VOY A USAR JAVI ========== ;;; 

;;; Nuestro sistema experto tendrá en cuenta si al estudiante le gustan las matemáticas. 
;;; Los posibles valores que tomará son: SI, NO, NC (no lo sé)
;;; La representación será la siguiente: (gusta Matemáticas SI | NO | NC)

;;; Nuestro sistema experto tendrá en cuenta qué tipo de trabajo prefiere el estudiante. 
;;; Los posibles valores que tomará son: EMPRESA PRIVADA, EMPRESA PUBLICA, DOCENCIA, NC (no lo sé)
;;; La representación será la siguiente: (rTrabajo EMPRESA_PUBLICA | EMPRESA_PRIVADA | DOCENCIA | NC)

;;; Nuestro sistema experto tendrá en cuenta la nota media del estudiante. 
;;; Los posibles valores que tomará son: BAJA, MEDIA, ALTA, NC (no lo sé)
;;; La representación será la siguiente: (rNota BAJA | MEDIA | ALTA | NC)

;;; Nuestro sistema experto tendrá en cuenta si al estudiante le apasiona lo relacionado con hardware. 
;;; Los posibles valores que tomará son: SI, NO, NC (no lo sé)
;;; La representación será la siguiente: (gusta Hardware SI | NO | NC)

;;; Nuestro sistema experto tendrá en cuenta cómo de trabajador se coNCidera el estudiante a sí mismo. 
;;; Los posibles valores que tomará son: POCO, NORMAL, MUCHO, NC (no lo sé)
;;; La representación será la siguiente: (rTrabajador POCO | NORMAL | MUCHO | NC)

;;; Nuestro sistema experto tendrá en cuenta si al estudiante le apasiona la programación. 
;;; Los posibles valores que tomará son: SI, NO, NC (no lo sé)
;;; La representación será la siguiente: (gusta programacion SI | NO | NC)

;;; Nuestro sistema experto tendrá en cuenta si a nuestro estudiante le llama más la atención la teoría, o la práctica. 
;;; Los posibles valores que tomará son: TEORIA, PRACTICA, NC (no lo sé)
;;; La representación será la siguiente: ;;;; (rTipoClases TEORIA | PRACTICAS | NC)

;;; Hecho para representar que el sistema aconsejar elegir una rama por un motivo
;;; (consejo <nombre de la rama> "<texto del motivo>" "apodo del experto")

;; Representación de Ramas
(deffacts Ramas
  (Rama Computacion_y_Sistemas_Inteligentes)
  (Rama Ingenieria_del_Software)
  (Rama Ingenieria_de_Computadores)
  (Rama Sistemas_de_la_Informacion)
  (Rama Tecnologias_de_la_Informacion)
)












;Inicio del programa
(defrule inicio
    (declare (salience 1000))    
    =>    
    (printout t "Buenas soy un sistema experto que te va a aconsejar que rama escoger en base a unas preguntas." crlf)
    (printout t "Puedes parar en cualquier momento escribiendo como respuesta a la pregunta PARAR." crlf)
    (printout t "Me meto en el modulo 'ModuloPreguntas'" crlf)
    (focus ModuloPreguntas)
)

; Módulo con las preguntas 

(defmodule ModuloPreguntas (export ?ALL))

;;Deffacts sobre las preguntas
(deffacts preguntas
(pregunta gusta_programar)
(pregunta matematicas)
(pregunta hardware)
(pregunta administrar_sistemas)
(pregunta disenio_direccion)
(pregunta trabajo)
(pregunta razonamiento)
(pregunta sobre nota)
(pregunta sobre trabajador)
(pregunta sobre tipoClases)
)

;Preguntas para saber que le gusta al estudiante

;Preguntas donde se espera respuesta SI, NO, NC (No contesta)

;Pregunta sobre programacion
(defrule pregunta_programacion
    ?f <- (pregunta gusta_programar)
    (not (Parar))
    =>
    (printout t "Te gusta programar? Puedes responder con SI, NO o NC" crlf)
    (assert (me_gusta programar (upcase (read))))
    (retract ?f)
)

;Pregunta sobre matemáticas
(defrule pregunta_matematicas
    ?f <- (pregunta matematicas)
    (not (Parar))
    =>
    (printout t "Te gustan las matematicas? Puedes responder con SI, NO o NC" crlf)
    (assert (me_gusta matematicas (upcase (read))))
    (retract ?f)
)

;Pregunta sobre hardware
(defrule pregunta_hardware
    ?f <- (pregunta hardware)
    (not (Parar))
    =>
    (printout t "Te gusta el hardware? Puedes responder con SI, NO o NC" crlf)
    (assert (me_gusta hardware (upcase (read))))
    (retract ?f)
)

;Pregunta sobre administración de sistemas
(defrule pregunta_sistemas
    ?f <- (pregunta administrar_sistemas)
    (not (Parar))
    =>
    (printout t "Te gusta administrar sistemas? Puedes responder con SI, NO o NC" crlf)
    (assert (me_gusta administrar_sistemas (upcase (read))))
    (retract ?f)
)

;Pregunta sobre direccion de proyectos 
(defrule pregunta_direccion_proyectos
    ?f <- (pregunta disenio_direccion)
    (not (Parar))
    =>
    (printout t "Te gusta diseniar y dirigir proyectos? Puedes responder con SI, NO o NC" crlf)
    (assert (me_gusta disenio_direccion (upcase (read))))
    (retract ?f)
)

;Preguntas donde no se espera respuesta SI, NO, NC (No contesta)

;Pregunta sobre el tipo de trabajo que espera
(defrule pregunta_trabajo
    ?f <- (pregunta trabajo)
    (not (Parar))
    =>
    (printout t "Donde tienes pensado trabajar cuando acabes la carrera? Puedes responder con DOCENCIA, PUBLICA (empresa publica), PRIVADA (empresa privada) o NC (no contesta)" crlf)
    (assert (respuesta trabajo (upcase (read))))
    (retract ?f)
)

;Pregunta sobre razonamiento
(defrule pregunta_razonamiento
    ?f <- (pregunta razonamiento)
    (not (Parar))
    =>
    (printout t "Del 1 al 5 como consideras tu capacidad de razonamiento? Responde un numero del 1 al 5" crlf)
    (assert (respuesta razonamiento (read)))
    (retract ?f)
)

;Comprobaciones sobre las respuestas
;Preguntas de SI/NO (si gustan ciertas cosas)

(defrule respuesta_SINONC
    (declare (salience 100))
    ?f <- (me_gusta ?pregunta ?respuesta)
    (test (and (neq ?respuesta SI) (and (neq ?respuesta NO) (neq ?respuesta NC) ) ) )
    =>
    (retract ?f)
    (assert (pregunta ?pregunta))
    (printout t "Se debe responder con SI, NO o NC: " crlf)
)

;Se comprueba si el alumno quiere parar con las preguntas

(defrule respuesta_SINONC_PARAR
    (declare (salience 1000))
    ?f <- (me_gusta ?pregunta PARAR)
    =>
    (retract ?f)
    (assert (Parar))
    (printout t "Esta bien, se acabaron las preguntas" crlf)
)

;Comprobaciones sobre las respuestas
;Preguntas con respuestas distintas a SI/NO 

(defrule respuesta_trabajo
    (declare (salience 100))
    ?f <- (respuesta trabajo ?respuesta)
    (test 
        (and 
            (neq ?respuesta DOCENCIA) 
            
            (and 
                (neq ?respuesta PUBLICA) 
                
                (and (neq ?respuesta PRIVADA) (neq ?respuesta NC) ) 
            ) 
        ) 
    )
    =>
    (retract ?f)
    (assert (pregunta trabajo))
    (printout t "Se debe responder con DOCENCIA, PUBLICA, PRIVADA o NC: " crlf)
)

(defrule respuesta_razonamiento
    (declare (salience 100))
    ?f <- (respuesta razonamiento ?respuesta)
    (test 
        (and 
            (neq ?respuesta 1) 
            
            (and 
                (neq ?respuesta 2) 
                
                (and 
                
                    (and (neq ?respuesta 3) (neq ?respuesta 4) )
                    
                    (neq ?respuesta 5)
                
                ) 
            ) 
        ) 
    )
    =>
    (retract ?f)
    (assert (pregunta razonamiento))
    (printout t "Se debe responder con un numero del 1 al 5 o PARAR en mayuscula" crlf)
)

;Se comprueba si el alumno quiere parar con las preguntas

(defrule respuesta_PARAR
    (declare (salience 1000))
    ?f <- (respuesta ?pregunta PARAR)
    =>
    (retract ?f)
    (assert (Parar))
    (printout t "Esta bien, se acabaron las preguntas" crlf)
)

;Cuando hay un hecho que sea (Parar) se acaban las preguntas y salimos del módulo preguntas 
(defrule PARAR
    (declare (salience 9000))
    (Parar)
    =>
    (printout t "Me meto en el modulo inferir_Sergio" crlf)
    (focus inferir_Sergio)
)

;;; Mediante esta regla obtendremos respuesta a la pregunta de qué nota media
;;; posee el estudiante.

(defrule preg_NotaMedia
    (declare (salience 6))
    ?f <- (pregunta sobre nota)
    (not (Parar))
    =>
    (retract ?f)
    (printout t "¿Cual es tu calificacion media? POSIBLES RESPUESTAS (Numero | Alta | Media | Baja | NC)" crlf)
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
    (assert (Parar))
)

;;; A diferencia de las preguntas con respuesta SI | NO | NC, para las de esta sección
;;; hemos de crear una regla que compruebe las respuestas de cada pregunta, pues las 
;;; posibles repsuestas varían de una a otra. 

(defrule respuestaNota
    (declare (salience 999))
    ?f <- (rNota ?nota)
    (test (eq (type ?nota) SYMBOL))
    (test 
        (and 
            (neq (upcase ?nota) ALTA) 
            (and
                (neq (upcase ?nota) MEDIA)
                (and
                    (neq (upcase ?nota) BAJA)
                    (neq (upcase ?nota) NC)
                )
            )
        )
    )
    =>
    (retract ?f)
    (printout t "Debe introducir una respuesta valida: (Numero | Alta | Media | Baja | NC):" ?nota  (type ?nota) crlf)
    (assert (pregunta nota))
)

;;; Mediante esta regla, pasaremos a mayusculas la respuesta sobre
;;; la pregunta de la nota media. Para ello, primero hemos de comprobar que
;;; la respuesta introducida es válida. 

(defrule ajustar_Mayusculas_Nota
    (declare (salience 998))
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
                    (eq (upcase ?nota) NC)
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
;;; de trabajador se coNCidera el estudiante. 

(defrule preg_Trabajador
    (declare (salience 8))
    ?f <- (pregunta sobre trabajador)
    (not (Parar))

    =>
    (retract ?f)
    (printout t "¿Te consideras trabajador? POSIBLES RESPUESTAS (Mucho | Normal | Poco | NC)" crlf)
    (assert (rTrabajador (upcase (read))))
)

;;; Regla para comprobar si decide parar al perguntar sobre la nota media

(defrule comprobaPararTrabajador
    (declare (salience 9999))
    ?f <- (rTrabajador ?tr)
    (test (eq ?tr PARAR))
    =>
    (retract ?f)
    (printout t "Vale, no hare mas preguntas. ")
    (assert (Parar))
)


;;; A diferencia de las preguntas con respuesta SI | NO | NC, para las de esta sección
;;; hemos de crear una regla que compruebe las respuestas de cada pregunta, pues las 
;;; posibles repsuestas varían de una a otra. 

(defrule respuestaTrabajador
    (declare (salience 999))
    ?f <- (rTrabajador ?tr)
    (test
        (and
            (neq  ?tr MUCHO)
            (and
                (neq ?tr NORMAL)
                (and
                    (neq ?tr POCO)
                    (neq ?tr NC)
                )
            )
        )
    )
    =>
    (retract ?f)
    (printout t "Debe introducir una respuesta valida: (Mucho | Normal | Poco | NC):" crlf)
    (assert (pregunta sobre trabajador))
)

;;; ¿ QUE TIPO DE CLASES PREFIERE EL ESTUDIANTE ? ;;; 

;;; Mediante esta regla obtendremos respuesta a la pregunta sobre
;;; que tipo de clases prefiere el estudiante

(defrule pTipoClases
    ?f <- (pregunta sobre tipoClases)
    (not (Parar))
    =>
    (retract ?f)
    (printout t "¿Te gustan las clases teoricas o practicas? RESPUESTA POSIBLES (Teoricas | Practicas | NC)" crlf)
    (assert (rTipoClases (upcase (read))))
)

;;; Regla para comprobar si decide parar al perguntar sobre el tipo de clases

(defrule comprobaPararTipoClases
    (declare (salience 9999))
    ?r <- (rTipoClases ?tr)
    (test (eq ?tr PARAR))

    =>

    (retract ?r)
    (printout t "Vale, no te hare mas preguntas...")
    (assert (Parar))
)

;;; A diferencia de las preguntas con respuesta SI | NO | NC, para las de esta sección
;;; hemos de crear una regla que compruebe las respuestas de cada pregunta, pues las 
;;; posibles repsuestas varían de una a otra. 

(defrule respuestaTipoClases
    (declare (salience 999))
    ?f <- (rTipoClases ?tc)
    (test
        (and
            (neq ?tc TEORICAS)
            (and
                (neq ?tc PRACTICAS)
                (neq ?tc NC)
            )
        )
    )
    =>
    (retract ?f)
    (printout t "Debe introducir una respuesta valida: (Teoricas | Practicas | NC):" crlf)
    (assert (pregunta sobre tipoClases))
)

;Si no quedan preguntas, salimos del módulo preguntas 
(defrule no_quedan_preguntas
    (declare (salience 2000))
    (not (pregunta ?pregunta) )
    (not (pregunta sobre ?pregunta) )
    =>
    (printout t "Preguntas Terminadas." crlf)
    (focus inferir_Sergio)
)

; Módulo para inferir las respuestas de Sergio

(defmodule inferir_Sergio (export ?ALL) (import ModuloPreguntas ?ALL))

(defrule inferir_1    
    (me_gusta matematicas SI)
    =>
    (assert (aconsejar SI))
    (assert (aconsejar CSI))
    (assert (consejo SI "ya que te gustan las matematicas (lo que es fundamental en esta rama)."))
    (assert (consejo CSI "ya que te gustan las matematicas, lo cual es una gran ventaja."))
)

(defrule inferir_2    
    (respuesta trabajo DOCENCIA)
    =>
    (assert (aconsejar SI))
    (assert (aconsejar CSI))
    (assert (consejo SI "ya que tiene grandes aplicaciones en investigacion dentro de la docencia, algo en lo que tu estas interesado/a."))
    (assert (consejo CSI "ya que es un buen perfil para docencia, de hecho algunos profesores trabajan tambien en proyectos para empresas."))
)

(defrule inferir_3    
    (respuesta trabajo PRIVADA)
    =>
    (assert (aconsejar SI))
    (assert (aconsejar IS))
    (assert (aconsejar CSI))
    (assert (consejo SI "ya que es un perfil muy solicitado en empresas privadas."))
    (assert (consejo IS "ya que es un perfil muy solicitado en empresas privadas."))
    (assert (consejo CSI "ya que es un perfil muy solicitado en empresas privadas."))
)

(defrule inferir_4    
    (me_gusta disenio_direccion SI)
    =>
    (assert (aconsejar IS))
    (assert (aconsejar TI))
    (assert (consejo IS "ya que te gusta el disenio y direccion de proyectos (lo que es fundamental en esta rama)."))
    (assert (consejo TI "ya que te gusta el disenio y direccion de proyectos (lo que es fundamental en esta rama)."))
)

(defrule inferir_5    
    (respuesta razonamiento ?respuesta)
    (test (or (= ?respuesta 4) (= ?respuesta 5) ) )
    =>
    (assert (aconsejar CSI))
    (assert (consejo CSI "debido a que tienes una buena capacidad de razonamiento (lo que es fundamental en esta rama)."))
)

(defrule inferir_6    
    (respuesta trabajo PUBLICA)
    =>
    (assert (aconsejar IC))
    (assert (consejo IC "porque es un perfil muy solicitado en empresas publicas."))
)

(defrule inferir_7    
    (me_gusta administrar_sistemas SI)
    =>
    (assert (aconsejar IC))
    (assert (consejo IC "porque que te gusta el hardware y la administracion de sistemas (lo que es fundamental en esta rama)."))
)

(defrule inferir_8    
    (me_gusta hardware SI)
    =>
    (assert (aconsejar IC))
    (assert (consejo IC "porque te gusta el hardware y la administracion de sistemas (lo que es fundamental en esta rama)."))
)

(defrule inferir_9    
    (me_gusta programar NO)
    =>
    (assert (aconsejar IC))
    (assert (aconsejar TI))
    (assert (consejo IC "debido a que no te gusta programar, la rama de IC te puede gustar."))
    (assert (consejo TI "debido a que te gusta programar, la rama de TI te puede gustar."))
)


;No aconsejo en caso de que no les guste o no se les de bien algo que es fundamental

(defrule inferir_neg_1    
    ?f <- (aconsejar SI)
    (me_gusta matematicas ?respuesta)
    (test (neq ?respuesta SI))
    =>
    (retract ?f)
)

(defrule inferir_neg_2    
    ?f <- (aconsejar IS)
    (me_gusta disenio_direccion ?respuesta)
    (test (neq ?respuesta SI))
    =>
    (retract ?f)
)

(defrule inferir_neg_3    
    (me_gusta matematicas NO)
    =>
    (assert (consejo CSI "Que no te gusten las matematicas es un handicap para la rama de CSI."))
)

(defrule inferir_neg_4    
    ?f <- (aconsejar CSI)
    (respuesta razonamiento ?respuesta)
    (test 
        (or 
            (or (= ?respuesta 1) (= ?respuesta 2) )

            (= ?respuesta 3)
        ) 
    )
    =>
    (retract ?f)
)

(defrule inferir_neg_5    
    ?f <- (aconsejar IC)
    (me_gusta hardware NO)
    =>
    (retract ?f)
)

(defrule inferir_neg_6    
    ?f <- (aconsejar IC)
    (me_gusta administrar_sistemas NO)
    =>
    (retract ?f)
)

(defrule inferir_neg_7    
    ?f <- (aconsejar TI)
    (me_gusta disenio_direccion ?respuesta)
    (test (neq ?respuesta SI))
    =>
    (retract ?f)
)

(defrule inferir_comodin
    (declare (salience -1000))    
    (not (consejo ?rama ?texto))
    =>
    (assert (aconsejar TI))
    (assert (consejo TI "porque tengo poca informacion y esta suele ser una rama equilibrada en cuanto a dificultad y que suele gustarle a los alumnos."))
)


;si no se puede disparar ninguna regla sobre inferencia, se ha acabado
(defrule no_mas_inferencia
    (declare (salience -2000))
    =>
    (printout t "Me meto modulo inferir Javi" crlf)
    (focus inferir_Javi)
)

;;; ========= CALCULO DE LA RAMA OPTATIVA MAS aconsejarBLE ============ ;;;

(defmodule inferir_Javi (export ?ALL) (import ModuloPreguntas ?ALL))

;;; RAMA CSI (COMPUTACION Y SISTEMAS INTELIGENTES) ;;;

;;; Mediante esta regla aconsejaremos la rama de CSI a aquellos estudiantes que: 
;;; 1º No les guste el hardware (O no lo saben). 
;;; 2º Les gusten las mates. 
;;; 3º Sean muy trabajadores

(defrule CSI_1
    (declare (salience 100))
    (me_gusta hardware ?n)
    (test
        (or 
            (eq ?n NO)
            (eq ?n NC)
        )
    )
    (me_gusta matematicas SI)
    (rTrabajador MUCHO)
    =>
    (assert (Rama Computacion_y_Sistemas_Inteligentes))
    (assert (consejo Computacion_y_Sistemas_Inteligentes "Esta rama esta muy relacionada con las matematicas. Esta enfocada en software, y requiere de mucho trabajo por parte del estudiante. Por tanto, considero que encajas a la perfeccion con el perfil de estudiante recomendado para esta rama." "FJGALLEGO"))
)

;;; Mediante esta regla aconsejaremos la rama de CSI a aquellos estudiantes que: 
;;; 1º No les guste el hardware. 
;;; 2º Les gusten las mates. 
;;; 3º Sean trabajadores 'normales'.
;;; 4º Les guste programar
;;; 5º Tengan una nota media ALTA | MEDIA

(defrule CSI_2
    (declare (salience 100))
    (me_gusta hardware ?n)
    (test
        (or 
            (eq ?n NO)
            (eq ?n NC)
        )
    )
    (gusta matematicas SI)
    (rTrabajador NORMAL)
    (me_gusta programacion SI)
    (rNota ?n)
    (test
        (or 
            (eq ?n MEDIA)
            (eq ?n ALTA)
        )
    )
    =>
    (assert (Rama Computacion_y_Sistemas_Inteligentes))
    (assert (consejo Computacion_y_Sistemas_Inteligentes "Esta rama esta muy relacionada con las matematicas. Esta enfocada en software, y requiere de mucho trabajo por parte del estudiante. Debido a tu gusto por las matematicas, que eres buen trabajador y sobre todo, por tus buenas notas, esta rama es la mas indicada." "FJGALLEGO"))
)

;;; RAMA IS (Ingeniera del Sotware) ;;;

;;; Mediante esta regla aconsejaremos la rama de IS a aquellos estudiantes que: 
;;; 1º No les guste el hardware. 
;;; 2º No le gustan las mates (O no lo saben). 
;;; 3º Quieren trabajar en la empresa PUBLICA | DOCENCIA | NC.
;;; 4º Son muy trabajadores

(defrule IS
    (declare (salience 100))
    (me_gusta hardware ?n)
    (test
        (or 
            (eq ?n NO)
            (eq ?n NC)
        )
    )
    (me_gusta matematicas ?n)
    (test
        (or 
            (eq ?n NO)
            (eq ?n NC)
        )
    )
    (rTrabajo ?n)
    (test
        (or 
            (eq ?n DOCENCIA)
            (or
                (eq ?n EMPRESA_PUBLICA)
                (eq ?n NC)
            )            
        )
    )
    (rTrabajador MUCHO)    
    =>
    (assert (Rama Ingenieria_del_Software))
    (assert (consejo Ingenieria_del_Software "Esta rama no esta muy relacionada con las matematicas. Asi mismo, requiere trabajo y puede estar relacionada con el tipo de trabajo que te gusta." "FJGALLEGO"))
)

;;; RAMA SI (SISTEMAS DE INFORMACION) ;;;

;;; Mediante esta regla aconsejaremos la rama de SI a aquellos estudiantes que: 
;;; 1º No les guste el hardware (O no lo saben). 
;;; 2º No le gustan las mates (O no lo saben). 
;;; 3º Quieren trabajar en la EMPRESA PRIVADA.

(defrule SI_1
    (declare (salience 100))
    (me_gusta hardware ?n)
    (test
        (or 
            (eq ?n NO)
            (eq ?n NC)
        )
    )
    (me_gusta matematicas ?n)
    (test
        (or 
            (eq ?n NO)
            (eq ?n NC)
        )
    )
    (rTrabajo EMPRESA_PRIVADA)
    =>
    (assert (Rama Sistemas_de_Informacion))
    (assert (consejo Sistemas_de_Informacion "Esta rama puede estar relacionada con el tipo de trabajo que buscas. Asi mismo, puesto que no has presentado un gran interes por las matematicas y el hardware, la veo como la ideal para ti." "FJGALLEGO"))
)

;;; Mediante esta regla aconsejaremos la rama de SI a aquellos estudiantes que: 
;;; 1º No les guste el hardware (O no lo saben). 
;;; 2º No le gustan las mates (O no lo saben). 
;;; 3º Quieren trabajar en la EMPRESA PRIVADA.
;;; 4º Poco trabajador

(defrule SI_2
    (declare (salience 100))
    (me_gusta hardware ?n)
    (test
        (or 
            (eq ?n NO)
            (eq ?n NC)
        )
    )
    (me_gusta matematicas ?n)
    (test
        (or 
            (eq ?n NO)
            (eq ?n NC)
        )
    )
    (rTrabajo ?n)
    (test
        (or 
            (eq ?n DOCENCIA)
            (or
                (eq ?n EMPRESA_PUBLICA)
                (eq ?n NC)
            )            
        )
    )
    (rTrabajador ?n)
    (test
        (or 
            (eq ?n POCO)
            (eq ?n NC)
        )
    )
    =>
    (assert (Rama Sistemas_de_Informacion))
    (assert (consejo Sistemas_de_Informacion "Esta rama puede estar relacionada con el tipo de trabajo que buscas. Asi mismo, puesto que no has presentado un gran interes por las matematicas y el hardware, y eres poco trabajador, la veo como la ideal para ti." "FJGALLEGO"))
)

;;; Mediante esta regla aconsejaremos la rama de SI a aquellos estudiantes que: 
;;; 1º No les guste el hardware (O no lo saben). 
;;; 2º Les gustan las mates 
;;; 3º Trabajador NORMAL
;;; 4º Le gusta programar
;;; 5º Nota Media BAJA (o no sabe)

(defrule SI_3
    (declare (salience 100))
    (me_gusta hardware ?n)
    (test
        (or 
            (eq ?n NO)
            (eq ?n NC)
        )
    )
    (me_gusta matematicas SI)
    (rTrabajador NORMAL)
    (me_gusta programar SI)
    (rNota ?n)
    (test
        (or 
            (eq ?n BAJA)
            (eq ?n NC)
        )
    )
    =>
    (assert (Rama Sistemas_de_Informacion))
    (assert (consejo Sistemas_de_Informacion "Esta rama esta relacionada con el software. Aunque tus notas no sean excelentes, como te gusta programar y eres algo trabajador, la considero la ideal." "FJGALLEGO"))
)

;;; Mediante esta regla aconsejaremos la rama de SI a aquellos estudiantes que: 
;;; 1º No les guste el hardware (O no lo saben). 
;;; 2º Les gustan las mates 
;;; 3º Trabajador NORMAL
;;; 4º NO les gusta programar (o no saben)

(defrule SI_4
    (declare (salience 100))
    (me_gusta hardware ?n)
    (test
        (or 
            (eq ?n NO)
            (eq ?n NC)
        )
    )
    (me_gusta matematicas SI)
    (rTrabajador NORMAL)
    (me_gusta programar ?n)
    (test
        (or 
            (eq ?n NO)
            (eq ?n NC)
        )
    )
    =>
    (assert (Rama Sistemas_de_Informacion))
    (assert (consejo Sistemas_de_Informacion "Debido a que eres algo trabajador, pese a que no te guste programar en exceso, recomiendo que la mejor rama es esta." "FJGALLEGO"))
)

;;; Mediante esta regla aconsejaremos la rama de SI a aquellos estudiantes que: 
;;; 1º No les guste el hardware (O no lo saben). 
;;; 2º Les gustan las mates 
;;; 3º Trabajador POCO | NC 

(defrule SI_5
    (declare (salience 100))
    (me_gusta hardware ?n)
    (test
        (or 
            (eq ?n NO)
            (eq ?n NC)
        )
    )
    (me_gusta matematicas SI)
    (rTrabajador ?n)
    (test
        (or 
            (eq ?n POCO)
            (eq ?n NC)
        )
    )
    (rTrabajador POCO)
    =>
    (assert (Rama Sistemas_de_Informacion))
    (assert (consejo Sistemas_de_Informacion "Puesto que eres poco trabajador y te gustan las mates y lo relacionado con el sotfware, recomiendo esta rama." "FJGALLEGO"))
)

;;; RAMA TI (Tecnologias de la informacion) ;;;

;;; Mediante esta regla aconsejaremos la rama de SI a aquellos estudiantes que: 
;;; 1º No les guste el hardware (O no lo saben). 
;;; 2º No le gustan las mates (O no lo saben). 
;;; 3º Quieren trabajar en la EMPRESA PRIVADA.
;;; 4º Trabajador NORMAL

(defrule TI
    (declare (salience 100))
    (me_gusta hardware ?n)
    (test
        (or 
            (eq ?n NO)
            (eq ?n NC)
        )
    )
    (me_gusta matematicas ?n)
    (test
        (or 
            (eq ?n NO)
            (eq ?n NC)
        )
    )
    (rTrabajo ?n)
    (test
        (or 
            (eq ?n DOCENCIA)
            (or
                (eq ?n EMPRESA_PUBLICA)
                (eq ?n NC)
            )            
        )
    )
    (rTrabajador NORMAL)
    =>
    (assert (Rama Tecnologias_de_la_Informacion))
    (assert (consejo Tecnologias_de_la_Informacion "Esta rama puede estar relacionada con el tipo de trabajo que buscas. Asi mismo, puesto que no has presentado un gran interes por las matematicas y el hardware, y eres poco trabajador, la veo como la ideal para ti." "FJGALLEGO"))
)

;;; RAMA IC (INGENIERIA DE COMPUTADORES) ;;; 

;;; aconsejar la rama IC por gustarle el hardware
(defrule IC
    (declare (salience 101))
    (me_gusta hardware SI)
    =>
    (assert (Rama Ingenieria_de_Computadores))
    (assert (consejo Ingenieria_de_Computadores "es la mejor opcion si te gusta el hardware." "FJGALLEGO"))    
)

;;; ========= REGLAS PARA CUANDO SE PARAN LAS PREGUNTAS ========== ;;; 

;;; Ninguna respuesta ;;;

(defrule ninguna_resp
    (declare (salience -50))
    (Parar)
    (not (rTrabajador ?n))   
    =>
    (assert (Rama Tecnologias_de_la_Informacion))
    (assert (consejo Tecnologias_de_la_Informacion ", aunque no me hayas proporcionado demasiada informacion esta suele ser la opcion mas segura" "FJGALLEGO"))
)

;;; Solo 1 respuesta ;;;

(defrule solo_1_resp
    (declare (salience -49))
    (me_gusta hardware ?n)
    (test
        (or 
            (eq ?n NO)
            (eq ?n NC)
        )
    )    
    (Parar)
    =>
    (assert (Rama Tecnologias_de_la_Informacion))
    (assert (consejo Tecnologias_de_la_Informacion ", aunque no me hayas proporcionado demasiada informacion esta suele ser la opcion mas segura" "FJGALLEGO"))
)

;;; Solo 2 respuestas ;;;

(defrule solo_2_resp_matesSI
    (declare (salience -48))
    (me_gusta hardware ?n)
    (test
        (or 
            (eq ?n NO)
            (eq ?n NC)
        )
    )    
    (me_gusta matematicas SI)
    (Parar)
    =>
    (assert (Rama Sistemas_de_Informacion))
    (assert (consejo Sistemas_de_Informacion ", aunque no me hayas proporcionado demasiada informacion, puesto que te gustan las mates y no el hardware esta es la mejor opcion." "FJGALLEGO"))
)

(defrule solo_2_resp_matesNONC
    (declare (salience -48))
    (me_gusta hardware ?n)
    (test
        (or 
            (eq ?n NO)
            (eq ?n NC)
        )
    )    
    (me_gusta matematicas ?n)
    (test
        (or 
            (eq ?n NO)
            (eq ?n NC)
        )
    )   
    (Parar)
    =>
    (assert (Rama Tecnologias_de_la_Informacion))
    (assert (consejo Tecnologias_de_la_Informacion ", aunque no me hayas proporcionado demasiada informacion, puesto que no te gustan las mates ni el hardware, esta es la mas recomendada en mi opinion." "FJGALLEGO"))
)

;;; Solo 3 respuestas ;;;

(defrule solo_3_resp_Trabajo_NOPriv
    (declare (salience -47))
    (me_gusta hardware ?n)
    (test
        (or 
            (eq ?n NO)
            (eq ?n NC)
        )
    )    
    (me_gusta matematicas ?n)
    (test
        (or 
            (eq ?n NO)
            (eq ?n NC)
        )
    )   
    (rTrabajo ?n)
    (test
        (or 
            (eq ?n DOCENCIA)
            (or
                (eq ?n EMPRESA_PUBLICA)
                (eq ?n NC)
            )            
        )
    )
    (Parar)
    =>
    (assert (Rama Tecnologias_de_la_Informacion))
    (assert (consejo Tecnologias_de_la_Informacion "con todo lo que me has dicho, aunque no me hayas proporcionado toda la informacion, puesto que no te gustan las mates ni el hardware, y quizas esta mas relacionada con el trabajo que deseas, esta es tu rama." "FJGALLEGO"))
)

(defrule solo_3_resp_Trabajador_Normal
    (declare (salience -47))
    (me_gusta hardware ?n)
    (test
        (or 
            (eq ?n NO)
            (eq ?n NC)
        )
    )    
    (me_gusta matematicas SI)
    (rTrabajador NORMAL)
    (Parar)
    =>
    (assert (Rama Sistemas_de_Informacion))
    (assert (consejo Sistemas_de_Informacion "con todo lo que me has dicho, aunque no me hayas proporcionado toda la informacion, esta es la mejor rama para ti. Esto es porque es una rama relacionada con el software, donde se tiene que trabajar bastante (pero sin excederse) ." "FJGALLEGO"))
)

;;; Solo responde 4 preguntas ;;; 

(defrule solo_4_resp
    (declare (salience -46))
    (me_gusta hardware ?n)
    (test
        (or 
            (eq ?n NO)
            (eq ?n NC)
        )
    )    
    (me_gusta matematicas SI)
    (rTrabajador NORMAL)
    (me_gusta programar SI)
    (Parar)
    =>
    (assert (Rama Computacion_y_Sistemas_Inteligentes))
    (assert (consejo Computacion_y_Sistemas_Inteligentes "puesto que es una rama muy relacionada con las matematicas. Ademas, tiene muchas asignaturas con practicas de programacion y requiere de bastante trabajo." "FJGALLEGO"))
)

(defrule no_inferir
    (declare (salience -9999))
    =>
    (focus inferir_Josemi)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Fin de calcular la rama ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Terminar si ya se ha aconsejardo
(defrule noHayMasCalculos
    (declare (salience 200))
    (Rama ?rama)
    (consejo ?rama ?motivo ?experto)
    =>
    (printout t "Me meto en el modulo inferir Josemi" crlf)
    (focus inferir_Josemi)
)


















(defmodule inferir_Josemi (export ?ALL) (import ModuloPreguntas ?ALL))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;   CONCLUSIONES SOBRE LAS RESPUESTAS   ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Las recomendaciones están basadas en las reglas generadas por el árbol
(defrule recomiendacion_is1
  (declare (salience 9999))
  (me_gusta hardware NO)
  (me_gusta matematicas NO)
  (rNota ALTA)  
  =>
  (printout t "" crlf)
  (assert (Rama Ingeniera_del_Software))
  (assert (consejo Ingenieria_del_Software "En vista de que no te gusta el hardware te deberías de centrar en las ramas que están más alejadas de los componentes y del tratamiento del ordenador a bajo nivel. En vista de que no te gustan las matematicas, una buena eleccion seria Ingenieria del Software ya que con tu nota media tan alta no deberias de tener problema." "JOSEMI"))
)


(defrule recomiendacion_si1
  (declare (salience 9999))
  (me_gusta hardware NO)
  (me_gusta matematicas NO)
  (rNota BAJA|MEDIA)
  (respuesta trabajo PRIVADA)
  =>
  (assert (Rama Sistemas_de_la_Información))
  (assert (consejo Sistemas_de_la_Informacion "En vista de que no te gusta el hardware te deberías de centrar en las ramas que están más alejadas de los componentes y del tratamiento del ordenador a bajo nivel. En vista de que no te gustan las matematicas, y la nota media no importa mucho puedes hacer la rama de Sistemas de la Informacion, ya que tiene bastantes salidas en la empresa privada." "JOSEMI"))
)

(defrule recomiendacion_is2
  (declare (salience 9999))
  (me_gusta hardware NO)
  (me_gusta matematicas NO)
  (rNota BAJA|MEDIA)
  (respuesta trabajo PUBLICA|DOCENCIA|NC)
  =>
  (assert (Rama Ingeniera_del_Software))
  (assert (consejo Rama Ingeniera_del_Software "En vista de que no te gusta el hardware te deberías de centrar en las ramas que están más alejadas de los componentes y del tratamiento del ordenador a bajo nivel. En vista de que no te gustan las matematicas, una opcion es intentar Ingenieria del Software puesto que aunque tengas nota baja, hay trabajo en empresas publicas o docencia, como a ti te interesa." "JOSEMI"))
)

(defrule recomendacion_csi1
  (declare (salience 9999))
  (me_gusta hardware NO)
  (me_gusta matematicas SI)
  (rTrabajador MUCHO)
  =>
  (assert (Rama Computacion_y_Sistemas_Inteligentes))
  (assert (consejo Computacion_y_Sistemas_Inteligentes "En vista de que no te gusta el hardware te deberías de centrar en las ramas que están más alejadas de los componentes y del tratamiento del ordenador a bajo nivel. Como te gustan las matematicas, una rama muy acorde a ellas es la rama de Computacion y Sistemas Inteligentes. Hay que ser trabajador para sacarla adelante, Y TU LO ERES." "JOSEMI"))
)

(defrule recomendacion_csi2
  (declare (salience 9999))
  (me_gusta hardware NO)
  (me_gusta matematicas SI)
  (rTrabajador NORMAL)
  (respuesta trabajo PRIVADA)
  =>
  (assert (Rama Computacion_y_Sistemas_Inteligentes))
  (assert (consejo Computacion_y_Sistemas_Inteligentes "En vista de que no te gusta el hardware te deberías de centrar en las ramas que están más alejadas de los componentes y del tratamiento del ordenador a bajo nivel. Como te gustan las matematicas, una rama muy acorde a ellas es la rama de Computacion y Sistemas Inteligentes. Esta rama tiene muchas salidas en las empresas privadas. Seguro que te interesa." "JOSEMI"))
)

(defrule recomendacion_ti1
  (declare (salience 9999))
  (me_gusta hardware NO)
  (me_gusta matematicas SI)
  (rTrabajador NORMAL)
  (respuesta trabajo PUBLICA|DOCENCIA|NC)  ;; Cualquier cosa que no sea empresa privada
  =>
  (assert (Rama Tecnologias_de_la_Informacion))
  (assert (consejo Tecnologias_de_la_Informacion "En vista de que no te gusta el hardware te deberías de centrar en las ramas que están más alejadas de los componentes y del tratamiento del ordenador a bajo nivel. Como te gustan las matematicas y se te ve que trabajas mas o menos bien, una buena situacion seria que estudiases la rama de Tecnologias de la Informacion, aunque tiene pocas salidas en empresa privada, pero, por lo que me has contado, eso te da igual. " "JOSEMI"))
)

(defrule recomendacion_ti2
  (declare (salience 9999))
  (me_gusta hardware NO)
  (me_gusta matematicas SI)
  (rTrabajador POCO)
  =>
  (assert (Rama Tecnologias_de_la_Informacion))
  (assert (consejo Tecnologias_de_la_Informacion "En vista de que no te gusta el hardware te deberías de centrar en las ramas que están más alejadas de los componentes y del tratamiento del ordenador a bajo nivel. Como te gustan las matematicas pero trabajas poco, una rama que exige poco y que te puede interesar a nivel matematico seria Tecnologias de la informacion " "JOSEMI"))
)

(defrule recomendacion_is3
  (declare (salience 9999))
  (me_gusta hardware SI)
  (rTrabajador MUCHO)
  (respuesta trabajo PUBLICA|PRIVADA)
  =>
  (assert (Rama Ingeniera_del_Software))
  (assert (consejo Ingenieria_del_software "Por lo que veo te gusta el hardware, pero veo que eres trabajador y te interesa trabajar en una empresa. Mi recomendacion es que te metas a Ingenieria del Software, con esta rama te sera mas facil asentarte en un trabajo de empresa publica y con ello pivotar a un trabajo mas relacionado con hardware." "JOSEMI"))
)

(defrule recomendacion_ic1
  (declare (salience 9999))
  (me_gusta hardware SI)
  (rTrabajador MUCHO)
  (respuesta trabajo DOCENCIA|NC)
  =>
  (assert (Rama Ingeniera_de_Computadores))
  (assert (consejo Ingenieria_de_Computadores "Por lo que veo te gusta el hardware, pero veo que eres trabajador y te interesa trabajar en fuera de una empresa. Mi recomendacion es que te metas a Ingenieria de Computadores es la rama mas relacionada con hardware, y seguro que te gustara." "JOSEMI"))
)

(defrule recomendacion_ic2
  (declare (salience 9999))
  (me_gusta hardware SI)
  (rTrabajador NORMAL)
  =>
  (assert (Rama Ingeniera_de_Computadores))
  (assert (consejo Ingenieria_de_Computadores "Por lo que veo te gusta el hardware, pero veo que trabajas moderadamente, una opcion viable es que te metas a Ingenieria de Computadores es la rama mas relacionada con hardware, y seguro que te gustara." "JOSEMI"))
)


(defrule recomendacion_is4
  (declare (salience 9999))
  (me_gusta hardware SI)
  (rTrabajador POCO)
  (respuesta trabajo PRIVADA)
  =>
  (assert (Rama Ingeniera_del_Software))
  (assert (consejo Ingenieria_del_software "Por lo que veo te gusta el hardware, pero veo que trabajas poco, una opcion viable es que te metas a Ingenieria del Software. Te sera mas facil asentarte en un trabajo de empresa publica y con ello pivotar a un trabajo mas relacionado con hardware." "JOSEMI"))
)

(defrule recomendacion_ic3
  (declare (salience 9999))
  (me_gusta hardware SI)
  (rTrabajador POCO)
  (respuesta trabajo PUBLICA|DOCENCIA|NC)
  =>
  (assert (Rama Ingeniera_de_Computadores))
  (assert (consejo Ingenieria_de_Computadores "Por lo que veo te gusta el hardware, pero veo que trabajas poco. Una opcion viable es que te metas a Ingenieria de Computadores es la rama mas relacionada con hardware, y seguro que te gustara." "JOSEMI"))
)


;; Reglas por defecto, se aplican en caso de asegurar la recomendacion. Si ha llegado a un punto en el que la información no ha aportado
;; algo distinto de lo que se pensaba en un principio, pues se lanzan estas
(defrule recomendacion_ic_seguro
  (declare (salience -100))
  (me_gusta hardware SI)
  =>
  (assert (Rama Ingeniera_de_Computadores))
  (assert (consejo Ingenieria_de_Computadores "Viendo que te gusta el hardware, una eleccion que te podría interesar es la rama de Ingenieria de Computadores." "JOSEMI"))
)

(defrule recomendacion_csi_seguro
  (declare (salience -100))
  (me_gusta matematicas SI)
  (me_gusta hardware NO)
  =>
  (assert (Rama Computacion_y_Sistemas_Inteligentes))
  (assert (consejo Computacion_y_Sistemas_Inteligentes "Viendo que te gustan las matematicas y no el hardware, una eleccion que te podría interesar es la rama de Computacion y Sistemas Inteligentes." "JOSEMI"))
)

(defrule recomendacion_ti_seguro
  (declare (salience -100))
  (me_gusta matematicas NO)
  (me_gusta hardware NO)
  =>
  (assert (Rama Tecnologias_de_la_Informacion))
  (assert (consejo Tecnologias_de_la_Informacion "Viendo que no te gustan las matematicas ni el hardware, una eleccion que te podría interesar es la rama de Tecnologias de la Informacion." "JOSEMI"))
)


















;consejo final
(defrule consejo
    (declare (salience 9999))
    (aconsejar ?rama)
    (consejo ?rama ?texto)    
    =>    
    (assert (aconsejado))
    (printout t "Te aconsejo la rama " ?rama " " ?texto crlf)
)

;consejo final
(defrule consejo2
    (declare (salience 9999))
    (Rama ?rama)
    (consejo ?rama ?motivo ?experto)
    
    =>
    (assert (aconsejado))
    (printout t "Te aconsejo la rama " ?rama " " ?motivo crlf)
)


(defrule consejo3
    (declare (salience -9999))
    (not (aconsejado))
    =>
    (printout t "No hemos conseguido llegar a ninguna conclusión clara. Por esto te recomendamos la rama de Tecnologias de Informacion, puesto que es la mas facil de todas. " crlf)
)
