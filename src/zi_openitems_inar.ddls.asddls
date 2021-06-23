@AbapCatalog.sqlViewName: 'ZIOP4AR'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Open Items in AR'
define view ZI_OpenItems_inAR
  as select from           bseg as BillItem
    left outer to one join bseg as OpenItem on  OpenItem.bukrs   =  BillItem.bukrs
                                            and OpenItem.zuonr   =  BillItem.belnr
                                            and OpenItem.koart   =  BillItem.koart
                                            and OpenItem.shkzg   =  BillItem.shkzg
                                            and OpenItem.augbl   =  ''
                                            and OpenItem.h_bstat <> 'D'
                                            and OpenItem.h_bstat <> 'M'
                                            and OpenItem.xragl   =  ''
  //    left outer to one join ZI_ClearedItems_inAR as ClearedItem on ClearedItem.awkey = BillItem.awkey
{
  key BillItem.bukrs,
  key BillItem.belnr,
  key BillItem.gjahr,
  key BillItem.buzei,
      BillItem.awkey,
      cast(BillItem.dmbtr as abap.dec( 15, 2 )) as BillAmount,

      OpenItem.belnr                            as op_belnr,
      OpenItem.buzei                            as op_buzei,
      cast(
        case when OpenItem.dmbtr is null then 0
             else                             OpenItem.dmbtr
        end as abap.dec( 15, 2 ))               as OpenAmount

      //      ClearedItem.LastClearedDate               as ClearedDate

      //      cast(BillItem.dmbtr - OpenItem.dmbtr as abap.dec( 15, 2 )) as ClearedAmount
}
where
      BillItem.koart = 'D'
  and BillItem.shkzg = 'S'
  and BillItem.awtyp = 'VBRK'
