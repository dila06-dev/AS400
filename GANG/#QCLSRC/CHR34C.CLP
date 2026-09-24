/*    * PROGRAMMNAME.:BOARD0010C                                             */
/*    * FUNKTION.....:ERSTELLEN FELDER AUS                                   */
/*    *               TECDT00F                                               */
/*    * OKTOBER 2005 / HEISTER                                                */
/*    *                                                                       */
/*    * DRALON GMBH                                                           */
/*    * .....                                                                 */
/*    * .....                                                                 */
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
             DLTF       FILE(QTEMP/BORD028)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/CHR0031)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/CHR0032)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/CHR0033)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(FWLFR/CHR0034)
             MONMSG     MSGID(CPF0000)
/******************************************************************************/
/*ALLE *********************************+*****************************       */
/*    *                                                                      */
             CALL       PGM(DUMMY512) PARM(&MD 'CHR0028' ' ' ' +
                          ' 'CHR0028' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/*    *                                                                      */
             CALL       PGM(DUMMY512) PARM(&MD 'CHR0029' ' ' ' +
                          ' 'CHR0031' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/*    *                                                                      */
             CALL       PGM(DUMMY512) PARM(&MD 'CHR0030' ' ' ' +
                          ' 'CHR0031' 'QTEMP' '*ADD')
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/*    *                                                                      */
             CALL       PGM(DUMMY512) PARM(&MD 'CHR0031' ' ' ' +
                          ' 'CHR0031' 'QTEMP' '*ADD')
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/*    *                                                                      */
             CALL       PGM(DUMMY512) PARM(&MD 'CHR0032' ' ' ' +
                          ' 'CHR0032' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/*    *                                                                      */
             CALL       PGM(DUMMY512) PARM(&MD 'CHR0033' ' ' ' +
                          ' 'CHR0033' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/*    *                                                                      */
             CALL       PGM(DUMMY512) PARM(&MD 'CHR0034' ' ' ' +
                          ' 'CHR0034' 'FWLFR' '*REPLACE')
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
