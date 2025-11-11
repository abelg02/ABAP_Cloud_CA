CLASS zcl_c01_main DEFINITION
PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_c01_main IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    "Escribir por consola"
    out->write( 'This is my first class in ABAP' ).


    "Declaración de una variable"
    DATA lv_string TYPE string.

    "Declaración de varias variables"
    DATA: lv_int  TYPE i VALUE 20251212,
          lv_date TYPE d,
          lv_dec  TYPE p LENGTH 8 DECIMALS 2 VALUE '202501.13',
          lv_car  TYPE c LENGTH 10 VALUE 'Text'.


    lv_string = 'Valor de la cadena de texto'.
    lv_date   = '20251212'.


    out->write( lv_string ).
    out->write( lv_int ).
    out->write( lv_date ).
    out->write( lv_dec ).
    out->write( lv_car ).


    "TYPES"
    TYPES: BEGIN OF lty_employee,
             id   TYPE i,
             name TYPE string,
             age  TYPE i,
           END OF lty_employee.

    DATA ls_employee TYPE lty_employee.

    ls_employee = VALUE #( id = 1
                           name = 'Abel'
                           age = 22 ).

    out->write( |ID: { ls_employee-id }, Nombre: { ls_employee-name }, Edad: { ls_employee-age }| ).


    "Reference"
    DATA lvr_int TYPE REF TO i.

    DATA lvr_int1 LIKE lvr_int.

    DATA lo_ref TYPE REF TO zcl_01_hello_world_jr.


    "Constants"
    CONSTANTS: lc_const TYPE c LENGTH 6 VALUE 'Logali'.


    "Inline Declarations"
    DATA(lv_str) = `Abel`.
    DATA(lv_str2) = 'Laura'.
    DATA(lv_var) = 4 + 7.
    out->write( lv_var ).


  ENDMETHOD.

ENDCLASS.
