CLASS zcl_71_connections2 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.


*    DATA carrier_id    TYPE /dmo/carrier_id.
*    DATA connection_id TYPE /DMO/Connection_id.
    METHODS constructor
      IMPORTING
        i_carrier_id TYPE /dmo/carrier_id
        i_connection_id TYPE /dmo/connection_id.


    CLASS-DATA conn_counter TYPE i.
    CLASS-METHODS create
      IMPORTING
        i_carrier_id TYPE /dmo/carrier_id
        i_connection_id_1 TYPE /dmo/connection_id
        i_carrier_id_1 TYPE /dmo/carrier_id
        i_connection_id TYPE /dmo/connection_id
      RETURNING
        value(r_result) TYPE REF TO zcl_71_connections2.
    CLASS-METHODS class_constructor.
    INTERFACES if_oo_adt_classrun .
    TYPES: tab TYPE STANDARD TABLE OF REF TO zcl_71_connections2 WITH DEFAULT KEY.

*    METHODS set_attributes
*      IMPORTING
*        i_carrier_id    TYPE /dmo/carrier_id
*        i_connection_id TYPE /dmo/connection_id
*      RAISING
*        cx_abap_invalid_value.
*
*    METHODS get_output
*      RETURNING
*        VALUE(r_output) TYPE string_table.

  PROTECTED SECTION.
  PRIVATE SECTION.
      DATA carrier_id    TYPE /dmo/carrier_id.
    DATA connection_id TYPE /DMO/Connection_id.

*  DATA carrier_id    TYPE s_carr_id.
*    DATA connection_id TYPE s_conn_id.

  DATA airport_from_id TYPE /dmo/airport_from_id.
    DATA airport_to_id   TYPE /dmo/airport_to_id.

ENDCLASS.



CLASS zcl_71_connections2 IMPLEMENTATION.

  METHOD create.

    r_result = NEW #(
      i_carrier_id = i_carrier_id
      i_connection_id = i_connection_id_1
    ).

    r_result->carrier_id = i_carrier_id_1.
    r_result->connection_id = i_connection_id.

  ENDMETHOD.

  METHOD class_constructor.

  ENDMETHOD.

  METHOD constructor.

    me->carrier_id = i_carrier_id.
    me->connection_id = i_connection_id.


     SELECT SINGLE
    FROM /dmo/connection
    fields airport_from_id, airport_to_id
    where carrier_id = @i_carrier_id
      and connection_id = @connection_id
      into ( @airport_from_id, @airport_to_id ).

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.

DATA connection TYPE REF TO lcl_connection.
    DATA connections TYPE TABLE OF REF TO lcl_connection.

* First Instance
**********************************************************************
    connection = NEW #(  ).

    TRY.
        connection->set_attributes(
          EXPORTING
            i_carrier_id    = 'LH'
            i_connection_id = '0400'
        ).

*        connection->carrier_id    = 'LH'.
*        connection->connection_id = '0400'.

        APPEND connection TO connections.

      CATCH cx_abap_invalid_value.
        out->write( `Method call failed` ).
    ENDTRY.

* Second instance
**********************************************************************

    connection = NEW #(  ).

    TRY.
        connection->set_attributes(
          EXPORTING
            i_carrier_id    = 'AA'
            i_connection_id = '0017'
        ).

*        connection->carrier_id    = 'AA'.
*        connection->connection_id = '0017'.

        APPEND connection TO connections.

      CATCH cx_abap_invalid_value.
        out->write( `Method call failed` ).
    ENDTRY.

* Third instance
**********************************************************************
    connection = NEW #(  ).

    TRY.
        connection->set_attributes(
          EXPORTING
            i_carrier_id    = 'SQ'
            i_connection_id = '0001'
        ).

*        connection->carrier_id    = 'SQ'.
*        connection->connection_id = '0001'.

        APPEND connection TO connections.

      CATCH cx_abap_invalid_value.
        out->write( `Method call failed` ).
    ENDTRY.


* Output
**********************************************************************

    LOOP AT connections INTO connection.

      out->write( connection->get_output( ) ).

    ENDLOOP.
  endmethod.

ENDCLASS.
