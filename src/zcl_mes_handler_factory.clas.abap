CLASS zcl_mes_handler_factory DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS: get_instance
      IMPORTING
        !iv_tcode         TYPE tcode
      EXPORTING
        VALUE(eo_handler) TYPE any ,
      get_handler_vl0x_sd
        IMPORTING
          !it_xlikp          TYPE shp_likp_t OPTIONAL
          !it_ylikp          TYPE shp_ylikp_t OPTIONAL
        RETURNING
          VALUE(ro_instance) TYPE REF TO zif_mes_handler,
      get_handler_vl0x_mm
        IMPORTING
          !it_xlikp          TYPE shp_likp_t OPTIONAL
          !it_ylikp          TYPE shp_ylikp_t OPTIONAL
        RETURNING
          VALUE(ro_instance) TYPE REF TO zif_mes_handler,
      get_handler_cs0x
        IMPORTING
          !iv_stlnr                    TYPE stnum
          !iv_stlal                    TYPE stalt
          !it_stlal                    TYPE curto_stlal_range_t OPTIONAL
          !it_oldbomline_key           TYPE ztt_bomline_key OPTIONAL
          !it_oldproductbomreplace_key TYPE ztt_productbomreplace_key OPTIONAL
          !iv_matnr                    TYPE matnr OPTIONAL
        RETURNING
          VALUE(ro_instance)           TYPE REF TO zif_mes_handler          .


  PROTECTED SECTION.
  PRIVATE SECTION.

*    CLASS-DATA mo_vl0x TYPE REF TO zcl_mes_handler_vl0x .
    CLASS-DATA mo_cs0x TYPE REF TO zcl_mes_handler_cs0x .
    CLASS-DATA mo_vl0x_sd TYPE REF TO zcl_mes_handler_vl0x_sd .
    CLASS-DATA mo_vl0x_mm TYPE REF TO zcl_mes_handler_vl0x_mm .

ENDCLASS.



CLASS zcl_mes_handler_factory IMPLEMENTATION.

  METHOD get_handler_vl0x_sd.

*    IF mo_vl0x IS NOT BOUND.
*      mo_vl0x = NEW #( ).
*      mo_vl0x->set_data( it_xlikp = it_xlikp
*                         it_ylikp = it_ylikp ).
*    ENDIF.
*    ro_instance = mo_vl0x.
    IF mo_vl0x_sd IS NOT BOUND.
      mo_vl0x_sd = NEW #( it_xlikp = it_xlikp
                          it_ylikp = it_ylikp ).
    ENDIF.
    ro_instance = mo_vl0x_sd.

  ENDMETHOD.


  METHOD get_handler_vl0x_mm.

    IF mo_vl0x_mm IS NOT BOUND.
      mo_vl0x_mm = NEW #( it_xlikp = it_xlikp
                          it_ylikp = it_ylikp ).
    ENDIF.
    ro_instance = mo_vl0x_mm.

  ENDMETHOD.


  METHOD get_instance.

    CASE iv_tcode.
      WHEN 'VL0X'.
*        IF mo_vl0x IS NOT BOUND.
*          mo_vl0x = NEW #( ).
*        ENDIF.
*        eo_handler = mo_vl0x.

      WHEN 'CS0X'.
*        IF mo_cs0x IS NOT BOUND.
*          mo_cs0x = NEW #( ).
*        ENDIF.
*        eo_handler = mo_cs0x.

      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.


  METHOD get_handler_cs0x.

    IF mo_cs0x IS NOT BOUND.
      mo_cs0x = NEW #( iv_stlnr = iv_stlnr
                       iv_stlal = iv_stlal
*                       it_stlal = it_stlal
                       it_oldbomline_key = it_oldbomline_key
                       it_oldproductbomreplace_key = it_oldproductbomreplace_key
                       iv_matnr = iv_matnr ).
    ENDIF.
    ro_instance = mo_cs0x.

  ENDMETHOD.


ENDCLASS.
