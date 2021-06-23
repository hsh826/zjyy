*&---------------------------------------------------------------------*
*& Report ZFI_PRINT_DOCUMENT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zfi_print_document.

CLASS lcl_utils DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS
      spell_amount
        IMPORTING iv_money        TYPE bseg-dmbtr
        RETURNING VALUE(rv_money) TYPE string.
ENDCLASS.

INCLUDE rfkori00.
INCLUDE rfkori04.

begin_of_block 2.
PARAMETERS:     rforid   LIKE rfpdo1-allgevfo NO-DISPLAY .

PARAMETERS:     sortvk   LIKE rfpdo1-kordvarb NO-DISPLAY .

PARAMETERS:     dspras   LIKE rfpdo1-kord30as NO-DISPLAY .
PARAMETERS:     danzzl   LIKE adrs-anzzl DEFAULT '3' NO-DISPLAY .
end_of_block 2.
begin_of_block 8.
SELECTION-SCREEN BEGIN OF LINE.
*  SELECTION-SCREEN COMMENT 1(30) TEXT-110 FOR FIELD tddest.
  SELECTION-SCREEN POSITION POS_LOW.
  PARAMETERS      tddest   LIKE tsp01-rqdest VISIBLE LENGTH 11 NO-DISPLAY.
  SELECTION-SCREEN POSITION POS_HIGH.
  PARAMETERS      rimmd    LIKE rfpdo2-f140immd DEFAULT ' ' NO-DISPLAY.
*  SELECTION-SCREEN COMMENT 61(15) TEXT-111 FOR FIELD rimmd.
SELECTION-SCREEN END OF LINE.
PARAMETERS:     prdest   LIKE tsp01-rqdest VISIBLE LENGTH 11 NO-DISPLAY .
end_of_block 8.
*begin_of_block 4.
SELECTION-SCREEN BEGIN OF BLOCK 4 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: rbukrs   FOR  bkorm-bukrs NO INTERVALS NO-EXTENSION OBLIGATORY,
                  rkoart   FOR  bkorm-koart NO-DISPLAY,
                  rkonto   FOR  bkorm-konto NO-DISPLAY,
                  rgjahr   FOR  bkorm-gjahr NO INTERVALS NO-EXTENSION OBLIGATORY,
                  s_monat  FOR  bkpf-monat  NO INTERVALS NO-EXTENSION,
                  s_blart  FOR  bkpf-blart  ,
                  rbelnr   FOR  bkorm-belnr OBLIGATORY,
                  s_budat  FOR  bkpf-budat,
                  s_usnam FOR bkpf-usnam NO INTERVALS NO-EXTENSION,
                  s_ppnam FOR bkpf-ppnam NO INTERVALS NO-EXTENSION.
  PARAMETERS:     p_chk   TYPE flag AS CHECKBOX.

  PARAMETERS:     rxbkor   LIKE rfpdo-kordbkor NO-DISPLAY .
  PARAMETERS:     revent   LIKE bkorm-event NO-DISPLAY .
  SELECT-OPTIONS: rusnam   FOR  bkorm-usnam NO-DISPLAY .
  SELECT-OPTIONS: rdatum   FOR  bkorm-datum NO-DISPLAY .
  SELECT-OPTIONS: ruzeit   FOR  bkorm-uzeit NO-DISPLAY .
  SELECT-OPTIONS: rerldt   FOR  bkorm-erldt NO-DISPLAY .
  PARAMETERS:     rxtsub   LIKE xtsubm NO-DISPLAY.
  PARAMETERS: rxkont LIKE xkont NO-DISPLAY,
              rxbelg LIKE xbelg NO-DISPLAY,
              ranzdt LIKE anzdt NO-DISPLAY,
              rkauto TYPE c     NO-DISPLAY,
              rsimul TYPE c     NO-DISPLAY,
              rpdest LIKE syst-pdest NO-DISPLAY.

  PARAMETERS:     rindko   LIKE rfpdo1-kordindk NO-DISPLAY .
  PARAMETERS:     rspras   LIKE rf140-spras NO-DISPLAY .
  PARAMETERS:     title    LIKE rfpdo1-allgline NO-DISPLAY .
*end_of_block 4.
  PARAMETERS p_park TYPE char1 AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK 4.



START-OF-SELECTION.

  TYPES: BEGIN OF ty_parked,
           accountingdocument       TYPE vbkpf-belnr,
           ledgergllineitem         TYPE vbsegs-bzkey,
           postingkey               TYPE vbsegs-bschl,
           glaccount                TYPE vbsegs-saknr,
           glaccountname            TYPE skat-txt20,
           documentitemtext         TYPE vbsegs-sgtxt,
           costcenter               TYPE vbsegs-kostl,
           costcentername           TYPE cskt-ktext,
           material                 TYPE vbsegs-matnr,
           customer                 TYPE vbsegd-kunnr,
           customername             TYPE kna1-name1,
           vendor                   TYPE vbsegk-lifnr,
           vendorname               TYPE lfa1-name1,
           suppliershortname        TYPE lfa1-sortl,
           matnr                    TYPE vbsegs-matnr, "material
           functionalarea           TYPE vbsegs-fkber,
           functionalareaname       TYPE tfkbt-fkbtx,
           dmbtr                    TYPE vbsegs-dmbtr, "local amount
           shkzg                    TYPE vbsegs-shkzg, "S = debit, h = credit
           xnegp                    TYPE vbsegs-xnegp,
           debitamountincocodecrcy  TYPE vbsegs-dmbtr,
           creditamountincocodecrcy TYPE vbsegs-dmbtr,
           orderid                  TYPE vbsegs-aufnr,
         END OF ty_parked.

  DATA lt_document_parked_temp TYPE STANDARD TABLE OF ty_parked.
  DATA lt_document_parked_all TYPE STANDARD TABLE OF ty_parked.

  DATA: lv_fm_name           TYPE funcname,
        ls_output_param      TYPE sfpoutputparams,
        ls_doc_param         TYPE sfpdocparams,
        lt_items             TYPE ztt_pdf_fi_doc_itm,
        ls_header            TYPE zst_pdf_fi_doc_hd,
        lt_pages             TYPE ztt_pdf_fi_doc,
        lv_sgtxt             TYPE string,
        lv_suppliershortname TYPE string,
        lv_z_sum_h           TYPE fis_dr_hsl,
        lv_z_sum_s           TYPE fis_dr_hsl.
  DATA lv_count TYPE int2.
*SQL...
*test from ipad
  IF p_park IS INITIAL.
    SELECT FROM
      bkpf
    LEFT OUTER JOIN t001 ON t001~bukrs = bkpf~bukrs
    LEFT OUTER JOIN zi_user AS usnam_name ON usnam_name~bname = bkpf~usnam
    LEFT OUTER JOIN zi_user AS ppnam_name ON ppnam_name~bname = bkpf~ppnam
      FIELDS
      belnr,
      gjahr,
      blart,
      butxt AS bukrs_txt,
      bldat,
      budat,
      xblnr,
      usnam,
      usnam_name~lastname AS usnam_name,
      ppnam,
      ppnam_name~lastname AS ppnam_name
    WHERE bkpf~bukrs IN @rbukrs
      AND gjahr IN @rgjahr
      AND monat IN @s_monat
      AND blart IN @s_blart
      AND belnr IN @rbelnr
      AND ( bstat = '' OR bstat = 'A' OR bstat = 'V' OR bstat = 'U'  OR bstat = 'J')
      AND xreversal  = ''
      AND ppnam IN @s_ppnam
      AND budat IN @s_budat
      AND usnam IN @s_usnam
      INTO TABLE @DATA(lt_bkpf).

    IF sy-subrc <> 0.
      MESSAGE '没有数据' TYPE 'I'.
      EXIT.
    ENDIF.

    SELECT FROM
      i_glaccountlineitem
    INNER JOIN @lt_bkpf AS bkpf_ ON bkpf_~belnr = i_glaccountlineitem~accountingdocument
                                 AND bkpf_~gjahr = i_glaccountlineitem~fiscalyear
    LEFT OUTER JOIN mbew ON mbew~matnr = i_glaccountlineitem~material
                        AND mbew~bwkey = i_glaccountlineitem~companycode
    LEFT OUTER JOIN i_matlvaluationclasstext AS bklas_txt ON bklas_txt~materialvaluationclass = mbew~bklas
                                                         AND bklas_txt~language = '1'
      FIELDS
      accountingdocument,
      ledgergllineitem,
      postingkey,
      glaccount,
      documentitemtext,
      \_costcentertext[ (1) WHERE language = @sy-langu ]-costcentername,
      \_glacctinchartofaccountstext[ (1) WHERE language = @sy-langu ]-glaccountname,
*    \_customer-customername,
      \_customer-organizationbpname1 AS customername,
*    \_supplier-suppliername,
      \_supplier-organizationbpname1 AS suppliername,
*    \_supplier-OrganizationBPName1,
      \_functionalareatext[ (1) WHERE language = @sy-langu ]-functionalareaname,
      debitamountincocodecrcy,
      creditamountincocodecrcy,
      material,
      bklas_txt~materialusabilityprofilename AS bklas_txt,
      \_supplier-sortfield AS suppliershortname,
      orderid
    ORDER BY accountingdocument, ledgergllineitem
    INTO TABLE @DATA(lt_glacctitems)
      .

  ELSE.

    SELECT FROM
      vbkpf
    LEFT OUTER JOIN t001 ON t001~bukrs = vbkpf~bukrs
    LEFT OUTER JOIN zi_user AS usnam_name ON usnam_name~bname = vbkpf~usnam
*    LEFT OUTER JOIN zi_user AS ppnam_name ON ppnam_name~bname = vbkpf~ppnam
      FIELDS
      belnr,
      gjahr,
      blart,
      butxt AS bukrs_txt,
      bldat,
      budat,
      xblnr,
      usnam AS ppnam, "for parked documnent, the user name is parked user name
      usnam_name~lastname AS ppnam_name
*      ppnam,
*      ppnam_name~lastname AS ppnam_name
    WHERE vbkpf~bukrs IN @rbukrs
      AND gjahr IN @rgjahr
      AND monat IN @s_monat
      AND blart IN @s_blart
      AND belnr IN @rbelnr
      AND ( bstat = '' OR bstat = 'A' OR bstat = 'V' OR bstat = 'U'  OR bstat = 'J')
*      AND xreversal  = ''
*      AND ppnam IN @s_ppnam
      AND budat IN @s_budat
      AND usnam IN @s_ppnam
      INTO TABLE @DATA(lt_bkpf_temp).

    IF sy-subrc <> 0.
      MESSAGE '没有数据' TYPE 'I'.
      EXIT.
    ENDIF.


    SELECT i~belnr AS accountingdocument,
           i~bzkey AS ledgergllineitem,
           i~bschl AS postingkey,
           i~saknr AS glaccount,
      "glaccountname
           i~sgtxt AS documentitemtext,
           i~kostl AS costcenter,"costcenter
      "costcentername
           i~matnr AS material,"material
           "i~KUNNR as customer" customer
      "customername
           "i~LIFNR as vendor
      "vendorname
      "suppliershortname
           i~fkber AS functionalarea,"function area
      "functionalareaname
      i~dmbtr,
      i~shkzg,
      i~xnegp,
      "debitamountincocodecrcy
      "creditamountincocodecrcy
           i~aufnr AS orderid"order id
        FROM  vbkpf AS a
       INNER JOIN vbsegs AS i ON a~ausbk = i~ausbk
                             AND a~belnr = i~belnr
                             AND a~gjahr = i~gjahr
     WHERE a~bukrs IN @rbukrs
        AND a~gjahr IN @rgjahr
        AND a~monat IN @s_monat
        AND a~blart IN @s_blart
        AND a~belnr IN @rbelnr
        AND ( bstat = '' OR bstat = 'A' OR bstat = 'V' OR bstat = 'U'  OR bstat = 'J')
        "AND xreversal  = ''
        "AND ppnam IN @s_ppnam
        AND budat IN @s_budat
        AND usnam IN @s_ppnam
        ORDER BY i~belnr, i~gjahr
     INTO CORRESPONDING FIELDS OF TABLE @lt_document_parked_temp
      .

    APPEND LINES OF lt_document_parked_temp TO lt_document_parked_all.
    CLEAR:lt_document_parked_temp.

    SELECT i~belnr AS accountingdocument,
           i~bzkey AS ledgergllineitem,
           i~bschl AS postingkey,
           i~hkont AS glaccount,
      "glaccountname
           i~sgtxt AS documentitemtext,
*           i~kostl AS costcenter,"costcenter
      "costcentername
*           i~matnr AS material,"material
           i~kunnr AS customer," customer
      "customername
           "i~LIFNR as vendor
      "vendorname
      "suppliershortname
           i~fkber AS functionalarea,"function area
      "functionalareaname
      i~dmbtr,
      i~shkzg,
      i~xnegp
      "debitamountincocodecrcy
      "creditamountincocodecrcy
       "    i~aufnr AS orderid"order id
        FROM  vbkpf AS a
       INNER JOIN vbsegd AS i ON a~ausbk = i~ausbk
                             AND a~belnr = i~belnr
                             AND a~gjahr = i~gjahr
     WHERE a~bukrs IN @rbukrs
        AND a~gjahr IN @rgjahr
        AND a~monat IN @s_monat
        AND a~blart IN @s_blart
        AND a~belnr IN @rbelnr
        AND ( bstat = '' OR bstat = 'A' OR bstat = 'V' OR bstat = 'U'  OR bstat = 'J')
        "AND xreversal  = ''
        "AND ppnam IN @s_ppnam
        AND budat IN @s_budat
        AND usnam IN @s_ppnam
        ORDER BY i~belnr, i~gjahr
     INTO CORRESPONDING FIELDS OF TABLE @lt_document_parked_temp
      .

    APPEND LINES OF lt_document_parked_temp TO lt_document_parked_all.
    CLEAR:lt_document_parked_temp.

    SELECT i~belnr AS accountingdocument,
           i~bzkey AS ledgergllineitem,
           i~bschl AS postingkey,
           i~hkont AS glaccount,
      "glaccountname
           i~sgtxt AS documentitemtext,
*           i~kostl AS costcenter,"costcenter
      "costcentername
*           i~matnr AS material,"material
*           i~KUNNR as customer," customer
      "customername
           i~lifnr AS vendor,
      "vendorname
      "suppliershortname
           i~fkber AS functionalarea,"function area
      "functionalareaname
      i~dmbtr,
      i~shkzg,
      i~xnegp
      "debitamountincocodecrcy
      "creditamountincocodecrcy
*           i~aufnr AS orderid"order id
        FROM  vbkpf AS a
       INNER JOIN vbsegk AS i ON a~ausbk = i~ausbk
                             AND a~belnr = i~belnr
                             AND a~gjahr = i~gjahr
     WHERE a~bukrs IN @rbukrs
        AND a~gjahr IN @rgjahr
        AND a~monat IN @s_monat
        AND a~blart IN @s_blart
        AND a~belnr IN @rbelnr
        AND ( bstat = '' OR bstat = 'A' OR bstat = 'V' OR bstat = 'U'  OR bstat = 'J')
        "AND xreversal  = ''
        "AND ppnam IN @s_ppnam
        AND budat IN @s_budat
        AND usnam IN @s_ppnam
        ORDER BY i~belnr, i~gjahr
     INTO CORRESPONDING FIELDS OF TABLE @lt_document_parked_temp
      .

    APPEND LINES OF lt_document_parked_temp TO lt_document_parked_all.
    CLEAR:lt_document_parked_temp.

    SELECT i~belnr AS accountingdocument,
     i~bzkey AS ledgergllineitem,
     i~bschl AS postingkey,
     i~hkont AS glaccount,
"glaccountname
     i~sgtxt AS documentitemtext,
     i~kostl AS costcenter,"costcenter
"costcentername
     i~matnr AS material,"material
*           i~KUNNR as customer," customer
"customername
*     i~lifnr AS vendor,
"vendorname
"suppliershortname
     i~fkber AS functionalarea,"function area
"functionalareaname
     i~dmbtr,
     i~shkzg,
      i~xnegp
"debitamountincocodecrcy
"creditamountincocodecrcy
*           i~aufnr AS orderid"order id
  FROM  vbkpf AS a
      INNER JOIN vbsega AS i ON a~ausbk = i~ausbk
                       AND a~belnr = i~belnr
                       AND a~gjahr = i~gjahr
        WHERE a~bukrs IN @rbukrs
          AND a~gjahr IN @rgjahr
          AND a~monat IN @s_monat
          AND a~blart IN @s_blart
          AND a~belnr IN @rbelnr
          AND ( bstat = '' OR bstat = 'A' OR bstat = 'V' OR bstat = 'U'  OR bstat = 'J')
  "AND xreversal  = ''
  "AND ppnam IN @s_ppnam
          AND budat IN @s_budat
          AND usnam IN @s_ppnam
         ORDER BY i~belnr, i~gjahr
        INTO CORRESPONDING FIELDS OF TABLE @lt_document_parked_temp
.

    APPEND LINES OF lt_document_parked_temp TO lt_document_parked_all.
    CLEAR:lt_document_parked_temp.
*    APPEND LINES OF lt_bkpf_temp TO lt_bkpf.
    MOVE-CORRESPONDING lt_bkpf_temp TO lt_bkpf.
*    lt_bkpf = #(lt_bkpf_temp)

    DATA ls_glacctitem LIKE LINE OF lt_glacctitems.
    LOOP AT lt_document_parked_all ASSIGNING FIELD-SYMBOL(<fs_document>).
      IF <fs_document>-glaccount IS NOT INITIAL.
        SELECT SINGLE txt20 FROM skat
          INTO <fs_document>-glaccountname
          WHERE spras = '1'
           AND  ktopl = 'ZJYY'
           AND  saknr = <fs_document>-glaccount.
      ENDIF.

      IF <fs_document>-costcenter IS NOT INITIAL.
        SELECT SINGLE ktext FROM cskt
          INTO <fs_document>-costcentername
          WHERE spras = '1'
           AND  kokrs = '8000'
           AND  kostl = <fs_document>-costcenter
           AND datbi >= sy-datum .

        IF <fs_document>-functionalarea IS INITIAL.
          SELECT SINGLE func_area FROM csks
            INTO <fs_document>-functionalarea
            WHERE kokrs = '8000'
             AND  kostl = <fs_document>-costcenter
             AND datbi >= sy-datum.
        ENDIF.
      ENDIF.

      IF <fs_document>-customer IS NOT INITIAL.
        SELECT SINGLE name1 FROM kna1
          INTO <fs_document>-customername
          WHERE kunnr = <fs_document>-customer.
      ENDIF.

      IF <fs_document>-vendor IS NOT INITIAL.
        SELECT SINGLE name1,sortl FROM lfa1
          INTO ( @<fs_document>-vendorname , @<fs_document>-suppliershortname )
          WHERE lifnr = @<fs_document>-vendor.
      ENDIF.

      IF <fs_document>-functionalarea IS NOT INITIAL.
        SELECT SINGLE fkbtx FROM tfkbt
          INTO @<fs_document>-functionalareaname
          WHERE spras = '1'
            AND fkber = @<fs_document>-functionalarea.
        "functionalareaname
      ENDIF.

      IF <fs_document>-xnegp IS INITIAL.
        IF <fs_document>-shkzg = 'S'."debit
          <fs_document>-debitamountincocodecrcy = <fs_document>-dmbtr.
        ELSEIF <fs_document>-shkzg = 'H'."credit
          <fs_document>-creditamountincocodecrcy = <fs_document>-dmbtr.
        ENDIF.
      ELSE.
        IF <fs_document>-shkzg = 'S'."debit
          <fs_document>-creditamountincocodecrcy = -1 * <fs_document>-dmbtr .
        ELSEIF <fs_document>-shkzg = 'H'."credit
          <fs_document>-debitamountincocodecrcy = -1 * <fs_document>-dmbtr.
        ENDIF.
      ENDIF.

      MOVE-CORRESPONDING <fs_document> TO ls_glacctitem.
      APPEND ls_glacctitem TO lt_glacctitems.
    ENDLOOP.

  ENDIF.

  SORT lt_bkpf BY belnr.
  SORT lt_glacctitems BY accountingdocument ledgergllineitem.

  lv_count = 0.
*  DATA(lv_count) = 0.
  LOOP AT lt_bkpf INTO DATA(ls_bkpf).
    lv_count += 1.

    APPEND INITIAL LINE TO lt_pages REFERENCE INTO DATA(lr_page).
    MOVE-CORRESPONDING ls_bkpf TO lr_page->header.
    lr_page->header-seqno = lv_count.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input  = lr_page->header-belnr
      IMPORTING
        output = lr_page->header-belnr.

    lr_page->header-belnr = ls_bkpf-blart  && lr_page->header-belnr.
    lr_page->header-usnam = ls_bkpf-usnam_name.
    lr_page->header-ppnam = ls_bkpf-ppnam_name.

    CLEAR: lv_sgtxt, lv_suppliershortname, lv_z_sum_h, lv_z_sum_s.
    LOOP AT lt_glacctitems INTO ls_glacctitem WHERE accountingdocument = ls_bkpf-belnr.
      APPEND INITIAL LINE TO lr_page->items REFERENCE INTO DATA(lr_item).

     "lr_item->sgtxt = ls_glacctitem-documentitemtext.
      lr_item->sgtxt = ls_glacctitem-documentitemtext+0(18).
*      IF ls_glacctitem-material IS NOT INITIAL.
*        lv_sgtxt = |购{ ls_glacctitem-bklas_txt }（发票：{ ls_bkpf-xblnr }）|.
*      ENDIF.
      IF ls_glacctitem-suppliershortname IS NOT INITIAL.
        lv_suppliershortname = ls_glacctitem-suppliershortname.
      ENDIF.

*      IF ls_bkpf-blart = 'KZ'.
*        CASE ls_glacctitem-postingkey.
*          WHEN '50'.
*            lr_item->sgtxt = '50'.
*          WHEN '36'.
*            lr_item->sgtxt = '36'.
*          WHEN '25'.
*            lr_item->sgtxt = '25'.
*        ENDCASE.
*      ENDIF.

*      IF ls_glacctitem-customername IS NOT INITIAL.
      IF ls_glacctitem-customername IS NOT INITIAL.
        lr_item->z_acct = |{ ls_glacctitem-glaccountname }（{ ls_glacctitem-glaccount }） {
        "ls_glacctitem-customername
        ls_glacctitem-customername
        }|.
      ELSEIF ls_glacctitem-suppliername IS NOT INITIAL.
        lr_item->z_acct = |{ ls_glacctitem-glaccountname }（{ ls_glacctitem-glaccount }） { ls_glacctitem-suppliername }|.
      ELSE.
        lr_item->z_acct = |{ ls_glacctitem-glaccountname }（{ ls_glacctitem-glaccount }）|.
      ENDIF.
      IF ls_glacctitem-functionalareaname IS NOT INITIAL.
        lr_item->z_acct = lr_item->z_acct && '/' && ls_glacctitem-functionalareaname && '/' && ls_glacctitem-costcentername.
      ENDIF.
      IF p_chk = 'X'.
        lr_item->z_acct = lr_item->z_acct && '　' && ls_glacctitem-functionalareaname && '　' && ls_glacctitem-orderid.
      ENDIF.
      IF ls_glacctitem-creditamountincocodecrcy <> 0.
        IF p_park IS INITIAL.
          lr_item->value_h =   -1 * ls_glacctitem-creditamountincocodecrcy .
        ELSE.
          lr_item->value_h =   ls_glacctitem-creditamountincocodecrcy.
        ENDIF.
        lr_item->dmbtr_h = |{ lr_item->value_h NUMBER = USER }|.
      ENDIF.
      IF ls_glacctitem-debitamountincocodecrcy <> 0.
        lr_item->value_s = ls_glacctitem-debitamountincocodecrcy .
        lr_item->dmbtr_s = |{ lr_item->value_s  NUMBER = USER }|.
      ENDIF.

*      ADD ls_glacctitem-creditamountincocodecrcy TO lv_z_sum_h.
*      ADD ls_glacctitem-debitamountincocodecrcy TO lv_z_sum_s.

    ENDLOOP.

*    IF ls_bkpf-blart = 'RE'.
*      LOOP AT lr_page->items REFERENCE INTO lr_item.
*        lr_item->sgtxt = |{ lv_sgtxt }（{ lv_suppliershortname }）|.
*      ENDLOOP.
*    ELSEIF ls_bkpf-blart = 'KZ'.
*      LOOP AT lr_page->items REFERENCE INTO lr_item.
*        CASE lr_item->sgtxt.
*          WHEN '50'.
*            lr_item->sgtxt = |支付货款 （{ lv_suppliershortname }）|.
*          WHEN '36'.
*            lr_item->sgtxt = |剩余货款 （{ lv_suppliershortname }）|.
*          WHEN '25'.
*            lr_item->sgtxt = |核销付款 （{ lv_suppliershortname }）|.
*        ENDCASE.
*      ENDLOOP.
*    ENDIF.

*    lr_page->header-z_total = lcl_utils=>spell_amount( abs( lv_z_sum_s ) ).
*    lr_page->header-z_sum_h = |{ abs( lv_z_sum_h ) NUMBER = USER }|.
*    lr_page->header-z_sum_s = |{ lv_z_sum_s NUMBER = USER }|.

  ENDLOOP.

  "分拆页数
  DATA lv_total_page TYPE p DECIMALS 2.
  DATA lv_lines      TYPE int2.
  DATA lc_maxline    TYPE int2 VALUE '6'.
  DATA lv_curr_page  TYPE int2.
  DATA lt_pages_disp TYPE ztt_pdf_fi_doc.
  DATA lv_hsl TYPE acdoca-hsl.

  LOOP AT lt_pages INTO DATA(ls_page).
    CLEAR:  lv_total_page,lv_curr_page, lv_z_sum_h,lv_z_sum_s.
    lv_lines = lines( ls_page-items ).
    lv_total_page = ceil( lv_lines    / lc_maxline ).
*    ls_page-header-pages_t = lv_total_page.

    LOOP AT ls_page-items INTO DATA(ls_item).
      IF sy-tabix MOD lc_maxline = 1.
        lv_curr_page = lv_curr_page + 1.
        APPEND INITIAL LINE TO lt_pages_disp REFERENCE INTO lr_page.
        MOVE-CORRESPONDING ls_page-header TO lr_page->header.
        lr_page->header-pages_c = lv_curr_page.
        lr_page->header-pages_t = lv_total_page.
      ENDIF.

      lv_z_sum_h =  lv_z_sum_h +  ls_item-value_h .
      lv_z_sum_s = lv_z_sum_s +  ls_item-value_s .


      lr_page->header-z_total = lcl_utils=>spell_amount( abs( lv_z_sum_s ) ).
      lr_page->header-z_sum_h = |{ abs( lv_z_sum_h ) NUMBER = USER }|.
      lr_page->header-z_sum_s = |{ lv_z_sum_s NUMBER = USER }|.

      APPEND ls_item TO lr_page->items.
    ENDLOOP.
  ENDLOOP.


* Determine PDF function module for Certificate of guarantee
  CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
    EXPORTING
      i_name     = 'ZAF_FI_DOCUMENT'
    IMPORTING
      e_funcname = lv_fm_name
*     E_INTERFACE_TYPE           =
    .

  CALL FUNCTION 'FP_JOB_OPEN'
    CHANGING
      ie_outputparams = ls_output_param
    EXCEPTIONS
      cancel          = 1
      usage_error     = 2
      system_error    = 3
      internal_error  = 4
      OTHERS          = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  ls_doc_param-langu = sy-langu.
* Calling the function module and passing the form interface values
  CALL FUNCTION lv_fm_name
    EXPORTING
      /1bcdwb/docparams = ls_doc_param
*     pages             = lt_pages
      pages             = lt_pages_disp
* IMPORTING
*     /1BCDWB/FORMOUTPUT       =
    EXCEPTIONS
      usage_error       = 1
      system_error      = 2
      internal_error    = 3
      OTHERS            = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

* Close spool job
  CALL FUNCTION 'FP_JOB_CLOSE'
*   IMPORTING
*     E_RESULT             = result
    EXCEPTIONS
      usage_error    = 1
      system_error   = 2
      internal_error = 3
      OTHERS         = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.



CLASS lcl_utils IMPLEMENTATION.
  METHOD spell_amount.
    IF iv_money = 0.
      rv_money = '零'.
      EXIT.
    ENDIF.
    DATA:money_str(33).
    money_str = iv_money.
    CONDENSE money_str NO-GAPS.
    IF money_str CN '-0123456789. '.
      ASSERT 1 = 2.
    ENDIF.
    DATA:i TYPE i.
    IF money_str CS '.'.
      i = sy-fdpos + 1.
      money_str+sy-fdpos = money_str+i.
    ENDIF.
    CONDENSE money_str NO-GAPS.
    DATA:units_off TYPE i,
         curnt_off TYPE i.
    DATA:lastd  TYPE n,curntd TYPE n.
    DATA:cword(2),weight(2).
    DATA:units(30) VALUE '分角元拾佰仟万拾佰仟亿拾佰仟万',
         digts(20) VALUE '零壹贰叁肆伍陆柒捌玖'.
* clear:rv_money,units_off.
    lastd = 0.
    curnt_off = strlen( money_str ) - 1.
    WHILE curnt_off >= 0.
      curntd = money_str+curnt_off(1).
      i = curntd.
      cword = digts+i(1).
      weight = units+units_off(1).
      i = units_off / 1.
      IF curntd = 0.             "Current digit is 0
        IF i = 2 OR i = 6 OR i = 10.
          CLEAR:cword.
          IF curnt_off = 0.
            CLEAR:weight.
          ENDIF.
        ELSEIF lastd = 0.
          CLEAR:cword,weight.
        ELSE.
          CLEAR:weight.
        ENDIF.
      ENDIF.
      CONCATENATE cword weight rv_money INTO rv_money.
      lastd = curntd.
      SUBTRACT 1 FROM curnt_off.
      ADD 1 TO units_off.
    ENDWHILE.
    IF rv_money NS '分'.
      CONCATENATE rv_money '整' INTO rv_money.
    ELSE.
      cword = rv_money.
      IF cword = '零'.
        SHIFT rv_money BY 1 PLACES.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
