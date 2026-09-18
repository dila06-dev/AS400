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

             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             CHGVAR     VAR(&LIB) VALUE('SAVEFILE')
/*----------------------------------------------------------------------------*/

/*          OBJEKTE AUS LIB BMAP0475L                                        */
             CLRLIB     LIB(BMAP0475L)
             MONMSG     MSGID(CPF0000)
             RSTOBJ     OBJ(*ALL) SAVLIB(BMAP0475L) DEV(*SAVF) +
                          SAVF(&LIB/TBMAP0475L) MBROPT(*ALL) +
                          ALWOBJDIF(*ALL) RSTLIB(BMAP0475L)
             MONMSG     MSGID(CPF0000)

/*          OBJEKTE AUS LIB BMAP0476L                                        */
             CLRLIB     LIB(BMAP0476L)
             MONMSG     MSGID(CPF0000)
             RSTOBJ     OBJ(*ALL) SAVLIB(BMAP0476L) DEV(*SAVF) +
                          SAVF(&LIB/TBMAP0476L) MBROPT(*ALL) +
                          ALWOBJDIF(*ALL) RSTLIB(BMAP0476L)
             MONMSG     MSGID(CPF0000)

/*          OBJEKTE AUS LIB FMAPLIB                                          */
             CLRLIB     LIB(FMAPLIBS)
             MONMSG     MSGID(CPF0000)
             RSTOBJ     OBJ(*ALL) SAVLIB(FMAPLIB) DEV(*SAVF) +
                          SAVF(&LIB/TFMAPLIB) MBROPT(*ALL) +
                          ALWOBJDIF(*ALL) RSTLIB(FMAPLIBS)
             MONMSG     MSGID(CPF0000)

/*          OBJEKTE AUS LIB DMAPLIB                                          */
             CLRLIB     LIB(DMAPLIBS)
             MONMSG     MSGID(CPF0000)
             RSTOBJ     OBJ(*ALL) SAVLIB(DMAPLIB) DEV(*SAVF) +
                          SAVF(&LIB/TDMAPLIB) MBROPT(*ALL) +
                          ALWOBJDIF(*ALL) RSTLIB(DMAPLIBS)
             MONMSG     MSGID(CPF0000)

/*          LÖSCHEN DER SAVEFILES                                            */
             CLRSAVF    FILE(SAVEFILE/TBMAP0475L)
             MONMSG     MSGID(CPF0000)
             CLRSAVF    FILE(SAVEFILE/TBMAP0476L)
             MONMSG     MSGID(CPF0000)
             CLRSAVF    FILE(SAVEFILE/TFMAPLIB)
             MONMSG     MSGID(CPF0000)
             CLRSAVF    FILE(SAVEFILE/TDMAPLIB)
             MONMSG     MSGID(CPF0000)
             RCLRSC

             ENDPGM
