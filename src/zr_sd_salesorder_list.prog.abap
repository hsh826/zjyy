*&---------------------------------------------------------------------*
*& Report ZR_SD_SALESORDER_LIST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zr_sd_salesorder_list.

TABLES: vbak, vbap, twewt.
TYPES: BEGIN OF ty_data,
         salesdocument              TYPE vbeln_va,
         salesdocumentitem          TYPE posnr_va,
         memo                       TYPE c LENGTH 132,
         salesorganizationname      TYPE salesorganizationname,
         soldtoparty                TYPE kunag,
         soldtoparty_name           TYPE md_customer_name,
         shiptoparty_name           TYPE md_customer_name,
         salesofficename            TYPE salesofficename,
         salesdocumenttypename      TYPE tvakt_bezei,
         purchaseorderbycustomer    TYPE bstkd,
         correspncexternalreference TYPE ihrez,
         ihrez_e                    TYPE ihrez_e,
         close_status               TYPE zyy_close,
         material                   TYPE matnr,
         materialname               TYPE maktx,
         divisionname               TYPE divisionname,
         materialshortname          TYPE ewbez,
         packagemethod              TYPE bezei20,
         orderqty_wz                TYPE p LENGTH 15 DECIMALS 4,
         orderquantityunit          TYPE mseh3,
         orderqty_dx                TYPE p LENGTH 15 DECIMALS 3,
         netprice_wz                TYPE p LENGTH 15 DECIMALS 6,
         netamount                  TYPE netwr_ap,
         taxrate                    TYPE p LENGTH 15 DECIMALS 3,
         taxamount                  TYPE mwsbp,
         grossprice_wz              TYPE p LENGTH 15 DECIMALS 6,
         grossamount                TYPE p LENGTH 15 DECIMALS 3,
         dlvqty_wz                  TYPE p LENGTH 15 DECIMALS 4,
         dlvquantityunit            TYPE mseh3,
         dlvqty_dx                  TYPE p LENGTH 15 DECIMALS 3,
         dlvqty_amount              TYPE p LENGTH 15 DECIMALS 3,
         nondlvqty_wz               TYPE p LENGTH 15 DECIMALS 3,
         nondlvquantityunit         TYPE mseh3,
         nondlvqty_dx               TYPE p LENGTH 15 DECIMALS 3,
         nondlvqty_amount           TYPE p LENGTH 15 DECIMALS 3,
         plandlvdate                TYPE char100,
         billqty_wz                 TYPE p LENGTH 15 DECIMALS 3,
         billingquantityunit        TYPE mseh3,
         billqty_dx                 TYPE p LENGTH 15 DECIMALS 3,
         bill_netamount             TYPE netwr_fp,
         bill_grossamount           TYPE p LENGTH 15 DECIMALS 3,
*         cleareddate                TYPE budat,
*         clearedamount              TYPE p LENGTH 15 DECIMALS 3,
         hx_amt                     TYPE p LENGTH 15 DECIMALS 3,
         has_value                  TYPE char01,
         salesdocumentdate          TYPE datum,
         creationdate               TYPE erdat,
         creationtime               TYPE creation_time,
         createdbyuser              TYPE ernam,
         totalblockstatusdesc       TYPE status_bez,
         userstatusname             TYPE j_txt30,
         totaldeliverystatusdesc    TYPE status_bez,
         billingstatus_cal          TYPE char10,
         subsequentdocument         TYPE vbeln_nach,
         referencesddocument        TYPE vgbel,
         salesdocumenttype          TYPE auart,
         cell_type                  TYPE salv_t_int4_column,
       END OF ty_data.

CONSTANTS gc_label1 TYPE scrtext_l VALUE '不含税单价（元/销售单位）'.

DATA: gv_auart TYPE tdd_auart_nconv,
      gt_spstg TYPE RANGE OF spstg,
      go_alv   TYPE REF TO cl_salv_table,
      go_event TYPE REF TO cl_salv_events_table,
      gt_data  TYPE STANDARD TABLE OF ty_data WITH EMPTY KEY.
CLASS cl_handle_events DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      on_click FOR EVENT link_click OF cl_salv_events_table IMPORTING row column.
ENDCLASS.

CLASS cl_handle_events IMPLEMENTATION.
  METHOD on_click.
    PERFORM handle_click USING row column.
  ENDMETHOD.
ENDCLASS.

SELECTION-SCREEN BEGIN OF BLOCK block_1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS:
    so_vbeln FOR vbak-vbeln,
    so_auart FOR gv_auart,
    so_kunnr FOR vbak-kunnr,
    so_vkbur FOR vbak-vkbur,
    so_matnr FOR vbap-matnr,
    so_vkorg FOR vbak-vkorg,
    so_spart FOR vbap-spart,
    so_ewbez FOR twewt-ewbez.
SELECTION-SCREEN END OF BLOCK block_1.

SELECTION-SCREEN BEGIN OF BLOCK block_2 WITH FRAME TITLE TEXT-002.
  SELECT-OPTIONS:
    so_ernam FOR vbak-ernam,
    so_audat FOR vbak-audat,
    so_erdat FOR vbak-erdat.
SELECTION-SCREEN END OF BLOCK block_2.

SELECTION-SCREEN BEGIN OF BLOCK block_3 WITH FRAME TITLE TEXT-003.
  PARAMETERS:
    p_chk_1 AS CHECKBOX,
    p_chk_2 AS CHECKBOX,
    p_chk_3 AS CHECKBOX,
    p_chk_4 AS CHECKBOX,
    p_chk_5 AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN END OF BLOCK block_3.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR so_vbeln-low.
  PERFORM f4_search_help USING 'SO_VBELN-LOW'.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR so_vbeln-high.
  PERFORM f4_search_help USING 'SO_VBELN-HIGH'.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR so_auart-low.
  PERFORM f4_search_help USING 'SO_AUART-LOW'.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR so_auart-high.
  PERFORM f4_search_help USING 'SO_AUART-HIGH'.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR so_kunnr-low.
  PERFORM f4_search_help USING 'SO_KUNNR-LOW'.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR so_kunnr-high.
  PERFORM f4_search_help USING 'SO_KUNNR-HIGH'.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR so_matnr-low.
  PERFORM f4_search_help USING 'SO_MATNR-LOW'.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR so_matnr-high.
  PERFORM f4_search_help USING 'SO_MATNR-HIGH'.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR so_ewbez-low.
  PERFORM f4_search_help USING 'SO_EWBEZ-LOW'.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR so_ewbez-high.
  PERFORM f4_search_help USING 'SO_EWBEZ-HIGH'.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR so_ernam-low.
  PERFORM f4_search_help USING 'SO_ERNAM-LOW'.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR so_ernam-high.
  PERFORM f4_search_help USING 'SO_ERNAM-HIGH'.


START-OF-SELECTION.
  DATA    lt_spstgdesc TYPE RANGE OF char20.
  DATA ls_spstgdesc LIKE LINE OF lt_spstgdesc.
  DATA lv_char20 TYPE char20.
  IF p_chk_5 IS INITIAL.
    IF p_chk_1 IS NOT INITIAL.
      APPEND VALUE #( sign   = 'I' option = 'EQ' low = 'C' ) TO gt_spstg.
    ENDIF.
    IF p_chk_2 IS NOT INITIAL.
      APPEND VALUE #( sign   = 'I' option = 'EQ' low = 'A' ) TO gt_spstg.
    ENDIF.
    IF p_chk_3 IS NOT INITIAL.
      APPEND VALUE #( sign   = 'I' option = 'EQ' low = 'B' ) TO gt_spstg.
    ENDIF.
    IF p_chk_4 IS NOT INITIAL.
      APPEND VALUE #( sign   = 'I' option = 'EQ' low = 'C' ) TO gt_spstg.
    ENDIF.
  ENDIF.

*  LOOP AT gt_spstg INTO DATA(ls_spstg).
*    MOVE-CORRESPONDING ls_spstg TO ls_spstgdesc.
*    IF sy-langu = '1'.
*      CASE ls_spstg-low.
*        WHEN 'A'.     ls_spstgdesc-low = '没有处理'.
*        WHEN 'B'.     ls_spstgdesc-low = '部分处理'.
*        WHEN 'C' .    ls_spstgdesc-low = '完全地处理'.
*      ENDCASE.
*    ELSEIF sy-langu = 'E'.
*      CASE ls_spstg-low.
*        WHEN 'A'.     ls_spstgdesc-low = 'Not yet processed'.
*        WHEN 'B'.     ls_spstgdesc-low = 'Partially processed'.
*        WHEN 'C' .    ls_spstgdesc-low = 'Completely processed'.
*      ENDCASE.
*    ENDIF.
*    APPEND ls_spstgdesc TO lt_spstgdesc.
*
*  ENDLOOP.

  SELECT * FROM zi_salesorderlist INTO CORRESPONDING FIELDS OF TABLE @gt_data
    WHERE salesdocument IN @so_vbeln
      AND salesdocumenttype IN @so_auart
      AND soldtoparty IN @so_kunnr
      AND salesoffice IN @so_vkbur
      AND material IN @so_matnr
      AND salesorganization IN @so_vkorg
      AND division IN @so_spart
      AND totaldeliverystatus IN @gt_spstg
*      AND totaldeliverystatusdesc IN @lt_spstgdesc
*      AND totalblockstatus IN @gt_spstg
      AND materialshortname IN @so_ewbez
      AND createdbyuser IN @so_ernam
      AND creationdate IN @so_erdat
      AND salesdocumentdate IN @so_audat.

  "CR
  DATA: ls_text_line_z  TYPE ibiptextln,
        lt_text_lines_z TYPE STANDARD TABLE OF ibiptextln.
  "CR


  DATA lt_text TYPE TABLE OF tline.
  SORT gt_data BY salesdocument.

  DATA: lt_celltype TYPE salv_t_int4_column.
  DATA: ls_celltype LIKE LINE OF lt_celltype.
  ls_celltype-columnname = 'HX_AMT'.
  ls_celltype-value      = if_salv_c_cell_type=>hotspot.
  APPEND ls_celltype TO lt_celltype.

  LOOP AT gt_data REFERENCE INTO DATA(lr_data).
    "CR

    CLEAR:  ls_text_line_z, lt_text_lines_z.

    ls_text_line_z-mandt    = sy-mandt.
    ls_text_line_z-tdobject = 'VBBP'.
    ls_text_line_z-tdname   = lr_data->salesdocument && lr_data->salesdocumentitem.
    ls_text_line_z-tdspras  = '1'.
    ls_text_line_z-tdid     = '0002'.
    APPEND ls_text_line_z TO lt_text_lines_z.

    zcl_if_class=>get_so_long_text(
                                    IMPORTING es_line1     = lr_data->memo
                                    CHANGING ct_text_lines = lt_text_lines_z

    ).


    "CR

    IF lr_data->salesdocumenttype = 'ZTH' OR lr_data->salesdocumenttype = 'ZTH0'.
      lr_data->orderqty_wz *= -1.
      lr_data->orderqty_dx *= -1.
      lr_data->netamount *= -1.
      lr_data->taxamount *= -1.
      lr_data->grossamount *= -1.
      lr_data->dlvqty_wz *= -1.
      lr_data->dlvqty_dx *= -1.
      lr_data->dlvqty_amount *= -1.
      lr_data->nondlvqty_wz *= -1.
      lr_data->nondlvqty_dx *= -1.
      lr_data->nondlvqty_amount *= -1.
      lr_data->billqty_wz *= -1.
      lr_data->billqty_dx *= -1.
      lr_data->bill_netamount *= -1.
      lr_data->bill_grossamount *= -1.
      lr_data->hx_amt *= -1.
*      lr_data->clearedamount *= -1.
    ENDIF.

    SELECT vbeln FROM vbfa INTO TABLE @DATA(lt_vbeln) WHERE vbelv = @lr_data->salesdocument
                                                        AND posnv = @lr_data->salesdocumentitem
                                                        AND vbtyp_n = 'H'.
    LOOP AT lt_vbeln REFERENCE INTO DATA(lr_vbeln).
      AT FIRST.
        lr_data->subsequentdocument = |{ lr_vbeln->vbeln ALPHA = OUT }|.
        CONTINUE.
      ENDAT.
      lr_data->subsequentdocument = lr_data->subsequentdocument && '/' && |{ lr_vbeln->vbeln ALPHA = OUT }|.
    ENDLOOP.

    AT NEW salesdocument.
      DATA(lv_name) = CONV tdobname( lr_data->salesdocument ).
      CLEAR lt_text.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          id                      = '0001'
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
      IF lt_text IS NOT INITIAL.
        lr_data->plandlvdate = lt_text[ 1 ]-tdline.
      ELSE.
        SELECT edatu FROM vbep INTO TABLE @DATA(lt_edatu) WHERE vbeln = @lr_data->salesdocument
                                                            AND posnr = @lr_data->salesdocumentitem.
        LOOP AT lt_edatu REFERENCE INTO DATA(lr_edatu).
          AT FIRST.
            lr_data->plandlvdate = |{ lr_edatu->edatu DATE = ISO }|.
            CONTINUE.
          ENDAT.
          lr_data->plandlvdate = lr_data->plandlvdate && '/' && |{ lr_edatu->edatu DATE = ISO }|.
        ENDLOOP.
      ENDIF.
    ENDAT.
    IF lr_data->orderqty_wz = lr_data->dlvqty_wz AND lr_data->totaldeliverystatusdesc = '已完成'.
      lr_data->dlvqty_amount = lr_data->dlvqty_amount  + lr_data->nondlvqty_amount.
      CLEAR lr_data->nondlvqty_amount.
    ENDIF.
    IF lr_data->has_value = abap_true.
      lr_data->cell_type = lt_celltype.
*    ELSE.
*      SELECT SINGLE * FROM zsd02billso INTO @DATA(ls_bill)
*        WHERE aubel = @lr_data->salesdocument
*          AND aupos = @lr_data->salesdocumentitem.
*      IF sy-subrc = 0.
*        lr_data->cell_type = lt_celltype.
*      ENDIF.
    ENDIF.

  ENDLOOP.


  TRY.
      cl_salv_table=>factory(
        IMPORTING
          r_salv_table = go_alv
        CHANGING
          t_table      = gt_data ).
    CATCH cx_salv_msg.                                  "#EC NO_HANDLER
  ENDTRY.


  go_event = go_alv->get_event( ).

  DATA: go_handle_event TYPE REF TO cl_handle_events.
  CREATE OBJECT go_handle_event.
  SET HANDLER go_handle_event->on_click FOR go_event.

  DATA(lo_functions) = go_alv->get_functions( ).
*  lo_functions->set_all( 'X' ).
  go_alv->set_screen_status(
    pfstatus      =  '0100'
*    pfstatus      =  'SALV_STANDARD'
    report        =  sy-repid
    set_functions = go_alv->c_functions_all ).

  DATA: lo_layout TYPE REF TO cl_salv_layout,
        ls_key    TYPE salv_s_layout_key.

  lo_layout = go_alv->get_layout( ).

*... §4.1 set the Layout Key
  ls_key-report = sy-repid.
  lo_layout->set_key( ls_key ).

*... §4.2 set usage of default Layouts
  lo_layout->set_default( '' ).

*... §4.3 set Layout save restriction
  lo_layout->set_save_restriction( '3' ).

**... §4.4 set initial Layout
*  if gs_test-load_layo eq gc_true.
*    lr_layout->set_initial_layout( gs_test-layout ).
*  endif.

  DATA(lo_columns) = go_alv->get_columns( ).
  lo_columns->set_optimize( 'X' ).
  lo_columns->set_cell_type_column('CELL_TYPE' ).
  AUTHORITY-CHECK OBJECT 'ZSD_PRICE'
    ID 'ACTVT' FIELD '03'.
  IF sy-subrc <> 0.
    DATA(lv_hide) = abap_true.
  ELSE.
    lv_hide = abap_false.
  ENDIF.

  DATA(lo_column) = lo_columns->get_column( 'SALESDOCUMENT' ).
  lo_column->set_short_text( '订单编号' ).
  lo_column->set_medium_text( '订单编号' ).
  lo_column->set_long_text( '订单编号' ).

  lo_column = lo_columns->get_column( 'SALESDOCUMENTITEM' ).
  lo_column->set_short_text( '订单行项目' ).
  lo_column->set_medium_text( '订单行项目' ).
  lo_column->set_long_text( '订单行项目' ).

*  CR ALV列表中新增一列“项目注释”   "项目注释
  lo_column = lo_columns->get_column( 'MEMO' ).
  lo_column->set_short_text( '项目注释' ).
  lo_column->set_medium_text( '项目注释' ).
  lo_column->set_long_text( '项目注释' ).
* CR  ALV列表中新增一列“项目注释”   "项目注释

  lo_column = lo_columns->get_column( 'SALESORGANIZATIONNAME' ).
  lo_column->set_short_text( '销售组织描述' ).
  lo_column->set_medium_text( '销售组织描述' ).
  lo_column->set_long_text( '销售组织描述' ).

  lo_column = lo_columns->get_column( 'SOLDTOPARTY' ).
  lo_column->set_short_text( '客户代码' ).
  lo_column->set_medium_text( '客户代码' ).
  lo_column->set_long_text( '客户代码' ).

  lo_column = lo_columns->get_column( 'SOLDTOPARTY_NAME' ).
  lo_column->set_short_text( '客户名称' ).
  lo_column->set_medium_text( '客户名称' ).
  lo_column->set_long_text( '客户名称' ).

  lo_column = lo_columns->get_column( 'SHIPTOPARTY_NAME' ).
  lo_column->set_short_text( '送达方' ).
  lo_column->set_medium_text( '送达方' ).
  lo_column->set_long_text( '送达方' ).

  lo_column = lo_columns->get_column( 'SALESOFFICENAME' ).
  lo_column->set_short_text( '客户区域' ).
  lo_column->set_medium_text( '客户区域' ).
  lo_column->set_long_text( '客户区域' ).

  lo_column = lo_columns->get_column( 'SALESDOCUMENTTYPENAME' ).
  lo_column->set_short_text( '订单类型' ).
  lo_column->set_medium_text( '订单类型' ).
  lo_column->set_long_text( '订单类型' ).

  lo_column = lo_columns->get_column( 'PURCHASEORDERBYCUSTOMER' ).
  lo_column->set_short_text( '采购订单号' ).
  lo_column->set_medium_text( '采购订单号' ).
  lo_column->set_long_text( '采购订单号' ).

  lo_column = lo_columns->get_column( 'CORRESPNCEXTERNALREFERENCE' ).
  lo_column->set_short_text( '网签合同号' ).
  lo_column->set_medium_text( '网签合同号' ).
  lo_column->set_long_text( '网签合同号' ).

  lo_column = lo_columns->get_column( 'IHREZ_E' ).
  lo_column->set_short_text( '调拨转储单号' ).
  lo_column->set_medium_text( '调拨转储单号' ).
  lo_column->set_long_text( '调拨转储单号' ).

  lo_column = lo_columns->get_column( 'CLOSE_STATUS' ).
  lo_column->set_short_text( '手工关闭' ).
  lo_column->set_medium_text( '手工关闭' ).
  lo_column->set_long_text( '手工关闭' ).

  lo_column = lo_columns->get_column( 'MATERIAL' ).
  lo_column->set_short_text( '产品代码' ).
  lo_column->set_medium_text( '产品代码' ).
  lo_column->set_long_text( '产品代码' ).

  lo_column = lo_columns->get_column( 'MATERIALNAME' ).
  lo_column->set_short_text( '产品名称' ).
  lo_column->set_medium_text( '产品名称' ).
  lo_column->set_long_text( '产品名称' ).

  lo_column = lo_columns->get_column( 'DIVISIONNAME' ).
  lo_column->set_short_text( '产品组' ).
  lo_column->set_medium_text( '产品组' ).
  lo_column->set_long_text( '产品组' ).

  lo_column = lo_columns->get_column( 'MATERIALSHORTNAME' ).
  lo_column->set_short_text( '简称' ).
  lo_column->set_medium_text( '简称' ).
  lo_column->set_long_text( '简称' ).

  lo_column = lo_columns->get_column( 'PACKAGEMETHOD' ).
  lo_column->set_short_text( '包装方式' ).
  lo_column->set_medium_text( '包装方式' ).
  lo_column->set_long_text( '包装方式' ).

  lo_column = lo_columns->get_column( 'ORDERQTY_WZ' ).
  lo_column->set_short_text( '订单数量' ).
  lo_column->set_medium_text( '订单数量' ).
  lo_column->set_long_text( '订单数量' ).

  lo_column = lo_columns->get_column( 'ORDERQUANTITYUNIT' ).
  lo_column->set_short_text( '订单单位' ).
  lo_column->set_medium_text( '订单单位' ).
  lo_column->set_long_text( '订单单位' ).

  lo_column = lo_columns->get_column( 'ORDERQTY_DX' ).
  lo_column->set_short_text( '订单数量（大箱）' ).
  lo_column->set_medium_text( '订单数量（大箱）' ).
  lo_column->set_long_text( '订单数量（大箱）' ).

  lo_column = lo_columns->get_column( 'NETPRICE_WZ' ).
  lo_column->set_long_text( gc_label1 ).
  lo_column->set_technical( lv_hide ).

  lo_column = lo_columns->get_column( 'NETAMOUNT' ).
  lo_column->set_short_text( '不含税总价' ).
  lo_column->set_medium_text( '不含税总价' ).
  lo_column->set_long_text( '不含税总价' ).
  lo_column->set_technical( lv_hide ).

  lo_column = lo_columns->get_column( 'TAXRATE' ).
  lo_column->set_short_text( '税率' ).
  lo_column->set_medium_text( '税率' ).
  lo_column->set_long_text( '税率' ).

  lo_column = lo_columns->get_column( 'TAXAMOUNT' ).
  lo_column->set_short_text( '税额' ).
  lo_column->set_medium_text( '税额' ).
  lo_column->set_long_text( '税额' ).
  lo_column->set_technical( lv_hide ).

  lo_column = lo_columns->get_column( 'GROSSPRICE_WZ' ).
  lo_column->set_short_text( '含税单价' ).
  lo_column->set_medium_text( '含税单价' ).
  lo_column->set_long_text( '含税单价' ).
  lo_column->set_technical( lv_hide ).

  lo_column = lo_columns->get_column( 'GROSSAMOUNT' ).
  lo_column->set_short_text( '含税总价' ).
  lo_column->set_medium_text( '含税总价' ).
  lo_column->set_long_text( '含税总价' ).
  lo_column->set_technical( lv_hide ).

  lo_column = lo_columns->get_column( 'DLVQTY_WZ' ).
  lo_column->set_short_text( '已交货数量' ).
  lo_column->set_medium_text( '已交货数量' ).
  lo_column->set_long_text( '已交货数量' ).

  lo_column = lo_columns->get_column( 'DLVQUANTITYUNIT' ).
  lo_column->set_short_text( '报表单位' ).
  lo_column->set_medium_text( '报表单位' ).
  lo_column->set_long_text( '报表单位' ).
  lo_column->set_visible( abap_false ).

  lo_column = lo_columns->get_column( 'DLVQTY_DX' ).
  lo_column->set_short_text( '已交货数量（大箱）' ).
  lo_column->set_medium_text( '已交货数量（大箱）' ).
  lo_column->set_long_text( '已交货数量（大箱）' ).

  lo_column = lo_columns->get_column( 'DLVQTY_AMOUNT' ).
  lo_column->set_short_text( '已发货金额' ).
  lo_column->set_medium_text( '已发货金额' ).
  lo_column->set_long_text( '已发货金额' ).
  lo_column->set_technical( lv_hide ).

  lo_column = lo_columns->get_column( 'NONDLVQTY_WZ' ).
  lo_column->set_short_text( '未交货数量' ).
  lo_column->set_medium_text( '未交货数量' ).
  lo_column->set_long_text( '未交货数量' ).

  lo_column = lo_columns->get_column( 'NONDLVQUANTITYUNIT' ).
  lo_column->set_short_text( '未交货单位' ).
  lo_column->set_medium_text( '未交货单位' ).
  lo_column->set_long_text( '未交货单位' ).
  lo_column->set_visible( abap_false ).

  lo_column = lo_columns->get_column( 'NONDLVQTY_DX' ).
  lo_column->set_short_text( '未发货数量（大箱）' ).
  lo_column->set_medium_text( '未发货数量（大箱）' ).
  lo_column->set_long_text( '未发货数量（大箱）' ).

  lo_column = lo_columns->get_column( 'NONDLVQTY_AMOUNT' ).
  lo_column->set_short_text( '未发货金额' ).
  lo_column->set_medium_text( '未发货金额' ).
  lo_column->set_long_text( '未发货金额' ).
  lo_column->set_technical( lv_hide ).

  lo_column = lo_columns->get_column( 'PLANDLVDATE' ).
  lo_column->set_short_text( '计划交货日期' ).
  lo_column->set_medium_text( '计划交货日期' ).
  lo_column->set_long_text( '计划交货日期' ).

  lo_column = lo_columns->get_column( 'BILLQTY_WZ' ).
  lo_column->set_short_text( '已开票数量' ).
  lo_column->set_medium_text( '已开票数量' ).
  lo_column->set_long_text( '已开票数量' ).

  lo_column = lo_columns->get_column( 'BILLINGQUANTITYUNIT' ).
  lo_column->set_short_text( '已开票单位' ).
  lo_column->set_medium_text( '已开票单位' ).
  lo_column->set_long_text( '已开票单位' ).
  lo_column->set_visible( abap_false ).

  lo_column = lo_columns->get_column( 'BILLQTY_DX' ).
  lo_column->set_short_text( '已开票数量（大箱）' ).
  lo_column->set_medium_text( '已开票数量（大箱）' ).
  lo_column->set_long_text( '已开票数量（大箱）' ).

  lo_column = lo_columns->get_column( 'BILL_NETAMOUNT' ).
  lo_column->set_short_text( '已开票金额（不含税）' ).
  lo_column->set_medium_text( '已开票金额（不含税）' ).
  lo_column->set_long_text( '已开票金额（不含税）' ).
  lo_column->set_technical( lv_hide ).

  lo_column = lo_columns->get_column( 'BILL_GROSSAMOUNT' ).
  lo_column->set_short_text( '已开票金额（含税）' ).
  lo_column->set_medium_text( '已开票金额（含税）' ).
  lo_column->set_long_text( '已开票金额（含税）' ).
  lo_column->set_technical( lv_hide ).

*  lo_column = lo_columns->get_column( 'CLEAREDDATE' ).
*  lo_column->set_short_text( '回笼日期' ).
*  lo_column->set_medium_text( '回笼日期' ).
*  lo_column->set_long_text( '回笼日期' ).
*
*  lo_column = lo_columns->get_column( 'CLEAREDAMOUNT' ).
*  lo_column->set_short_text( '回笼金额' ).
*  lo_column->set_medium_text( '回笼金额' ).
*  lo_column->set_long_text( '回笼金额' ).
*  lo_column->set_technical( lv_hide ).
  lo_column = lo_columns->get_column( 'HX_AMT' ).
  lo_column->set_short_text( '核销金额' ).
  lo_column->set_medium_text( '核销金额' ).
  lo_column->set_long_text( '核销金额' ).
  lo_column->set_technical( lv_hide ).

  lo_column = lo_columns->get_column( 'SALESDOCUMENTDATE' ).
  lo_column->set_short_text( '凭证日期' ).
  lo_column->set_medium_text( '凭证日期' ).
  lo_column->set_long_text( '凭证日期' ).

  lo_column = lo_columns->get_column( 'CREATIONDATE' ).
  lo_column->set_short_text( '创建日期' ).
  lo_column->set_medium_text( '创建日期' ).
  lo_column->set_long_text( '创建日期' ).

  lo_column = lo_columns->get_column( 'CREATIONTIME' ).
  lo_column->set_short_text( '创建时间' ).
  lo_column->set_medium_text( '创建时间' ).
  lo_column->set_long_text( '创建时间' ).

  lo_column = lo_columns->get_column( 'CREATIONTIME' ).
  lo_column->set_short_text( '创建时间' ).
  lo_column->set_medium_text( '创建时间' ).
  lo_column->set_long_text( '创建时间' ).

  lo_column = lo_columns->get_column( 'CREATEDBYUSER' ).
  lo_column->set_short_text( '制单人' ).
  lo_column->set_medium_text( '制单人' ).
  lo_column->set_long_text( '制单人' ).

  lo_column = lo_columns->get_column( 'TOTALBLOCKSTATUSDESC' ).
  lo_column->set_short_text( '订单状态' ).
  lo_column->set_medium_text( '订单状态' ).
  lo_column->set_long_text( '订单状态' ).

  lo_column = lo_columns->get_column( 'USERSTATUSNAME' ).
  lo_column->set_short_text( '审批状态' ).
  lo_column->set_medium_text( '审批状态' ).
  lo_column->set_long_text( '审批状态' ).

  lo_column = lo_columns->get_column( 'TOTALDELIVERYSTATUSDESC' ).
  lo_column->set_short_text( '发货状态' ).
  lo_column->set_medium_text( '发货状态' ).
  lo_column->set_long_text( '发货状态' ).

  lo_column = lo_columns->get_column( 'BILLINGSTATUS_CAL' ).
  lo_column->set_short_text( '开票状态' ).
  lo_column->set_medium_text( '开票状态' ).
  lo_column->set_long_text( '开票状态' ).

  lo_column = lo_columns->get_column( 'SUBSEQUENTDOCUMENT' ).
  lo_column->set_short_text( '后续单号' ).
  lo_column->set_medium_text( '后续单号' ).
  lo_column->set_long_text( '后续单号' ).

  lo_column = lo_columns->get_column( 'REFERENCESDDOCUMENT' ).
  lo_column->set_short_text( '前序单号' ).
  lo_column->set_medium_text( '前序单号' ).
  lo_column->set_long_text( '前序单号' ).

*  lo_column = lo_columns->get_column( 'SALESORGANIZATION' ).
*  lo_column->set_technical( 'X' ).
*
  lo_column = lo_columns->get_column( 'SALESDOCUMENTTYPE' ).
  lo_column->set_technical( 'X' ).
  lo_column = lo_columns->get_column( 'HAS_VALUE' ).
  lo_column->set_technical( 'X' ).
*
*  lo_column = lo_columns->get_column( 'SALESOFFICE' ).
*  lo_column->set_technical( 'X' ).
*
*  lo_column = lo_columns->get_column( 'DIVISION' ).
*  lo_column->set_technical( 'X' ).
*
*  lo_column = lo_columns->get_column( 'TOTALBLOCKSTATUS' ).
*  lo_column->set_technical( 'X' ).


  go_alv->display( ).



FORM f4_search_help USING dynp_field TYPE help_info-dynprofld.
  DATA:
    lv_dynp_field      TYPE string,
    lv_retfield        TYPE dfies-fieldname,
    lt_data            TYPE REF TO data,
    lo_type            TYPE REF TO cl_abap_datadescr,
    lt_dynpfld_mapping TYPE STANDARD TABLE OF dselc.

  FIELD-SYMBOLS:
     <fs_value_tab> TYPE STANDARD TABLE.


  lv_dynp_field = dynp_field.
  REPLACE ALL OCCURRENCES OF REGEX '^SO_|-LOW$|-HIGH$'
    IN lv_dynp_field WITH ''.

  CASE lv_dynp_field.
    WHEN 'VBELN'.
      SELECT vbeln FROM vbak
        INTO TABLE @DATA(lt_vbeln)
        WHERE vbtyp IN ( 'C', 'H', 'I' )
        ORDER BY vbeln ASCENDING.

      lo_type = CAST cl_abap_datadescr(
      cl_abap_typedescr=>describe_by_data(
        EXPORTING
          p_data = lt_vbeln ) ).

      CREATE DATA lt_data TYPE HANDLE lo_type.
      ASSIGN lt_data->* TO <fs_value_tab>.
      MOVE-CORRESPONDING lt_vbeln TO <fs_value_tab>.

    WHEN 'AUART'.
      SELECT DISTINCT vbak~auart, bezei FROM vbak
        LEFT OUTER JOIN tvakt ON vbak~auart = tvakt~auart
        INTO TABLE @DATA(lt_auart)
        WHERE vbtyp IN ( 'C', 'H', 'I' )
          AND spras = @sy-langu
        ORDER BY vbak~auart ASCENDING.

      lo_type = CAST cl_abap_datadescr(
      cl_abap_typedescr=>describe_by_data(
        EXPORTING
          p_data = lt_auart ) ).

      CREATE DATA lt_data TYPE HANDLE lo_type.
      ASSIGN lt_data->* TO <fs_value_tab>.
      MOVE-CORRESPONDING lt_auart TO <fs_value_tab>.

    WHEN 'KUNNR'.
      SELECT DISTINCT vbpa~kunnr, but000~name_org1 FROM vbpa
        INNER JOIN vbak        ON vbak~vbeln = vbpa~vbeln
        LEFT OUTER JOIN but000 ON vbpa~kunnr = but000~partner
        INTO TABLE @DATA(lt_kunnr)
        WHERE vbtyp IN ( 'C', 'H', 'I' )
          AND parvw = 'WE'
        ORDER BY vbpa~kunnr ASCENDING.

      lo_type = CAST cl_abap_datadescr(
      cl_abap_typedescr=>describe_by_data(
        EXPORTING
          p_data = lt_kunnr ) ).

      CREATE DATA lt_data TYPE HANDLE lo_type.
      ASSIGN lt_data->* TO <fs_value_tab>.
      MOVE-CORRESPONDING lt_kunnr TO <fs_value_tab>.

    WHEN 'MATNR'.
      SELECT DISTINCT vbap~matnr, makt~maktx FROM vbap
        INNER JOIN vbak      ON vbak~vbeln = vbap~vbeln
        LEFT OUTER JOIN makt ON vbap~matnr = makt~matnr
        INTO TABLE @DATA(lt_matnr)
        WHERE vbtyp IN ( 'C', 'H', 'I' )
        ORDER BY vbap~matnr.

      lo_type = CAST cl_abap_datadescr(
      cl_abap_typedescr=>describe_by_data(
        EXPORTING
          p_data = lt_matnr ) ).

      CREATE DATA lt_data TYPE HANDLE lo_type.
      ASSIGN lt_data->* TO <fs_value_tab>.
      MOVE-CORRESPONDING lt_matnr TO <fs_value_tab>.

    WHEN 'EWBEZ'.
      SELECT twewt~ewbez FROM twewt
        INTO TABLE @DATA(lt_ewbez)
        WHERE spras = '1'
        ORDER BY ewbez.

      lo_type = CAST cl_abap_datadescr(
      cl_abap_typedescr=>describe_by_data(
        EXPORTING
          p_data = lt_ewbez ) ).

      CREATE DATA lt_data TYPE HANDLE lo_type.
      ASSIGN lt_data->* TO <fs_value_tab>.
      MOVE-CORRESPONDING lt_ewbez TO <fs_value_tab>.

    WHEN 'ERNAM'.
      SELECT DISTINCT ernam, name_last, name_first, name_text FROM vbak
        INNER JOIN usr21 ON vbak~ernam = usr21~bname
        LEFT OUTER JOIN adrp ON adrp~persnumber = usr21~persnumber
        INTO TABLE @DATA(lt_ernam)
        WHERE vbtyp IN ( 'C', 'H', 'I' )
        ORDER BY ernam ASCENDING.

      lo_type = CAST cl_abap_datadescr(
      cl_abap_typedescr=>describe_by_data(
        EXPORTING
          p_data = lt_ernam ) ).

      CREATE DATA lt_data TYPE HANDLE lo_type.
      ASSIGN lt_data->* TO <fs_value_tab>.
      MOVE-CORRESPONDING lt_ernam TO <fs_value_tab>.

    WHEN OTHERS.
      RETURN.

  ENDCASE.

  lt_dynpfld_mapping = VALUE #(
                        ( fldname = 'F0001'
                          dyfldname = dynp_field ) ).

  lv_retfield = lv_dynp_field.
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = lv_retfield
      dynpprog        = sy-repid
      dynpnr          = sy-dynnr
      dynprofield     = dynp_field
      value_org       = 'S'
    TABLES
      value_tab       = <fs_value_tab>
      dynpfld_mapping = lt_dynpfld_mapping
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.
  IF sy-subrc <> 0.
    "Do nothing
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form handle_click
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ROW
*&      --> COLUMN
*&---------------------------------------------------------------------*
FORM handle_click  USING   uv_row TYPE salv_de_row
                           uv_column TYPE salv_de_column.
  DATA: lt_item    TYPE STANDARD TABLE OF zyy_t_sd02,
        lo_alv     TYPE REF TO cl_salv_table,
        lo_funlst  TYPE REF TO cl_salv_functions_list,
        lx_root    TYPE REF TO cx_root,
        lv_msg     TYPE        string,
        lo_columns TYPE REF TO cl_salv_columns_table.

  CHECK uv_column = 'HX_AMT'.
  READ TABLE gt_data  INTO DATA(ls_data) INDEX uv_row.
  "SELECT * FROM zsd02billhxi INTO CORRESPONDING FIELDS OF TABLE lt_item
  SELECT * FROM zsd02billhx INTO CORRESPONDING FIELDS OF TABLE lt_item
    WHERE aubel = ls_data-salesdocument AND aupos = ls_data-salesdocumentitem.
*  IF sy-subrc = 0.
*    SORT lt_item BY belnr docln racct.
*    DELETE ADJACENT DUPLICATES FROM lt_item COMPARING belnr docln racct.
*  ENDIF.
  TRY.
      cl_salv_table=>factory( IMPORTING r_salv_table = lo_alv
                               CHANGING t_table      = lt_item[] ).
    CATCH  cx_root INTO lx_root.
      lv_msg = lx_root->get_text( ).
      MESSAGE e000(oo) WITH lv_msg.
  ENDTRY.
  lo_funlst = go_alv->get_functions( ).
  lo_funlst->set_all( 'X' ).
  lo_columns = lo_alv->get_columns( ).
  lo_columns->set_optimize( 'X' ).
  lo_alv->set_screen_status(
  pfstatus      =  'SALV_STANDARD'
  report        =  sy-repid
  set_functions = lo_alv->c_functions_all ).
  IF lo_alv IS BOUND.
    lo_alv->set_screen_popup( start_column = 18  end_column  = 120 start_line  = 2 end_line = 25 ).
    lo_alv->display( ).

    DATA: is_stable      TYPE  lvc_s_stbl.
    is_stable-row = abap_true.
    is_stable-col = abap_true.
    CALL METHOD go_alv->refresh
      EXPORTING
        s_stable = is_stable.
  ENDIF.
ENDFORM.
