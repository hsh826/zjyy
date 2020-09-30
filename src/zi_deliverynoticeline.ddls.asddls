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
    left outer to one join marm  as marm_JA on  I_DeliveryDocumentItem.Material = marm_JA.matnr
                                            and marm_JA.meinh                   = 'JA'
  //    left outer to one join marm as marm_WZ on  I_DeliveryDocumentItem.Material = marm_WZ.matnr
  //                                           and marm_WZ.meinh                   = 'WZ'
    left outer to one join marm  as marm_KG on  I_DeliveryDocumentItem.Material = marm_KG.matnr
                                            and marm_KG.meinh                   = 'KG'
    left outer to one join marm  as marm_DX on  I_DeliveryDocumentItem.Material = marm_DX.matnr
                                            and marm_DX.meinh                   = 'DX'
    left outer to one join t006a as WZ_txt  on  WZ_txt.spras = $session.system_language
                                            and WZ_txt.msehi = 'WZ'
{
  key DeliveryDocument                                                                               as DeliveryNoticeCode,
  key DeliveryDocumentItem                                                                           as SortIndex,
      DeliveryDocumentItem                                                                           as RowNo,
      ''                                                                                             as BatchNumber, //null
      Material                                                                                       as ItemCode,
      WZ_txt.mseht                                                                                   as UnitSaleMainCode,
      WZ_txt.mseht                                                                                   as UnitSaleAuxCode, //null
      1                                                                                              as RateFra, //null
      1                                                                                              as RateNum, //null
      case when DeliveryQuantityUnit = 'ZHG' then cast(ActualDeliveryQuantity as abap.fltp)
                                                    / cast(10000 as abap.fltp)
           when DeliveryQuantityUnit = 'QZ' then cast(ActualDeliveryQuantity as abap.fltp)
                                                    / cast(10 as abap.fltp)
           when DeliveryQuantityUnit = 'QG' then cast(ActualDeliveryQuantity as abap.fltp)
                                                    / cast(10 as abap.fltp)
           when DeliveryQuantityUnit = 'WZ' then cast(ActualDeliveryQuantity as abap.fltp)
           else 0
      end                                                                                            as Qty,
      0                                                                                              as AuxQty, //null
      dats_tims_to_tstmp( _DeliveryDocument.PlannedGoodsIssueDate,
                          '000000',
                          '',
                          $session.client,
                          'INITIAL' )                                                                as RequiredDate,
      StorageLocation                                                                                as WareHouseCode,
      '30'                                                                                           as LineSourceType,
      ManufactureDate                                                                                as ProductNote,
      MaterialByCustomer                                                                             as CustomItemCode,
      _MaterialFreightGroup._Text[ 1: Language = $session.system_language ].MaterialFreightGroupName as PackageType,
      cast( ItemGrossWeight as abap.char( 64 ) )                                                     as Weight,
      case when DeliveryQuantityUnit = 'ZHG' then cast(ActualDeliveryQuantity as abap.fltp)
                                                    / cast(1000 as abap.fltp)
                                                    / cast(marm_DX.umrez as abap.fltp)
                                                    * cast(marm_DX.umren as abap.fltp)
           when DeliveryQuantityUnit = 'QZ' then cast(ActualDeliveryQuantity as abap.fltp)
                                                    / cast(marm_DX.umrez as abap.fltp)
                                                    * cast(marm_DX.umren as abap.fltp)
           when DeliveryQuantityUnit = 'QG' then cast(ActualDeliveryQuantity as abap.fltp)
                                                    / cast(marm_DX.umrez as abap.fltp)
                                                    * cast(marm_DX.umren as abap.fltp)
           when DeliveryQuantityUnit = 'WZ' then cast(ActualDeliveryQuantity as abap.fltp)
                                                    * cast(10 as abap.fltp)
                                                    / cast(marm_DX.umrez as abap.fltp)
                                                    * cast(marm_DX.umren as abap.fltp)
           else 0
      end                                                                                            as BigNumber,
      case when DeliveryQuantityUnit = 'ZHG' then cast(ActualDeliveryQuantity as abap.fltp)
                                                    / cast(1000 as abap.fltp)
                                                    / cast(marm_JA.umrez as abap.fltp)
                                                    * cast(marm_JA.umren as abap.fltp)
           when DeliveryQuantityUnit = 'QZ' then cast(ActualDeliveryQuantity as abap.fltp)
                                                    / cast(marm_JA.umrez as abap.fltp)
                                                    * cast(marm_JA.umren as abap.fltp)
           when DeliveryQuantityUnit = 'QG' then cast(ActualDeliveryQuantity as abap.fltp)
                                                    / cast(marm_JA.umrez as abap.fltp)
                                                    * cast(marm_JA.umren as abap.fltp)
           when DeliveryQuantityUnit = 'WZ' then cast(ActualDeliveryQuantity as abap.fltp)
                                                    * cast(10 as abap.fltp)
                                                    / cast(marm_JA.umrez as abap.fltp)
                                                    * cast(marm_JA.umren as abap.fltp)
           else 0
      end                                                                                            as SingerNumber,
      cast(marm_JA.umrez as abap.fltp)
        / cast(marm_JA.umren as abap.fltp)
        / cast(10 as abap.fltp)                                                                      as ProductUnit,
      cast(marm_JA.umrez as abap.fltp)
        / cast(marm_JA.umren as abap.fltp)
        * cast(_Material.MaterialGrossWeight as abap.fltp)                                           as StockUnit,
      ''                                                                                             as Note,
      0                                                                                              as OperateType,
      0                                                                                              as syncflag,

      CustEngineeringChgStatus


}
