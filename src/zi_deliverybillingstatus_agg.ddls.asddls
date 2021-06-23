@AbapCatalog.sqlViewName: 'ZIDELBILLSTAGG'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.viewType: #BASIC
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Aggregates for billing status of the item'
define view ZI_DeliveryBillingStatus_AGG

  as select from ZI_DeliveryBillingStatus_Basic

{
  key vgbel,
  key vgpos,

      min(fksta_c)    as fksta_c,
      min(fksta_a)    as fksta_a,
      min(fksta_init) as fksta_init

}
group by
  vgbel,
  vgpos
