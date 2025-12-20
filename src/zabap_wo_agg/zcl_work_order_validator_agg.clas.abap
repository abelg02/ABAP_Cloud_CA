CLASS zcl_work_order_validator_agg DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    " Tipos usando mis Data Elements
    TYPES:
      ty_work_order_id TYPE zde_work_order_id_agg,
      ty_customer_id   TYPE zde_customer_id_agg,
      ty_technician_id TYPE zde_technician_id_agg,
      ty_status        TYPE zde_wo_status_agg,
      ty_priority      TYPE zde_wo_priority_agg.

    " Métodos públicos
    METHODS:
      validate_create_order
        IMPORTING
          iv_customer_id   TYPE ty_customer_id
          iv_technician_id TYPE ty_technician_id
          iv_priority      TYPE ty_priority
        RETURNING
          VALUE(rv_valid)  TYPE abap_bool,

      validate_update_order
        IMPORTING
          iv_work_order_id TYPE ty_work_order_id
          iv_status        TYPE ty_status
        RETURNING
          VALUE(rv_valid)  TYPE abap_bool,

      validate_delete_order
        IMPORTING
          iv_work_order_id TYPE ty_work_order_id
          iv_status        TYPE ty_status
        RETURNING
          VALUE(rv_valid)  TYPE abap_bool,

      validate_status_and_priority
        IMPORTING
          iv_status       TYPE ty_status
          iv_priority     TYPE ty_priority
        RETURNING
          VALUE(rv_valid) TYPE abap_bool.

  PROTECTED SECTION.
  PRIVATE SECTION.

    " Constantes
    CONSTANTS:
      gc_status_pending   TYPE ty_status VALUE 'PE',
      gc_status_completed TYPE ty_status VALUE 'CO',
      gc_priority_high    TYPE ty_priority VALUE 'A',
      gc_priority_low     TYPE ty_priority VALUE 'B'.

    METHODS:
      _check_customer_exists
        IMPORTING
          iv_customer_id   TYPE ty_customer_id
        RETURNING
          VALUE(rv_exists) TYPE abap_bool,

      _check_technician_exists
        IMPORTING
          iv_technician_id TYPE ty_technician_id
        RETURNING
          VALUE(rv_exists) TYPE abap_bool,

      _check_order_exists
        IMPORTING
          iv_work_order_id TYPE ty_work_order_id
        RETURNING
          VALUE(rv_exists) TYPE abap_bool,

      _check_order_history
        IMPORTING
          iv_work_order_id TYPE ty_work_order_id
        RETURNING
          VALUE(rv_exists) TYPE abap_bool.

ENDCLASS.



CLASS zcl_work_order_validator_agg IMPLEMENTATION.

  METHOD validate_create_order.
    rv_valid = abap_true.

    " 1. Validar que el cliente existe
    IF _check_customer_exists( iv_customer_id ) = abap_false.
      rv_valid = abap_false.
      RETURN.
    ENDIF.

    " 2. Validar que el técnico existe
    IF _check_technician_exists( iv_technician_id ) = abap_false.
      rv_valid = abap_false.
      RETURN.
    ENDIF.

    " 3. Validar que la prioridad es válida
    IF iv_priority <> gc_priority_high AND
       iv_priority <> gc_priority_low.
      rv_valid = abap_false.
      RETURN.
    ENDIF.

    " 4. AUTHORITY-CHECK para creación
    AUTHORITY-CHECK OBJECT 'Z_WORK_ORDER'
      ID 'ACTVT' FIELD '01'.  " 01 = Create

    IF sy-subrc <> 0.
      rv_valid = abap_false.
      RETURN.
    ENDIF.

  ENDMETHOD.

  METHOD validate_update_order.
    rv_valid = abap_true.

    " 1. Validar que la orden existe
    IF _check_order_exists( iv_work_order_id ) = abap_false.
      rv_valid = abap_false.
      RETURN.
    ENDIF.

    " 2. Validar que el estado se puede editar
    IF iv_status <> gc_status_pending.
      rv_valid = abap_false.
      RETURN.
    ENDIF.

    " 3. AUTHORITY-CHECK para actualización
    AUTHORITY-CHECK OBJECT 'Z_WORK_ORDER'
      ID 'ACTVT' FIELD '02'.  " 02 = Update

    IF sy-subrc <> 0.
      rv_valid = abap_false.
      RETURN.
    ENDIF.

  ENDMETHOD.

  METHOD validate_delete_order.
    rv_valid = abap_true.

    " 1. Validar que la orden existe
    IF _check_order_exists( iv_work_order_id ) = abap_false.
      rv_valid = abap_false.
      RETURN.
    ENDIF.

    " 2. Validar que el estado sea "PE"
    IF iv_status <> gc_status_pending.
      rv_valid = abap_false.
      RETURN.
    ENDIF.

    " 3. Validar que NO tenga historial
    IF _check_order_history( iv_work_order_id ) = abap_true.
      rv_valid = abap_false.
      RETURN.
    ENDIF.

    " 4. AUTHORITY-CHECK para eliminación
    AUTHORITY-CHECK OBJECT 'Z_WORK_ORDER'
      ID 'ACTVT' FIELD '06'.  " 06 = Delete

    IF sy-subrc <> 0.
      rv_valid = abap_false.
      RETURN.
    ENDIF.

  ENDMETHOD.

  METHOD validate_status_and_priority.
    rv_valid = abap_true.

    " 1. Validar estado
    IF iv_status <> gc_status_pending AND
       iv_status <> gc_status_completed.
      rv_valid = abap_false.
      RETURN.
    ENDIF.

    " 2. Validar prioridad
    IF iv_priority <> gc_priority_high AND
       iv_priority <> gc_priority_low.
      rv_valid = abap_false.
      RETURN.
    ENDIF.

  ENDMETHOD.


  METHOD _check_customer_exists.
    " Buscar si el cliente existe en zdt_customer_agg
    SELECT SINGLE @abap_true
      FROM zdt_customer_agg
      WHERE customer_id = @iv_customer_id
      INTO @rv_exists.

    IF sy-subrc <> 0.
      rv_exists = abap_false.
    ENDIF.
  ENDMETHOD.

  METHOD _check_technician_exists.
    " Buscar si el técnico existe en zdt_tech_agg
    SELECT SINGLE @abap_true
      FROM zdt_tech_agg
      WHERE technician_id = @iv_technician_id
      INTO @rv_exists.

    IF sy-subrc <> 0.
      rv_exists = abap_false.
    ENDIF.
  ENDMETHOD.

  METHOD _check_order_exists.
    " Buscar si la orden existe en zdt_wo_agg
    SELECT SINGLE @abap_true
      FROM zdt_wo_agg
      WHERE work_order_id = @iv_work_order_id
      INTO @rv_exists.

    IF sy-subrc <> 0.
      rv_exists = abap_false.
    ENDIF.
  ENDMETHOD.

  METHOD _check_order_history.
    " Buscar si hay historial para la orden
    SELECT SINGLE @abap_true
      FROM zdt_wo_hist_agg
      WHERE work_order_id = @iv_work_order_id
      INTO @rv_exists.

    IF sy-subrc <> 0.
      rv_exists = abap_false.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
