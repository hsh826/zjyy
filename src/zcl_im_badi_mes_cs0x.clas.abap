CLASS zcl_im_badi_mes_cs0x DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_ex_bom_update .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_im_badi_mes_cs0x IMPLEMENTATION.


  METHOD if_ex_bom_update~change_at_save.
    DATA: lt_OldBomline           TYPE zcl_mes_interface=>ty_t_bomline,
          lt_OldProductBomReplace TYPE zcl_mes_interface=>ty_t_productbomreplace,
          lv_dup                  TYPE c VALUE IS INITIAL.


    CHECK delta_stkob IS NOT INITIAL AND delta_mastb IS NOT INITIAL.

    LOOP AT delta_stkob INTO DATA(ls_delta_stkob) WHERE aenkz = 'X'.
      ASSERT lv_dup IS INITIAL.
      DATA(lv_stlal) = ls_delta_stkob-stlal.
      lv_dup = 'X'.
    ENDLOOP.
    CHECK sy-subrc = 0.


    TRY.
        zcl_mes_handler_cs0x=>query_sap( EXPORTING iv_stlnr = delta_stkob[ 1 ]-stlnr
                                                   iv_stlal = lv_stlal
*                                                   it_stlal = VALUE #( FOR wa1 IN delta_stkob WHERE ( aenkz = 'X' )
*                                                                ( sign = 'I' option = 'EQ' low = wa1-stlal ) )
                                         IMPORTING et_bomline = lt_OldBomline
                                                   et_productbomreplace = lt_OldProductBomReplace ).

        DATA(lt_OldBomline_key) = VALUE ztt_bomline_key( FOR wa2 IN lt_OldBomline
                                    ( bomcode = wa2-bomcode productcode = wa2-productcode routingcode = wa2-routingcode ) ).
        DELETE ADJACENT DUPLICATES FROM lt_OldBomline_key COMPARING ALL FIELDS.

        DATA(lt_OldProductBomReplace_key) = VALUE ztt_productbomreplace_key( FOR wa3 IN lt_OldProductBomReplace
                                              ( productcode = wa3-productcode routingcode = wa3-routingcode bomcode = wa3-bomcode ) ).
        DELETE ADJACENT DUPLICATES FROM lt_OldProductBomReplace_key COMPARING ALL FIELDS.


        DATA(lr_unit) = cl_bgrfc_destination_inbound=>create( 'BGRFC_INBOUND' )->create_trfc_unit( ).

        CALL FUNCTION 'ZMES_BGRFC_CS0X' IN BACKGROUND UNIT lr_unit
          EXPORTING
            iv_stlnr                    = delta_stkob[ 1 ]-stlnr
            iv_stlal                    = lv_stlal
*           it_stlal                    = VALUE curto_stlal_range_t( FOR wa1 IN delta_stkob WHERE ( aenkz = 'X' )
*                                            ( sign = 'I' option = 'EQ' low = wa1-stlal ) )
            it_oldbomline_key           = lt_OldBomline_key
            it_oldproductbomreplace_key = lt_OldProductBomReplace_key
            iv_matnr                    = delta_mastb[ 1 ]-matnr.

      CATCH cx_sy_itab_line_not_found.
    ENDTRY.


  ENDMETHOD.


  METHOD if_ex_bom_update~change_before_update.
  ENDMETHOD.


  METHOD if_ex_bom_update~change_in_update.

*    DATA(lr_unit) = cl_bgrfc_destination_inbound=>create( 'BGRFC_INBOUND' )->create_trfc_unit( ).
*
*    CALL FUNCTION 'ZMES_BGRFC_CS0X' IN BACKGROUND UNIT lr_unit
*      EXPORTING
*        delta_mastb = delta_mastb.

  ENDMETHOD.


  METHOD if_ex_bom_update~create_trex_cpointer.
  ENDMETHOD.
ENDCLASS.
