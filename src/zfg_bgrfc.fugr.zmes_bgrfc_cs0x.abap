FUNCTION zmes_bgrfc_cs0x.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_STLNR) TYPE  STNUM
*"     VALUE(IV_STLAL) TYPE  STALT
*"     VALUE(IT_STLAL) TYPE  CURTO_STLAL_RANGE_T OPTIONAL
*"     VALUE(IT_OLDBOMLINE_KEY) TYPE  ZTT_BOMLINE_KEY OPTIONAL
*"     VALUE(IT_OLDPRODUCTBOMREPLACE_KEY) TYPE
*"        ZTT_PRODUCTBOMREPLACE_KEY OPTIONAL
*"     VALUE(IV_MATNR) TYPE  MATNR OPTIONAL
*"----------------------------------------------------------------------

  zcl_mes_handler_factory=>get_handler_cs0x( iv_stlnr = iv_stlnr
                                             iv_stlal = iv_stlal
*                                             it_stlal = it_stlal
                                             it_oldbomline_key = it_oldbomline_key
                                             it_oldproductbomreplace_key = it_oldproductbomreplace_key
                                             iv_matnr = iv_matnr )->replicate( ).


ENDFUNCTION.
