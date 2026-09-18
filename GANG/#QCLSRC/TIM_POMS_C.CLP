/*    * PROGRAMMNAME.:TIM_POMS_C                                             */
/*    * FUNKTION.....:CALL TIM_POMS_R                                        */
/*    *               CALL-FUNKTION  MIT *OWNER ÜBERSETZEN                   */
/*    * NOVEMBER 2000                                                         */
/*    *                                                                       */
/*    * FASERWERKE-LINGEN GMBH                                                */
/*    * DARMER ESCH 75                                                        */
/*    * 49811 LINGEN                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&AUFTRAG)
             DCL        VAR(&AUFTRAG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FWLFIRM) TYPE(*CHAR) LEN(01)
             DCL        VAR(&ENV)     TYPE(*CHAR) LEN(01)
             DCL        VAR(&RECORDS) TYPE(*DEC) LEN(10 0)
/*-ENVIRONMENT ANPASSEN BZW ERSTELLEN-----------------------------------------*/
             RTVDTAARA  DTAARA(FWLFIRM (1 1)) RTNVAR(&FWLFIRM)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             GOTO       CMDLBL(ENDE)
             ENDDO
             RTVDTAARA  DTAARA(FWLFIRM (2 1)) RTNVAR(&ENV)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             GOTO       CMDLBL(ENDE)
             ENDDO
             IF         COND(&ENV *NE 'P') THEN(DO)
                   GOTO       CMDLBL(ENDE)
             ENDDO
             IF         COND(&FWLFIRM *EQ 'L') THEN(DO)
                   GOTO       CMDLBL(ENDE)
             ENDDO
             IF         COND(&FWLFIRM *EQ 'D') THEN(DO)
             ENDDO
             CALL       PGM(#DEFLDA) PARM(' ')
/*          ----------------------------------------------------------       */
             CRTDDMF    FILE(TIM/POMENTUEB) +
                          RMTFILE(LMFLIBD/POMENTUEB) +
                          RMTLOCNAME('10.185.0.2' *IP)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(TIM_POMS_R) PARM(&AUFTRAG)
             MONMSG     MSGID(CPF0000)
/*          ----------------------------------------------------------       */
ENDE:
             RCLRSC
             ENDPGM
