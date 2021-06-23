@AbapCatalog.sqlViewName: 'ZISOWBILLDOC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.viewType: #BASIC
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Sales Order with Billing Document'
define view ZI_SalesOrder_BillingDoc
  as select from ZI_BillingDocumentItem_SD

{
  key SalesDocument,
  key SalesDocumentItem,

      max( ZI_BillingDocumentItem_SD.ClearedDate ) as ClearedDate,

      sum( BillingQuantity)                        as BillingQuantity,
      BillingQuantityUnit,
      sum( BillingQuantityInBaseUnit )             as BillingQuantityInBaseUnit,
      sum( NetAmount )                             as NetAmount,
      sum( TaxAmount )                             as TaxAmount,
      sum( ClearedAmount )                         as ClearedAmount
}
where
     SalesSDDocumentCategory = 'C'
  or SalesSDDocumentCategory = 'H'
  or SalesSDDocumentCategory = 'I'
group by
  SalesDocument,
  SalesDocumentItem,
  BillingQuantityUnit
