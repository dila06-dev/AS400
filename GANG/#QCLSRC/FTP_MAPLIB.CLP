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

             RCLRSC

             ENDPGM
