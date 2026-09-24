/*    * PROGRAMMNAME.:CALL ........                                          */
/*    * FUNKTION.....:IDCO                                                   */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    * SELECT CURRENT TIMESTAMP TSTAMP FROM QSYS2/QSQPTABL                   */
/*    * DATEI SUNSITEM01 IN TVRELWAECO WURDE ERSTELLT.                        */
/*    *                                                                       */
/*    * UPDATE SUNSITEM01 SET TSTAMP =                                        */
/*    * (SELECT CURRENT TIMESTAMP TSTAMP FROM QSYS2/QSQPTABL)                 */
/*    *                                                                       */
/*    * UPDDTA SUNSITEM01                                                     */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
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
             DCL        VAR(&NBRCURRCD3) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBRCURRCD4) TYPE(*DEC) LEN(10 0)

             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)
             DCL        VAR(&QTIME)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&RUN) TYPE(*CHAR) LEN(1) VALUE(' ')

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('SUNSHINE_T')
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

/*     GOTO SAVE  */
/*     GOTO ENDPGM*/
             IF         COND(&PARM *EQ '1' ) THEN(DO)
/*             GENERELLER AUFBAU                                             */
/*             ZIEHEN RELEVANTER DATEN AUS #LBLB                             */
                RTVMBRD    FILE(TVRELWAECO/SUNSHINE_T) +
                           NBRCURRCD(&NBRCURRCD)
                MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&NBRCURRCD) +
                           VALUE(0))
                IF         COND(&NBRCURRCD *NE 0) THEN(DO)
/*     -----      TESTSYTEM NDE ARTIKEL SUNSHINE  AUSGABE                    */
                   OVRDBF     FILE(INPUT) TOFILE(TVRELWAECO/FTP) +
                             MBR(SUNSHCCMDT)
                   MONMSG     MSGID(CPF0000)
                   OVRDBF     FILE(OUTPUT) TOFILE(TVRELWAECO/FTP) +
                             MBR(SUNSHCLOGT)
                   MONMSG     MSGID(CPF0000)
                   CALL     PGM(DUMMY512) PARM(&MD '#DC0010' ' ' ' ' +
                           'OUTPUT    '  'TVRELWAECO' '*ADD')
                   MONMSG     MSGID(CPF0000)
                   FTP        RMTSYS('172.16.100.51') PORT(22)
                   DLTOVR     FILE(INPUT)
                   MONMSG     MSGID(CPF0000)
                   DLTOVR     FILE(OUTPUT)
                   MONMSG     MSGID(CPF0000)
       /*   *** ...                                                          */
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
