CLASS zcl_c09_c10_main DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_c09_c10_main IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

* Insert Data

    "Inserción de un solo registro"
    DATA: ls_airline TYPE zcarrier_c09_c10.

*    ls_airline = VALUE #( carrier_id = 'AA'
*                          name = 'American Airlines'
*                          currency_code = 'USD' ).
*
*    "Tres formas diferentes de insertar datos una por una pero de manera diferente con diferencias"
*
*    "INSERT INTO zcarrier_c09_c10 VALUES @ls_airline."
*    "INSERT zcarrier_c09_c10 FROM @ls_airline."
*
*    "De esta manera usamos la nomenclatura sql pero sin declarar una estructura de manera independiente."
*    INSERT zcarrier_c09_c10 FROM @( VALUE #( carrier_id = 'KLM'
*                                             name = 'KLM'
*                                             currency_code = 'EUR' ) ).
*
*    "Toda sentencia sql se debe de validar para comprobar si su ejecución fue correcta de esta manera"
*    IF sy-subrc = 0.
*      out->write( 'Insert correct' ).
*    ELSE.
*      out->write( 'Insert error' ).
*    ENDIF.
*
*
*
*    "Para insertar múltiples registros tengo que hacerlo de la siguiente manera, que es como se suele hacer más frecuentemente"
*    "Multiple records"
*    "Primero borramos de forma completa mi tabla de base de datos"
*    DELETE FROM zcarrier_c09_c10.
*
*    "Declaramos una tabla interna con la misma estructura de mi tabla de base de datos"
*    DATA lt_ddbb TYPE STANDARD TABLE OF zcarrier_c09_c10.
*
*    "Con esta sentencia limpiamos nuestra tabla interna, es decir, la dejamos vacía"
*    FREE: lt_ddbb.

    "Seleccionamos de la tabla de base de datos todos aquellos registros donde la moneda sea USD y lo guardamos en la tabla interna"
*    SELECT FROM /dmo/i_carrier
*    FIELDS *
*      WHERE CurrencyCode = 'USD'
*      INTO TABLE @DATA(lt_airlines).
*
*    "Esta sentencia la podríamos hacer comentando el corresponding que hacemos abajo para especificar otra fuente de datos seleccionando los datos que"
*    "nos interesan y ahorrándonos el mapping. Es una práctica mejor especificando los campos que realmente necesitamos"
*
*    SELECT FROM /dmo/carrier
*    FIELDS carrier_id,
*           name,
*           currency_code
*      WHERE currency_code = 'USD'
*       INTO CORRESPONDING FIELDS OF TABLE @lt_ddbb.
*
*
*    "Una vez guardado en la tabla interna insertamos todos los registros obtenidos desde la tabla interna"
*    "Dado que los nombres de la tabla de la tabla que estoy obteniendo los datos "/dmo/i_carrier" tienen campos diferentes a los que guardamos en la tabla"
*    "interna tenemos que mover los campos correspondientes y mapeamos indicando los campos de nuestra tabla interna"
*    IF sy-subrc = 0.
*
**      lt_ddbb = CORRESPONDING #( lt_airlines MAPPING carrier_id = AirlineID
**                                                     currency_code = CurrencyCode ).
*
*      INSERT zcarrier_c09_c10 FROM TABLE @lt_ddbb.
*
*      IF sy-subrc = 0.
*        out->write( 'Insert correct' ).
*      ELSE.
*        out->write( 'Insert error' ).
*      ENDIF.
*
*    ENDIF.


*---> Update: Actualización de registros que existan en la tabla de base de datos
*    "Select single selecciona un registro, y seleccionará el primero que encuentre en la condición where"
*    SELECT SINGLE FROM zcarrier_c09_c10
*    FIELDS *
*    WHERE carrier_id = 'KL'
*      INTO @ls_airline.
*
*    IF sy-subrc = 0.
*
*      ls_airline = VALUE #( carrier_id = 'KL'
*                            "name = 'American Airlines'"
*                            currency_code = 'USD' ).
*
*      ls_airline-currency_code = 'EUR'.
*
*      UPDATE zcarrier_c09_c10 FROM @ls_airline.
*
*      IF sy-subrc = 0.
*        out->write( 'Update correct' ).
*      ENDIF.
*
*    ENDIF.

*   "Multiple records"

*    "Hacemos un select a la tabla y nos traemos todos los campos y guardo la información en una tabla interna"
*    SELECT FROM zcarrier_c09_c10
*    FIELDS *
*      INTO TABLE @DATA(lt_airline).
*
*    IF sy-subrc = 0.
*
*      "A todos los registros de la tabla interna le ponemos la moneda MXN"
*      LOOP AT lt_airline ASSIGNING FIELD-SYMBOL(<fs_airline>).
*        <fs_airline>-currency_code = 'MXN'.
*      ENDLOOP.
*
*      "Actualizamos la tabla de la base de datos a la tabla interna"
*      UPDATE zcarrier_c09_c10 FROM TABLE @lt_airline.
*
*      IF sy-subrc = 0.
*        out->write( 'Update correct' ).
*      ENDIF.
*
*    ENDIF.


*   "Columns"
*    UPDATE zcarrier_c09_c10
*    SET currency_code = 'EUR'
*    WHERE carrier_id = 'CO'
*        OR carrier_id = 'FJ'.
*
*    IF sy-subrc = 0.
*      out->write( 'Update correct' ).
*    ENDIF.


*    UPDATE zcarrier_c09_c10
*    SET counter = counter + 10
*    WHERE carrier_id = 'CO'.
*    "or carrier_id = 'FJ'."
*
*    IF sy-subrc = 0.
*      out->write( 'Update correct' ).
*    ENDIF.


*---> Modify: Si el campo existe lo modifica y si no existe lo agrega a la tabla de base de datos
*    ls_airline = VALUE #( carrier_id = 'WZ'
*                          name = 'Wizz Air'
*                          currency_code = 'USD' ).
*
*    MODIFY zcarrier_c09_c10 FROM @ls_airline.
*
*    IF sy-subrc = 0.
*      out->write( 'Modify correct' ).
*    ENDIF.


*    "Seleccionamos de la tabla todos los campos de la condición where y lo guardamos en una tabla interna"
*    SELECT FROM zcarrier_c09_c10
*    FIELDS *
*    WHERE carrier_id = 'UA'
*       OR carrier_id = 'WZ'
*        INTO TABLE @DATA(lt_airline).
*
*    IF sy-subrc = 0.
*
*      "A la tabla interna le cambiamos el valor MXN"
*      LOOP AT lt_airline ASSIGNING FIELD-SYMBOL(<fs_airline>).
*        <fs_airline>-currency_code = 'MXN'.
*      ENDLOOP.
*
*      "Agregamos a la misma tabla interna un valor que se llama Avianca"
*      APPEND VALUE #( carrier_id = 'AV'
*                      name = 'Avianca'
*                      currency_code = 'COP' ) TO lt_airline.
*
*      "Modificamos la tabla de la base de datos desde la tabla interna"
*      MODIFY zcarrier_c09_c10 FROM TABLE @lt_airline.
*
*      IF sy-subrc = 0.
*        out->write( 'Modify correct' ).
*      ENDIF.
*
*    ENDIF.



*---> Delete

*    "Un registro: A una estructura le pasamos valores"
*    "Cuando usemos este caso validar que nuestra estructura no esté vacía"
*    ls_airline = VALUE #( carrier_id = 'WZ'
*                          name = 'Wizz Air'
*                          currency_code = 'USD' ).
*
*    DELETE zcarrier_c09_c10 FROM @ls_airline.
*
*    IF sy-subrc = 0.
*      out->write( 'Delete correct' ).
*    ENDIF.


*    "Multiple records: Seleccionamos todos los datos de la tabla carrier donde el currency_code sea EUR"
*    "Cuando usemos este caso validar que la tabla no esté vacía"
*    SELECT FROM zcarrier_c09_c10
*    FIELDS *
*    WHERE currency_code = 'EUR'
*      INTO TABLE @DATA(lt_airline).
*
*
*    IF sy-subrc = 0.
*
*    "check lt_airline is not initial."
*
*      DELETE zcarrier_c09_c10 FROM TABLE @lt_airline.
*
*      IF sy-subrc = 0.
*        out->write( 'Delete correct' ).
*      ENDIF.
*
*    ENDIF.


*    "With condition"
*    "Obligatorio poner la condición where para no borrar la tabla de base de datos completa"
*    DELETE FROM zcarrier_c09_c10
*        WHERE currency_code = 'MXN'
*           OR currency_code = 'COP'.
*
*    IF sy-subrc = 0.
*      out->write( 'Delect correct' ).
*    ENDIF.



  ENDMETHOD.

ENDCLASS.
