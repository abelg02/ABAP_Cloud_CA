CLASS zcl_select_sql_one_c09_c10 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_select_sql_one_c09_c10 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*    "Me mostrará el primer registro que encuentre con esta condición"
*    "Por lo general casi nunca se usa el bypassing buffer"
*    SELECT SINGLE FROM zcarrier_c09_c10
*    FIELDS *
*    WHERE currency_code = 'USD'
*    INTO @DATA(ls_airline)
*    BYPASSING BUFFER.
*
*    IF sy-subrc = 0.
*      out->write( ls_airline ).
*    ENDIF.



    "Con appending lo que hacemos es que lo que tenemos en la tabla se conserva y agrega lo que está sosteniendo en la consulta"
    "Con into lo que haríamos sería guardar en la tabla interna y si tenemos otra consulta que guarda en la tabla interna pues lo reemplazaría"
    DATA: lt_airlines TYPE STANDARD TABLE OF zcarrier_c09_c10.

*    SELECT FROM zcarrier_c09_c10
*    FIELDS *
*    WHERE currency_code = 'USD'
*    INTO TABLE @lt_airlines.
*
*    IF sy-subrc = 0.
*      out->write( lt_airlines ).
*
*      out->write( 'Appending' ).
*
*      SELECT FROM zcarrier_c09_c10
*      FIELDS *
*      WHERE currency_code = 'EUR'
*      APPENDING TABLE @lt_airlines.
*
*      out->write( lt_airlines ).
*
*    ENDIF.



*    "Nueva sentencia select. Esta es la sentencia a llevar a cabo en lugar de select *"
*    out->write( 'New Select' ).
*
*    SELECT FROM zcarrier_c09_c10
*     FIELDS *
*      WHERE currency_code = 'ABD'
*      INTO TABLE @lt_airlines.
*
*    IF sy-subrc = 0.
*      out->write( lt_airlines ).
*    ELSE.
*      out->write( 'No data in internal table ' ).
*    ENDIF.



    TYPES: BEGIN OF ty_flights,
             airlineid    TYPE c LENGTH 3,
             connection   TYPE c LENGTH 4,
             price        TYPE p LENGTH 16 DECIMALS 2,
             currencycode TYPE c LENGTH 5,
           END OF ty_flights.

    "DATA: lt_flights TYPE STANDARD TABLE OF ty_flights."

*    "Como los nombre de los campos son diferentes de mis tablas simplemente usamos el alias "as""
*    SELECT FROM /dmo/flight
*    FIELDS carrier_id AS airlineid,
*           connection_id AS connection,
*           price,
*           currency_code AS currencycode
*    WHERE carrier_id = 'LH'
*    INTO TABLE @lt_flights.
*
*    IF sy-subrc = 0.
*
*      out->write( lt_flights ).
*
*    ENDIF.



*    "Manejo de más alias si fuera una estructura"
*    SELECT SINGLE FROM /dmo/flight
*      FIELDS carrier_id as airlineid,
*           connection_id as connectionid,
*           price,
*           currency_code as currencycode
*      WHERE carrier_id = 'AA'
*       AND  connection_id = '0322'
*       AND flight_date = '20260705'
*       INTO @DATA(ls_flight).
*
*    IF sy-subrc = 0.
*
*      out->write( ls_flight ).
*
*    ENDIF.



*    TYPES: BEGIN OF ty_flights2,
*             carrier_id    TYPE c LENGTH 3,
*             connection_id TYPE c LENGTH 4,
*             price         TYPE p LENGTH 16 DECIMALS 2,
*             "currencycode TYPE c LENGTH 5,
*           END OF ty_flights2.
*
*    DATA: lt_flights2 TYPE STANDARD TABLE OF ty_flights2.
*
*    SELECT FROM /dmo/flight
**     FIELDS carrier_id as airlineid,
**          connection_id,
**          price,
**          currency_code
*     FIELDS *
*     WHERE carrier_id = 'AA'
*      "INTO TABLE @DATA(lt_flight).
*     INTO CORRESPONDING FIELDS OF TABLE @lt_flights2.
*
*    IF sy-subrc = 0.
*
*      out->write( lt_flights2 ).
*
*    ENDIF.

*
*    SELECT FROM /dmo/flight
*    FIELDS *
*     WHERE carrier_id = 'AA'
*     INTO TABLE @DATA(lt_flights)
*     UP TO 4 ROWS.
*
*    IF sy-subrc = 0.
*
*      out->write( lt_flights ).
*
*    ENDIF.

*    DATA: lt_flights TYPE SORTED TABLE OF /dmo/flight
*                      WITH NON-UNIQUE KEY carrier_id connection_id.

*    SELECT FROM /dmo/flight
*        FIELDS *
*        "INTO  @DATA(ls_flights).
*      INTO TABLE @lt_flights
*      PACKAGE SIZE 3.
*
*      "out->write( ls_flights ).
*      out->write( lt_flights ).
*
*    ENDSELECT.


*    "Esta sentencia ya no es tan utilizada, ahora se usa otra en su lugar"
*    SELECT FROM /DMO/I_Flight
*    FIELDS *
*    FOR ALL ENTRIES IN @lt_flights
*    WHERE AirlineID = @lt_flights-carrier_id
*    INTO TABLE @DATA(lt_dummy).



* Operadores relacionales. Es lo mismo poner las letras que los símbolos:
* GT, >
* GE, >=
* LT, <
* LE, <=
* EQ, =
* NE, <>


*    "El operador GE significa que es mayor o igual (a la fecha indicada)"
*    SELECT FROM /dmo/flight
*            FIELDS *
*            WHERE flight_date GE '20240414'
*             INTO TABLE @DATA(lt_flights).



*    SELECT FROM /dmo/flight
*    FIELDS *
*     WHERE flight_date GE '20250414'
*       AND flight_date LE '20260414'
*      INTO TABLE @DATA(lt_flights).
*
*    IF sy-subrc = 0.
*      out->write( lines( lt_flights ) ).
*      out->write( lt_flights ).
*    ENDIF.


*    SELECT FROM /dmo/flight
*    FIELDS *
*     WHERE flight_date NOT BETWEEN '20240414' AND '20250414'
*      INTO TABLE @DATA(lt_flight2).
*
*    IF sy-subrc = 0.
*      out->write( lines( lt_flight2 ) ).
*      out->write( lt_flight2 ).
*    ENDIF.


*    "Aquí decimos que previo y posterior al string egel puede haber cualquier cosa con dicha sintaxis"
*
*    "Los guiones bajos sirven para indicar que van a haber dos caracteres previos. Por ejemplo en el caso de egel puede que hayan dos caracteres previos"
*    "y se muestren igual, pero en el caso de erlin (Berlín), si le pusieramos dos guiones bajos, al no tener dos caracteres previos sino uno pues no se"
*    "mostraría nada"
*
*    "DATA: lv_search_criteria TYPE string VALUE '%__egel%'.
*
*     DATA: lv_search_criteria TYPE string VALUE '%erlin%'.
*
*    "LIKE sirve para traer todos aquellos registros que cumplan con el patrón del string"
*    SELECT FROM /DMO/I_Airport
*    FIELDS *
*     WHERE name LIKE @lv_search_criteria
*      INTO TABLE @DATA(lt_airports).
*
*    IF sy-subrc = 0.
*      out->write( lt_airports ).
*    ELSE.
*      out->write( 'No Data' ).
*    ENDIF.


*    MODIFY zcarrier_c09_c10 FROM @( VALUE #( carrier_id = 'AV'
*                                             name = 'AVIANCA%'
*                                    currency_code = 'COP' ) ) .
*
*    DATA: c_escape TYPE c LENGTH 1 VALUE '*'.
*
*    SELECT FROM zcarrier_c09_c10
*    FIELDS *
*    "Tráeme todos los registros cuyo nombre CONTENGA un % en cualquier parte. El * ahí sirve solo para "escapar" el %, es decir: Le dice a SAP:"
*    "el % no es comodín, es un carácter normal"
*     WHERE name LIKE '%*%%' ESCAPE @c_escape
*      INTO TABLE @DATA(lt_carrier).
*
*    IF sy-subrc = 0.
*      out->write( lt_carrier ).
*    ELSE.
*      out->write( 'No Data' ).
*    ENDIF.




*    SELECT FROM /dmo/flight
*    FIELDS *
*     WHERE carrier_id IN ( 'AA', 'AC', 'JL' )
*      INTO TABLE @DATA(lt_carrier).
*
*    IF sy-subrc = 0.
*      out->write( lt_carrier ).
*    ELSE.
*      out->write( 'No Data' ).
*    ENDIF.



*    "Un rango es una tabla interna que nos va a permitir manejar intervalos"
*    DATA lr_price TYPE RANGE OF /dmo/flight_price.
*
*    "Consideramos todos los precios que se encuentren entre 500 y 1500"
*    lr_price = VALUE #( ( sign = 'I' "E
*                          option = 'BT' " EQ
*                          low = 500
*                          high = 1500 ) ).
*
*    "También consideramos los registros en los que el precio sea exactamente igual a 4996"
*    APPEND VALUE #( sign = 'I' "E
*                    option = 'EQ' " EQ
*                       low = '4996.00' ) to lr_price.

*    "Una vez definido el rango lo podemos usar con la cláusula IN"
*    SELECT FROM /dmo/flight
*    FIELDS *
*     WHERE price IN @lr_price
*       and currency_code = 'USD'
*      INTO TABLE @DATA(lt_flights).
*
*    IF sy-subrc = 0.
*      out->write( lt_flights ).
*    ELSE.
*      out->write( 'No Data' ).
*    ENDIF.




*    CONSTANTS lc_no_value TYPE c VALUE ''.
*
*    SELECT FROM /dmo/flight
*      FIELDS *
*       WHERE currency_code IS NULL
*          OR currency_code = @lc_no_value
*          OR currency_code = @space
*        INTO TABLE @DATA(lt_flights).
*
*    IF sy-subrc = 0.
*      out->write( lt_flights ).
*    ELSE.
*      out->write( 'No Null or empty values available' ).
*    ENDIF.




*    SELECT FROM /DMO/I_Connection
*      FIELDS *
*       WHERE
*             ( AirlineID = 'AA' OR AirlineID = 'LH' )
*         AND
*             ( DepartureAirport = 'SFO' OR
*               DepartureAirport = 'JFK' )
*        AND
*            NOT ConnectionID = '0401'
*
*         INTO TABLE @DATA(lt_connection).
*
*    IF sy-subrc = 0.
*      out->write( lt_connection ).
*    ELSE.
*      out->write( 'No Data' ).
*    ENDIF.



*    "Registro con el valor mínimo y registro con el valor máximo"
*    SELECT FROM /DMO/I_Flight
*          FIELDS MIN( MaximumSeats ) AS MinSeats,
*                 MAX( MaximumSeats ) AS MaxSeats
*          "Lo separamos entre variables propias separados por coma"
*          "INTO ( @DATA(lv_minseats), @DATA(lv_maxseats) ).
*          "O podemos guardarlo en una estructura directamente"
*           INTO @DATA(ls_min_max).
*
*    IF sy-subrc = 0.
*      "out->write( |Min Seats: { lv_minseats }, Max Seats: { lv_maxseats }| ).
*      out->write( ls_min_max ).
*    ENDIF.



*    "Sacamos el average de los valores distintos de MaximumSeats y posteriormente la sumatoria"
*    SELECT FROM /DMO/I_Flight
*    FIELDS AVG( DISTINCT MaximumSeats ) AS AvgSeats,
*           SUM( DISTINCT MaximumSeats ) AS SumSeats
*    WHERE AirlineID = 'AA'
*      INTO ( @DATA(lv_avgseats), @DATA(lv_sumseats) ).
*
*    IF sy-subrc = 0.
*      out->write( |AVG Seats: { lv_avgseats }, SUM Seats: { lv_sumseats }| ).
*    ENDIF.





*    SELECT FROM /DMO/I_Flight
*    FIELDS DISTINCT MaximumSeats
*    WHERE AirlineID = 'AA'
*      INTO @DATA(lv_distinct).
*
*      IF sy-subrc = 0.
*        out->write( lv_distinct ).
*      ENDIF.
*
*    ENDSELECT.



*    SELECT FROM /DMO/I_Flight
*    FIELDS DISTINCT MaximumSeats
*    WHERE AirlineID = 'AA'
*      INTO table @DATA(lt_distinct).
*
*      IF sy-subrc = 0.
*        out->write( lt_distinct ).
*      ENDIF.



*    SELECT FROM /DMO/I_Flight
*     FIELDS COUNT( * ) AS countall,
*            COUNT( DISTINCT MaximumSeats ) AS countMaxSeats
*     WHERE AirlineID = 'AA'
*       INTO ( @DATA(lv_countall), @DATA(lv_scountmaxseats) ).
*
*    IF sy-subrc = 0.
*      out->write( |Count All: { lv_countall }, Count max Seats: { lv_scountmaxseats }| ).
*    ENDIF.



*    SELECT FROM /DMO/I_Flight
*    FIELDS AirlineID,
*           CurrencyCode,
*           COUNT( DISTINCT ConnectionID ) AS CountDisConn
*    WHERE FlightDate GE '20240101'
*     GROUP BY AirlineID, CurrencyCode
*      INTO TABLE @DATA(lt_results).
*
*    IF sy-subrc = 0.
*      out->write( lt_results ).
*    ENDIF.




*1. from
*2. where
*3. group by
*4. having
*5. select
*6. order by
*7. up to (limit)

*    "Con having apicamos un filtro sobre la agrupación"
*    SELECT FROM /DMO/I_Flight
*    FIELDS AirlineID,
*          MIN( MaximumSeats ) AS MinSeats,
*          MAX( MaximumSeats ) AS MaxSeats
*    WHERE FlightDate BETWEEN '20240101' AND '20301231'
*     GROUP BY AirlineID
*     HAVING AirlineID IN ( 'AA', 'LH', 'UA' )
*      INTO TABLE @DATA(lt_results).
*
*    IF sy-subrc = 0.
*      out->write( lt_results ).
*    ENDIF.



*    SELECT FROM /DMO/I_Flight
*        FIELDS AirlineID,
*               ConnectionID,
*               FlightDate,
*               Price,
*               CurrencyCode
*        WHERE FlightDate BETWEEN '20240101' AND '20301231'
*        ORDER BY FlightDate DESCENDING "Ascending
*          INTO TABLE @DATA(lt_results).
*
*    IF sy-subrc = 0.
*      out->write( lt_results ).
*    ENDIF.



*        SELECT FROM /DMO/I_Flight
*        FIELDS AirlineID,
*               ConnectionID,
*               FlightDate,
*               Price,
*               CurrencyCode
*        WHERE FlightDate BETWEEN '20240101' AND '20301231'
*        ORDER BY PRIMARY KEY
*          INTO TABLE @DATA(lt_results).
*
*    IF sy-subrc = 0.
*      out->write( lt_results ).
*    ENDIF.



*1. from
*2. where
*3. group by
*4. having
*5. select
*6. order by
*7. up to (limit)


*    SELECT FROM /DMO/I_Flight
*    FIELDS AirlineID,
*           MIN( Price ) AS MinPrice
*    WHERE PlaneType = '767-200'
*    GROUP BY AirlineID, CurrencyCode HAVING CurrencyCode IN ( 'USD', 'EUR' )
*    ORDER BY AirlineID ASCENDING
*      INTO TABLE @DATA(lt_results)
*      UP TO 3 ROWS.
*
*    IF sy-subrc = 0.
*      out->write( lt_results ).
*    ENDIF.


*    select SINGLE from /DMO/I_Flight
*      fields *
*      order by
*      into data@( ls_results).




* OFFSET

*   "Através de offset podemos paginar. Es el control de la paginación usando tres variables. Es decir, a través de la sentencia select mostraremos"
*   "10 registros por cada paginación"

*   "Número de páginas"
    DATA: lv_page_number      TYPE i VALUE 2,
          "Número de registros por página"
          lv_records_per_page TYPE i VALUE 10.

*   "Variable offset"
    DATA: gv_offset TYPE int8.

* Page 1 = Block 0
* Page 2 = Block 1

    "El cálculo del offset se calcula: El número de la página en la que estoy menos 1 multiplicado por el número de registros por página"
    gv_offset = ( lv_page_number - 1 ) * lv_records_per_page.

    SELECT FROM /DMO/I_Flight
    FIELDS *
    WHERE CurrencyCode = 'USD'
    ORDER BY AirlineID, ConnectionID, FlightDate ASCENDING
    INTO TABLE @DATA(lt_results)
    OFFSET @gv_offset
    UP TO @lv_records_per_page ROWS.

    IF sy-subrc = 0.
      out->write( lt_results ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
