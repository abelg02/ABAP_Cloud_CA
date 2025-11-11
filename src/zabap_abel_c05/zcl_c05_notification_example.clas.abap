CLASS zcl_c05_notification_example DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_c05_notification_example IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    "IMPORTANTE ACTIVAR LAS DOS CLASES ANTES DE EJECUTAR PARA QUE FUNCIONE Y NO DÉ ERROR"

    out->write( |Ejemplo de NEW - Crear instancias | ).
    out->write( |==================================| ).
    "ANTES (forma antigua - 3 líneas)
    "DATA lo_notif TYPE REF TO zcl_notificacion"
    "CREATE OBJECT lo_notif EXPORTING iv_destinatario = 'admin@empresa.com'"
    "iv_mensaje = 'Sistema caído'"
    "iv_prioridad = 'URGENTE'."

    "AHORA (forma moderna 1 línea)"
    DATA(lo_notification) = NEW zcl_c05_notification(
    iv_destinatario = 'admin@empresa.com'
    iv_mensaje = 'Sistema caído - requiere atención inmediata'
    iv_prioridad = 'URGENTE'
    ).
    out->write( |Notificación creada: | ).
    out->write( |   Destinatario: { lo_notification->mv_destinatario }| ).
    out->write( |   Mensaje: { lo_notification->mv_mensaje }| ).
    out->write( |   Prioridad: { lo_notification->mv_prioridad }| ).
    out->write( |\n| ).

    "NEW también para referencias a datos simples"
    DATA(lr_contador) = NEW i( 100 ).
    DATA(lr_texto) = NEW string( 'Hola ABAP Cloud' ).
    out->write( |Referencias a datos:| ).
    out->write( |Contador: { lr_contador->* }| ).
    out->write( |Texto: { lr_texto->* }| ).

  ENDMETHOD.
ENDCLASS.
