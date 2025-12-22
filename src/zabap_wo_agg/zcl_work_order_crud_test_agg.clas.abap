CLASS zcl_work_order_crud_test_agg DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PRIVATE SECTION.
    METHODS:
      " Métodos de test para cada operación CRUD
      test_create_work_order
        IMPORTING
          io_out TYPE REF TO if_oo_adt_classrun_out,

      test_read_work_order
        IMPORTING
          io_out TYPE REF TO if_oo_adt_classrun_out,

      test_update_work_order
        IMPORTING
          io_out TYPE REF TO if_oo_adt_classrun_out,

      test_delete_work_order
        IMPORTING
          io_out TYPE REF TO if_oo_adt_classrun_out,

      " Método auxiliar para mostrar mensajes
      show_message
        IMPORTING
          iv_text      TYPE string
          iv_is_error  TYPE abap_bool DEFAULT abap_false
          io_out       TYPE REF TO if_oo_adt_classrun_out,

      " Método auxiliar para crear datos de prueba
      setup_test_data.
ENDCLASS.



CLASS zcl_work_order_crud_test_agg IMPLEMENTATION.

 METHOD if_oo_adt_classrun~main.
    " Este es el método principal que se ejecuta al correr la clase

    out->write( '==========================================' ).
    out->write( ' INICIANDO PRUEBAS CRUD - ÓRDENES DE TRABAJO' ).
    out->write( '==========================================' ).
    out->write( '' ).  " Línea vacía

    " 1. Preparar datos de prueba (clientes y técnicos)
    setup_test_data( ).
    out->write( '✅ Datos de prueba creados (clientes y técnicos)' ).
    out->write( '' ).

    " 2. Ejecutar pruebas
    test_create_work_order( io_out = out ).
    test_read_work_order( io_out = out ).
    test_update_work_order( io_out = out ).
    test_delete_work_order( io_out = out ).

    out->write( '' ).
    out->write( '==========================================' ).
    out->write( ' PRUEBAS COMPLETADAS' ).
    out->write( '==========================================' ).
  ENDMETHOD.

    METHOD setup_test_data.
    " Crear algunos clientes y técnicos de prueba

    " 1. Limpiar tablas primero (opcional, solo para pruebas)
    DELETE FROM zdt_customer_agg.
    DELETE FROM zdt_tech_agg.

    " 2. Crear tabla interna de clientes
    DATA lt_customers TYPE TABLE OF zdt_customer_agg.

    lt_customers = VALUE #(
      ( customer_id = '00000001'
        name        = 'Cliente Prueba 1'
        address     = 'Calle Falsa 123'
        phone       = '600111222' )
      ( customer_id = '00000002'
        name        = 'Cliente Prueba 2'
        address     = 'Avenida Siempre Viva 456'
        phone       = '600333444' )
    ).

    " 3. Insertar clientes
    INSERT zdt_customer_agg FROM TABLE @lt_customers.

    " 4. Crear tabla interna de técnicos
    DATA lt_technicians TYPE TABLE OF zdt_tech_agg.

    lt_technicians = VALUE #(
      ( technician_id = 'TEC001'
        name          = 'Técnico Juan Pérez'
        specialty     = 'Electricidad' )
      ( technician_id = 'TEC002'
        name          = 'Técnica María López'
        specialty     = 'Fontanería' )
    ).

    " 5. Insertar técnicos
    INSERT zdt_tech_agg FROM TABLE @lt_technicians.
  ENDMETHOD.

  METHOD show_message.
    IF iv_is_error = abap_true.
      io_out->write( |❌ ERROR: { iv_text }| ).
    ELSE.
      io_out->write( |✅ { iv_text }| ).
    ENDIF.
  ENDMETHOD.

      METHOD test_create_work_order.
    io_out->write( '--- TEST: CREAR ORDEN DE TRABAJO ---' ).

    " 1. Instanciar el handler CRUD
    DATA(lo_handler) = NEW zcl_wo_crud_handler_agg( ).

    " 2. Preparar datos de una orden válida
    DATA ls_work_order TYPE zdt_wo_agg.

    ls_work_order-work_order_id   = '0000000001'.
    ls_work_order-customer_id     = '00000001'.    " Cliente que existe
    ls_work_order-technician_id   = 'TEC001'.      " Técnico que existe
    ls_work_order-creation_date   = cl_abap_context_info=>get_system_date( ).
    ls_work_order-status          = 'PE'.          " Pendiente
    ls_work_order-priority        = 'A'.           " Alta
    ls_work_order-description     = 'Reparación eléctrica en oficina principal'.

    " 3. Intentar crear la orden
    DATA(lv_success) = lo_handler->create_work_order( ls_work_order ).

    IF lv_success = abap_true.
      show_message(
        iv_text = 'Orden creada exitosamente'
        io_out  = io_out
      ).
    ELSE.
      show_message(
        iv_text     = 'Fallo al crear la orden (datos inválidos o validación falló)'
        iv_is_error = abap_true
        io_out      = io_out
      ).
    ENDIF.

    " 4. Probar crear orden con datos inválidos (técnico no existe)
    DATA ls_bad_order TYPE zdt_wo_agg.

    ls_bad_order-work_order_id   = '0000000002'.
    ls_bad_order-customer_id     = '00000001'.    " Cliente existe
    ls_bad_order-technician_id   = 'TEC999'.      " Técnico NO existe
    ls_bad_order-creation_date   = cl_abap_context_info=>get_system_date( ).
    ls_bad_order-status          = 'PE'.
    ls_bad_order-priority        = 'A'.
    ls_bad_order-description     = 'Orden con técnico inválido'.

    lv_success = lo_handler->create_work_order( ls_bad_order ).

    IF lv_success = abap_false.
      show_message(
        iv_text = 'Validación funcionó: rechazó orden con técnico inexistente'
        io_out  = io_out
      ).
    ELSE.
      show_message(
        iv_text     = 'ERROR: Debería haber rechazado técnico inexistente'
        iv_is_error = abap_true
        io_out      = io_out
      ).
    ENDIF.

    io_out->write( '' ).  " Línea vacía
  ENDMETHOD.

    METHOD test_read_work_order.
    io_out->write( '--- TEST: LEER ORDEN DE TRABAJO ---' ).

    DATA(lo_handler) = NEW zcl_wo_crud_handler_agg( ).

    " 1. Leer orden que debería existir (la que creamos en test_create)
    DATA(ls_read_order) = lo_handler->read_work_order( '0000000001' ).

    IF ls_read_order-work_order_id IS NOT INITIAL.
      show_message(
        iv_text = |Orden leída: ID { ls_read_order-work_order_id }, Descripción: { ls_read_order-description }|
        io_out  = io_out
      ).
    ELSE.
      show_message(
        iv_text     = 'No se pudo leer la orden (no existe)'
        iv_is_error = abap_true
        io_out      = io_out
      ).
    ENDIF.

    " 2. Leer orden que NO existe
    ls_read_order = lo_handler->read_work_order( '9999999999' ).

    IF ls_read_order-work_order_id IS INITIAL.
      show_message(
        iv_text = 'Correcto: devolvió vacío para orden inexistente'
        io_out  = io_out
      ).
    ELSE.
      show_message(
        iv_text     = 'ERROR: Debería devolver vacío para orden inexistente'
        iv_is_error = abap_true
        io_out      = io_out
      ).
    ENDIF.

    io_out->write( '' ).
  ENDMETHOD.

      METHOD test_update_work_order.
    io_out->write( '--- TEST: ACTUALIZAR ORDEN DE TRABAJO ---' ).

    DATA(lo_handler) = NEW zcl_wo_crud_handler_agg( ).

    " 1. Preparar cambios
    DATA ls_changes TYPE zdt_wo_agg.

    ls_changes-status      = 'CO'.  " Cambiar a Completado
    ls_changes-priority    = 'B'.   " Cambiar a Baja
    ls_changes-description = 'Reparación completada satisfactoriamente'.

    " 2. Intentar actualizar orden existente
    DATA(lv_success) = lo_handler->update_work_order(
      iv_work_order_id = '0000000001'
      is_changes       = ls_changes
    ).

    IF lv_success = abap_true.
      show_message(
        iv_text = 'Orden actualizada exitosamente'
        io_out  = io_out
      ).

      " Verificar que se actualizó
      DATA(ls_updated) = lo_handler->read_work_order( '0000000001' ).
      show_message(
        iv_text = |Estado actual: { ls_updated-status }, Prioridad: { ls_updated-priority }|
        io_out  = io_out
      ).
    ELSE.
      show_message(
        iv_text     = 'Fallo al actualizar la orden'
        iv_is_error = abap_true
        io_out      = io_out
      ).
    ENDIF.

    " 3. Intentar actualizar orden que NO existe
    lv_success = lo_handler->update_work_order(
      iv_work_order_id = '9999999999'
      is_changes       = ls_changes
    ).

    IF lv_success = abap_false.
      show_message(
        iv_text = 'Correcto: rechazó actualización de orden inexistente'
        io_out  = io_out
      ).
    ENDIF.

    io_out->write( '' ).
  ENDMETHOD.

      METHOD test_delete_work_order.
    io_out->write( '--- TEST: ELIMINAR ORDEN DE TRABAJO ---' ).

    DATA(lo_handler) = NEW zcl_wo_crud_handler_agg( ).

    " 1. Primero crear una orden nueva en estado PE (para poder borrar)
    DATA ls_new_order TYPE zdt_wo_agg.

    ls_new_order-work_order_id   = '0000000003'.
    ls_new_order-customer_id     = '00000002'.
    ls_new_order-technician_id   = 'TEC002'.
    ls_new_order-creation_date   = cl_abap_context_info=>get_system_date( ).
    ls_new_order-status          = 'PE'.  " Pendiente (se puede borrar)
    ls_new_order-priority        = 'B'.
    ls_new_order-description     = 'Orden temporal para prueba de borrado'.

    " Crear la orden
    DATA(lv_created) = lo_handler->create_work_order( ls_new_order ).

    IF lv_created = abap_true.
      show_message(
        iv_text = 'Orden temporal creada para prueba de borrado'
        io_out  = io_out
      ).

      " 2. Intentar borrar la orden (debería funcionar porque está en PE)
      DATA(lv_deleted) = lo_handler->delete_work_order( '0000000003' ).

      IF lv_deleted = abap_true.
        show_message(
          iv_text = 'Orden borrada exitosamente (estado PE)'
          io_out  = io_out
        ).
      ELSE.
        show_message(
          iv_text     = 'Fallo al borrar orden en estado PE'
          iv_is_error = abap_true
          io_out      = io_out
        ).
      ENDIF.
    ENDIF.

    " 3. Intentar borrar orden que NO existe
    lv_deleted = lo_handler->delete_work_order( '9999999999' ).

    IF lv_deleted = abap_false.
      show_message(
        iv_text = 'Correcto: rechazó borrado de orden inexistente'
        io_out  = io_out
      ).
    ENDIF.

    io_out->write( '' ).
  ENDMETHOD.

ENDCLASS.

