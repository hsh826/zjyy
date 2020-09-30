CLASS zcl_mes_handler_cs0x DEFINITION
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

    CLASS-METHODS query_sap
      IMPORTING
        !iv_stlnr             TYPE stnum
        !iv_stlal             TYPE stalt
        !it_stlal             TYPE curto_stlal_range_t OPTIONAL
      EXPORTING
        !et_bomline           TYPE any
        !et_productbomreplace TYPE any .

  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS c_true TYPE c VALUE 'Y' ##NO_TEXT.
    CONSTANTS c_false TYPE c VALUE 'N' ##NO_TEXT.
    DATA mv_stlnr TYPE stnum .
    DATA mv_stlal TYPE stalt.
    DATA mt_stlal TYPE curto_stlal_range_t .
    DATA mt_oldbomline_key TYPE ztt_bomline_key .
    DATA mt_oldproductbomreplace_key TYPE ztt_productbomreplace_key .
    DATA mv_matnr TYPE matnr.
    DATA mv_triggered TYPE flag .

    METHODS constructor
      IMPORTING
        !iv_stlnr                    TYPE stnum
        !iv_stlal                    TYPE stalt
        !it_stlal                    TYPE curto_stlal_range_t OPTIONAL
        !it_oldbomline_key           TYPE ztt_bomline_key OPTIONAL
        !it_oldproductbomreplace_key TYPE ztt_productbomreplace_key OPTIONAL
        !iv_matnr                    TYPE matnr OPTIONAL.
ENDCLASS.



CLASS zcl_mes_handler_cs0x IMPLEMENTATION.


  METHOD constructor.

    IF iv_stlnr IS NOT INITIAL.
      mv_stlnr = iv_stlnr.
    ENDIF.

    IF iv_stlal IS NOT INITIAL.
      mv_stlal = iv_stlal.
    ENDIF.

    IF it_stlal IS NOT INITIAL.
      mt_stlal = it_stlal.
    ENDIF.

    IF it_oldbomline_key IS NOT INITIAL.
      mt_oldbomline_key = it_oldbomline_key.
    ENDIF.

    IF it_oldproductbomreplace_key IS NOT INITIAL.
      mt_oldproductbomreplace_key = it_oldproductbomreplace_key.
    ENDIF.

    IF iv_matnr IS NOT INITIAL.
      mv_matnr = iv_matnr.
    ENDIF.

  ENDMETHOD.


  METHOD query_sap.
    DATA: ls_BomLine           TYPE zcl_mes_interface=>ty_bomline,
          lt_BomLine           TYPE zcl_mes_interface=>ty_t_bomline,
          ls_ProductBomReplace TYPE zcl_mes_interface=>ty_productbomreplace,
          lt_ProductBomReplace TYPE zcl_mes_interface=>ty_t_productbomreplace.


    CHECK iv_stlnr IS NOT INITIAL AND iv_stlal IS NOT INITIAL.

*   SQL
    SELECT * FROM ZI_BomLine WHERE stlnr = @iv_stlnr
                               AND BomCode = @iv_stlal
                               INTO TABLE @DATA(lt_data).

    CHECK NOT line_exists( lt_data[ RoutingCode = '' ] ).

*   Convert
    LOOP AT lt_data INTO DATA(ls_data) WHERE alpgr IS INITIAL
                                          OR ( alpgr IS NOT INITIAL AND alprf = '01' ).
      CLEAR ls_BomLine.
      MOVE-CORRESPONDING ls_data TO ls_BomLine.
      APPEND ls_BomLine TO lt_Bomline.
    ENDLOOP.

    LOOP AT lt_data INTO ls_data WHERE alpgr IS NOT INITIAL
                                   AND alprf > '01'.
      CLEAR ls_ProductBomReplace.
      MOVE-CORRESPONDING ls_data TO ls_ProductBomReplace.
      ls_ProductBomReplace-ItemReplaceCode = ls_data-ItemCode.
*      ls_ProductBomReplace-Amount = ls_data-Amount_replace.
      ls_ProductBomReplace-replaceunitcode = ls_data-UnitCode.
      ls_ProductBomReplace-replaceunitname = ls_data-UnitName.
      TRY.
          ls_ProductBomReplace-ItemOriginalCode = lt_data[ alpgr = ls_data-alpgr
                                                           alprf = '01' ]-ItemCode.
        CATCH cx_sy_itab_line_not_found.
          CONTINUE.
      ENDTRY.

      APPEND ls_ProductBomReplace TO lt_ProductBomReplace.
    ENDLOOP.

    et_BomLine = lt_Bomline.
    et_ProductBomReplace = lt_ProductBomReplace.

  ENDMETHOD.


  METHOD zif_mes_handler~is_triggered.

    mv_triggered = c_true.

    IF mv_triggered = c_true.
      rv_triggered = abap_true.
    ELSE.
      rv_triggered = abap_false.
    ENDIF.

  ENDMETHOD.


  METHOD zif_mes_handler~replicate.
    DATA: ls_BomLine           TYPE zcl_mes_interface=>ty_bomline,
          lt_BomLine           TYPE zcl_mes_interface=>ty_t_bomline,
          ls_ProductBomReplace TYPE zcl_mes_interface=>ty_productbomreplace,
          lt_ProductBomReplace TYPE zcl_mes_interface=>ty_t_productbomreplace.


    CHECK is_triggered( ) = abap_true.


    CONVERT DATE sy-datum
            TIME sy-uzeit INTO TIME STAMP DATA(lv_curr_timestamp) TIME ZONE ''.
    DATA(lv_datetime) = CONV char23( |{ lv_curr_timestamp TIMESTAMP = ISO }| ).

*   SQL
    query_sap( EXPORTING iv_stlnr = mv_stlnr
                         iv_stlal = mv_stlal
               IMPORTING et_bomline = lt_BomLine
                         et_productbomreplace = lt_ProductBomReplace ).

*   Compare
    LOOP AT mt_oldbomline_key INTO DATA(ls_oldbomline_key).
      IF NOT line_exists( lt_BomLine[ bomcode = ls_oldbomline_key-bomcode
                                      productcode = ls_oldbomline_key-productcode
                                      routingcode = ls_oldbomline_key-routingcode ] ).
        CLEAR ls_BomLine.
        MOVE-CORRESPONDING ls_oldbomline_key TO ls_BomLine.
        ls_BomLine-operatetype = 4.
        ls_BomLine-mdfdt = lv_datetime.
        APPEND ls_BomLine TO lt_BomLine.
      ENDIF.
    ENDLOOP.
    LOOP AT lt_BomLine ASSIGNING FIELD-SYMBOL(<fs_BomLine>) WHERE operatetype = 0.
      <fs_BomLine>-operatetype = 1.
      <fs_BomLine>-mdfdt = lv_datetime.
    ENDLOOP.

    LOOP AT mt_oldproductbomreplace_key INTO DATA(ls_oldproductbomreplace_key).
      IF NOT line_exists( lt_ProductBomReplace[ productcode = ls_oldproductbomreplace_key-productcode
                                                routingcode = ls_oldproductbomreplace_key-routingcode
                                                bomcode = ls_oldproductbomreplace_key-bomcode ] ).
        CLEAR ls_ProductBomReplace.
        MOVE-CORRESPONDING ls_oldproductbomreplace_key TO ls_ProductBomReplace.
        ls_ProductBomReplace-operatetype = 4.
        ls_ProductBomReplace-mdfdt = lv_datetime.
        APPEND ls_ProductBomReplace TO lt_ProductBomReplace.
      ENDIF.
    ENDLOOP.
    LOOP AT lt_ProductBomReplace ASSIGNING FIELD-SYMBOL(<fs_ProductBomReplace>) WHERE operatetype = 0.
      <fs_ProductBomReplace>-operatetype = 1.
      <fs_ProductBomReplace>-mdfdt = lv_datetime.
    ENDLOOP.

*    IF lt_BomLine IS INITIAL.
*      LOOP AT mt_stlal INTO DATA(ls_stlal).
*        APPEND INITIAL LINE TO lt_BomLine ASSIGNING FIELD-SYMBOL(<fs_BomLine>).
*        <fs_BomLine>-bomcode = ls_stlal-low.
*        <fs_BomLine>-productcode = mv_matnr.
*        <fs_BomLine>-operatetype = 4.
*        <fs_BomLine>-mdfdt = lv_datetime.
*      ENDLOOP.
*    ENDIF.
*
*    IF lt_ProductBomReplace IS INITIAL.
*      LOOP AT mt_stlal INTO ls_stlal.
*        APPEND INITIAL LINE TO lt_ProductBomReplace ASSIGNING FIELD-SYMBOL(<fs_ProductBomReplace>).
*        <fs_ProductBomReplace>-productcode = mv_matnr.
*        <fs_ProductBomReplace>-bomcode = ls_stlal-low.
*        <fs_ProductBomReplace>-operatetype = 4.
*        <fs_ProductBomReplace>-mdfdt = lv_datetime.
*      ENDLOOP.
*    ENDIF.

*    LOOP AT lt_BomLine ASSIGNING <fs_BomLine> WHERE operatetype <> 4.
*      IF <fs_BomLine>-routingcode IS INITIAL.
*        DELETE lt_ProductBomReplace WHERE productcode = <fs_BomLine>-productcode
*                                      AND bomcode = <fs_BomLine>-bomcode.
*        DELETE lt_BomLine WHERE bomcode = <fs_BomLine>-bomcode
*                            AND productcode = <fs_BomLine>-productcode.
*        CONTINUE.
*      ENDIF.
*      <fs_BomLine>-operatetype = 1.
*      <fs_BomLine>-mdfdt = lv_datetime.
*    ENDLOOP.
*
*    LOOP AT lt_ProductBomReplace ASSIGNING <fs_ProductBomReplace> WHERE operatetype <> 4.
*      IF <fs_ProductBomReplace>-routingcode IS INITIAL.
*        DELETE lt_BomLine WHERE bomcode = <fs_ProductBomReplace>-bomcode
*                            AND productcode = <fs_ProductBomReplace>-productcode.
*        DELETE lt_ProductBomReplace WHERE productcode = <fs_ProductBomReplace>-productcode
*                                      AND bomcode = <fs_ProductBomReplace>-bomcode.
*        CONTINUE.
*      ENDIF.
*      <fs_ProductBomReplace>-operatetype = 1.
*      <fs_ProductBomReplace>-mdfdt = lv_datetime.
*    ENDLOOP.


*   Update MES DB
    TRY.
        IF lt_BomLine IS NOT INITIAL.
          zcl_mes_interface=>Erp_BomLine( it_data = lt_BomLine ).
        ENDIF.

        IF lt_ProductBomReplace IS NOT INITIAL.
          zcl_mes_interface=>Erp_ProductBomReplace( it_data = lt_ProductBomReplace ).
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
