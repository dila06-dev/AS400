PGM
/* QUERY AUFBAUEN DER OFFENEN POS DATEI                    */
             RUNQRY     QRY(BAR_VERT/AHLUND2)

/* SEKTION DATEN FÜR HERRN AHLUND CSV PER MAIL 17.04.2012  */
             CVTDBF     OBJ('BARENKAMP/DB_OPEN.CSV') +
                          DBFILE(TVRELWAECO/DB_TWO_PE2) DBOUTFMT(*CSV)

/* QUERY FÜR AUTOMAIL STARTEN 2                            */
             RUNQRY     QRY(BAR_VERT/AHLUND3)







ENDPGM




























