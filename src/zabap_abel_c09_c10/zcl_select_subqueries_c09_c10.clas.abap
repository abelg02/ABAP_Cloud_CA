CLASS zcl_select_subqueries_c09_c10 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_select_subqueries_c09_c10 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

*    "AS: Alias"
*    SELECT FROM /dmo/flight
*    FIELDS carrier_id AS Airline,
*           connection_id AS Connection
*    GROUP BY carrier_id, connection_id
*    INTO TABLE @DATA(lt_flights).
*
*    IF sy-subrc = 0.
*      out->write( lt_flights ).
*    ENDIF.



*    "Subquery: consulta dentro de otra consulta. Sirve para usar el resultado de un SELECT como condición o dato de otro SELECT."
*    SELECT FROM /DMO/I_Flight
*    FIELDS *
*    WHERE price EQ ( SELECT FROM /DMO/I_Flight
*                     FIELDS MIN( price ) )
*    INTO TABLE @DATA(lt_lowcost).
*
*    IF sy-subrc = 0.
*      out->write( lt_lowcost ).
*    ENDIF.



*    SELECT FROM /DMO/I_Flight
*    FIELDS *
*    where airlineid in ( select from /DMO/I_Connection
*                         fields AirlineID
*                         where DepartureAirport eq 'JFK' )
*    INTO TABLE @DATA(lt_flights).
*
*    IF sy-subrc = 0.
*      out->write( lt_flights ).
*    ENDIF.



    " ANY/SOME
*    SELECT FROM /DMO/I_Connection AS Connection
*    FIELDS *
*    WHERE AirlineID eq some ( SELECT FROM /DMO/I_Flight
*                         FIELDS AirlineID
*                         WHERE OccupiedSeats GE 100 )
*    INTO TABLE @DATA(lt_flights).
*
*    IF sy-subrc = 0.
*      out->write( lt_flights ).
*    ENDIF.



    " Exists
    SELECT FROM /DMO/I_Flight AS flights
    FIELDS *
    WHERE OccupiedSeats LT flights~MaximumSeats
    AND EXISTS ( SELECT FROM zcarrier_c09_c10
                 FIELDS carrier_id
                 WHERE carrier_id = flights~AirlineID ) "'XX' )
    INTO TABLE @DATA(lt_flights).

    IF sy-subrc = 0.
      out->write( lt_flights ).
    ELSE.
      out->write( 'No data' ).
    ENDIF.


  ENDMETHOD.

ENDCLASS.
