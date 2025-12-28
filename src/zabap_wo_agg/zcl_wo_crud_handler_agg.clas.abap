CLASS zcl_wo_crud_handler_agg DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS:
      " Crea una nueva orden de trabajo con validaciones previas
      create_work_order
        IMPORTING
          is_work_order     TYPE zdt_wo_agg          " Datos de la nueva orden
        RETURNING
          VALUE(rv_success) TYPE abap_bool,        " True si se creó exitosamente

      " Lee una orden de trabajo existente por su ID
      read_work_order
        IMPORTING
          iv_work_order_id     TYPE zde_work_order_id_agg  " ID de la orden a leer
        RETURNING
          VALUE(rs_work_order) TYPE zdt_wo_agg,        " Datos de la orden leída

      " Actualiza una orden de trabajo existente
      update_work_order
        IMPORTING
          iv_work_order_id  TYPE zde_work_order_id_agg  " ID de la orden a actualizar
          is_changes        TYPE zdt_wo_agg             " Campos a modificar
        RETURNING
          VALUE(rv_success) TYPE abap_bool,            " True si se actualizó exitosamente

      " Elimina una orden de trabajo existente
      delete_work_order
        IMPORTING
          iv_work_order_id  TYPE zde_work_order_id_agg  " ID de la orden a eliminar
        RETURNING
          VALUE(rv_success) TYPE abap_bool.            " True si se eliminó exitosamente

  PRIVATE SECTION.
    METHODS:
      " Obtiene el estado actual de una orden de trabajo
      get_current_status
        IMPORTING
          iv_work_order_id TYPE zde_work_order_id_agg
        RETURNING
          VALUE(rv_status) TYPE zde_wo_status_agg,

      " Registra un cambio en el historial de la orden
      log_history
        IMPORTING
          iv_work_order_id TYPE zde_work_order_id_agg
          iv_description   TYPE zde_wo_change_desc_agg.
ENDCLASS.


CLASS zcl_wo_crud_handler_agg IMPLEMENTATION.

  METHOD create_work_order.
    rv_success = abap_false.

*    " Primero validar que el usuario tiene autorización para crear órdenes
*    " Actividad '01' corresponde a CREAR en el objeto de autorización
    DATA(lo_validator) = NEW zcl_work_order_validator_agg( ).
*    IF lo_validator->check_authorization(
*         iv_activity = '01'        " Código de actividad: Crear
*         iv_status   = 'PE'        " Estado inicial: Pendiente
*       ) = abap_false.
*      " Si no tiene autorización, salir sin crear la orden
*      RETURN.
*    ENDIF.

    " Validar los datos de la orden antes de crearla
    " Verifica que cliente y técnico existan, y prioridad sea válida
    IF lo_validator->validate_create_order(
         iv_customer_id  = is_work_order-customer_id
         iv_technician_id = is_work_order-technician_id
         iv_priority     = is_work_order-priority
       ) = abap_false.
      RETURN. " Validación de datos falló
    ENDIF.

    " Insertar la nueva orden en la tabla de base de datos
    INSERT zdt_wo_agg FROM @is_work_order.

    " Verificar que la inserción fue exitosa (sy-subrc = 0)
    IF sy-subrc = 0.
      rv_success = abap_true.

      " Registrar la creación en el historial de cambios
      log_history(
        iv_work_order_id = is_work_order-work_order_id
        iv_description   = 'Orden creada'
      ).
    ENDIF.
  ENDMETHOD.

  METHOD read_work_order.
    " Inicializar estructura de retorno
    CLEAR rs_work_order.

*    " Validar que el usuario tiene autorización para ver órdenes
*    " Actividad '03' corresponde a MOSTRAR/CONSULTAR
*    DATA(lo_validator) = NEW zcl_work_order_validator_agg( ).
*    IF lo_validator->check_authorization(
*         iv_activity = '03'  " Código de actividad: Mostrar
*       ) = abap_false.
*      " Si no tiene autorización, retornar estructura vacía
*      RETURN.
*    ENDIF.

    " Buscar la orden en la base de datos por su ID
    SELECT SINGLE * FROM zdt_wo_agg
      WHERE work_order_id = @iv_work_order_id
      INTO @rs_work_order.

    " Si no se encuentra la orden (sy-subrc ≠ 0), dejar estructura vacía
    IF sy-subrc <> 0.
      CLEAR rs_work_order.
    ENDIF.
  ENDMETHOD.

  METHOD update_work_order.
    rv_success = abap_false.

    " Obtener el estado actual de la orden para la validación de autorización
    DATA(lv_current_status) = get_current_status( iv_work_order_id ).

*    " Validar que el usuario tiene autorización para modificar órdenes
*    " Actividad '02' corresponde a CAMBIAR/MODIFICAR
    DATA(lo_validator) = NEW zcl_work_order_validator_agg( ).
*    IF lo_validator->check_authorization(
*         iv_activity = '02'               " Código de actividad: Cambiar
*         iv_status   = lv_current_status  " Estado actual de la orden
*       ) = abap_false.
*      " Si no tiene autorización para este estado, salir
*      RETURN.
*    ENDIF.

    " Leer la orden actual de la base de datos
    DATA ls_current TYPE zdt_wo_agg.
    SELECT SINGLE * FROM zdt_wo_agg
      WHERE work_order_id = @iv_work_order_id
      INTO @ls_current.

    " Verificar que la orden existe
    IF sy-subrc <> 0.
      RETURN. " Orden no encontrada
    ENDIF.

    " Validar que la orden se puede actualizar (debe estar en estado 'PE' - Pendiente)
    IF lo_validator->validate_update_order(
         iv_work_order_id = iv_work_order_id
         iv_status        = ls_current-status
       ) = abap_false.
      RETURN.
    ENDIF.

    " Aplicar solo los campos que han sido proporcionados para actualizar
    " Esto permite actualizaciones parciales
    IF is_changes-customer_id IS NOT INITIAL.
      ls_current-customer_id = is_changes-customer_id.
    ENDIF.

    IF is_changes-technician_id IS NOT INITIAL.
      ls_current-technician_id = is_changes-technician_id.
    ENDIF.

    IF is_changes-status IS NOT INITIAL.
      ls_current-status = is_changes-status.
    ENDIF.

    IF is_changes-priority IS NOT INITIAL.
      ls_current-priority = is_changes-priority.
    ENDIF.

    IF is_changes-description IS NOT INITIAL.
      ls_current-description = is_changes-description.
    ENDIF.

    " Actualizar la orden en la base de datos
    UPDATE zdt_wo_agg FROM @ls_current.

    " Verificar que la actualización fue exitosa
    IF sy-subrc = 0.
      rv_success = abap_true.

      " Registrar la actualización en el historial
      log_history(
        iv_work_order_id = iv_work_order_id
        iv_description   = 'Orden actualizada'
      ).
    ENDIF.
  ENDMETHOD.

  METHOD delete_work_order.
    rv_success = abap_false.

    " Obtener el estado actual de la orden
    DATA(lv_current_status) = get_current_status( iv_work_order_id ).

*    " Validar que el usuario tiene autorización para eliminar órdenes
*    " Actividad '04' corresponde a ELIMINAR
    DATA(lo_validator) = NEW zcl_work_order_validator_agg( ).
*    IF lo_validator->check_authorization(
*         iv_activity = '04'               " Código de actividad: Eliminar
*         iv_status   = lv_current_status  " Estado actual de la orden
*       ) = abap_false.
*      " Si no tiene autorización para este estado, salir
*      RETURN.
*    ENDIF.

    " Validar que la orden se puede eliminar
    " Debe estar en estado 'PE' y no tener historial de cambios
    IF lo_validator->validate_delete_order(
         iv_work_order_id = iv_work_order_id
         iv_status        = lv_current_status
       ) = abap_false.
      RETURN.
    ENDIF.

    " Eliminar la orden de la base de datos
    DELETE FROM zdt_wo_agg WHERE work_order_id = @iv_work_order_id.

    " Verificar que la eliminación fue exitosa
    IF sy-subrc = 0.
      rv_success = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD get_current_status.
    " Método auxiliar para obtener el estado actual de una orden
    " Utilizado en operaciones de actualización y eliminación
    SELECT SINGLE status FROM zdt_wo_agg
      WHERE work_order_id = @iv_work_order_id
      INTO @rv_status.
  ENDMETHOD.

  METHOD log_history.
    " Método para registrar cambios en el historial de órdenes

    " 1. Generar un nuevo ID para el registro de historial
    " Busca el máximo ID actual y le suma 1
    SELECT MAX( history_id ) FROM zdt_wo_hist_agg INTO @DATA(lv_max_id).

    IF lv_max_id IS INITIAL.
      " Si no hay registros, empezar desde 1
      lv_max_id = '000000000001'.
    ELSE.
      " Incrementar el último ID
      lv_max_id = lv_max_id + 1.
    ENDIF.

    " 2. Crear la estructura con los datos del historial
    DATA ls_history TYPE zdt_wo_hist_agg.
    ls_history-history_id         = lv_max_id.                    " ID único del registro
    ls_history-work_order_id      = iv_work_order_id.             " ID de la orden modificada
    ls_history-modification_date  = cl_abap_context_info=>get_system_date( ).  " Fecha actual
    ls_history-change_description = iv_description.               " Descripción del cambio

    " 3. Insertar el registro en la tabla de historial
    INSERT zdt_wo_hist_agg FROM @ls_history.
  ENDMETHOD.

ENDCLASS.
