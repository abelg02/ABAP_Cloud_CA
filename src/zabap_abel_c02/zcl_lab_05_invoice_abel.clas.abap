CLASS zcl_lab_05_invoice_abel DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_lab_05_invoice_abel IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

*Continuando con el desarrollo del sistema de gestión de facturas para una
*empresa. Necesitas realizar varias operaciones con cadenas de caracteres
*para procesar y mostrar información de las facturas. Cada método de la
*clase se encargará de una operación específica.
*Esta actividad se desarrollará mediante la ampliación de la clase ABAP
*llamada “ZCL_LAB_05_INVOICE_USER*” donde “USER” deberá ser
*reemplazado con el nombre del usuario SAP del estudiante.
*Además, implementar la interfaz “IF_OO_ADT_CLASSRUN” en la clase y
*utilizar el método “WRITE” de la interfaz para mostrar en consola los
*resultados de cada una de las actividades.
*
*Realiza las siguientes actividades:
*1. OVERLAY
*Declarar la siguiente variable del tipo “STRING”:
*● LV_SALE, asignándole el valor “Purchase Completed”.
*● LV_SALE_STATUS, asignando el valor “Invoice”.
*Utilizar la sentencia “OVERLAY” para sobreponer el valor de la
*primera variable con la segunda.
*
*2. Función SUBSTRING
*Declarar la siguiente variable del tipo “STRING”:
*● LV_RESULT, asignándole el valor “SAP-ABAP-32-PE”.
*Obtener la cadena de caracteres desde la posición 9 hasta la 14 y
*devolver el valor en la misma variable. Luego mostrar en consola los
*resultados de la cadena antes y después de la cadena de caracteres
*“ABAP”.
*
*3. FIND
*Declarar las siguientes variables:
*● LV_STATUS, de tipo “STRING” asignándole el valor “INVOICE
*GENERATED SUCCESSFULLY”.
*● LV_COUNT, de tipo “I”.
*
*Buscar con la sentencia “FIND_ANY_OF” de la primera variable los
*caracteres “GEN” y muestra por pantalla la posición real de los
*caracteres buscados. Luego con la sentencia “FIND ALL
*OCCURRENCES OF IN MATCH COUNT” o con la función “COUNT()”
*encontrar la cantidad de letras “A” en la primera variable y asignar
*dicha cantidad a la segunda variable.
*
*4. REPLACE
*Declarar la siguiente variable de tipo “STRING”:
*● LV_REQUEST asignándole el mismo valor “SAP-ABAP-32-PE”.
*
*Reemplazar todas las ocurrencias del carácter “-” con el carácter “/”
*con la instrucción sentencia “REPLACE”.
*
*5. PCRE Regex
*Declarar las siguientes variables del tipo “STRING”:
*● LV_REGEX, asignándole el valor
*“^[_a-z0-9-]+(.[_a-z0-9-]+)@[a-z0-9-]+(.[a-z0-9-]+)(.[a-z]
*{2,4})$” para validar el formato de los correos electrónicos.
*● LV_EMAIL, asignándole un correo electrónico de su preferencia.
*
*Aplicar la sentencia “FIND REGEX” para validar el formato del correo
*establecido de la segunda variable es válido.
*
*6. Expresiones regulares
*Declarar las siguientes variables del tipo “STRING”:
*● LV_IDCUSTOME, asignándole el valor “0000012345”.
*
*Reutilizar la variable “LV_REGEX”, asignándole el valor de “0*” para
*eliminar los ceros a la izquierda de la variable “LV_IDCUSTOME”.
*
*7. Repetición de strings
*Reutilizar la variable “LV_IDCUSTOME” y repetir el valor que
*contiene 3 veces utilizando la función “REPEAT()”.
*
*8. Función ESCAPE
*Declarar las siguientes variables:
*● LV_FORMAT, del tipo “STRING” asignándole el valor “Send
*payment data via Internet”.
*
*Mostrar en consola el valor de la variable en los formatos URL, Json
*y String Templates.



    "1. OVERLAY"
    DATA lv_sale        TYPE string.
    DATA lv_sale_status TYPE string.

    lv_sale = 'Purchase Completed'.
    lv_sale_status = 'Invoice'.

    OVERLAY lv_sale WITH lv_sale_status.
    out->write( |OVERLAY: { lv_sale }| ).

    "2. Función SUBSTRING"
    DATA lv_result TYPE string.
    lv_result = 'SAP-ABAP-32-PE'.

    out->write( |SUBSTRING Antes: { lv_result }| ).
    lv_result = lv_result+8(6). "Posición 9 a 14, índice 0-based
    out->write( |SUBSTRING Después: { lv_result }| ).

    "3. FIND"
    DATA lv_status TYPE string.
    DATA lv_count  TYPE i.

    lv_status = 'INVOICE GENERATED SUCCESSFULLY'.

    lv_count = find_any_of( val = lv_status sub = 'GEN' ).
    out->write( |FIND_ANY_OF: { lv_count }| ).

    lv_count = count( val = lv_status sub = 'A' ).
    out->write( |COUNT 'A': { lv_count }| ).

    "4. REPLACE"
    DATA lv_request TYPE string.
    lv_request = 'SAP-ABAP-32-PE'.

    REPLACE ALL OCCURRENCES OF '-' IN lv_request WITH '/'.
    out->write( |REPLACE: { lv_request }| ).

    "5. PCRE Regex"
    DATA lv_regex TYPE string.
    DATA lv_email TYPE string.

    lv_regex = `^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$`.
    lv_email = 'usuario@ejemplo.com'.

    IF contains( val = lv_email pcre = lv_regex ).
      out->write( |EMAIL VÁLIDO: { lv_email }| ).
    ELSE.
      out->write( |EMAIL INVÁLIDO: { lv_email }| ).
    ENDIF.

    "6. Expresiones regulares"
    DATA lv_idcustome TYPE string.
    lv_idcustome = '0000012345'.

    lv_regex = '0*'.
    lv_idcustome = replace( val = lv_idcustome sub = lv_regex with = '' ).
    out->write( |ID sin ceros iniciales: { lv_idcustome }| ).

    "7. Repetición de strings"
    lv_idcustome = repeat( val = lv_idcustome occ = 3 ).
    out->write( |ID repetido 3 veces: { lv_idcustome }| ).

    "8. Función ESCAPE"
    out->write( '8. FUNCIÓN ESCAPE' ).
    DATA(lv_format) = 'Send payment data via Internet'.
    out->write( |Texto original: { lv_format }| ).

    " Formato URL
    DATA(lv_url_escaped) = escape( val = lv_format format = cl_abap_format=>e_url ).
    out->write( |Formato URL: { lv_url_escaped }| ).

    " Formato JSON
    DATA(lv_json_escaped) = escape( val = lv_format format = cl_abap_format=>e_json_string ).
    out->write( |Formato JSON: { lv_json_escaped }| ).

    " Formato String Templates (XML)
    DATA(lv_xml_escaped) = escape( val = lv_format format = cl_abap_format=>e_xml_attr ).
    out->write( |Formato XML/String Template: { lv_xml_escaped }| ).

    out->write( | | ).
    out->write( '=== FIN DEL EJERCICIO ===' ).


  ENDMETHOD.

ENDCLASS.
