/*    * PROGRAMMNAME.:TIMU003C                                               */
/*    * FUNKTION.....:CALL TIMU005C                                          */
/*                    1) SPINNMENGEN      AUS POMS SPMG                      */
/*                    2) GEBINDEMELDUNGEN AUS POMS GB                        */
/*                    3) STOIN00F VERBUCHEN                                  */
/*                    4) AUF LOTEBENE TECHN.FELDER ANLEGEN                   */
/*                    5) AUF LOTEBENE TECHN.FELDER-AUS QM ÜBERNEHMEN         */
/*    * 2004                                                                  */
/*    *                                                                       */
/*    * FASERWERKE-LINGEN GMBH                                                */
/*    * DARMER ESCH 75                                                        */
/*    * 49811 LINGEN                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/*    * 21.06.2005                                            GANG            */
/*            SPINNMENGEN ABGEKLEMMT                                         */
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
             IF         COND(&FWLFIRM *EQ 'L') THEN(DO)
                   GOTO       CMDLBL(ENDE)
             ENDDO
             IF         COND(&FWLFIRM *EQ 'D') THEN(DO)
             ENDDO
             CALL       PGM(#DEFLDA) PARM(' ')
/*          ------------------------SPINNMENGEN      AUS POMS SPMG----       */
SPMG:
             CRTDDMF    FILE(TIM/POMS_SPMG) RMTFILE(TIM/POMS_SPMG) +
                          RMTLOCNAME('10.185.0.2' *IP) +
                          TEXT('Spinnmengen POMS')
             MONMSG     MSGID(CPF0000)
             CRTDDMF    FILE(TIM/POMS_SPMG0) RMTFILE(TIM/POMS_SPMG0) +
                          RMTLOCNAME('10.185.0.2' *IP) +
                          TEXT('Spinnmengen POMS')
             MONMSG     MSGID(CPF0000)
             RTVMBRD    FILE(TIM/POMS_SPMG) NBRCURRCD(&RECORDS)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                GOTO       CMDLBL(GB)
             ENDDO
             IF         COND(&RECORDS *EQ 0) THEN(DO)
                GOTO       CMDLBL(GB)
             ENDDO
/*           CALL       PGM(TIMU010R)  */
/*          ------------------------GEBINDEMELDUNGEN AUS POMS GB -----       */
GB:
             CRTDDMF    FILE(TIM/POMS_GBL) RMTFILE(TIM/POMS_GBL) +
                          RMTLOCNAME('10.185.0.2' *IP) +
                          TEXT('Gebindemeldungen GB')
             MONMSG     MSGID(CPF0000)
             RTVMBRD    FILE(TIM/POMS_GBL) NBRCURRCD(&RECORDS)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                GOTO       CMDLBL(YS2001C)
             ENDDO
             IF         COND(&RECORDS *EQ 0) THEN(DO)
                GOTO       CMDLBL(YS2001C)
             ENDDO
             CALL       PGM(TIMU005R)
             GOTO       CMDLBL(YS2001C)
/*          ------------------------STOIN00F VERBUCHEN ---------------       */
YS2001C:
             CALL       PGM(##SVRLDA) PARM('S')
             CALL       PGM(YS2001C)
/*             CALL       PGM(YS2001)   */
             CALL       PGM(##SVRLDA) PARM('R')
/*          ------------------------AUF LOTEBENE TECHN.FELDER---------       */
             CALL       PGM(TIMU007R)
/*          ------------------------AUF LOTEBENE TECHN.FELDER-AUS QM--       */
QM:
             CRTDDMF    FILE(TIM/POMS_QUL) RMTFILE(TIM/POMS_QUL) +
                          RMTLOCNAME('10.185.0.2' *IP) +
                          TEXT('Qualitätsmeldungen QU')
             MONMSG     MSGID(CPF0000)
             RTVMBRD    FILE(TIM/POMS_QUL) NBRCURRCD(&RECORDS)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                GOTO       CMDLBL(FAST)
             ENDDO
             IF         COND(&RECORDS *EQ 0) THEN(DO)
                GOTO       CMDLBL(FAST)
             ENDDO
             CALL       PGM(TIMU008R)
/*----------------------------------------------------------------------------*/
/*          ----------------------FAST PRODUKTIONSAUFTRÄGE VERBUCHEN--       */
/*                    1) PRODUKTIONSAUFTRÄGE POMS FAST                       */
/*                    2) DISDT00F/DISHD00F VERBUCHEN                         */
FAST:
             CRTDDMF    FILE(TIM/POMS_FASTL) RMTFILE(TIM/POMS_FASTL) +
                          RMTLOCNAME('10.185.0.2' *IP) +
                          TEXT('Produktionsmeldungen FAST')
             MONMSG     MSGID(CPF0000)
/*           POMS_FAST NICHT FÜR DIESES PROGRAMM SONDERN PROD004R */
             CRTDDMF    FILE(TIM/POMS_FAST) RMTFILE(TIM/POMS_FAST) +
                          RMTLOCNAME('10.185.0.2' *IP) +
                          TEXT('Produktionsmeldungen FAST')
             MONMSG     MSGID(CPF0000)
             RTVMBRD    FILE(TIM/POMS_FASTL) NBRCURRCD(&RECORDS)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                GOTO       CMDLBL(ENDE)
             ENDDO
             IF         COND(&RECORDS *EQ 0) THEN(DO)
                GOTO       CMDLBL(ENDE)
             ENDDO
             CALL       PGM(TIMU012R)
             GOTO       CMDLBL(ENDE)
/*          ----------------------------------------------------------       */
ENDE:
             RCLRSC
             SIGNOFF
             ENDPGM
