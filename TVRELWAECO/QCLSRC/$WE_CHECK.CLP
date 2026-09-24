/*    * PROGRAMMNAME.:......                                                 */
/*    * FUNKTION.....:...                                                    */
/*    * JANUAR  2012   M. GANG                                                */
/******************************************************************************/
             PGM

             DCL        VAR(&CODE)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&DONE) TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&RUN) TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&QTIME)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&$INTERFACE) TYPE(*CHAR) LEN(01)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('$WE_CHECK ')
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

 LOOP:       RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&QTIME)

/*          ABGLEICHE JOB LÄUFT 2 SEKUNDEN                              */
             IF         COND(&QTIME *GT '070000') THEN(DO)
/*             ABGLEICH 08:00                                              */
                CALL PGM(TVRELWAECO/WE_CHECK)
                MONMSG     MSGID(CPF0000)
                DLYJOB     DLY(7200)
/*             ABGLEICH 10:00                                              */
                CALL PGM(TVRELWAECO/WE_CHECK)
                MONMSG     MSGID(CPF0000)
                DLYJOB     DLY(10800)
/*             ABGLEICH 13:00                                              */
                CALL PGM(TVRELWAECO/WE_CHECK)
                MONMSG     MSGID(CPF0000)
                DLYJOB     DLY(7200)
/*             ABGLEICH 15:00                                              */
                CALL PGM(TVRELWAECO/WE_CHECK)
                MONMSG     MSGID(CPF0000)
                GOTO       CMDLBL(ENDPGM)
             ENDDO
             DLYJOB     DLY(060)

             IF         COND(&QTIME *GT '150000') THEN(GOTO +
                          CMDLBL(ENDPGM))
             GOTO       CMDLBL(LOOP)


 ENDPGM:
   /*        DSPJOBLOG  OUTPUT(*PRINT)      */

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


