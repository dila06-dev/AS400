/*    * PROGRAMMNAME.:KVS02C                                                 */
/*    * FUNKTION.....:AUFBAU DER OFFENEN VERBINDLICHKEITEN                   */
/*    *               ...                                                    */
/*    * NOVEMBER 2000                                                         */
/*    *                                                                       */
/*    * FASERWERKE-LINGEN GMBH                                                */
/*    * DARMER ESCH 75                                                        */
/*    * 49811 LINGEN                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM

/*----------------------------------------------------------------------------*/
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&MSGPGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LDAS)   TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')
/*                                                              */
             DCL        VAR(&MODUS)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&DATMOD)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&RTNCOD)  TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&SYSGES)  TYPE(*CHAR) LEN(26)
             DCL        VAR(&SYSDAT)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&SYSZEI)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FWLFIRM) TYPE(*CHAR) LEN(01)
             DCL        VAR(&BASISJA) TYPE(*DEC) LEN(07) VALUE(9999999)
             DCL        VAR(&X) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
/*----------------------------------------------------------------------------*/
             RTVDTAARA  DTAARA(BASISJA)          RTNVAR(&BASISJA)
             CHGVAR     VAR(&X) VALUE(&BASISJA)
/*----------------------------------------------------------------------------*/
             RTVDTAARA  DTAARA(FWLFIRM (1 1)) RTNVAR(&FWLFIRM)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             GOTO       CMDLBL(ENDE)
             ENDDO
             IF         COND(&FWLFIRM *EQ 'D') THEN(DO)
             ENDDO
             IF         COND(&FWLFIRM *EQ 'L') THEN(DO)
             ENDDO
/*-ENVIRONMENT ANPASSEN BZW ERSTELLEN-----------------------------------------*/
/*                                                */
             DLTF       FILE(QTEMP/W§BAB580L1)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/W§BAB580*)
             MONMSG     MSGID(CPF0000)
/*                                                */
             ADDLIBLE   LIB(FWLGSMLIB) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))
             ADDLIBLE   LIB(SFBF)      POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))

             IF         COND(&FWLFIRM *EQ 'D') THEN(DO)
                CHGVAR     VAR(%SST(&MD 9 1))   VALUE('2')
             ENDDO
             IF         COND(&FWLFIRM *EQ 'L') THEN(DO)
                CHGVAR     VAR(%SST(&MD 9 1))   VALUE('1')
             ENDDO
/*           LÖSCHEN DER AKTUELLEN MONATSDATEN    */
             CHGVAR     VAR(%SST(&MD 1 01))   VALUE('2')
             CHGVAR     VAR(%SST(&MD 2 07)) VALUE(&X)
             CHGVAR     VAR(%SST(&MD 1 02))   VALUE('20')
             CHGVAR     VAR(%SST(&MD 1 02))   VALUE('00')
             CALL       PGM(DUMMY512) PARM(&MD 'BAB0825' ' ' ' ' +
                          ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(#DEFLDA) PARM(' ')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(KVS02R)
             MONMSG     MSGID(CPF0000)
/*                                                */
             DLTOVR     FILE(*ALL) LVL(*)
             MONMSG     MSGID(CPF0000)
             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(FWLGSMLIB)
             ENDDO
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(SFBF)
             ENDDO
/*                                                */
ENDE:
             RCLRSC
             ENDPGM
