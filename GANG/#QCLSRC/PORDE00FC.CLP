/*    * PROGRAMMNAME.:FILE-HANDLING PORDE00F IN QTEMP                        */
/*    * FUNKTION.....:LÖSCHEN BZW VORER GENERIEREN DER FILE                  */
/*    * FUNKTION.....:PORDE00F IN QTEMP                                      */
/*    * 06.07.98                                                              */
/*    *                                                                       */
/*    * Manfred Gang                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM

/*----------------------------------------------------------------------------*/
             CHKOBJ     OBJ(QTEMP/PORDE00F) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                CRTPF      FILE(QTEMP/PORDE00F) +
                          SRCFILE(UEBERNAHME/QDDSSRC) +
                          SRCMBR(PORDE00F) OPTION(*NOLIST +
                          *NOSOURCE) RECOVER(*AFTIPL) SIZE(100 10) +
                          REUSEDLT(*YES) LVLCHK(*NO)
                MONMSG     MSGID(CPF0000)
             ENDDO
/*          ---------------------------                                      */
             CLRPFM     FILE(QTEMP/PORDE00F)
             MONMSG     MSGID(CPF0000)
/*          ---------------------------                                      */
 ENDE:
             RCLRSC

             ENDPGM
