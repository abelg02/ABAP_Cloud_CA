CLASS zcl_work_order_crud_test_agg DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PRIVATE SECTION.
    DATA:
      " Variables para compartir IDs entre tests
      gv_test_customer_id   TYPE zde_customer_id_agg,
      gv_test_technician_id TYPE zde_technician_id_agg,
      gv_test_work_order_id TYPE zde_work_order_id_agg.

    METHODS:
      setup_test_data,
      cleanup_test_data,

      " Tests independientes
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

      " Helper methods
      show_message
        IMPORTING
          iv_text      TYPE string
          iv_is_error  TYPE abap_bool DEFAULT abap_false
          io_out       TYPE REF TO if_oo_adt_classrun_out,

      get_next_work_order_id
        RETURNING
          VALUE(rv_next_id) TYPE zde_work_order_id_agg.
ENDCLASS.



CLASS zcl_work_order_crud_test_agg IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    out->write( '==========================================' ).
    out->write( ' PRUEBAS CRUD - ÓRDENES DE TRABAJO (V2.0)' ).
    out->write( '==========================================' ).
    out->write( '' ).

    " 1. LIMPIEZA COMPLETA
    cleanup_test_data( ).
    out->write( '✅ Tablas limpias' ).

    " 2. SETUP COMPLETO
    setup_test_data( ).
    out->write( '✅ Datos de prueba creados' ).
    out->write( '' ).

    " 3. TESTS INDEPENDIENTES (pueden ejecutarse en cualquier orden)
    test_create_work_order( io_out = out ).
    test_read_work_order( io_out = out ).
    test_update_work_order( io_out = out ).
    test_delete_work_order( io_out = out ).

    out->write( '' ).
    out->write( '==========================================' ).
    out->write( ' TODAS LAS PRUEBAS COMPLETADAS' ).
    out->write( '==========================================' ).
  ENDMETHOD.

  METHOD cleanup_test_data.
    " LIMPIEZA COMPLETA (en orden inverso a dependencias)
    DELETE FROM zdt_wo_hist_agg.  " Historial depende de órdenes
    DELETE FROM zdt_wo_agg.       " Órdenes dependen de cliente/técnico
    DELETE FROM zdt_customer_agg.
    DELETE FROM zdt_tech_agg.
  ENDMETHOD.

  METHOD setup_test_data.
    " 1. IDs predefinidos pero NO hardcodeados en los tests
    gv_test_customer_id   = '00000001'.
    gv_test_technician_id = 'TEC001'.

    " 2. Insertar cliente
    INSERT zdt_customer_agg FROM @( VALUE #(
      customer_id = gv_test_customer_id
      name        = 'Cliente de Prueba'
      address     = 'Calle Test 123'
      phone       = '600000001'
    ) ).

    " 3. Insertar técnico
    INSERT zdt_tech_agg FROM @( VALUE #(
      technician_id = gv_test_technician_id
      name          = 'Técnico de Prueba'
      specialty     = 'Testing'
    ) ).
  ENDMETHOD.

  METHOD get_next_work_order_id.
    " ✅ GENERACIÓN DINÁMICA DE IDS
    SELECT MAX( work_order_id )
      FROM zdt_wo_agg
      INTO @DATA(lv_max_id).

    IF lv_max_id IS INITIAL.
      rv_next_id = '0000000001'.
    ELSE.
      rv_next_id = lv_max_id + 1.
    ENDIF.
  ENDMETHOD.

  METHOD test_create_work_order.
    io_out->write( '--- TEST: CREAR ORDEN (INDEPENDIENTE) ---' ).

    DATA(lo_handler) = NEW zcl_wo_crud_handler_agg( ).

    " ✅ ID DINÁMICO (no hardcodeado)
    gv_test_work_order_id = get_next_work_order_id( ).

    DATA ls_order TYPE zdt_wo_agg.
    ls_order-work_order_id   = gv_test_work_order_id.
    ls_order-customer_id     = gv_test_customer_id.
    ls_order-technician_id   = gv_test_technician_id.
    ls_order-creation_date   = cl_abap_context_info=>get_system_date( ).
    ls_order-status          = 'PE'.
    ls_order-priority        = 'A'.
    ls_order-description     = 'Orden creada en test independiente'.

    DATA(lv_success) = lo_handler->create_work_order( ls_order ).

    IF lv_success = abap_true.
      show_message(
        iv_text = |Orden { gv_test_work_order_id } creada exitosamente|
        io_out  = io_out
      ).
    ELSE.
      show_message(
        iv_text     = 'Fallo al crear orden'
        iv_is_error = abap_true
        io_out      = io_out
      ).
    ENDIF.

    io_out->write( '' ).
  ENDMETHOD.

 METHOD test_read_work_order.
    io_out->write( '--- TEST: LEER ORDEN (INDEPENDIENTE) ---' ).

    DATA(lo_handler) = NEW zcl_wo_crud_handler_agg( ).

    " ✅ SOLO 1 HANDLER para todo
    DATA(lv_test_id) = get_next_work_order_id( ).

    " Crear orden para este test
    DATA ls_temp_order TYPE zdt_wo_agg.
    ls_temp_order-work_order_id   = lv_test_id.
    ls_temp_order-customer_id     = gv_test_customer_id.
    ls_temp_order-technician_id   = gv_test_technician_id.
    ls_temp_order-creation_date   = cl_abap_context_info=>get_system_date( ).
    ls_temp_order-status          = 'PE'.
    ls_temp_order-priority        = 'B'.
    ls_temp_order-description     = 'Orden temporal para test de lectura'.

    " ✅ Mismo handler para crear
    lo_handler->create_work_order( ls_temp_order ).

    " ✅ Mismo handler para leer
    DATA(ls_read) = lo_handler->read_work_order( lv_test_id ).

    IF ls_read-work_order_id IS NOT INITIAL.
      show_message(
        iv_text = |Orden { lv_test_id } leída correctamente|
        io_out  = io_out
      ).
    ELSE.
      show_message(
        iv_text     = 'Error al leer orden'
        iv_is_error = abap_true
        io_out      = io_out
      ).
    ENDIF.

    io_out->write( '' ).
ENDMETHOD.

  METHOD test_update_work_order.
    io_out->write( '--- TEST: ACTUALIZAR ORDEN (INDEPENDIENTE) ---' ).

    DATA(lo_handler) = NEW zcl_wo_crud_handler_agg( ).

    " ✅ CREA SU PROPIA ORDEN PARA ACTUALIZAR
    DATA(lv_update_id) = get_next_work_order_id( ).

    " Crear orden en estado PE (editable)
    DATA ls_order_to_update TYPE zdt_wo_agg.
    ls_order_to_update-work_order_id   = lv_update_id.
    ls_order_to_update-customer_id     = gv_test_customer_id.
    ls_order_to_update-technician_id   = gv_test_technician_id.
    ls_order_to_update-creation_date   = cl_abap_context_info=>get_system_date( ).
    ls_order_to_update-status          = 'PE'.  " Importante: editable
    ls_order_to_update-priority        = 'A'.
    ls_order_to_update-description     = 'Orden para actualizar'.

    lo_handler->create_work_order( ls_order_to_update ).

    " Preparar cambios
    DATA ls_changes TYPE zdt_wo_agg.
    ls_changes-status      = 'CO'.
    ls_changes-description = 'Actualizada exitosamente'.

    " Intentar actualizar
    DATA(lv_success) = lo_handler->update_work_order(
      iv_work_order_id = lv_update_id
      is_changes       = ls_changes
    ).

    IF lv_success = abap_true.
      show_message(
        iv_text = |Orden { lv_update_id } actualizada correctamente|
        io_out  = io_out
      ).
    ELSE.
      show_message(
        iv_text     = |Fallo al actualizar orden { lv_update_id }|
        iv_is_error = abap_true
        io_out      = io_out
      ).
    ENDIF.

    io_out->write( '' ).
  ENDMETHOD.

  METHOD test_delete_work_order.
    io_out->write( '--- TEST: ELIMINAR ORDEN (INDEPENDIENTE) ---' ).

    DATA(lo_handler) = NEW zcl_wo_crud_handler_agg( ).

    " ✅ CREA SU PROPIA ORDEN PARA BORRAR
    DATA(lv_delete_id) = get_next_work_order_id( ).

    " Crear orden en estado PE (borrable)
    DATA ls_order_to_delete TYPE zdt_wo_agg.
    ls_order_to_delete-work_order_id   = lv_delete_id.
    ls_order_to_delete-customer_id     = gv_test_customer_id.
    ls_order_to_delete-technician_id   = gv_test_technician_id.
    ls_order_to_delete-creation_date   = cl_abap_context_info=>get_system_date( ).
    ls_order_to_delete-status          = 'PE'.  " Importante: borrable
    ls_order_to_delete-priority        = 'B'.
    ls_order_to_delete-description     = 'Orden para borrar'.

    lo_handler->create_work_order( ls_order_to_delete ).

    " Intentar borrar
    DATA(lv_success) = lo_handler->delete_work_order( lv_delete_id ).

    IF lv_success = abap_true.
      show_message(
        iv_text = |Orden { lv_delete_id } borrada correctamente|
        io_out  = io_out
      ).
    ELSE.
      show_message(
        iv_text     = |Fallo al borrar orden { lv_delete_id }|
        iv_is_error = abap_true
        io_out      = io_out
      ).
    ENDIF.

    io_out->write( '' ).
  ENDMETHOD.

  METHOD show_message.
    IF iv_is_error = abap_true.
      io_out->write( |❌ ERROR: { iv_text }| ).
    ELSE.
      io_out->write( |✅ { iv_text }| ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.
