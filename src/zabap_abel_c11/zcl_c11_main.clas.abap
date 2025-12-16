CLASS zcl_c11_main DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_c11_main IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

**Inline Declaration
*
*    SELECT * FROM /dmo/customer
*     INTO TABLE @DATA(lt_results)
*     UP TO 10 ROWS.
*
*    IF sy-subrc = 0.
*      out->write( lt_results ).
*    ENDIF.

**Column specifications
*
*    SELECT FROM /dmo/customer
*     FIELDS "* "de esta manera me traigo todos los campos
*     customer_id,
*     first_name,  "traigo solo los campos necesarios
*     last_name
*     INTO TABLE @DATA(lt_results2)
*     UP TO 10 ROWS.
*
*    IF sy-subrc = 0.
*      out->write( lt_results2 ).
*    ENDIF.

**HOST VARIABLES
*
*    CONSTANTS lc_inmediately TYPE c LENGTH 1 VALUE 'I'.
*
*    DATA lv_airline_id TYPE c LENGTH 3 VALUE 'LH'.
*
*    TYPES: BEGIN OF ty_result,
*             AirlineID    TYPE c LENGTH 3,
*             ConnectionID TYPE c LENGTH 4,
*             Availability TYPE c LENGTH 1,
*           END OF ty_result.
*
*    DATA ls_result TYPE ty_result.
*
*    SELECT SINGLE FROM /DMO/I_Flight
*           FIELDS AirlineID,
*                  ConnectionID,
*                  @lc_inmediately AS Availability
*            WHERE AirlineID EQ @lv_airline_id
*            INTO @ls_result.
*
*    IF sy-subrc EQ 0.
*      out->write( ls_result ).
*    ENDIF.

**CLAUSE SECUENCE
*
*    CONSTANTS lc_availability_seats TYPE int4 VALUE 30.
*
*    SELECT FROM /DMO/I_Flight
*           FIELDS AirlineID,
*                  ConnectionID
*           WHERE ( MaximumSeats - OccupiedSeats ) GE @lc_availability_seats
*           GROUP BY AirlineID, ConnectionID
*           ORDER BY AirlineID DESCENDING
*           INTO TABLE @DATA(lt_flights)
*           UP TO 30 ROWS.
*
*    IF sy-subrc EQ 0.
*      out->write( lt_flights ).
*    ENDIF.

**CASE
*
*    DATA: lv_date TYPE d VALUE '20300101'.
*
*    DATA(lv_current_date) = cl_abap_context_info=>get_system_date( ).
*
*    SELECT FROM /dmo/customer
*           FIELDS customer_id,
*                  country_code,
*
*           CASE country_code
*             WHEN 'US' THEN concat( 'United States -', concat_with_space( first_name, last_name, 2 ) )
*             WHEN 'DE' THEN concat( 'Germany - ', last_name )
*             WHEN 'ES' THEN concat( 'Spain -', last_name )
*             ELSE 'Another Country Code'
*           END AS columnCase1,
*
*           CASE
*             WHEN country_code = 'US' OR country_code = 'ES' THEN CASE title
*                                                                     WHEN 'Mr.' THEN 'US/ES - Mr.'
*                                                                     WHEN 'Mrs.' THEN 'US/ES - Mrs.'
*                                                                     ELSE 'US/ES - Different Title'
*                                                                   END
*
*             WHEN title = 'Mr.' THEN last_name
*             WHEN @lv_date < dats_add_days( @lv_current_date, -30 ) THEN 'Lower Date'
*             ELSE 'Nocondition applied'
*           END AS ColumnCase2
*
*           INTO TABLE @DATA(lt_results).
*
*    IF sy-subrc = 0.
*      out->write( lt_results ).
*    ENDIF.


** UNION
*
*    CONSTANTS lc_blank_date TYPE d VALUE '00000000'.
*
*    SELECT FROM /DMO/I_Flight
*           FIELDS AirlineID AS id,
*                  ConnectionID,
*                  FlightDate
*
*    UNION DISTINCT
*
*    SELECT FROM /DMO/I_Connection
*           FIELDS AirlineID AS id,
*                  ConnectionID,
*                  @lc_blank_date AS FlightDate
*
*    ORDER BY id ASCENDING
*    INTO TABLE @DATA(lt_results).
*
*    IF sy-subrc = 0.
*      out->write( lt_results ).
*    ENDIF.

** Intersect
*
*    SELECT FROM /dmo/flight AS f
*           INNER JOIN /dmo/carrier AS c ON c~carrier_id = f~carrier_id
*           FIELDS f~carrier_id, c~name
*
*    INTERSECT
*
*    SELECT FROM /dmo/carrier
*           FIELDS carrier_id, name
*
*    ORDER BY carrier_id ASCENDING, name
*
*    INTO TABLE @DATA(lt_final).
*
*    IF sy-subrc = 0.
*      out->write( lt_final ).
*    ENDIF.

* Except
    SELECT FROM /dmo/carrier
           FIELDS carrier_id, name

    EXCEPT

    SELECT FROM /dmo/flight AS f
           INNER JOIN /dmo/carrier AS c ON c~carrier_id = f~carrier_id
           FIELDS f~carrier_id, c~name

    ORDER BY carrier_id ASCENDING, name

    INTO TABLE @DATA(lt_final2).

    IF sy-subrc = 0.
      out->write( lt_final2 ).
    ENDIF.


**Inserción / Modificación – Subconsulta
*    MODIFY zflights_lgl FROM ( SELECT FROM /DMO/I_Flight AS Flight
*                                      INNER JOIN /DMO/I_Connection AS Connection
*                                            ON Flight~AirlineID    EQ Connection~AirlineID
*                                           AND Flight~ConnectionID EQ Connection~ConnectionID
*                                      FIELDS Flight~AirlineID,
*                                             Flight~ConnectionID,
*                                             Flight~FlightDate,
*                                             Connection~DepartureAirport,
*                                             Connection~DestinationAirport ).
*
*    SELECT FROM zflights_lgl
*           FIELDS *
*           INTO TABLE @DATA(lt_results).
*
*    IF sy-subrc EQ 0.
*      out->write( lt_results ).
*    ENDIF.



*SQL Functions
*    INSERT zdemo_exp_c11 FROM @( VALUE #( id = 'L'
*                                       num1 = 15
*                                       num2 = 8
*                                       char1 = 'aaBBCcDde'
*                                       char2 = '123456'
*                                       dec3 = '160.934'
*                                       amount = '100.00'
*                                       currency = 'USD' ) ).


* Numeric Functions

*DATA lv_decimal TYPE p LENGTH 5 DECIMALS 2 VALUE '17.82'.
*
*SELECT SINGLE FROM zdemo_exp_c11
*       FIELDS id,
*              num1,
*              num2,
*              CAST( num1 AS FLTP ) / CAST( num2 AS FLTP ) AS ratio,
*              division( num1, num2, 2 ) AS division,
*              div( num1, num2 ) AS div,
*              mod( num1, num2 ) AS mod,
*              num1 + num2 + @lv_decimal AS sum,
*              abs( num1 + num2 ) AS abs,
*              ceil( @lv_decimal ) AS ceil,
*              floor( @lv_decimal ) AS floor,
*              round( @lv_decimal, 2 ) AS round
*
*       WHERE id = 'L'
*       INTO @DATA(ls_results).
*
*IF sy-subrc = 0.
*  out->write( ls_results ).
*ENDIF.

** String Functions
*
*SELECT SINGLE FROM zdemo_exp_c11
*       FIELDS id,
*              char1,
*              char2,
*              left( char1, 2 ) AS left,
*              right( char1, 2 ) AS right,
*              lpad( char2, 18, '0' ) AS lpad,
*              rpad( char2, 18, '0' ) AS rpad,
*              ltrim( char1, 'B' ) AS ltrim,
*              rtrim( char1, 'e' ) AS rtrim,
*              instr( char1, 'BC' ) AS instr,
*              substring( char1, 3, 2 ) AS substring,
*              length( char1 ) AS length,
*              replace( char1, 'BC', '__' ) AS replace,
*              upper( char1 ) AS upper,
*              lower( char1 ) AS lower
*
*       WHERE id = 'L'
*       INTO @DATA(ls_results).
*
*IF sy-subrc = 0.
*  out->write( ls_results ).
*ENDIF.


* Concat functions

    SELECT SINGLE FROM zdemo_exp_c11
           FIELDS id,
                  char1,
                  char2,
                  concat( char1, char2 ) AS concat,
                  concat_with_space( char1, char2, 2 ) AS concatSpace,
                  char1 && char2 && 'Logali' AS concatman

           WHERE id = 'L'
           INTO @DATA(ls_results).

    IF sy-subrc = 0.
      out->write( ls_results ).
    ENDIF.



  ENDMETHOD.

ENDCLASS.
