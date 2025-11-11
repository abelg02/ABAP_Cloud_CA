CLASS zcl_71_hello_world2 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_71_hello_world2 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
  out->write( 'hello' ).
  ENDMETHOD.
ENDCLASS.
