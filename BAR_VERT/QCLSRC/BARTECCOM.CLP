PGM
             CVTDBF     OBJ('TECCOM/Inventory.Dat') +
                          DBFILE(BAR_TEC/INVENTORY) DBOUTFMT(*CSV) +
                          DBFLDDSC(*YES) CSVSEPCHR(';')

             CVTDBF     OBJ('TECCOM/MAterial.dat') +
                          DBFILE(BAR_TEC/MATERIAL) DBOUTFMT(*CSV) +
                          DBFLDDSC(*YES) CSVSEPCHR(';')

             CVTDBF     OBJ('TECCOM/Matprice.dat') +
                          DBFILE(BAR_TEC/MATPRICE) DBOUTFMT(*CSV) +
                          DBFLDDSC(*YES) CSVSEPCHR(';')









ENDPGM
