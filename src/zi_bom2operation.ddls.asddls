@AbapCatalog.sqlViewName: 'ZIBOM2OPERATION'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.viewType: #BASIC
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Allocation of BOM to Operations'

define view ZI_BOM2Operation
  as select distinct from plmz
    inner join            plas on  plas.plnty = plmz.plnty
                               and plas.plnnr = plmz.plnnr
                               and plas.plnal = plmz.plnal
                               and plas.plnfl = plmz.plnfl
                               and plas.plnkn = plmz.plnkn
                               and plas.loekz = ''
    inner join            plpo on  plpo.plnty = plas.plnty
                               and plpo.plnnr = plas.plnnr
                               and plpo.plnkn = plas.plnkn
    //                               and plpo.datuv = plas.datuv
    //                               and plpo.aennr = plas.aennr
                               and plpo.loekz = ''
    inner join            plfl on  plfl.plnty = plas.plnty
                               and plfl.plnnr = plas.plnnr
                               and plfl.plnal = plas.plnal
                               and plfl.plnfl = plas.plnfl
                               and plfl.loekz = ''
    inner join            plko on  plko.plnty = plas.plnty
                               and plko.plnnr = plas.plnnr
                               and plko.plnal = plas.plnal
                               and plko.loekz = ''
    inner join            mapl on  mapl.plnty = plas.plnty
                               and mapl.plnnr = plas.plnnr
                               and mapl.plnal = plas.plnal
                               and mapl.loekz = ''

{
  key plmz.plnty,
  key plmz.plnnr,
  key plmz.zuonr,
  key plmz.zaehl,

      plmz.plnal,
      plmz.plnfl,
      plmz.plnkn,

      plmz.stlty,
      plmz.stlnr,
      plmz.stlal,
      plmz.stlkn,

      plpo.ktsch,

      mapl.matnr,
      mapl.werks

}
where
      plas.plnty = 'N'
  and plmz.loekz = ''
