/*    * PROGRAMMNAME.:KASSNERC                                               */
/*    * FUNKTION.....:::::                                                   */
/*    * 2004                                                                  */
/*    *                                                                       */
/*    * FASERWERKE-LINGEN GMBH                                                */
/*    * DARMER ESCH 75                                                        */
/*    * 49811 LINGEN                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/*    * 21.06.2005                                            GANG            */
/*                                                                           */
/******************************************************************************/
             PGM

/*          ------------------------GEBINDEMELDUNGEN AUS POMS GB -----       */
GB:
             CLRPFM     KASSNER
             MONMSG     MSGID(CPF0000)
             CPYF       FROMFILE(TIM/POMS_GBL) TOFILE(*LIBL/KASSNER) +
                          MBROPT(*REPLACE) CRTFILE(*NO) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF0000)
             DSPPFM     FILE(KASSNER)
             MONMSG     MSGID(CPF0000)
             GOTO       CMDLBL(ENDE)
/*          ----------------------------------------------------------       */
ENDE:
             RCLRSC
             ENDPGM
