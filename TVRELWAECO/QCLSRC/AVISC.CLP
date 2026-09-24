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

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('AVISC     ')
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
             IF         COND(&QTIME *GT '200000') THEN(GOTO +
                          CMDLBL(ENDPGM))
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&QTIME)
             MONMSG     MSGID(CPF0000)

/*          ALLE ÄNDERUNGEN IN DATEI EINSPIELEN                             */
             CPYF       FROMFILE(TVRELWAECO/SQL_0002) +
                          TOFILE(TVRELWAECO/#SQL_0002) MBROPT(*ADD)
             MONMSG     MSGID(CPF0000)
             CLRPFM     TVRELWAECO/SQL_0002
             MONMSG     MSGID(CPF0000)
             CALL       PGM(AVISR)
             MONMSG     MSGID(CPF0000)
             RTVMBRD    FILE(TVRELWAECO/SQL_0002) NBRCURRCD(&NBRCURRCD)
             MONMSG     MSGID(CPF0000)

             IF         COND(&NBRCURRCD *GT 0) THEN(DO)
/*          PROTOKOLLIERUNG ---                                           */
                CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
                CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
                CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
                CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
                CHGVAR     VAR(%SST(&MD 40 06)) VALUE('LOOP ')
                CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
                CHGVAR     VAR(%SST(&MD 100 10)) VALUE(&NBRCURRCD)
                CHGVAR     VAR(%SST(&MD 110 12)) VALUE(' SÄTZE     ')
                CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                              'JOB_RUN   '  'TVRELWAECO' '*ADD')
                MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */
                RMVLNK     OBJLNK('/SALESCOMPANY/UK/SQL_0002.TXT')
                MONMSG     MSGID(CPF0000)
                CVTDBF     OBJ('/SALESCOMPANY/UK/SQL_0002.TXT') +
                          DBFILE(TVRELWAECO/SQL_0002) +
                          DBOUTFMT(*CSV) DBFLDDSC(*NO)
                MONMSG     MSGID(CPF0000)
                OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                    FORMTYPE('SQL_0002UK') OVRSCOPE(*JOB)
                MONMSG     MSGID(CPF0000)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                           ' ' ' ' ' ')
                MONMSG     MSGID(CPF0000)
             ENDDO
             DLYJOB     DLY(600)
             MONMSG     MSGID(CPF0000)
             GOTO BATCHRUN
/*                                                                            */
 ENDLOOP:
/*                                                                            */
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
