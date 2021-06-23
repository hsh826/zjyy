@AbapCatalog.sqlViewName: 'ZISOLISTBASIC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.viewType: #BASIC
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Sales Order List Basic'
define view ZI_SalesOrderListBasic
  as select distinct from  I_SalesDocumentItem
    left outer to one join mara                                          on mara.matnr = I_SalesDocumentItem.Material
    left outer to one join twewt                                         on  twewt.extwg = mara.extwg
                                                                         and twewt.spras = $session.system_language
  //    left outer to one join ZI_ProductUnitDetermine as mfrgr_Text on mfrgr_Text.mfrgr = I_SalesDocumentItem.?
    left outer to one join marm                         as WZ_per_Basic                          on  WZ_per_Basic.matnr = I_SalesDocumentItem.Material
                                                                                                 and WZ_per_Basic.meinh = 'WZ'
    left outer to one join marm                         as DX_per_Basic                          on  DX_per_Basic.matnr = I_SalesDocumentItem.Material
                                                                                                 and DX_per_Basic.meinh = 'DX'
    left outer to one join marm                         as kmein_per_Basic                       on  kmein_per_Basic.matnr = I_SalesDocumentItem.Material
                                                                                                 and kmein_per_Basic.meinh = I_SalesDocumentItem.NetPriceQuantityUnit
    left outer to one join t006a                        as WZ_txt                               on  WZ_txt.msehi = 'WZ'
                                                                                                and WZ_txt.spras = '1'
    left outer to one join t006a                        as Tao_txt                              on  Tao_txt.msehi = 'JZ6'
                                                                                                and Tao_txt.spras = '1'
    left outer to one join t006a                        as orderunit                              on  orderunit.msehi = I_SalesDocumentItem.OrderQuantityUnit
                                                                                                and orderunit.spras = $session.system_language
  //    left outer to one join I_PricingElement as NetPriceElement on  NetPriceElement.PricingDocument     =  I_SalesDocumentItem.SalesDocumentCondition
  //                                                               and NetPriceElement.PricingDocumentItem =  I_SalesDocumentItem.SalesDocumentItem
  //                                                               and (
  //                                                                  NetPriceElement.ConditionType        =  'PR00'
  //                                                                  or NetPriceElement.ConditionType     =  'ZPR2'
  //                                                                )
  //                                                               and NetPriceElement.ConditionRateValue  <> 0
    left outer to one join I_PricingElement             as TaxRateElement            on  TaxRateElement.PricingDocument     = I_SalesDocumentItem.SalesDocumentCondition
                                                                                     and TaxRateElement.PricingDocumentItem = I_SalesDocumentItem.SalesDocumentItem
                                                                                     and TaxRateElement.ConditionType       = 'MWST'
    left outer to one join I_PricingElement             as PriceElement            on  PriceElement.PricingDocument     = I_SalesDocumentItem.SalesDocumentCondition
                                                                                     and PriceElement.PricingDocumentItem = I_SalesDocumentItem.SalesDocumentItem
                                                                                     and PriceElement.ConditionType       = 'PR00'
  //    left outer to many join vbfa                    on  vbfa.vbelv   = I_SalesDocumentItem.SalesDocument
  //                                                    and vbfa.posnv   = I_SalesDocumentItem.SalesDocumentItem
  //                                                    and vbfa.vbtyp_n = 'M'
  //    left outer to many join I_BillingDocumentItemBasic as BillingDocItem on  BillingDocItem.ReferenceSDDocument         = I_SalesDocumentItem.SalesDocument
  //                                                                         and BillingDocItem.ReferenceSDDocumentItem     = I_SalesDocumentItem.SalesDocumentItem
  //                                                                         and BillingDocItem.ReferenceSDDocumentCategory = 'C'
    left outer to one join ZI_SalesOrder_ScheduleLine   as ScheduleLine    on  ScheduleLine.SalesDocument     = I_SalesDocumentItem.SalesDocument
                                                                           and ScheduleLine.SalesDocumentItem = I_SalesDocumentItem.SalesDocumentItem
    left outer to one join ZI_SalesOrder_BillingDoc     as BillingDoc        on  BillingDoc.SalesDocument     = I_SalesDocumentItem.SalesDocument
                                                                             and BillingDoc.SalesDocumentItem = I_SalesDocumentItem.SalesDocumentItem
    left outer to one join ZI_DeliveryBillingStatus_AGG as BillingStatus on  BillingStatus.vgbel = I_SalesDocumentItem.SalesDocument
                                                                         and BillingStatus.vgpos = I_SalesDocumentItem.SalesDocumentItem
    left outer to one join ZI_BILLINGSTATUS_AGG as BStatus on  BStatus.aubel = I_SalesDocumentItem.SalesDocument
                                                                         and BStatus.aupos = I_SalesDocumentItem.SalesDocumentItem
    

{
  key I_SalesDocumentItem.SalesDocument,
  key I_SalesDocumentItem.SalesDocumentItem,

      I_SalesDocumentItem._SalesDocument._SalesOrganization._Text[ 1: Language = $session.system_language ].SalesOrganizationName,
      I_SalesDocumentItem._SalesDocument.SoldToParty,
      I_SalesDocumentItem._SalesDocument._SoldToParty.OrganizationBPName1           as SoldToParty_Name,
      I_SalesDocumentItem._SalesDocument._StandardPartner._ShipToParty.CustomerName as ShipToParty_Name,
      I_SalesDocumentItem._SalesDocument._SalesOffice._Text[ 1: Language = $session.system_language ].SalesOfficeName,
      I_SalesDocumentItem._SalesDocument._SalesDocumentType._Text[ 1: Language = $session.system_language ].SalesDocumentTypeName,
      I_SalesDocumentItem.PurchaseOrderByCustomer,
      I_SalesDocumentItem._SalesDocument.CorrespncExternalReference,

      I_SalesDocumentItem.Material,
      I_SalesDocumentItem._Material._Text[ 1: Language = $session.system_language ].MaterialName,
      I_SalesDocumentItem._Division._Text[ 1: Language = $session.system_language ].DivisionName,
      twewt.ewbez,


      /*case OrderQuantityUnit when 'JZ6' then OrderQuantity
                             else            cast(
                                               round(OrderQuantity
                                                     * division(OrderToBaseQuantityNmrtr,OrderToBaseQuantityDnmntr,6)
                                                     * division(WZ_per_Basic.umren,WZ_per_Basic.umrez,6)
                                                     ,2)
                                               as abap.dec( 15, 2 ))
      end                                                                           as OrderQty_WZ,
      case OrderQuantityUnit when 'JZ6' then Tao_txt.mseh3
                             else WZ_txt.mseh3
      end                                                                           as OrderQuantityUnit,


      case NetPriceQuantityUnit when 'JZ6' then NetPriceAmount
                                else            cast(
                                                  division(NetPriceAmount,NetPriceQuantity,6)
                                                  * division(kmein_per_Basic.umrez,kmein_per_Basic.umren,6)
                                                  * division(WZ_per_Basic.umren,WZ_per_Basic.umrez,6)
                                                  as abap.dec( 15, 6 ))
      end                                                                           as NetPrice_WZ,
      case NetPriceQuantityUnit when 'JZ6' then Tao_txt.mseh3
                                else            WZ_txt.mseh3
      end                                                                           as NetPriceQuantityUnit,
      */
      
      case I_SalesDocumentItem.OrderQuantityUnit
        when 'QG'
          then division( OrderQuantity, 10, 4)
          else OrderQuantity 
      end as OrderQty_WZ,
      orderunit.mseh3 as OrderQuantityUnit,
      case I_SalesDocumentItem.OrderQuantityUnit
        when 'QG'
          then cast(
        round( cast( round (division( OrderQuantity, 10, 4)
              * division(OrderToBaseQuantityNmrtr,OrderToBaseQuantityDnmntr,6) ,6 ) as abap.dec(15,6))
              * division(DX_per_Basic.umren,DX_per_Basic.umrez,6)
              ,2)
        as abap.dec( 15, 2 ))
          else cast(
        round(OrderQuantity
              * division(OrderToBaseQuantityNmrtr,OrderToBaseQuantityDnmntr,6)
              * division(DX_per_Basic.umren,DX_per_Basic.umrez,6)
              ,2)
        as abap.dec( 15, 2 ))
      end as OrderQty_DX,
       //cast(
       // round(OrderQuantity
       //       * division(OrderToBaseQuantityNmrtr,OrderToBaseQuantityDnmntr,6)
       //       * division(DX_per_Basic.umren,DX_per_Basic.umrez,6)
       //       ,2)
      //  as abap.dec( 15, 2 ))                                                       as OrderQty_DX,
      //division(NetPriceAmount,NetPriceQuantity,6) as NetPrice_WZ,
      case when PriceElement.ConditionQuantity is null then 0
           //when I_SalesDocumentItem.OrderQuantityUnit = 'QG'
          // then cast( division(PriceElement.ConditionRateValue * 10,PriceElement.ConditionQuantity,6) as abap.dec( 15, 6 ))
           else cast( division(PriceElement.ConditionRateValue,PriceElement.ConditionQuantity,6) as abap.dec( 15, 6 )) end as NetPrice_WZ,
      //cast(division(I_SalesDocumentItem.NetAmount,OrderQuantity,6) as abap.dec( 15, 6 )) as NetPrice_WZ,
      case NetPriceQuantityUnit when 'JZ6' then Tao_txt.mseh3
                                else            WZ_txt.mseh3
      end                                                                           as NetPriceQuantityUnit,
      I_SalesDocumentItem.NetAmount,

      case when TaxRateElement.ConditionRateValue is null then 0
           else                                                TaxRateElement.ConditionRateValue
      end                                                                           as TaxRate,

      I_SalesDocumentItem.TaxAmount,

      //      cast(NetPriceAmount as abap.fltp)
      //      / cast(NetPriceQuantity as abap.fltp)
      //      / cast(kmein_per_Basic.umren as abap.fltp)
      //      * cast(kmein_per_Basic.umrez as abap.fltp)
      //      / ( cast(WZ_per_Basic.umrez as abap.fltp) / cast(WZ_per_Basic.umren as abap.fltp) )
      //      *
      //      ( cast(1 as abap.fltp) + cast(I_SalesDocumentItem.TaxAmount as abap.fltp) / cast(I_SalesDocumentItem.NetAmount as abap.fltp) ) as GrossPrice_WZ,

      //      I_SalesDocumentItem.NetAmount + I_SalesDocumentItem.TaxAmount                       as GrossAmount,

      /*case OrderQuantityUnit when 'JZ6' then ScheduleLine.DeliveredQtyInOrderQtyUnit
                             else            cast(
                                               round(ScheduleLine.DeliveredQuantityInBaseUnit
                                                     * division(WZ_per_Basic.umren,WZ_per_Basic.umrez,6)
                                                     ,2)
                                               as abap.dec( 15, 2 ))
      end
                                                                                 as DlvQty_WZ,*/
      case I_SalesDocumentItem.OrderQuantityUnit
        when 'QG'
        then division( ScheduleLine.DeliveredQtyInOrderQtyUnit, 10, 4)  
        else ScheduleLine.DeliveredQtyInOrderQtyUnit 
      end as DlvQty_WZ,
      //case OrderQuantityUnit when 'JZ6' then Tao_txt.mseh3
      //                       else            WZ_txt.mseh3
      //end                                                                           as DlvQuantityUnit,
      WZ_txt.mseh3 as DlvQuantityUnit,
      case I_SalesDocumentItem.OrderQuantityUnit
        when 'QG'
          then cast(
        round( division( ScheduleLine.DeliveredQuantityInBaseUnit, 10, 4)
              * division(DX_per_Basic.umren,DX_per_Basic.umrez,6)
              ,2)
        as abap.dec( 15, 2 ))
          else cast(
        round(ScheduleLine.DeliveredQuantityInBaseUnit
              * division(DX_per_Basic.umren,DX_per_Basic.umrez,6)
              ,2)
        as abap.dec( 15, 2 ))
      end as DlvQty_DX,
      
      //cast(
      //  round(ScheduleLine.DeliveredQuantityInBaseUnit
      //        * division(DX_per_Basic.umren,DX_per_Basic.umrez,6)
      //        ,2)
      //  as abap.dec( 15, 2 ))                                                       as DlvQty_DX,

      //      cast(ScheduleLine.DeliveredQuantityInBaseUnit as abap.fltp)
      //      / ( cast(WZ_per_Basic.umrez as abap.fltp) / cast(WZ_per_Basic.umren as abap.fltp) )
      //      * (
      //      cast(NetPriceAmount as abap.fltp)
      //      / cast(NetPriceQuantity as abap.fltp)
      //      / cast(kmein_per_Basic.umren as abap.fltp)
      //      * cast(kmein_per_Basic.umrez as abap.fltp)
      //      / ( cast(WZ_per_Basic.umrez as abap.fltp) / cast(WZ_per_Basic.umren as abap.fltp) )
      //      )                                                                                   as DlvQty_Amount,

      /*case BillingDoc.BillingQuantityUnit when 'JZ6' then BillingDoc.BillingQuantity
                                          else            cast(
                                                            round(BillingDoc.BillingQuantityInBaseUnit
                                                                  * division(WZ_per_Basic.umren,WZ_per_Basic.umrez,6)
                                                                  ,2)
                                                            as abap.dec( 15, 2 ))
      end                                                                           as BillQty_WZ,*/
      BillingDoc.BillingQuantity as BillQty_WZ,
      case BillingDoc.BillingQuantityUnit when 'JZ6' then Tao_txt.mseh3
                                          else            WZ_txt.mseh3
      end                                                                           as BillingQuantityUnit,

      cast(
        round(BillingDoc.BillingQuantityInBaseUnit
              * division(DX_per_Basic.umren,DX_per_Basic.umrez,6)
              ,2)
        as abap.dec( 15, 2 ))                                                       as BillQty_DX,

      BillingDoc.NetAmount                                                          as Bill_NetAmount,
      BillingDoc.TaxAmount                                                          as Bill_TaxAmount,
      BillingDoc.ClearedAmount,
      BillingDoc.ClearedDate,

      I_SalesDocumentItem._SalesDocument.SalesDocumentDate,
      I_SalesDocumentItem.CreationDate,
      I_SalesDocumentItem.CreationTime,
      I_SalesDocumentItem.CreatedByUser,
      I_SalesDocumentItem._SalesDocument._TotalBlockStatus._Text[ 1: Language = $session.system_language ].TotalBlockStatusDesc,

      //      WZ_per_Basic.umrez                                                                                                             as WZ_umrez,
      //      WZ_per_Basic.umren                                                                                                             as WZ_umren,
      //      DX_per_Basic.umrez                                                                                                             as DX_umrez,
      //      DX_per_Basic.umren                                                                                                             as DX_umren,

      I_SalesDocumentItem._SalesDocument.SalesOrganization,
      I_SalesDocumentItem._SalesDocument.SalesDocumentType,
      I_SalesDocumentItem._SalesDocument.SalesOffice,
      I_SalesDocumentItem.Division,
      I_SalesDocumentItem._SalesDocument.TotalBlockStatus,
      concat('VB',concat(I_SalesDocumentItem.SalesDocument,'000000'))               as StatusObject,
      _TotalDeliveryStatus._Text[ 1: Language = $session.system_language ].TotalDeliveryStatus,
      _TotalDeliveryStatus._Text[ 1: Language = $session.system_language ].TotalDeliveryStatusDesc,
      //case I_SalesDocumentItem.DeliveryStatus when 'A' then '没有处理'
      //                                        when 'B' then '部分处理'
      //                                        when '' then '无关'
      //                                        when 'C' then case when BillingStatus.fksta_c = 1 then '完全地处理'
      //                                                           when BillingStatus.fksta_a = 1 then '没有处理'
      //                                                           when BillingStatus.fksta_init = 1 then '无关'
      //                                                           else '部分处理'
      //                                                      end
      //end                                                                           as BillingStatus_CAL,
      case when BStatus.gbstk_c = 1 then '完全地处理'
                                                                 when BStatus.gbstk_a = 1 then '没有处理'
                                                                 when BStatus.gbstk_b = 1 then '部分处理'
                                                                 when BStatus.gbstk_init = 1 then '无关'
                                                                 else '没有处理'
      end                                                                           as BillingStatus_CAL,
      I_SalesDocumentItem.ReferenceSDDocument

}
where
  (
       SDDocumentCategory      = 'C'
    or SDDocumentCategory      = 'H'
    or SDDocumentCategory      = 'I'
  )
  and  SalesDocumentRjcnReason = ''
