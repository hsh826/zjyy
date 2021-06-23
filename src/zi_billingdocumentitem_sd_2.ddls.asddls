@AbapCatalog.sqlViewName: 'ZIBILLDOCIT4SD2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Billing Document Item for SD - 2'
define view ZI_BillingDocumentItem_SD_2

  as select from ZI_BillingDocumentItem_SD_1

{
  key BillingDocument,

      sum( ClearedAmount_alloc ) as ClearedAmount

}
group by
  BillingDocument
