CLASS zcl_c12_main DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_c12_main IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    "ABAP Test Cockpit es una herramienta de análisis de código en SAP que asegura calidad, rendimiento y seguridad en desarrollos ABAP."
    "Realiza análisis estáticos, detecta problemas de rendimiento, errores, y riesgos de seguridad y facilita el cumplimiento de estándares."

    "Este es un ejemplo de advertencia en ATC, ya que lo recomendable es filtrar los campos correspondientes, no marcarlos todos"
    SELECT * FROM /dmo/flight
    INTO TABLE @DATA(lt_results).

    "Sirve para validar mi componente o todos los componentes de un paquete con clic derecho -> Run As -> ABAP Test Cockpit"
    "Con esto podemos ver avisos que pueden llegar a ser errores que podemos corregir para dejar el código lo más limpio posible"

  ENDMETHOD.

ENDCLASS.
