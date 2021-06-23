@AbapCatalog.sqlViewName: 'ZIPUNITCONV'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.viewType: #BASIC
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Product Unit Convert'
define view ZI_ProductUnitConvert
  as select distinct from marm as marm_l
    inner join            marm as marm_r on marm_r.matnr = marm_l.matnr
{
  key marm_l.matnr,
  key marm_l.meinh                                as num_unit,
  key marm_r.meinh                                as denom_unit,

      cast(marm_r.umrez as abap.fltp)
        / cast(marm_r.umren as abap.fltp)
        * ( cast(marm_l.umren as abap.fltp)
              / cast(marm_l.umrez as abap.fltp) ) as fator

}
