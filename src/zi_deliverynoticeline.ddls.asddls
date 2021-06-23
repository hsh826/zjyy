@AbapCatalog.sqlViewName: 'ZIDELIVNOTILINE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.viewType: #BASIC
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'MES: Erp_DeliveryNoticeLine'
/*+[hideWarning] { "IDS" : [ "DOUBLE_JOIN" ]  } */

define view ZI_DeliveryNoticeLine
  as select from           I_DeliveryDocumentItem
  //    left outer to one join marm                    as marm_JA       on  I_DeliveryDocumentItem.Material = marm_JA.matnr
  //                                                                    and marm_JA.meinh                   = 'JA'
  //  //    left outer to one join marm as marm_WZ on  I_DeliveryDocumentItem.Material = marm_WZ.matnr
  //  //                                           and marm_WZ.meinh                   = 'WZ'
  //    left outer to one join marm                    as marm_KG       on  I_DeliveryDocumentItem.Material = marm_KG.matnr
  //                                                                    and marm_KG.meinh                   = 'KG'
  //    left outer to one join marm                    as marm_DX       on  I_DeliveryDocumentItem.Material = marm_DX.matnr
  //                                                                    and marm_DX.meinh                   = 'DX'
    left outer to one join ZI_ProductUnitDetermine as Single_unit      on Single_unit.mfrgr = I_DeliveryDocumentItem.MaterialFreightGroup
  //    left outer to one join t006a                   as WZ_txt           on  WZ_txt.spras = $session.system_language
  //                                                                       and WZ_txt.msehi = 'WZ'
  //    left outer to one join ZI_ProductUnitConvert   as WZ_per_Deliv     on  WZ_per_Deliv.matnr      = I_DeliveryDocumentItem.Material
  //                                                                       and WZ_per_Deliv.num_unit   = 'WZ'
  //                                                                       and WZ_per_Deliv.denom_unit = I_DeliveryDocumentItem.DeliveryQuantityUnit
  //    left outer to one join ZI_ProductUnitConvert   as DX_per_Deliv     on  DX_per_Deliv.matnr      = I_DeliveryDocumentItem.Material
  //                                                                       and DX_per_Deliv.num_unit   = 'DX'
  //                                                                       and DX_per_Deliv.denom_unit = I_DeliveryDocumentItem.DeliveryQuantityUnit
  //    left outer to one join ZI_ProductUnitConvert   as Single_per_Deliv on  Single_per_Deliv.matnr      = I_DeliveryDocumentItem.Material
  //                                                                       and Single_per_Deliv.num_unit   = Single_unit.msehi
  //                                                                       and Single_per_Deliv.denom_unit = I_DeliveryDocumentItem.DeliveryQuantityUnit
  //    left outer to one join ZI_ProductUnitConvert   as WZ_per_Single    on  WZ_per_Single.matnr      = I_DeliveryDocumentItem.Material
  //                                                                       and WZ_per_Single.num_unit   = 'WZ'
  //                                                                       and WZ_per_Single.denom_unit = Single_unit.msehi
    left outer to one join marm                    as Single_per_Basic on  Single_per_Basic.matnr = I_DeliveryDocumentItem.Material
                                                                       and Single_per_Basic.meinh = Single_unit.msehi
    left outer to one join marm                    as WZ_per_Basic     on  WZ_per_Basic.matnr = I_DeliveryDocumentItem.Material
                                                                       and WZ_per_Basic.meinh = 'WZ'
    left outer to one join marm                    as DX_per_Basic     on  DX_per_Basic.matnr = I_DeliveryDocumentItem.Material
                                                                       and DX_per_Basic.meinh = 'DX'
{
  key DeliveryDocument                                                                                  as DeliveryNoticeCode,
  key DeliveryDocumentItem                                                                              as SortIndex,
      DeliveryDocumentItem                                                                              as RowNo,
      ''                                                                                                as BatchNumber, //null
      ltrim(Material,'0')                                                                               as ItemCode,
      //      WZ_txt.mseh3                                                                          as UnitSaleMainCode,
      //      WZ_txt.mseh3                                                                          as UnitSaleAuxCode, //null
      _DeliveryQuantityUnit._Text[ 1: Language = $session.system_language ].UnitOfMeasureCommercialName as UnitSaleMainCode,
      _DeliveryQuantityUnit._Text[ 1: Language = $session.system_language ].UnitOfMeasureCommercialName as UnitSaleAuxCode,
      1                                                                                                 as RateFra, //null
      1                                                                                                 as RateNum, //null

      //      cast(ActualDeliveredQtyInBaseUnit as abap.fltp)
      //      / ( cast(WZ_per_Basic.umrez as abap.fltp) / cast(WZ_per_Basic.umren as abap.fltp) )               as Qty,
      ActualDeliveryQuantity                                                                            as Qty,
      0                                                                                                 as AuxQty, //null
      dats_tims_to_tstmp( _DeliveryDocument.PlannedGoodsIssueDate,
                          '000000',
                          '',
                          $session.client,
                          'INITIAL' )                                                                   as RequiredDate,
      StorageLocation                                                                                   as WareHouseCode,
      '30'                                                                                              as LineSourceType,
      ManufactureDate                                                                                   as ProductNote,
      MaterialByCustomer                                                                                as CustomItemCode,
      Single_unit.bezei                                                                                 as PackageType,

      case when DeliveryQuantityUnit = 'JZ6' or DeliveryQuantityUnit = 'WZ'
        then
      ( cast(Single_per_Basic.brgew as abap.fltp) / cast(Single_per_Basic.umren as abap.fltp)
        - ( cast(Single_per_Basic.umrez as abap.fltp) / cast(Single_per_Basic.umren as abap.fltp)
            * cast(_Material.MaterialNetWeight as abap.fltp) ) )
      * cast(ceil(cast(ActualDeliveredQtyInBaseUnit as abap.fltp)
                  / ( cast(Single_per_Basic.umrez as abap.fltp) / cast(Single_per_Basic.umren as abap.fltp) )
                  ) as abap.fltp)
      + cast(ItemNetWeight as abap.fltp)
      else 0
      end                                                                                               as Weight,

      case when DeliveryQuantityUnit = 'JZ6' or DeliveryQuantityUnit = 'WZ'
        then
      cast(ActualDeliveredQtyInBaseUnit as abap.fltp)
      / ( cast(DX_per_Basic.umrez as abap.fltp) / cast(DX_per_Basic.umren as abap.fltp) )
      else 0
      end                                                                                               as BigNumber,

      case when DeliveryQuantityUnit = 'JZ6' or DeliveryQuantityUnit = 'WZ'
        then
      ceil(
        cast(ActualDeliveredQtyInBaseUnit as abap.fltp)
        / ( cast(Single_per_Basic.umrez as abap.fltp) / cast(Single_per_Basic.umren as abap.fltp) )
        )
      else 0
      end                                                                                               as SingerNumber,

      case when DeliveryQuantityUnit = 'JZ6' or DeliveryQuantityUnit = 'WZ'
        then
      cast(Single_per_Basic.umrez as abap.fltp)
      / ( cast(WZ_per_Basic.umrez as abap.fltp) / cast(WZ_per_Basic.umren as abap.fltp) )
      / cast(Single_per_Basic.umren as abap.fltp)
      else 0
      end                                                                                               as ProductUnit,

      case when DeliveryQuantityUnit = 'JZ6' or DeliveryQuantityUnit = 'WZ'
        then
      cast(Single_per_Basic.brgew as abap.fltp) / cast(Single_per_Basic.umren as abap.fltp)
      else 0
      end                                                                                               as StockUnit,

      ''                                                                                                as Note,
      0                                                                                                 as OperateType,
      0                                                                                                 as syncflag,

      CustEngineeringChgStatus


}
