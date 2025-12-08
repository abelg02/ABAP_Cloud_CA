CLASS zcl_select_joins_c09_c10 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_select_joins_c09_c10 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.



*  SELECT FROM zdatasource_1 AS ds1
*      JOIN zdatasource_2 AS ds2
*        ON ds1~id EQ ds2~id
*
*     FIELDS ds1~id AS id1,
*            ds2~id AS id2,
*
*            ds1~name1,
*            ds2~name2,
*
*            ds1~datasource1,
*            ds2~datasource2
*
*       INTO TABLE @DATA(lt_results).
*
*    out->write( lt_results ).



*    "Inner join"
*    SELECT FROM zdatasource_1 AS ds1
*      INNER JOIN zdatasource_2 AS ds2
*        ON ds1~id EQ ds2~id
*      INNER JOIN zdatasource_3 AS ds3
*         ON ds1~id EQ ds3~id
*     FIELDS ds1~id AS id1,
*            ds2~id AS id2,
*            ds3~id AS id3,
*            ds1~name1,
*            ds2~name2,
*            ds3~name3,
*            ds1~datasource1,
*            ds2~datasource2,
*            ds3~datasource3
*       INTO TABLE @DATA(lt_results).
*
*    out->write( lt_results ).



*    "Lef outer join"
*    SELECT FROM zdatasource_1 AS ds1
*      LEFT OUTER JOIN zdatasource_2 AS ds2
*         ON ds1~id EQ ds2~id
*     FIELDS ds1~id AS id1,
*            ds2~id AS id2,
*            ds1~name1,
*            ds2~name2,
*            ds1~datasource1,
*            ds2~datasource2
*       INTO TABLE @DATA(lt_results).
*
*    out->write( lt_results ).



*    "Right outer join"
*    SELECT FROM zdatasource_1 AS ds1
*      RIGHT OUTER JOIN zdatasource_2 AS ds2
*         ON ds1~id EQ ds2~id
*     FIELDS ds1~id AS id1,
*            ds2~id AS id2,
*            ds1~name1,
*            ds2~name2,
*            ds1~datasource1,
*            ds2~datasource2
*       INTO TABLE @DATA(lt_results).
*
*    out->write( lt_results ).



*    "Left / Right Excluding"
*    SELECT FROM zdatasource_1 AS ds1
*    FIELDS *
*    WHERE ds1~id NOT IN ( SELECT FROM zdatasource_2 AS ds2
*                          FIELDS id
*                          WHERE ds1~id = ds2~id )
*    INTO TABLE @DATA(lt_ex_left).
*
*    out->write( lt_ex_left ).
*
*    SELECT FROM zdatasource_2 AS ds2
*    FIELDS *
*    WHERE ds2~id NOT IN ( SELECT FROM zdatasource_1 AS ds1
*                          FIELDS id
*                          WHERE ds1~id = ds2~id )
*    INTO TABLE @DATA(lt_ex_right).
*
*    out->write( lt_ex_right ).



*    "Cross join"
    SELECT FROM zdatasource_1 AS ds1
      CROSS JOIN zdatasource_2 AS ds2
      CROSS JOIN zdatasource_3 AS ds3
     FIELDS *
       INTO TABLE @DATA(lt_results).

    out->write( lt_results ).



  ENDMETHOD.

ENDCLASS.
