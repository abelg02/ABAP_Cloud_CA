CLASS zcl_71_connections DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    DATA carrier_id    TYPE /dmo/carrier_id.
    DATA connection_id TYPE /DMO/Connection_id.

    CLASS-DATA conn_counter TYPE i.
    INTERFACES if_oo_adt_classrun .

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
ENDCLASS.



CLASS ZCL_71_CONNECTIONS IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA lr_conn2 TYPE REF TO zcl_71_connections2.

    lr_conn2 = zcl_71_connections2=>create(
          EXPORTING
            i_carrier_id    = 'LH'
            i_connection_id = '0400'
            i_carrier_id_1 = 'LH'
            i_connection_id_1  = '0401' ).

    DATA connection  TYPE REF TO lcl_connection.
    DATA connections  TYPE TABLE OF REF TO lcl_connection.

* Create Instance
**********************************************************************

    connection = NEW #(  ).

    connection->set_attributes(
      EXPORTING
        i_carrier_id    = 'LH'
        i_connection_id = '0400'
    ).

    APPEND connection TO connections.

* Calling Functional Method
**********************************************************************
    " in a value assignment (with inline declaration for result)
    DATA(result) = connection->get_output( ).

    " in logical expression
    IF connection->get_output(  ) IS NOT INITIAL.

      " as operand in a statement
      LOOP AT connection->get_output(  ) INTO DATA(line).

      ENDLOOP.

      "  to supply input parameter of another method
      out->write( data = connection->get_output( )
                  name = `  ` ).

    ENDIF.


  ENDMETHOD.
ENDCLASS.
