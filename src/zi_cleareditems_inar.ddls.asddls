@AbapCatalog.sqlViewName: 'ZICL4AR'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cleared Items in AR'
define view ZI_ClearedItems_inAR
  as select from bseg
    inner join   bseg as bsad on  bsad.bukrs   =  bseg.bukrs
                              and bsad.gjahr   =  bseg.gjahr
                              and bsad.belnr   =  bseg.belnr
                              and bsad.koart   =  'S'
                              and bseg.koart   =  'D'
                              and bseg.shkzg   =  'H'
                              and bseg.augbl   <> ''
                              and bseg.h_bstat <> 'D'
                              and bseg.h_bstat <> 'M'
{
  key bseg.zuonr,
  key bseg.bukrs,
  key bseg.gjahr,

      max( bsad.h_budat ) as LastClearedDate,
      sum( bsad.dmbtr )   as ClearedAmount
}
where
     bsad.hkont between '1001000000' and '1012999999'
  or bsad.hkont =       '1121010000'
  or bsad.hkont =       '1121020000'
group by
  bseg.zuonr,
  bseg.bukrs,
  bseg.gjahr
