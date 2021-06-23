@AbapCatalog.sqlViewName: 'ZIDELBILLSTBASIC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.viewType: #BASIC
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'List of billing status of the item'
define view ZI_DeliveryBillingStatus_Basic

  as select from lips

{
  key vbeln,
  key posnr,

      vgbel,
      vgpos,

      case fksta when 'C' then 1
                 else 0
      end as fksta_c,

      case fksta when 'A' then 1
                 else 0
      end as fksta_a,

      case fksta when '' then 1
                 else 0
      end as fksta_init

}
