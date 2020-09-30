FUNCTION-POOL zfg_bdt_events.               "MESSAGE-ID ..

* INCLUDE LZFG_BDT_EVENTSD...                " Local class definition
TYPES:
  BEGIN OF ty_s_partner,
    partner      TYPE bu_partner,
    partner_guid TYPE bu_partner_guid,
    customer     TYPE flag,
    vendor       TYPE flag,
  END OF ty_s_partner.

DATA: gt_partners TYPE TABLE OF ty_s_partner.
