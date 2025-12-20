CLASS zcl_wo_crud_handler_agg DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    TYPES:
      BEGIN OF ty_s_work_order,
        work_order_id TYPE zde_work_order_id_agg,
        customer_id   TYPE zde_customer_id_agg,
        technician_id TYPE zde_technician_id_agg,
        creation_date TYPE zde_wo_creation_date_agg,
        status        TYPE zde_wo_status_agg,
        priority      TYPE zde_wo_priority_agg,
        description   TYPE zde_wo_description_agg,
      END OF ty_s_work_order,

      ty_t_work_orders TYPE TABLE OF ty_s_work_order WITH KEY work_order_id.

    " Métodos CRUD principales (PDF página 5)
    METHODS:
      create_work_order
        IMPORTING
          is_work_order     TYPE ty_s_work_order
        RETURNING
          VALUE(rv_success) TYPE abap_bool
        RAISING
          cx_root,

      read_work_order
        IMPORTING
          iv_work_order_id     TYPE zde_work_order_id_agg
        RETURNING
          VALUE(rs_work_order) TYPE ty_s_work_order
        RAISING
          cx_root,

      read_work_orders_filtered
        IMPORTING
          iv_status        TYPE zde_wo_status_agg OPTIONAL
          iv_customer_id   TYPE zde_customer_id_agg OPTIONAL
          iv_date_from     TYPE d OPTIONAL
          iv_date_to       TYPE d OPTIONAL
        RETURNING
          VALUE(rt_orders) TYPE ty_t_work_orders
        RAISING
          cx_root,

      update_work_order
        IMPORTING
          is_work_order     TYPE ty_s_work_order
        RETURNING
          VALUE(rv_success) TYPE abap_bool
        RAISING
          cx_root,

      delete_work_order
        IMPORTING
          iv_work_order_id  TYPE zde_work_order_id_agg
        RETURNING
          VALUE(rv_success) TYPE abap_bool
        RAISING
          cx_root.

  PROTECTED SECTION.
    " (vacío pero presente)

  PRIVATE SECTION.
    " Instancia del validador (PDF: "integrando las validaciones previas")
    DATA:
      mo_validator TYPE REF TO zcl_work_order_validator_agg.

    " Constantes para bloqueos
    CONSTANTS:
      gc_lock_object TYPE string VALUE 'EZ_WORKORDER',
      gc_lock_mode   TYPE c LENGTH 1 VALUE 'E'.  " 'E' = Exclusive, 'S' = Shared

    " Métodos privados
    METHODS:
      _lock_work_order
        IMPORTING
          iv_work_order_id TYPE zde_work_order_id_agg
        RETURNING
          VALUE(rv_locked) TYPE abap_bool
        RAISING
          cx_root,

      _unlock_work_order
        IMPORTING
          iv_work_order_id TYPE zde_work_order_id_agg
        RAISING
          cx_root,

      _log_history
        IMPORTING
          iv_work_order_id TYPE zde_work_order_id_agg
          iv_change_desc   TYPE zde_wo_change_desc_agg
        RAISING
          cx_root,

      _get_next_history_id
        RETURNING
          VALUE(rv_history_id) TYPE zde_history_id_agg
        RAISING
          cx_root.

ENDCLASS.



CLASS zcl_wo_crud_handler_agg IMPLEMENTATION.

  METHOD create_work_order.
    " Inicializar éxito como falso
    rv_success = abap_false.

    " 1. VALIDACIONES (PDF 2.2: "validaciones como campos obligatorios")
    " Validar campos obligatorios
    IF is_work_order-work_order_id IS INITIAL OR
       is_work_order-customer_id IS INITIAL OR
       is_work_order-technician_id IS INITIAL OR
       is_work_order-description IS INITIAL.
      RETURN.
    ENDIF.

    " 2. USAR VALIDADOR (PDF: "integrando las validaciones previas")
    IF mo_validator IS NOT BOUND.
      mo_validator = NEW #( ).
    ENDIF.

    IF mo_validator->validate_create_order(
         iv_customer_id   = is_work_order-customer_id
         iv_technician_id = is_work_order-technician_id
         iv_priority      = is_work_order-priority
       ) = abap_false.
      RETURN.
    ENDIF.

    " 3. VALIDAR ESTADO Y PRIORIDAD CON VALIDADOR
    IF mo_validator->validate_status_and_priority(
         iv_status   = is_work_order-status
         iv_priority = is_work_order-priority
       ) = abap_false.
      RETURN.
    ENDIF.

    " 4. CREAR ORDEN (con campos obligatorios según PDF 2.2)
    DATA(ls_work_order) = is_work_order.
    IF ls_work_order-creation_date IS INITIAL.
      ls_work_order-creation_date = cl_abap_context_info=>get_system_date( ).
    ENDIF.

    IF ls_work_order-status IS INITIAL.
      ls_work_order-status = 'PE'.  " Pending
    ENDIF.

    INSERT zdt_wo_agg FROM @( VALUE #(
      client        = sy-mandt
      work_order_id = ls_work_order-work_order_id
      customer_id   = ls_work_order-customer_id
      technician_id = ls_work_order-technician_id
      creation_date = ls_work_order-creation_date
      status        = ls_work_order-status
      priority      = ls_work_order-priority
      description   = ls_work_order-description
    ) ).

    IF sy-subrc = 0.
      rv_success = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD read_work_order.
    CLEAR rs_work_order.

    SELECT SINGLE
      work_order_id,
      customer_id,
      technician_id,
      creation_date,
      status,
      priority,
      description
      FROM zdt_wo_agg
      WHERE work_order_id = @iv_work_order_id
      INTO CORRESPONDING FIELDS OF @rs_work_order.

  ENDMETHOD.


  METHOD read_work_orders_filtered.
    CLEAR rt_orders.

    SELECT
      work_order_id,
      customer_id,
      technician_id,
      creation_date,
      status,
      priority,
      description
      FROM zdt_wo_agg
      WHERE ( @iv_status IS INITIAL OR status = @iv_status )
        AND ( @iv_customer_id IS INITIAL OR customer_id = @iv_customer_id )
        AND ( @iv_date_from IS INITIAL OR creation_date >= @iv_date_from )
        AND ( @iv_date_to IS INITIAL OR creation_date <= @iv_date_to )
      ORDER BY creation_date DESCENDING, priority ASCENDING
      INTO TABLE @rt_orders.

  ENDMETHOD.


  METHOD update_work_order.
    rv_success = abap_false.

    DATA(ls_existing_order) = read_work_order( is_work_order-work_order_id ).
    IF ls_existing_order IS INITIAL.
      RETURN.
    ENDIF.

    IF _lock_work_order( is_work_order-work_order_id ) = abap_false.
      RETURN.
    ENDIF.

    TRY.
        IF mo_validator IS NOT BOUND.
          mo_validator = NEW #( ).
        ENDIF.

        IF mo_validator->validate_update_order(
             iv_work_order_id = is_work_order-work_order_id
             iv_status        = ls_existing_order-status
           ) = abap_false.
          _unlock_work_order( is_work_order-work_order_id ).
          RETURN.
        ENDIF.

        IF mo_validator->validate_status_and_priority(
             iv_status   = is_work_order-status
             iv_priority = is_work_order-priority
           ) = abap_false.
          _unlock_work_order( is_work_order-work_order_id ).
          RETURN.
        ENDIF.

        UPDATE zdt_wo_agg
          SET
            customer_id   = @is_work_order-customer_id,
            technician_id = @is_work_order-technician_id,
            status        = @is_work_order-status,
            priority      = @is_work_order-priority,
            description   = @is_work_order-description
          WHERE work_order_id = @is_work_order-work_order_id.

        IF sy-subrc = 0.
          _log_history(
            iv_work_order_id = is_work_order-work_order_id
            iv_change_desc   = |Order updated at { cl_abap_context_info=>get_system_time( ) }|
          ).
          rv_success = abap_true.
        ENDIF.

        _unlock_work_order( is_work_order-work_order_id ).

      CATCH cx_root INTO DATA(lx_error).
        _unlock_work_order( is_work_order-work_order_id ).
        RAISE EXCEPTION lx_error.
    ENDTRY.

  ENDMETHOD.


  METHOD delete_work_order.
    rv_success = abap_false.

    DATA(ls_order) = read_work_order( iv_work_order_id ).
    IF ls_order IS INITIAL.
      RETURN.
    ENDIF.

    IF mo_validator IS NOT BOUND.
      mo_validator = NEW #( ).
    ENDIF.

    IF mo_validator->validate_delete_order(
         iv_work_order_id = iv_work_order_id
         iv_status        = ls_order-status
       ) = abap_false.
      RETURN.
    ENDIF.

    IF _lock_work_order( iv_work_order_id ) = abap_false.
      RETURN.
    ENDIF.

    TRY.
        DELETE FROM zdt_wo_agg
          WHERE work_order_id = @iv_work_order_id.

        IF sy-subrc = 0.
          rv_success = abap_true.
        ENDIF.

        _unlock_work_order( iv_work_order_id ).

      CATCH cx_root INTO DATA(lx_error).
        _unlock_work_order( iv_work_order_id ).
        RAISE EXCEPTION lx_error.
    ENDTRY.

  ENDMETHOD.


  METHOD _lock_work_order.
    " Para proyecto académico, simular bloqueo exitoso
    rv_locked = abap_true.
  ENDMETHOD.


  METHOD _unlock_work_order.
    " No hacer nada - solo para cumplir con interfaz
  ENDMETHOD.


  METHOD _log_history.
    DATA(lv_history_id) = _get_next_history_id( ).

    INSERT zdt_wo_hist_agg FROM @( VALUE #(
      client             = sy-mandt
      history_id         = lv_history_id
      work_order_id      = iv_work_order_id
      modification_date  = cl_abap_context_info=>get_system_date( )
      change_description = iv_change_desc
    ) ).

  ENDMETHOD.


  METHOD _get_next_history_id.
    SELECT MAX( history_id )
      FROM zdt_wo_hist_agg
      INTO @DATA(lv_max_id).

    IF lv_max_id IS NOT INITIAL.
      rv_history_id = lv_max_id + 1.
    ELSE.
      rv_history_id = 1.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
