/*    * PROGRAMMNAME.:CALL ........                                          */
/*    * FUNKTION.....:DATENBASIS FÜR RPMII                                   */
/*    *               ...                                                    */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM

             DCL        VAR(&PARM)    TYPE(*CHAR) LEN(01)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&ERROR1)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&OUTFILE)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFKT)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBRCURRCD)  TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBRCURRCD2) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&TOFILEDE) TYPE(*CHAR) LEN(32) VALUE('  ')
             DCL        VAR(&TIMESTAMP) TYPE(*CHAR) LEN(11) VALUE(' ')

             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)

             ADDLIBLE   LIB(TVRELWAECO) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('RPM_CONTRC')
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
/*                                                                            */
/*          LETZTE KALKULATIONSDATEN LIEFERN                              */
             CALL       PGM(RPMIIKALKC)
             MONMSG     MSGID(CPF0000)

/*                                                                            */
             CALL RPM_CONTRR
             MONMSG     MSGID(CPF0000)

             CLRPFM     TVRELWAECO/#RP0542
             MONMSG     MSGID(CPF0000)
/*                                                                            */
             CLRPFM     TVRELWAECO/RPMIIPC
             MONMSG     MSGID(CPF0000)
/*                                                                            */
             CALL    PGM(DUMMY512) PARM(&MD '#RP0542' ' ' ' ' +
                         '#RP0542' 'TVRELWAECO' '*REPLACE')
             MONMSG     MSGID(CPF0000)

       /*   ***    FTP UPLOAD                           RPMIIRC#2            */
             CALL       PGM(FTP_TIMEST) PARM(&TIMESTAMP)
                        CHGVAR VAR(&TOFILEDE) VALUE('DE411A_AC_' *CAT +
                       (%SST(&TIMESTAMP 1 6)) *CAT '.txt')
       /*   *** ABRUFDATEI PC FÜR HOCHLADEN NACH RPMII                       */

             QSYS/CPYTOIMPF FROMFILE(#RP0542) +
                          TOFILE(TVRELWAECO/RPMIIPC) +
                          MBROPT(*REPLACE) STRDLM(' ') +
                          RMVBLANK(*BOTH) FLDDLM(';') DECPNT(*COMMA)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(INPUT) TOFILE(TVRELWAECO/QCLSRC) +
                        MBR(RPM_CONTRB)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(OUTPUT) TOFILE(TVRELWAECO/QCLSRC) +
                        MBR(RPM_CONTRT)
             MONMSG     MSGID(CPF0000)
             CALL     PGM(DUMMY512) PARM(&MD '#DC0010' ' ' ' ' +
                    'OUTPUT    '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(%SST(&MD 01 32)) VALUE(&TOFILEDE)
             CALL      PGM(DUMMY512) PARM(&MD '#RP0521' ' ' ' ' +
                             ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             FTP        RMTSYS('ftp.seit.dometic.com')

             DLTOVR     FILE(INPUT)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(OUTPUT)
             MONMSG     MSGID(CPF0000)

 ENDPGM:
             IF         COND(&ERROR2 = '0') THEN(DO)
             ENDDO

/*          PROTOKOLLIERUNG ---                                           */
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('ENDE ')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CHGVAR     VAR(%SST(&MD 100 10)) VALUE(&NBRCURRCD)
             CHGVAR     VAR(%SST(&MD 110 06)) VALUE(' SÄTZE')
             CHGVAR     VAR(%SST(&MD 116 12)) VALUE('=>RPM STK3  ')
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */
             DSPJOBLOG  OUTPUT(*PRINT)
             MONMSG     MSGID(CPF0000)
             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(TVRELWAECO)
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
                MONMSG     MSGID(CPF0000)
             ENDDO

             ENDPGM
