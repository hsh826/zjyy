@AbapCatalog.sqlViewName: 'ZISOWSCHEDLN'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.viewType: #BASIC
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Sales Order with ScheduleLine'
define view ZI_SalesOrder_ScheduleLine
  as select from I_SalesDocumentScheduleLine

{
  key SalesDocument,
  key SalesDocumentItem,

      sum( DeliveredQuantityInBaseUnit ) as DeliveredQuantityInBaseUnit,
      sum( DeliveredQtyInOrderQtyUnit )  as DeliveredQtyInOrderQtyUnit
}
group by
  SalesDocument,
  SalesDocumentItem
