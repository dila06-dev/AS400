PGM

/* SEKTION DATEN FÜR CONRAD BEREITSTELLEN TÄGLICH          */
             ADDLIBLE   LIB(BAR_VERT)

             RUNQRY     QRY(BAR_VERT/CONR_AR_E1)
             RUNQRY     QRY(BAR_VERT/CONR_AR_EX)
             RUNQRY     QRY(BAR_VERT/CONR_AR_E2)
             CPYF       FROMFILE(BAR_VERT/CONR_AR_EX) +
                          TOFILE(BAR_VERT/CONR_AR) MBROPT(*REPLACE) +
                          CRTFILE(*YES) FMTOPT(*NOCHK)
             CPYF       FROMFILE(BAR_VERT/CONR_AR_E2) +
                          TOFILE(BAR_VERT/CONR_AR) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)
             CLRPFM     FILE(BAR_VERT/CONR_AR#)
             CALL       PGM(BAR_VERT/CONRADR)
             RUNQRY     QRY(BAR_VERT/CONR_AR_E3)
             RMVLIBLE   LIB(BAR_VERT)
/* SPOOLDATEI WIRD VON AUTOM.CONRAD01 WEITERGELEITET MAIL */

























ENDPGM
