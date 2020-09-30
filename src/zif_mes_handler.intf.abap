interface ZIF_MES_HANDLER
  public .


  methods IS_TRIGGERED
    returning
      value(RV_TRIGGERED) type FLAG .
  methods REPLICATE .
endinterface.
