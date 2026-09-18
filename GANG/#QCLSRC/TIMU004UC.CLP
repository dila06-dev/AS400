/*    * PROGRAMMNAME.:TIMU004UC                                              */
/*    * FUNKTION.....:.....                                                  */
/*    *               MIT *OWNER UMWANDELN                                   */
/*    * 2004                                                                  */
/*    *                                                                       */
/*    * FASERWERKE-LINGEN GMBH                                                */
/*    * DARMER ESCH 75                                                        */
/*    * 49811 LINGEN                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/*    * 04.07.2001                                            GANG            */
/******************************************************************************/
             PGM

/*       SONSTIGES                                          */
             DCL        VAR(&FWLFIRM) TYPE(*CHAR) LEN(01)
             DCL        VAR(&RECORDS) TYPE(*DEC) LEN(10 0)
/*----------------------------------------------------------------------------*/
/*-ENVIRONMENT ANPASSEN BZW ERSTELLEN-----------------------------------------*/
             RTVDTAARA  DTAARA(FWLFIRM (1 1)) RTNVAR(&FWLFIRM)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                GOTO       CMDLBL(ENDE)
             ENDDO
             IF         COND(&FWLFIRM *EQ 'D') THEN(DO)
                   GOTO       CMDLBL(ENDE)
             ENDDO
             IF         COND(&FWLFIRM *EQ 'L') THEN(DO)
             ENDDO

             CRTDUPOBJ  OBJ(GRADEBAL) FROMLIB(EDV) OBJTYPE(*FILE) +
                          TOLIB(TIM)
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
             IF         COND(&RECORDS *EQ 0) THEN(DO)
                   GOTO       CMDLBL(ENDE)
             ENDDO
/*----------------------------------------------------------------------------*/
             GOTO       CMDLBL(ENDE)
/*          ----------------------------------------------------------       */
ENDE:
             DLTOVR     FILE(*ALL) LVL(*)
             RCLRSC
             SIGNOFF
             ENDPGM
