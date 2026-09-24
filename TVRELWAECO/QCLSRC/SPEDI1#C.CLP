/*    * PROGRAMMNAME.:CALL ........                                          */
/*    * FUNKTION.....:SPEDI1                                                 */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    * BEI ERNEUTER ÜBERTRAGUNG WIRD VORHER EINE PC-DATEI GENERIERT          */
/*    * ÜBER:                                                                 */
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
             DCL        VAR(&NBRCURR##)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBRCURRCD2) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&VERSION)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&VON) TYPE(*DEC) LEN(6 0) VALUE(010110)
             DCL        VAR(&BIS) TYPE(*DEC) LEN(6 0) VALUE(310311)
             DCL        VAR(&TIMESTAMP) TYPE(*CHAR) LEN(11) VALUE(' ')
             DCL        VAR(&TOFILE) TYPE(*CHAR) LEN(32) VALUE('  ')

             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))

             ADDLIBLE   LIB(TVRELWAECO) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('SPEDI1#C  ')
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

             CALL       PGM(TVRELWAECO/IFSP16TN)
             MONMSG     MSGID(CPF0000)
             DSPJOBLOG  OUTPUT(*PRINT)

             CLRPFM     FILE(TVRELWAECO/#SP0005)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/#SP0015)
             MONMSG     MSGID(CPF0000)

             CALL       PGM(DUMMY512) PARM(&MD '#SP0005' ' ' ' ' +
                           '#SP0005   '  'TVRELWAECO' '*REPLACE')
             MONMSG     MSGID(CPF0000)

             CALL       PGM(DUMMY512) PARM(' ' '#SP0005' ' ' ' ' +
                           'SPEDI1#'  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
             QSYS/RTVMBRD FILE(TVRELWAECO/#SP0005) +
                          NBRCURRCD(&NBRCURRCD)
             MONMSG     MSGID(CPF0000)

/*                                                                            */
             IF         COND(&NBRCURRCD *GT 0) THEN(DO)
                CALL       PGM(DUMMY512) PARM(' ' '#SP0015' ' ' ' ' +
                              '#SP0015'  'QTEMP' '*REPLACE')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(FTP_TIMEST) PARM(&TIMESTAMP)
                CHGVAR     VAR(&TOFILE) VALUE('N_' *CAT +
                             (%SST(&TIMESTAMP 01 6)) *CAT +
                             (%SST(&TIMESTAMP 08 4)) *CAT '01.WAD')
                CHGVAR     VAR(&MD) +
                          VALUE('                                     -
                                                            ')
                CHGVAR     VAR(%SST(&MD 01 32)) VALUE(&TOFILE)

                OVRDBF     FILE(INPUT) TOFILE(TVRELWAECO/QCLSRC) +
                           MBR(TNTCMD)
                MONMSG     MSGID(CPF0000)
                OVRDBF     FILE(OUTPUT) TOFILE(TVRELWAECO/QCLSRC) +
                           MBR(TNTLOG)
                MONMSG     MSGID(CPF0000)
                CALL      PGM(DUMMY512) PARM(&MD '#SP0010' ' ' ' ' +
                          ' ' ' ' ' ')
                MONMSG     MSGID(CPF0000)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0010' ' ' ' ' +
                        'OUTPUT    '  'TVRELWAECO' '*ADD')
                MONMSG     MSGID(CPF0000)
                FTP        RMTSYS('62.159.142.203')
                MONMSG     MSGID(CPF0000)
                DLTOVR     FILE(INPUT)
                MONMSG     MSGID(CPF0000)
                DLTOVR     FILE(OUTPUT)
                MONMSG     MSGID(CPF0000)
             ENDDO
/*                                                                            */
 ENDPGM:
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

             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
             ENDDO

             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(TVRELWAECO)
             ENDDO

             ENDPGM
