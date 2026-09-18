/*    * PROGRAMMNAME.:HIBACO_C                                               */
/*    * FUNKTION.....:CALL HIBACO_R                                          */
/*    *               DISPONIERUNG                                           */
/*    * NOVEMBER 2000                                                         */
/*    *                                                                       */
/*    * FASERWERKE-LINGEN GMBH                                                */
/*    * DARMER ESCH 75                                                        */
/*    * 49811 LINGEN                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM
             DCL        VAR(&HIB) TYPE(*DEC) LEN(13 0)
             DCL        VAR(&RECORDS) TYPE(*DEC) LEN(10 0)
             RTVDTAARA  DTAARA(HIB) RTNVAR(&HIB)
             MONMSG     MSGID(CPF0000)
             CRTDDMF    FILE(TIM/MAPBALKL) RMTFILE(QS36F/MAPBALKL) +
                          RMTLOCNAME('10.185.0.2' *IP) AUT(*ALL)
             MONMSG     MSGID(CPF0000)

             CPYF       FROMFILE(TIM/MAPBALKL) TOFILE(TIM/GRADEBAL) +
                          MBROPT(*REPLACE) CRTFILE(*NO) FMTOPT(*NOCHK)
                MONMSG     MSGID(CPF0000) EXEC(DO)
                GOTO       CMDLBL(ENDE)
             ENDDO

             RTVMBRD    FILE(TIM/GRADEBAL) NBRCURRCD(&RECORDS)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                GOTO       CMDLBL(ENDE)
             ENDDO
             CALL       PGM(HIBACO_R)
             RTVDTAARA  DTAARA(HIB) RTNVAR(&HIB)
             MONMSG     MSGID(CPF0000)
ENDE:
             RCLRSC
             ENDPGM
