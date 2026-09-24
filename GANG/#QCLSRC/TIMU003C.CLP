/*    * PROGRAMMNAME.:TIMU003C                                               */
/*    * FUNKTION.....:CALL TIMU003C                                          */
/*    *               AKTUELLE DATEN VON DER MASCHINE FWLHOST                */
/*    *               PER FTP LADEN (LIB: FWLPD)                             */
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
             DCL        VAR(&ENV)     TYPE(*CHAR) LEN(01)
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

             CRTDDMF    FILE(TIM/MAPBALKL) RMTFILE(QS36F/MAPBALKL) +
                          RMTLOCNAME('10.185.0.2' *IP) AUT(*ALL)
             MONMSG     MSGID(CPF0000)

/*----------------------------------------------------------------------------*/
/*-ENVIRONMENT ANPASSEN BZW ERSTELLEN-----------------------------------------*/
             RTVDTAARA  DTAARA(FWLFIRM (1 1)) RTNVAR(&FWLFIRM)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             GOTO       CMDLBL(ENDE)
             ENDDO
             RTVDTAARA  DTAARA(FWLFIRM (2 1)) RTNVAR(&ENV)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             GOTO       CMDLBL(ENDE)
             ENDDO
             IF         COND(&FWLFIRM *EQ 'L') THEN(DO)
             IF         COND(&ENV *NE 'M') THEN(DO)
/*              STRQMQRY   QMQRY(FMAPLIB/AKTKTRLINY) OUTPUT(*OUTFILE) +  */
                STRQMQRY   QMQRY(FMAPLIB/AKTKTRLINX) OUTPUT(*OUTFILE) +
                             OUTFILE(QTEMP/AKTBALLEN)
                MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDE))
                STRQMQRY   QMQRY(FMAPLIB/AKTKTRLIN2) OUTPUT(*OUTFILE) +
                           OUTFILE(QTEMP/AKTBALLEN) OUTMBR(*FIRST *ADD)
                MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDE))
             ENDDO
             IF         COND(&ENV *EQ 'M') THEN(DO)
               STRQMQRY   QMQRY(FMAPLIB/AKTBALLEN)  OUTPUT(*OUTFILE) +
                        OUTFILE(QTEMP/AKTBALLEN) OUTMBR(*FIRST *ADD)
                MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDE))
             ENDDO
/*          ????       WAR AM 27.07.05  EINGEFÜGT     */
  /*        GOTO       CMDLBL(ENDE)              */
                CALL       PGM(#DEFLDA) PARM(' ')
                CALL TIMU003R
            GOTO       CMDLBL(ENDE)
                CALL       PGM(##SVRLDA) PARM('S')
/*              CALL       PGM(YS2001C)           */
/*                CALL       PGM(YS2001)          */
/*      BEI MANUELLEM AUFRUF VON TIMU003C  YS2001C ANSCHL. AUFRUFEN */
                CALL       PGM(##SVRLDA) PARM('R')
                GOTO       CMDLBL(ENDE)
             ENDDO
             IF         COND(&FWLFIRM *EQ 'D') THEN(DO)
             ENDDO
/*----------------------------------------------------------------------------*/
             GOTO       CMDLBL(ENDE)
/*          ----------------------------------------------------------       */
ENDE:
             RCLRSC
             ENDPGM
