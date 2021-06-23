@AbapCatalog.sqlViewName: 'ZIBILLSTBASIC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.viewType: #BASIC
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'List of billing status of the item'
define view ZI_BILLINGSTATUS_BASIC

  as select from vbrp

{
  key vbeln,
  key posnr,

      aubel,
      aupos,

      case gbstk_ana when 'C' then 1
                 else 0
      end as GBSTK_c,

      case gbstk_ana when 'B' then 1
                 else 0
      end as GBSTK_b,
      
      case gbstk_ana when 'A' then 1
                 else 0
      end as GBSTK_a,

      case gbstk_ana when '' then 1
                 else 0
      end as GBSTK_init

}
