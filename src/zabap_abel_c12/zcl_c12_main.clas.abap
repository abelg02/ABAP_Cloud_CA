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

    "Para habilitar estas vistas lo que tenemos que hacer es ir a Window -> Show View -> Other -> ATC"


    "Otros componentes son los objetos de autorización para validar que el usuario que está ejecutando el código tenga autorización sobre ciertos"
    "componentes del sistema"

    "Para crearlo tenemos que hacer clic derecho en nuestro paquete -> New -> Other ABAP Repository Object y buscamos auth y seleccionamos"
    "Authorization Field. El Authorization Field debe estar asociado a un elemento de datos que tenga que ver con el objeto"

    "Hacer la validación"

    DATA: lv_country_code TYPE land1 VALUE 'ES'.

    AUTHORITY-CHECK OBJECT '/DMO/TRVL'
    ID '/DMO/CNTRY' FIELD lv_country_code
    ID '/ACTVT' FIELD '01'.

    IF sy-subrc = 0.
      out->write( 'You have authority' ).
    ELSE.
      out->write( 'You dont have authority' ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
