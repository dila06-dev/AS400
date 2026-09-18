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
/*-CALL AUF DRUCKSTEUERPROGRAMM---==> START                                   */
             CALL       PGM(PRTCTL) PARM(&PRT 'QPQUPRFIL ' &CTL +
                          '*NO ' '1')
/******************************************************************************/
             DLTF       FILE(QTEMP/CHR0005)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/CHR0006)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/CHR0007)
             MONMSG     MSGID(CPF0000)
/******************************************************************************/
/*CALL CHR0005 FÜR ARBEITSDATEI QTEMP/CHR0005*************************       */
/*    *                                                                      */
             CALL       PGM(DUMMY512) PARM(&MD 'CHR0005' ' ' ' +
                          ' 'CHR0005' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/*CALL CHR0006 FÜR ARBEITSDATEI QTEMP/CHR0006*************************       */
/*    *                                                                      */
             CALL       PGM(DUMMY512) PARM(&MD 'CHR0006' ' ' ' +
                          ' 'CHR0006' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/*CALL CHR0007 FÜR AUSGABEDATEI QTEMP/CHR0007*************************       */
/*    *                                                                      */
             CALL       PGM(DUMMY512) PARM(&MD 'CHR0007' ' ' ' +
                          ' 'CHR0007' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/*CALL CHR0005A ******************************************************       */
/*    *                                                                      */
             RUNQRY     QRY(FWLFR/CHR0005A) RCDSLT(*YES)
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/*CALL CHR0005B ******************************************************       */
/*    *                                                                      */
             RUNQRY     QRY(FWLFR/CHR0005B) RCDSLT(*YES)
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/*CALL CHR0005C ******************************************************       */
/*    *                                                                      */
             RUNQRY     QRY(FWLFR/CHR0005C) RCDSLT(*YES)
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/*CALL CHR0005D ******************************************************       */
/*    *                                                                      */
             RUNQRY     QRY(FWLFR/CHR0005D) RCDSLT(*YES)
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
