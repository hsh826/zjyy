@AbapCatalog.sqlViewName: 'ZIBILLSTAGG'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.viewType: #BASIC
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Aggregates for billing status of the item'
define view ZI_BILLINGSTATUS_AGG

  as select from ZI_BILLINGSTATUS_BASIC

{
  key aubel,
  key aupos,

      min(GBSTK_c)    as gbstk_c,
      min(GBSTK_a)    as gbstk_b,
      min(GBSTK_a)    as gbstk_a,
      min(GBSTK_init) as gbstk_init

}
group by
  aubel,
  aupos
