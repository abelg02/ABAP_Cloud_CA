CLASS zcl_c03_main DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_c03_main IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    "Expresiones Lógicas"
    " =  EQ (igual)"
    " <> NE (diferente)"
    " <  LT (menor que)"
    " <= LE (menor o igual)"
    " >  GT (mayor que)"
    " >= GE (mayor o igual)"

    "NOT - Niega la expresión, (invierte) el resultado de una condición. Si algo es verdadero lo vuelve falso y viceversa."
    "AND - Ambas condiciones deben ser verdaderas. Todas las condiciones deben cumplirse para que el resultado sea verdadero."
    "OR  - Al menos una condición debe ser verdadera. Solo hace falta que una condición sea verdadera para que todo sea verdadero."
    "Si se combinan las tres expresiones primero se evalua "NOT", luego "AND" y por último "OR""

    DATA(num1) = 10.
    DATA(num2) = 20.

    " EQ / NE / LT / LE / GE "
    IF num1 EQ 10.
      out->write( 'num1 es igual a 10' ).
    ELSE.
      out->write( 'num1 NO es igual a 10' ).
    ENDIF.

    IF num1 NE num2.
      out->write( 'num1 y num2 son diferentes' ).
    ELSE.
      out->write( 'num1 y num2 son iguales' ).
    ENDIF.

    IF num1 LT num2.
      out->write( 'num1 es menor que num2' ).
    ELSE.
      out->write( 'num1 NO es menor que num2' ).
    ENDIF.

    IF num2 GE 20.
      out->write( 'num2 es mayor o igual a 20' ).
    ELSE.
      out->write( 'num2 es menor que 20' ).
    ENDIF.


    " NOT / AND / OR "
    IF NOT num1 EQ 5.
      out->write( 'num1 NO es igual a 5' ).
    ELSE.
      out->write( 'num1 es igual a 5' ).
    ENDIF.

    IF num1 LT 15 AND num2 GT 15.
      out->write( 'Ambas condiciones son verdaderas' ).
    ELSE.
      out->write( 'Al menos una condición es falsa' ).
    ENDIF.

    IF num1 EQ 10 OR num2 EQ 10.
      out->write( 'Al menos una condición es verdadera' ).
    ELSE.
      out->write( 'Ninguna condición es verdadera' ).
    ENDIF.


    " Prioridad: NOT → AND → OR "
    "ABAP lo interpreta así: ((NOT num1 EQ 5) AND (num2 EQ 20)) OR (num1 EQ 0)"
    IF NOT num1 EQ 5 AND num2 EQ 20 OR num1 EQ 0.
      out->write( 'La condición compuesta es verdadera' ).
    ELSE.
      out->write( 'La condición compuesta es falsa' ).
    ENDIF.



    "Estructuras de control:"

    "Bifurcaciones (IF, CASE, SWITCH, COND)"
    "Bucles (DO, WHILE, LOOP, FOR)"
    "Control de flujo (CHECK)"
    "Manejo de excepciones (TRY-CATCH)"

    "IF"
    DATA(lv_monto_compra) = 1500.
    DATA(lv_descuento) = 0.

    IF lv_monto_compra >= 1000.
      lv_descuento = 10. "10% de descuento"
      out->write( |Monto: { lv_monto_compra } - Descuento: { lv_descuento }%| ).
    ELSEIF lv_monto_compra >= 500.
      lv_descuento = 5. "5% de descuento"
      out->write( |Monto: { lv_monto_compra } - Descuento: { lv_descuento }%| ).
    ELSE.
      out->write( |Monto: { lv_monto_compra } - Sin descuento| ).
    ENDIF.



    "CASE - Determinar estado de orden de compra"
    DATA(lv_estado_orden) = 'A'. "A=Aprobada, P=Pendiente, R=Rechazada, E=Entregada"

    out->write( '=== CASE: ESTADO DE ORDEN DE COMPRA ===' ).

    CASE lv_estado_orden.
      WHEN 'A'.
        out->write( 'Estado: APROBADA - Proceder con la entrega' ).
      WHEN 'P'.
        out->write( 'Estado: PENDIENTE - Esperando aprobación' ).
      WHEN 'R'.
        out->write( 'Estado: RECHAZADA - Contactar con compras' ).
      WHEN 'E'.
        out->write( 'Estado: ENTREGADA - Orden completada' ).
      WHEN OTHERS.
        out->write( 'Estado: DESCONOCIDO - Verificar sistema' ).
    ENDCASE.
    out->write( | | ).



    "SWITCH: CATEGORÍA DE PRODUCTO SEGÚN CÓDIGO"
    DATA(lv_codigo) = 'B'.
    "La almohadilla "#" infiere el tipo de la variable automáticamente según el valor que voy a asignar. En este caso string”.
    DATA(lv_categoria) = SWITCH #( lv_codigo
      WHEN 'A' THEN 'Electrónica'
      WHEN 'B' THEN 'Ropa'
      WHEN 'C' THEN 'Alimentos'
      ELSE 'Desconocido'
    ).
    out->write( |Categoría del producto: { lv_categoria }| ).
    out->write( | | ).



    "COND: DESCUENTO SEGÚN MONTO DE COMPRA"
    DATA(lv_monto) = 1200.
    DATA(lv_descuento_cond) = COND #(
      WHEN lv_monto >= 1000 THEN '10% de descuento'
      WHEN lv_monto >= 500  THEN '5% de descuento'
      ELSE 'Sin descuento'
    ).
    out->write( |Monto: { lv_monto } → { lv_descuento_cond }| ).
    out->write( | | ).



    "DO"
    DATA(lv_numero_factura) = 10001.
    DATA(lv_contador) = 0.

    out->write( '=== DO ===' ).

    DO 5 TIMES.
      lv_contador = lv_contador + 1.
      out->write( |Factura { lv_contador }: FAC-{ lv_numero_factura }| ).
      lv_numero_factura = lv_numero_factura + 1.
    ENDDO.
    out->write( | | ).




    "WHILE"
    out->write( '=== WHILE ===' ).

    DATA(lv_deuda_total) = 5000.
    DATA(lv_pago_acumulado) = 0.
    DATA(lv_numero_pago) = 0.
    DATA(lv_pago) = 1500.

    WHILE lv_pago_acumulado < lv_deuda_total.
      lv_numero_pago = lv_numero_pago + 1.
      "Ajustar pago si excede la deuda
      IF lv_pago_acumulado + lv_pago > lv_deuda_total.
        lv_pago = lv_deuda_total - lv_pago_acumulado.
      ENDIF.
      lv_pago_acumulado = lv_pago_acumulado + lv_pago.
      out->write( |Pago { lv_numero_pago }: { lv_pago } - Acumulado: { lv_pago_acumulado }| ).
    ENDWHILE.
    out->write( | | ).



    "LOOP"
    out->write( '=== LOOP ===' ).

    "Con la definición mediante TYPES no se les puede dar valor a las variables, solo crea el molde"
    "Definimos el tipo de estructura, no se asigna valores"
    TYPES: BEGIN OF ty_venta,
             vendedor TYPE string,
             monto    TYPE i,
           END OF   ty_venta.

    "Declaramos una tabla interna lt_ventas que contendrá muchos registros de tipo ty_venta"
    DATA: lt_ventas TYPE TABLE OF ty_venta.

    "Asignamos los valores reales a la tabla lt_ventas. Cada fila es una estructura ty_venta con valores para vendedor y monto."
    lt_ventas = VALUE #(
        ( vendedor = 'Juan' monto = 1000 )
        ( vendedor = 'María' monto = 1500 )
        ( vendedor = 'Juan' monto = 2000 )
        ( vendedor = 'María' monto = 500 )
    ).

    "Declara una variable simple lv_total_ventas (prefijo lv_) e inicializa en 0, para acumular montos"
    DATA(lv_total_ventas) = 0.

    "Tablas = muchos registros (lt). Estructura = un solo registro (ls)"
    "Recorre cada fila de la tabla lt_ventas, guardando temporalmente el registro en ls_venta (estructura de un solo registro)."
    LOOP AT lt_ventas INTO DATA(ls_venta). "Recorrer todos los registros de esta tabla interna"
      lv_total_ventas = lv_total_ventas + ls_venta-monto. "Suma el monto de cada fila al total acumulado."
      out->write( |{ ls_venta-vendedor }: { ls_venta-monto }| ).
    ENDLOOP.
    out->write( | | ).



    "FOR"
    out->write( '=== FOR ===' ).

    DATA(lt_cuadrados) = VALUE string_table( FOR i = 1 THEN i + 1 UNTIL i > 5 ( |{ i }^2 = { i * i }| ) ).

    "Mostrar resultados"
    LOOP AT lt_cuadrados INTO DATA(lv_cuadrado).
      out->write( lv_cuadrado ).
    ENDLOOP.
    out->write( | | ).



    "CHECK"
    "Se usa dentro de bucles para saltar iteraciones que no cumplen una condición en específico"
    out->write( '=== CHEK ===' ).

    TYPES: BEGIN OF ty_factura,
             numero TYPE string,
             estado TYPE c LENGTH 1, "A=Aprobada, P=Pendiente"
             monto  TYPE i,
           END OF   ty_factura.

    DATA: lt_facturas TYPE TABLE OF ty_factura.
    lt_facturas = VALUE #(
        ( numero = 'FAC-001' estado = 'A' monto = 1000 )
        ( numero = 'FAC-002' estado = 'P' monto = 1500 )
        ( numero = 'FAC-003' estado = 'A' monto = 2000 )
        ( numero = 'FAC-004' estado = 'P' monto = 500 )
    ).

    "Iteramos todos los registros de la tabla"
    LOOP AT lt_facturas INTO DATA(ls_factura).
      "Comprobamos únicamente las aprobadas"
      CHECK ls_factura-estado = 'A'. "Solo procesar aprobadas"
      out->write( |Procesando: { ls_factura-numero } - Monto: { ls_factura-monto }| ).
    ENDLOOP.
    out->write( | | ).



    "TRY-CATCH"
    out->write( '=== TRY-CATCH: Convertir montode string a número ===' ).

    DATA(lv_monto_texto) = '1500.50'. "Cantidad como texto"
    DATA lv_monto_numero TYPE p DECIMALS 2.

    TRY.
        lv_monto_numero = lv_monto_texto.
        out->write( |Conversión exitosa: { lv_monto_numero }| ).
        "Validar que el monto sea positivo"
        IF lv_monto_numero <= 0.
          out->write( 'Error: El monto debe ser mayor a cero' ).
        ELSE.
          out->write( |Monto válido para procesamiento: { lv_monto_numero }| ).
        ENDIF.
      CATCH cx_sy_conversion_error INTO DATA(lx_error).
        out->write( | Error de conversión: { lx_error->get_text(  ) }| ).
    ENDTRY.

    out->write( | | ).

    "Ejemplo con error
    out->write( '--- Ejemplo con dato inválido ---' ).
    lv_monto_texto = 'ABC123'. "Texto inválido"
    TRY.
        lv_monto_numero = lv_monto_texto.
        out->write( |Conversión exitosa: { lv_monto_numero }| ).
      CATCH cx_sy_conversion_error INTO lx_error.
        out->write( | No se pudo convertir "{ lv_monto_texto }" a número| ).
        out->write( | Razón: { lx_error->get_text( ) }| ).
    ENDTRY.



  ENDMETHOD.

ENDCLASS.
