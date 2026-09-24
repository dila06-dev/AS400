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

             DCL        VAR(&NBRCURR_DE) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBRCURR_AU) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBRCURR_CH) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBRCURR_NL) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBRCURR_BE) TYPE(*DEC) LEN(10 0)

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
             CHGVAR     VAR(&PGM) VALUE('SUNSHINE_C')
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

             ADDLIBLE   LIB(TVRELWAECO) POSITION(*AFTER TFXF)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))

             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&QTIME)
             IF         COND(&QTIME *GT '090000' *AND &QTIME *LT +
                          '091500') THEN(DO)
                CALL       PGM(BESTOCKC) PARM('1')
                MONMSG     MSGID(CPF0000)
                CHGVAR     VAR(&RUN) VALUE('1')
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&QTIME *GT '120000' *AND &QTIME *LT +
                          '121500') THEN(DO)
                CALL       PGM(BESTOCKC) PARM('1')
                MONMSG     MSGID(CPF0000)
                CHGVAR     VAR(&RUN) VALUE('1')
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&QTIME *GT '160000' *AND &QTIME *LT +
                          '161500') THEN(DO)
                CALL       PGM(BESTOCKC) PARM('1')
                MONMSG     MSGID(CPF0000)
                CHGVAR     VAR(&RUN) VALUE('1')
                MONMSG     MSGID(CPF0000)
             ENDDO

/*     GOTO SAVE  */
 /*    GOTO ENDPGM  */
             IF         COND(&PARM *EQ '1' ) THEN(DO)
                CLRPFM     SUNSHINE_C
                MONMSG     MSGID(CPF0000)
                CLRPFM     SUNSHINE_D
                MONMSG     MSGID(CPF0000)
                CLRPFM     SUNSHINE_E
                MONMSG     MSGID(CPF0000)
                CLRPFM     SUNSHINE_F
                MONMSG     MSGID(CPF0000)
                CLRPFM     SUNSHINE_G
                MONMSG     MSGID(CPF0000)
/*             ERMITTLUNG RELEVANTER AUFTRÄGE                                */
                CALL       ORDERSUNS
                MONMSG     MSGID(CPF0000)
                ALCOBJ     OBJ((TVPF/BBSC *FILE *EXCLRD))
                MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDPGM))


                CALL       PGM(TVRELWAECO/ORDERIN_R6)
                MONMSG     MSGID(CPF0000)
/*             GENERELLER AUFBAU                                             */
/*             ZIEHEN RELEVANTER DATEN AUS #LBLB                             */
/*                        EDC                                                           */
                RTVMBRD    FILE(TVRELWAECO/SUNSHINE_C) +
                           NBRCURRCD(&NBRCURR_DE)
                MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&NBRCURR_DE) +
                           VALUE(0))
/*                        BELGIEN                                                       */
                RTVMBRD    FILE(TVRELWAECO/SUNSHINE_D) +
                           NBRCURRCD(&NBRCURR_BE)
                MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&NBRCURR_BE) +
                           VALUE(0))
/*                        NIEDERLANDE                                                   */
                RTVMBRD    FILE(TVRELWAECO/SUNSHINE_E) +
                           NBRCURRCD(&NBRCURR_NL)
                MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&NBRCURR_NL) +
                           VALUE(0))
/*                        ÖSTERREICH                                                    */
                RTVMBRD    FILE(TVRELWAECO/SUNSHINE_F) +
                           NBRCURRCD(&NBRCURR_AU)
                MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&NBRCURR_AU) +
                           VALUE(0))
/*                        SCHWEIZ                                                       */
                RTVMBRD    FILE(TVRELWAECO/SUNSHINE_G) +
                           NBRCURRCD(&NBRCURR_CH)
                MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&NBRCURR_CH) +
                           VALUE(0))

                IF      COND(&NBRCURR_DE *NE 0 *OR &NBRCURR_BE *NE 0 +
                          *OR &NBRCURR_NL *NE 0 *OR &NBRCURR_NL *NE +
                          0 *OR &NBRCURR_AU *NE 0 *OR &NBRCURR_CH +
                          *NE 0) THEN(DO)

                   CPYF FROMFILE(TVRELWAECO/SUNSHINE_C) +
                   TOFILE(TVRELWAECO/SUNSHINE_S)        +
                   MBROPT(*ADD) FMTOPT(*MAP *DROP)
                   MONMSG     MSGID(CPF0000)

                   CPYF FROMFILE(TVRELWAECO/SUNSHINE_D) +
                   TOFILE(TVRELWAECO/SUNSHINE_S)        +
                   MBROPT(*ADD) FMTOPT(*MAP *DROP)
                   MONMSG     MSGID(CPF0000)

                   CPYF FROMFILE(TVRELWAECO/SUNSHINE_E) +
                   TOFILE(TVRELWAECO/SUNSHINE_S)        +
                   MBROPT(*ADD) FMTOPT(*MAP *DROP)
                   MONMSG     MSGID(CPF0000)

                   CPYF FROMFILE(TVRELWAECO/SUNSHINE_F) +
                   TOFILE(TVRELWAECO/SUNSHINE_S)        +
                   MBROPT(*ADD) FMTOPT(*MAP *DROP)
                   MONMSG     MSGID(CPF0000)

                   CPYF FROMFILE(TVRELWAECO/SUNSHINE_G) +
                   TOFILE(TVRELWAECO/SUNSHINE_S)        +
                   MBROPT(*ADD) FMTOPT(*MAP *DROP)
                   MONMSG     MSGID(CPF0000)

                   MONMSG     MSGID(CPF0000)
                   OVRDBF     FILE(INPUT) TOFILE(TVRELWAECO/QCLSRC) +
                             MBR(SUNSHCCMD)
                   MONMSG     MSGID(CPF0000)
                   OVRDBF     FILE(OUTPUT) TOFILE(TVRELWAECO/QCLSRC) +
                             MBR(SUNSHCLOG)
                   MONMSG     MSGID(CPF0000)
                   CALL     PGM(DUMMY512) PARM(&MD '#DC0010' ' ' ' ' +
                           'OUTPUT    '  'TVRELWAECO' '*ADD')
                   MONMSG     MSGID(CPF0000)
                   IF         COND(&NBRCURR_DE *NE 0) THEN(DO)
                      FTP        RMTSYS('ftp.seit.dometic.com')
                   ENDDO
                   DLTOVR     FILE(INPUT)
                   MONMSG     MSGID(CPF0000)
                   DLTOVR     FILE(OUTPUT)
                   MONMSG     MSGID(CPF0000)

/*     -----   *  TESTSYTEM NDE ARTIKEL SUNSHINE  AUSGABE                    */
/*     -----      _______________________________________________            */
       /*   ***   DE411                                                      */
                   IF      COND(&NBRCURR_DE *NE 0) THEN(DO)
                      OVRDBF     FILE(INPUT) TOFILE(TVRELWAECO/FTP) +
                                MBR(SUNSHCCMD)
                      MONMSG     MSGID(CPF0000)
                      OVRDBF     FILE(OUTPUT) TOFILE(TVRELWAECO/FTP) +
                                MBR(SUNSHCLOG)
                      MONMSG     MSGID(CPF0000)

/*     -----      ACHTUNG DIRECTORIES UND FILE ÄNDERN                        */
                      CHGVAR     VAR(%SST(&MD 01 30)) VALUE('cd +
                             /de411/snd                 ')
                      CALL     PGM(DUMMY512) PARM(&MD '#SU0050' ' ' ' ' +
                           ' '  ' ' ' ')
                      MONMSG     MSGID(CPF0000)
                      CHGVAR     VAR(%SST(&MD 01 40)) VALUE('APPEND +
                             SUNSHINE_C ORDERINPUT.TXT')
                      CALL     PGM(DUMMY512) PARM(&MD '#SU0051' ' ' ' ' +
                              ' '  ' ' ' ')
                      MONMSG     MSGID(CPF0000)
                      CALL     PGM(DUMMY512) PARM(&MD '#DC0010' ' ' ' ' +
                              'OUTPUT    '  'TVRELWAECO' '*ADD')
                      MONMSG     MSGID(CPF0000)
                      FTP        RMTSYS('172.16.100.51') PORT(22)
                      DLTOVR     FILE(INPUT)
                      MONMSG     MSGID(CPF0000)
                      DLTOVR     FILE(OUTPUT)
                      MONMSG     MSGID(CPF0000)
                   ENDDO
       /*   ***   BE111                                                      */
                   IF      COND(&NBRCURR_BE *NE 0) THEN(DO)
                      OVRDBF     FILE(INPUT) TOFILE(TVRELWAECO/FTP) +
                                MBR(SUNSHCCMD)
                      MONMSG     MSGID(CPF0000)
                      OVRDBF     FILE(OUTPUT) TOFILE(TVRELWAECO/FTP) +
                                MBR(SUNSHCLOG)
                      MONMSG     MSGID(CPF0000)

/*     -----      ACHTUNG DIRECTORIES UND FILE ÄNDERN                        */
                      CHGVAR     VAR(%SST(&MD 01 30)) VALUE('cd +
                             /be111/snd                 ')
                      CALL     PGM(DUMMY512) PARM(&MD '#SU0050' ' ' ' ' +
                           ' '  ' ' ' ')
                      MONMSG     MSGID(CPF0000)
                      CHGVAR     VAR(%SST(&MD 01 40)) VALUE('APPEND +
                             SUNSHINE_D ORDERINPUT.TXT')
                      CALL     PGM(DUMMY512) PARM(&MD '#SU0051' ' ' ' ' +
                              ' '  ' ' ' ')
                      MONMSG     MSGID(CPF0000)
                      CALL     PGM(DUMMY512) PARM(&MD '#DC0010' ' ' ' ' +
                              'OUTPUT    '  'TVRELWAECO' '*ADD')
                      MONMSG     MSGID(CPF0000)
                      FTP        RMTSYS('172.16.100.51') PORT(22)
                      DLTOVR     FILE(INPUT)
                      MONMSG     MSGID(CPF0000)
                      DLTOVR     FILE(OUTPUT)
                      MONMSG     MSGID(CPF0000)
                   ENDDO
       /*   ***   NL411                                                      */
                   IF      COND(&NBRCURR_NL *NE 0) THEN(DO)
                      OVRDBF     FILE(INPUT) TOFILE(TVRELWAECO/FTP) +
                                MBR(SUNSHCCMD)
                      MONMSG     MSGID(CPF0000)
                      OVRDBF     FILE(OUTPUT) TOFILE(TVRELWAECO/FTP) +
                                MBR(SUNSHCLOG)
                      MONMSG     MSGID(CPF0000)

/*     -----      ACHTUNG DIRECTORIES UND FILE ÄNDERN                        */
                      CHGVAR     VAR(%SST(&MD 01 30)) VALUE('cd +
                             /nl411/snd                 ')
                      CALL     PGM(DUMMY512) PARM(&MD '#SU0050' ' ' ' ' +
                           ' '  ' ' ' ')
                      MONMSG     MSGID(CPF0000)
                      CHGVAR     VAR(%SST(&MD 01 40)) VALUE('APPEND +
                             SUNSHINE_E ORDERINPUT.TXT')
                      CALL     PGM(DUMMY512) PARM(&MD '#SU0051' ' ' ' ' +
                              ' '  ' ' ' ')
                      MONMSG     MSGID(CPF0000)
                      CALL     PGM(DUMMY512) PARM(&MD '#DC0010' ' ' ' ' +
                              'OUTPUT    '  'TVRELWAECO' '*ADD')
                      MONMSG     MSGID(CPF0000)
                      FTP        RMTSYS('172.16.100.51') PORT(22)
                      DLTOVR     FILE(INPUT)
                      MONMSG     MSGID(CPF0000)
                      DLTOVR     FILE(OUTPUT)
                      MONMSG     MSGID(CPF0000)
                   ENDDO
       /*   ***   AT411                                                      */
                   IF      COND(&NBRCURR_AU *NE 0) THEN(DO)
                      OVRDBF     FILE(INPUT) TOFILE(TVRELWAECO/FTP) +
                                MBR(SUNSHCCMD)
                      MONMSG     MSGID(CPF0000)
                      OVRDBF     FILE(OUTPUT) TOFILE(TVRELWAECO/FTP) +
                                MBR(SUNSHCLOG)
                      MONMSG     MSGID(CPF0000)

/*     -----      ACHTUNG DIRECTORIES UND FILE ÄNDERN                        */
                      CHGVAR     VAR(%SST(&MD 01 30)) VALUE('cd +
                             /at411/snd                 ')
                      CALL     PGM(DUMMY512) PARM(&MD '#SU0050' ' ' ' ' +
                           ' '  ' ' ' ')
                      MONMSG     MSGID(CPF0000)
                      CHGVAR     VAR(%SST(&MD 01 40)) VALUE('APPEND +
                             SUNSHINE_F ORDERINPUT.TXT')
                      CALL     PGM(DUMMY512) PARM(&MD '#SU0051' ' ' ' ' +
                              ' '  ' ' ' ')
                      MONMSG     MSGID(CPF0000)
                      CALL     PGM(DUMMY512) PARM(&MD '#DC0010' ' ' ' ' +
                              'OUTPUT    '  'TVRELWAECO' '*ADD')
                      MONMSG     MSGID(CPF0000)
                      FTP        RMTSYS('172.16.100.51') PORT(22)
                      DLTOVR     FILE(INPUT)
                      MONMSG     MSGID(CPF0000)
                      DLTOVR     FILE(OUTPUT)
                      MONMSG     MSGID(CPF0000)
                   ENDDO
       /*   ***   ch412                                                      */
                   IF      COND(&NBRCURR_CH *NE 0) THEN(DO)
                      OVRDBF     FILE(INPUT) TOFILE(TVRELWAECO/FTP) +
                                MBR(SUNSHCCMD)
                      MONMSG     MSGID(CPF0000)
                      OVRDBF     FILE(OUTPUT) TOFILE(TVRELWAECO/FTP) +
                                MBR(SUNSHCLOG)
                      MONMSG     MSGID(CPF0000)

/*     -----      ACHTUNG DIRECTORIES UND FILE ÄNDERN                        */
                      CHGVAR     VAR(%SST(&MD 01 30)) VALUE('cd +
                             /ch412/snd                 ')
                      CALL     PGM(DUMMY512) PARM(&MD '#SU0050' ' ' ' ' +
                           ' '  ' ' ' ')
                      MONMSG     MSGID(CPF0000)
                      CHGVAR     VAR(%SST(&MD 01 40)) VALUE('APPEND +
                             SUNSHINE_G ORDERINPUT.TXT')
                      CALL     PGM(DUMMY512) PARM(&MD '#SU0051' ' ' ' ' +
                              ' '  ' ' ' ')
                      MONMSG     MSGID(CPF0000)
                      CALL     PGM(DUMMY512) PARM(&MD '#DC0010' ' ' ' ' +
                              'OUTPUT    '  'TVRELWAECO' '*ADD')
                      MONMSG     MSGID(CPF0000)
                      FTP        RMTSYS('172.16.100.51') PORT(22)
                      DLTOVR     FILE(INPUT)
                      MONMSG     MSGID(CPF0000)
                      DLTOVR     FILE(OUTPUT)
                      MONMSG     MSGID(CPF0000)
                   ENDDO
                ENDDO

             DLCOBJ     OBJ((TVPF/BBSC *FILE *EXCLRD))
             MONMSG     MSGID(CPF0000)

/*     -----      A L L ES  FEHLERHANDLING UND MITTEILUNGEN                  */
       /*   *** ...                                                          */
/*     -----      MAIL FEHLENDE ARTIKEL SUNSHINE  AUSGABE                    */
             OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                          PAGESIZE(*N 160) CPI(15) OVRFLW(36) +
                          FOLD(*YES) FORMTYPE('SUNSITEM01') +
                          OVRSCOPE(*JOB)
                   MONMSG     MSGID(CPF0000)
/*                MAIL FEHLENDE ARTIKEL SUNSHINE                             */
                  CHGVAR  VAR(%SST(&MD 01 60)) VALUE(' missing SKU in +
                          system Geluwe              ')
                   CALL PGM(DUMMY512) PARM(&MD '#SU0301' ' ' ' '     +
                          ' ' ' ' ' ')
                   MONMSG     MSGID(CPF0000)
                   CLRPFM     FILE(QTEMP/#SU0300)
                   MONMSG     MSGID(CPF0000)
                   CALL     PGM(DUMMY512) PARM(&MD '#SU0300' ' ' ' ' +
                                 '#SU0300   '  'QTEMP' '*REPLACE')
                   MONMSG     MSGID(CPF0000)
                   RTVMBRD    FILE(QTEMP/#SU0300) +
                              NBRCURRCD(&NBRCURRCD3)
                   MONMSG     MSGID(CPF0000)
                   IF         COND(&NBRCURRCD3 *NE 0) THEN(DO)
                    CALL PGM(DUMMY512) PARM(&MD '#SU0300' ' ' 'PRT55' +
                          ' ' ' ' ' ')
                    MONMSG     MSGID(CPF0000)
                   ENDDO
                   DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
                   MONMSG     MSGID(CPF0000)
/*                UPDATE TIMESTAMP                                           */
                   CALL PGM(DUMMY512) PARM(&MD '#SU0200' ' ' 'PRT55' +
                          ' ' ' ' ' ')
                   MONMSG     MSGID(CPF0000)
                   DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
                   MONMSG     MSGID(CPF0000)
                   DLYJOB     DLY(60)

/*     -----      AKTUELLE AUFTRÄGE MELDEN        AUFTRÄGE                   */
             OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                          PAGESIZE(*N 160) CPI(15) OVRFLW(36) +
                          FOLD(*YES) FORMTYPE('SUNSITEM02') +
                          OVRSCOPE(*JOB)
                   MONMSG     MSGID(CPF0000)
/*                AKTUELLE AUFTRÄGE MELDEN                                   */
                   CHGVAR     VAR(%SST(&MD 01 60)) VALUE(' new orders +
                          arrived by import              ')
                   CALL PGM(DUMMY512) PARM(&MD '#SU0401' ' ' ' '     +
                          ' ' ' ' ' ')
                   MONMSG     MSGID(CPF0000)
                   CALL PGM(DUMMY512) PARM(&MD '#SU0400' ' ' 'PRT55' +
                          ' ' ' ' ' ')
                   MONMSG     MSGID(CPF0000)
                   DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
                   MONMSG     MSGID(CPF0000)
/*                UPDATE TIMESTAMP                                           */
                   CALL PGM(DUMMY512) PARM(&MD '#SU0200' ' ' 'PRT55' +
                          ' ' ' ' ' ')
                   MONMSG     MSGID(CPF0000)
                   DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
                   MONMSG     MSGID(CPF0000)
                   DLYJOB     DLY(60)


/*     -----      SPECIELLE ARTIKELFEHLER                                    */
             OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                          PAGESIZE(*N 160) CPI(15) OVRFLW(36) +
                          FOLD(*YES) FORMTYPE('SUNSITEM03') +
                          OVRSCOPE(*JOB)
                   MONMSG     MSGID(CPF0000)
/*                MAIL FEHLENDE ARTIKEL SUNSHINE                             */
                  CHGVAR  VAR(%SST(&MD 01 60)) VALUE(' refused order l+
                          ines!!!                    ')
                   CALL PGM(DUMMY512) PARM(&MD '#SU0501' ' ' ' '     +
                          ' ' ' ' ' ')
                   MONMSG     MSGID(CPF0000)
                   CLRPFM     FILE(QTEMP/#SU0500)
                   MONMSG     MSGID(CPF0000)
                   CALL     PGM(DUMMY512) PARM(&MD '#SU0500' ' ' ' ' +
                                 '#SU0500   '  'QTEMP' '*REPLACE')
                   MONMSG     MSGID(CPF0000)
                   RTVMBRD    FILE(QTEMP/#SU0500) +
                              NBRCURRCD(&NBRCURRCD4)
                   MONMSG     MSGID(CPF0000)
                   IF         COND(&NBRCURRCD4 *NE 0) THEN(DO)
                    CALL PGM(DUMMY512) PARM(&MD '#SU0500' ' ' 'PRT55' +
                          ' ' ' ' ' ')
                    MONMSG     MSGID(CPF0000)
                   ENDDO
                   DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
                   MONMSG     MSGID(CPF0000)
                   DLYJOB     DLY(60)

       /*   *** ...                                                          */
       /*       ENDDO      */

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
