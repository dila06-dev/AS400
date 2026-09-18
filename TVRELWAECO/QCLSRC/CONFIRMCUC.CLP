/*    * PROGRAMMNAME.:CALL ........                                          */
/*    * FUNKTION.....:IDCO                                                   */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    * .                                                                     */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM

             DCL        VAR(&PARM)    TYPE(*CHAR) LEN(01)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&IFAKIFFI)   TYPE(*CHAR) LEN(05)
             DCL        VAR(&IFAKMAAF)   TYPE(*CHAR) LEN(10)

             DCL        VAR(&ERROR1)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR3)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&OUTFILE)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFKT)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBRCURRCD)  TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBRCURRCD2) TYPE(*DEC) LEN(10 0)

             DCL        VAR(&D)         TYPE(*CHAR) LEN(8)
             DCL        VAR(&ABDATUM)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&QTIME)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&QDATETIME) TYPE(*CHAR) LEN(20)

             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)

             DCLF       FILE(QTEMP/#DC0200)

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('CONFIRMCUC')
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

             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&QTIME)
             RTVSYSVAL  SYSVAL(QDATETIME) RTNVAR(&QDATETIME)
             CHGVAR     VAR(&D) VALUE(%SST(&QDATETIME 1 8))

             ADDLIBLE   LIB(TVRELWAECO) POSITION(*AFTER TFXF)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))

 BATCHRUN:
             IF         COND(&QTIME *GT '180000') THEN(GOTO +
                          CMDLBL(ENDPGM))

/*          ALLE ÄNDERUNGEN IN DATEI EINSPIELEN                             */
             CLRPFM     FILE(TVRELWAECO/UNFREEZE)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(CONFIRMBR)
             MONMSG     MSGID(CPF0000)

             ALCOBJ     OBJ((TVRELWAECO/CONFIRUFTP *PGM *EXCL)) WAIT(5)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR3) +
                          VALUE('1'))
/*          SENDEN PER FTP                                                  */
             IF         COND(&ERROR3 = '0') THEN(DO)
                CALL      PGM(DUMMY512) PARM(&MD '#DC0199' ' ' ' ' +
                           '#DC0200' 'QTEMP' '*ADD')
                MONMSG     MSGID(CPF0000)
                RTVMBRD    FILE(QTEMP/#DC0200) NBRCURRCD(&NBRCURRCD)
                MONMSG     MSGID(CPF0000)
                IF         COND(&NBRCURRCD *GT 0) THEN(DO)
 LOOP:             RCVF
                   MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDLOOP))
/*          PROTOKOLLIERUNG ---                                           */
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('LOOP ')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CHGVAR     VAR(%SST(&MD 100 10)) VALUE(&CUSTOMER)
             CHGVAR     VAR(%SST(&MD 110 12)) VALUE('=>CONFIRUFTP')
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */
                   CALL       PGM(CONFIRUFTP) PARM(&CUSTOMER)
                   MONMSG     MSGID(CPF0000)
                   GOTO LOOP
                ENDDO
/*                                                                            */
 ENDLOOP:
                DLCOBJ     OBJ((TVRELWAECO/CONFIRUFTP *PGM *EXCL))
                MONMSG     MSGID(CPF0000)
             ENDDO
/*                                                                            */
             DLCOBJ     OBJ((TVRELWAECO/CONFIRUFTP *PGM *EXCL))
             MONMSG     MSGID(CPF0000)
             GOTO       CMDLBL(ENDPGM)
/*                                                                            */
 ENDPGM:

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
                MONMSG     MSGID(CPF0000)
             ENDDO

             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
                MONMSG     MSGID(CPF0000)
             ENDDO

             ENDPGM
