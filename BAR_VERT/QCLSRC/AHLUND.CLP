PGM


/* SEKTION DATEN FÜR HERRN AHLUND CSV PER MAIL 16.04.2012  */
             CVTDBF     OBJ('BARENKAMP/DB_TWO.CSV') +
                        DBFILE(TVRELWAECO/DB_TWO_PER) DBOUTFMT(*CSV)

/* QUERY FÜR AUTOMAIL STARTEN 1                            */
             RUNQRY     QRY(BAR_VERT/AHLUND)

/* QUERY FÜR DATEI BESTELLUNGEN ERSTELLT                   */
             RUNQRY     QRY(TVRELWAECO/BEST2012)
             CVTDBF     OBJ('BARENKAMP/BEST2012.CSV') +
                          DBFILE(BAR_VERT/BEST2012) DBOUTFMT(*CSV)








ENDPGM




























