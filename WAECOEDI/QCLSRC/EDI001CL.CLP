PGM
             ADDLIBLE   LIB(BAR_FRA)

             CPYF       FROMFILE(BAR_FRA/NAVHEAD01) +
                          TOFILE(BAR_FRA/WWWORD10) FROMMBR(*FIRST) +
                          MBROPT(*REPLACE) FMTOPT(*CVTSRC)
/*                      MONMSG     MSGID(CPF0000)             */
             CPYF       FROMFILE(BAR_FRA/NAVLINE01) +
                          TOFILE(BAR_FRA/WWWORD51) FROMMBR(*FIRST) +
                          MBROPT(*REPLACE) FMTOPT(*CVTSRC)
/*                      MONMSG     MSGID(CPF0000)             */
             CPYF       FROMFILE(BAR_FRA/NAVLINE01) +
                          TOFILE(BAR_FRA/WWWORD50) FROMMBR(*FIRST) +
                          MBROPT(*REPLACE) FMTOPT(*CVTSRC)
/*                      MONMSG     MSGID(CPF0000)             */
             CPYF       FROMFILE(BAR_FRA/NAVHEAD01) +
                          TOFILE(BAR_FRA/WWWORD10FR) +
                          FROMMBR(*FIRST) MBROPT(*ADD) FMTOPT(*CVTSRC)
/*                      MONMSG     MSGID(CPF0000)             */
             CPYF       FROMFILE(BAR_FRA/NAVLINE01) +
                          TOFILE(BAR_FRA/WWWORD50FR) +
                          FROMMBR(*FIRST) MBROPT(*ADD) FMTOPT(*CVTSRC)
/*                      MONMSG     MSGID(CPF0000)             */
             CPYF       FROMFILE(BAR_FRA/NAVHEAD01) +
                          TOFILE(WAECOEDI/WWWORD10) FROMMBR(*FIRST) +
                          MBROPT(*ADD) FMTOPT(*CVTSRC)
/*                      MONMSG     MSGID(CPF0000)             */
             CPYF       FROMFILE(BAR_FRA/NAVLINE01) +
                          TOFILE(WAECOEDI/WWWORD50) FROMMBR(*FIRST) +
                          MBROPT(*ADD) FMTOPT(*CVTSRC)
/*                      MONMSG     MSGID(CPF0000)             */
             CPYF       FROMFILE(BAR_FRA/NAVLINE01) +
                          TOFILE(WAECOEDI/WWWORD51) FROMMBR(*FIRST) +
                          MBROPT(*ADD) FMTOPT(*CVTSRC)
/*                      MONMSG     MSGID(CPF0000)             */
             CLRPFM     FILE(BAR_FRA/NAVHEAD01)
/*                      MONMSG     MSGID(CPF0000)             */
             CLRPFM     FILE(BAR_FRA/NAVLINE01)
/*                      MONMSG     MSGID(CPF0000)             */

             RMVLIBLE   LIB(BAR_FRA)
ENDPGM
