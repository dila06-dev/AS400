/*    * PROGRAMMNAME.:CALL ........                                          */
/*    * FUNKTION.....:IDCO                                                   */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    *                                                                       */
/*    * RESTART:                                                              */
/*    * UPDATE #AFRK11016 SET STATUS = ' ' WHERE #CC = 4                      */
/*    *                                                                       */
/*    * CALL DIREKT AUF RPG ACHTUNG FREITAGKENNUNG                            */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/*    * dometicwaeco  qQU2N16r     ==> alter Zugriff          PGMR.....       */
/******************************************************************************/
             PGM        PARM(&PARM)

             DCL        VAR(&PARM)    TYPE(*CHAR) LEN(01)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&ERROR1)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&OUTFILE)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFKT)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBRCURRCD)  TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBRCURR##)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBRCURRCD2) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&TIMESTAMP) TYPE(*CHAR) LEN(11) VALUE(' ')
             DCL        VAR(&TOFILE) TYPE(*CHAR) LEN(32) VALUE('  ')

             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)

             ADDLIBLE   LIB(TVRELWAECO) POSITION(*AFTER TFXF)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('TE11016_C ')
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

             IF         COND(&PARM *EQ '1' ) THEN(DO)
                CALL       PGM(FTP_TIMEST) PARM(&TIMESTAMP)
                CHGVAR     VAR(&TOFILE) VALUE('TE'          *CAT +
                           &TIMESTAMP *CAT '.txt')
      /*               GOTO  GO      */
/*             GENERELLER AUFBAU                                             */
/*             ZIEHEN RELEVANTER DATEN AUS #LBLB                             */
                CALL    PGM(DUMMY512) PARM(&MD '#TE0500' ' ' ' ' +
                           '#AFRK11016' 'TVRELWAECO' '*ADD')
                MONMSG     MSGID(CPF0000)

                CPYF       FROMFILE(EDI_TECHP) TOFILE(EDI_TECHPS) +
                            TOMBR(*FIRST) MBROPT(*ADD) CRTFILE(*NO)
                MONMSG     MSGID(CPF0000)
                CLRPFM     FILE(EDI_TECHP)
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TE11016_R)
                MONMSG     MSGID(CPF0000)

 GO:
                RTVMBRD    FILE(TVRELWAECO/EDI_TECHP) +
                           NBRCURRCD(&NBRCURRCD)
                MONMSG     MSGID(CPF0000)
                IF         COND(&NBRCURRCD *GT 00000) THEN(DO)
                   OVRDBF     FILE(INPUT) TOFILE(TVRELWAECO/QCLSRC) +
                             MBR(TECHNOCMD)
                   MONMSG     MSGID(CPF0000)
                   OVRDBF     FILE(OUTPUT) TOFILE(TVRELWAECO/QCLSRC) +
                             MBR(TECHNOLOG)
                   MONMSG     MSGID(CPF0000)
                   CHGVAR     VAR(%SST(&MD 01 32)) VALUE(&TOFILE)
                   CALL      PGM(DUMMY512) PARM(&MD '#TE0505' ' ' ' ' +
                             ' ' ' ' ' ')
                   MONMSG     MSGID(CPF0000)
                   CALL     PGM(DUMMY512) PARM(&MD '#DC0010' ' ' ' ' +
                           'OUTPUT    '  'TVRELWAECO' '*ADD')
                   MONMSG     MSGID(CPF0000)
/*                 AB 01.01.2014                              */
/*                 FTP        RMTSYS('MY.EDIEXPERTS.DE')      */
/*                 FTP        RMTSYS('WWW.TIBSONLINE.DE')     */
                   FTP        RMTSYS('FTP.TIBSONLINE.DE')
                   DLTOVR     FILE(INPUT)
                   MONMSG     MSGID(CPF0000)
                   DLTOVR     FILE(OUTPUT)
                   MONMSG     MSGID(CPF0000)
                ENDDO
             ENDDO
/*                                                                            */
 ENDPGM:
             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(TVRELWAECO)
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
                MONMSG     MSGID(CPF0000)
             ENDDO

/*          PROTOKOLLIERUNG ---                                           */
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('ENDE ')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CHGVAR     VAR(%SST(&MD 100 14)) VALUE('Sätze verarb.')
             CHGVAR     VAR(&NBRCURR##) VALUE(&NBRCURRCD)
             CHGVAR     VAR(%SST(&MD 115 10)) VALUE(&NBRCURR##)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */

             ENDPGM
