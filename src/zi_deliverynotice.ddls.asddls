@AbapCatalog.sqlViewName: 'ZIDELIVNOTI'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.viewType: #BASIC
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'MES: Erp_DeliveryNotice'

define view ZI_DeliveryNotice
  as select from           I_DeliveryDocument
    left outer to one join ZTF_BOLNR_Regex( clnt: $session.client ) on I_DeliveryDocument.DeliveryDocument = ZTF_BOLNR_Regex.vbeln

{
  key DeliveryDocument                                                                               as Code,
      //      _DeliveryDocumentType._Text[ 1: Language = $session.system_language ].DeliveryDocumentTypeName as BillType,
      case DeliveryDocumentType when 'ZLF'  then '1'
                                when 'ZLR'  then '2'
                                when 'ZLR0' then '3'
                                when 'ZYF'  then '4'
                                when 'ZLO'  then '5'
                                else '0'
      end                                                                                            as BillType,
      '30'                                                                                           as SourceType,
      ShipToParty                                                                                    as CustomerCode,
      _Partner[ 1: PartnerFunction = 'WE' ]._Address.StreetName                                      as ReceiveAddress,
      dats_tims_to_tstmp( DocumentDate,
                          '000000',
                          '',
                          $session.client,
                          'INITIAL' )                                                                as BillDate,
      _MeansOfTransportType._Text[ 1: Language = $session.system_language ].MeansOfTransportTypeName as DeliveryMethod,
      ''                                                                                             as Note,
      ZTF_BOLNR_Regex.bolnr_name                                                                     as TransportorName,
      ZTF_BOLNR_Regex.bolnr_phone                                                                    as TransportorPhoneNun,
      MeansOfTransport                                                                               as TransportCarNumber,
      0                                                                                              as OperateType,
      DeliveryDocument                                                                               as Recid,
      tstmp_current_utctimestamp()                                                                   as Mdfdt,
      0                                                                                              as syncflag
}
