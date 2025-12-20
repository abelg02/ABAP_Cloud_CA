CLASS zcl_work_order_validator_agg DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE.

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
          iv_status       TYPE zde_wo_status_agg
          iv_priority     TYPE zde_wo_priority_agg
        RETURNING
          VALUE(rv_valid) TYPE abap_bool.

  PRIVATE SECTION.
    CONSTANTS:
      gc_status_pending   TYPE zde_wo_status_agg VALUE 'PE',
      gc_status_completed TYPE zde_wo_status_agg VALUE 'CO',

      gc_priority_high    TYPE zde_wo_priority_agg VALUE 'A',
      gc_priority_low     TYPE zde_wo_priority_agg VALUE 'B'.

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

    " 1. Validar cliente existe
    IF check_customer_exists( iv_customer_id ) = abap_false.
      RETURN.
    ENDIF.

    " 2. Validar técnico existe
    IF check_technician_exists( iv_technician_id ) = abap_false.
      RETURN.
    ENDIF.

    " 3. Validar prioridad
    IF iv_priority <> gc_priority_high AND iv_priority <> gc_priority_low.
      RETURN.
    ENDIF.

    " 4. AUTHORITY-CHECK para creación (PDF página 6)
    AUTHORITY-CHECK OBJECT 'Z_WORK_ORDER'
      ID 'ACTVT' FIELD '01'.  " 01 = Create

    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    rv_valid = abap_true.
  ENDMETHOD.


  METHOD validate_update_order.
    rv_valid = abap_false.

    " 1. Validar que la orden existe
    IF check_order_exists( iv_work_order_id ) = abap_false.
      RETURN.
    ENDIF.

    " 2. Validar estado editable (SOLO "PE" según PDF 4.2)
    IF iv_status <> gc_status_pending.  " Solo pendiente se puede editar
      RETURN.
    ENDIF.

    " 3. AUTHORITY-CHECK para actualización
    AUTHORITY-CHECK OBJECT 'Z_WORK_ORDER'
      ID 'ACTVT' FIELD '02'.  " 02 = Update

    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    rv_valid = abap_true.
  ENDMETHOD.


  METHOD validate_delete_order.
    rv_valid = abap_false.

    " 1. Validar que la orden existe
    IF check_order_exists( iv_work_order_id ) = abap_false.
      RETURN.
    ENDIF.

    " 2. Validar estado = 'PE' (Pendiente)
    IF iv_status <> gc_status_pending.
      RETURN.
    ENDIF.

    " 3. Validar que NO tenga historial
    IF check_order_history( iv_work_order_id ) = abap_true.
      RETURN.
    ENDIF.

    " 4. AUTHORITY-CHECK para eliminación
    AUTHORITY-CHECK OBJECT 'Z_WORK_ORDER'
      ID 'ACTVT' FIELD '06'.  " 06 = Delete

    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    rv_valid = abap_true.
  ENDMETHOD.


  METHOD validate_status_and_priority.
    rv_valid = abap_false.

    " 1. Validar estado
    IF iv_status <> gc_status_pending AND iv_status <> gc_status_completed.
      RETURN.
    ENDIF.

    " 2. Validar prioridad
    IF iv_priority <> gc_priority_high AND iv_priority <> gc_priority_low.
      RETURN.
    ENDIF.

    rv_valid = abap_true.
  ENDMETHOD.



  METHOD check_customer_exists.
    SELECT SINGLE @abap_true
      FROM zdt_customer_agg
      WHERE customer_id = @iv_customer_id
      INTO @rv_exists.
  ENDMETHOD.


  METHOD check_technician_exists.
    SELECT SINGLE @abap_true
      FROM zdt_tech_agg
      WHERE technician_id = @iv_technician_id
      INTO @rv_exists.
  ENDMETHOD.


  METHOD check_order_exists.
    SELECT SINGLE @abap_true
      FROM zdt_wo_agg
      WHERE work_order_id = @iv_work_order_id
      INTO @rv_exists.
  ENDMETHOD.


  METHOD check_order_history.
    SELECT SINGLE @abap_true
      FROM zdt_wo_hist_agg
      WHERE work_order_id = @iv_work_order_id
      INTO @rv_exists.
  ENDMETHOD.

ENDCLASS.
