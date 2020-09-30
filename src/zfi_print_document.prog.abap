*&---------------------------------------------------------------------*
*& Report ZFI_PRINT_DOCUMENT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zfi_print_document.

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
  SELECT-OPTIONS: rbukrs   FOR  bkorm-bukrs NO INTERVALS NO-EXTENSION,
                  rkoart   FOR  bkorm-koart NO-DISPLAY,
                  rkonto   FOR  bkorm-konto NO-DISPLAY,
                  rbelnr   FOR  bkorm-belnr NO INTERVALS NO-EXTENSION,
                  rgjahr   FOR  bkorm-gjahr NO INTERVALS NO-EXTENSION.

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
SELECTION-SCREEN END OF BLOCK 4.


START-OF-SELECTION.
  DATA: lv_fm_name      TYPE funcname,
        ls_output_param TYPE sfpoutputparams,
        ls_doc_param    TYPE sfpdocparams,
        lt_items        TYPE ztt_pdf_fi_doc_itm,
        ls_header       TYPE zst_pdf_fi_doc_hd.


*SQL...


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
      it_items          = lt_items
      is_header         = ls_header
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
