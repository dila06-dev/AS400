PGM
             ADDLIBLE   LIB(BAR_TEC)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(TVRELWAECO)
             MONMSG     MSGID(CPF0000)

             RUNQRY     QRY(BAR_TEC/#INVENTORY)
                        MONMSG     MSGID(CPF0000)

             RUNQRY     QRY(BAR_TEC/#MATERIAL)
                        MONMSG     MSGID(CPF0000)

             RUNQRY     QRY(BAR_TEC/#MATPRICE)
                        MONMSG     MSGID(CPF0000)

             RUNQRY     QRY(BAR_TEC/#MATPRISE)
                        MONMSG     MSGID(CPF0000)

/*           RUNQRY     QRY(BAR_TEC/TPARTNER)                      */
/*                      MONMSG     MSGID(CPF0000)                  */

             CALL       PGM(TVRELWAECO/TECCOMR)
             MONMSG     MSGID(CPF0000)

             RMVLIBLE   LIB(BAR_TEC)
             MONMSG     MSGID(CPF0000)
             RMVLIBLE   LIB(TVRELWAECO)
             MONMSG     MSGID(CPF0000)
ENDPGM
