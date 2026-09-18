/*    * PROGRAMMNAME.:TIMU004C                                               */
/*    * FUNKTION.....:CALL TIMU004R                                          */
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
  /*     GOTO       CMDLBL(RESTART)  */
             CPYF       FROMFILE(TIM/MAPBALKL) TOFILE(TIM/GRADEBAL) +
                          MBROPT(*REPLACE) CRTFILE(*NO) FMTOPT(*NOCHK)
                MONMSG     MSGID(CPF0000) EXEC(DO)
                GOTO       CMDLBL(ENDE)
             ENDDO
RESTART:
             RTVMBRD    FILE(TIM/GRADEBAL) NBRCURRCD(&RECORDS)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                GOTO       CMDLBL(ENDE)
             ENDDO
             IF         COND(&RECORDS *EQ 0) THEN(DO)
                   GOTO       CMDLBL(ENDE)
             ENDDO
             CALL       PGM(HIBACO_R)
             CALL       PGM(#DEFLDA) PARM(' ')
             CALL       PGM(TIMU004R)
             CALL       PGM(##SVRLDA) PARM('S')
ESCAPE:
      /* GOTO       CMDLBL(ENDE) */
             CALL       PGM(YS2001C)
             CALL       PGM(##SVRLDA) PARM('R')
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
