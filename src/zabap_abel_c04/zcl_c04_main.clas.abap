CLASS zcl_c04_main DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.



    "Estructura para datos de empleado"
    TYPES: BEGIN OF ty_employee,
             id            TYPE n LENGTH 8,
             first_name    TYPE c LENGTH 40,
             last_name     TYPE c LENGTH 40,
             email         TYPE c LENGTH 40,
             phone_number  TYPE c LENGTH 20,
             salary        TYPE p LENGTH 8 DECIMALS 2,
             currency_code TYPE c LENGTH 3,
           END OF ty_employee.

    "Tipo de tabla para usar con VALUE"
    TYPES ty_t_employees TYPE STANDARD TABLE OF ty_employee
    WITH EMPTY KEY.

ENDCLASS.



CLASS zcl_c04_main IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.


*    "Estructura: molde o plantilla de un registro. Define qué campos tiene y de qué tipo son."
*    TYPES: BEGIN OF ty_persona,
*             nombre TYPE string,
*             edad   TYPE i,
*           END OF ty_persona.


    "Registro: instancia de esa estructura. O sea, un objeto concreto con valores."
*    DATA(ls_persona) = VALUE ty_persona( nombre = 'Juan' edad = 30 ).


    "Tabla interna: colección de registros del mismo tipo. O sea, una lista de estructuras."
*    DATA lt_personas TYPE TABLE OF ty_persona.

*    lt_personas = VALUE #(
*      ( nombre = 'Pedro' edad = 35 )
*      ( nombre = 'María' edad = 25 )
*      ( nombre = 'Luis'  edad = 40 )
*    ).

    "Campos: columnas dentro de una estructura."
    "Ejemplo: nombre y edad son campos."


    "Tipos de tablas internas"

    "STANDARD TABLE"
    "Sin orden automático. Puede tener registros duplicados. Búsqueda lenta (secuencial)."
    "Se usa para recorrer o almacenar listas simples."
    "DATA lt_tabla TYPE STANDARD TABLE OF ty_persona."


    "SORTED TABLE"
    "Siempre ordenada por la clave primaria. Puede ser UNIQUE o NON-UNIQUE. Búsqueda más rápida (binaria)."
    "DATA lt_tabla TYPE SORTED TABLE OF ty_persona WITH UNIQUE KEY nombre."


    "HASHED TABLE"
    "Parecida a un “diccionario” o “mapa” en otros lenguajes. Solo admite claves únicas. Búsqueda muy rápida (hash)."
    "No puedes recorrerla con índice (INDEX), solo por clave."
    "DATA lt_tabla TYPE HASHED TABLE OF ty_persona WITH UNIQUE KEY nombre."



    out->write( '===========================================' ).
    out->write( '     SISTEMA DE GESTIÓN DE EMPLEADOS     ' ).
    out->write( '===========================================' ).

    "ESCENARIO 1: CARGA INICIAL DEL MES"
    "Usar VALUE cuando tenemos varios registros predefinidos"

    out->write( '--- ESCENARIO 1: Carga inicial del mes ---' ).
    out->write( 'RR.HH. Tiene 3 empleados nuevos que empiezan hoy' ).
    out->write( | | ).

    "VALUE permite crear la tabla con todos los datos de una vez"
    "Cada par de paréntesis internos representa un empleado"
    DATA(lt_empleados_mes) = VALUE ty_t_employees(
     ( id = '00000001'
     first_name = 'Carlos'
     last_name = 'García'
     email = 'carlos.garcia@empresa.com'
     phone_number = '+34 643654348'
     salary = '2500.00'
     currency_code = 'EUR' )
    ( id = '00000002'
     first_name = 'Ana'
     last_name = 'Martínez'
     email = 'ana.martinez@empresa.com'
     phone_number = '+34 675843398'
     salary = '2800.00'
     currency_code = 'EUR' )
     ( id = '00000003'
     first_name = 'Luis'
     last_name = 'Rodríguez'
     email = 'luis.rodriguez@empresa.com'
     phone_number = '+34 746338921'
     salary = '2600.00'
     currency_code = 'EUR' )
    ).

    out->write( 'Empleados cargados con VALUE:' ).
    out->write( | | ).

    "Mostramos los empleados cargados"
    LOOP AT lt_empleados_mes INTO DATA(ls_emp).
      out->write( |{ ls_emp-id } - { ls_emp-first_name } { ls_emp-last_name }| ).
    ENDLOOP.
    out->write( | | ).
    out->write( 'VALUE es ideal para carga inicial' ).
    out->write( 'Porque podemos definir todos los registros de una vez' ).
    out->write( | | ).
    out->write( | | ).

    "ESCENARIO 2: LLEGA UN DIRECTOR QUE DEBE IR PRIMERO"
    "Usar INSERT cuando necesitamos posición específica"

    out->write( '--- ESCENARIO 2: Llega el nuevo director ---' ).
    out->write( 'Debe aparecer en la primera posición de la lista' ).
    out->write( | | ).

    "Forma clásica: usando estructura intermedia"
    DATA ls_director TYPE ty_employee.
    ls_director-id = '00000004'.
    ls_director-first_name = 'María'.
    ls_director-last_name = 'Fernández'.
    ls_director-email = 'maria.fernandez@empresa.com'.
    ls_director-phone_number = '+34 664379213'.
    ls_director-salary = '4500.00'.
    ls_director-currency_code = 'EUR'.

    "INSERT permite especificar la posición INDEX 1 = primera posición"
    INSERT ls_director INTO lt_empleados_mes INDEX 1.
    out->write( 'Director insertado en la primera posición con INSERT' ).
    out->write( | | ).
    out->write( 'Lista actualizada:' ).
    out->write( | | ).

    LOOP AT lt_empleados_mes INTO ls_emp.
      IF sy-tabix = 1.
        out->write( | { ls_emp-id } - { ls_emp-first_name } { ls_emp-last_name } (DIRECTOR) | ).
      ELSE.
        out->write( | { ls_emp-id } - { ls_emp-first_name } { ls_emp-last_name } | ).
      ENDIF.
    ENDLOOP.

    out->write( | | ).
    out->write( 'INSERT es ideal para posiciones específicas' ).

    "ESCENARIO 3: VAN LLEGANDO SOLICITUDES DURANTE EL DÍA"
    "Usar APPEND para ir agregando al final"

    out->write( '--- ESCENARIO 3: Solicitudes durante el día ---' ).
    out->write( 'Cada solicitud se agrega al final de la cola' ).
    out->write( | | ).

    "APPEND siempre agrega al final de la tabla"
    "Es más rápido que INSERT cuando no importa la posición"
    "Primera solicitud del día - usando estructura"
    "SÓLO FUNCIONA CON LAS TABLAS INTERNAS STANDAR"
    "Sintaxis antigua"
    DATA ls_nuevo_empleado TYPE ty_employee.
    ls_nuevo_empleado-id = '00000005'.
    ls_nuevo_empleado-first_name = 'Roberto'.
    ls_nuevo_empleado-last_name = 'Jiménez'.
    ls_nuevo_empleado-email = 'roberto.jimenez@empresa.com'.
    ls_nuevo_empleado-phone_number = '+34 645829382'.
    ls_nuevo_empleado-salary = '2400.00'.
    ls_nuevo_empleado-currency_code = 'EUR'.

    APPEND ls_nuevo_empleado TO lt_empleados_mes.
    out->write( 'Solicitud 1: Roberto agregado al final con APPEND' ).

    "Segunda solicitud usando VALUE # directamente"
    "Esta es la sintaxis nueva recomendada a usar"
    APPEND VALUE #(
    id = '00000006'
    first_name = 'Laura'
     last_name = 'López'
     email = 'laura.lopez@empresa.com'
     phone_number = '+34 774983128'
     salary = '2700.00'
     currency_code = 'EUR'
     ) TO lt_empleados_mes.

    out->write( 'Solicitud 2: Laura agregada al final con APPEND' ).
    out->write( | | ).
    out->write( 'Lista final completa:' ).

    LOOP AT lt_empleados_mes INTO ls_emp.
      out->write( |{ sy-tabix }. { ls_emp-id } - {
      ls_emp-first_name } { ls_emp-last_name } | &&
      |({ ls_emp-salary } { ls_emp-currency_code }) | ).

    ENDLOOP.
    out->write( | | ).



    "CORRESPONDING"
    "Sirve para copiar datos entre estructuras o tablas internas que tienen algunos campos con el mismo nombre
    "aunque no tengan la misma estructura completa."
    "DEMOSTRACIÓN 1: Copia básica de campos coincidentes"
    "Definimos un tipo local con solo los campos que necesitamos"
    "La tabla origen /dmo/flight tiene muchos más campos, pero solo queremos trabajar con estos tres"

    "/dmo/ solo se usa para prácticas y ejemplos. En proyectos reales se usan tus propias tablas y campos
    "(por ejemplo z_empleados, z_ventas, etc.)"
    TYPES: BEGIN OF lty_flights,
             carrier_id    TYPE /dmo/carrier_id,
             connection_id TYPE /dmo/connection_id,
             flight_date   TYPE /dmo/flight_date,
           END OF lty_flights.

    " Declaro gt_my_flights como tabla interna (varios registros) del tipo lty_flights y gs_my_flight como una
    "fila/estructura de ese tipo."
    DATA: gt_my_flights TYPE STANDARD TABLE OF lty_flights,
          gs_my_flight  TYPE lty_flights.

    "Obtenemos todos los vuelos en EUR de la base de datos"
    "Ejecuta una consulta DB que trae todas las columnas de /dmo/flight donde currency_code = 'EUR'
    "y guarda el resultado completo en la tabla interna gt_flights"
    SELECT FROM /dmo/flight
    FIELDS *
    WHERE currency_code EQ 'EUR'
    INTO TABLE @DATA(gt_flights).


    out->write( '============================================' ).
    out->write( 'CASO 1: Copia básica con campos coincidentes' ).
    out->write( '============================================' ).
    out->write( | | ).
    "Informa cuántos registros (filas) tiene la tabla origen gt_flights"
    out->write( |Tabla origen tiene { lines( gt_flights ) } registros con TODOS los campos| ).

    "FORMA ANTIGUA: Usando MOVE-CORRESPONDING"
    "MOVE-CORRESPONDING gt_flights TO gt_my_flights."

    "FORMA MODERNA"
    "Copiamos desde gt_flights solo los campos que existen en lty_flights (por nombre y tipo) y devuelve una tabla
    "gt_my_flights con esos registros simplificados"
    gt_my_flights = CORRESPONDING #( gt_flights ).

    "Muestra cuántos registros quedaron en gt_my_flights y luego imprime el contenido"
    out->write( |Resultado: { lines( gt_my_flights ) } registros copiados| ).
    out->write( gt_my_flights ).

    "DEMOSTRACIÓN 2: Agregar registros sin borrar los existentes"
    "Imaginemos que gt_my_flights ya tiene datos y queremos agregar más registros sin perder los que teníamos"
    "Esto es muy común cuando acumulamos datos de diferentes fuentes"

    out->write( '================================================' ).
    out->write( 'CASO 2: Agregar datos conservando los existentes' ).
    out->write( '================================================' ).
    out->write( | | ).

    "Primero llamamos gt_my_flights con algunos vuelos en EUR"
    SELECT FROM /dmo/flight
        FIELDS *
        WHERE currency_code EQ 'EUR'
        INTO TABLE @gt_flights
        UP TO 3 ROWS.
    gt_my_flights = CORRESPONDING #( gt_flights ).
    out->write( |Comenzamos con { lines( gt_my_flights ) } vuelos en EUR| ).
    out->write( gt_my_flights ).
    out->write( | | ).

    "Ahora obtenemos vuelos en USD y queremos agregarlos"
    SELECT FROM /dmo/flight
        FIELDS *
        WHERE currency_code EQ 'USD'
        INTO TABLE @gt_flights
        UP TO 3 ROWS.
    out->write( |Queremos agregar { lines( gt_flights ) } vuelos en USD| ).
    out->write( | | ).

    CLEAR gt_my_flights.
    SELECT FROM /dmo/flight
        FIELDS *
        WHERE currency_code EQ 'EUR'
        INTO TABLE @DATA(gt_flights_eur)
        UP TO 3 ROWS.
    gt_my_flights = CORRESPONDING #( gt_flights_eur ).

    gt_my_flights = CORRESPONDING #( BASE ( gt_my_flights ) gt_flights ).
    out->write( |Resultado: Ahora tenemos { lines( gt_my_flights ) } vuelos totales| ).
    out->write( |Los 3 primeros EUR se conservan + 3 USD se agregaron| ).
    out->write( gt_my_flights ).


    "DEMOSTRACIÓN 3: Mapeo de campos con nombres diferentes"

    "¿Qué pasa si los campos tienen información similar pero con nombres diferentes?"
    "Aquí necesitamos hacer un mapeo manual"
    out->write( '================================================' ).
    out->write( 'CASO 3: MAPEO DE CAMPOS CON NOMBRES DIFERENTES' ).
    out->write( '================================================' ).
    out->write( | | ).

    "Definimos un tipo donde los campos se llaman diferente"
    TYPES: BEGIN OF lty_flights_renamed,
             carrier    TYPE /dmo/carrier_id,       "En origen: carrier_id"
             connection TYPE /dmo/connection_id,    "En origen: connection_id"
             date       TYPE /dmo/flight_date,      "En origen: flight_date"
           END OF lty_flights_renamed.
    DATA gt_flights_renamed TYPE STANDARD TABLE OF lty_flights_renamed.

    "Obtenemos datos origen"
    SELECT FROM /dmo/flight
        FIELDS *
        WHERE currency_code EQ 'EUR'
        INTO TABLE @gt_flights
        UP TO 5 ROWS.
    out->write( |Tabla origen tiene campos: carrier_id, connection_id, flight_date| ).
    out->write( |Tabla destino tiene campos: carrier, connection, date| ).
    out->write( |Los nombres no coinciden pero la información es la misma| ).
    out->write( | | ).

    "Con CORRESPONDING necesitamos usar MAPPING para indicar qué campo origen corresponde a qué campo destino"
    gt_flights_renamed = CORRESPONDING #( gt_flights MAPPING carrier    = carrier_id
                                                             connection = connection_id
                                                             date       = flight_date ).

    out->write( |Usamos MAPPING para relacionar los campos| ).
    out->write( |Resultado con campos mapeados:| ).
    out->write( gt_flights_renamed ).



    "Buscar y recuperar registros en las tablas internas"
    "READ TABLE"
    "POR ÍNDICE: siempre rápido. Usar si se conoce la posición"
    "POR CLAVE en tabla STANDARD: solo para tablas pequeñas"
    "POR CLAVE en tabla SORTED/HASHED: siempre usa KEY primary_key"
    "OPTIONAL: para evitar errores si el registro puede no existir"

    "Obtenemos datos de aeropuertos para trabajar"
    SELECT FROM /dmo/airport
        FIELDS *
        WHERE country EQ 'DE'
        INTO TABLE @DATA(lt_airports).
    "Cuando hacemos declaraciones en línea de tablas internas siempre son declaradas como tablas STANDARD"

    "Los otros tipos de tabla se definen así:"
    "DATA ls_airports_sort TYPE SORTED TABLE OF /dmo/airport WITH UNIQUE KEY city."
    "DATA ls_airports_sort TYPE SORTED TABLE OF /dmo/airport WITH NON-UNIQUE KEY city."

    "En este caso solo se permite campos únicos"
    "DATA ls_airports_hash TYPE HASHED TABLE OF /dmo/airport WITH UNIQUE KEY city."


    "El IF es como una manera de comprobar cómo yo sé que la lectura me dio un resultado satisfactorio"
    IF sy-subrc EQ 0.

      "CASO 1: LECTURA POR ÍNDICE (posición)"
      out->write( '=============================================' ).
      out->write( 'CASO 1: Acceso por índice (muy rápido siempre' ).
      out->write( '=============================================' ).

      "Forma moderna: expresión de tabla con corchetes"
      DATA(ls_airport) = lt_airports[ 1 ].
      out->write( ls_airport ).

      "Si el índice puede que no existir, usar OPTIONAL"
      "Con optional no falla si no existe el índice"
      DATA(ls_safe) = VALUE #( lt_airports[ 999 ] OPTIONAL ).


      "CASO 2: LECTURA POR CLAVE (campo específico)"
      out->write( '=======================================================' ).
      out->write( 'CASO 2: Acceso por CAMPO (lento si hay muchos registros' ).
      out->write( '=======================================================' ).

      "Forma moderna"
      DATA(ls_munich) = lt_airports[ city = 'Munich' ].
      out->write( ls_munich ).

      "Acceso directo a un componente específico"
      DATA(lv_name) = lt_airports[ city = 'Hamburg' ]-name.
      out->write( |Resultado: { lv_name }| ).


      "CASO 3: LECTURA OPTIMIZADA CON TABLA SORTED"
      out->write( '==========================================' ).
      out->write( 'CASO 3: Acceso optimizado con tabla SORTED' ).
      out->write( '==========================================' ).

      DATA gt_sorted TYPE SORTED TABLE OF /dmo/airport
        WITH NON-UNIQUE KEY airport_id.

      SELECT FROM /dmo/airport
      FIELDS *
      INTO TABLE @gt_sorted.

      "IMPORTANTE: especificar KEY primary_key para usar optimización"
      DATA(ls_fast) = gt_sorted[ KEY primary_key airport_id = 'FRA' ].
      out->write( ls_fast ).

    ENDIF.



    "FOR para tablas internas"
    TYPES: BEGIN OF ty_producto,
             id        TYPE i,
             nombre    TYPE string,
             precio    TYPE p LENGTH 10 DECIMALS 2,
             categoria TYPE string,
           END OF ty_producto.

    TYPES: BEGIN OF ty_producto_con_descuento,
             id              TYPE i,
             nombre          TYPE string,
             precio_original TYPE p LENGTH 10 DECIMALS 2,
             descuento       TYPE i,
             precio_final    TYPE p LENGTH 10 DECIMALS 2,
           END OF ty_producto_con_descuento.

    DATA lt_productos TYPE TABLE OF ty_producto.

    DATA lt_productos_descuento TYPE TABLE OF ty_producto_con_descuento.

    "Generación de datos"
    "CASO 1: Generar catálogo de productos con FOR UNTIL"
    out->write( |CASO 1: Generar productos automáticamente| ).
    out->write( '=========================================' ).

    "Con FOR (forma moderna - una sola expresión)"
    lt_productos = VALUE #(
    FOR i = 1 UNTIL i > 10
    ( id = i
      nombre = |Producto { i }|
      precio = 100 + ( i * 20 )
      categoria = COND #( WHEN i <= 5 THEN 'Básico' ELSE 'Premium' ) ) ).
    "COND es como una condición. Mientras i sea menor o igual a 5 la categoría será básica"

    out->write( |Generados { lines( lt_productos ) } productos| ).
    out->write( lt_productos ).
    out->write( |\n| ).



    "Modificación de datos"
    "CASO 2: Aplicar descuento a todos con FOR...IN)
    out->write( |CASO 2: Aplicar descuentos según precio| ).
    out->write( '=======================================' ).

    "Con FOR (forma moderna con COND)"
    "Creo variables auxiliar (variables temporales) con LET, y con el COND hacemos la transformación a número entero"
    "Cuando el campo de precio de ls_prod sea mayor o igual a 200 entonces el descuento es de 20"
    "Si es mayor o igual a 150 el descuento será de 15"
    "Si no cumple ni una condición ni otra pues aplicará el descuento de 10"
    "la variable de descuento será según la condición que cumpla el precio"
    lt_productos_descuento = VALUE #( FOR ls_prod IN lt_productos
                                        LET descuento_aplicado = COND i( WHEN ls_prod-precio >= 200 THEN 20
                                           WHEN ls_prod-precio >= 150 THEN 15
                                           ELSE 10 ) IN
                                           ( id = ls_prod-id
                                           nombre = ls_prod-nombre
                                           precio_original = ls_prod-precio
                                           descuento = descuento_aplicado
                                           precio_final = ls_prod-precio * ( 100 - descuento_aplicado ) / 100 ) ).

    out->write( |Todos los productos con descuento aplicado:| ).

    "Ahora para mostrar la información iteramos sobre los productos con un LOOP"
    LOOP AT lt_productos_descuento INTO DATA(ls_desc).
      out->write( |{ ls_desc-nombre }: { ls_desc-precio_original } EUR -> { ls_desc-precio_final } EUR({ ls_desc-descuento }%| ).
    ENDLOOP.
    out->write( |\n| ).



    "CASO 3: Filtrar solo productos Premium con FOR...IN WHERE)"
    out->write( |CASO 3: Reporte solo de productos Premium| ).
    out->write( '=========================================' ).

    DATA lt_solo_premium TYPE TABLE OF ty_producto.

    lt_solo_premium = VALUE #( FOR ls_prod IN lt_productos
                        WHERE ( categoria = 'Premium' )
                        ( ls_prod ) ).

    out->write( |Productos Premium: { lines( lt_solo_premium ) } de { lines( lt_productos ) }| ).
    out->write( lt_solo_premium ).
    out->write( |\n| ).



    "Ordenación de los registros en los registros de las tablas internas"
    "SORT: Por defecto siempre se ordena de manera ascendente, a no ser que se lo indiquemos"
    "Esto solo aplica para tablas STANDARD y HASH"

    "Para el siguiente ejercicio vamos a obtener la información desde una vista CDS del estándar de SAP"
    "Este objeto nos lo ofrece SAP para practicar"
    DATA lt_vuelos TYPE STANDARD TABLE OF /DMO/I_Flight
    WITH NON-UNIQUE KEY AirlineID ConnectionID FlightDate.

    SELECT FROM /DMO/I_Flight
        FIELDS AirlineID, ConnectionID, FlightDate, Price, CurrencyCode
        WHERE CurrencyCode = 'EUR'
        INTO TABLE @lt_vuelos
        UP TO 10 ROWS.

    out->write( |Datos originales sin ordenar:| ).
    out->write( lt_vuelos ).
    out->write( |\n| ).


    "CASO 1: SORT con clave primaria (ascendente por defecto)"
    out->write( |CASO 1: Ordenar por clave primaria| ).
    out->write( '==================================' ).

    SORT lt_vuelos.
    out->write( |Después de SORT (Clave primaria ascendente| ).
    out->write( lt_vuelos ).
    out->write( |\n| ).


    "CASO 2: SORT DESCENDING (Orden inverso)"
    out->write( |CASO 2: Orden descendente| ).
    out->write( '=========================' ).

    SORT lt_vuelos DESCENDING.
    out->write( |Después de SORT DESCENDING| ).
    out->write( lt_vuelos ).
    out->write( |\n| ).


    "CASO 3: SORT BY campo específico"
    out->write( |CASO 3: Orden por campo específico (FlightDate)| ).
    out->write( '===============================================' ).

    "Ordenar solo por la fecha de vuelo)"
    SORT lt_vuelos BY FlightDate.
    out->write( |Ordenado por FlightDate ascendente:| ).
    LOOP AT lt_vuelos INTO DATA(ls_vuelo).
      out->write( |{ ls_vuelo-AirlineId }{ ls_vuelo-ConnectionID } - { ls_vuelo-FlightDate } - { ls_vuelo-Price } { ls_vuelo-CurrencyCode }| ).
    ENDLOOP.
    out->write( |\n| ).


    "CASO 4: SORT BY campo descendente"
    out->write( |CASO 4: Orden por precio (más caro primero)| ).
    out->write( '===========================================' ).

    "Ordenar por precio de mayor a menor"
    SORT lt_vuelos BY Price DESCENDING.
    out->write( |Ordenado por Price descendente:| ).
    LOOP AT lt_vuelos INTO ls_vuelo.
      out->write( |{ ls_vuelo-AirlineId }{ ls_vuelo-ConnectionID } - Precio: { ls_vuelo-Price } { ls_vuelo-CurrencyCode }| ).
    ENDLOOP.
    out->write( |\n| ).


    "CASO 5: SORT múltiples campos con diferentes direcciones"
    out->write( |CASO 5: Orden por varios campos| ).
    out->write( '===============================' ).

    "Primero por aerolínea (ascendente), luego por precio (descendente)"
    SORT lt_vuelos BY AirlineID ASCENDING
                      Price     DESCENDING.
    out->write( |Ordenado por CarrierID (asc) y luego Price (desc):| ).
    LOOP AT lt_vuelos into ls_vuelo.
        out->write( |{ ls_vuelo-AirlineID } - { ls_vuelo-ConnectionID } - { ls_vuelo-Price } EUR| ).
    ENDLOOP.
    out->write( |\n| ).









  ENDMETHOD.

ENDCLASS.
