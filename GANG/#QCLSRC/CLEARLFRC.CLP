/*    * PROGRAMMNAME.:ÜBERNAHME ARTIKELDATEN                                 */
/*    * FUNKTION.....:INITIALISIEREN DER BEREICHE KUNDENSTAMMDATEN           */
/*    * 06.07.98                                                              */
/*    *                                                                       */
/*    * Manfred Gang                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM

/*----------------------------------------------------------------------------*/
             CLRPFM     FILE(ANCLI00F)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(ANCLI10F)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(ANCLI20F)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(ANCLI98F)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(ANCLI99F)
             MONMSG     MSGID(CPF0000)
             RCLRSC

             ENDPGM
