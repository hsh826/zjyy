@AbapCatalog.sqlViewName: 'ZIDELIVORDRLINE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.viewType: #BASIC
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'MES: Erp_OutDeliveryOrderLine'
/*+[hideWarning] { "IDS" : [ "DOUBLE_JOIN" ]  } */

define view ZI_OutDeliveryOrderLine
  as select from I_DeliveryDocumentItem
{
  key DeliveryDocument                                                                        as OutDeliveryOrderCode,
  key DeliveryDocumentItem                                                                    as SortIndex,
      DeliveryDocumentItem                                                                    as RowNo,
      ltrim(Material,'0')                                                                     as ItemCode,
      _DeliveryQuantityUnit._Text[ 1: Language = $session.system_language ].UnitOfMeasureName as UnitSaleMainCode,
      _DeliveryQuantityUnit._Text[ 1: Language = $session.system_language ].UnitOfMeasureName as UnitSaleAuxCode,
      1                                                                                       as RateFra,
      1                                                                                       as RateNum,
      ActualDeliveryQuantity                                                                  as Qty,
      ActualDeliveryQuantity                                                                  as AuxQty,
      dats_tims_to_tstmp( _DeliveryDocument.PlannedGoodsIssueDate,
                          '000000',
                          '',
                          $session.client,
                          'INITIAL' )                                                         as RequiredDate,
      _StorageLocation.StorageLocationName                                                    as WareHouseCode,
      '30'                                                                                    as LineSourceType,
      ''                                                                                      as Note,
      case _DeliveryDocument.OverallGoodsMovementStatus when 'A' then '1'
                                                        when 'B' then '2'
                                                        when 'C' then '4'
                                                        else ''
      end                                                                                     as LineStat,
      0                                                                                       as OperateType,
      0                                                                                       as syncflag,
      tstmp_current_utctimestamp()                                                            as Mdfdt,
      ''                                                                                      as DataBatchNum

}
