/*    * PROGRAMMNAME.:AVISUSR01C                                             */
/*    * FUNKTION.....:AVLÖSUNG SRS-SYSTEM                                    */
/*    *               BESTANDENTWICKLUNG                                     */
/*    * MAI 2002 GANG/CUCCHI                                                  */
/*    *                                                                       */
/*    * FASERWERKE-LINGEN GMBH                                                */
/*    * DARMER ESCH 75                                                        */
/*    * 49811 LINGEN                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM
             DCL        VAR(&BASISJA) TYPE(*DEC) LEN(07) VALUE(9999999)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&X) TYPE(*CHAR) LEN(7)
             DCL        VAR(&KKT) TYPE(*CHAR) LEN(04) VALUE(' ')
             DCL        VAR(&VGL) TYPE(*CHAR) LEN(4)  VALUE(' ')
             DCL        VAR(&FIRMA) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CTL) TYPE(*CHAR) LEN(1)  VALUE(' ')
             RTVDTAARA  DTAARA(QTEMP/FWLFIRM (1 1)) RTNVAR(&FIRMA)
             RTVDTAARA  DTAARA(BASISJA)          RTNVAR(&BASISJA)
             CHGVAR     VAR(&X) VALUE(&BASISJA)
/******************************************************************************/
/*    *                                                                      */
             CALL       PGM(DRUCK_R) PARM(&PRT)
             MONMSG     MSGID(CPF0000)
/*-CALL AUF RUCKSTEUERPROGRAMM---==> START                                   */
             CALL       PGM(PRTCTL) PARM(&PRT 'QPQUPRFIL ' &CTL +
                          '*NO ' '1')
/******************************************************************************/
             DLTF       FILE(QTEMP/DOW*)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(FWLFR/DOW*)
             MONMSG     MSGID(CPF0000)
/******************************************************************************/
/*CALL DOW0001 FÜR DOW0002********************************************       */
/*    *                                                                      */
             CALL       PGM(DUMMY512) PARM(&MD 'DOW0001' ' ' ' +
                          ' 'DOW0001' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/*CALL DOW0002 FÜR ARBEITSDATEI QTEMP/DOW0002*************************       */
/*    *                                                                      */
             CALL       PGM(DUMMY512) PARM(&MD 'DOW0002' ' ' ' +
                          ' 'DOW0002' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/*CALL DOW0003 FÜR EXCEL WK 02 ***************************************       */
/*    *                                                                      */
             CALL       PGM(DUMMY512) PARM(&MD 'DOW0003' ' ' ' +
                          ' 'DOW0003' 'FWLFR' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/*CALL DOW0003 FÜR EXCEL WK 03 ***************************************       */
/*    *                                                                      */
             CALL       PGM(DUMMY512) PARM(&MD 'DOW0004' ' ' ' +
                          ' 'DOW0004' 'FWLFR' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/*CALL DOW0003 FÜR EXCEL WK 05 ***************************************       */
/*    *                                                                      */
             CALL       PGM(DUMMY512) PARM(&MD 'DOW0005' ' ' ' +
                          ' 'DOW0005' 'FWLFR' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/*CALL DOW0003 FÜR EXCEL WK 06 ***************************************       */
/*    *                                                                      */
             CALL       PGM(DUMMY512) PARM(&MD 'DOW0006' ' ' ' +
                          ' 'DOW0006' 'FWLFR' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/*CALL DOW0003 FÜR EXCEL WK 07 ***************************************       */
/*    *                                                                      */
             CALL       PGM(DUMMY512) PARM(&MD 'DOW0007' ' ' ' +
                          ' 'DOW0007' 'FWLFR' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/*CALL SOPOLISTE *****************************************************       */
/*    *                                                                      */
             RUNQRY     QRY(FWLFR/SOPOLISTE)
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/*********************************************************************       */
/*-CALL AUF RUCKSTEUERPROGRAMM---==> ENDE                                    */
             CALL       PGM(PRTCTL) PARM(&PRT 'QPQUPRFIL ' &CTL +
                          '*NO ' '0')
/*********************************************************************       */
             IF         COND(&FIRMA *EQ 'L') THEN(DO)
             ENDDO
             IF         COND(&FIRMA *EQ 'D') THEN(DO)
             ENDDO
/*********************************************************************       */
             CHGVAR     VAR(&VGL)             VALUE(%SST(&X 2 04))
             CHGVAR     VAR(%SST(&MD 1 01))   VALUE('A')
             CHGVAR     VAR(%SST(&MD 1 07))   VALUE(&X)
/******************************************************************************/
 ENDPGM:     ENDPGM
