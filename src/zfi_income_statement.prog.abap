*&---------------------------------------------------------------------*
*& Report ZFI_INCOME_STATEMENT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zfi_income_statement.

TYPE-POOLS: vrm.
INCLUDE ole2incl.

DATA: o_excel           TYPE ole2_object,
      o_workbook        TYPE ole2_object,
      o_sheet           TYPE ole2_object,
      o_shapes          TYPE ole2_object,
      o_cells           TYPE ole2_object,
      o_selection       TYPE ole2_object, "Selection
      o_range           TYPE ole2_object , "Selection
      o_picture         TYPE ole2_object,
      o_application     TYPE ole2_object, "Application
      gc_save_file_name TYPE string VALUE '利润表'.

INCLUDE zexcel_outputopt_incl.

DATA: gv_FromPostingDate TYPE fis_budat_from,
      gv_ToPostingDate   TYPE fis_budat_to.

SELECTION-SCREEN BEGIN OF BLOCK bk1 WITH FRAME TITLE TEXT-100.
  PARAMETERS: p_bukrs TYPE bukrs,
              p_gjahr TYPE gjahr,
              p_monat TYPE monat AS LISTBOX VISIBLE LENGTH 4.
SELECTION-SCREEN END OF BLOCK bk1.


INITIALIZATION.
  MESSAGE '该事务码已经作废，请使用事务码ZFI011N' TYPE 'A'.
  PERFORM setup_listboxes.


START-OF-SELECTION.

  gv_FromPostingDate = p_gjahr && p_monat && '01'.
  CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
    EXPORTING
      day_in            = gv_FromPostingDate
    IMPORTING
      last_day_of_month = gv_ToPostingDate.

  DATA(lv_output_date) = gv_ToPostingDate.

  SELECT FROM
    ZI_GLAcctBalance_inIS( P_FromPostingDate = @gv_FromPostingDate, P_ToPostingDate = @gv_ToPostingDate )
  FIELDS
    CompanyCode,
    FiscalYear,
    row1,
    SUM( row_02 ) AS row_02,
    SUM( row_03 ) AS row_03,
    SUM( row_05 ) AS row_05,
    SUM( row_06 ) AS row_06,
    SUM( row_07 ) AS row_07,
    SUM( row_08 ) AS row_08,
    SUM( row_09 ) AS row_09,
    SUM( row_10 ) AS row_10,
    SUM( row_11 ) AS row_11,
    SUM( row_11 ) AS row_12,
    SUM( row_13 ) AS row_13,
    SUM( row_14 ) AS row_14,
    SUM( row_15 ) AS row_15,
    SUM( row_17 ) AS row_17,
    SUM( row_18 ) AS row_18,
    SUM( row_19 ) AS row_19,
    SUM( row_21 ) AS row_21,
    SUM( row_22 ) AS row_22,
    SUM( row_24 ) AS row_24
  WHERE
    CompanyCode = @p_bukrs AND
    FiscalYear = @p_gjahr
  GROUP BY
    CompanyCode,
    FiscalYear,
    row1
  INTO TABLE @DATA(gt_data_curr).

  IF sy-subrc <> 0.
*    MESSAGE '没有数据' TYPE 'I'.
*    EXIT.
*    APPEND INITIAL LINE TO gt_data_curr.
*    APPEND INITIAL LINE TO gt_data_curr.
  ENDIF.


  p_gjahr -= 1.
  gv_FromPostingDate = p_gjahr && p_monat && '01'.
  CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
    EXPORTING
      day_in            = gv_FromPostingDate
    IMPORTING
      last_day_of_month = gv_ToPostingDate.

  SELECT FROM
    ZI_GLAcctBalance_inIS( P_FromPostingDate = @gv_FromPostingDate, P_ToPostingDate = @gv_ToPostingDate )
  FIELDS
    CompanyCode,
    FiscalYear,
    SUM( row_02 ) AS row_02,
    SUM( row_03 ) AS row_03,
    SUM( row_05 ) AS row_05,
    SUM( row_06 ) AS row_06,
    SUM( row_07 ) AS row_07,
    SUM( row_08 ) AS row_08,
    SUM( row_09 ) AS row_09,
    SUM( row_10 ) AS row_10,
    SUM( row_11 ) AS row_11,
    SUM( row_11 ) AS row_12,
    SUM( row_13 ) AS row_13,
    SUM( row_14 ) AS row_14,
    SUM( row_15 ) AS row_15,
    SUM( row_17 ) AS row_17,
    SUM( row_18 ) AS row_18,
    SUM( row_19 ) AS row_19,
    SUM( row_21 ) AS row_21,
    SUM( row_22 ) AS row_22,
    SUM( row_24 ) AS row_24
  WHERE
    CompanyCode = @p_bukrs AND
    FiscalYear = @p_gjahr
  GROUP BY
    CompanyCode,
    FiscalYear,
    row1
  INTO TABLE @DATA(gt_data_prev).

  IF sy-subrc <> 0.
*      MESSAGE '没有数据' TYPE 'I'.
*      EXIT.
*    APPEND INITIAL LINE TO gt_data_prev.
*    APPEND INITIAL LINE TO gt_data_prev.
  ENDIF.



  PERFORM output_excel.



FORM output_excel.
  DATA: filename        TYPE localfile,
        ls_wwwdata_item LIKE wwwdatatab,
        lv_num(2)       TYPE n,
        lv_row          TYPE i,
        lv_col          TYPE i.

  filename = p_path.
* Add trailing "\" or "/"
  IF filename CA '/'.
    REPLACE REGEX '([^/])\s*$' IN filename WITH '$1/' .
  ELSE.
    REPLACE REGEX '([^\\])\s*$' IN filename WITH '$1\\'.
  ENDIF.

  CONCATENATE filename gc_save_file_name '-' p_gjahr p_monat '.xlsx' INTO filename.

  SELECT SINGLE * FROM wwwdata
                  INTO CORRESPONDING FIELDS OF ls_wwwdata_item
                  WHERE objid = 'ZTEMP_INCOME_STATEMENT' .

  CALL FUNCTION 'DOWNLOAD_WEB_OBJECT' "
    EXPORTING
      key         = ls_wwwdata_item
      destination = filename.


  IF o_excel-header = space OR o_excel-handle = -1.
    CREATE OBJECT o_excel 'EXCEL.APPLICATION'.
    SET PROPERTY OF o_excel 'Visible' = 0.
  ENDIF.

  CALL METHOD OF o_excel 'WORKBOOKS' = o_workbook.
  CALL METHOD OF o_workbook 'OPEN'
    EXPORTING
      #1 = filename.
  CALL METHOD OF o_excel 'WORKSHEETS' = o_sheet
    EXPORTING
    #1 = 1.

  CALL METHOD OF o_sheet 'ACTIVATE'.

  DATA(lv_date_str) = |{ lv_output_date DATE = ISO }|.
  CALL METHOD OF o_excel 'cells' = o_cells
    EXPORTING #1 = 2
              #2 = 2.
  SET PROPERTY OF o_cells 'value' = lv_date_str.

  DATA(gs_data_curr) = VALUE #( gt_data_curr[ 1 ] OPTIONAL ).
  DATA(gs_data_prev) = VALUE #( gt_data_prev[ 1 ] OPTIONAL ).
  DO 39 TIMES.
    lv_num += 1.
    DATA(lv_fldnm) = 'ROW_' && lv_num.

    ASSIGN COMPONENT lv_fldnm OF STRUCTURE gs_data_curr TO FIELD-SYMBOL(<fs_value>).
    IF sy-subrc = 0.
      lv_row = lv_num + 4.
      lv_col = 5.
      IF lv_row = 6 OR lv_row = 7 OR lv_row = 18 OR lv_row = 19 OR lv_row = 21 OR lv_row = 22 OR lv_row = 23 OR lv_row = 25.
        <fs_value> = <fs_value> * ( -1 ).
        CALL METHOD OF o_excel 'cells' = o_cells
       EXPORTING #1 = lv_row
                 #2 = lv_col.
        SET PROPERTY OF o_cells 'value' = <fs_value>.
      ELSE .
        CALL METHOD OF o_excel 'cells' = o_cells
  EXPORTING #1 = lv_row
            #2 = lv_col.
        SET PROPERTY OF o_cells 'value' = <fs_value>.
      ENDIF.
    ENDIF.

    ASSIGN COMPONENT lv_fldnm OF STRUCTURE gs_data_prev TO <fs_value>.
    IF sy-subrc = 0.
      lv_row = lv_num + 4.
      lv_col = 7.
       IF lv_row = 6 OR lv_row = 7 OR lv_row = 18 OR lv_row = 19 OR lv_row = 21 OR lv_row = 22 OR lv_row = 23 OR lv_row = 25.
        <fs_value> = <fs_value> * ( -1 ).
        CALL METHOD OF o_excel 'cells' = o_cells
          EXPORTING #1 = lv_row
                    #2 = lv_col.
        SET PROPERTY OF o_cells 'value' = <fs_value>.
      ELSE.
        CALL METHOD OF o_excel 'cells' = o_cells
  EXPORTING #1 = lv_row
            #2 = lv_col.
        SET PROPERTY OF o_cells 'value' = <fs_value>.
      ENDIF.
    ENDIF.
  ENDDO.

  CLEAR lv_num.
  DATA(gs_data_currmonth) = VALUE #( gt_data_curr[ 2 ] OPTIONAL ).
  DATA(gs_data_prevmonth) = VALUE #( gt_data_prev[ 2 ] OPTIONAL ).
  DO 39 TIMES.
    lv_num += 1.
    DATA(lv_fldnm1) = 'ROW_' && lv_num.

    ASSIGN COMPONENT lv_fldnm1 OF STRUCTURE gs_data_currmonth TO FIELD-SYMBOL(<fs_value1>).
    IF sy-subrc = 0.
      lv_row = lv_num + 4.
      lv_col = 4.
      IF lv_row = 6 OR lv_row = 7 OR lv_row = 18 OR lv_row = 19 OR lv_row = 21 OR lv_row = 22 OR lv_row = 23 OR lv_row = 25.
        <fs_value1> = <fs_value1> * ( -1 ).
        CALL METHOD OF o_excel 'cells' = o_cells
          EXPORTING #1 = lv_row
                    #2 = lv_col.
        SET PROPERTY OF o_cells 'value' = <fs_value1>.
      ELSE.
        CALL METHOD OF o_excel 'cells' = o_cells
          EXPORTING #1 = lv_row
                    #2 = lv_col.
        SET PROPERTY OF o_cells 'value' = <fs_value1>.
      ENDIF.
    ENDIF.

    ASSIGN COMPONENT lv_fldnm1 OF STRUCTURE gs_data_prevmonth TO <fs_value1>.
    IF sy-subrc = 0.
      lv_row = lv_num + 4.
      lv_col = 6.
      IF lv_row = 6 OR lv_row = 7 OR lv_row = 18 OR lv_row = 19 OR lv_row = 21 OR lv_row = 22 OR lv_row = 23 OR lv_row = 25.
        <fs_value1> = <fs_value1> * ( -1 ).
        CALL METHOD OF o_excel 'cells' = o_cells
          EXPORTING #1 = lv_row
                    #2 = lv_col.
        SET PROPERTY OF o_cells 'value' = <fs_value1>.
      ELSE.
        CALL METHOD OF o_excel 'cells' = o_cells
  EXPORTING #1 = lv_row
            #2 = lv_col.
        SET PROPERTY OF o_cells 'value' = <fs_value1>.
      ENDIF.
    ENDIF.
  ENDDO.

  GET PROPERTY OF o_excel 'ActiveWorkbook' = o_workbook.
  CALL METHOD OF o_workbook 'Save'.
  CALL METHOD OF o_workbook 'CLOSE'.
  FREE o_sheet.
  FREE o_workbook.

  IF o_excel-handle <> -1.
    CALL METHOD OF o_excel 'Quit'.
    FREE OBJECT o_excel.
  ENDIF.

  MESSAGE '下载成功' TYPE 'I'.

ENDFORM.

FORM setup_listboxes.
  DATA: lv_id     TYPE vrm_id,
        lt_values TYPE vrm_values.

  lv_id = 'P_MONAT'.
  lt_values = VALUE #( FOR i = 1 THEN i + 1 WHILE i < 13
                        ( key = i text = i ) ).

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id              = lv_id
      values          = lt_values
    EXCEPTIONS
      id_illegal_name = 1
      OTHERS          = 2.

ENDFORM.
