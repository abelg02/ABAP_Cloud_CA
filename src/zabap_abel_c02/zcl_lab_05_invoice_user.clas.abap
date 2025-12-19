CLASS zcl_lab_05_invoice_user DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_lab_05_invoice_user IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

*Sistema de gestión de facturas – Operaciones con cadenas en ABAP
*
*Imagina que estás desarrollando un sistema de gestión de facturas para una empresa. Necesitas realizar varias operaciones con cadenas de
*caracteres para procesar y mostrar información de las facturas. Cada método de la clase se encargará de una operación específica.
*
*Esta actividad se desarrollará mediante la creación de una clase ABAP llamada:
*“ZCL_LAB_05_INVOICE_USER” donde “USER” deberá ser reemplazado con el nombre del Usuario SAP del estudiante.
*
*Además, se implementará la interfaz IF_OO_ADT_CLASSRUN en la clase y se utilizará el método WRITE de la interfaz para mostrar en consola los
*resultados de cada actividad.
*
*1. Concatenación
*
*Declarar variables:
*
*MV_EXERCISE de tipo N, longitud 4.
*
*MV_INVOICE_NO de tipo N, longitud 8.
*
*MV_INVOICE_CODE de tipo STRING.
*
*Asignar valores a las dos primeras variables.
*
*Concatenar MV_EXERCISE y MV_INVOICE_NO en MV_INVOICE_CODE separadas por "/".
*
*2. Concatenación de líneas de tablas
*
*Realizar consulta a la tabla ZEMP_LOGALI.
*
*Asignar los valores obtenidos a la tabla LT_EMPLOYEES mediante declaración dinámica.
*
*Concatenar los campos de cada registro con un espacio en blanco usando CONCAT_LINES_OF.
*
*3. Condensación
*
*Declarar variables de tipo STRING:
*
*MV_CASE1
*
*MV_CASE2
*
*Asignar a MV_CASE1 el valor "Sales invoice with         status in process" y dejar solo un espacio entre palabras.
*
*Asignar a MV_CASE2 el valor "***ABAP*Cloud***" y eliminar todos los caracteres "*".
*
*4. SPLIT
*
*Declarar variables de tipo STRING:
*
*MV_DATA = "0001111111;LOGALI GROUP;2024"
*
*MV_ID_CUSTOMER
*
*MV_CUSTOMER
*
*MV_YEAR
*
*Separar MV_DATA usando el carácter ";" y asignar cada sección a las demás variables mediante SPLIT.
*
*5. SHIFT
*
*Declarar variable:
*
*MV_INVOICE_NUM de tipo STRING = "2015ABCD".
*
*Eliminar 2 caracteres al inicio y 2 al final usando SHIFT.
*
*6. Funciones STRLEN y NUMOFCHAR
*
*Declarar variables:
*
*MV_RESPONSE = " Generating Invoice ".
*
*MV_COUNT
*
*Mostrar en consola la cantidad de caracteres de MV_RESPONSE usando STRLEN() y NUMOFCHAR().
*
*7. Funciones TO_LOWER y TO_UPPER
*
*Declarar variable:
*
*MV_TRANSLATE_INVOICE de tipo STRING = "Report the issuance of this invoice".
*
*Cambiar el contenido a mayúsculas y luego a minúsculas usando TRANSLATE.
*
*Imprimir ambos resultados.
*
*8. Función INSERT y REVERSE
*
*Reutilizar MV_TRANSLATE_INVOICE.
*
*Insertar al final la cadena " to client" con INSERT.
*
*Invertir el contenido de la variable usando REVERSE.


    "1. Concatenación
    DATA: mv_exercise     TYPE n LENGTH 4 VALUE '0001',
          mv_invoice_no   TYPE n LENGTH 8 VALUE '00001234',
          mv_invoice_code TYPE string.

    "Concatenación usando template (forma recomendada)
    mv_invoice_code = |{ mv_exercise }/{ mv_invoice_no }|.

    out->write( |Concatenación: { mv_invoice_code }| ).


    "2. Concatenación de líneas de tablas
    DATA: lt_employees TYPE TABLE OF zemp_logali,
          ls_employee  TYPE zemp_logali,
          lv_lines     TYPE string.

    "Realizar consulta a la tabla ZEMP_LOGALI
    SELECT * FROM zemp_logali INTO TABLE @lt_employees.

    "Concatenar campos de cada registro con espacio
    LOOP AT lt_employees INTO ls_employee.
      CONCATENATE lv_lines ls_employee-id ls_employee-name ls_employee-client
                  INTO lv_lines SEPARATED BY space.
    ENDLOOP.

    out->write( |Concatenación de empleados: { lv_lines }| ).




    "3. Condensación
    "------------------------------
    DATA: mv_case1 TYPE string VALUE 'Sales invoice with         status in process',
          mv_case2 TYPE string VALUE '***ABAP*Cloud***'.

    "Dejar solo un espacio entre palabras
    CONDENSE mv_case1.
    out->write( |Condensación MV_CASE1: { mv_case1 }| ).

    "Eliminar todos los caracteres '*'
    REPLACE ALL OCCURRENCES OF '*' IN mv_case2 WITH ''.
    out->write( |Condensación MV_CASE2: { mv_case2 }| ).


    "4. SPLIT
    "------------------------------
    DATA: mv_data        TYPE string VALUE '0001111111;LOGALI GROUP;2024',
          mv_id_customer TYPE string,
          mv_customer    TYPE string,
          mv_year        TYPE string.

    SPLIT mv_data AT ';' INTO mv_id_customer mv_customer mv_year.
    out->write( |SPLIT ID Customer: { mv_id_customer }| ).
    out->write( |SPLIT Customer: { mv_customer }| ).
    out->write( |SPLIT Year: { mv_year }| ).


    "5. SHIFT
    "------------------------------
    DATA mv_invoice_num TYPE string VALUE '2015ABCD'.

    out->write( |SHIFT - Valor original: { mv_invoice_num }| ).

    "Eliminar 2 caracteres al inicio usando shift_left
    DATA(lv_sin_inicio) = shift_left( val = mv_invoice_num places = 2 ).
    out->write( |SHIFT_LEFT (2 posiciones): { lv_sin_inicio }| ).

    "Ahora eliminar 2 caracteres al final del resultado anterior
    "Para eliminar del final, usamos substring o una combinación
    DATA(lv_final) = substring( val = lv_sin_inicio len = strlen( lv_sin_inicio ) - 2 ).
    out->write( |SHIFT - Resultado final (sin 2 del inicio y 2 del final): { lv_final }| ).


    "6. Funciones STRLEN y NUMOFCHAR
    "------------------------------
    DATA mv_response TYPE string VALUE ' Generating Invoice '.
    DATA lv_count TYPE i.

    "Usando strlen()
    lv_count = strlen( mv_response ).
    out->write( |STRLEN de MV_RESPONSE: { lv_count }| ).

    "Usando numofchar()
    lv_count = numofchar( mv_response ).
    out->write( |NUMOFCHAR de MV_RESPONSE: { lv_count }| ).


    "7. TO_LOWER y TO_UPPER
    "------------------------------
    DATA mv_translate_invoice TYPE string VALUE 'Report the issuance of this invoice'.

    TRANSLATE mv_translate_invoice TO UPPER CASE.
    out->write( |TO_UPPER: { mv_translate_invoice }| ).

    TRANSLATE mv_translate_invoice TO LOWER CASE.
    out->write( |TO_LOWER: { mv_translate_invoice }| ).


    "8. INSERT y REVERSE
    "------------------------------
    "Insertar al final la cadena ' to client'
    mv_translate_invoice = insert( val = mv_translate_invoice sub = ' to client' off = strlen( mv_translate_invoice ) ).
    out->write( |INSERT: { mv_translate_invoice }| ).

    "Invertir el contenido de la variable
    DATA(lv_reversed) = reverse( val = mv_translate_invoice ).
    out->write( |REVERSE: { lv_reversed }| ).





  ENDMETHOD.

ENDCLASS.
