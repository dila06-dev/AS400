PGM
             CPYF       FROMFILE(TVRELWAECO/DFOPPK) +
                          TOFILE(TVRELWAECO/BAFOPPK) +
                          MBROPT(*REPLACE) CRTFILE(*NO) INCREL((*IF +
                          OPOPST *EQ '1'))


             CPYF       FROMFILE(TVRELWAECO/DFPSKTO) +
                          TOFILE(TVRELWAECO/BAFPSKTO) +
                          MBROPT(*REPLACE) CRTFILE(*NO) INCREL((*IF +
                          P0ZBD *EQ 'DNE') (*OR P0ZBD *EQ 'DEU'))

             RUNQRY     QRY(TVRELWAECO/DIPS01) RCDSLT(*YES)
             RUNQRY     QRY(TVRELWAECO/DIPS02) RCDSLT(*YES)
             RUNQRY     QRY(TVRELWAECO/DIPS03) RCDSLT(*NO)
             RUNQRY     QRY(TVRELWAECO/DIPS04) RCDSLT(*NO)
             RUNQRY     QRY(TVRELWAECO/DIPS05) RCDSLT(*YES)
             RUNQRY     QRY(TVRELWAECO/DIPS06) RCDSLT(*YES)
             RUNQRY     QRY(TVRELWAECO/DIPS07) RCDSLT(*NO)
             RUNQRY     QRY(TVRELWAECO/DIPS08) RCDSLT(*NO)
             RUNQRY     QRY(TVRELWAECO/DIPS09) RCDSLT(*NO)
             RUNQRY     QRY(TVRELWAECO/DIPS09A) RCDSLT(*NO)
             RUNQRY     QRY(TVRELWAECO/DIPS09B) RCDSLT(*NO)
             RUNQRY     QRY(TVRELWAECO/DIPS09C) RCDSLT(*NO)

             CVTDBF     OBJ('Barenkamp/dipsA.txt') +
                          DBFILE(TVRELWAECO/DISP09A) DBOUTFMT(*CSV)

             CVTDBF     OBJ('Barenkamp/dipsB.txt') +
                          DBFILE(TVRELWAECO/DISP09B) DBOUTFMT(*CSV)

             CVTDBF     OBJ('Barenkamp/dipsC.txt') +
                          DBFILE(TVRELWAECO/DISP09C) DBOUTFMT(*CSV)






ENDPGM
