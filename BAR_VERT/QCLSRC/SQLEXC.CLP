PGM
             ADDLIBLE   LIB(BAR_VERT)
             CPYF       FROMFILE(BAR_VERT/DOM006) +
                          TOFILE(BAR_VERT/PSTARPT) +
                          FROMMBR(BUESCHER) TOMBR(*FIRST) +
                          MBROPT(*REPLACE) CRTFILE(*YES) OUTFMT(*CHAR)
             RUNQRY     QRY(BAR_VERT/BUESCH_0)
             RUNQRY     QRY(BAR_VERT/BUESCH_1)
             RUNQRY     QRY(BAR_VERT/BUESCH_2)
             RUNQRY     QRY(BAR_VERT/BUESCH_3)
             RUNQRY     QRY(BAR_VERT/BUESCH_4)
             RUNQRY     QRY(BAR_VERT/BUESCH_6)
             RUNQRY     QRY(BAR_VERT/RUECK_MOV)
             RMVLIBLE   LIB(BAR_VERT)

/* SEKTION DATEN FÜR QLICKVIEW                             */

             ADDLIBLE   LIB(BAR_QLIK)
             RUNQRY     QRY(BAR_QLIK/QLIK_KCJ)
             RUNQRY     QRY(BAR_QLIK/AUFSUCHE)
             RUNQRY     QRY(BAR_QLIK/RUECK_01)
             RUNQRY     QRY(BAR_QLIK/QLIK_ART)
             RUNQRY     QRY(BAR_QLIK/QLIK_ARB)
             RUNQRY     QRY(BAR_QLIK/QLIKOP01D)
             RUNQRY     QRY(BAR_QLIK/QLIK_FAK03)
             RUNQRY     QRY(BAR_QLIK/QLIK_FAK06)

/* SEKTION DATEN LAGERBESTAND FÜR QLIKVIEW HERR RECH       */
             RUNQRY     QRY(BAR_QLIK/LAGINVM_01)
             RUNQRY     QRY(BAR_QLIK/LAGINVM_02)
             RUNQRY     QRY(BAR_QLIK/LAGINVM_03)

             RMVLIBLE   LIB(BAR_QLIK)

/* SEKTION DATEN FÜR ROLOFF MIN MAX BERECHNUNGEN           */

             ADDLIBLE   LIB(BAR_VERT)
             RUNQRY     QRY(BAR_VERT/ROLOFF_A1)
             RUNQRY     QRY(BAR_VERT/ROLOFF_A2)
             RUNQRY     QRY(BAR_VERT/ROLOFF_A3)
             RUNQRY     QRY(BAR_VERT/ROLOFF_A4)
             RUNQRY     QRY(BAR_VERT/ROLOFF_A5)
             RUNQRY     QRY(BAR_VERT/ROLOFF_A6)
             RUNQRY     QRY(BAR_VERT/ROLOFF_A7)
             RMVLIBLE   LIB(BAR_VERT)

/* SEKTION DATEN FÜR CONRAD BEREITSTELLEN TÄGLICH          */
             CALL       PGM(BAR_VERT/CONRAD)

/* SEKTION DATEN FÜR DOMETIC DK BEREITSTELLEN TÄGLICH       */
             CALL       PGM(BAR_VERT/RUECKDK)

























ENDPGM
