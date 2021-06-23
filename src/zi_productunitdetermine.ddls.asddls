@AbapCatalog.sqlViewName: 'ZIPUNITDETERM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.viewType: #BASIC
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Product Unit Determine by Package'

define view ZI_ProductUnitDetermine
  as select distinct from tmfgt
    inner join            t006a on  t006a.mseh3 = tmfgt.bezei
                                and t006a.spras = '1'
{
  key mfrgr,
  key msehi,

      tmfgt.bezei

}
where
  tmfgt.spras = '1'
