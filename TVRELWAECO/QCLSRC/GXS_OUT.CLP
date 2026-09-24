/*    * PROGRAMMNAME.:                                                       */
/*    * FUNKTION.....:...                                                    */
/*    * JULI    2014                                                          */
/******************************************************************************/
             PGM

             DCL        VAR(&CODE)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&DONE) TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&RUN) TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&QTIME)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&$INTERFACE) TYPE(*CHAR) LEN(01)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&ENVIR) TYPE(*CHAR) LEN(1) VALUE('0')

             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('GXS_OUT   ')
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

             IF         COND(&QTIME *GT '220000') THEN(GOTO +
                          CMDLBL(ENDPGM))

             IF         COND(&QTIME *GT '083000' *AND &ENVIR = '0') +
                        THEN(DO)
/*           - ENVIRONMENT ERSTELLEN FÜR GXS INVOICING                       */
                CHGVAR     VAR(&ENVIR) VALUE('1')
                MONMSG     MSGID(CPF0000)
                CALL PGM(INVOICES)
                MONMSG     MSGID(CPF0000)
             ENDDO

             IF         COND(&QTIME *GT '093000' *AND &QTIME *LT +
                          '213000')  THEN(DO)
/*           - TREND    STARTEN FÜR 01 ==> DOMETIC EMSDETTEN                 */
                CALL PGM(#INVOICTRC) PARM('01' ' ')
                MONMSG     MSGID(CPF0000)
             ENDDO
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000)

             IF         COND(&QTIME *GT '093000' *AND &QTIME *LT +
                          '213000')  THEN(DO)
/*           - TREND    STARTEN FÜR 08 ==> DOMETIC EMSDETTEN                 */
                CALL PGM(#INVOICTRC) PARM('08' ' ')
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&QTIME *GT '093000' *AND &QTIME *LT +
                          '213000')  THEN(DO)
/*           - TREND START JOB FOR  52 ==> WAECO GROUP-HOLDING               */
                CALL PGM(#INVOICTRC) PARM('52' ' ')
                MONMSG     MSGID(CPF0000)
             ENDDO
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000)

             IF         COND(&QTIME *GT '093000' *AND &QTIME *LT +
                          '213000')  THEN(DO)
/*           - TREND START JOB FOR  55 ==> DOMETIC SWITZERLAND AG            */
                CALL PGM(#INVOICTRC) PARM('55' ' ')
                MONMSG     MSGID(CPF0000)
             ENDDO
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000)

             IF         COND(&QTIME *GT '093000' *AND &QTIME *LT +
                          '213000')  THEN(DO)
/*           - EL-ERP   STARTEN FÜR 03 ==> ???                               */
                CALL PGM(#INVOICELC) PARM('03' ' ')
                MONMSG     MSGID(CPF0000)
             ENDDO
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000)

             IF         COND(&QTIME *GT '093000' *AND &QTIME *LT +
                          '213000')  THEN(DO)
/*           - USA      STARTEN FÜR 99 ==> USA ERP                           */
                CALL PGM(#INVOICUSC) PARM('99' ' ')
                MONMSG     MSGID(CPF0000)
             ENDDO
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000)

             IF         COND(&QTIME *GT '093000' *AND &QTIME *LT +
                          '213000')  THEN(DO)
/*           - EL-ERP   STARTEN FÜR 15 ==> DOMETIC LEIGHT-SYST.GMBH          */
                CALL PGM(#INVOICELC) PARM('15' ' ')
                MONMSG     MSGID(CPF0000)
             ENDDO
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000)


             DLYJOB     DLY(1800)

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

        /*   DSPJOBLOG  OUTPUT(*PRINT)     */

