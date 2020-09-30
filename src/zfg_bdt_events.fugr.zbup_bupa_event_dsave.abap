FUNCTION zbup_bupa_event_dsave.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"----------------------------------------------------------------------

*  DATA:
*    lt_but000        TYPE TABLE OF bus000___i,
*    lt_but000_temp   TYPE TABLE OF bus000___i,
*    lt_but0bk        TYPE TABLE OF but0bk,
*    lt_but100        TYPE TABLE OF but100,
*    lt_but0cc        TYPE TABLE OF but0cc,
*    lt_but0is        TYPE TABLE OF but0is,
*    lt_but0id        TYPE TABLE OF but0id,
*    lt_but020        TYPE TABLE OF bus020___i,
*    lt_but021_fs     TYPE TABLE OF bus021_fs_i,
*    lt_but000_old    TYPE TABLE OF bus000___i,
*    lt_but0bk_old    TYPE TABLE OF but0bk,
*    lt_but100_old    TYPE TABLE OF but100,
*    lt_but0cc_old    TYPE TABLE OF but0cc,
*    lt_but0is_old    TYPE TABLE OF but0is,
*    lt_but0id_old    TYPE TABLE OF but0id,
*    lt_but020_old    TYPE TABLE OF bus020___i,
*    lt_but021_fs_old TYPE TABLE OF bus021_fs_i.
*
*
*  CALL FUNCTION 'BUP_MEMORY_GET_ALL'
*    TABLES
*      t_but000        = lt_but000
*      t_but000_temp   = lt_but000_temp
*      t_but0bk        = lt_but0bk
*      t_but100        = lt_but100
*      t_but0cc        = lt_but0cc
*      t_but0is        = lt_but0is
*      t_but0id        = lt_but0id
*      t_but020        = lt_but020
*      t_but021_fs     = lt_but021_fs
*      t_but000_old    = lt_but000_old
*      t_but0bk_old    = lt_but0bk_old
*      t_but100_old    = lt_but100_old
*      t_but0cc_old    = lt_but0cc_old
*      t_but0is_old    = lt_but0is_old
*      t_but0id_old    = lt_but0id_old
*      t_but020_old    = lt_but020_old
*      t_but021_fs_old = lt_but021_fs_old.
*
*
*  EXIT.

*  DATA:
*    lt_but000       TYPE TABLE OF bus000___i,
*    lt_but000_td    TYPE TABLE OF but000_td,
*    lt_but001       TYPE TABLE OF bus001updt,
*    lt_but0bk       TYPE TABLE OF but0bk,
*    lt_but100       TYPE TABLE OF but100,
*    lt_but0cc       TYPE TABLE OF but0cc,
*    lt_but0is       TYPE TABLE OF but0is,
*    lt_but0id       TYPE TABLE OF but0id,
*    lt_partner_ext  TYPE bus_partnr_t,
*    lt_partnerroles TYPE TABLE OF bup_partnerroles.
*
*
*  CALL FUNCTION 'BUP_BUPA_MEMORY_GET_ALL'
*    EXPORTING
*      i_xwa          = 'X'
*    TABLES
*      t_but000       = lt_but000
*      t_but000_td    = lt_but000_td
*      t_but001       = lt_but001
*      t_but0bk       = lt_but0bk
*      t_but100       = lt_but100
*      t_but0cc       = lt_but0cc
*      t_but0is       = lt_but0is
*      t_but0id       = lt_but0id
*      t_partner_ext  = lt_partner_ext
*      t_partnerroles = lt_partnerroles.

ENDFUNCTION.
