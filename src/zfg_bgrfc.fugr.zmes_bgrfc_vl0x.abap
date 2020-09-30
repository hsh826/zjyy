FUNCTION zmes_bgrfc_vl0x.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IT_XLIKP) TYPE  SHP_LIKP_T OPTIONAL
*"     VALUE(IT_YLIKP) TYPE  SHP_YLIKP_T OPTIONAL
*"----------------------------------------------------------------------
*  DATA: lo_handler TYPE REF TO zcl_mes_handler_vl0x.
*
*  zcl_mes_handler_factory=>get_instance( EXPORTING iv_tcode = 'VL0X'
*                                         IMPORTING eo_handler = lo_handler ).
*
*  lo_handler->set_data( EXPORTING it_xlikp = it_xlikp
*                                  it_ylikp = it_ylikp ).
*
*  IF lo_handler->is_triggered( ) = abap_true.
*    lo_handler->replicate( ).
*  ENDIF.
  IF  it_xlikp[ 1 ]-lfart = 'LB'.
    DATA(lo_handler) = zcl_mes_handler_factory=>get_handler_vl0x_mm( it_xlikp = it_xlikp
                                                                     it_ylikp = it_ylikp ).
  ELSE.
    lo_handler = zcl_mes_handler_factory=>get_handler_vl0x_sd( it_xlikp = it_xlikp
                                                               it_ylikp = it_ylikp ).
  ENDIF.

  IF lo_handler->is_triggered( ) = abap_true.
    lo_handler->replicate( ).
  ENDIF.


ENDFUNCTION.
