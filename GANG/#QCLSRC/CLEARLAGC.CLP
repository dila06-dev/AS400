/*    * PROGRAMMNAME.:ÜBERNAHME ARTIKELDATEN                                 */
/*    * FUNKTION.....:INITIALISIEREN DER BEREICHE                            */
/*    * 06.07.98                                                              */
/*    *                                                                       */
/*    * Manfred Gang                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM

/*----------------------------------------------------------------------------*/
             CHGDTAARA  DTAARA(STOIN00F#) VALUE(0)
             CLRPFM     FILE(BALLENPF)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(STOTR00F)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(STODT00F)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(ELEMS00F)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(UNTBL00F)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(LOTBL00F)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(STOBL00F)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(STOIN00F)
             MONMSG     MSGID(CPF0000)
             RCLRSC

             ENDPGM
