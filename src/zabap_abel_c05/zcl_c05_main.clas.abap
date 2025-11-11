CLASS zcl_c05_main DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_c05_main IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    "REF"
    "Obtenemos una referencia a datos o a objetos existentes sin necesidad de copiarlos"
    "Es decir, no crea nada nuevo, sino que apunta a lo que ya existe"

    TYPES: BEGIN OF ty_config,
             parametro TYPE string,
             valor     TYPE string,
           END OF ty_config.
    DATA lt_configuraciones TYPE TABLE OF ty_config.

    lt_configuraciones = VALUE #(
    ( parametro = 'max_usuarios' valor = '100' )
    ( parametro = 'timeout' valor = '30' )
    ( parametro = 'modo_debug' valor = 'ON' )
    ).

    out->write( |Ejemplo de REF - Obtener referencias| ).
    out->write( |====================================| ).

    "REF con tabla interna - referencia al segundo registro"
    DATA(lr_config) = REF #( lt_configuraciones[ 2 ] ).
    out->write( |Referencia al registro 2| ).
    out->write( |   Parámetro: { lr_config->parametro }| ).
    out->write( |   Valor: { lr_config->valor }| ).

    "Modificar a través de la referencia afecta al original"
    lr_config->valor = '60'.

    out->write( |Después de modificar vía referencia:| ).
    out->write( lt_configuraciones ).



    "CONV"
    out->write( |Ejemplo de CONV - Conversiones de tipo| ).
    out->write( |======================================| ).

    "CASO: Cálculo de precio sin IVA"
    DATA lv_precio TYPE p LENGTH 10 DECIMALS 2 VALUE '100.00'.
    DATA lv_iva TYPE p LENGTH 5 DECIMALS 2 VALUE '0.21'.

    "SIN CONV (necesitas variable auxiliar)"
    "DATA lv_mensaje TYPE string."
    "DATA lv_total_aux TYPE p LENGTH 10 DECIMALS 2."
    "lv_total_aux = lv_precio * ( 1 + lv_iva )."
    "lv_mensaje = lv_total_aux."

    "Con CONV (directo, sin variable auxiliar)"
    DATA(lv_mensaje) = |Precio final: { CONV string( lv_precio * ( 1 + lv_iva ) ) } EUR|.

    out->write( lv_mensaje ).

    "Otro ejemplo: convertir tabla SORTED a STANDARD"
    DATA lt_numeros_sorted TYPE SORTED TABLE OF i WITH NON-UNIQUE DEFAULT KEY.
    lt_numeros_sorted = VALUE #( ( 3 ) ( 1 ) ( 4 ) ( 1 ) ( 5 ) ).

    TYPES tt_numeros_standard TYPE STANDARD TABLE OF i WITH EMPTY KEY.
    DATA(lt_numeros_standard) = CONV tt_numeros_standard( lt_numeros_sorted ).

    out->write( |Tabla convertida de SORTED a STANDARD| ).
    out->write( lt_numeros_standard ).



    "EXACT"
    "Convierte únicamente si no hay una pérdida de datos, si no es exacta lanza una excepción"
    "EXACT en comparación al CONV es más seguro"
    "EXACT es como el CONV pero con una validación adicional"

    out->write( |Ejemplo de EXACT - Conversión segura| ).
    out->write( |====================================| ).

    "CASO: Validación de cantidad de stock"
    DATA lv_stock_float TYPE f VALUE '150.00'.

    TRY.
        "EXACT valida que no haya decimales antes de convertir"
        DATA(lv_stock_int) = EXACT i( lv_stock_float ).
        out->write( |Stock convertido correctamente: { lv_stock_int }| ).
      CATCH cx_sy_conversion_error INTO DATA(lx_error).
        out->write( |ERROR: { lx_error->get_text( ) }| ).
    ENDTRY.

    "Caso que falla"
    DATA lv_stock_decimal TYPE f VALUE '150.75'.

    TRY.
        lv_stock_int = EXACT i( lv_stock_decimal ).
        out->write( |Stock: { lv_stock_int }| ).
      CATCH cx_sy_conversion_error INTO lx_error.
        out->write( |ERROR: No se puede convertir 150.75 a entero sin perder datos| ).
    ENDTRY.



    "FILTER"
    "Podremos crear una tabla nueva con solo los registros que cumpla la condición que especifiquemos"

    "PASO 1: Definir la estructura de producto"
    TYPES: BEGIN OF ty_producto,
             codigo    TYPE string,
             nombre    TYPE string,
             precio    TYPE p LENGTH 10 DECIMALS 2,
             stock     TYPE i,
             en_oferta TYPE abap_bool,
           END OF ty_producto.


    "Paso 2: Declarar la tabla de inventario"
    "CLAVE: La clave debe incluir los campos que se van filtrar"
    "La clave que tenemos especificada en el tipo de tabla es completamente necesaria para que la utilicemos en la expresión FILTER"
    DATA lt_inventario TYPE SORTED TABLE OF ty_producto
        WITH NON-UNIQUE KEY en_oferta stock.

    "Paso 3: Llenar el inventario con datos"
    lt_inventario = VALUE #(
    ( codigo = 'LAP001' nombre = 'Laptop HP'        precio = 800 stock = 3  en_oferta = abap_true )
    ( codigo = 'MOU001' nombre = 'Mouse Logitech'   precio = 25  stock = 50 en_oferta = abap_true )
    ( codigo = 'TEC001' nombre = 'Teclado Mecánico' precio = 120 stock = 15 en_oferta = abap_true )
    ( codigo = 'MON001' nombre = 'Monitor Samsung'  precio = 300 stock = 8  en_oferta = abap_false )
    ( codigo = 'WEB001' nombre = 'Webcam HD'        precio = 60  stock = 2  en_oferta = abap_true )
    ( codigo = 'AUR001' nombre = 'Auriculares'      precio = 45  stock = 20 en_oferta = abap_false )
    ( codigo = 'IMP001' nombre = 'Impresora'        precio = 200 stock = 12 en_oferta = abap_true )
     ).

    "Mostrar inventario completo"
    out->write( |================================| ).
    out->write( |INVENTARIO COMPLETO DE LA TIENDA| ).
    out->write( |================================| ).
    out->write( |Total de productos: { lines( lt_inventario ) }| ).
    out->write( |\n| ).

    LOOP AT lt_inventario INTO DATA(ls_prod).
      DATA(lv_oferta_texto) = COND string( WHEN ls_prod-en_oferta = abap_true
                                           THEN 'EN OFERTA'
                                           ELSE '' ).

      "Aquí "formateamos" para que salgan en el mismo nivel los diferentes elementos o registros"
      "Por ejemplo aquí indicamos que en el nombre me dé un ancho de 20 para todos"
      out->write( |{ ls_prod-codigo } - { ls_prod-nombre WIDTH = 20 }| &&
                  |Precio: { ls_prod-precio WIDTH = 6 } EUR | &&
                  |Stock:  { ls_prod-stock  WIDTH = 3 } { lv_oferta_texto }| ).
    ENDLOOP.

    out->write( |\n| ).

    "Paso 4: Aplicar FILTER"
    out->write( |===============================| ).
    out->write( |FILTRADO: Ofertas con Stock > 5| ).
    out->write( |===============================| ).

    "FILTER"
    DATA(lt_productos_para_promocion) = FILTER #( lt_inventario
                                                  WHERE en_oferta = abap_true AND stock > 5 ).


    "Paso 5: Mostrar resultados filtrados"
    out->write( |Productos encontrados: { lines( lt_productos_para_promocion ) }| ).
    out->write( |\n| ).

    IF lt_productos_para_promocion IS NOT INITIAL.
      out->write( |Estos productos van a la campaña de email:| ).
      LOOP AT lt_productos_para_promocion INTO DATA(ls_promo).
        out->write( |{ ls_promo-nombre } - { ls_promo-precio } EUR (Stock: { ls_promo-stock })| ).
      ENDLOOP.
    ELSE.
      out->write( |No hay productos que cumplan con los criterios:| ).
    ENDIF.

    "Paso 6: Mostrar resultados filtrados"
    out->write( |\n| ).

    DATA(lv_valor_total) = REDUCE i( INIT sum = 0
                                      FOR prod IN lt_productos_para_promocion
                                      NEXT sum = sum + ( prod-precio * prod-stock ) ).

    out->write( |Valor total del inventario promocional: { lv_valor_total } EUR| ).




    "FIELD-SYMBOLS"
    "Actúa como un puntero que referencia directamente otra variable, permitiendo acceder o modificar su valor sin crear una copia."
    "Sirve para trabajar con datos de forma dinámica y eficiente en memoria.

    "EJERCICIO 1: Variable simple. Trabajando con un solo dato"

    "1. Crear variable normal"
    DATA lv_nombre TYPE string VALUE 'Abel'.
    out->write( |Variable original { lv_nombre }| ).


    "2. Declarar Field Symbol"
    FIELD-SYMBOLS <fs_nombre> TYPE string.


    "3. Conectar el Field Symbol con ASSIGN"
    ASSIGN lv_nombre TO <fs_nombre>.
    out->write( |Field Symbol: { <fs_nombre> }| ).


    "4. Cambiar valor a través de Field Symbol"
    <fs_nombre> = 'González'.


    out->write( |Después de cambiar FS: { <fs_nombre> }| ).
    out->write( |Variable original: { lv_nombre }| ).
    out->write( |\n Conclusión: Ambos cambiaron porque el FS apunta a lv_nombre| ).



    "EJERCICIO 2: Tabla de números. Para múltiples registros"
    DATA lt_numeros TYPE TABLE OF i WITH EMPTY KEY.

    lt_numeros = VALUE #( ( 10 ) ( 20 ) ( 30 ) ).
    out->write( |Tabla original: 10, 20, 30| ).
    out->write( |\n Multiplicar x2 con Field Symbol: | ).

    "Declarar Field Symbol"
    FIELD-SYMBOLS <fs_num> TYPE i.

    "Con ASSIGN (Sí funciona)"
    LOOP AT lt_numeros ASSIGNING <fs_num>. "Con estructura tendría que cargar cambios con APPEND"
      <fs_num> = <fs_num> * 2.
    ENDLOOP.

    out->write( |Resultado: { lt_numeros[ 1 ] }, { lt_numeros[ 2 ] }, { lt_numeros[ 3 ] } | ).
    out->write( | Sí cambió porque FS apunta al original| ).



    "EJERCICIO 3: Declaración en línea FS"
    "Leer vuelos de la tabla demo"
    out->write( |=========================| ).
    out->write( | DESCUENTO 10% EN VUELOS| ).
    out->write( |=========================| ).
    out->write( |\n| ).

    SELECT FROM /dmo/flight
            FIELDS carrier_id,
                   connection_id,
                   flight_date,
                   price,
                   currency_code
            WHERE carrier_id = 'AA'
            INTO TABLE @DATA(lt_flights)
            UP TO 5 ROWS.


    IF lt_flights IS INITIAL.
      out->write( |No hay vuelos| ).
      RETURN.
    ENDIF.

    out->write( |Antes del descuento:| ).

    LOOP AT lt_flights INTO DATA(ls_flight).
      out->write( |{ ls_flight-carrier_id } { ls_flight-connection_id } - { ls_flight-price } { ls_flight-currency_code } | ).
    ENDLOOP.

    "Aplicar descuento con FS en línea"
    out->write( |\n| ).
    out->write( |Aplicando 10% de descuento...| ).
    out->write( |\n| ).


    "Declaración en línea"
    LOOP AT lt_flights ASSIGNING FIELD-SYMBOL(<flight>).
      DATA(lv_precio_anterior) = <flight>-price.
      <flight>-price = <flight>-price * '0.90'.
      out->write( |{ <flight>-carrier_id } { <flight>-connection_id }: { lv_precio_anterior } -> { <flight>-price }| ).
    ENDLOOP.


    out->write( |\n Descuento aplicado directamente| ).



    "EJERCICIO 4: Realizar cambios de forma masiva en las tablas internas"
    "Actualizar emails de clientes"
    out->write( |==========================| ).
    out->write( | ACTUALIZAR DOMINIO EMAIL| ).
    out->write( |==========================| ).

    SELECT FROM /dmo/customer
        FIELDS customer_id,
               first_name,
               last_name,
               email_address
        WHERE email_address LIKE '%@flight.example.de' "Puede encontrar cualquier carácter antes del arroba (@) usando el comodín "%"
        INTO TABLE @DATA(lt_customers)
        UP TO 5 ROWS.


    IF lt_customers IS INITIAL.
      out->write( |No hay clientes con @flight.example| ).
      RETURN.
    ENDIF.

    out->write( |Clientes encontrados: { lines( lt_customers ) }| ).
    out->write( |\n| ).


    "Actualizar con FIELD SYMBOL en línea"
    LOOP AT lt_customers ASSIGNING FIELD-SYMBOL(<customer>).
      DATA(lv_email_viejo) = <customer>-email_address.
      "Cambiar dominio"
      <customer>-email_address = replace(
        val = <customer>-email_address
        sub = 'flight.example.de'
        with = 'empresa.com'
      ).

      out->write( |{ <customer>-first_name } { <customer>-last_name }:| ).
      out->write( | Antes: { lv_email_viejo }| ).
      out->write( | Ahora: { <customer>-email_address }| ).
      out->write( |\n| ).

    ENDLOOP.


  ENDMETHOD.

ENDCLASS.
