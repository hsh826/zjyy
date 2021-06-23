@AbapCatalog.sqlViewName: 'ZIRSTGR'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.viewType: #BASIC
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'RSTGR in BSEG'
define view ZI_RSTGR
  as select from bseg
{
  key bukrs,
  key belnr,
  key gjahr,
  key cast(concat('000',buzei) as abap.numc( 6 )) as buzei,
      rstgr

}
