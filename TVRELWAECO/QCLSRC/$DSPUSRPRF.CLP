/*    * PROGRAMMNAME.:......                                                 */
/*    * FUNKTION.....:...                                                    */
/*SELECT UPUPRF, UPUSCL, UPPWCD, UPPWCT, UPPSOD, UPPSOT, UPSPAU,              */
/*UPINPG, UPINPL, UPJBDS, UPOWNR, UPSTAT, UPENLM , UPLPWM, UPPWCB,            */
/*UPLSTD FROM TVRELWAECO/#DSPUSRPRF                                           */
/*DATEI U20140514 IN TVRELWAECO WURDE ERSTELLT.                               */
/*                                                                            */
/*                                                                            */
/*                                                                            */
/******************************************************************************/
             PGM

             DCL        VAR(&CODE)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&DONE) TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&RUN)  TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&DAYS) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&$DSPUSRPRF) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&QTIME)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&QDATE)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&$INTERFACE) TYPE(*CHAR) LEN(01)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&ERROR1)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&NBR2) TYPE(*DEC) LEN(10 0)

             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)

             DCLF       FILE(TVRELWAECO/#DSPUSRPRF)

             ADDLIBLE   LIB(TVRELWAECO) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('$DSPUSRPRF')
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

             RTVDTAARA  DTAARA(TVRELWAECO/$DSPUSRPRF *ALL) +
                        RTNVAR(&$DSPUSRPRF)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDPGM))

 LOOP:       RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&QTIME)
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&QDATE)
     /*      CHGVAR     VAR(&QTIME) VALUE('060001')     */
             IF         COND(&QTIME *GT '235959') THEN(GOTO +
                          CMDLBL(ENDPGM))

             IF         COND(&QTIME *GT '059999' *AND &QTIME *LT +
                          '235900') THEN(DO)

/*             FUNKTION                                                     */
                CALL       PGM(TVRELWAECO/#DATECHECK) PARM('$$$$$$' +
                               &$DSPUSRPRF)
                MONMSG     MSGID(CPF0000)

 LOOP2:         RCVF
                   MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDPGM))
/*                ZUSATZ                                                     */
                   IF         COND(&UPUPRF *EQ 'GANG      ') THEN(DO)
                       CHGUSRPRF  USRPRF(&UPUPRF) PASSWORD(*SAME) +
                          STATUS(*ENABLED)
                       MONMSG     MSGID(CPF0000)
                   ENDDO
                   IF         COND(&UPUPRF *EQ 'SEIDL02   ') THEN(DO)
                       CHGUSRPRF  USRPRF(&UPUPRF) PASSWORD(*SAME) +
                          STATUS(*ENABLED)
                       MONMSG     MSGID(CPF0000)
                   ENDDO
/*                                                                            */
/*                TAGE FÜR ARGUMENT                                          */
                   CHGVAR     VAR(&DAYS) VALUE(0)
                   CALL  PGM(TVRELWAECO/#DATECHECK) PARM(&UPLSTD &DAYS)
                   MONMSG     MSGID(CPF0000)
/*                UND FUNKTION                                               */
                   IF    COND(&DAYS *GT &$DSPUSRPRF *AND &UPSTAT *EQ +
                          '*ENABLED  ') THEN(DO)
                      CHGVAR     VAR(&DAYS) VALUE(0)
                   ENDDO
                GOTO LOOP2


                DLYJOB     DLY(200)
                GOTO       CMDLBL(LOOP)
/*          PROTOKOLLIERUNG ---                                           */
             ENDDO

 ENDPGM:
/*          SONDERFUNKTION DRUCKERSTARTEN                                  */
             ADDLIBLE   LIB(PMQSL) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)
             STRSBS PMQSL/PMDOC
             MONMSG     MSGID(CPF0000)
             PMQSL/PMDOCSTART
             MONMSG     MSGID(CPF0000)
             DSPJOBLOG  OUTPUT(*PRINT)

/*          PROTOKOLLIERUNG ---                                           */
             CHGVAR     VAR(&MD) +
                          VALUE('                                     -
                                                           ')
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

             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(TVRELWAECO)
             ENDDO
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
             ENDDO

