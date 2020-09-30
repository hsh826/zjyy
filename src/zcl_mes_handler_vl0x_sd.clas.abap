CLASS zcl_mes_handler_vl0x_sd DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE

  GLOBAL FRIENDS zcl_mes_handler_factory .

  PUBLIC SECTION.

    INTERFACES zif_mes_handler .

    ALIASES is_triggered
      FOR zif_mes_handler~is_triggered .
    ALIASES replicate
      FOR zif_mes_handler~replicate .
  PROTECTED SECTION.

  PRIVATE SECTION.

    CONSTANTS c_true TYPE c VALUE 'Y' ##NO_TEXT.
    CONSTANTS c_false TYPE c VALUE 'N' ##NO_TEXT.
    DATA mt_xlikp TYPE shp_likp_t .
    DATA mt_ylikp TYPE shp_ylikp_t .
    DATA mv_vbeln TYPE vbeln_vl .
    DATA mv_updkz TYPE updkz_d .
    DATA mv_triggered TYPE flag .

    METHODS constructor
      IMPORTING
        !it_xlikp TYPE shp_likp_t OPTIONAL
        !it_ylikp TYPE shp_ylikp_t OPTIONAL .
ENDCLASS.



CLASS zcl_mes_handler_vl0x_sd IMPLEMENTATION.


  METHOD constructor.

    IF it_xlikp IS NOT INITIAL.
      mt_xlikp = it_xlikp.
    ENDIF.

    IF it_ylikp IS NOT INITIAL.
      mt_ylikp = it_ylikp.
    ENDIF.

  ENDMETHOD.


  METHOD zif_mes_handler~is_triggered.

    DO 1 TIMES.
      CHECK mv_triggered IS INITIAL.

      IF NOT line_exists( mt_xlikp[ 1 ] ).
        mv_triggered = c_false.
        EXIT.
      ENDIF.

      IF mt_xlikp[ 1 ]-lfart = 'LB'.
        mv_triggered = c_false.
        EXIT.
      ENDIF.

      mv_vbeln = mt_xlikp[ 1 ]-vbeln.
      mv_updkz = mt_xlikp[ 1 ]-updkz.

      DATA(lv_wbstk_old) = VALUE #( mt_ylikp[ 1 ]-wbstk OPTIONAL ).

      IF mt_xlikp[ 1 ]-wbstk <> 'C'.
        IF lv_wbstk_old <> 'C'.     "create/change/delete
          mv_triggered = c_true.
        ELSE.                       "reverse
          mv_triggered = c_false.
        ENDIF.
      ELSE.
        IF lv_wbstk_old = 'C'.      "no changes
          mv_triggered = c_false.
        ELSE.                       "post
          IF mt_xlikp[ 1 ]-lfart = 'ZYF'.
            mv_updkz = 'D'.
            mv_triggered = c_true.
          ELSE.
            mv_triggered = c_false.
          ENDIF.
        ENDIF.
      ENDIF.

    ENDDO.

    IF mv_triggered = c_true.
      rv_triggered = abap_true.
    ELSE.
      rv_triggered = abap_false.
    ENDIF.


  ENDMETHOD.


  METHOD zif_mes_handler~replicate.
    DATA: ls_DeliveryNotice     TYPE zcl_mes_interface=>ty_DeliveryNotice,
          lt_DeliveryNotice     TYPE TABLE OF zcl_mes_interface=>ty_DeliveryNotice,
          lt_text               TYPE TABLE OF tline,
          ls_DeliveryNoticeLine TYPE zcl_mes_interface=>ty_DeliveryNoticeLine,
          lt_DeliveryNoticeLine TYPE TABLE OF zcl_mes_interface=>ty_DeliveryNoticeLine,
          ls_lips               TYPE lips.


    CHECK is_triggered( ) = abap_true.


    CONVERT DATE sy-datum
            TIME sy-uzeit INTO TIME STAMP DATA(lv_curr_timestamp) TIME ZONE ''.
    DATA(lv_datetime) = CONV char23( |{ lv_curr_timestamp TIMESTAMP = ISO }| ).
    DATA l_guid16 TYPE sysuuid_x16.
    TRY.
        CALL METHOD cl_system_uuid=>if_system_uuid_static~create_uuid_x16
          RECEIVING
            uuid = l_guid16.
      CATCH cx_uuid_error .
    ENDTRY.

*   SQL
    SELECT * FROM ZI_DeliveryNotice WHERE Code = @mv_vbeln
        INTO TABLE @DATA(lt_header).
    IF sy-subrc <> 0.
      IF mv_updkz = 'D'.
        lt_DeliveryNotice = VALUE #( ( Code = mv_vbeln
                                       OperateType = '3'
                                       Recid = mv_vbeln
                                       Mdfdt = lv_datetime
                                       syncflag = 0
                                       databatchnum = l_guid16 ) ).
      ELSE.
        ASSERT 1 = 2.
      ENDIF.
    ENDIF.

    SELECT * FROM ZI_DeliveryNoticeLine WHERE DeliveryNoticeCode = @mv_vbeln
        INTO TABLE @DATA(lt_items).
    IF sy-subrc <> 0.
      IF mv_updkz = 'D'.
        lt_DeliveryNoticeLine = VALUE #( ( DeliveryNoticeCode = mv_vbeln
                                           OperateType = '3'
                                           syncflag = 0
                                           Mdfdt = lv_datetime
                                           databatchnum = l_guid16 ) ).
      ELSE.
        ASSERT 1 = 2.
      ENDIF.
    ENDIF.


*   Convert
    LOOP AT lt_header INTO DATA(ls_header).
      MOVE-CORRESPONDING ls_header TO ls_DeliveryNotice.

      ls_DeliveryNotice-billdate = CONV char23( |{ ls_header-BillDate TIMESTAMP = ISO }| ).
      ls_DeliveryNotice-transportorname = match( val = ls_header-TransportorName
                                                 regex = '[^~!@#$%^&*()_+{}|:"<>?`=;,./，、；·（）-]+'
                                                 occ = 1 ).

      DATA(lv_name) = CONV tdobname( ls_header-Code ).
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          id                      = '0002'
          language                = sy-langu
          name                    = lv_name
          object                  = 'VBBK'
        TABLES
          lines                   = lt_text
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
      IF sy-subrc = 0.
        ls_DeliveryNotice-note = REDUCE #( INIT o1 TYPE char256
                                           FOR  i = 1 THEN i + 1 WHILE i <= lines( lt_text )
                                           NEXT o1 = o1 && lt_text[ i ]-tdline ).
      ENDIF.

      CASE mv_updkz.
        WHEN 'I'.
          ls_DeliveryNotice-operatetype = 1.
        WHEN 'U'.
          ls_DeliveryNotice-operatetype = 2.
        WHEN 'D'.
          ls_DeliveryNotice-operatetype = 3.
        WHEN OTHERS.
          ls_DeliveryNotice-operatetype = 0.
      ENDCASE.
      ls_DeliveryNotice-mdfdt = lv_datetime.
      ls_DeliveryNotice-databatchnum = l_guid16.

      APPEND ls_DeliveryNotice TO lt_DeliveryNotice.
    ENDLOOP.

    LOOP AT lt_items INTO DATA(ls_item).
      CLEAR: ls_DeliveryNoticeLine, lt_text.
      MOVE-CORRESPONDING ls_item TO ls_DeliveryNoticeLine.

      ls_DeliveryNoticeLine-Qty = CONV #( ls_item-Qty ).
      ls_DeliveryNoticeLine-RequiredDate = |{ ls_item-RequiredDate TIMESTAMP = ISO }|.

      CLEAR ls_lips.
      SPLIT ls_item-CustEngineeringChgStatus AT '/' INTO ls_lips-vbeln ls_lips-posnr.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = ls_lips-vbeln
        IMPORTING
          output = ls_lips-vbeln.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = ls_lips-posnr
        IMPORTING
          output = ls_lips-posnr.
      ls_DeliveryNoticeLine-SaleOutOrderCode = ls_lips-vbeln.
      ls_DeliveryNoticeLine-SaleOutOrderRowNo = ls_lips-posnr.

      ls_DeliveryNoticeLine-BigNumber = |{ ls_item-BigNumber DECIMALS = 3 }|.
      ls_DeliveryNoticeLine-SingerNumber = |{ ls_item-SingerNumber DECIMALS = 3 }|.
      ls_DeliveryNoticeLine-ProductUnit = |{ ls_item-ProductUnit DECIMALS = 3 }|.
      ls_DeliveryNoticeLine-StockUnit = |{ ls_item-StockUnit DECIMALS = 3 }|.

      lv_name = ls_item-DeliveryNoticeCode && ls_item-SortIndex.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          id                      = '0003'
          language                = sy-langu
          name                    = lv_name
          object                  = 'VBBP'
        TABLES
          lines                   = lt_text
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
      IF sy-subrc = 0.
        ls_DeliveryNoticeLine-Note = REDUCE #( INIT o2 TYPE char255
                                               FOR  i = 1 THEN i + 1 WHILE i <= lines( lt_text )
                                               NEXT o2 = o2 && lt_text[ i ]-tdline ).

      ENDIF.

      CASE mv_updkz.
        WHEN 'I'.
          ls_DeliveryNoticeLine-operatetype = 1.
        WHEN 'U'.
          ls_DeliveryNoticeLine-operatetype = 2.
        WHEN 'D'.
          ls_DeliveryNoticeLine-operatetype = 3.
        WHEN OTHERS.
          ls_DeliveryNoticeLine-operatetype = 0.
      ENDCASE.
      ls_DeliveryNoticeLine-mdfdt = lv_datetime.
      ls_DeliveryNoticeLine-databatchnum = l_guid16.

      APPEND ls_DeliveryNoticeLine TO lt_DeliveryNoticeLine.
    ENDLOOP.


*   Update MES DB
    TRY.
        IF lt_DeliveryNotice IS NOT INITIAL.
          zcl_mes_interface=>Erp_DeliveryNotice( it_data = lt_DeliveryNotice ).
        ENDIF.
        IF lt_DeliveryNoticeLine IS NOT INITIAL.
          zcl_mes_interface=>Erp_DeliveryNoticeLine( it_data = lt_DeliveryNoticeLine ).
        ENDIF.

      CATCH zcx_mes_interface INTO DATA(lr_exc).
        DATA(lv_error) = 'X'.
        cl_demo_output=>display( lr_exc->get_text( ) ).
    ENDTRY.

    TRY.
        IF lv_error IS INITIAL.
          zcl_mes_interface=>commit( ).
        ELSE.
          zcl_mes_interface=>rollback( ).
        ENDIF.
      CATCH zcx_mes_interface INTO lr_exc.
        cl_demo_output=>display( lr_exc->get_text( ) ).
    ENDTRY.


  ENDMETHOD.
ENDCLASS.
