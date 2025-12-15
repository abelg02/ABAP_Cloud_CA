CLASS zcl_lab_03_datatypes_user DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_lab_03_datatypes_user IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

*Imaginemos que estamos desarrollando un programa para una empresa de recursos humanos llamada “HR Solutions”.
*Este programa ayudará a los empleados a gestionar la información de los nuevos empleados que se inscriben en la empresa.
*El objetivo es crear un programa que permita ingresar y validar los datos personales y contractuales de los empleados, así
*como gestionar sus beneficios y permisos de acceso a programas y transacciones.
*
*Esta actividad se desarrollará mediante la creación de una clase ABAP llamada “ZCL_LAB_03_DATATYPES_USER*” donde “USER” deberá
*ser reemplazado con el nombre del Usuario SAP del estudiante.
*
*Además, implementar la interfaz “IF_OO_ADT_CLASSRUN” en la clase y utilizar el método “WRITE” de la interfaz para
*mostrar en consola los resultados de cada una de las actividades.
*
*Actividades
*
*1. Conversiones de Tipo
*Declarar las siguientes variables:
*
*MV_CHAR, del tipo “C” con una longitud de “10” con un valor de “12345”.
*
*MV_NUM, del tipo “I”.
*
*MV_FLOAT, del tipo “F”.
*
*Convierte el valor de MV_CHAR a un número entero y luego a un número de punto flotante.
*
*2. Truncamiento y Redondeo
*Declarar las siguientes variables del tipo “I”:
*
*MV_TRUNC
*
*MV_ROUND
*
*Reutilizar la variable MV_FLOAT, asignando el valor decimal “123.45”, trunca el valor en la primera variable y redondea el valor en la segunda variable sumándole el valor “0,5” de esta actividad, y muestra ambos resultados.
*
*3. Tipos en declaraciones en línea
*Declarar una variable en línea con el valor “ABAP”.
*
*4. Conversiones del Tipo Forzado
*Reutilizar las variables MV_CHAR y MV_NUM para convertir forzadamente el valor de la primera variable que se
*encuentra en caracteres a número y muestra el resultado.
*
*5. Cálculo de Fecha y Hora
*Declarar las siguientes variables:
*
*MV_DATE_1, del tipo “D”.
*
*MV_DATE_2, del tipo “D”.
*
*MV_DAYS, del tipo “I”.
*
*MV_TIME, del tipo “T”.
*
*Obtener el número de días entre la primera variable y la segunda, mostrar el resultado en la tercera. Además de
*mostrar en consola con el formato de “DDMMAAAA” el valor de la primera variable.
*
*6. Campos Timestamp
*Declarar la variable:
*
*MV_TIMESTAMP, del tipo “UTCLONG”.
*
*Obtener la fecha actual con la función “UTCLONG_CURRENT()”.
*Luego obtener la fecha del sistema, pasar la fecha y hora a 2 variables reutilizar las variables
*MV_DATE_2 y MV_TIME. Por último, restar 2 días a la primera variable.


    "1. Conversiones de Tipo"
    DATA: mv_char  TYPE c LENGTH 10 VALUE '12345',
          mv_num   TYPE i,
          mv_float TYPE f.

    "Convertir MV_CHAR a entero y luego a float"
    mv_num = mv_char.
    mv_float = mv_char.
    out->write( |mv_char -> mv_num: { mv_num }| ).
    out->write( |mv_char -> mv_float: { mv_float }| ).

    "2. Truncamiento y Redondeo"
    DATA: mv_trunc TYPE i,
          mv_round TYPE i.

    mv_float = '123.45'.
    mv_trunc = mv_float.        "Truncamiento
    mv_round = mv_float + '0.5'.  "Redondeo
    out->write( |Truncado: { mv_trunc }| ).
    out->write( |Redondeado: { mv_round }| ).

    "3. Tipos en declaraciones en línea"
    DATA(lv_inline) = 'ABAP'.
    out->write( |Variable en línea: { lv_inline }| ).

    "4. Conversiones del Tipo Forzado"
    mv_num = CONV i( mv_char ).
    out->write( |Conversión forzada MV_CHAR -> MV_NUM: { mv_num }| ).

    "5. Cálculo de Fecha y Hora"
    DATA: mv_date_1 TYPE d,
          mv_date_2 TYPE d,
          mv_days   TYPE i,
          mv_time   TYPE t.

    "Ejemplo de fechas"
    mv_date_1 = '20251201'.
    mv_date_2 = '20251210'.

    mv_days = mv_date_2 - mv_date_1.
    out->write( |Días entre MV_DATE_1 y MV_DATE_2: { mv_days }| ).
    out->write( |Fecha MV_DATE_1 (DDMMAAAA): { mv_date_1 }| ).


  ENDMETHOD.

ENDCLASS.
