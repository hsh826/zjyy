CLASS zcl_im_badi_mes_vl0x_pre DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_ex_le_shp_delivery_proc .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_im_badi_mes_vl0x_pre IMPLEMENTATION.


  METHOD if_ex_le_shp_delivery_proc~change_delivery_header.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~change_delivery_item.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~change_fcode_attributes.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~change_field_attributes.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~check_item_deletion.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~delivery_deletion.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~delivery_final_check.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~document_number_publish.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~fill_delivery_header.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~fill_delivery_item.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~initialize_delivery.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~item_deletion.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~publish_delivery_item.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~read_delivery.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~save_and_publish_before_output.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~save_and_publish_document.

    DATA(lr_unit) = cl_bgrfc_destination_inbound=>create( 'BGRFC_INBOUND' )->create_trfc_unit( ).

    CALL FUNCTION 'ZMES_BGRFC_VL0X' IN BACKGROUND UNIT lr_unit
      EXPORTING
        it_xlikp = it_xlikp
        it_ylikp = it_ylikp.


  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~save_document_prepare.
  ENDMETHOD.
ENDCLASS.
