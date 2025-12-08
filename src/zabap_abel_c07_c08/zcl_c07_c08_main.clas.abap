CLASS zcl_c07_c08_main DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_c07_c08_main IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    "Diccionarios: los diccionarios funcionarán como la capa entre nuestro código ABAP y la base de datos de SAP HANA"
    "De esta manera podremos definir estructuras de datos una sola vez y reutilizarlas en todo el sistema"
    "Si necesitamos que nuestro objeto/estructura/tabla sea global y demás usuarios puedan acceder debemos ponerlo en nuestro diccionario de datos"

    "1. Dominio: Define el tipo técnico: tipo de dato, longitud y reglas básicas"
    "Z_DOM_ID -> NUMC, longitud 8"

    "2. Elementos de datos: Añade significado semántico : etiquetas,textos de ayuda y documentación"
    "Z_TRAVEL_ID -> Etiqueta: "Travel ID"

    "3. Estructura: Agrupa múltiples campos relacionados en una unidad lógica"
    "Z_S_TRAVEL -> (travel_id, customer_id, begin_date)"

    "4. Tipo tabla: Define una tabla interna (internal table) basada en la estructura"
    "Z_TT_TRAVELS -> TYPE TABLE OF z_s_travel"

    "5. Tabla base de datos: Persistencia física de datos en la base de datos HANA"
    "Z_TRAVEL -> Almacena registros en HANA"

    "Para construir el elemento del diccionario de datos tenemos que hacer clic derecho en el paquete -> new -> other ABAP repository Object"
    "Escribimos Domain, lo nombramos (Ejemplo: ZDO_EMP_ID_C07) y se abrirá un entorno donde pasaremos el tipo de dato (INT1) y la longitud (3)."
    "Para que se guarde simplemente lo activamos con CTRL+F3 (No es suficiente con guardarlo con CTRL+S)"
    "Con esto en nuestro paquete se creará una nueva carpeta llamada "Domains"
    "Podemos crear un nuevo dominio haciendo clic derecho para crearlo y en este caso lo llamamos ZDO_NAME_C07 de tipo char y 30 de longitud"
    "De esta manera vamos creando nuestros tipos de información"
    "Si creamos en este caso uno nuevo por ejemplo de sexo le ponemos char de longitud 1 y en Fixed Value añadimos un valor de "M" y otro de "F".

    "Para utilizar nuestros dominios cuando los tengamos creados creamos un elemento de datos con clic derecho en la carpeta Dictionary -> New -> Data Element"
    "Cuando lo creemos en la categoría es preferible usar Domain"
    "En el tipo de dominio (Type Name) colocaremos el nombre de nuestro dominio del ide de empleado: ZDO_EMP_ID_C07 y rellenamos las etiquetas"
    "Con esto tendríamos nuestro primer elemento de datos"

    "El siguiente paso será crear nuestra estructura haciendo clic derech en Dictionary -> New -> Structure"
    "Al crear la estructura borramos el parámetro por defecto component_to_be_changed"
    "Ahora crearemos de forma global la estructura, pero no van a almacenar datos"

    "Ejemplo:      employee_id : zde_emp_id_c07;"
    "name        : zde_name_c07;"
    "last_name   : abap.char(30);"

    "Además de elementos de datos en las estructuras también podemos pasar datos primitivos como por ejemplo last_name"

    "También existen las estructuras de tipos anidadas: clic derecho en la carpeta structure y creamos una nueva"
    "La nombramos como ZST_EMP_ADDRESS_C07"
    "Luego podemos ir a la estructura de empleado y crear otro campo llamado dirección"
    "Este campo tendrá más campos anidados por lo que le asignaremos la estructura de address"

    "Para hace uso de esta estructura del diccionario de datos hacemos lo siguiente:"

    DATA(ls_employee) = VALUE zst_emp_c07_c08( employee_id = 1
                                               name        = 'Abel'
                                               last_name   = 'González'
                                               age         = '22'
                                               sex         = 'M'
                                               address-address_id  = 1
                                               address-street_name = 'Street 1'
                                               address-int_number  = 2
                                               address-city         = 'New York'
                                               ).

    "Para mejorar la vista por consola asignaremos el include a nuestra estructura de address con include

*    DATA(ls_employee) = VALUE zst_emp_c07_c08( employee_id = 1
*                                               name        = 'Abel'
*                                               last_name   = 'González'
*                                               age         = '22'
*                                               sex         = 'M'
*                                               address_id  = 1
*                                               street_name = 'Street 1'
*                                               int_number  = 2
*                                               city         = 'New York'
*                                               ).
*
*    out->write( ls_employee ).


    "Ahora crearemos los elementos de tipo tabla con clic derecho en carpeta Dictionary -> New -> Table Type"
    "Es una tabla interna reutilizable, es decir, de forma global"
    "En la categoría podemos pasarle un tipo predefinido o un tipo del diccionario que creamos previamente (ZST_EMPLOYEE_C07)"

    DATA(lt_emp_addr) = VALUE ztt_emp_addr_c07_c08( ( address-address_id  = 1
                                                      address-street_name = 'Street 1'
                                                      address-int_number  = 2
                                                      address-city         = 'New York' )

                                                    ( address-address_id  = 2
                                                      address-street_name = 'Street 2'
                                                      address-int_number  = 2
                                                      address-city         = 'New York'
                                                      ) ).


    out->write( lt_emp_addr ).


    "Cómo insertar datos en mi tabla (Database table: ZEMP_C07_C08)"

*    MODIFY ZEMP_C07_C08 FROM TABLE @( VALUE #( (   emp_id         = 1
*                                                   emp_first_name = 'Enrique'
*                                                   emp_last_name  = 'Irala'
*                                                   emp_age        = 30
*                                                   emp_role       = 'Developer'
*                                                   emp_addr_id    = '1'
*                                                   emp_email      = 'irala@logali.com'
*                                                   emp_salary = '10000.00'
*                                                   currency = 'USD' )
*                                                   ( emp_id       = 2
*                                                   emp_first_name = 'Jhon'
*                                                   emp_last_name  = 'Smith'
*                                                   emp_age        = 35
*                                                   emp_role       = 'Manager'
*                                                   emp_addr_id    = '1'
*                                                   emp_email      = 'irala@logali.com'
*                                                   emp_salary = '100000.00'
*                                                   currency = 'USD' )
*                                                   ( emp_id       = 3
*                                                   emp_first_name = 'Juan'
*                                                   emp_last_name  = 'Lopez'
*                                                   emp_age        = 40
*                                                   emp_role       = 'Accountant'
*                                                   emp_addr_id    = '1'
*                                                   emp_email      = 'irala@logali.com'
*                                                   emp_salary = '15000.00'
*                                                   currency = 'EUR' )
*                                                   ( emp_id         = 4
*                                                   emp_first_name = 'Enrique'
*                                                   emp_last_name  = 'Irala'
*                                                   emp_age        = 30
*                                                   emp_role       = 'Developer'
*                                                   emp_addr_id    = '1'
*                                                   emp_email      = 'irala@logali.com'
*                                                   emp_salary = '10000.00'
*                                                   currency = 'USD' )
*                                                   ( emp_id       = 5
*                                                   emp_first_name = 'Jhon'
*                                                   emp_last_name  = 'Smith'
*                                                   emp_age        = 35
*                                                   emp_role       = 'Manager'
*                                                   emp_addr_id    = '1'
*                                                   emp_email      = 'irala@logali.com'
*                                                   emp_salary = '100000.00'
*                                                   currency = 'USD' )
*                                                   ( emp_id       = 6
*                                                   emp_first_name = 'Juan'
*                                                   emp_last_name  = 'Lopez'
*                                                   emp_age        = 40
*                                                   emp_role       = 'Accountant'
*                                                   emp_addr_id    = '1'
*                                                   emp_email      = 'irala@logali.com'
*                                                   emp_salary = '15000.00'
*                                                   currency = 'EUR' )
*                                                   ( emp_id         = 7
*                                                   emp_first_name = 'Enrique'
*                                                   emp_last_name  = 'Irala'
*                                                   emp_age        = 30
*                                                   emp_role       = 'Developer'
*                                                   emp_addr_id    = '1'
*                                                   emp_email      = 'irala@logali.com'
*                                                   emp_salary = '10000.00'
*                                                   currency = 'USD' )
*                                                   ( emp_id       = 8
*                                                   emp_first_name = 'Jhon'
*                                                   emp_last_name  = 'Smith'
*                                                   emp_age        = 35
*                                                   emp_role       = 'Manager'
*                                                   emp_addr_id    = '1'
*                                                   emp_email      = 'irala@logali.com'
*                                                   emp_salary = '100000.00'
*                                                   currency = 'USD' )
*                                                   ( emp_id       = 9
*                                                   emp_first_name = 'Juan'
*                                                   emp_last_name  = 'Lopez'
*                                                   emp_age        = 40
*                                                   emp_role       = 'Accountant'
*                                                   emp_addr_id    = '1'
*                                                   emp_email      = 'irala@logali.com'
*                                                   emp_salary = '15000.00'
*                                                   currency = 'EUR' )
*                                                   ( emp_id         = 10
*                                                   emp_first_name = 'Enrique'
*                                                   emp_last_name  = 'Irala'
*                                                   emp_age        = 30
*                                                   emp_role       = 'Developer'
*                                                   emp_addr_id    = '1'
*                                                   emp_email      = 'irala@logali.com'
*                                                   emp_salary = '10000.00'
*                                                   currency = 'USD' )
*                                                   ( emp_id       = 11
*                                                   emp_first_name = 'Jhon'
*                                                   emp_last_name  = 'Smith'
*                                                   emp_age        = 35
*                                                   emp_role       = 'Manager'
*                                                   emp_addr_id    = '1'
*                                                   emp_email      = 'irala@logali.com'
*                                                   emp_salary = '100000.00'
*                                                   currency = 'USD' )
*                                                   ( emp_id       = 12
*                                                   emp_first_name = 'Juan'
*                                                   emp_last_name  = 'Lopez'
*                                                   emp_age        = 40
*                                                   emp_role       = 'Accountant'
*                                                   emp_addr_id    = '1'
*                                                   emp_email      = 'irala@logali.com'
*                                                   emp_salary = '15000.00'
*                                                   currency = 'EUR' ) ) ).

* Global Temporary Table

*    DATA: lt_employee TYPE STANDARD TABLE OF ZEMP_GT_C07_C08.
*
*    lt_employee = VALUE #( ( emp_id = 1
*                             emp_first_name = 'Enrique'
*                             emp_last_name  = 'Pérez'
*                             emp_age        = '36'
*                             emp_role       = 'Developer' )
*                           ( emp_id = 2
*                             emp_first_name = 'Laura'
*                             emp_last_name  = 'García'
*                             emp_age        = '36'
*                             emp_role       = 'Manager' )  ).
*
*    MODIFY ZEMP_GT_C07_C08 FROM TABLE @lt_employee.
*
*    IF sy-subrc = 0.
*
*      SELECT * FROM ZEMP_GT_C07_C08 INTO TABLE @DATA(lt_results).
*
*      out->write( lt_results ).
*
*    ENDIF.



* Dynamic Cache

*    GET TIME STAMP FIELD DATA(lv_begin).
*
*    SELECT FROM ZEMP_C07_C08
*    FIELDS currency,
*           SUM( emp_salary ) AS TotalSalary
*    GROUP BY currency
*    INTO TABLE @DATA(lt_salary).
*
*    IF sy-subrc = 0.
*      GET TIME STAMP FIELD DATA(lv_end).
*
*      DATA(lv_dif) = cl_abap_tstmp=>subtract(
*                       tstmp1 = lv_end
*                       tstmp2 = lv_begin ).
*
*      out->write( lt_salary ).
*      out->write( |Execution Time: { lv_dif }| ).
*    ENDIF.


    MODIFY zdatasource_1 FROM TABLE @( VALUE #( ( id = 1
                                                  name1 = 'Record1'
                                                  datasource1 = 'A'  )

                                                 ( id = 2
                                                  name1 = 'Record2'
                                                  datasource1 = 'B'  )

                                                ( id = 5
                                                  name1 = 'Record5'
                                                  datasource1 = 'A'  )

                                                ( id = 6
                                                  name1 = 'Record6'
                                                  datasource1 = 'B'  )

                                                ( id = 7
                                                  name1 = 'Record7'
                                                  datasource1 = 'B'  )

                                                 ( id = 8
                                                  name1 = 'Record8'
                                                  datasource1 = 'B'  )  ) ).



    MODIFY zdatasource_2 FROM TABLE @( VALUE #( ( id = 3
                                                 name2 = 'Record3'
                                                 datasource2 = 'A'  )

                                                ( id = 4
                                                 name2 = 'Record4'
                                                 datasource2 = 'B'  )

                                               ( id = 5
                                                 name2 = 'Record5'
                                                 datasource2 = 'A'  )

                                               ( id = 6
                                                 name2 = 'Record6'
                                                 datasource2 = 'B'  )
                                               ( id = 9
                                                 name2 = 'Record9'
                                                 datasource2 = 'B'  )
                                                ( id = 10
                                                 name2 = 'Record10'
                                                 datasource2 = 'A'  )    ) ).


    MODIFY zdatasource_3 FROM TABLE @( VALUE #( ( id = 5
                                                name3 = 'Record5'
                                                datasource3 = 'A'  )

                                               ( id = 9
                                                name3 = 'Record9'
                                                datasource3 = 'B'  )

                                              ( id = 11
                                                name3 = 'Record11'
                                                datasource3 = 'A'  )

                                              ( id = 12
                                                name3 = 'Record12'
                                                datasource3 = 'B'  )
                                              ( id = 13
                                                name3 = 'Record13'
                                                datasource3 = 'B'  )
                                               ( id = 14
                                                name3 = 'Record14'
                                                datasource3 = 'B'  )    ) ).



  ENDMETHOD.
ENDCLASS.
