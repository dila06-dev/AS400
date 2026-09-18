/*    * PROGRAMMNAME.:TIMU004C                                               */
/*    * FUNKTION.....:CALL TIMU004R                                          */
/*    *               MIT *OWNER UMWANDELN                                   */
/*    *               PARAMETER: B = ÜBERNAHME KLASSIERT U.UNKLASSIERT       */
/*    *               PARAMETER: K = ÜBERNAHME KLASSIERT                     */
/*    *               PARAMETER: U = ÜBERNAHME UNKLASSIERT                   */
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
             PGM        PARM(&MODUS)

/*       SONSTIGES                                          */
             DCL        VAR(&FWLFIRM) TYPE(*CHAR) LEN(01)
             DCL        VAR(&ENV)     TYPE(*CHAR) LEN(01)
             DCL        VAR(&RECORDS) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&MODUS)   TYPE(*CHAR) LEN(1)
/*----------------------------------------------------------------------------*/
/*-ENVIRONMENT ANPASSEN BZW ERSTELLEN-----------------------------------------*/
             RTVDTAARA  DTAARA(FWLFIRM (1 1)) RTNVAR(&FWLFIRM)
             RTVDTAARA  DTAARA(FWLFIRM (2 1)) RTNVAR(&ENV)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                GOTO       CMDLBL(ENDE)
             ENDDO
             IF         COND(&FWLFIRM *EQ 'D') THEN(DO)
                   GOTO       CMDLBL(ENDE)
             ENDDO
             IF         COND(&FWLFIRM *EQ 'L') THEN(DO)
             ENDDO
             IF         COND(&ENV     *NE 'T') THEN(DO)
                   GOTO       CMDLBL(ENDE)
             ENDDO
             CRTDDMF    FILE(TIM/HIBACDAT) RMTFILE(FWLPD/HIBACDAT) +
                          RMTLOCNAME('10.185.0.2' *IP) AUT(*ALL)
             MONMSG     MSGID(CPF0000)
             CRTDDMF    FILE(TIM/HIBACIND) RMTFILE(FWLPD/HIBACIND) +
                          RMTLOCNAME('10.185.0.2' *IP) AUT(*ALL)
             MONMSG     MSGID(CPF0000)
             CRTDDMF    FILE(TIM/HIBACINF) RMTFILE(FWLPD/HIBACINF) +
                          RMTLOCNAME('10.185.0.2' *IP) AUT(*ALL)
             MONMSG     MSGID(CPF0000)
             CRTDDMF    FILE(TIM/HIBACMDO) RMTFILE(FWLPD/HIBACMDO) +
                          RMTLOCNAME('10.185.0.2' *IP) AUT(*ALL)
             MONMSG     MSGID(CPF0000)
             CRTDDMF    FILE(TIM/HIBACO) RMTFILE(FWLPD/HIBACO) +
                          RMTLOCNAME('10.185.0.2' *IP) AUT(*ALL)
             MONMSG     MSGID(CPF0000)
             CRTDDMF    FILE(TIM/HIBACOHLD) RMTFILE(FWLPD/HIBACOHLD) +
                          RMTLOCNAME('10.185.0.2' *IP) AUT(*ALL)
             MONMSG     MSGID(CPF0000)
             CRTDDMF    FILE(TIM/HIBACPRD) RMTFILE(FWLPD/HIBACPRD) +
                          RMTLOCNAME('10.185.0.2' *IP) AUT(*ALL)
             MONMSG     MSGID(CPF0000)

             CRTDDMF    FILE(TIM/FDFWLMME)  RMTFILE(QS36F/FDFWLMME) +
                          RMTLOCNAME('10.185.0.2' *IP) AUT(*ALL)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(FDFWLMME) TOFILE(TIM/FDFWLMME) +
                          MBR(*FIRST) OVRSCOPE(*CALLLVL)

             CRTDUPOBJ  OBJ(GRADEBAL) FROMLIB(EDV) OBJTYPE(*FILE) +
                          TOLIB(TIM)
             MONMSG     MSGID(CPF0000)
             CRTDDMF    FILE(TIM/MAPBALKL) RMTFILE(QS36F/MAPBALKL) +
                          RMTLOCNAME('10.185.0.2' *IP) AUT(*ALL)
             MONMSG     MSGID(CPF0000)
             CRTDDMF    FILE(TIM/MAPBALUN) RMTFILE(QS36F/GRADEBAL) +
                          RMTLOCNAME('10.185.0.2' *IP) AUT(*ALL)
             MONMSG     MSGID(CPF0000)
             CRTDDMF    FILE(TIM/BALECOLL) RMTFILE(QS36F/BALECOLL) +
                          RMTLOCNAME('10.185.0.2' *IP) AUT(*ALL)
             MONMSG     MSGID(CPF0000)

/*----------------------------------------------------------------------------*/
/*     TIM/GRADEBAL LÖSCHEN                                                  */
          IF         COND(&MODUS *NE ' ') THEN(DO)
             CLRPFM     FILE(TIM/GRADEBAL)
             MONMSG     MSGID(CPF0000)
          ENDDO
/*     K L A S S I E R T E  PRODUKTION                                       */
          IF         COND(&MODUS *EQ 'K' *OR &MODUS *EQ 'B') +
                          THEN(DO)
             CPYF       FROMFILE(TIM/MAPBALKL) TOFILE(TIM/GRADEBAL) +
                         MBROPT(*ADD) CRTFILE(*NO) FMTOPT(*NOCHK)
                MONMSG   MSGID(CPF0000) EXEC(DO)
                GOTO     CMDLBL(ENDE)
             ENDDO
          ENDDO
/*     U N K L A S S I E R T E  PRODUKTION  UND ZUSÄTZLICH DIE               */
/*     BIS DATO AUFGELAUFENE GEMELDETE PRODUKTION VOM RISK-RECHNER           */
          IF         COND(&MODUS *EQ 'U' *OR &MODUS *EQ 'B') +
                          THEN(DO)
             CPYF       FROMFILE(TIM/MAPBALUN) TOFILE(TIM/GRADEBAL) +
                         MBROPT(*ADD) CRTFILE(*NO) FMTOPT(*NOCHK)
                MONMSG   MSGID(CPF0000) EXEC(DO)
                GOTO     CMDLBL(ENDE)
             ENDDO
             CPYF       FROMFILE(TIM/BALECOLL) TOFILE(TIM/GRADEBAL) +
                         MBROPT(*ADD) CRTFILE(*NO) FMTOPT(*NOCHK)
                MONMSG   MSGID(CPF0000) EXEC(DO)
                GOTO     CMDLBL(ENDE)
             ENDDO
          ENDDO
/*----------------------------------------------------------------------------*/
/*     NACH TEST AKTIVIEREN   GRADEBAL_T UNKLASSIERTE PROD TEST              */
          IF         COND(&MODUS *EQ '0' *OR &MODUS *EQ '0') +
                          THEN(DO)
             CPYF       FROMFILE(TIM/GRADEBAL_T) TOFILE(TIM/GRADEBAL) +
                        MBROPT(*REPLACE) CRTFILE(*NO) FMTOPT(*NOCHK)
                MONMSG     MSGID(CPF0000) EXEC(DO)
                GOTO       CMDLBL(ENDE)
             ENDDO
          ENDDO

             RTVMBRD    FILE(TIM/GRADEBAL) NBRCURRCD(&RECORDS)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                GOTO       CMDLBL(ENDE)
             ENDDO
             IF         COND(&RECORDS *EQ 0) THEN(DO)
                   GOTO       CMDLBL(ENDE)
             ENDDO
             CALL       PGM(#DEFLDA) PARM(' ')
             CALL       PGM(TIMU004R2)
             CALL       PGM(##SVRLDA) PARM('S')
             CALL       PGM(YS2001C)
             CALL       PGM(##SVRLDA) PARM('R')
/*     NACH TEST RAUS                                                        */
        GOTO       CMDLBL(ENDE)
/*     NACH TEST RAUS                                                        */
/* FELD GRUDAT (UPDATE DATUM) AUF AKTUELLES DATUM JJMMTT SETZEN IN GRADEBAL   */
             STRQMQRY   QMQRY(UEBERNAHME/GRADEBAL)
             MONMSG     MSGID(CPF0000)
             CPYF       FROMFILE(TIM/GRADEBAL) +
                          TOFILE(TIM/GRADEBAL_H) MBROPT(*ADD) +
                          CRTFILE(*NO)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(TIM/MAPBALKL)
                MONMSG     MSGID(CPF0000) EXEC(DO)
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
