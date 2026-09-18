/*    * PROGRAMMNAME.:$INTERFACE                                             */
/*    * FUNKTION.....:...                                                    */
/*    * JULI    2010   GANG, MANFRED                                          */
/*    *                                                                       */
/*    *-DER JOB IST RESTARTFÄHIG                                             */
/*    * $INTERFACE                                                           */
/*    *  CHGDTAARA DTAARA(TVRELWAECO/$INTERFACE *ALL) VALUE('0')              */
/*    *  DSPDTAARA DTAARA(TVRELWAECO/$INTERFACE)                              */
/*    *  0 BEDEUTET NICHT AKTIV 1 BEDEUTET AKTIV                              */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
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
             CHGVAR     VAR(&PGM) VALUE('$INTERFNEW')
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

             IF         COND(&QTIME *GT '190500') THEN(GOTO +
                          CMDLBL(ENDPGM))

/*          -ABRÄUMEN DER ORDER                                              */
             CALL PGM(TVRELWAECO/ORDERNAV_C)
             MONMSG     MSGID(CPF0000)

             GOTO       CMDLBL(LOOP)

 ENDPGM:

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(TVRELWAECO) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)
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
