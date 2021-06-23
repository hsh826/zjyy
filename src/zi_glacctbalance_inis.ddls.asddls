@AbapCatalog.sqlViewName: 'ZIGLBALANCE4IS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.viewType: #BASIC
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'I_Glacctbalance in Income Statement'
/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */

define view ZI_GLAcctBalance_inIS
  with parameters
    P_FromPostingDate : fis_budat_from,
    P_ToPostingDate   : fis_budat_to

  as select from I_GLAcctBalance
                 ( P_FromPostingDate: $parameters.P_FromPostingDate, P_ToPostingDate: $parameters.P_ToPostingDate )

{
  key CompanyCode,
  key FiscalYear,
  key AccountingDocument,
  key LedgerGLLineItem,
  key FiscalPeriodDate,

      FunctionalArea,
      GLAccount,
      FiscalPeriod,
      '1' as ROW1,

      case when GLAccount between concat('6001','000000') and concat('6001','999999') then EndingBalanceAmtInCoCodeCrcy
           else 0
      end as row_02,

      case when GLAccount between concat('6051','000000') and concat('6051','999999') then EndingBalanceAmtInCoCodeCrcy
           else 0
      end as row_03,

      case when GLAccount between concat('6401','000000') and concat('6401','999999') then EndingBalanceAmtInCoCodeCrcy
      end as row_05,

      case when GLAccount between concat('6402','000000') and concat('6402','999999') then EndingBalanceAmtInCoCodeCrcy
           else 0
      end as row_06,

      case when GLAccount between concat('6403','000000') and concat('6403','999999') then EndingBalanceAmtInCoCodeCrcy
           else 0
      end as row_07,

      case when GLAccount between concat('6601','000000') and concat('6601','999999') and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
           when GLAccount between concat('6602','000000') and concat('6602','999999') and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
           when GLAccount between concat('6603','000000') and concat('6603','999999') and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
           when GLAccount between concat('6604','000000') and concat('6604','999999') and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
           when GLAccount between concat('660601','0000') and concat('660601','9999') and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
           else 0
      end as row_08,

      case when GLAccount between concat('6601','000000') and concat('6601','999999') and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
           when GLAccount between concat('6602','000000') and concat('6602','999999') and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
           when GLAccount between concat('6603','000000') and concat('6603','999999') and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
           when GLAccount between concat('6604','000000') and concat('6604','999999') and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
           when GLAccount between concat('660601','0000') and concat('660601','9999') and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
           else 0
      end as row_09,

      case when GLAccount between concat('660606','0000') and concat('660606','9999') then EndingBalanceAmtInCoCodeCrcy
           else 0
      end as row_10,

      case when GLAccount between concat('6608','000000') and concat('6608','999999') then EndingBalanceAmtInCoCodeCrcy
           else 0
      end as row_11,

      //      case when GLAccount = '6601010001' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6601010002' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6601010003' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6602010001' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6603010001' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6603010002' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6603010003' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6603010004' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6603010005' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6604010001' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010010' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010020' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010030' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010040' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010050' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010060' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010070' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010080' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010090' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010100' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010110' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010120' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010130' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010140' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010150' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010160' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010170' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010180' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010190' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010200' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010210' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010220' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010230' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010240' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010250' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010260' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010270' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010280' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010290' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010300' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010310' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010320' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010330' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010340' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010350' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010360' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010371' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010372' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010373' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010374' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010375' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010376' and FunctionalArea = '2000' then EndingBalanceAmtInCoCodeCrcy
      //           else 0
      //      end as row_04,
      //
      //      case when GLAccount = '6601010001' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6601010002' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6601010003' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6602010001' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6603010001' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6603010002' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6603010003' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6603010004' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6603010005' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6604010001' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010010' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010020' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010030' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010040' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010050' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010060' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010070' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010080' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010090' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010100' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010110' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010120' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010130' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010140' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010150' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010160' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010170' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010180' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010190' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010200' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010210' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010220' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010230' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010240' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010250' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010260' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010270' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010280' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010290' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010300' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010310' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010320' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010330' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010340' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010350' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010360' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010371' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010372' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010373' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010374' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010375' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606010376' and FunctionalArea = '1000' then EndingBalanceAmtInCoCodeCrcy
      //           else 0
      //      end as row_05,
      //
      //      case when GLAccount = '6606060100' and FunctionalArea = '3000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606060301' and FunctionalArea = '3000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606060302' and FunctionalArea = '3000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606060303' and FunctionalArea = '3000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606060304' and FunctionalArea = '3000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606060305' and FunctionalArea = '3000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606060400' and FunctionalArea = '3000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606060501' and FunctionalArea = '3000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606060502' and FunctionalArea = '3000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606060503' and FunctionalArea = '3000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606060504' and FunctionalArea = '3000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606060600' and FunctionalArea = '3000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606060700' and FunctionalArea = '3000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606060800' and FunctionalArea = '3000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606060900' and FunctionalArea = '3000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606061000' and FunctionalArea = '3000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606061100' and FunctionalArea = '3000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606061901' and FunctionalArea = '3000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606061902' and FunctionalArea = '3000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606061903' and FunctionalArea = '3000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606061904' and FunctionalArea = '3000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606061905' and FunctionalArea = '3000' then EndingBalanceAmtInCoCodeCrcy
      //           when GLAccount = '6606061906' and FunctionalArea = '3000' then EndingBalanceAmtInCoCodeCrcy
      //           else 0
      //      end as row_06,
      //
      //      case GLAccount when '6608010000' then EndingBalanceAmtInCoCodeCrcy
      //                     when '6608020000' then EndingBalanceAmtInCoCodeCrcy
      //                     when '6608030000' then EndingBalanceAmtInCoCodeCrcy
      //                     when '6608040000' then EndingBalanceAmtInCoCodeCrcy
      //                     when '6608050000' then EndingBalanceAmtInCoCodeCrcy
      //                     when '6608990000' then EndingBalanceAmtInCoCodeCrcy
      //                     else 0
      //      end as row_07,

      case GLAccount when '6608030000' then EndingBalanceAmtInCoCodeCrcy
      //case GLAccount when '6608010000' then EndingBalanceAmtInCoCodeCrcy
                     else 0
      end as row_12,

      case GLAccount when '6608040000' then EndingBalanceAmtInCoCodeCrcy
                     else 0
      end as row_13,

      case GLAccount when '6131010000' then EndingBalanceAmtInCoCodeCrcy
                     else 0
      end as row_14,

      case GLAccount when '6111010000' then EndingBalanceAmtInCoCodeCrcy
                     when '6111020000' then EndingBalanceAmtInCoCodeCrcy
                     else 0
      end as row_15,

      case GLAccount when '6101010000' then EndingBalanceAmtInCoCodeCrcy
                     else 0
      end as row_17,

      case GLAccount when '6701000000' then EndingBalanceAmtInCoCodeCrcy
                     else 0
      end as row_18,

      case GLAccount when '6121010000' then EndingBalanceAmtInCoCodeCrcy
                     else 0
      end as row_19,

      case when GLAccount between concat('6301','000000') and concat('6301','999999') then EndingBalanceAmtInCoCodeCrcy
           else 0
      end as row_21,

      case when GLAccount between concat('6711','000000') and concat('6711','999999') then EndingBalanceAmtInCoCodeCrcy
           else 0
      end as row_22,

      //            case GLAccount when '6301010000' then EndingBalanceAmtInCoCodeCrcy
      //                           when '6301020000' then EndingBalanceAmtInCoCodeCrcy
      //                           when '6301030000' then EndingBalanceAmtInCoCodeCrcy
      //                           when '6301040000' then EndingBalanceAmtInCoCodeCrcy
      //                           when '6301050000' then EndingBalanceAmtInCoCodeCrcy
      //                           when '6301060000' then EndingBalanceAmtInCoCodeCrcy
      //                           when '6301070000' then EndingBalanceAmtInCoCodeCrcy
      //                           when '6301080000' then EndingBalanceAmtInCoCodeCrcy
      //                           when '6301090000' then EndingBalanceAmtInCoCodeCrcy
      //                           else 0
      //            end as row_17,

      //            case GLAccount when '6301090000' then EndingBalanceAmtInCoCodeCrcy
      //                           when '6711020000' then EndingBalanceAmtInCoCodeCrcy
      //                           when '6711030000' then EndingBalanceAmtInCoCodeCrcy
      //                           when '6711040000' then EndingBalanceAmtInCoCodeCrcy
      //                           when '6711990000' then EndingBalanceAmtInCoCodeCrcy
      //                           else 0
      //            end as row_18,

      case GLAccount when '6801000000' then EndingBalanceAmtInCoCodeCrcy
                     else 0
      end as row_24

}
where
  Ledger = '0L'

union all select from I_GLAcctBalance
                      ( P_FromPostingDate: $parameters.P_FromPostingDate, P_ToPostingDate: $parameters.P_ToPostingDate )

{
  key CompanyCode,
  key FiscalYear,
  key AccountingDocument,
  key LedgerGLLineItem,
  key FiscalPeriodDate,

      FunctionalArea,
      GLAccount,
      FiscalPeriod,
      '2' as ROW1,

      case when GLAccount between concat('6001','000000') and concat('6001','999999') then AmountInCompanyCodeCurrency
           else 0
      end as row_02,

      case when GLAccount between concat('6051','000000') and concat('6051','999999') then AmountInCompanyCodeCurrency
           else 0
      end as row_03,

      case when GLAccount between concat('6401','000000') and concat('6401','999999') then AmountInCompanyCodeCurrency
      end as row_05,

      case when GLAccount between concat('6402','000000') and concat('6402','999999') then AmountInCompanyCodeCurrency
           else 0
      end as row_06,

      case when GLAccount between concat('6403','000000') and concat('6403','999999') then AmountInCompanyCodeCurrency
           else 0
      end as row_07,

      case when GLAccount between concat('6601','000000') and concat('6601','999999') and FunctionalArea = '2000' then AmountInCompanyCodeCurrency
           when GLAccount between concat('6602','000000') and concat('6602','999999') and FunctionalArea = '2000' then AmountInCompanyCodeCurrency
           when GLAccount between concat('6603','000000') and concat('6603','999999') and FunctionalArea = '2000' then AmountInCompanyCodeCurrency
           when GLAccount between concat('6604','000000') and concat('6604','999999') and FunctionalArea = '2000' then AmountInCompanyCodeCurrency
           when GLAccount between concat('660601','0000') and concat('660601','9999') and FunctionalArea = '2000' then AmountInCompanyCodeCurrency
           else 0
      end as row_08,

      case when GLAccount between concat('6601','000000') and concat('6601','999999') and FunctionalArea = '1000' then AmountInCompanyCodeCurrency
           when GLAccount between concat('6602','000000') and concat('6602','999999') and FunctionalArea = '1000' then AmountInCompanyCodeCurrency
           when GLAccount between concat('6603','000000') and concat('6603','999999') and FunctionalArea = '1000' then AmountInCompanyCodeCurrency
           when GLAccount between concat('6604','000000') and concat('6604','999999') and FunctionalArea = '1000' then AmountInCompanyCodeCurrency
           when GLAccount between concat('660601','0000') and concat('660601','9999') and FunctionalArea = '1000' then AmountInCompanyCodeCurrency
           else 0
      end as row_09,

      case when GLAccount between concat('660606','0000') and concat('660606','9999') then AmountInCompanyCodeCurrency
           else 0
      end as row_10,

      case when GLAccount between concat('6608','000000') and concat('6608','999999') then AmountInCompanyCodeCurrency
           else 0
      end as row_11,

      case GLAccount when '6608030000' then AmountInCompanyCodeCurrency
      //case GLAccount when '6608010000' then AmountInCompanyCodeCurrency
                     else 0
      end as row_12,

      case GLAccount when '6608040000' then AmountInCompanyCodeCurrency
                     else 0
      end as row_13,

      case GLAccount when '6131010000' then AmountInCompanyCodeCurrency
                     else 0
      end as row_14,

      case GLAccount when '6111010000' then AmountInCompanyCodeCurrency
                     when '6111020000' then AmountInCompanyCodeCurrency
                     else 0
      end as row_15,

      case GLAccount when '6101010000' then AmountInCompanyCodeCurrency
                     else 0
      end as row_17,

      case GLAccount when '6701000000' then AmountInCompanyCodeCurrency
                     else 0
      end as row_18,

      case GLAccount when '6121010000' then AmountInCompanyCodeCurrency
                     else 0
      end as row_19,

      case when GLAccount between concat('6301','000000') and concat('6301','999999') then AmountInCompanyCodeCurrency
           else 0
      end as row_21,

      case when GLAccount between concat('6711','000000') and concat('6711','999999') then AmountInCompanyCodeCurrency
           else 0
      end as row_22,

      case GLAccount when '6801000000' then AmountInCompanyCodeCurrency
                     else 0
      end as row_24

}

where
  Ledger = '0L'
