/*    * PROGRAMMNAME.:......                                                 */
/*    * FUNKTION.....:...                                                    */
/*    * JANUAR  2012   M. GANG                                                */
/******************************************************************************/
             PGM        PARM(&USRPRF)

             DCL        VAR(&CODE)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&DONE) TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&RUN) TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&QTIME)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&$INTERFACE) TYPE(*CHAR) LEN(01)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&USRPRF) TYPE(*CHAR) STG(*AUTO) LEN(10)
             DCL        VAR(&RQSVAR) TYPE(*CHAR) LEN(14)
             DCL        VAR(&RQSLEN) TYPE(*INT) VALUE(14)

             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('$QZLSCHSI ')
             RTVMBRD    FILE(TVRELWAECO/QCLSRC) MBR(&PGM) TEXT(&TXT)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('START')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CHGVAR     VAR(%SST(&MD 52 10)) VALUE(&USRPRF)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */

 LOOP:       RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&QTIME)

/*          ABGLEICHE JOB LÄUFT 2 SEKUNDEN                                */
             IF         COND(&QTIME *GT '080000') THEN(DO)
        /*      CHGVAR     VAR(&USRPRF) VALUE(&USER)          */
        /*      CHGVAR     VAR(&USRPRF) VALUE('GANG      ')   */
/*             ABGLEICH 08:00                                              */
                CHGVAR VAR(&RQSVAR) VALUE('    ' *CAT &USRPRF)
                MONMSG     MSGID(CPF0000)
                CHGVAR VAR(%BINARY(&RQSVAR 1 4)) VALUE(&RQSLEN)
                MONMSG     MSGID(CPF0000)
                CALL QSYS/QZLSCHSI PARM(&RQSVAR &RQSLEN ZLSS0200 X'00000000')
                MONMSG     MSGID(CPF0000)
             ENDDO

 ENDPGM:
   /*        DSPJOBLOG  OUTPUT(*PRINT)      */

/*          PROTOKOLLIERUNG ---                                           */
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('ENDE ')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CHGVAR     VAR(%SST(&MD 52 10)) VALUE(&USRPRF)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */


