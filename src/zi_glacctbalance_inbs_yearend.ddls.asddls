@AbapCatalog.sqlViewName: 'ZIBSYEAREND'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'ZI_GLAcctBalance_inBS_YearEnd'
define view ZI_GLAcctBalance_inBS_YearEnd 
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

      //      case GLAccount when '1001001000' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1002011000' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1002021000' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1002031000' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1002091000' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1012010000' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1012020000' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1012030000' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1012040000' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1012050000' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1012060000' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1012070000' then EndingBalanceAmtInCoCodeCrcy
      //                     else 0
      //                                                                    end as row_02,
      case when GLAccount between concat('1001','000000') and concat('1001','999999') then EndingBalanceAmtInCoCodeCrcy
           when GLAccount between concat('1002','000000') and concat('1002','999999') then EndingBalanceAmtInCoCodeCrcy
           when GLAccount between concat('1012','000000') and concat('1012','999999') then EndingBalanceAmtInCoCodeCrcy
           else 0
                                                                                       end as row_02,

      case when GLAccount between concat('1101','000000') and concat('1101','999999') then EndingBalanceAmtInCoCodeCrcy
           else 0
      end                                                                                  as row_03,

      case when GLAccount between concat('1121','000000') and concat('1121','999999') then EndingBalanceAmtInCoCodeCrcy
           else 0
      end                                                                                  as row_05,

      //case when GLAccount = '1122010000' and EndingBalanceAmtInCoCodeCrcy <> 0 then EndingBalanceAmtInCoCodeCrcy
      //     when GLAccount = '2203010000' and EndingBalanceAmtInCoCodeCrcy <> 0 then EndingBalanceAmtInCoCodeCrcy
      //     when GLAccount = '1231010000' and EndingBalanceAmtInCoCodeCrcy <> 0 then EndingBalanceAmtInCoCodeCrcy
      case when GLAccount = '1122010000' then EndingBalanceAmtInCoCodeCrcy
           when GLAccount = '2203010000' then EndingBalanceAmtInCoCodeCrcy
           when GLAccount = '1231010000' then EndingBalanceAmtInCoCodeCrcy
           else 0
      end                                                                                  as row_06,

      case when GLAccount = '1123010000' and EndingBalanceAmtInCoCodeCrcy > 0 then EndingBalanceAmtInCoCodeCrcy
           when GLAccount between concat('2202','000000') and concat('2202','999999') and EndingBalanceAmtInCoCodeCrcy > 0 then EndingBalanceAmtInCoCodeCrcy
           else 0
      end                                                                                  as row_07,

      case when GLAccount between concat('1221','000000') and concat('1221','999999') and EndingBalanceAmtInCoCodeCrcy > 0 then EndingBalanceAmtInCoCodeCrcy
           when GLAccount between concat('2241','000000') and concat('2241','999999') and EndingBalanceAmtInCoCodeCrcy > 0 then EndingBalanceAmtInCoCodeCrcy
           else 0
      end                                                                                  as row_08,

      //      case GLAccount when '1401010000' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1402010000' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1403010100' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1403010200' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1403010300' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1403010400' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1403010500' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1403010600' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1403010700' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1403010900' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1404010100' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1404010200' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1404010300' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1404010400' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1404010500' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1404010600' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1404010700' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1404010900' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1405010100' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1406010100' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1407010100' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1407010200' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1407010300' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1407010400' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1407010500' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1407010600' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1408010100' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1408010200' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1408010300' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1408010400' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1408010500' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1408010600' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1409010100' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1409010200' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1409010300' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1410010100' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1410010200' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1410010300' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1411010100' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1412010100' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1413010000' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1413020000' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1413030000' then EndingBalanceAmtInCoCodeCrcy
      //                     when '1471010000' then EndingBalanceAmtInCoCodeCrcy
      //                     else 0
      //      end                                                                                  as row_09,
      case when GLAccount between concat('1401','000000') and concat('1401','999999') then EndingBalanceAmtInCoCodeCrcy
           when GLAccount between concat('1402','000000') and concat('1402','999999') then EndingBalanceAmtInCoCodeCrcy
           when GLAccount between concat('1403','000000') and concat('1403','999999') then EndingBalanceAmtInCoCodeCrcy
           when GLAccount between concat('1405','000000') and concat('1405','999999') then EndingBalanceAmtInCoCodeCrcy
           when GLAccount between concat('1407','000000') and concat('1407','999999') then EndingBalanceAmtInCoCodeCrcy
           when GLAccount between concat('1409','000000') and concat('1409','999999') then EndingBalanceAmtInCoCodeCrcy
           when GLAccount between concat('1411','000000') and concat('1411','999999') then EndingBalanceAmtInCoCodeCrcy
           when GLAccount between concat('1412','000000') and concat('1412','999999') then EndingBalanceAmtInCoCodeCrcy
           when GLAccount between concat('1471','000000') and concat('1471','999999') then EndingBalanceAmtInCoCodeCrcy
           else 0
      end                                                                                  as row_09,

      case when GLAccount = '1131000000' then EndingBalanceAmtInCoCodeCrcy
           when GLAccount = '1132000000' then EndingBalanceAmtInCoCodeCrcy
           when GLAccount = '2221040000' and EndingBalanceAmtInCoCodeCrcy > 0 then EndingBalanceAmtInCoCodeCrcy
           when GLAccount = '2221050000' and EndingBalanceAmtInCoCodeCrcy > 0 then EndingBalanceAmtInCoCodeCrcy
           else 0
      end                                                                                  as row_12,

      case when GLAccount = '1511010000' and EndingBalanceAmtInCoCodeCrcy > 0 then EndingBalanceAmtInCoCodeCrcy
           when GLAccount = '1512010000' and EndingBalanceAmtInCoCodeCrcy > 0 then EndingBalanceAmtInCoCodeCrcy
           else 0
      end                                                                                  as row_18,

      case when GLAccount = '1521010000' and EndingBalanceAmtInCoCodeCrcy > 0 then EndingBalanceAmtInCoCodeCrcy
           when GLAccount = '1522010000' and EndingBalanceAmtInCoCodeCrcy > 0 then EndingBalanceAmtInCoCodeCrcy
           else 0
      end                                                                                  as row_19,


      case when GLAccount between concat('1601','000000') and concat('1601','999999') then EndingBalanceAmtInCoCodeCrcy
           when GLAccount between concat('1602','000000') and concat('1602','999999') then EndingBalanceAmtInCoCodeCrcy
           else 0
      end                                                                                  as row_20,

      //      case GLAccount when '1601010000' then DebitAmountInCoCodeCrcy
      //                     when '1601020000' then DebitAmountInCoCodeCrcy
      //                     when '1601030000' then DebitAmountInCoCodeCrcy
      //                     when '1601040000' then DebitAmountInCoCodeCrcy
      //                     when '1601050000' then DebitAmountInCoCodeCrcy
      //                     when '1602010000' then -1 * CreditAmountInCoCodeCrcy
      //                     when '1602020000' then -1 * CreditAmountInCoCodeCrcy
      //                     when '1602030000' then -1 * CreditAmountInCoCodeCrcy
      //                     when '1602040000' then -1 * CreditAmountInCoCodeCrcy
      //                     when '1602050000' then -1 * CreditAmountInCoCodeCrcy
      //                     when '1603010000' then -1 * CreditAmountInCoCodeCrcy
      //                     else 0
      //      end                                                                                  as row_20,
      case when GLAccount between concat('1604','000000') and concat('1604','999999') then EndingBalanceAmtInCoCodeCrcy
           else 0
      end                                                                                  as row_21,

      //
      //      case GLAccount when '1701010000' then DebitAmountInCoCodeCrcy
      //                     when '1701010000' then DebitAmountInCoCodeCrcy
      //                     when '1701010000' then DebitAmountInCoCodeCrcy
      //                     when '1702010000' then -1 * CreditAmountInCoCodeCrcy
      //                     when '1702010000' then -1 * CreditAmountInCoCodeCrcy
      //                     when '1702010000' then -1 * CreditAmountInCoCodeCrcy
      //                     when '1703000000' then -1 * CreditAmountInCoCodeCrcy
      //                     else 0
      //      end                                                                                  as row_24,

      case when GLAccount between concat('1701','000000') and concat('1701','999999') then EndingBalanceAmtInCoCodeCrcy
           when GLAccount between concat('1702','000000') and concat('1702','999999') then EndingBalanceAmtInCoCodeCrcy
           when GLAccount between concat('1703','000000') and concat('1703','999999') then EndingBalanceAmtInCoCodeCrcy
           else 0
      end                                                                                  as row_24,

      case when GLAccount between concat('1801','000000') and concat('1801','999999') then EndingBalanceAmtInCoCodeCrcy
           else 0
      end                                                                                  as row_27,




      case GLAccount when '2001000000' then EndingBalanceAmtInCoCodeCrcy
           else 0
      end                                                                                  as row_40,

      case when GLAccount between concat('2201','000000') and concat('2201','999999') then EndingBalanceAmtInCoCodeCrcy
           else 0
      end                                                                                  as row_43,

      //case when GLAccount between concat('2202','000000') and concat('2202','999999') and EndingBalanceAmtInCoCodeCrcy <> 0 then EndingBalanceAmtInCoCodeCrcy
      case when GLAccount between concat('2202','000000') and concat('2202','999999') then EndingBalanceAmtInCoCodeCrcy
           when GLAccount = '11230100000' and EndingBalanceAmtInCoCodeCrcy <> 0 then EndingBalanceAmtInCoCodeCrcy
           else 0
      end                                                                                  as row_44,

      //case  when GLAccount ='2203010000' and EndingBalanceAmtInCoCodeCrcy <> 0 then EndingBalanceAmtInCoCodeCrcy
      //      when GLAccount ='1122010000' and EndingBalanceAmtInCoCodeCrcy <> 0 then EndingBalanceAmtInCoCodeCrcy
      case  when GLAccount ='2203010000' then EndingBalanceAmtInCoCodeCrcy
            when GLAccount ='1122010000' then EndingBalanceAmtInCoCodeCrcy
            else 0
      end                                                                                  as row_45,

      case when GLAccount between concat('2211','000000') and concat('2211','999999') then EndingBalanceAmtInCoCodeCrcy
           else 0
      end                                                                                  as row_46,

      //      case GLAccount when '2211010000' then EndingBalanceAmtInCoCodeCrcy
      //                     when '2211020000' then EndingBalanceAmtInCoCodeCrcy
      //                     when '2211030001' then EndingBalanceAmtInCoCodeCrcy
      //                     when '2211030002' then EndingBalanceAmtInCoCodeCrcy
      //                     when '2211030003' then EndingBalanceAmtInCoCodeCrcy
      //                     when '2211030004' then EndingBalanceAmtInCoCodeCrcy
      //                     when '2211030005' then EndingBalanceAmtInCoCodeCrcy
      //                     when '2211040000' then EndingBalanceAmtInCoCodeCrcy
      //                     when '2211050000' then EndingBalanceAmtInCoCodeCrcy
      //                     when '2211060000' then EndingBalanceAmtInCoCodeCrcy
      //                     else 0
      //      end                                                                                  as row_46,

      case when GLAccount =  '2221010100' then EndingBalanceAmtInCoCodeCrcy
           when GLAccount = '2221010200' then EndingBalanceAmtInCoCodeCrcy
           when GLAccount = '2221010300' then EndingBalanceAmtInCoCodeCrcy
           when GLAccount = '2221010400' then EndingBalanceAmtInCoCodeCrcy
           when GLAccount = '2221010500' then EndingBalanceAmtInCoCodeCrcy
           when GLAccount = '2221010600' then EndingBalanceAmtInCoCodeCrcy
           when GLAccount = '2221010700' then EndingBalanceAmtInCoCodeCrcy
           when GLAccount = '2221010800' then EndingBalanceAmtInCoCodeCrcy
           when GLAccount = '2221010900' then EndingBalanceAmtInCoCodeCrcy
           when GLAccount = '2221020000' then EndingBalanceAmtInCoCodeCrcy
           when GLAccount = '2221030000' then EndingBalanceAmtInCoCodeCrcy
           when GLAccount = '2221060000' then EndingBalanceAmtInCoCodeCrcy
           when GLAccount = '2221070000' then EndingBalanceAmtInCoCodeCrcy
           when GLAccount = '2221080000' then EndingBalanceAmtInCoCodeCrcy
           when GLAccount = '2221090000' then EndingBalanceAmtInCoCodeCrcy
           when GLAccount = '2221100000' then EndingBalanceAmtInCoCodeCrcy
           when GLAccount = '2221110000' then EndingBalanceAmtInCoCodeCrcy
           when GLAccount = '2221120000' then EndingBalanceAmtInCoCodeCrcy
           when GLAccount = '2221130000' then EndingBalanceAmtInCoCodeCrcy
           when GLAccount = '2221140000' then EndingBalanceAmtInCoCodeCrcy
           when GLAccount = '2221150000' then EndingBalanceAmtInCoCodeCrcy
           when GLAccount = '2221160000' then EndingBalanceAmtInCoCodeCrcy
           when GLAccount = '2221170000' then EndingBalanceAmtInCoCodeCrcy
           when GLAccount = '2221180000' then EndingBalanceAmtInCoCodeCrcy
           when GLAccount = '2221190000' then EndingBalanceAmtInCoCodeCrcy
           when GLAccount = '2221040000' and EndingBalanceAmtInCoCodeCrcy < 0 then EndingBalanceAmtInCoCodeCrcy
           when GLAccount = '2221050000' and EndingBalanceAmtInCoCodeCrcy < 0 then EndingBalanceAmtInCoCodeCrcy
           else 0
      end                                                                                  as row_47,

      //      case GLAccount when '2241010000' then CreditAmountInCoCodeCrcy
      //                     when '2241020000' then CreditAmountInCoCodeCrcy
      //                     when '2241030000' then CreditAmountInCoCodeCrcy
      //                     when '2241040000' then CreditAmountInCoCodeCrcy
      //                     when '2241050000' then CreditAmountInCoCodeCrcy
      //                     when '2241070000' then CreditAmountInCoCodeCrcy
      //                     when '1221010000' then CreditAmountInCoCodeCrcy
      //                     when '1221020001' then CreditAmountInCoCodeCrcy
      //                     when '1221020002' then CreditAmountInCoCodeCrcy
      //                     when '1221030000' then CreditAmountInCoCodeCrcy
      //                     when '1221040000' then CreditAmountInCoCodeCrcy
      //                     when '1221050000' then CreditAmountInCoCodeCrcy
      //                     else 0
      //      end                                                                                  as row_48,

      case when GLAccount between concat('2241','000000') and concat('2241','999999') and EndingBalanceAmtInCoCodeCrcy < 0 then EndingBalanceAmtInCoCodeCrcy
           when GLAccount between concat('1221','000000') and concat('1221','999999') and EndingBalanceAmtInCoCodeCrcy < 0 then EndingBalanceAmtInCoCodeCrcy
           else 0
      end                                                                                  as row_48,

      case when GLAccount between concat('2231','000000') and concat('2231','999999') then EndingBalanceAmtInCoCodeCrcy
           when GLAccount between concat('2232','000000') and concat('2232','999999') then EndingBalanceAmtInCoCodeCrcy
           when GLAccount between concat('2242','000000') and concat('2242','999999') then EndingBalanceAmtInCoCodeCrcy
           else 0
      end                                                                                  as row_51,

      case GLAccount when '2501000000' then EndingBalanceAmtInCoCodeCrcy
                     else 0
      end                                                                                  as row_54,

      case GLAccount when '2801000000' then EndingBalanceAmtInCoCodeCrcy
                     else 0
      end                                                                                  as row_59,

      case GLAccount when '4001000000' then EndingBalanceAmtInCoCodeCrcy
                     else 0
      end                                                                                  as row_66,

      case when GLAccount between concat('4002','000000') and concat('4002','999999') then EndingBalanceAmtInCoCodeCrcy
                     else 0
      end                                                                                  as row_70,

      case when GLAccount between concat('4101','000000') and concat('4101','999999') then EndingBalanceAmtInCoCodeCrcy
                     else 0
      end                                                                                  as row_73,

      case when GLAccount between concat('4103','000000') and concat('4103','999999') then EndingBalanceAmtInCoCodeCrcy
           when GLAccount between concat('4104','000000') and concat('4104','999999') then EndingBalanceAmtInCoCodeCrcy
           when GLAccount between concat('5001','000000') and concat('6','999999999') then EndingBalanceAmtInCoCodeCrcy
                     else 0
      end                                                                                  as row_74

}
where
  Ledger = '0L' 
  and FiscalPeriod = '016'
