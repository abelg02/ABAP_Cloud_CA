CLASS zcl_lab_04_message_user DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_lab_04_message_user IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

*Escenario y Clase
*
*Imaginemos que estamos desarrollando un programa para una empresa de comercio electrónico y dependiendo de las
*situaciones que puedan encontrar durante la gestión de pedidos de compra en la tienda en línea se mostrarán en
*pantalla diferentes estatus dependiendo del parámetro seleccionado.
*
*Esta actividad se desarrollará mediante la creación de una clase ABAP llamada “ZCL_LAB_04_MESSAGE_USER”* donde
*“USER” deberá ser reemplazado con el nombre del Usuario SAP del estudiante.
*
*Además, implementar la interfaz “IF_OO_ADT_CLASSRUN” en la clase y utilizar el método “WRITE” de la interfaz para
*mostrar en consola los resultados de cada una de las actividades.
*
*Actividades
*
*1. Símbolos de texto
*
*Crear un símbolo de texto con el ID “001” y agregar el texto “Test with text symbols”.
*
*2. Funciones de descripción
*
*Declarar las siguientes variables:
*
*LV_ORDER_STATUS, del tipo “STRING” con un valor de “Purchase Completed Successfully”.
*
*LV_CHAR_NUMBER, del tipo “I”.
*
*Realizar las siguientes operaciones utilizando la variable “LV_ORDER_STATUS”:
*
*Contar la longitud de caracteres de la primera variable con las funciones “STRLEN()” y “NUMOFCHAR()”.
*
*Contar la cantidad de los caracteres “A” en su totalidad sin distinguir entre mayúsculas y minúsculas dentro de
*la variable.
*
*Encontrar la posición del patrón “Exit” utilizando la función “FIND()”.
*
*Para todos los casos utilizar para esto la segunda variable para mostrar los resultados en consola.
*
*3. Funciones de procesamiento
*
*Realizar las siguientes operaciones reutilizando la variable “LV_ORDER_STATUS”:
*
*Cambiar el formato del contenido de la variable a mayúsculas, minúsculas y a un mixto entre los 2 formatos.
*
*Desplazar los 9 primeros caracteres al final de la variable.
*
*Extraer la palabra “Completed” de la variable.
*
*Revertir el orden de los caracteres de la variable.
*
*4. Funciones de contenido
*
*Declarar las siguientes variables del tipo “STRING”:
*
*LV_PATTERN, con el valor “\d{3}-\d{3}-\d{4}”.
*
*LV_PHONE, con el valor “Agregar cualquier teléfono”.
*
*Validar utilizando la función “CONTAINS()” el teléfono ingresado por el cliente dentro de la segunda variable y validar si contiene el formato correcto para esto utilizar el patrón dentro de la primera variable.
*
*5. Funciones con expresiones regulares
*
*Declarar la variable del tipo “STRING”:
*
*LV_EMAIL, con el valor “Agregar cualquier correo”.
*
*Validar el correo ingresado por el cliente dentro de la variable y validar si contiene el formato correcto para esto reutilizar la variable “LV_PATTERN”, reemplazando su contenido con la expresión regular:
*
*“\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+.[A-Z|a-z]{2,}\b”.


    "1. Símbolos de texto"

    DATA lv_text TYPE string.
    lv_text = TEXT-001.

    out->write( lv_text ).



    "2. Funciones de descripción"
    DATA lv_order_status TYPE string VALUE 'Purchase Completed Successfully'.
    DATA lv_char_number TYPE i.

    " Longitud de caracteres"
    lv_char_number = strlen( lv_order_status ).
    out->write( |Longitud con STRLEN(): { lv_char_number }| ).

    lv_char_number = numofchar( lv_order_status ).
    out->write( |Longitud con NUMOFCHAR(): { lv_char_number }| ).

    " Contar cantidad de 'A'"
    DATA lv_text_upper TYPE string.
    DATA lv_count_a TYPE i.

    lv_text_upper = to_upper( lv_order_status ).
    lv_count_a = count( val = lv_text_upper sub = 'A' ).

    out->write( |Cantidad de 'A': { lv_count_a }| ).

    " Encontrar patrón 'Exit'"
    lv_char_number = find( val = lv_order_status sub = 'Exit' ).
    out->write( lv_char_number ).




    "3. Funciones de procesamiento"
    "Mayúsculas, minúsculas, mixto"
    DATA lv_upper TYPE string.
    DATA lv_lower TYPE string.
    DATA lv_mixed TYPE string.

    lv_upper = to_upper( lv_order_status ).
    lv_lower = to_lower( lv_order_status ).
    lv_mixed = to_mixed( lv_order_status ).

    out->write( |Mayúsculas: { lv_upper }| ).
    out->write( |Minúsculas: { lv_lower }| ).
    out->write( |Mixto: { lv_mixed }| ).

    "Desplazar 9 primeros caracteres al final"
    out->write( |SHIFT_LEFT  (circ) = { shift_left(  val = lv_order_status circular = 9 ) }| ).

    "Extraer palabra 'Completed'"
    DATA lv_completed TYPE string.
    lv_completed = lv_order_status+9(9).
    out->write( |Extraído: { lv_completed }| ).

    "Revertir caracteres"
    out->write( |REVERSE = { reverse( lv_order_status ) }| ).



    "4. Funciones de contenido"
    DATA lv_pattern TYPE string VALUE '\d{3}-\d{3}-\d{4}'.
    DATA lv_phone   TYPE string VALUE '123-456-7890'.

    IF contains( val = lv_phone pcre = lv_pattern ).
      out->write( |Teléfono válido según patrón| ).
    ELSE.
      out->write( |Teléfono no válido según patrón| ).
    ENDIF.


    "5. Funciones con expresiones regulares"
    DATA lv_email TYPE string VALUE 'correo@dominio.com'.
    lv_pattern = '\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b'.

    IF matches( val = lv_email pcre = lv_pattern ).
      out->write( |Correo válido| ).
    ELSE.
      out->write( |Correo no válido| ).
    ENDIF.



  ENDMETHOD.

ENDCLASS.
