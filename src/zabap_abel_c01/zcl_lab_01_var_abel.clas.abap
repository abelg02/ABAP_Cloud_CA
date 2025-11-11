CLASS zcl_lab_01_var_abel DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_lab_01_var_abel IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    "Tipo de datos elementales"
    "Creación de variables"
    DATA: mv_purchase_date TYPE d, "Tipo fecha"
          mv_purchase_time TYPE t. "Tipo hora"

    "Asignar fecha y hora actual entiendiendo que no hemos visto cómo asignar la fecha en tiempo real"
    mv_purchase_date = '20251029'.
    mv_purchase_time = '163000'.


    "ESTA SERÍA OTRA FORMA DE MOSTRAR LA FECHA Y HORA ACTUAL DEL SISTEMA"
    "mv_purchase_date = cl_abap_context_info=>get_system_date( )."
    "mv_purchase_time = cl_abap_context_info=>get_system_time( )."


    "Podríamos sintetizar código pero vamos a seguir paso a paso lo que nos pide tal cual el ejercicio"
    DATA: mv_price     TYPE f VALUE '10.5', "flotante, permite decimales grandes y negativos"
          mv_tax       TYPE i VALUE 16, "número entero de 4 bytes, sin decimales"
          mv_increase  TYPE decfloat16 VALUE '20.5', "número decimal con 16 dígitos significativos."
          mv_discounts TYPE decfloat34 VALUE '10.5', "número decimal con 34 dígitos significativos."
          mv_type      TYPE c LENGTH 8 VALUE 'PC', "carácter (texto), longitud fija"
          mv_shipping  TYPE p LENGTH 8 DECIMALS 2 VALUE '40.36', "packed number, para valores con decimales fijos"
          mv_id_code   TYPE n LENGTH 4 VALUE '1110', "numérico texto, solo dígitos, longitud fija, sin decimales"
          mv_qr_code   TYPE x LENGTH 5 VALUE 'F5CF'. "datos en hexadecimal (binario puro), longitud fija"


    "Tipo de datos complejos"
    TYPES: BEGIN OF mty_customer,
             id       TYPE i,
             customer TYPE c LENGTH 15,
             age      TYPE i,
           END OF mty_customer.

    DATA ms_customer TYPE mty_customer.

    ms_customer = VALUE #( id = 1
                           customer = 'Abel'
                           age = 22 ).

    out->write( |ID: { ms_customer-id }, Customer: { ms_customer-customer }, Age: { ms_customer-age }| ).
    out->write( |\n| ).


    "Tipo de datos de referencia"
    "Declaramos MS_EMPLOYEES como referencia a la tabla/estructura /DMO/EMPLOYEE_HR
    DATA ms_employees TYPE REF TO /dmo/employee_hr.

    "Ahora necesitamos instanciar la estructura para poder asignarle valores
    "En este caso usamos CREATE DATA, que es lo clásico para referencias
    CREATE DATA ms_employees.

    " Asignamos valores a los componentes de la estructura
    ms_employees->employee = 1001.
    ms_employees->first_name  = 'Juan'.
    ms_employees->last_name   = 'Pérez'.

    " Mostramos por consola usando la referencia (desreferenciamos con ->*)
    out->write( |Empleado ID: { ms_employees->employee }| ).
    out->write( |Nombre: { ms_employees->first_name } { ms_employees->last_name }| ).



    "Objetos de datos"
    DATA mv_product  TYPE string VALUE 'Laptop'.
    DATA mv_bar_code TYPE xstring VALUE '1212'. "Almacenar datos binarios (no texto legible), como imágenes, ficheros PDF, códigos QR, etc".



    "Constantes"
    CONSTANTS mc_purchase_date TYPE d VALUE '20251029'.
    CONSTANTS mc_purchase_time TYPE t VALUE '163000'.
    CONSTANTS mc_price         TYPE f VALUE '10.5'.
    CONSTANTS mc_tax           TYPE i       VALUE 16.
    CONSTANTS mc_increase      TYPE decfloat16 VALUE '20.5'.
    CONSTANTS mc_discounts     TYPE decfloat34 VALUE '10.5'.
    CONSTANTS mc_type          TYPE c LENGTH 8  VALUE 'PC'.
    CONSTANTS mc_shipping      TYPE p LENGTH 8 DECIMALS 2 VALUE '40.36'.
    CONSTANTS mc_id_code       TYPE n LENGTH 4 VALUE '1110'.
    CONSTANTS mc_qr_code       TYPE x LENGTH 5 VALUE 'F5CF'.
    CONSTANTS mc_product       TYPE string VALUE 'Laptop'.
    CONSTANTS mc_bar_code      TYPE xstring VALUE '1212'.


    "Asignación a las variables"
    mv_purchase_date = mc_purchase_date.
    mv_purchase_time = mc_purchase_time.
    mv_price         = mc_price.
    mv_tax           = mc_tax.
    mv_increase      = mc_increase.
    mv_discounts     = mc_discounts.
    mv_type          = mc_type.
    mv_shipping      = mc_shipping.
    mv_id_code       = mc_id_code.
    mv_qr_code       = mc_qr_code.
    mv_product       = mc_product.
    mv_bar_code      = mc_bar_code.


    out->write( mv_purchase_date ).
    out->write( mv_purchase_time ).
    out->write( mv_price ).
    out->write( mv_tax ).
    out->write( mv_increase ).
    out->write( mv_discounts ).
    out->write( mv_type ).
    out->write( mv_shipping ).
    out->write( mv_id_code ).
    out->write( mv_qr_code ).
    out->write( mv_product ).
    out->write( mv_bar_code ).


    "Declaración en línea traspasando los valores de las variables existentes"
    DATA(lv_product)  = mv_product.
    DATA(lv_bar_code) = mv_bar_code.



  ENDMETHOD.

ENDCLASS.
