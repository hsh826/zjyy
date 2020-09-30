@EndUserText.label: 'BOLNR splitting by regex'
define table function ZTF_BOLNR_Regex
  with parameters
    @Environment.systemField: #CLIENT
    clnt : abap.clnt
returns
{
  mandt       : mandt;
  vbeln       : vbeln_vl;
  bolnr_name  : bolnr;
  bolnr_phone : bolnr;
}
implemented by method
  zcl_amdp_func_mes=>split_bolnr;