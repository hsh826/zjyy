@AbapCatalog.sqlViewName: 'ZIGLBALANCE4CF'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.viewType: #BASIC
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'I_GLAcctBalance in Cash Flow'
define view ZI_GLAcctBalance_inCF
  with parameters
    P_FromPostingDate : fis_budat_from,
    P_ToPostingDate   : fis_budat_to

  as select from I_GLAcctBalance
                 ( P_FromPostingDate: $parameters.P_FromPostingDate, P_ToPostingDate: $parameters.P_ToPostingDate )
    inner join   ZI_RSTGR on  ZI_RSTGR.bukrs = I_GLAcctBalance.CompanyCode
                          and ZI_RSTGR.belnr = I_GLAcctBalance.AccountingDocument
                          and ZI_RSTGR.gjahr = I_GLAcctBalance.FiscalYear
                          and ZI_RSTGR.buzei = I_GLAcctBalance.LedgerGLLineItem
{
  key CompanyCode,
  key FiscalYear,
  key AccountingDocument,
  key LedgerGLLineItem,
  key FiscalPeriodDate,

      FunctionalArea,
      GLAccount,
      FiscalPeriod,
      rstgr,
      case when GLAccount between concat('1001','000000') and concat('1001','999999') then AmountInCompanyCodeCurrency
                when GLAccount between concat('1002','000000') and concat('1002','999999') then AmountInCompanyCodeCurrency
                when GLAccount between concat('1012','000000') and concat('1012','999999') then AmountInCompanyCodeCurrency
                else 0
                                                                                           end    as CurrAmount,

      case when GLAccount between concat('1001','000000') and concat('1001','999999') then EndingBalanceAmtInCoCodeCrcy
                   when GLAccount between concat('1002','000000') and concat('1002','999999') then EndingBalanceAmtInCoCodeCrcy
                   when GLAccount between concat('1012','000000') and concat('1012','999999') then EndingBalanceAmtInCoCodeCrcy
                   else 0
                                                                                              end as EndAmount

}
where
  Ledger = '0L'
