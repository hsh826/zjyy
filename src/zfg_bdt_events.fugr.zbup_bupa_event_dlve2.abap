FUNCTION zbup_bupa_event_dlve2.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"----------------------------------------------------------------------

  CASE lines( gt_partners ).
    WHEN 0.
      RETURN.
    WHEN 1.
      DATA(ls_partner) = gt_partners[ 1 ].
    WHEN OTHERS.
      ASSERT 1 = 2.
  ENDCASE.


  CONVERT DATE sy-datum INTO TIME STAMP DATA(lv_curr_timestamp) TIME ZONE ''.
  DATA(lv_datetime) = CONV char23( |{ lv_curr_timestamp TIMESTAMP = ISO }| ).
  IF ls_partner-partner IS INITIAL.
    SELECT SINGLE partner FROM but000 INTO ls_partner-partner WHERE partner_guid = ls_partner-partner_guid.
  ENDIF.

* Customer
  SELECT COUNT(*) FROM but100 WHERE partner = ls_partner-partner
                                AND rltyp = 'FLCU01'
                                AND dfval = ''
                                AND ( valid_from LE lv_curr_timestamp AND valid_to GE lv_curr_timestamp ).
  IF sy-subrc = 0.
    SELECT FROM I_Customer
      INNER JOIN adrc ON adrc~addrnumber = I_Customer~AddressID
*                     AND adrc~date_from = '00010101'
                     AND adrc~nation    = ' '
      FIELDS \_CustomerToBusinessPartner\_BusinessPartner[ (1) INNER WHERE BusinessPartner = @ls_partner-partner ]-BusinessPartner AS Code,
             \_CustomerToBusinessPartner\_BusinessPartner-BusinessPartnerName AS Name,
             \_CustomerToBusinessPartner\_BusinessPartner-SearchTerm1 AS ShortName,
             \_CustomerToBusinessPartner\_BusinessPartner-SearchTerm2 AS PinYinCode,
*             \_CustomerToBusinessPartner\_BusinessPartner\_CurrentDefaultAddress\_Address-StreetName AS Address,
*             \_CustomerToBusinessPartner\_BusinessPartner\_CurrentDefaultAddress\_Address-PhoneNumber AS Phone,
             adrc~street AS Address,
             adrc~tel_number AS Phone,
             ' ' AS Note,
             CASE WHEN OrderIsBlockedForCustomer = '01' THEN 3
                  WHEN \_CustomerToBusinessPartner\_BusinessPartner[ BusinessPartner = @ls_partner-partner ]-IsMarkedForArchiving = 'X' THEN 3
                  WHEN \_CustomerToBusinessPartner\_BusinessPartner[ BusinessPartner = @ls_partner-partner ]-BusinessPartnerIsBlocked = 'X' THEN 3
                  ELSE 1
             END AS OperateType,
             @ls_partner-partner AS Recid,
             @lv_datetime AS Mdfdt,
             0 AS syncflag
      INTO TABLE @DATA(lt_data).

    TRY.
        DATA(con) = cl_sql_connection=>get_abap_connection( 'MESMIDDB' ).

        DATA(lv_sql) = |DELETE FROM ZJYYMESDB_Middle.dbo.Erp_Customer | &&
                       |WHERE Code = ?|.
        DATA(sql) = NEW cl_sql_prepared_statement( con_ref = con statement = lv_sql ).
        sql->set_param( REF #( lt_data[ 1 ]-code ) ).
        sql->execute_update( lv_sql ).

        lv_sql = |INSERT INTO ZJYYMESDB_Middle.dbo.Erp_Customer | &&
                 |VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)|.
        sql = NEW cl_sql_prepared_statement( con_ref = con statement = lv_sql ).
        sql->set_param_struct( REF #( lt_data[ 1 ] ) ).
        sql->execute_update( lv_sql ).

        sql->clear_parameters( ).
        sql->set_param( data_ref = REF #( 'Erp_Customer' )
                        inout    = cl_sql_statement=>c_param_in ).
        sql->execute_procedure(
          proc_name = 'ZJYYMESDB_Middle.dbo.proc_Erp_WriteLog' ).

        sql->close( ).
      CATCH cx_sql_exception INTO DATA(exc).
        cl_demo_output=>display( exc->get_text( ) ).
    ENDTRY.

  ELSE.
    IF ls_partner-customer = 'X'.
      lt_data = VALUE #( ( Code = ls_partner-partner
                           OperateType = 3
                           Recid = ls_partner-partner
                           Mdfdt = lv_datetime
                           syncflag = 0 ) ).
      TRY.
          con = cl_sql_connection=>get_abap_connection( 'MESMIDDB' ).

          lv_sql = |DELETE FROM ZJYYMESDB_Middle.dbo.Erp_Customer | &&
                   |WHERE Code = ?|.
          sql = NEW cl_sql_prepared_statement( con_ref = con statement = lv_sql ).
          sql->set_param( REF #( lt_data[ 1 ]-code ) ).
          sql->execute_update( lv_sql ).

          lv_sql = |INSERT INTO ZJYYMESDB_Middle.dbo.Erp_Customer | &&
                   |VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)|.
          sql = NEW cl_sql_prepared_statement( con_ref = con statement = lv_sql ).
          sql->set_param_struct( REF #( lt_data[ 1 ] ) ).
          sql->execute_update( lv_sql ).

          sql->clear_parameters( ).
          sql->set_param( data_ref = REF #( 'Erp_Customer' )
                          inout    = cl_sql_statement=>c_param_in ).
          sql->execute_procedure(
            proc_name = 'ZJYYMESDB_Middle.dbo.proc_Erp_WriteLog' ).

          sql->close( ).
        CATCH cx_sql_exception INTO exc.
          cl_demo_output=>display( exc->get_text( ) ).
      ENDTRY.
    ENDIF.

  ENDIF.


* Vendor
  DATA: lv_space TYPE text1_042z.

  SELECT COUNT(*) FROM but100 WHERE partner = ls_partner-partner
                                AND rltyp = 'FLVN01'
                                AND dfval = ''
                                AND ( valid_from LE lv_curr_timestamp AND valid_to GE lv_curr_timestamp ).
  IF sy-subrc = 0.
    SELECT FROM I_Supplier
      INNER JOIN adrc ON adrc~addrnumber = I_Supplier~AddressID
*                     AND adrc~date_from = '00010101'
                     AND adrc~nation    = ' '
      INNER JOIN lfa1 ON lfa1~lifnr = I_Supplier~Supplier
      LEFT OUTER JOIN tsfgt ON tsfgt~sfrgr = lfa1~sfrgr
                           AND tsfgt~spras = @sy-langu
      LEFT OUTER JOIN j_1atodct ON j_1atodct~j_1atodc = I_Supplier~TaxNumberType
                               AND j_1atodct~spras = @sy-langu
      FIELDS \_SupplierToBusinessPartner\_BusinessPartner[ (1) INNER WHERE BusinessPartner = @ls_partner-partner ]-BusinessPartner AS Code,
             \_SupplierToBusinessPartner\_BusinessPartner-BusinessPartnerName AS Name,
             \_SupplierToBusinessPartner\_BusinessPartner-SearchTerm1 AS ShortName,
             \_SupplierToBusinessPartner\_BusinessPartner-SearchTerm2 AS PinYinCode,
*             \_SupplierToBusinessPartner\_BusinessPartner\_CurrentDefaultAddress\_Address-StreetName AS Address,
*             \_SupplierToBusinessPartner\_BusinessPartner\_CurrentDefaultAddress\_Address-PhoneNumber AS Phone,
             SupplierCorporateGroup AS OutsourcingAttribute,
             adrc~street AS Address,
             adrc~tel_number AS Phone,
             \_SupplierPurchasingOrg-SupplierRespSalesPersonName AS Contact,
             adrc~fax_number AS Fax,
             ' ' AS Note,
             tsfgt~bezei AS DeliveryMethod,
             \_SupplierCompany\_PaymentTermsText[ Language = @sy-langu ]-PaymentTermsName AS RequestMethod,
             j_1atodct~text30 AS InvoiceType,
             @lv_space AS PaymentMethod,
             CASE " WHEN PurchasingIsBlocked = 'X' THEN 3
                  WHEN \_SupplierToBusinessPartner\_BusinessPartner[ BusinessPartner = @ls_partner-partner ]-IsMarkedForArchiving = 'X' THEN 3
                  WHEN \_SupplierToBusinessPartner\_BusinessPartner[ BusinessPartner = @ls_partner-partner ]-BusinessPartnerIsBlocked = 'X' THEN 3
                  ELSE 1
             END AS OperateType,
             @ls_partner-partner AS Recid,
             @lv_datetime AS Mdfdt,
             0 AS syncflag
      INTO TABLE @DATA(lt_data2).

    LOOP AT lt_data2 REFERENCE INTO DATA(lr_data2).
      SELECT SINGLE zwels FROM lfb1 WHERE lifnr = @lr_data2->Code INTO @lv_space.
      IF sy-subrc = 0.
        CONDENSE lv_space NO-GAPS.
        SELECT SINGLE text1 FROM t042z WHERE land1 = 'CN'
                                         AND zlsch = @lv_space(1)
                                        INTO @lr_data2->paymentmethod.
      ENDIF.
    ENDLOOP.

    TRY.
        con = cl_sql_connection=>get_abap_connection( 'MESMIDDB' ).

        lv_sql = |DELETE FROM ZJYYMESDB_Middle.dbo.Erp_Supplier | &&
                 |WHERE Code = ?|.
        sql = NEW cl_sql_prepared_statement( con_ref = con statement = lv_sql ).
        sql->set_param( REF #( lt_data2[ 1 ]-code ) ).
        sql->execute_update( lv_sql ).

        lv_sql = |INSERT INTO ZJYYMESDB_Middle.dbo.Erp_Supplier | &&
                 |VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?,?,?,?)|.
        sql = NEW cl_sql_prepared_statement( con_ref = con statement = lv_sql ).
        sql->set_param_struct( REF #( lt_data2[ 1 ] ) ).
        sql->execute_update( lv_sql ).

        sql->clear_parameters( ).
        sql->set_param( data_ref = REF #( 'Erp_Supplier' )
                        inout    = cl_sql_statement=>c_param_in ).
        sql->execute_procedure(
          proc_name = 'ZJYYMESDB_Middle.dbo.proc_Erp_WriteLog' ).

        sql->close( ).

      CATCH cx_sql_exception INTO exc.
        cl_demo_output=>display( exc->get_text( ) ).
    ENDTRY.

  ELSE.
    IF ls_partner-vendor = 'X'.
      lt_data2 = VALUE #( ( Code = ls_partner-partner
                            OperateType = 3
                            Recid = ls_partner-partner
                            Mdfdt = lv_datetime
                            syncflag = 0 ) ).
      TRY.
          con = cl_sql_connection=>get_abap_connection( 'MESMIDDB' ).

          lv_sql = |DELETE FROM ZJYYMESDB_Middle.dbo.Erp_Supplier | &&
                   |WHERE Code = ?|.
          sql = NEW cl_sql_prepared_statement( con_ref = con statement = lv_sql ).
          sql->set_param( REF #( lt_data2[ 1 ]-code ) ).
          sql->execute_update( lv_sql ).

          lv_sql = |INSERT INTO ZJYYMESDB_Middle.dbo.Erp_Supplier | &&
                   |VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?,?,?,?)|.
          sql = NEW cl_sql_prepared_statement( con_ref = con statement = lv_sql ).
          sql->set_param_struct( REF #( lt_data2[ 1 ] ) ).
          sql->execute_update( lv_sql ).

          sql->clear_parameters( ).
          sql->set_param( data_ref = REF #( 'Erp_Supplier' )
                          inout    = cl_sql_statement=>c_param_in ).
          sql->execute_procedure(
            proc_name = 'ZJYYMESDB_Middle.dbo.proc_Erp_WriteLog' ).

          sql->close( ).

        CATCH cx_sql_exception INTO exc.
          cl_demo_output=>display( exc->get_text( ) ).
      ENDTRY.
    ENDIF.

  ENDIF.


  CLEAR gt_partners.

ENDFUNCTION.
