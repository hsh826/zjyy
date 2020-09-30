@AbapCatalog.sqlViewName: 'ZIDELIVORDR'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.viewType: #BASIC
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'MES: Erp_OutDeliveryOrder'

define view ZI_OutDeliveryOrder
  as select from I_DeliveryDocument
{
  key DeliveryDocument                as Code,
      ''                              as PurOrderCode,
      case DeliveryDocumentType when 'ZLF'  then '1'
                                when 'ZLR'  then '2'
                                when 'ZLR0' then '3'
                                when 'ZYF'  then '4'
                                when 'ZLO'  then '5'
                                when 'LB'   then '2'
                                else '0'
      end                             as BillType,
      '30'                            as SourceType,
      ShipToParty                     as SupplyCode,
      CreatedByUser                   as EmpCode,
      dats_tims_to_tstmp( DocumentDate,
                          '000000',
                          '',
                          $session.client,
                          'INITIAL' ) as BillDate,
      ''                              as Note,
      0                               as OperateType,
      DeliveryDocument                as Recid,
      tstmp_current_utctimestamp()    as Mdfdt,
      0                               as syncflag,
      ''                              as DataBatchNum
}
