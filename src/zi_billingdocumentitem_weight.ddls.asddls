@AbapCatalog.sqlViewName: 'ZIBILLDOCITWT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Billing Document Item Weight'
define view ZI_BillingDocumentItem_Weight

  as select from I_BillingDocumentItemBasic
    inner join   bseg on  bseg.awkey = I_BillingDocumentItemBasic.BillingDocument
                      and bseg.awtyp = 'VBRK'
                      and bseg.shkzg = 'S'
                      and bseg.koart = 'D'
{
  key I_BillingDocumentItemBasic.BillingDocument,
  key I_BillingDocumentItemBasic.BillingDocumentItem,

      cast(division(( NetAmount + TaxAmount ),bseg.dmbtr,6) as abap.dec( 8, 6 )) as Weight

}
