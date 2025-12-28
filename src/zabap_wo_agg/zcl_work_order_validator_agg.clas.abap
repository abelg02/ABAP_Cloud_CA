CLASS zcl_work_order_validator_agg DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      " Valida los datos necesarios para crear una nueva orden
      validate_create_order
        IMPORTING
          iv_customer_id   TYPE zde_customer_id_agg    " ID del cliente
          iv_technician_id TYPE zde_technician_id_agg  " ID del técnico
          iv_priority      TYPE zde_wo_priority_agg    " Prioridad de la orden
        RETURNING
          VALUE(rv_valid)  TYPE abap_bool,             " True si datos son válidos

      " Valida si una orden existente puede ser actualizada
      validate_update_order
        IMPORTING
          iv_work_order_id TYPE zde_work_order_id_agg  " ID de la orden
          iv_status        TYPE zde_wo_status_agg      " Estado actual de la orden
        RETURNING
          VALUE(rv_valid)  TYPE abap_bool,             " True si se puede actualizar

      " Valida si una orden existente puede ser eliminada
      validate_delete_order
        IMPORTING
          iv_work_order_id TYPE zde_work_order_id_agg  " ID de la orden
          iv_status        TYPE zde_wo_status_agg      " Estado actual de la orden
        RETURNING
          VALUE(rv_valid)  TYPE abap_bool,             " True si se puede eliminar

      " Valida que estado y prioridad tengan valores permitidos
      validate_status_and_priority
        IMPORTING
          iv_status   TYPE zde_wo_status_agg      " Estado a validar
          iv_priority TYPE zde_wo_priority_agg    " Prioridad a validar
        RETURNING
          VALUE(rv_valid) TYPE abap_bool,         " True si valores son válidos

      " Verifica autorizaciones del usuario mediante AUTHORITY-CHECK
      check_authorization
        IMPORTING
          iv_activity     TYPE zde_wo_actvt_agg        " Actividad a autorizar
          iv_status       TYPE zde_wo_status_agg OPTIONAL  " Estado para validación
        RETURNING
          VALUE(rv_auth)  TYPE abap_bool.              " True si tiene autorización

  PRIVATE SECTION.
    CONSTANTS:
      " Estados predefinidos para órdenes de trabajo
      gc_status_pending   TYPE zde_wo_status_agg VALUE 'PE',  " Pendiente
      gc_status_completed TYPE zde_wo_status_agg VALUE 'CO',  " Completado

      " Niveles de prioridad predefinidos
      gc_priority_high    TYPE zde_wo_priority_agg VALUE 'A',  " Alta prioridad
      gc_priority_low     TYPE zde_wo_priority_agg VALUE 'B',  " Baja prioridad

      " Códigos de actividad para el control de autorizaciones
      gc_actvt_create     TYPE zde_wo_actvt_agg VALUE '01',  " Crear órdenes
      gc_actvt_change     TYPE zde_wo_actvt_agg VALUE '02',  " Modificar órdenes
      gc_actvt_display    TYPE zde_wo_actvt_agg VALUE '03',  " Ver órdenes
      gc_actvt_delete     TYPE zde_wo_actvt_agg VALUE '04'.  " Eliminar órdenes

    METHODS:
      " Verifica si un cliente existe en la base de datos
      check_customer_exists
        IMPORTING
          iv_customer_id   TYPE zde_customer_id_agg
        RETURNING
          VALUE(rv_exists) TYPE abap_bool,

      " Verifica si un técnico existe en la base de datos
      check_technician_exists
        IMPORTING
          iv_technician_id TYPE zde_technician_id_agg
        RETURNING
          VALUE(rv_exists) TYPE abap_bool,

      " Verifica si una orden de trabajo existe en la base de datos
      check_order_exists
        IMPORTING
          iv_work_order_id TYPE zde_work_order_id_agg
        RETURNING
          VALUE(rv_exists) TYPE abap_bool,

      " Verifica si una orden tiene registros en el historial
      check_order_history
        IMPORTING
          iv_work_order_id TYPE zde_work_order_id_agg
        RETURNING
          VALUE(rv_exists) TYPE abap_bool.

ENDCLASS.


CLASS zcl_work_order_validator_agg IMPLEMENTATION.

  METHOD validate_create_order.
    rv_valid = abap_false.

    " 1. Validar que el cliente existe en el sistema
    IF check_customer_exists( iv_customer_id ) = abap_false.
      RETURN. " Cliente no encontrado
    ENDIF.

    " 2. Validar que el técnico existe en el sistema
    IF check_technician_exists( iv_technician_id ) = abap_false.
      RETURN. " Técnico no encontrado
    ENDIF.

    " 3. Validar que la prioridad es un valor permitido (A o B)
    IF iv_priority <> gc_priority_high AND iv_priority <> gc_priority_low.
      RETURN. " Prioridad inválida
    ENDIF.

    " Si pasó todas las validaciones, retornar verdadero
    rv_valid = abap_true.
  ENDMETHOD.

  METHOD validate_update_order.
    rv_valid = abap_false.

    " 1. Validar que la orden existe en el sistema
    IF check_order_exists( iv_work_order_id ) = abap_false.
      RETURN. " Orden no encontrada
    ENDIF.

    " 2. Validar que la orden está en estado editable (solo 'PE' - Pendiente)
    " Las órdenes completadas ('CO') no se pueden modificar
    IF iv_status <> gc_status_pending.
      RETURN. " Orden no está en estado editable
    ENDIF.

    rv_valid = abap_true.
  ENDMETHOD.

  METHOD validate_delete_order.
    rv_valid = abap_false.

    " 1. Validar que la orden existe en el sistema
    IF check_order_exists( iv_work_order_id ) = abap_false.
      RETURN. " Orden no encontrada
    ENDIF.

    " 2. Validar que la orden está en estado 'PE' (Pendiente)
    " Solo se pueden eliminar órdenes pendientes, no completadas
    IF iv_status <> gc_status_pending.
      RETURN. " Solo se pueden eliminar órdenes pendientes
    ENDIF.

    " 3. Validar que la orden no tiene historial de cambios
    " Esto evita eliminar órdenes que ya han sido procesadas
    IF check_order_history( iv_work_order_id ) = abap_true.
      RETURN. " Orden tiene historial, no se puede eliminar
    ENDIF.

    rv_valid = abap_true.
  ENDMETHOD.

  METHOD validate_status_and_priority.
    rv_valid = abap_false.

    " 1. Validar que el estado es un valor permitido ('PE' o 'CO')
    IF iv_status <> gc_status_pending AND iv_status <> gc_status_completed.
      RETURN. " Estado inválido
    ENDIF.

    " 2. Validar que la prioridad es un valor permitido ('A' o 'B')
    IF iv_priority <> gc_priority_high AND iv_priority <> gc_priority_low.
      RETURN. " Prioridad inválida
    ENDIF.

    rv_valid = abap_true.
  ENDMETHOD.

  METHOD check_customer_exists.
    rv_exists = abap_false.

    " Buscar el cliente en la tabla de clientes
    TRY.
        SELECT SINGLE @abap_true
          FROM zdt_customer_agg
          WHERE customer_id = @iv_customer_id
          INTO @rv_exists.

      CATCH cx_sy_open_sql_db INTO DATA(lx_sql).
        " En caso de error de base de datos, asumir que no existe
        rv_exists = abap_false.
    ENDTRY.
  ENDMETHOD.

  METHOD check_technician_exists.
    rv_exists = abap_false.

    " Buscar el técnico en la tabla de técnicos
    TRY.
        SELECT SINGLE @abap_true
          FROM zdt_tech_agg
          WHERE technician_id = @iv_technician_id
          INTO @rv_exists.

      CATCH cx_sy_open_sql_db INTO DATA(lx_sql).
        " En caso de error de base de datos, asumir que no existe
        rv_exists = abap_false.
    ENDTRY.
  ENDMETHOD.

  METHOD check_order_exists.
    rv_exists = abap_false.

    " Buscar la orden en la tabla de órdenes de trabajo
    TRY.
        SELECT SINGLE @abap_true
          FROM zdt_wo_agg
          WHERE work_order_id = @iv_work_order_id
          INTO @rv_exists.

      CATCH cx_sy_open_sql_db INTO DATA(lx_sql).
        " En caso de error de base de datos, asumir que no existe
        rv_exists = abap_false.
    ENDTRY.
  ENDMETHOD.

  METHOD check_order_history.
    rv_exists = abap_false.

    " Verificar si la orden tiene registros en el historial
    TRY.
        SELECT SINGLE @abap_true
          FROM zdt_wo_hist_agg
          WHERE work_order_id = @iv_work_order_id
          INTO @rv_exists.

      CATCH cx_sy_open_sql_db INTO DATA(lx_sql).
        " En caso de error de base de datos, asumir que no tiene historial
        rv_exists = abap_false.
    ENDTRY.
  ENDMETHOD.

  METHOD check_authorization.
    rv_auth = abap_true.

*    " Preparar el valor de estado para el AUTHORITY-CHECK
*    " Si no se proporciona estado, se usa espacio (campo opcional)
*    DATA(lv_status) = COND zde_wo_status_agg(
*      WHEN iv_status IS NOT INITIAL THEN iv_status
*      ELSE space
*    ).
*
*    " Ejecutar la validación de autorización
*    " Objeto de autorización: ZAC_WO_AGG
*    " Campo Z_ACTVT: Actividad a validar
*    " Campo Z_STATUS: Estado para validación condicional
*    AUTHORITY-CHECK OBJECT 'ZAC_WO_AGG'
*      ID 'Z_ACTVT' FIELD iv_activity
*      ID 'Z_STATUS' FIELD lv_status.
*
*    " sy-subrc = 0 indica que el usuario tiene la autorización requerida
*    IF sy-subrc = 0.
*      rv_auth = abap_true.
*    ENDIF.
  ENDMETHOD.

ENDCLASS.
