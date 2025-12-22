CLASS zcl_wo_crud_handler_agg DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS:
      create_work_order
        IMPORTING
          is_work_order     TYPE zdt_wo_agg  " Estructura con datos de la orden
        RETURNING
          VALUE(rv_success) TYPE abap_bool,

      read_work_order
        IMPORTING
          iv_work_order_id     TYPE zde_work_order_id_agg
        RETURNING
          VALUE(rs_work_order) TYPE zdt_wo_agg,

      update_work_order
        IMPORTING
          iv_work_order_id  TYPE zde_work_order_id_agg
          is_changes        TYPE zdt_wo_agg  " Solo campos a actualizar
        RETURNING
          VALUE(rv_success) TYPE abap_bool,

      delete_work_order
        IMPORTING
          iv_work_order_id  TYPE zde_work_order_id_agg
        RETURNING
          VALUE(rv_success) TYPE abap_bool.

  PRIVATE SECTION.
    METHODS:
      get_current_status
        IMPORTING
          iv_work_order_id TYPE zde_work_order_id_agg
        RETURNING
          VALUE(rv_status) TYPE zde_wo_status_agg,

      log_history
        IMPORTING
          iv_work_order_id TYPE zde_work_order_id_agg
          iv_description   TYPE zde_wo_change_desc_agg.
ENDCLASS.

CLASS zcl_wo_crud_handler_agg IMPLEMENTATION.

  METHOD create_work_order.
    rv_success = abap_false.

    " 1. Validar datos antes de crear
    DATA(lo_validator) = NEW zcl_work_order_validator_agg( ).

    IF lo_validator->validate_create_order(
         iv_customer_id   = is_work_order-customer_id
         iv_technician_id = is_work_order-technician_id
         iv_priority      = is_work_order-priority
       ) = abap_false.
      RETURN. " Validación falló
    ENDIF.

    " 2. Crear la orden
    INSERT zdt_wo_agg FROM @is_work_order.

    IF sy-subrc = 0.
      rv_success = abap_true.

      " 3. Registrar en historial
      log_history(
        iv_work_order_id = is_work_order-work_order_id
        iv_description   = 'Orden creada'
      ).
    ENDIF.
  ENDMETHOD.

  METHOD read_work_order.
    " Leer orden por ID
    SELECT SINGLE *
      FROM zdt_wo_agg
      WHERE work_order_id = @iv_work_order_id
      INTO @rs_work_order.

    IF sy-subrc <> 0.
      CLEAR rs_work_order. " Devolver estructura vacía si no existe
    ENDIF.
  ENDMETHOD.

  METHOD update_work_order.
    rv_success = abap_false.

    " 1. Obtener estado actual
    DATA(lv_current_status) = get_current_status( iv_work_order_id ).

    " 2. Validar si se puede actualizar
    DATA(lo_validator) = NEW zcl_work_order_validator_agg( ).
    IF lo_validator->validate_update_order(
         iv_work_order_id = iv_work_order_id
         iv_status        = lv_current_status
       ) = abap_false.
      RETURN.
    ENDIF.

    " 3. Actualizar solo los campos proporcionados
    UPDATE zdt_wo_agg
      SET customer_id   = @is_changes-customer_id,
          technician_id = @is_changes-technician_id,
          status        = @is_changes-status,
          priority      = @is_changes-priority,
          description   = @is_changes-description
      WHERE work_order_id = @iv_work_order_id.

    IF sy-subrc = 0.
      rv_success = abap_true.

      " 4. Registrar en historial
      log_history(
        iv_work_order_id = iv_work_order_id
        iv_description   = 'Orden actualizada'
      ).
    ENDIF.
  ENDMETHOD.

  METHOD delete_work_order.
    rv_success = abap_false.

    " 1. Obtener estado actual
    DATA(lv_current_status) = get_current_status( iv_work_order_id ).

    " 2. Validar si se puede eliminar
    DATA(lo_validator) = NEW zcl_work_order_validator_agg( ).
    IF lo_validator->validate_delete_order(
         iv_work_order_id = iv_work_order_id
         iv_status        = lv_current_status
       ) = abap_false.
      RETURN.
    ENDIF.

    " 3. Eliminar orden
    DELETE FROM zdt_wo_agg WHERE work_order_id = @iv_work_order_id.

    IF sy-subrc = 0.
      rv_success = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD get_current_status.
    SELECT SINGLE status
      FROM zdt_wo_agg
      WHERE work_order_id = @iv_work_order_id
      INTO @rv_status.
  ENDMETHOD.

  METHOD log_history.
    " 1. Obtener el máximo ID actual y sumar 1
    SELECT MAX( history_id )
      FROM zdt_wo_hist_agg
      INTO @DATA(lv_max_id).

    IF lv_max_id IS INITIAL.
      lv_max_id = '000000000001'.
    ELSE.
      lv_max_id = lv_max_id + 1.
    ENDIF.

    " 2. Crear estructura para insertar en la tabla de historial
    DATA ls_history TYPE zdt_wo_hist_agg.

    ls_history-history_id         = lv_max_id.
    ls_history-work_order_id      = iv_work_order_id.
    ls_history-modification_date  = cl_abap_context_info=>get_system_date( ).
    ls_history-change_description = iv_description.

    " 3. Insertar en la tabla de base de datos
    INSERT zdt_wo_hist_agg FROM @ls_history.
  ENDMETHOD.

ENDCLASS.
