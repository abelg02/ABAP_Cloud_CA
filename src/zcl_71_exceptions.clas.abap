CLASS zcl_71_exceptions DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

 DATA carrier_id    TYPE /dmo/carrier_id.
    DATA connection_id TYPE /DMO/Connection_id.

    CLASS-DATA conn_counter TYPE i.
    INTERFACES if_oo_adt_classrun .

 METHODS set_attributes
      IMPORTING
        i_carrier_id    TYPE /dmo/carrier_id
        i_connection_id TYPE /dmo/connection_id
      RAISING
        cx_abap_invalid_value.

          METHODS get_output
      returning
        value(r_output) type string_table.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_71_EXCEPTIONS IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

data lr type ref to lcl123.

    DATA numbers TYPE TABLE OF i.
    DATA output TYPE STANDARD TABLE OF string.

    DATA(counter) = 0.

do 20 times.

      CASE sy-index.
        WHEN 1.
          APPEND 0 TO numbers.
        WHEN 2.
          APPEND 1 TO numbers.
        WHEN OTHERS.
          APPEND numbers[  sy-index - 2 ]
               + numbers[  sy-index - 1 ]
              TO numbers.
      ENDCASE.


enddo.

    LOOP AT numbers INTO data(number).
      counter = counter + 1.

      APPEND |{ counter WIDTH = 4 }: { number WIDTH = 10 ALIGN = RIGHT }|
          TO output.
    ENDLOOP.



    out->write(
           data   = output
           name   = |The first 20 Fibonacci Numbers|
                  ) .

  ENDMETHOD.


  METHOD get_output.


     APPEND |------------------------------| TO r_output.
     APPEND |Carrier:     { carrier_id    }| TO r_output.
     APPEND |Connection:  { connection_id }| TO r_output.


  ENDMETHOD.


  METHOD set_attributes.

   IF i_carrier_id IS INITIAL OR i_connection_id IS INITIAL.
    RAISE EXCEPTION TYPE cx_abap_invalid_value.
  ENDIF.

  carrier_id    = i_carrier_id.
  connection_id = i_connection_id.

  ENDMETHOD.
ENDCLASS.
