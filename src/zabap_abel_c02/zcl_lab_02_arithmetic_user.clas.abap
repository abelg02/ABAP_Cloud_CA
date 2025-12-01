CLASS zcl_lab_02_arithmetic_user DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_lab_02_arithmetic_user IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    "1. Descripción del escenario"
    "Eres un desarrollador ABAP en una empresa de logística. Tu tarea es crear un programa que calcule el costo total de envío de varios paquetes. Cada paquete"
    "tiene un peso y un costo por kilogramo. Además, hay un descuento aplicable si el peso total de los paquetes supera un cierto umbral."

    "Esta actividad se desarrollará mediante la creación de una clase ABAP llamada “ZCL_LAB_02_ARITHMETIC_USER*” donde “USER” deberá ser"
    "reemplazado con el nombre del usuario SAP del estudiante."

    "Además implementar la interfaz “IF_OO_ADT_CLASSRUN” en la clase y utilizar el método “WRITE” de la interfaz para mostrar en consola los"
    "resultados de cada una de las actividades."

    "2. Realizar las siguientes actividades"
    "2.1. Suma / Sentencia ADD"

    "Declarar las siguientes variables de tipo “i”:"
    "● lv_base_rate asignándole el valor de “20”."
    "● lv_corp_area_rate asignándole el valor de “10”."
    "● lv_medical_service_rate asignándole el valor de “15”."
    "● lv_total_rate."

    "Aplicar la operación de sumatoria utilizando el carácter “+” donde se guarda el resultado de la operación en la tercera variable aplicada"
    "sobre las variables con valor (primeras tres). Al resultado final suma el valor “5” utilizando la sentencia “add”."

    "2.2. Resta / Sentencia subtract"
    "Declarar las siguientes variables de tipo “i”:"
    "● lv_maintenance_rate asignándole el valor de “30”."
    "● lv_margin_rate asignándole el valor de “10”."
    "● lv_base_rate."

    "Aplicar la operación de resta utilizando el carácter “-” donde se guarda el resultado de la operación en la tercera variable aplicada"
    "sobre las variables con valor (primeras dos). Al resultado final resta el valor “4” utilizando la sentencia “subtract”."

    "2.3. Multiplicación / Sentencia multiply"
    "Declarar las siguientes variables de tipo “i”:"
    "● lv_package_weight asignándole el valor de “2”."
    "● lv_cost_per_kg asignándole el valor de “3”."
    "● lv_multi_rate."

    "Aplicar la operación de multiplicación utilizando el carácter “*” para guardar el resultado de la operación en la tercera variable. Utiliza la"
    "sentencia “multiply” para multiplicar por “2” el resultado de la operación."

    "2.4. División / Sentencia divide"
    "Declarar las siguientes variables:"
    "● lv_total_weight de tipo “i”, asignándole el valor de “38”."
    "● lv_num_packages de tipo “i” asignándole el valor de “4”."
    "● lv_applied_rate de tipo incompleto “p” con una longitud de 8 y 2 decimales."

    "Aplica la operación de división utilizando el carácter “/” guardando el resultado de la operación en la tercera variable."
    "Utiliza la sentencia “divide” para dividir por “3” el resultado de la operación de la tercera variable."

    "2.5. División sin resto / Sentencia div"
    "Declarar las siguientes variables:"
    "● lv_total_cost de tipo “i”, asignándole el valor de “17”."
    "● lv_discount_threshold de tipo “i” asignándole el valor de “4”."
    "● lv_result de tipo incompleto “p” con una longitud de “4” y “2” decimales."

    "Obtener el resultado de la división sin resto (residuo) en la última variable. Muestra por pantalla el valor de la tercera variable."

    "2.6. Resto (residuo) de división / Sentencia MOD"
    "Declarar las siguientes variables:"
    "● lv_total_cost de tipo “i”, asignándole el valor de “19”."
    "● lv_discount_threshold de tipo “i” asignándole el valor de “4”."
    "● lv_remainder de tipo incompleto “p” con una longitud de “4” y “2” decimales."

    "Obtén el resultado de la operación resto de división aplicada sobre las dos primeras variables en la última variable declarada."

    "2.7. Exponenciación"
    "Declarar las siguientes variables de tipo “i”:"
    "● lv_weight asignándole el valor de “5”."
    "● lv_expo."

    "Eleva al cuadrado la primera variable y guarda el resultado en una variable en la última."

    "2.8. Raíz cuadrada"
    "Declarar las siguientes variables de tipo “i”:"
    "● lv_square_root."

    "Obtener la raíz cuadrada del valor de la variable lv_expo de la actividad anterior."

  ENDMETHOD.

ENDCLASS.
