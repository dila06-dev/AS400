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
             DLTF       FILE(QTEMP/DGM0015)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/DGM0016)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/DGM0017)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/DGM0018)
             MONMSG     MSGID(CPF0000)
/******************************************************************************/
/*CALL DGM0015 FÜR ARBEITSDATEI QTEMP/DGM0015*************************       */
/*    *                                                                      */
             CALL       PGM(DUMMY512) PARM(&MD 'DGM0015' ' ' ' +
                          ' 'DGM0015' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/******************************************************************************/
/*CALL DGM0016 FÜR ARBEITSDATEI QTEMP/DGM0016*************************       */
/*    *                                                                      */
             CALL       PGM(DUMMY512) PARM(&MD 'DGM0016' ' ' ' +
                          ' 'DGM0016' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/******************************************************************************/
/*CALL DGM0017 FÜR ARBEITSDATEI QTEMP/DGM0017*************************       */
/*    *                                                                      */
             CALL       PGM(DUMMY512) PARM(&MD 'DGM0017' ' ' ' +
                          ' 'DGM0017' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/******************************************************************************/
/*CALL DGM0018 FÜR ARBEITSDATEI QTEMP/DGM0018*************************       */
/*    *                                                                      */
             CALL       PGM(DUMMY512) PARM(&MD 'DGM0018' ' ' ' +
                          ' 'DGM0018' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/******************************************************************************/
             RUNQRY     QRY(FWLFR/DGM0018)
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
