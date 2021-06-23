@AbapCatalog.sqlViewName: 'ZIBILLDOCIT4SD1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Billing Document Item for SD - 1'
define view ZI_BillingDocumentItem_SD_1

  as select distinct from           I_BillingDocumentItemBasic
    inner join             bseg                                on  bseg.awkey = I_BillingDocumentItemBasic.BillingDocument
                                                               and bseg.koart = 'D'
                                                               and bseg.awtyp = 'VBRK'
    left outer to one join ZI_ClearedItems_inAR as ClearedItem on  ClearedItem.zuonr = bseg.zuonr
                                                               and ClearedItem.bukrs = bseg.bukrs
                                                               and ClearedItem.gjahr = bseg.gjahr

  //    inner join   ZI_OpenItems_inAR as AcctDoc on AcctDoc.awkey = I_BillingDocumentItemBasic.BillingDocument

{
  key I_BillingDocumentItemBasic.BillingDocument,
  key BillingDocumentItem,

      I_BillingDocumentItemBasic.NetAmount,
      I_BillingDocumentItemBasic.TaxAmount,
      //      AcctDoc.BillAmount,
      //      AcctDoc.BillAmount - AcctDoc.OpenAmount as ClearedAmount,
      case when ClearedItem.ClearedAmount is null then 0
           else ClearedItem.ClearedAmount
      end                         as ClearedAmount,

      case when ClearedItem.ClearedAmount is null then 0
           else cast(
                    round(division((NetAmount + TaxAmount),bseg.dmbtr,6)
                          * cast(ClearedItem.ClearedAmount as abap.dec( 15, 2 ))
                          ,2)
                    as abap.dec( 15, 2 ))
      end                         as ClearedAmount_alloc,

      ClearedItem.LastClearedDate as ClearedDate

}
where
      bseg.bukrs = I_BillingDocumentItemBasic._BillingDocumentBasic.CompanyCode
  and bseg.gjahr = I_BillingDocumentItemBasic._BillingDocumentBasic.FiscalYear
