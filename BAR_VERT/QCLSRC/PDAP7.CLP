PGM
             RUNQRY     QRY(BAR_QLIK/PDAP_AR)
             RUNQRY     QRY(BAR_QLIK/PDAP_KD)
             RUNQRY     QRY(BAR_QLIK/PDAP_LI)
             RUNQRY     QRY(BAR_QLIK/PDAP_TE)
             RUNQRY     QRY(BAR_QLIK/PDAP_WE)


             CVTDBF     OBJ('TREND/SND/PDAP7_AR.csv') +
                          DBFILE(BAR_QLIK/PDAP_AR) DBOUTFMT(*CSV) +
                          CSVSEPCHR(';') /* PDAP7 Import Daten */

             CVTDBF     OBJ('TREND/SND/PDAP7_KD.csv') +
                          DBFILE(BAR_QLIK/PDAP_KD) DBOUTFMT(*CSV) +
                          CSVSEPCHR(';') /* PDAP7 Import Daten */

             CVTDBF     OBJ('TREND/SND/PDAP7_LI.csv') +
                          DBFILE(BAR_QLIK/PDAP_LI) DBOUTFMT(*CSV) +
                          CSVSEPCHR(';') /* PDAP7 Import Daten */

             CVTDBF     OBJ('TREND/SND/PDAP7_TE.csv') +
                          DBFILE(BAR_QLIK/PDAP_TE) DBOUTFMT(*CSV) +
                          CSVSEPCHR(';') /* PDAP7 Import Daten */

             CVTDBF     OBJ('TREND/SND/PDAP7_WE.csv') +
                          DBFILE(BAR_QLIK/PDAP_WE) DBOUTFMT(*CSV) +
                          CSVSEPCHR(';') /* PDAP7 Import Daten */






ENDPGM
