/*    * PROGRAMMNAME.:PROD002C                                               */
/*    * FUNKTION.....:CALL ...                                               */
/*    *               SALDIERUNG DER PRODUKTIONSAUFTRÄGE                     */
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
/*----------------------------------------------------------------------------*/
             RTVDTAARA  DTAARA(FWLFIRM (1 1)) RTNVAR(&FWLFIRM)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             GOTO       CMDLBL(ENDE)
             ENDDO
             IF         COND(&FWLFIRM *EQ 'D') THEN(DO)
                   GOTO       CMDLBL(ENDE)
             ENDDO
             IF         COND(&FWLFIRM *EQ 'L') THEN(DO)
             ENDDO
/*-ENVIRONMENT ANPASSEN BZW ERSTELLEN-----------------------------------------*/
             ADDLIBLE   LIB(FWLFR) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))
/*----------------------------------------------------------------------------*/
/*    *     SYSGES: 20050322090226                                           */
/*    *     SYSDAT: 20050322                                                 */
/*    *     SYSZEI: 090226                                                   */
             CHGVAR     VAR(&DATMOD) VALUE('*JMT4')
             CALL       PGM(SUBR36/#DATAKTR) PARM(&DATMOD &RTNCOD +
                          &SYSGES &SYSDAT &SYSZEI)
/*    *     SYSGES: 22032005090226                                           */
/*    *     SYSDAT: 22032005                                                 */
/*    *     SYSZEI: 090226                                                   */
             CHGVAR     VAR(&DATMOD) VALUE('*TMJ4')
             CALL       PGM(SUBR36/#DATAKTR) PARM(&DATMOD &RTNCOD +
                          &SYSGES &SYSDAT &SYSZEI)
/*    *     SYSGES: 22.03.200509.02.26                                       */
/*    *     SYSDAT: 22.03.2005                                               */
/*    *     SYSZEI: 09.02.26                                                 */
             CHGVAR     VAR(&DATMOD) VALUE('*EUR ')
             CALL       PGM(SUBR36/#DATAKTR) PARM(&DATMOD &RTNCOD +
                          &SYSGES &SYSDAT &SYSZEI)
/*----------------------------------------------------------------------------*/
/*                                                */
/*    *     SYSGES: 20050322090226                                           */
/*    *     SYSDAT: 20050322                                                 */
/*    *     SYSZEI: 090226                                                   */
             CHGVAR     VAR(&DATMOD) VALUE('*JMT4')
             CALL       PGM(SUBR36/#DATAKTR) PARM(&DATMOD &RTNCOD +
                          &SYSGES &SYSDAT &SYSZEI)
             CHGVAR     VAR(%SST(&MD 1 08)) VALUE(&SYSDAT)
             CALL       PGM(DUMMY512) PARM(&MD 'PRO0002' ' ' ' ' +
                          'PRO0002' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*                                                */
             CALL       PGM(PROD002R)
             MONMSG     MSGID(CPF0000)
/*                                                */
ENDE:
             RCLRSC
             ENDPGM
