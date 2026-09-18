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
             DLTF       FILE(QTEMP/CHR0021)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/CHR0022)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/CHR0023)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/CHR0024)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/CHR0025)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(FWLFR/CHR0026)
             MONMSG     MSGID(CPF0000)
/******************************************************************************/
/*********************************************************************       */
/*    *                                                                      */
             CALL       PGM(DUMMY512) PARM(&MD 'CHR0020' ' ' ' +
                          ' 'CHR0021' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/*********************************************************************       */
/*    *                                                                      */
             CALL       PGM(DUMMY512) PARM(&MD 'CHR0021' ' ' ' +
                          ' 'CHR0021' 'QTEMP' '*ADD')
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/*********************************************************************       */
/*    *                                                                      */
             CALL       PGM(DUMMY512) PARM(&MD 'CHR0022' ' ' ' +
                          ' 'CHR0022' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/*********************************************************************       */
/*    *                                                                      */
             CALL       PGM(DUMMY512) PARM(&MD 'CHR0023' ' ' ' +
                          ' 'CHR0023' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/*********************************************************************       */
/*    *                                                                      */
             CALL       PGM(DUMMY512) PARM(&MD 'CHR0024' ' ' ' +
                          ' 'CHR0024' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/*********************************************************************       */
/*    *                                                                      */
             CALL       PGM(DUMMY512) PARM(&MD 'CHR0025' ' ' ' +
                          ' 'CHR0025' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/*********************************************************************       */
/*    *                                                                      */
             CALL       PGM(DUMMY512) PARM(&MD 'CHR0026' ' ' ' +
                          ' 'CHR0026' 'FWLFR' '*REPLACE')
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
