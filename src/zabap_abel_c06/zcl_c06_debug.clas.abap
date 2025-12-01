CLASS zcl_c06_debug DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_C06_DEBUG IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    "DEPURACIÓN"

    "En este tema veremos las herramientas que más vamos a utilizar si queremos hacer seguimiento de nuestro código."
    "El Depurador/Debugger sirve para analizar problemas en el código que se puedan presentar en tiempo de ejecución."

    "Si no conseguimos ver las variables ni el debugger lo que tenemos que hacer es ir a window -> preferences -> abap development -> debug y activar el primer botón."

    "Tenemos los llamados breakpoint que los añadimos para poder hacer pausas en nuestro código"
    "Luego de hacemos la inspección de variables en tiempo real y también podemos modificar las variables en tiempo de ejecución"

    "Podemos utilizar watchpoint para detectar cuándo cambia una variable y hacer el seguimiento paso a paso"

    "Esto solo lo haremos para hacer comprobaciones del código, no como producto final para el usuario"

    "Para deshabilitar breakpoint hacemos clic derecho sobre él y lo deshabilitamos"

    "Con las teclas de arriba en las funciones del depurador podemos hacer varias cosas:"
    "Terminate: Finaliza el debugger sin mostrar nada por consola que haya después del breakpoint"
    "Disconnect: Sí muestra resultado en la consola"
    "Skip All Breakpoints: omite todos los breakpoints
    "Resume (f8): El programa se ejecuta hasta encontrar otro breakpoint"
    "Step Over (f6): Ejecuta la siguiente instrucción del programa, pero si es una llamada a otro programa/función no entra en este detalle"
    "Step Into (f5): Sí entraría en detalle"
    "Step return (f7): Podemos volver al paso anterior por si quiero volver por ejemplo si pulsamos f5 y vemos detalles sin querer"
    "Run to Line (Shift+F8): La ejecución salta directamente hasta la línea donde está el cursor sin tener que ir paso a paso"
    "Move pointer (Shift+F12): La ejecución sigue corriendo normalmente hasta el siguiente breakpoint o hasta que termine el programa. No se detiene en cada línea"




    "SECCIÓN 1: DEMOSTRACIÓN DE F8 (CONTINUE/RESUME)"
    "Si por ejemplo ponemos un breakpoint en la siguiente línea la ejecución del código pararía ahí"
    out->write( |--- SECCIÓN 1: F8 (Continue) ---| ).


    DATA lv_inicio TYPE string VALUE 'Inicio del programa'.
    out->write( lv_inicio ).

    "Líneas que se ejecutarán cuando ejecutemos el programa"
    "Si pulso dos veces en la variable se mostrará en las variables del panel de debug"
    DATA lv_valor1 TYPE i VALUE 100.
    DATA lv_valor2 TYPE i VALUE 200.
    DATA lv_suma TYPE i.
    lv_suma = lv_valor1 + lv_valor2.


    "F8 en la línea del BP anterior -> saltará aquí directamente
    out->write( |Suma: { lv_suma }| ).


    "SECCIÓN 2: DEMOSTRACIÓN DE F6 (STEP OVER)"
    out->write( |--- SECCIÓN 2: F6 (STEP OVER) ---| ).

    DATA lt_flights TYPE TABLE OF /dmo/flight.

    "F6 -> Ejecuta el SELECT completo sin ver los detalles internos"
    "No entrará en el procesamiento interno del SELECT"
    SELECT * FROM /dmo/flight
        WHERE carrier_id = 'AA'
        INTO TABLE @lt_flights
        UP TO 3 ROWS.

    "F6 nuevamente -> Ejecuta el lines() sin entrar en él"
    DATA(lv_cantidad) = lines( lt_flights ).

    "F6 -> Ejecuta esta línea"
    out->write( |Vuelos encontrados: { lv_cantidad }| ).


    "SECCIÓN 3: DEMOSTRACIÓN DE F5 (STEP INTO)"
    out->write( |--- SECCIÓN 3: F5 (STEP INTO) ---| ).

    DATA lv_precio TYPE /dmo/flight_price VALUE 1000.

    "F5 -> Entrará en el constructor VALUE #()"
    "Verás el código interno de cómo ABAP construye la tabla"
    DATA(lt_precios) = VALUE string_table(
    ( |1500| )
    ( |2000| )
    ( |2500| )
    ).

    "F6 aquí (no F5) - Solo verás el resultado"
    DATA lv_total_precios TYPE i VALUE 0.
    LOOP AT lt_precios INTO DATA(lv_precio_str).
      lv_total_precios = lv_total_precios + lv_precio_str.
    ENDLOOP.


    "SECCIÓN 4: DEMOSTRACIÓN DE F7 (STEP RETURN)"
    out->write( |--- SECCIÓN 4: F7 (Step Return) ---| ).

    "Si en la sección 3 usaste f5 y entraste muy profundo en el código"
    "Presiona f7 -> Saldrás y volverás al nivel anterior"


    "SECCIÓN 5: DEMOSTRACIÓN DE shift+f8 (RUN TO LINE)"
    out->write( |--- SECCIÓN 5: shift+f8 (Run to Line) ---| ).

    DATA lv_contador TYPE i VALUE 0.

    "Estas líneas se ejecutarán cuando uses shift+f8"
    DO 10 TIMES.
      lv_contador = lv_contador + 1.
      "Imagina que aquí hay mucho código que funciona bien"
    ENDDO.

    "Cursos aquí (en la línea 123)"
    "En línea 123 presiono Ctrl+f8"
    "Ejecutará todo hasta aquí sin parar"
    out->write( |Contador después del loop: { lv_contador }| ).


    "SECCIÓN 6: DEMOSTRACIÓN DE shift+f12 (Move pointer)"
    out->write( |--- SECCIÓN 6: shift+f12 (Move pointer) ---| ).

    "Esta función es poderosa pero peligrosa"

    DATA lv_saldo TYPE i VALUE 1000.
    out->write( |Saldo inicial: { lv_saldo }| ).

    "PASO 2: Estás en línea 134"
    "La siguiente línea hará una resta"
    lv_saldo = lv_saldo - 500. "Línea 138"

    "PASO 3: Sin ejecutar línea 138, coloca CURSOR en línea 143"
    "Shift+f12"
    "Saltará la resta, lv_saldo seguirá siendo 1000"
    out->write( |Saldo después de "saltar" la resta: { lv_saldo }| ).



    "SECCIÓN 7: COMBINACIÓN DE TÉCNICAS"
    out->write( |--- SECCIÓN 7: Combinación ---| ).

    "Escenario real: Precesar una lista de vuelos"

    SELECT * FROM /dmo/flight
        WHERE carrier_id = 'LH'
        INTO TABLE @lt_flights
        UP TO 5 ROWS.

    "Presiona F6 -> Ejecuta el select"
    out->write( |Total vuelos: { lines( lt_flights ) }| ).

    "Procesar cada vuelo"
    DATA lv_vuelos_caros TYPE i VALUE 0.

    LOOP AT lt_flights INTO DATA(ls_flight).

      "Presiona F6 -> Avanza una iteración"
      "Presiona F8 -> Completa todo el loop"

      IF ls_flight-price > 500.
        lv_vuelos_caros = lv_vuelos_caros + 1.
      ENDIF.

    ENDLOOP.

    out->write( |Vuelos caros: { lv_vuelos_caros }| ).



    "SECCIÓN 8: DEBUGGING DE EXPRESIONES COMPLEJAS"
    out->write( |--- SECCIÓN 8: Expresiones complejas ---| ).

    DATA(lv_precio_max) = REDUCE /dmo/flight_price(
    INIT max = 0
    FOR flight IN lt_flights
    NEXT max = COND #( WHEN flight-price > max
                       THEN flight-price
                       ELSE max ) ).


    "F6 -> Ejecuta todo el REDUCE de una vez"

    out->write( |Precio máximo: { lv_precio_max }| ).

    "Corresponding con mapeo"
    DATA: BEGIN OF ls_flight_simple,
            carrier    TYPE /dmo/carrier_id,
            connection TYPE /dmo/connection_id,
            price      TYPE /dmo/flight_price,
          END OF ls_flight_simple.


    IF lines( lt_flights ) > 0.
      ls_flight_simple = CORRESPONDING #( lt_flights[ 1 ] ).
    ENDIF.

    "Presiona f5 -> entra en el corresponding"
    out->write( |Vuelo simplificado - Carrier: { ls_flight_simple-carrier }| ).

    "FINALIZACIÓN"
    "BREAKPOINT AQUÍ"
    "Presiona f8 -> termina el programa"
    out->write( |=== FIN DEL PROGRAMA ===| ).



  ENDMETHOD.
ENDCLASS.
