@AbapCatalog.sqlViewName: 'ZISOLIST'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.viewType: #BASIC
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Sales Order List'
define view ZI_SalesOrderList
  as select distinct from  ZI_SalesOrderListBasic
    inner join             vbap                                      on  vbap.vbeln = ZI_SalesOrderListBasic.SalesDocument
                                                                     and vbap.posnr = ZI_SalesOrderListBasic.SalesDocumentItem
    left outer to one join tmfgt                                     on  tmfgt.mfrgr = vbap.mfrgr
                                                                     and tmfgt.spras = '1'
    left outer to one join vbkd                                      on  vbkd.vbeln = SalesDocument
                                                                     and vbkd.posnr = SalesDocumentItem
    left outer to one join I_StatusObjectStatusBasic as ObjectStatus on  ObjectStatus.StatusObject     =    ZI_SalesOrderListBasic.StatusObject
                                                                     and ObjectStatus.StatusIsInactive =    ''
                                                                     and ObjectStatus.StatusCode       like 'E%'
    left outer to one join I_UserStatusText          as UserStatusText        on  UserStatusText.UserStatus = ObjectStatus.StatusCode
                                                                              and UserStatusText.Language   = '1'
    left outer to one join zyy_d_check as close on vbap.vbeln = close.vbeln
                                               and vbap.posnr = close.posnr
    left outer to one join Z_SD02_BILLING_SO as hx on vbap.vbeln = hx.aubel
                                               and vbap.posnr = hx.aupos

{
  key SalesDocument,
  key SalesDocumentItem,

      SalesOrganizationName,
      SoldToParty,
      SoldToParty_Name,
      ShipToParty_Name,
      SalesOfficeName,
      SalesDocumentTypeName,
      PurchaseOrderByCustomer,
      vbkd.ihrez                                                                as CorrespncExternalReference,
      vbkd.ihrez_e,
      case close.zyy_close when 'X' then '是'
                     else ''
                                                                            end as close_status,
      Material,
      MaterialName,
      DivisionName,
      ewbez                                                                     as MaterialShortName,
      tmfgt.bezei                                                               as PackageMethod,

      OrderQty_WZ,
      OrderQuantityUnit,
      OrderQty_DX,
      NetPrice_WZ,
      NetPriceQuantityUnit,
      NetAmount,
      TaxRate,
      TaxAmount,

      case NetAmount when 0 then 0
                     else round(NetPrice_WZ * (1 + division(TaxRate,100,6)),6)
                                                                            end as GrossPrice_WZ,

      NetAmount + TaxAmount                                                     as GrossAmount,

      DlvQty_WZ,
      DlvQuantityUnit,
      DlvQty_DX,
      case NetAmount when 0 then 0
                     else round(cast(NetPrice_WZ
                                     * (1 + division(TaxRate,100,5)) as abap.dec( 20, 5 ))
                                * DlvQty_WZ
                                ,2)
      end                                                                       as DlvQty_Amount,

      OrderQty_WZ - DlvQty_WZ                                                   as nonDlvQty_WZ,
      DlvQuantityUnit                                                           as nonDlvQuantityUnit,
      OrderQty_DX - DlvQty_DX                                                   as nonDlvQty_DX,
      case NetAmount when 0 then 0
                     else NetAmount + TaxAmount
                          -
                          round(cast(NetPrice_WZ
                                     * (1 + division(TaxRate,100,5)) as abap.dec( 20, 5 ))
                                * DlvQty_WZ
                                ,2)
      end                                                                       as nonDlvQty_Amount,

      ''                                                                        as PlanDlvDate,

      BillQty_WZ,
      BillingQuantityUnit,
      BillQty_DX,
      Bill_NetAmount,
      Bill_NetAmount + Bill_TaxAmount                                           as Bill_GrossAmount,
      //ClearedAmount,
      //ClearedDate,
      hx.hx_amt,
      case 
       when hx.hx_amt is null
        then ''
       else 'X'
       end as has_value,
      SalesDocumentDate,
      CreationDate,
      CreationTime,
      CreatedByUser,
      TotalBlockStatusDesc,
      UserStatusText.UserStatusName,

      SalesOrganization,
      SalesDocumentType,
      SalesOffice,
      Division,
      TotalBlockStatus,

      TotalDeliveryStatus,
      TotalDeliveryStatusDesc,
      BillingStatus_CAL,
      ReferenceSDDocument

}
where
  UserStatusText.StatusProfile = ObjectStatus._StatusObject.StatusProfile
