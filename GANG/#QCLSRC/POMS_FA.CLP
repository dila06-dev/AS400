/*    * PROGRAMMNAME.:POMS_FA FÜLLEN AUF ALTER MASCHINE                      */
/*    * FUNKTION.....:                                                       */
/*    * 06.07.98                                                              */
/*    *                                                                       */
/*    * Manfred Gang                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM

             DCL        VAR(&FWLFIRM) TYPE(*CHAR) LEN(01)
             DCL        VAR(&ENV)     TYPE(*CHAR) LEN(01)
             RTVDTAARA  DTAARA(FWLFIRM (1 1)) RTNVAR(&FWLFIRM)
             RTVDTAARA  DTAARA(FWLFIRM (2 1)) RTNVAR(&ENV)
             IF         COND(&FWLFIRM *EQ ' ') THEN(DO)
                IF         COND(&ENV *EQ ' ') THEN(DO)
/*          POMS_FA                                                          */
                   CRTDDMF    FILE(TIM/PAUFTRAG) +
                           RMTFILE(LMFLIBD/POMENTUEB) +
                           RMTLOCNAME('10.185.0.2' *IP) +
                           TEXT('Übergabe Produktionsaufträge an POMS')
                   MONMSG     MSGID(CPF0000)
                CPYF    FROMFILE(QTEMP/POM0001) TOFILE(TIM/PAUFTRAG) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)
                   MONMSG     MSGID(CPF0000)
                ENDDO
             ENDDO
             RCLRSC

             ENDPGM
