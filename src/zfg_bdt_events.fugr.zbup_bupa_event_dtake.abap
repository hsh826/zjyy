FUNCTION zbup_bupa_event_dtake.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"----------------------------------------------------------------------

  DATA:
    lt_but000  TYPE TABLE OF bus000___i,
*    lt_but000_td    TYPE TABLE OF but000_td,
*    lt_but001       TYPE TABLE OF bus001updt,
*    lt_but0bk       TYPE TABLE OF but0bk,
    lt_but100  TYPE TABLE OF but100,
*    lt_but0cc       TYPE TABLE OF but0cc,
*    lt_but0is       TYPE TABLE OF but0is,
*    lt_but0id       TYPE TABLE OF but0id,
*    lt_partner_ext  TYPE bus_partnr_t,
*    lt_partnerroles TYPE TABLE OF bup_partnerroles,
    ls_partner TYPE ty_s_partner.


  CALL FUNCTION 'BUP_BUPA_MEMORY_GET_ALL'
    EXPORTING
      i_xwa    = 'X'
    TABLES
      t_but000 = lt_but000
*     t_but000_td    = lt_but000_td
*     t_but001 = lt_but001
*     t_but0bk = lt_but0bk
      t_but100 = lt_but100
*     t_but0cc = lt_but0cc
*     t_but0is = lt_but0is
*     t_but0id = lt_but0id
*     t_partner_ext  = lt_partner_ext
*     t_partnerroles = lt_partnerroles
    .

  CONVERT DATE sy-datum INTO TIME STAMP DATA(lv_curr_timestamp) TIME ZONE ''.
  CONVERT DATE '99991231' INTO TIME STAMP DATA(lv_end_timestamp) TIME ZONE ''.

  LOOP AT lt_but000 INTO DATA(ls_but000) WHERE type = '2'.
    IF lt_but100 IS NOT INITIAL.
      LOOP AT lt_but100 INTO DATA(ls_role) WHERE partner = ls_but000-partner
                                             AND ( rltyp = 'FLCU01' OR rltyp = 'FLVN01' ).
        IF ls_role-valid_from GT lv_curr_timestamp.
          MESSAGE e002(zmes_intf) WITH ls_role-valid_from.
          RETURN.
        ENDIF.
        IF ls_role-valid_to LT lv_end_timestamp.
          MESSAGE e001(zmes_intf).
          RETURN.
        ENDIF.
      ENDLOOP.
    ENDIF.

    SELECT COUNT(*) FROM but000 WHERE partner = ls_but000-partner.
    IF sy-subrc = 0.
      ls_partner = ls_but000-partner.

      SELECT COUNT(*) FROM but100 WHERE partner = ls_but000-partner
                                    AND rltyp = 'FLCU01'
                                    AND dfval = ''
                                    AND ( valid_from LE lv_curr_timestamp AND valid_to GE lv_curr_timestamp ).
      IF sy-subrc = 0.
        ls_partner-customer = 'X'.
      ENDIF.
      SELECT COUNT(*) FROM but100 WHERE partner = ls_but000-partner
                                    AND rltyp = 'FLVN01'
                                    AND dfval = ''
                                    AND ( valid_from LE lv_curr_timestamp AND valid_to GE lv_curr_timestamp ).
      IF sy-subrc = 0.
        ls_partner-vendor = 'X'.
      ENDIF.

    ELSE.
      ls_partner-partner_guid = ls_but000-partner_guid.

    ENDIF.

    APPEND ls_partner TO gt_partners.

    IF sy-tabix > 1.
      ASSERT 1 = 2.
    ENDIF.

  ENDLOOP.


ENDFUNCTION.
