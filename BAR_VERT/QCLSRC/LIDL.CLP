PGM

/* SEKTION DATEN FÜR LIDL BEREITSTELLEN TÄGLICH          */
             ADDLIBLE   LIB(BAR_VERT)

             RUNQRY     QRY(BAR_VERT/LIDL_A1)



             CVTDBF     OBJ('LIDL/StockNotice.CSV') +
                          DBFILE(BAR_VERT/LIDL_A1) DBOUTFMT(*CSV) +
                          CSVSEPCHR(';') /* Lidl Bestandsdatei */







             RMVLIBLE   LIB(BAR_VERT)

















ENDPGM
