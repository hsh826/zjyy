*&---------------------------------------------------------------------*
*& Report YINTERN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT yintern.


DATA:BEGIN OF itab OCCURS 0,
       line(200) TYPE c,         "如果代码中某行大于了200个字符，请重新设定值，
     END OF itab.

PARAMETERS: progname(120) TYPE c."程序名称

READ REPORT progname INTO itab.  "把指定的程序读取到内表

EDITOR-CALL FOR itab.            "对内表数据进行修改（即代码进入编辑状态)

INSERT REPORT progname FROM itab."把修改后的程序插回sap
