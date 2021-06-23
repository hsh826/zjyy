*&---------------------------------------------------------------------*
*& Report ZFI_BALANCE_SHEET
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zfi_balance_sheet.

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
      gc_save_file_name TYPE string VALUE '资产负债表'.

INCLUDE zexcel_outputopt_incl.

DATA: gv_frompostingdate TYPE fis_budat_from,
      gv_topostingdate   TYPE fis_budat_to.

SELECTION-SCREEN BEGIN OF BLOCK bk1 WITH FRAME TITLE TEXT-100.
  PARAMETERS: p_bukrs TYPE bukrs,
              p_gjahr TYPE gjahr,
              p_monat TYPE monat AS LISTBOX VISIBLE LENGTH 4.
SELECTION-SCREEN END OF BLOCK bk1.


INITIALIZATION.
  MESSAGE '当前事务码作废，请使用事务码ZFI009N' TYPE 'A'.
  PERFORM setup_listboxes.


START-OF-SELECTION.

  gv_frompostingdate = p_gjahr && p_monat && '01'.

  CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
    EXPORTING
      day_in            = gv_frompostingdate
    IMPORTING
      last_day_of_month = gv_topostingdate.

  DATA(lv_output_date) = gv_topostingdate.

  DATA(lv_period) = p_monat.

  IF p_monat = '12'.
    lv_period = '16'."last period of the year
  ENDIF.

  SELECT FROM
    zi_glacctbalance_inbs( p_frompostingdate = @gv_frompostingdate, p_topostingdate = @gv_topostingdate )
  FIELDS
    companycode,
    fiscalyear,
    SUM( row_02 ) AS row_02,
    SUM( row_03 ) AS row_03,
    SUM( row_05 ) AS row_05,
    SUM( row_06 ) AS row_06,
    SUM( row_07 ) AS row_07,
    SUM( row_08 ) AS row_08,
    SUM( row_09 ) AS row_09,
    SUM( row_12 ) AS row_12,
    SUM( row_18 ) AS row_18,
    SUM( row_19 ) AS row_19,
    SUM( row_20 ) AS row_20,
    SUM( row_21 ) AS row_21,
    SUM( row_24 ) AS row_24,
    SUM( row_27 ) AS row_27,
    SUM( row_40 ) AS row_40,
    SUM( row_43 ) AS row_43,
    SUM( row_44 ) AS row_44,
    SUM( row_45 ) AS row_45,
    SUM( row_46 ) AS row_46,
    SUM( row_47 ) AS row_47,
    SUM( row_48 ) AS row_48,
    SUM( row_51 ) AS row_51,
    SUM( row_54 ) AS row_54,
    SUM( row_59 ) AS row_59,
    SUM( row_66 ) AS row_66,
    SUM( row_70 ) AS row_70,
    SUM( row_73 ) AS row_73,
    SUM( row_74 ) AS row_74
  WHERE
    companycode = @p_bukrs AND
    fiscalyear = @p_gjahr AND
    fiscalperiod = @lv_period
  GROUP BY
    companycode,
    fiscalyear,
    fiscalperiod
  INTO TABLE @DATA(gt_data_end).

  IF sy-subrc <> 0.
*    MESSAGE '没有数据' TYPE 'I'.
*    EXIT.
    APPEND INITIAL LINE TO gt_data_end.
  ENDIF.

*取去年年末余额
*  gv_ToPostingDate = gv_FromPostingDate - 1.
*  gv_FromPostingDate(6) = gv_ToPostingDate(6).
*  gv_FromPostingDate+6(2) = '01'.
  p_gjahr -= 1.
  gv_frompostingdate = p_gjahr && '12' && '01'.
  CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
    EXPORTING
      day_in            = gv_frompostingdate
    IMPORTING
      last_day_of_month = gv_topostingdate.
  SELECT FROM
    zi_glacctbalance_inbs_yearend( p_frompostingdate = @gv_frompostingdate, p_topostingdate = @gv_topostingdate )
  FIELDS
    companycode,
    fiscalyear,
    SUM( row_02 ) AS row_02,
    SUM( row_03 ) AS row_03,
    SUM( row_05 ) AS row_05,
    SUM( row_06 ) AS row_06,
    SUM( row_07 ) AS row_07,
    SUM( row_08 ) AS row_08,
    SUM( row_09 ) AS row_09,
    SUM( row_12 ) AS row_12,
    SUM( row_18 ) AS row_18,
    SUM( row_19 ) AS row_19,
    SUM( row_20 ) AS row_20,
    SUM( row_21 ) AS row_21,
    SUM( row_24 ) AS row_24,
    SUM( row_27 ) AS row_27,
    SUM( row_40 ) AS row_40,
    SUM( row_43 ) AS row_43,
    SUM( row_44 ) AS row_44,
    SUM( row_45 ) AS row_45,
    SUM( row_46 ) AS row_46,
    SUM( row_47 ) AS row_47,
    SUM( row_48 ) AS row_48,
    SUM( row_51 ) AS row_51,
    SUM( row_54 ) AS row_54,
    SUM( row_59 ) AS row_59,
    SUM( row_66 ) AS row_66,
    SUM( row_70 ) AS row_70,
    SUM( row_73 ) AS row_73,
    SUM( row_74 ) AS row_74
  WHERE
    companycode = @p_bukrs AND
    fiscalyear = @p_gjahr AND
    fiscalperiod = '16' ""last period of last year
  GROUP BY
    companycode,
    fiscalyear
  INTO TABLE @DATA(gt_data_int).

  IF sy-subrc <> 0.
*    MESSAGE '没有数据' TYPE 'I'.
*    EXIT.
    APPEND INITIAL LINE TO gt_data_int.
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
                  WHERE objid = 'ZTEMP_BALANCE_SHEET' .

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

  DATA(gs_data_end) = gt_data_end[ 1 ].
  DATA(gs_data_int) = gt_data_int[ 1 ].
  DO 99 TIMES.
    lv_num += 1.
    DATA(lv_fldnm) = 'ROW_' && lv_num.
    ASSIGN COMPONENT lv_fldnm OF STRUCTURE gs_data_end TO FIELD-SYMBOL(<fs_value>).
    IF sy-subrc = 0.
      <fs_value> = abs( <fs_value> ).
      IF lv_num LE 38.
        lv_row = lv_num + 4.
        lv_col = 4.
      ELSE.
        lv_row = lv_num - 34.
        lv_col = 8.
      ENDIF.
      CALL METHOD OF o_excel 'cells' = o_cells
        EXPORTING #1 = lv_row
                  #2 = lv_col.
      SET PROPERTY OF o_cells 'value' = <fs_value>.
    ENDIF.
    IF sy-subrc = 4
      AND lv_num NE 13
      AND lv_num NE 30
      AND lv_num NE 38
      AND lv_num NE 52
      AND lv_num NE 63
      AND lv_num NE 64
      AND lv_num NE 75
      AND lv_num NE 76.

      IF lv_num LE 38.
        lv_row = lv_num + 4.
        lv_col = 4.
      ELSEIF lv_num LE 76.
        lv_row = lv_num - 34.
        lv_col = 8.
      ENDIF.
      CALL METHOD OF o_excel 'cells' = o_cells
              EXPORTING #1 = lv_row
                        #2 = lv_col.
      SET PROPERTY OF o_cells 'value' = '0.00'.
      IF lv_row = 5
     OR ( lv_row = 18 AND lv_col BETWEEN 4 AND 5 )
     OR ( lv_row BETWEEN 35 AND 41 AND lv_col BETWEEN 4 AND 5 )
     OR ( lv_row = 19 AND lv_col BETWEEN 8 AND 9 )
     OR ( lv_row = 31 AND lv_col BETWEEN 8 AND 9 ).
        CALL METHOD OF o_excel 'cells' = o_cells
        EXPORTING #1 = lv_row
                  #2 = lv_col.
        SET PROPERTY OF o_cells 'value' = ' '.
      ENDIF.
    ENDIF.

    ASSIGN COMPONENT lv_fldnm OF STRUCTURE gs_data_int TO <fs_value>.
    IF sy-subrc = 0.
      <fs_value> = abs( <fs_value> ).
      IF lv_num LE 38.
        lv_row = lv_num + 4.
        lv_col = 5.
      ELSE.
        lv_row = lv_num - 34.
        lv_col = 9.
      ENDIF.
      CALL METHOD OF o_excel 'cells' = o_cells
        EXPORTING #1 = lv_row
                  #2 = lv_col.
      SET PROPERTY OF o_cells 'value' = <fs_value>.
    ENDIF.
    IF sy-subrc = 4
      AND lv_num NE 13
      AND lv_num NE 30
      AND lv_num NE 38
      AND lv_num NE 52
      AND lv_num NE 63
      AND lv_num NE 64
      AND lv_num NE 75
      AND lv_num NE 76.
      IF lv_num LE 38.
        lv_row = lv_num + 4.
        lv_col = 5.
      ELSEIF lv_num LE 76.
        lv_row = lv_num - 34.
        lv_col = 9.
      ENDIF.
      CALL METHOD OF o_excel 'cells' = o_cells
  EXPORTING #1 = lv_row
           #2 = lv_col.
      SET PROPERTY OF o_cells 'value' = '0.00'.
      IF lv_row = 5
     OR ( lv_row = 18 AND lv_col BETWEEN 4 AND 5 )
     OR ( lv_row BETWEEN 35 AND 41 AND lv_col BETWEEN 4 AND 5 )
     OR ( lv_row = 19 AND lv_col BETWEEN 8 AND 9 )
     OR ( lv_row = 31 AND lv_col BETWEEN 8 AND 9 ).
        CALL METHOD OF o_excel 'cells' = o_cells
        EXPORTING #1 = lv_row
                  #2 = lv_col.
        SET PROPERTY OF o_cells 'value' = ' '.
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
