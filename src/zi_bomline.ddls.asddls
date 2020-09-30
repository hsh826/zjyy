@AbapCatalog.sqlViewName: 'ZIBOMLINE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.viewType: #BASIC
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'MES: Erp_BomLine'

define view ZI_BomLine
  as select distinct from   stas
    inner join              stpo                     on  stpo.stlty = stas.stlty
                                                     and stpo.stlnr = stas.stlnr
                                                     and stpo.stlkn = stas.stlkn
    //                                                     and stpo.datuv = stas.datuv
    //                                                     and stpo.aennr = stas.aennr
                                                     and stpo.lkenz = ''
    inner join              stko                     on  stko.stlty = stas.stlty
                                                     and stko.stlnr = stas.stlnr
                                                     and stko.stlal = stas.stlal
                                                     and stko.stlst = '01'
                                                     and stko.lkenz = ''
    inner join              mast                     on  mast.stlnr = stas.stlnr
                                                     and mast.stlal = stas.stlal
                                                     and mast.stlan = '1'
    left outer to many join ZI_BOM2Operation as zOps on  zOps.stlty = stas.stlty
                                                     and zOps.stlnr = stas.stlnr
                                                     and zOps.stlal = stas.stlal
                                                     and zOps.stlkn = stas.stvkn
                                                     and zOps.matnr = mast.matnr
                                                     and zOps.werks = mast.werks
    left outer to one join  t006a                    on  t006a.msehi = stpo.meins
                                                     and t006a.spras = $session.system_language

{
  key stas.stlnr,
  key stas.stlal                         as BomCode,
  key stas.stvkn                         as SortIndex,
  key concat(zOps.plnnr, zOps.plnal)     as RoutingCode,
      mast.matnr                         as ProductCode,
      zOps.ktsch                         as ProcessCode,
      stpo.idnrk                         as ItemCode,
      t006a.mseht                        as UnitName,
      stpo.meins                         as UnitCode,
      cast(stpo.menge as ze_mes_dec31_6) as Amount,
      //      cast(stpo.menge as ze_mes_dec31_6) as Amount_replace,
      stpo.ausch                         as LossRate,
      ''                                 as Note,
      cast(stko.bmeng as ze_mes_dec31_6) as BomQty,
      0                                  as OperateType,
      tstmp_current_utctimestamp()       as Mdfdt,
      0                                  as syncflag,

      stpo.alpgr,
      stpo.alprf

}
where
      stas.lkenz = ''
  and stas.stlty = 'M'
