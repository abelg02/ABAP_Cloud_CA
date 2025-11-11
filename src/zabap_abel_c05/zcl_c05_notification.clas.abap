CLASS zcl_c05_notification DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .
  PUBLIC SECTION.
    DATA: mv_destinatario TYPE string,
          mv_mensaje      TYPE string,
          mv_prioridad    TYPE string.
    METHODS: constructor IMPORTING iv_destinatario TYPE string
                                   iv_mensaje      TYPE string
                                   iv_prioridad    TYPE string,
      enviar.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_c05_notification IMPLEMENTATION.

  METHOD constructor.
    mv_destinatario = iv_destinatario.
    mv_mensaje = iv_mensaje.
    mv_prioridad = iv_prioridad.
  ENDMETHOD.

  METHOD enviar.
    "Lógica de envío aquí"
  ENDMETHOD.

ENDCLASS.
