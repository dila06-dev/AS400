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

/*          ----------------------- RISK-MELDUNGEN -------------------       */
RISK:
             CRTDDMF    FILE(TIM/MAPBALKL) RMTFILE(QS36F/MAPBALKL) +
                          RMTLOCNAME('10.185.0.2' *IP) AUT(*ALL)
             MONMSG     MSGID(CPF0000)

             DSPPFM     FILE(TIM/MAPBALKL)
             MONMSG     MSGID(CPF0000)
             GOTO       CMDLBL(ENDE)
/*          ----------------------------------------------------------       */
ENDE:
             RCLRSC
             ENDPGM
