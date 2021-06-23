@AbapCatalog.sqlViewName: 'ZIBILLDOCWTRD'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Billing Document Total Weight Rounding'
define view ZI_BillingDoc_WeightRounding

  as select from ZI_BillingDocumentItem_Weight

{
  key BillingDocument,

      sum( Weight ) as Weight_SUM

}
group by
  BillingDocument
