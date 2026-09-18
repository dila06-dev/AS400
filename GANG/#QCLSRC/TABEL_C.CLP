/*    * PROGRAMMNAME.:BAB0708C                                               */
/*    * FUNKTION.....:AUFRUF PROGRAMM BAB0708C                               */
/*    * MAI 2002 GANG                                                         */
/*    *                                                                       */
/*    * FASERWERKE-LINGEN GMBH                                                */
/*    * DARMER ESCH 75                                                        */
/*    * 49811 LINGEN                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&X) TYPE(*CHAR) LEN(7)
             DCL        VAR(&VGL) TYPE(*CHAR) LEN(4)  VALUE(' ')
             DCL        VAR(&FIRMA) TYPE(*CHAR) LEN(1)
             RTVDTAARA  DTAARA(QTEMP/FWLFIRM (1 1)) RTNVAR(&FIRMA)
/******************************************************************************/
             CHGVAR     VAR(&VGL)             VALUE(%SST(&X 2 04))
             IF         COND(&FIRMA *EQ 'L') THEN(DO)
                GOTO  ENDE
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&FIRMA *EQ 'D') THEN(DO)
                GOTO  ENDE
                MONMSG     MSGID(CPF0000)
             ENDDO
/*    *+++++++++++++++++++++++++8                                            */
             CHGVAR     VAR(%SST(&MD 1 01))   VALUE('A')
             CALL       PGM(DUMMY512) PARM(&MD 'BAB0010' ' ' ' +
                          ' 'W§BAB555' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/******************************************************************************/
 ENDPGM:     ENDPGM
