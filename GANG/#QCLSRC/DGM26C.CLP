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
             RTVDTAARA  DTAARA(QTEMP/FWLFIRM (1 1)) RTNVAR(&FIRMA)
             RTVDTAARA  DTAARA(BASISJA)          RTNVAR(&BASISJA)
             CHGVAR     VAR(&X) VALUE(&BASISJA)
/******************************************************************************/
             DLTF       FILE(QTEMP/DGM0019)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/DGM0021)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/DGM0022)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/DGM0024)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/DGM0025)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/DGM0026)
             MONMSG     MSGID(CPF0000)
/******************************************************************************/
/*CALL DGM0019 FÜR ARBEITSDATEI QTEMP/DGM0019*************************       */
/*    *                                                                      */
             CALL       PGM(DUMMY512) PARM(&MD 'DGM0019' ' ' ' +
                          ' 'DGM0019' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/*CALL DGM0020 FÜR ARBEITSDATEI QTEMP/DGM0021*************************       */
/*    *                                                                      */
             CALL       PGM(DUMMY512) PARM(&MD 'DGM0020' ' ' ' +
                          ' 'DGM0021' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/*CALL DGM0021 FÜR AUSGABEDATEI QTEMP/DGM0021*************************       */
/*    *                                                                      */
             CALL       PGM(DUMMY512) PARM(&MD 'DGM0021' ' ' ' +
                          ' 'DGM0021' 'QTEMP' '*ADD')
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/*CALL DGM0022 FÜR AUSGABEDATEI QTEMP/DGM0022*************************       */
/*    *                                                                      */
             CALL       PGM(DUMMY512) PARM(&MD 'DGM0022' ' ' ' +
                          ' 'DGM0022' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/*CALL DGM0023 FÜR AUSGABEDATEI QTEMP/DGM0024*************************       */
/*    *                                                                      */
             CALL       PGM(DUMMY512) PARM(&MD 'DGM0023' ' ' ' +
                          ' 'DGM0024' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/*CALL DGM0024 FÜR AUSGABEDATEI QTEMP/DGM0024*************************       */
/*    *                                                                      */
             CALL       PGM(DUMMY512) PARM(&MD 'DGM0024' ' ' ' +
                          ' 'DGM0024' 'QTEMP' '*ADD')
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/*CALL DGM0025 FÜR AUSGABEDATEI QTEMP/DGM0025*************************       */
/*    *                                                                      */
             CALL       PGM(DUMMY512) PARM(&MD 'DGM0025' ' ' ' +
                          ' 'DGM0025' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/*CALL DGM0026 FÜR AUSGABEDATEI QTEMP/DGM0026*************************       */
/*    *                                                                      */
             CALL       PGM(DUMMY512) PARM(&MD 'DGM0026' ' ' ' +
                          ' 'DGM0026' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
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
