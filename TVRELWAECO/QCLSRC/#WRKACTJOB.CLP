/*    * PROGRAMMNAME.:TREND ENVIRONMENT AUFBAUEN                             */
/*    * FUNKTION.....:..                                                     */
/*    * SEPTEMBER 2010   GANG, MANFRED                                        */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                          PGMR.....           */
/******************************************************************************/
             PGM

             DCL        VAR(&PARM) TYPE(*CHAR) LEN(04)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&JOB)        TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)       TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)        TYPE(*CHAR) LEN(06)
             DCL        VAR(&CUSER)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATETIME)   TYPE(*CHAR) LEN(20)
             DCL        VAR(&TYPE)       TYPE(*CHAR) LEN(1)
             DCL        VAR(&QTIME)     TYPE(*CHAR) LEN(6)

             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('#WRKACTJOB')
             RTVMBRD    FILE(TVRELWAECO/QCLSRC) MBR(&PGM) TEXT(&TXT)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('START')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */


             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR) +
                          CURUSER(&CUSER) TYPE(&TYPE) +
                          DATETIME(&DATETIME)
             MONMSG     MSGID(CPF0000)
 LOOP:       RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&QTIME)
             IF         COND(&QTIME *GT '160000') THEN(GOTO +
                          CMDLBL(ENDPGM))

             WRKACTJOB OUTPUT(*PRINT) SBS(TRXCALP)
             MONMSG     MSGID(CPF0000)
             CPYSPLF    FILE(QPDSPAJB) TOFILE(TVRELWAECO/#WRKACTJOB) +
                          JOB(&NBR/&USER/&JOB) SPLNBR(*LAST) +
                          MBROPT(*ADD)
             MONMSG     MSGID(CPF0000)
             DLTSPLF    FILE(QPDSPAJB) JOB(&NBR/&USER/&JOB) +
                          SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)
             DLYJOB     DLY(300)
             GOTO       CMDLBL(LOOP)

 ENDPGM:
/*          PROTOKOLLIERUNG ---                                           */
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('ENDE ')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */

             ENDPGM
