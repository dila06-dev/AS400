/*    * PROGRAMMNAME.:CALL ........                                          */
/*    * FUNKTION.....:...                                                    */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    * .                                                                     */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM

             CPYF       FROMFILE(TVRELWAECO/ORDHEADS) +
                          TOFILE(BAR_TEC/ORDHEAD)     MBROPT(*ADD) +
                          CRTFILE(*NO)
             MONMSG     MSGID(CPF0000)
             CPYF       FROMFILE(TVRELWAECO/ORDITEMS) +
                          TOFILE(BAR_TEC/ORDITEM)     MBROPT(*ADD) +
                          CRTFILE(*NO)
             MONMSG     MSGID(CPF0000)
             CPYF       FROMFILE(TVRELWAECO/ORDSHIP)  +
                          TOFILE(BAR_TEC/ORDSHIP)     MBROPT(*ADD) +
                          CRTFILE(*NO)
             MONMSG     MSGID(CPF0000)
             ENDPGM
