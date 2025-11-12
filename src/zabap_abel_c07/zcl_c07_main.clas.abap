CLASS zcl_c07_main DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  iNTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_c07_main IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

  "Diccionarios: los diccionarios funcionarán como la capa entre nuestro código ABAP y la base de datos de SAP HANA"
  "De esta manera podremos definir estructuras de datos una sola vez y reutilizarlas en todo el sistema"
  "Si necesitamos que nuestro objeto/estructura/tabla sea global y demás usuarios puedan acceder debemos ponerlo en nuestro diccionario de datos"

  ENDMETHOD.

ENDCLASS.
