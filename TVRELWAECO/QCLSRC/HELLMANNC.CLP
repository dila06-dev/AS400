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
             DCL        VAR(&ERROR4)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&OUTFILE)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFKT)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBRCURRCD)  TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBRCURRCD2) TYPE(*DEC) LEN(10 0)

             DCL        VAR(&MSGYES)    TYPE(*CHAR) LEN(1)
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
             CHGVAR     VAR(&PGM) VALUE('HELLMANNC ')
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
             CHGVAR     VAR(&MSGYES) VALUE('0')
             CLRPFM     FILE(TVRELWAECO/#HEL0150)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(TVRELWAECO/#HEL0250)
             MONMSG     MSGID(CPF0000)
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&QTIME)
             RTVSYSVAL  SYSVAL(QDATETIME) RTNVAR(&QDATETIME)
             IF         COND(&QTIME *GT '180000') THEN(GOTO +
                          CMDLBL(ENDPGM))

/*          A U F T R A G E   NACH   K O M M I S S I O N I E R U N G      */
             CHGVAR     VAR(&ERROR3) VALUE('0')
             ALCOBJ     OBJ((TVRELWAECO/AVISORDER *FILE *EXCL)) WAIT(5)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR3) +
                          VALUE('1'))


/*          ALLE ÄNDERUNGEN IN DATEI EINSPIELEN                             */

          IF         COND(&ERROR3 = '0') THEN(DO)

             CLRPFM     FILE(TVRELWAECO/AVISORDER)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(HELLMANNR) PARM('AVISORDER ')
             MONMSG     MSGID(CPF0000)
             CPYF       FROMFILE(TVRELWAECO/AVISORDER) +
                         TOFILE(TVRELWAECO/AVISORDER#)  +
                         FROMMBR(*FIRST) MBROPT(*ADD)
             MONMSG     MSGID(CPF0000)

/*          SENDEN PER FTP                                                  */
             RTVMBRD    FILE(TVRELWAECO/AVISORDER) +
                        NBRCURRCD(&NBRCURRCD)
             MONMSG     MSGID(CPF0000)
             IF         COND(&NBRCURRCD *GT 0) THEN(DO)
/*             PROTOKOLLIERUNG ---                                        */
                CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
                CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
                CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
                CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
                CHGVAR     VAR(%SST(&MD 40 06)) VALUE('LOOP ')
                CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
                CHGVAR     VAR(%SST(&MD 100 10)) VALUE(&NBRCURRCD)
                CHGVAR     VAR(%SST(&MD 110 06)) VALUE(' SÄTZE')
                CHGVAR     VAR(%SST(&MD 116 12)) VALUE('=>HELLMANNC ')
                CALL    PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
                MONMSG     MSGID(CPF0000)
/*             PROTOKOLLIERUNG ---                                        */
                CALL    PGM(DUMMY512) PARM(&MD 'HEL0100' ' ' ' ' +
                           '#HEL0100  '  'TVRELWAECO' '*REPLACE')
                MONMSG     MSGID(CPF0000)
                OVRDBF     FILE(INPUT) TOFILE(TVRELWAECO/QCLSRC) +
                           MBR(HELL_CMD)
                MONMSG     MSGID(CPF0000)
                OVRDBF     FILE(OUTPUT) TOFILE(TVRELWAECO/QCLSRC) +
                           MBR(HELL_LOG)
                MONMSG     MSGID(CPF0000)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0010' ' ' ' ' +
                         'OUTPUT    '  'TVRELWAECO' '*ADD')
                MONMSG     MSGID(CPF0000)
                FTP        RMTSYS('EMEA-B2B-FTP1.hellmann.net')
                DLTOVR     FILE(INPUT)
                MONMSG     MSGID(CPF0000)
                DLTOVR     FILE(OUTPUT)
                MONMSG     MSGID(CPF0000)

                CHGVAR     VAR(&MSGYES) VALUE('1')
             CALL    PGM(DUMMY512) PARM(&MD 'HEL0150' ' ' ' ' +
                        '#HEL0150  '  'TVRELWAECO' '*REPLACE')
             MONMSG     MSGID(CPF0000)
             RMVLNK     OBJLNK('/SPEDITION/Hellmann/#HEL0150.TXT')
             MONMSG     MSGID(CPF0000)
             CVTDBF     OBJ('/SPEDITION/Hellmann/#HEL0150.TXT') +
                          DBFILE(TVRELWAECO/#HEL0150) +
                          DBOUTFMT(*TXT) DBFLDDSC(*YES)
             MONMSG     MSGID(CPF0000)
             CALL    PGM(DUMMY512) PARM(&MD 'HEL0155' ' ' ' ' +
                        ' '  ' ' ' ')
             MONMSG     MSGID(CPF0000)


                DLCOBJ     OBJ((TVRELWAECO/AVISORDER *FILE *EXCL))
                MONMSG     MSGID(CPF0000)
             ENDDO
             DLCOBJ     OBJ((TVRELWAECO/AVISORDER *FILE *EXCL))
             MONMSG     MSGID(CPF0000)
          ENDDO
/*                                                                            */

/*          W A R E N E I N G Ä N G E                                     */
             CHGVAR     VAR(&ERROR3) VALUE('0')
             ALCOBJ     OBJ((TVRELWAECO/WEORDER *FILE *EXCL)) WAIT(5)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR4) +
                          VALUE('1'))

/*          ALLE ÄNDERUNGEN IN DATEI EINSPIELEN                             */

          IF         COND(&ERROR4 = '0') THEN(DO)

             CLRPFM     FILE(TVRELWAECO/WEORDER)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(HELLMANNR) PARM('WEORDER   ')
             MONMSG     MSGID(CPF0000)
             CPYF       FROMFILE(TVRELWAECO/WEORDER) +
                         TOFILE(TVRELWAECO/WEORDER#)  +
                         FROMMBR(*FIRST) MBROPT(*ADD)
             MONMSG     MSGID(CPF0000)

/*          SENDEN PER FTP                                                  */
             RTVMBRD    FILE(TVRELWAECO/WEORDER) +
                        NBRCURRCD(&NBRCURRCD)
             MONMSG     MSGID(CPF0000)
             IF         COND(&NBRCURRCD *GT 0) THEN(DO)
/*             PROTOKOLLIERUNG ---                                        */
                CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
                CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
                CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
                CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
                CHGVAR     VAR(%SST(&MD 40 06)) VALUE('LOOP ')
                CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
                CHGVAR     VAR(%SST(&MD 100 10)) VALUE(&NBRCURRCD)
                CHGVAR     VAR(%SST(&MD 110 06)) VALUE(' SÄTZE')
                CHGVAR     VAR(%SST(&MD 116 12)) VALUE('=>HELLMANNC ')
                CALL    PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
                MONMSG     MSGID(CPF0000)
/*             PROTOKOLLIERUNG ---                                        */
                CALL    PGM(DUMMY512) PARM(&MD 'HEL0200' ' ' ' ' +
                           '#HEL0200  '  'TVRELWAECO' '*REPLACE')
                MONMSG     MSGID(CPF0000)
                OVRDBF     FILE(INPUT) TOFILE(TVRELWAECO/QCLSRC) +
                           MBR(HELL_CMD2)
                MONMSG     MSGID(CPF0000)
                OVRDBF     FILE(OUTPUT) TOFILE(TVRELWAECO/QCLSRC) +
                           MBR(HELL_LOG)
                MONMSG     MSGID(CPF0000)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0010' ' ' ' ' +
                         'OUTPUT    '  'TVRELWAECO' '*ADD')
                MONMSG     MSGID(CPF0000)
                FTP        RMTSYS('EMEA-B2B-FTP1.hellmann.net')
                DLTOVR     FILE(INPUT)
                MONMSG     MSGID(CPF0000)
                DLTOVR     FILE(OUTPUT)
                MONMSG     MSGID(CPF0000)
                CHGVAR     VAR(&MSGYES) VALUE('1')

             CALL    PGM(DUMMY512) PARM(&MD 'HEL0250' ' ' ' ' +
                        '#HEL0250  '  'TVRELWAECO' '*REPLACE')
             MONMSG     MSGID(CPF0000)
             RMVLNK     OBJLNK('/SPEDITION/Hellmann/#HEL0250.TXT')
             MONMSG     MSGID(CPF0000)
             CVTDBF     OBJ('/SPEDITION/Hellmann/#HEL0250.TXT') +
                          DBFILE(TVRELWAECO/#HEL0250) +
                          DBOUTFMT(*TXT) DBFLDDSC(*YES)
             MONMSG     MSGID(CPF0000)
             CALL    PGM(DUMMY512) PARM(&MD 'HEL0255' ' ' ' ' +
                        ' '  ' ' ' ')
             MONMSG     MSGID(CPF0000)


                DLCOBJ     OBJ((TVRELWAECO/WEORDER *FILE *EXCL))
                MONMSG     MSGID(CPF0000)
             ENDDO
             DLCOBJ     OBJ((TVRELWAECO/WEORDER *FILE *EXCL))
             MONMSG     MSGID(CPF0000)
          ENDDO
/*                                                                            */

          IF         COND(&MSGYES *EQ '1') THEN(DO)
             OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                    FORMTYPE('#HEL0150 ') OVRSCOPE(*JOB)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                          ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
          ENDDO


          DLYJOB     DLY(1200)
          GOTO BATCHRUN
/*                                                                            */
 ENDPGM:

             DLCOBJ     OBJ((TVRELWAECO/WEORDER  *FILE *EXCL))
             MONMSG     MSGID(CPF0000)
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
