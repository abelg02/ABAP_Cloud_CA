CLASS zcl_lab_06_condition_abel DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS get_case_description
      IMPORTING iv_string      TYPE string
      RETURNING VALUE(rv_desc) TYPE string.
ENDCLASS.



CLASS zcl_lab_06_condition_abel IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

*En esta oportunidad se estará desarrollando un programa educativo que
*tiene como objetivo enseñar a los estudiantes a cómo utilizar diferentes
*estructuras de control en ABAP.
*Esta actividad se desarrollará mediante la creación de una clase ABAP
*llamada “ZCL_LAB_06_CONDITION_USER*” donde “USER” deberá ser
*reemplazado con el nombre del Usuario SAP del estudiante.
*Además, implementar la interfaz “IF_OO_ADT_CLASSRUN” en la clase y
*utilizar el método “WRITE” de la interfaz para mostrar en consola los
*resultados de cada una de las actividades.
*
*Realiza las siguientes actividades:
*1. IF / ENDIF
*Declarar la siguiente variable de tipo “I”:
*● LV_CONDITIONAL, asignándole el valor de “7”.
*Validar si la variable es igual o diferente de “7” utilizando la
*sentencia “IF/ELSE/ENDIF”. Para ambos casos mostrar en pantalla
*un mensaje que identifica si es igual o diferente al valor de la
*variable. Para esta actividad es necesario llamar y asignar
*nuevamente la variable, una vez con algún otro número.
*2. CASE / ENDCASE
*Declarar la siguiente variable del tipo “STRING”:
*● LV_STRING,
*Validar la variable utilizando la sentencia “CASE/ENDCASE”. en 3
*escenarios:
*- Para el valor “LOGALI” muestra en pantalla el valor
*“Academy”.
*- Para el valor “SAP” muestra en pantalla el valor “Enterprise
*software”.
*- Para cualquier otro valor distinto a los dos primeros, muestra
*en pantalla el valor “Unknown”.
*
*Es necesario realizar varias asignaciones a la variable para validar
*cada uno de los posibles escenarios y mostrar el resultado por
*consola. Para este caso una opción es crear una subrutina con la
*sentencia “FORM” en la cual dependiendo de la entrada devuelva la
*cadena de caracteres correspondiente.
*
*3. DO / ENDDO
*Declarar la siguiente variable del tipo “I”:
*● LV_COUNTER.
*Realizar 10 iteraciones utilizando la sentencia “DO” y la condición
*“10 TIMES” y mostrar el valor de la variable “LV_COUNTER” que va
*aumentando su valor en “1” en cada iteración.
*
*4. CHECK
*Repetir el bucle anterior liberando o inicializando a cero la variable
*“LV_COUNTER” pero terminando el ciclo en la séptima vuelta. Por
*último, devolver el valor de la variable en cada iteración.
*5. SWITCH
*Declarar la siguiente variable del tipo “STRING”:
*● LV_STRING_2,
*Validar la variable utilizando la sentencia “SWITCH. en 3 escenarios:
*- Para el valor “LOGALI” muestra en pantalla el valor “SAP
*Academy”.
*- Para el valor “SAP” muestra en pantalla el valor “Enterprise
*software”.
*- Para el valor “MOVISTAR” muestra en pantalla el valor
*“Telephony”
*- Para cualquier otro valor distinto a los dos primeros, muestra
*en pantalla el valor “Unknown”.
*
*Es necesario realizar varias asignaciones a la variable para validar
*cada uno de los posibles escenarios y mostrar el resultado por
*consola. Para este caso una opción es crear un método en el cual
*dependiendo de la entrada devuelva la cadena de caracteres
*correspondiente.
*6. COND
*Declarar la variable del tipo “T”:
*● LV_TIME, asignándole el valor
*“cl_abap_context_info=>get_system_time( )”.
*
*Identificar si el valor que devuelve la variable del sistema está en
*formato “AM”, “PM” o “HIGH NOON”. “COND”
*Cuando la variable sea:
*- Menor a “120000” se imprimirá la hora actual con el formato
*“AM”
*- Mayor a “120000” se imprimirá la hora actual con el formato
*“PM”
*- Igual a “120000” se imprimirá la hora actual con el formato
*“High Noon”.
*
*7. WHILE / ENDWHILE
*Declarar la variable del tipo “I”:
*● LV_COUNTER_2.
*Realizar un bucle con la condición “WHILE”, con la condición que la
*primera variable sea menor que “20”, incremente el valor de la
*variable en cada ciclo y mostrar el valor en pantalla. Luego sin
*utilizar la sentencia “EXIT” implementa la lógica del código para que
*muestre en pantalla el valor de la variable hasta que el valor sea
*igual a “10”.
*
*8. LOOP / ENDLOOP
*Declarar una tabla interna estándar y una estructura (Opcional) del
*tipo de la tabla transparente “ZEMP_LOGALI”:
*● LT_EMPLOYEES.
*● LS_EMPLOYEES.
*Realizar una consulta a la tabla “ZEMP_LOGALI” y guardar todos sus
*registros en la tabla interna declarada. Luego, ejecutar un ciclo
*“LOOP” sobre dicha tabla para iterar únicamente los registros cuyo
*campo “APE2” coincida con “JIMENEZ”, utilizando la condición
*“WHERE”. Finalmente, mostrar una lista de los correos electrónicos
*asociados en el campo “EMAIL”.
*
*9. TRY / ENDTRY
*Declarar la siguiente variable del tipo “F”:
*● LV_EXCEPTION, asignándole el valor de “5”.
*Realizar un bucle “DO” de 5 iteraciones asignándole el valor de “5” a
*la variable “LV_COUNTER” donde en cada iteración se reste en “1”
*el valor de dicha variable y se divida el valor de la variable
*“LV_EXCEPTION” con el de la variable “LV_COUNTER” que está
*cambiando en cada ciclo. Por último, capturar la excepción
*“CX_SY_ZERODIVIDE”.

       out->write( '=== ACTIVIDAD 1: IF / ENDIF ===' ).

    "1. IF / ENDIF
    DATA(lv_conditional) = 7.

    IF lv_conditional EQ 7.
      out->write( |La variable LV_CONDITIONAL es igual a { lv_conditional }| ).
    ELSE.
      out->write( |La variable LV_CONDITIONAL es diferente de 7 (valor actual: { lv_conditional })| ).
    ENDIF.

    "Llamar y asignar nuevamente la variable
    lv_conditional = 10.
    IF lv_conditional EQ 7.
      out->write( |La variable LV_CONDITIONAL es igual a { lv_conditional }| ).
    ELSE.
      out->write( |La variable LV_CONDITIONAL es diferente de 7 (valor actual: { lv_conditional })| ).
    ENDIF.

    out->write( | | ).
    out->write( '=== ACTIVIDAD 2: CASE / ENDCASE ===' ).

    "2. CASE / ENDCASE
    DATA(lv_string) = 'LOGALI'.

    "Primer escenario: LOGALI
    out->write( '--- Primer escenario: LOGALI ---' ).
    CASE lv_string.
      WHEN 'LOGALI'.
        out->write( |Para '{ lv_string }' → Academy| ).
      WHEN 'SAP'.
        out->write( |Para '{ lv_string }' → Enterprise| ).
      WHEN OTHERS.
        out->write( |Para '{ lv_string }' → Unknown| ).
    ENDCASE.

    "Segundo escenario: SAP
    lv_string = 'SAP'.
    out->write( '--- Segundo escenario: SAP ---' ).
    CASE lv_string.
      WHEN 'LOGALI'.
        out->write( |Para '{ lv_string }' → Academy| ).
      WHEN 'SAP'.
        out->write( |Para '{ lv_string }' → Enterprise| ).
      WHEN OTHERS.
        out->write( |Para '{ lv_string }' → Unknown| ).
    ENDCASE.

    "Tercer escenario: Otro valor
    lv_string = 'ABAP'.
    out->write( '--- Tercer escenario: ABAP ---' ).
    CASE lv_string.
      WHEN 'LOGALI'.
        out->write( |Para '{ lv_string }' → Academy| ).
      WHEN 'SAP'.
        out->write( |Para '{ lv_string }' → Enterprise| ).
      WHEN OTHERS.
        out->write( |Para '{ lv_string }' → Unknown| ).
    ENDCASE.

    "Usando subrutina FORM (opcional como menciona el ejercicio)
    out->write( '--- Usando método ---' ).
    DATA(lv_result) = get_case_description( 'LOGALI' ).
    out->write( lv_result ).

    lv_result = get_case_description( 'SAP' ).
    out->write( lv_result ).

    lv_result = get_case_description( 'PYTHON' ).
    out->write( lv_result ).

    out->write( | | ).
    out->write( '=== ACTIVIDAD 3: DO / ENDDO ===' ).

    "3. DO / ENDDO
    DATA(lv_counter) = 0.

    DO 10 TIMES.
      lv_counter = lv_counter + 1.
      out->write( |Iteración { sy-index }: LV_COUNTER = { lv_counter }| ).
    ENDDO.

    out->write( | | ).
    out->write( '=== ACTIVIDAD 4: CHECK ===' ).

    "4. CHECK
    lv_counter = 0. "Reinicializar a cero

    DO 10 TIMES.
      lv_counter = lv_counter + 1.
      CHECK lv_counter <= 7. "Terminar en la séptima vuelta
      out->write( |Iteración { sy-index }: LV_COUNTER = { lv_counter }| ).
    ENDDO.

    out->write( | | ).
    out->write( '=== ACTIVIDAD 5: SWITCH ===' ).

    "5. SWITCH
    DATA(lv_string_2) = 'LOGALI'.

    "Primer escenario: LOGALI
    DATA(lv_result_switch) = SWITCH string( lv_string_2
      WHEN 'LOGALI' THEN 'SAP Academy'
      WHEN 'SAP'    THEN 'Enterprise'
      WHEN 'MOVIST' THEN 'Telephony'
      ELSE 'Unknown'
    ).
    out->write( |Para '{ lv_string_2 }' → { lv_result_switch }| ).

    "Segundo escenario: SAP
    lv_string_2 = 'SAP'.
    lv_result_switch = SWITCH string( lv_string_2
      WHEN 'LOGALI' THEN 'SAP Academy'
      WHEN 'SAP'    THEN 'Enterprise'
      WHEN 'MOVIST' THEN 'Telephony'
      ELSE 'Unknown'
    ).
    out->write( |Para '{ lv_string_2 }' → { lv_result_switch }| ).

    "Tercer escenario: MOVIST (acortado a 6 caracteres)
    lv_string_2 = 'MOVIST'.
    lv_result_switch = SWITCH string( lv_string_2
      WHEN 'LOGALI' THEN 'SAP Academy'
      WHEN 'SAP'    THEN 'Enterprise'
      WHEN 'MOVIST' THEN 'Telephony'
      ELSE 'Unknown'
    ).
    out->write( |Para '{ lv_string_2 }' → { lv_result_switch }| ).

    "Cuarto escenario: Otro valor
    lv_string_2 = 'GOOGLE'.
    lv_result_switch = SWITCH string( lv_string_2
      WHEN 'LOGALI' THEN 'SAP Academy'
      WHEN 'SAP'    THEN 'Enterprise'
      WHEN 'MOVIST' THEN 'Telephony'
      ELSE 'Unknown'
    ).
    out->write( |Para '{ lv_string_2 }' → { lv_result_switch }| ).

    out->write( | | ).
    out->write( '=== ACTIVIDAD 6: COND ===' ).

    "6. COND
    DATA(lv_time) = cl_abap_context_info=>get_system_time( ).

    DATA(lv_time_display) = COND string(
      WHEN lv_time < '120000' THEN |{ lv_time TIME = ISO } AM|
      WHEN lv_time > '120000' THEN |{ lv_time TIME = ISO } PM|
      WHEN lv_time = '120000' THEN |{ lv_time TIME = ISO } High Noon|
      ELSE 'Formato desconocido'
    ).

    out->write( |Hora del sistema: { lv_time_display }| ).

    "Mostrar ejemplos adicionales
    out->write( '--- Ejemplos adicionales ---' ).

    DATA(lv_test_time) = CONV t( '093000' ). "9:30 AM
    DATA(lv_test_display) = COND string(
      WHEN lv_test_time < '120000' THEN |{ lv_test_time TIME = ISO } AM|
      WHEN lv_test_time > '120000' THEN |{ lv_test_time TIME = ISO } PM|
      WHEN lv_test_time = '120000' THEN |{ lv_test_time TIME = ISO } High Noon|
      ELSE 'Formato desconocido'
    ).
    out->write( |Ejemplo 1 (09:30): { lv_test_display }| ).

    lv_test_time = '143000'. "14:30 PM
    lv_test_display = COND string(
      WHEN lv_test_time < '120000' THEN |{ lv_test_time TIME = ISO } AM|
      WHEN lv_test_time > '120000' THEN |{ lv_test_time TIME = ISO } PM|
      WHEN lv_test_time = '120000' THEN |{ lv_test_time TIME = ISO } High Noon|
      ELSE 'Formato desconocido'
    ).
    out->write( |Ejemplo 2 (14:30): { lv_test_display }| ).

    lv_test_time = '120000'. "12:00 High Noon
    lv_test_display = COND string(
      WHEN lv_test_time < '120000' THEN |{ lv_test_time TIME = ISO } AM|
      WHEN lv_test_time > '120000' THEN |{ lv_test_time TIME = ISO } PM|
      WHEN lv_test_time = '120000' THEN |{ lv_test_time TIME = ISO } High Noon|
      ELSE 'Formato desconocido'
    ).
    out->write( |Ejemplo 3 (12:00): { lv_test_display }| ).

    out->write( | | ).
    out->write( '=== ACTIVIDAD 7: WHILE / ENDWHILE ===' ).

    "7. WHILE / ENDWHILE
    DATA(lv_counter_2) = 0.

    out->write( '--- Bucle WHILE completo (menor que 20) ---' ).
    WHILE lv_counter_2 < 20.
      lv_counter_2 = lv_counter_2 + 1.
      out->write( |LV_COUNTER_2 = { lv_counter_2 }| ).
    ENDWHILE.

    out->write( '--- Bucle WHILE que se detiene en 10 (sin EXIT) ---' ).
    lv_counter_2 = 0.

    WHILE lv_counter_2 < 20.
      lv_counter_2 = lv_counter_2 + 1.
      out->write( |LV_COUNTER_2 = { lv_counter_2 }| ).

      "Condición para detener cuando sea igual a 10
      IF lv_counter_2 = 10.
        "Ajustamos lv_counter_2 para que no cumpla la condición del WHILE
        lv_counter_2 = 20.
      ENDIF.
    ENDWHILE.

    out->write( | | ).
    out->write( '=== ACTIVIDAD 8: LOOP / ENDLOOP ===' ).

    "8. LOOP / ENDLOOP
    "Definimos una tabla interna simulada para el ejemplo
    TYPES: BEGIN OF ty_employee,
             empid  TYPE i,
             nombre TYPE string,
             ape1   TYPE string,
             ape2   TYPE string,
             email  TYPE string,
           END OF ty_employee.

    TYPES: ty_employee_table TYPE TABLE OF ty_employee WITH EMPTY KEY.

    "Creamos la tabla interna con datos de prueba
    DATA: lt_employees TYPE ty_employee_table.
    lt_employees = VALUE #(
        ( empid = 1 nombre = 'Juan'   ape1 = 'Pérez'     ape2 = 'Gómez'    email = 'juan.perez@empresa.com' )
        ( empid = 2 nombre = 'María'  ape1 = 'López'     ape2 = 'JIMENEZ'  email = 'maria.lopez@empresa.com' )
        ( empid = 3 nombre = 'Carlos' ape1 = 'García'    ape2 = 'JIMENEZ'  email = 'carlos.garcia@empresa.com' )
        ( empid = 4 nombre = 'Ana'    ape1 = 'Martínez'  ape2 = 'Sánchez'  email = 'ana.martinez@empresa.com' )
        ( empid = 5 nombre = 'Luis'   ape1 = 'Rodríguez' ape2 = 'JIMENEZ'  email = 'luis.rodriguez@empresa.com' )
    ).

    out->write( '=== Correos electrónicos de empleados con APE2 = JIMENEZ ===' ).

    LOOP AT lt_employees INTO DATA(ls_employee) WHERE ape2 = 'JIMENEZ'.
      out->write( |{ ls_employee-nombre } { ls_employee-ape1 }: { ls_employee-email }| ).
    ENDLOOP.

    out->write( | | ).
    out->write( '=== ACTIVIDAD 9: TRY / ENDTRY ===' ).

    "9. TRY / ENDTRY
    DATA(lv_exception) = CONV f( 5 ).
    DATA(lv_counter_div) = 5.

    DO 5 TIMES.
      TRY.
          lv_counter_div = lv_counter_div - 1.
          DATA(lv_division_result) = lv_exception / lv_counter_div.
          out->write( |Iteración { 6 - lv_counter_div }: { lv_exception } / { lv_counter_div } = { lv_division_result }| ).
        CATCH cx_sy_zerodivide INTO DATA(lx_zero_divide).
          out->write( |Iteración { 6 - lv_counter_div }: Error - División por cero ({ lv_exception } / { lv_counter_div })| ).
          out->write( |Mensaje de error: { lx_zero_divide->get_text( ) }| ).
      ENDTRY.
    ENDDO.

    out->write( | | ).
    out->write( '=== EJERCICIO COMPLETADO ===' ).

  ENDMETHOD.

  METHOD get_case_description.
    "Método auxiliar para la actividad 2
    CASE iv_string.
      WHEN 'LOGALI'.
        rv_desc = |Para '{ iv_string }' → Academy (usando método)|.
      WHEN 'SAP'.
        rv_desc = |Para '{ iv_string }' → Enterprise (usando método)|.
      WHEN OTHERS.
        rv_desc = |Para '{ iv_string }' → Unknown (usando método)|.
    ENDCASE.
  ENDMETHOD.

ENDCLASS.
