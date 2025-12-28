CLASS zcl_work_order_validator_agg DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      validate_create_order
        IMPORTING
          iv_customer_id   TYPE zde_customer_id_agg
          iv_technician_id TYPE zde_technician_id_agg
          iv_priority      TYPE zde_wo_priority_agg
        RETURNING
          VALUE(rv_valid)  TYPE abap_bool,

      validate_update_order
        IMPORTING
          iv_work_order_id TYPE zde_work_order_id_agg
          iv_status        TYPE zde_wo_status_agg
        RETURNING
          VALUE(rv_valid)  TYPE abap_bool,

      validate_delete_order
        IMPORTING
          iv_work_order_id TYPE zde_work_order_id_agg
          iv_status        TYPE zde_wo_status_agg
        RETURNING
          VALUE(rv_valid)  TYPE abap_bool,

      validate_status_and_priority
        IMPORTING
          iv_status   TYPE zde_wo_status_agg
          iv_priority TYPE zde_wo_priority_agg
        RETURNING
          VALUE(rv_valid) TYPE abap_bool,

      " Método para validar autorizaciones
      check_authorization
        IMPORTING
          iv_activity     TYPE zde_wo_actvt_agg
          iv_status       TYPE zde_wo_status_agg OPTIONAL
        RETURNING
          VALUE(rv_auth)  TYPE abap_bool.

  PRIVATE SECTION.
    CONSTANTS:
      " Estados y prioridades
      gc_status_pending   TYPE zde_wo_status_agg VALUE 'PE',
      gc_status_completed TYPE zde_wo_status_agg VALUE 'CO',
      gc_priority_high    TYPE zde_wo_priority_agg VALUE 'A',
      gc_priority_low     TYPE zde_wo_priority_agg VALUE 'B',

      " Actividades para AUTHORITY-CHECK
      gc_actvt_create     TYPE zde_wo_actvt_agg VALUE '01',  " Crear
      gc_actvt_change     TYPE zde_wo_actvt_agg VALUE '02',  " Cambiar
      gc_actvt_display    TYPE zde_wo_actvt_agg VALUE '03',  " Mostrar
      gc_actvt_delete     TYPE zde_wo_actvt_agg VALUE '04'.  " Eliminar

    METHODS:
      check_customer_exists
        IMPORTING
          iv_customer_id   TYPE zde_customer_id_agg
        RETURNING
          VALUE(rv_exists) TYPE abap_bool,

      check_technician_exists
        IMPORTING
          iv_technician_id TYPE zde_technician_id_agg
        RETURNING
          VALUE(rv_exists) TYPE abap_bool,

      check_order_exists
        IMPORTING
          iv_work_order_id TYPE zde_work_order_id_agg
        RETURNING
          VALUE(rv_exists) TYPE abap_bool,

      check_order_history
        IMPORTING
          iv_work_order_id TYPE zde_work_order_id_agg
        RETURNING
          VALUE(rv_exists) TYPE abap_bool.

ENDCLASS.

CLASS zcl_work_order_validator_agg IMPLEMENTATION.

  METHOD validate_create_order.
    rv_valid = abap_false.

    IF check_customer_exists( iv_customer_id ) = abap_false.
      RETURN.
    ENDIF.

    IF check_technician_exists( iv_technician_id ) = abap_false.
      RETURN.
    ENDIF.

    IF iv_priority <> gc_priority_high AND iv_priority <> gc_priority_low.
      RETURN.
    ENDIF.

    rv_valid = abap_true.
  ENDMETHOD.

  METHOD validate_update_order.
    rv_valid = abap_false.

    IF check_order_exists( iv_work_order_id ) = abap_false.
      RETURN.
    ENDIF.

    " Solo se permite actualizar si está pendiente
    IF iv_status <> gc_status_pending.
      RETURN.
    ENDIF.

    rv_valid = abap_true.
  ENDMETHOD.

  METHOD validate_delete_order.
    rv_valid = abap_false.

    IF check_order_exists( iv_work_order_id ) = abap_false.
      RETURN.
    ENDIF.

    IF iv_status <> gc_status_pending.
      RETURN.
    ENDIF.

    IF check_order_history( iv_work_order_id ) = abap_true.
      RETURN.
    ENDIF.

    rv_valid = abap_true.
  ENDMETHOD.

  METHOD validate_status_and_priority.
    rv_valid = abap_false.

    IF iv_status <> gc_status_pending AND iv_status <> gc_status_completed.
      RETURN.
    ENDIF.

    IF iv_priority <> gc_priority_high AND iv_priority <> gc_priority_low.
      RETURN.
    ENDIF.

    rv_valid = abap_true.
  ENDMETHOD.

  METHOD check_customer_exists.
    rv_exists = abap_false.
    TRY.
        SELECT SINGLE @abap_true
          FROM zdt_customer_agg
          WHERE customer_id = @iv_customer_id
          INTO @rv_exists.
      CATCH cx_sy_open_sql_db INTO DATA(lx_sql).
        rv_exists = abap_false.
    ENDTRY.
  ENDMETHOD.

  METHOD check_technician_exists.
    rv_exists = abap_false.
    TRY.
        SELECT SINGLE @abap_true
          FROM zdt_tech_agg
          WHERE technician_id = @iv_technician_id
          INTO @rv_exists.
      CATCH cx_sy_open_sql_db INTO DATA(lx_sql).
        rv_exists = abap_false.
    ENDTRY.
  ENDMETHOD.

  METHOD check_order_exists.
    rv_exists = abap_false.
    TRY.
        SELECT SINGLE @abap_true
          FROM zdt_wo_agg
          WHERE work_order_id = @iv_work_order_id
          INTO @rv_exists.
      CATCH cx_sy_open_sql_db INTO DATA(lx_sql).
        rv_exists = abap_false.
    ENDTRY.
  ENDMETHOD.

  METHOD check_order_history.
    rv_exists = abap_false.
    TRY.
        SELECT SINGLE @abap_true
          FROM zdt_wo_hist_agg
          WHERE work_order_id = @iv_work_order_id
          INTO @rv_exists.
      CATCH cx_sy_open_sql_db INTO DATA(lx_sql).
        rv_exists = abap_false.
    ENDTRY.
  ENDMETHOD.

  METHOD check_authorization.
    rv_auth = abap_false.

    " Si no viene status, usar espacio para el authority-check
    DATA(lv_status) = COND zde_wo_status_agg(
      WHEN iv_status IS NOT INITIAL THEN iv_status
      ELSE space
    ).

    " Ejecutar el authority-check con nuestro objeto
    AUTHORITY-CHECK OBJECT 'ZAC_WO_AGG'  " Tu objeto de autorización
      ID 'Z_ACTVT' FIELD iv_activity
      ID 'Z_STATUS' FIELD lv_status.

    " sy-subrc = 0 significa autorización concedida
    IF sy-subrc = 0.
      rv_auth = abap_true.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
