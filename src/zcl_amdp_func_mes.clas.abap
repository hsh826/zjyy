CLASS zcl_amdp_func_mes DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS split_bolnr FOR TABLE FUNCTION ZTF_BOLNR_Regex.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_amdp_func_mes IMPLEMENTATION.
  METHOD split_bolnr BY DATABASE FUNCTION FOR HDB
                     LANGUAGE SQLSCRIPT
                     OPTIONS READ-ONLY
                     USING likp.
    RETURN
    SELECT mandt,
           vbeln,
           substr_regexpr('[^A-Za-z0-9\s]+' IN bolnr) as bolnr_name,
           substr_regexpr('\d+' IN bolnr) as bolnr_phone
           FROM likp
           WHERE mandt = :clnt ;
  ENDMETHOD.
ENDCLASS.
