*&---------------------------------------------------------------------*
*& Report ZBP_MES_IMPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbp_mes_import.


DATA: lv_partner  TYPE bu_partner,
      lt_Customer TYPE  zcl_mes_interface=>ty_t_Customer,
      lt_Supplier TYPE  zcl_mes_interface=>ty_t_Supplier.

SELECTION-SCREEN BEGIN OF BLOCK bk1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_bp FOR lv_partner OBLIGATORY.
  PARAMETERS: p_cust TYPE c RADIOBUTTON GROUP rb1,
              p_vend TYPE c RADIOBUTTON GROUP rb1.
SELECTION-SCREEN END OF BLOCK bk1.


START-OF-SELECTION.

  CONVERT DATE sy-datum INTO TIME STAMP DATA(lv_curr_timestamp) TIME ZONE ''.
  DATA(lv_datetime) = CONV char23( |{ lv_curr_timestamp TIMESTAMP = ISO }| ).

* Customer
  IF p_cust = 'X'.
    SELECT FROM I_Customer WITH PRIVILEGED ACCESS
      INNER JOIN adrc ON adrc~addrnumber = I_Customer~AddressID
*                     AND adrc~date_from = '00010101'
                     AND adrc~nation    = ' '
      FIELDS \_CustomerToBusinessPartner\_BusinessPartner[ (1) INNER ]-BusinessPartner AS Code,
             \_CustomerToBusinessPartner\_BusinessPartner-BusinessPartnerName AS Name,
             \_CustomerToBusinessPartner\_BusinessPartner-SearchTerm1 AS ShortName,
             \_CustomerToBusinessPartner\_BusinessPartner-SearchTerm2 AS PinYinCode,
*             \_CustomerToBusinessPartner\_BusinessPartner\_CurrentDefaultAddress\_Address-StreetName AS Address,
*             \_CustomerToBusinessPartner\_BusinessPartner\_CurrentDefaultAddress\_Address-PhoneNumber AS Phone,
             adrc~street AS Address,
             adrc~tel_number AS Phone,
             ' ' AS Note,
             1 AS OperateType,
             \_CustomerToBusinessPartner\_BusinessPartner[ (1) INNER ]-BusinessPartner AS Recid,
             @lv_datetime AS Mdfdt,
             0 AS syncflag
      WHERE \_CustomerToBusinessPartner\_BusinessPartner-BusinessPartner IN @s_bp
      INTO TABLE @lt_Customer.


  ELSE.
* Vendor
    SELECT FROM I_Supplier WITH PRIVILEGED ACCESS
        INNER JOIN adrc ON adrc~addrnumber = I_Supplier~AddressID
*                     AND adrc~date_from = '00010101'
                       AND adrc~nation    = ' '
      FIELDS \_SupplierToBusinessPartner\_BusinessPartner[ (1) INNER ]-BusinessPartner AS Code,
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
             1 AS OperateType,
             \_SupplierToBusinessPartner\_BusinessPartner[ (1) INNER ]-BusinessPartner AS Recid,
             @lv_datetime AS Mdfdt,
             0 AS syncflag
      WHERE \_SupplierToBusinessPartner\_BusinessPartner-BusinessPartner IN @s_bp
      INTO TABLE @lt_Supplier.


  ENDIF.


  TRY.
      IF lt_Customer IS NOT INITIAL.
        zcl_mes_interface=>Erp_Customer( it_data = lt_Customer ).
      ENDIF.

      IF lt_Supplier IS NOT INITIAL.
        zcl_mes_interface=>Erp_Supplier( it_data = lt_Supplier ).
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
