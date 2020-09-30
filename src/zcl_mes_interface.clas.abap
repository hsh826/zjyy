CLASS zcl_mes_interface DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_DeliveryNotice,
        Code                TYPE char32,
        BillType            TYPE i,
        SourceType          TYPE i,
        CustomerCode        TYPE char32,
        ReceiveAddress      TYPE char255,
        BillDate            TYPE char23,
        DeliveryMethod      TYPE char255,
        Note                TYPE char256,
        TransportorName     TYPE char255,
        TransportorPhoneNun TYPE char255,
        TransportCarNumber  TYPE char255,
        OperateType         TYPE i,
        Recid               TYPE char32,
        Mdfdt               TYPE char23,
        syncflag            TYPE i,
        DataBatchNum        TYPE char50,
      END OF ty_DeliveryNotice,
      ty_t_DeliveryNotice TYPE TABLE OF ty_DeliveryNotice,
      BEGIN OF ty_DeliveryNoticeLine,
        DeliveryNoticeCode TYPE char32,
        SortIndex          TYPE char50,
        RowNo              TYPE char32,
        BatchNumber        TYPE char32,
        ItemCode           TYPE char32,
        UnitSaleMainCode   TYPE char32,
        UnitSaleAuxCode    TYPE char32,
        RateFra            TYPE ze_mes_dec31_6,
        RateNum            TYPE ze_mes_dec31_6,
        Qty                TYPE ze_mes_dec31_6,
        AuxQty             TYPE ze_mes_dec31_6,
        RequiredDate       TYPE char23,
        WareHouseCode      TYPE char32,
        LineSourceType     TYPE char32,
        ProductNote        TYPE char32,
        CustomItemCode     TYPE char255,
        PackageType        TYPE char32,
        Weight             TYPE char64,
        BigNumber          TYPE char64,
        SingerNumber       TYPE char64,
        ProductUnit        TYPE char32,
        StockUnit          TYPE char32,
        Note               TYPE char255,
        SaleOutOrderCode   TYPE char32,
        SaleOutOrderRowNo  TYPE char32,
        OperateType        TYPE i,
        syncflag           TYPE i,
        Mdfdt              TYPE char23,
        DataBatchNum       TYPE char50,
      END OF ty_DeliveryNoticeLine,
      ty_t_DeliveryNoticeLine TYPE TABLE OF ty_DeliveryNoticeLine,

      BEGIN OF ty_BomLine.
*        BomCode     TYPE char32,
*        ProductCode TYPE char32,
*        RoutingCode TYPE char32,
        INCLUDE     TYPE zst_bomline_key.
    TYPES:
        ProcessCode TYPE char32,
        ItemCode    TYPE char32,
        UnitName    TYPE char128,
        UnitCode    TYPE char32,
        Amount      TYPE ze_mes_dec31_6,
        LossRate    TYPE ze_mes_dec31_6,
        SortIndex   TYPE char50,
        Note        TYPE char256,
        BomQty      TYPE ze_mes_dec31_6,
        OperateType TYPE i,
        Mdfdt       TYPE char23,
        syncflag    TYPE i,
      END OF ty_BomLine,
      ty_t_BomLine TYPE STANDARD TABLE OF ty_BomLine WITH EMPTY KEY,

      BEGIN OF ty_ProductBomReplace.
*        ProductCode      TYPE char32,
*        RoutingCode      TYPE char32,
*        BomCode          TYPE char32,
        INCLUDE TYPE zst_productbomreplace_key.
    TYPES:
        ProcessCode      TYPE char32,
        ItemOriginalCode TYPE char32,
        ItemReplaceCode  TYPE char32,
        ReplaceUnitName  TYPE char64,
        ReplaceUnitCode  TYPE char32,
        Amount           TYPE ze_mes_dec31_6,
        SortIndex        TYPE char50,
        Note             TYPE char256,
        OperateType      TYPE i,
        Mdfdt            TYPE char23,
        syncflag         TYPE i,
      END OF ty_ProductBomReplace,
      ty_t_ProductBomReplace TYPE STANDARD TABLE OF ty_ProductBomReplace WITH EMPTY KEY,

      BEGIN OF ty_OutDeliveryOrder,
        Code         TYPE char32,
        PurOrderCode TYPE char32,
        BillType     TYPE i,
        SourceType   TYPE char32,
        SupplyCode   TYPE char32,
        EmpCode      TYPE char32,
        BillDate     TYPE char23,
        Note         TYPE char256,
        OperateType  TYPE i,
        Recid        TYPE char32,
        Mdfdt        TYPE char23,
        syncflag     TYPE i,
        DataBatchNum TYPE char50,
      END OF ty_OutDeliveryOrder,
      ty_t_OutDeliveryOrder TYPE TABLE OF ty_OutDeliveryOrder,
      BEGIN OF ty_OutDeliveryOrderLine,
        OutDeliveryOrderCode TYPE char32,
        SortIndex            TYPE char50,
        RowNo                TYPE char32,
        ItemCode             TYPE char32,
        UnitSaleMainCode     TYPE char32,
        UnitSaleAuxCode      TYPE char32,
        RateFra              TYPE ze_mes_dec31_6,
        RateNum              TYPE ze_mes_dec31_6,
        Qty                  TYPE ze_mes_dec31_6,
        AuxQty               TYPE ze_mes_dec31_6,
        RequiredDate         TYPE char23,
        WareHouseCode        TYPE char32,
        LineSourceType       TYPE char32,
        Note                 TYPE char256,
        LineStat             TYPE i,
        OperateType          TYPE i,
        syncflag             TYPE i,
        Mdfdt                TYPE char23,
        DataBatchNum         TYPE char50,
      END OF ty_OutDeliveryOrderLine,
      ty_t_OutDeliveryOrderLine TYPE TABLE OF ty_OutDeliveryOrderLine.

    CLASS-DATA:
      mo_con TYPE REF TO cl_sql_connection.

    CLASS-METHODS:
      class_constructor,
      Erp_DeliveryNotice
        IMPORTING
                  it_data TYPE ty_t_DeliveryNotice
        RAISING   zcx_mes_interface,
      Erp_DeliveryNoticeLine
        IMPORTING
                  it_data TYPE ty_t_DeliveryNoticeLine
        RAISING   zcx_mes_interface,
      Erp_BomLine
        IMPORTING
                  VALUE(it_data) TYPE ty_t_BomLine
        RAISING   zcx_mes_interface,
      Erp_ProductBomReplace
        IMPORTING
                  VALUE(it_data) TYPE ty_t_ProductBomReplace
        RAISING   zcx_mes_interface,
      Erp_OutDeliveryOrder
        IMPORTING
                  it_data TYPE ty_t_OutDeliveryOrder
        RAISING   zcx_mes_interface,
      Erp_OutDeliveryOrderLine
        IMPORTING
                  it_data TYPE ty_t_OutDeliveryOrderLine
        RAISING   zcx_mes_interface,
      commit
        RAISING zcx_mes_interface,
      rollback
        RAISING zcx_mes_interface.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_mes_interface IMPLEMENTATION.


  METHOD class_constructor.

    IF mo_con IS NOT BOUND.
      TRY.
          mo_con = cl_sql_connection=>get_abap_connection( 'MESMIDDB' ).
        CATCH cx_sql_exception INTO DATA(lr_exc).
          cl_demo_output=>display( lr_exc->get_text( ) ).
      ENDTRY.
    ENDIF.

  ENDMETHOD.


  METHOD Erp_DeliveryNotice.

    CHECK mo_con IS BOUND AND it_data IS NOT INITIAL.

    TRY.
        DATA(lv_sql) = |DELETE FROM ZJYYMESDB_Middle.dbo.Erp_DeliveryNotice | &&
                       |WHERE Code = ?|.
        DATA(sql) = NEW cl_sql_statement( con_ref = mo_con ).
        sql->set_param( REF #( it_data[ 1 ]-code ) ).
        sql->execute_update( lv_sql ).

        lv_sql = |INSERT INTO ZJYYMESDB_Middle.dbo.Erp_DeliveryNotice | &&
                 |VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)|.
        sql = NEW cl_sql_statement( con_ref = mo_con ).
        sql->set_param_struct( REF #( it_data[ 1 ] ) ).
        sql->execute_update( lv_sql ).

        sql = NEW cl_sql_statement( con_ref = mo_con ).
        sql->set_param( data_ref = REF #( 'Erp_DeliveryNotice' )
                        inout    = cl_sql_statement=>c_param_in ).
        sql->execute_procedure(
          proc_name = 'ZJYYMESDB_Middle.dbo.proc_Erp_WriteLog' ).

      CATCH cx_sql_exception INTO DATA(lr_exc).
        RAISE EXCEPTION TYPE zcx_mes_interface
          EXPORTING
            previous = lr_exc.
    ENDTRY.

  ENDMETHOD.


  METHOD Erp_DeliveryNoticeLine.

    CHECK mo_con IS BOUND AND it_data IS NOT INITIAL.

    TRY.
        DATA(lv_sql) = |DELETE FROM ZJYYMESDB_Middle.dbo.Erp_DeliveryNoticeLine | &&
                       |WHERE DeliveryNoticeCode = ?|.
        DATA(sql) = NEW cl_sql_statement( con_ref = mo_con ).
        sql->set_param( REF #( it_data[ 1 ]-DeliveryNoticeCode ) ).
        sql->execute_update( lv_sql ).

        lv_sql = |INSERT INTO ZJYYMESDB_Middle.dbo.Erp_DeliveryNoticeLine | &&
                 |VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)|.
        sql = NEW cl_sql_statement( con_ref = mo_con ).
        sql->set_param_table( REF #( it_data ) ).
        sql->execute_update( lv_sql ).

        sql = NEW cl_sql_statement( con_ref = mo_con ).
        sql->set_param( data_ref = REF #( 'Erp_DeliveryNoticeLine' )
                        inout    = cl_sql_statement=>c_param_in ).
        sql->execute_procedure(
          proc_name = 'ZJYYMESDB_Middle.dbo.proc_Erp_WriteLog' ).

      CATCH cx_sql_exception INTO DATA(lr_exc).
        RAISE EXCEPTION TYPE zcx_mes_interface
          EXPORTING
            previous = lr_exc.
    ENDTRY.

  ENDMETHOD.


  METHOD Erp_BomLine.
    DATA lv_sql TYPE string.


    CHECK mo_con IS BOUND AND it_data IS NOT INITIAL.

    DATA(lt_BomLine_key) = VALUE ztt_bomline_key( FOR wa IN it_data
                             ( bomcode = wa-bomcode productcode = wa-productcode routingcode = wa-routingcode ) ).
    DELETE ADJACENT DUPLICATES FROM lt_BomLine_key COMPARING ALL FIELDS.

    TRY.
        LOOP AT lt_BomLine_key INTO DATA(ls_BomLine_key).
          IF lv_sql IS INITIAL.
            lv_sql = |DELETE FROM ZJYYMESDB_Middle.dbo.Erp_BomLine | &&
                     |WHERE BomCode = ? and ProductCode = ? and RoutingCode = ? |.
          ENDIF.
          DATA(sql) = NEW cl_sql_statement( con_ref = mo_con ).
          sql->set_param( REF #( ls_BomLine_key-BomCode ) ).
          sql->set_param( REF #( ls_BomLine_key-ProductCode ) ).
          sql->set_param( REF #( ls_BomLine_key-RoutingCode ) ).
          sql->execute_update( lv_sql ).
        ENDLOOP.

*        IF it_data[ 1 ]-operatetype = 4.
*          DATA lt_data_H TYPE ty_t_BomLine.
*          lv_sql = |SELECT * FROM ZJYYMESDB_Middle.dbo.Erp_BomLine_H | &&
*                   |WHERE BomCode = ? and ProductCode = ? |.
*          sql = NEW cl_sql_statement( con_ref = mo_con ).
*          sql->set_param( REF #( it_data[ 1 ]-BomCode ) ).
*          sql->set_param( REF #( it_data[ 1 ]-ProductCode ) ).
*          DATA(result) = sql->execute_query( lv_sql ).
*          result->set_param_table( itab_ref = REF #( lt_data_H ) ).
*          result->next_package( ).
*          result->close( ).
*          DATA(lv_mdfdt) = it_data[ 1 ]-mdfdt.
*          CLEAR it_data.
*          LOOP AT lt_data_H INTO DATA(ls_data).
*            ls_data-mdfdt = lv_mdfdt.
*            ls_data-operatetype = 4.
*            APPEND ls_data TO it_data.
*          ENDLOOP.
*        ENDIF.

        lv_sql = |INSERT INTO ZJYYMESDB_Middle.dbo.Erp_BomLine | &&
                 |VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)|.
        sql = NEW cl_sql_statement( con_ref = mo_con ).
        sql->set_param_table( REF #( it_data ) ).
        sql->execute_update( lv_sql ).

        sql = NEW cl_sql_statement( con_ref = mo_con ).
        sql->set_param( data_ref = REF #( 'Erp_BomLine' )
                        inout    = cl_sql_statement=>c_param_in ).
        sql->execute_procedure(
          proc_name = 'ZJYYMESDB_Middle.dbo.proc_Erp_WriteLog' ).

      CATCH cx_sql_exception INTO DATA(lr_exc).
        RAISE EXCEPTION TYPE zcx_mes_interface
          EXPORTING
            previous = lr_exc.
    ENDTRY.

  ENDMETHOD.


  METHOD Erp_ProductBomReplace.
    DATA lv_sql TYPE string.


    CHECK mo_con IS BOUND AND it_data IS NOT INITIAL.

    DATA(lt_ProductBomReplace_key) = VALUE ztt_productbomreplace_key( FOR wa IN it_data
                                       ( productcode = wa-productcode routingcode = wa-routingcode bomcode = wa-bomcode ) ).
    DELETE ADJACENT DUPLICATES FROM lt_ProductBomReplace_key COMPARING ALL FIELDS.

    TRY.
        LOOP AT lt_ProductBomReplace_key INTO DATA(ls_ProductBomReplace_key).
          lv_sql = |DELETE FROM ZJYYMESDB_Middle.dbo.Erp_ProductBomReplace | &&
                   |WHERE ProductCode = ? and RoutingCode = ? and BomCode = ? |.
          DATA(sql) = NEW cl_sql_statement( con_ref = mo_con ).
          sql->set_param( REF #( ls_ProductBomReplace_key-ProductCode ) ).
          sql->set_param( REF #( ls_ProductBomReplace_key-RoutingCode ) ).
          sql->set_param( REF #( ls_ProductBomReplace_key-BomCode ) ).
          sql->execute_update( lv_sql ).
        ENDLOOP.

*        IF it_data[ 1 ]-operatetype = 4.
*          DATA lt_data_H TYPE ty_t_ProductBomReplace.
*          lv_sql = |SELECT * FROM ZJYYMESDB_Middle.dbo.Erp_ProductBomReplace_H | &&
*                   |WHERE ProductCode = ? and BomCode = ? |.
*          sql = NEW cl_sql_statement( con_ref = mo_con ).
*          sql->set_param( REF #( it_data[ 1 ]-ProductCode ) ).
*          sql->set_param( REF #( it_data[ 1 ]-BomCode ) ).
*          DATA(result) = sql->execute_query( lv_sql ).
*          result->set_param_table( itab_ref = REF #( lt_data_H ) ).
*          result->next_package( ).
*          result->close( ).
*          DATA(lv_mdfdt) = it_data[ 1 ]-mdfdt.
*          CLEAR it_data.
*          LOOP AT lt_data_H INTO DATA(ls_data).
*            ls_data-mdfdt = lv_mdfdt.
*            ls_data-operatetype = 4.
*            APPEND ls_data TO it_data.
*          ENDLOOP.
*        ENDIF.

        lv_sql = |INSERT INTO ZJYYMESDB_Middle.dbo.Erp_ProductBomReplace | &&
                 |VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)|.
        sql = NEW cl_sql_statement( con_ref = mo_con ).
        sql->set_param_table( REF #( it_data ) ).
        sql->execute_update( lv_sql ).

        sql = NEW cl_sql_statement( con_ref = mo_con ).
        sql->set_param( data_ref = REF #( 'Erp_ProductBomReplace' )
                        inout    = cl_sql_statement=>c_param_in ).
        sql->execute_procedure(
          proc_name = 'ZJYYMESDB_Middle.dbo.proc_Erp_WriteLog' ).

      CATCH cx_sql_exception INTO DATA(lr_exc).
        RAISE EXCEPTION TYPE zcx_mes_interface
          EXPORTING
            previous = lr_exc.
    ENDTRY.

  ENDMETHOD.


  METHOD Erp_OutDeliveryOrder.

    CHECK mo_con IS BOUND AND it_data IS NOT INITIAL.

    TRY.
        DATA(lv_sql) = |DELETE FROM ZJYYMESDB_Middle.dbo.Erp_OutDeliveryOrder | &&
                       |WHERE Code = ?|.
        DATA(sql) = NEW cl_sql_statement( con_ref = mo_con ).
        sql->set_param( REF #( it_data[ 1 ]-code ) ).
        sql->execute_update( lv_sql ).

        lv_sql = |INSERT INTO ZJYYMESDB_Middle.dbo.Erp_OutDeliveryOrder | &&
                 |VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)|.
        sql = NEW cl_sql_statement( con_ref = mo_con ).
        sql->set_param_struct( REF #( it_data[ 1 ] ) ).
        sql->execute_update( lv_sql ).

        sql = NEW cl_sql_statement( con_ref = mo_con ).
        sql->set_param( data_ref = REF #( 'Erp_OutDeliveryOrder' )
                        inout    = cl_sql_statement=>c_param_in ).
        sql->execute_procedure(
          proc_name = 'ZJYYMESDB_Middle.dbo.proc_Erp_WriteLog' ).

      CATCH cx_sql_exception INTO DATA(lr_exc).
        RAISE EXCEPTION TYPE zcx_mes_interface
          EXPORTING
            previous = lr_exc.
    ENDTRY.

  ENDMETHOD.


  METHOD Erp_OutDeliveryOrderLine.

    CHECK mo_con IS BOUND AND it_data IS NOT INITIAL.

    TRY.
        DATA(lv_sql) = |DELETE FROM ZJYYMESDB_Middle.dbo.Erp_OutDeliveryOrderLine | &&
                       |WHERE OutDeliveryOrderCode = ?|.
        DATA(sql) = NEW cl_sql_statement( con_ref = mo_con ).
        sql->set_param( REF #( it_data[ 1 ]-OutDeliveryOrderCode ) ).
        sql->execute_update( lv_sql ).

        lv_sql = |INSERT INTO ZJYYMESDB_Middle.dbo.Erp_OutDeliveryOrderLine | &&
                 |VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)|.
        sql = NEW cl_sql_statement( con_ref = mo_con ).
        sql->set_param_table( REF #( it_data ) ).
        sql->execute_update( lv_sql ).

        sql = NEW cl_sql_statement( con_ref = mo_con ).
        sql->set_param( data_ref = REF #( 'Erp_OutDeliveryOrderLine' )
                        inout    = cl_sql_statement=>c_param_in ).
        sql->execute_procedure(
          proc_name = 'ZJYYMESDB_Middle.dbo.proc_Erp_WriteLog' ).

      CATCH cx_sql_exception INTO DATA(lr_exc).
        RAISE EXCEPTION TYPE zcx_mes_interface
          EXPORTING
            previous = lr_exc.
    ENDTRY.

  ENDMETHOD.


  METHOD commit.

    CHECK mo_con IS BOUND.

    TRY.
        mo_con->commit( ).
        mo_con->close( ).

      CATCH cx_sql_exception INTO DATA(lr_exc).
        RAISE EXCEPTION TYPE zcx_mes_interface
          EXPORTING
            previous = lr_exc.
    ENDTRY.

  ENDMETHOD.


  METHOD rollback.

    CHECK mo_con IS BOUND.

    TRY.
        mo_con->rollback( ).
        mo_con->close( ).

      CATCH cx_sql_exception INTO DATA(lr_exc).
        RAISE EXCEPTION TYPE zcx_mes_interface
          EXPORTING
            previous = lr_exc.
    ENDTRY.

  ENDMETHOD.


ENDCLASS.
