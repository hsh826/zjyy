@AbapCatalog.sqlViewName: 'ZIBILLDOCIT4SD'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Billing Document Item for SD'
define view ZI_BillingDocumentItem_SD

  as select from I_BillingDocumentItemBasic
  //    inner join   ZI_OpenItems_inAR           as AcctDoc      on AcctDoc.awkey = I_BillingDocumentItemBasic.BillingDocument
  //    inner join   ZI_BillingDoc_WeightRounding as WeightRounding on WeightRounding.BillingDocument = I_BillingDocumentItemBasic.BillingDocument
    inner join   ZI_BillingDocumentItem_SD_1 as Cleared_Item on  Cleared_Item.BillingDocument     = I_BillingDocumentItemBasic.BillingDocument
                                                             and Cleared_Item.BillingDocumentItem = I_BillingDocumentItemBasic.BillingDocumentItem
    inner join   ZI_BillingDocumentItem_SD_2 as Cleared_SUM  on Cleared_SUM.BillingDocument = I_BillingDocumentItemBasic.BillingDocument


{
  key I_BillingDocumentItemBasic.BillingDocument,
  key I_BillingDocumentItemBasic.BillingDocumentItem,

      SalesDocumentItemCategory,
      SalesDocumentItemType,
      SalesDocument,
      SalesDocumentItem,
      SalesSDDocumentCategory,

      //BillingQuantity,
      //BillingQuantityUnit,
      case BillingQuantityUnit
       when 'QG'
       then division(BillingQuantity, 10 ,3 ) 
       else BillingQuantity
       end as BillingQuantity,
       
      'WZ' as BillingQuantityUnit,
      BillingQuantityInBaseUnit,

      I_BillingDocumentItemBasic.NetAmount,
      I_BillingDocumentItemBasic.TaxAmount,
      //      Cleared_Item.BillAmount,

      case I_BillingDocumentItemBasic.BillingDocumentItem
        when '000010' then Cleared_Item.ClearedAmount_alloc + Cleared_Item.ClearedAmount - Cleared_SUM.ClearedAmount
        else               Cleared_Item.ClearedAmount_alloc
      end as ClearedAmount,

      Cleared_Item.ClearedDate

}
where
      _BillingDocumentBasic.BillingDocumentIsCancelled = ''
  and _BillingDocumentBasic.CancelledBillingDocument   = ''
