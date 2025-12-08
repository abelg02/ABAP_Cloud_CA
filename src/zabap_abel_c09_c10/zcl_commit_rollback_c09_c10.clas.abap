CLASS zcl_commit_rollback_c09_c10 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_commit_rollback_c09_c10 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

* 1 LUW
    UPDATE zcarrier_c09_c10
        SET currency_code = 'EUR'
    WHERE carrier_id = 'AA'.

    IF sy-subrc = 0.

      COMMIT WORK.

* 2 LUW
      SELECT SINGLE FROM zcarrier_c09_c10
          FIELDS *
      WHERE carrier_id = 'AA'
      INTO @DATA(ls_airline).

      IF sy-subrc = 0.

        out->write( ls_airline-currency_code ).

      ENDIF.

      ROLLBACK WORK.

      SELECT SINGLE FROM zcarrier_c09_c10
      FIELDS *
      WHERE carrier_id = 'AA'
      INTO @ls_airline.

      IF sy-subrc = 0.

        out->write( ls_airline-currency_code ).

      ENDIF.

      UPDATE zcarrier_c09_c10
        SET currency_code = 'USD'
      WHERE carrier_id = 'AA'.

      ROLLBACK WORK.

    ENDIF.


  ENDMETHOD.

ENDCLASS.
