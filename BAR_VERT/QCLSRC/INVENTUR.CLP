PGM

             CPYF       FROMFILE(TVRELWAECO/INVENT02) +
                       TOFILE(TVRELWAECO/#INVENT02) MBROPT(*ADD) +
                       CRTFILE(*YES)
             MONMSG     MSGID(CPF0000)
       /* AUSGABE  TVRELWAECO/INVENT02                     */
             RUNQRY     QRY(TVRELWAECO/INVENT201X)

       /* AUSGABE  TVRELWAECO/INVENT03                     */
             RUNQRY     QRY(TVRELWAECO/INVENT201Y)

       /* AUSGABE  TVRELWAECO/INVENT01                     */
             RUNQRY     QRY(TVRELWAECO/INVENT2011)

       /* AUSGABE  BAR_VERT/INVLAG2012                   */
             RUNQRY     QRY(BAR_VERT/INVLAG2012)

       /* AUSGABE  BAR_VERT/INVPOS2012                   */
             RUNQRY     QRY(BAR_VERT/INVPOS2012)

       /* AUSGABE  BAR_VERT/INVENTBDO                    */
             RUNQRY     QRY(BAR_VERT/INVPRUF2)
       /*    RUNQRY     QRY(BAR_VERT/INVPRUF2)           */
             CPYF       FROMFILE(TVRELWAECO/INVENT02) +
                       TOFILE(TVRELWAECO/##INVENT02) MBROPT(*ADD) +
                       CRTFILE(*YES)
             MONMSG     MSGID(CPF0000)
























ENDPGM
