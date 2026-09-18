/*    * PROGRAMMNAME.:CALL ........                                          */
/*    * FUNKTION.....:IDCO                                                   */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    *                                                                       */
/*    * STANDARD:                                                             */
/*    * CHGDTAARA DTAARA(#DAYMINUS *ALL) VALUE(1)                             */
/*    * FUNKTION.....:...                                                    */
/*    *               ...                                                    */
/*    * WIEDER AUF 01 GESETZT, WURDE FÜR BATCHÜBERGABEN VORÜBERGEHEND         */
/*    * GEÄNDERT, UM ALLE EINZELSTAPEL ZU HABEN                               */
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
             DCL        VAR(&CC)         TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBRCURRCD)  TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBRCURRCD2) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&TIMESTAMP) TYPE(*CHAR) LEN(11) VALUE(' ')
             DCL        VAR(&TOFILENL) TYPE(*CHAR) LEN(32) VALUE('  ')
             DCL        VAR(&TOFILEBE) TYPE(*CHAR) LEN(32) VALUE('  ')
             DCL        VAR(&TOFILECH) TYPE(*CHAR) LEN(32) VALUE('  ')

             DCL        VAR(&#DAYMINUS) TYPE(*DEC) LEN(04 0)
             DCL        VAR(&PGM)       TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)       TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)       TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)       TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)       TYPE(*CHAR) LEN(50)

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('RPMIIRC#2 ')
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
 /*          GOTO       CMDLBL(ENDPGM)       */
             ADDLIBLE   LIB(TVRELWAECO) POSITION(*AFTER TFXF)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))

             IF         COND(&PARM *EQ '1' ) THEN(DO)
                CALL      PGM(FTP_TIMEST) PARM(&TIMESTAMP)
                          CHGVAR VAR(&TOFILENL) VALUE('NL411-20' *CAT +
                          (%SST(&TIMESTAMP 1 6)) *CAT '.csv')
                          CHGVAR VAR(&TOFILEBE) VALUE('BE111-20' *CAT +
                          (%SST(&TIMESTAMP 1 6)) *CAT '.csv')
                          CHGVAR VAR(&TOFILECH) VALUE('CH412-20' *CAT +
                          (%SST(&TIMESTAMP 1 6)) *CAT '.csv')
           /*          GOTO  GO                        */

                RTVDTAARA  DTAARA(#DAYMINUS *ALL) +
                          RTNVAR(&#DAYMINUS)
                IF         COND(&#DAYMINUS *EQ  01  ) THEN(DO)
    /*            CHGVAR VAR(&TOFILE) VALUE('DE411-20' *CAT +  */
    /*                    '121031' *CAT '.csv')                */
                ENDDO
/*             GENERELLER AUFBAU                                             */
/*             ZIEHEN RELEVANTER DATEN AUS #LBLB                             */
                CPYF       FROMFILE(TVRELWAECO/RPMII_TO#) +
                           TOFILE(TVRELWAECO/RPMII_TO#S) +
                           TOMBR(*FIRST) MBROPT(*ADD) CRTFILE(*NO)
                MONMSG     MSGID(CPF0000)
                CLRPFM     FILE(TVRELWAECO/RPMII_TO#)
                MONMSG     MSGID(CPF0000)
                CALL       PGM(RPMIIRP2#)
                MONMSG     MSGID(CPF0000)
                CALL       PGM(RPMIIRP2_#)
                MONMSG     MSGID(CPF0000)
                CLRPFM     FILE(TVRELWAECO/#RP0530)
                MONMSG     MSGID(CPF0000)

 GO:
       /*   *** NUR INHALTE, DIE ÜBERGEBEN WERDEN MÜSSEN                     */
       /*   *** FÜR ALLE SC'S                                                */
                CALL    PGM(DUMMY512) PARM(&MD '#RP0532' ' ' ' ' +
                            '#RP0530X' 'TVRELWAECO' '*REPLACE')
                MONMSG     MSGID(CPF0000)
       /*   *** SELEKTION ARTIKEL RANGE + SC-CODE                            */
                CHGVAR     VAR(&CC) VALUE('NL411     ')
 LOOP:
                IF         COND(&CC *EQ 'NL411     ') THEN(DO)
                   CHGVAR  VAR(%SST(&MD 01 10)) VALUE('NL411     ')
                ENDDO
                IF         COND(&CC *EQ 'BE111     ') THEN(DO)
                   CHGVAR  VAR(%SST(&MD 01 10)) VALUE('BE111     ')
                ENDDO
                IF         COND(&CC *EQ 'CH412     ') THEN(DO)
                   CHGVAR  VAR(%SST(&MD 01 10)) VALUE('CH412     ')
                ENDDO
                CALL    PGM(DUMMY512) PARM(&MD '#RP0531' ' ' ' ' +
                            '#RP0530' 'TVRELWAECO' '*REPLACE')
                MONMSG     MSGID(CPF0000)
                RTVMBRD    FILE(TVRELWAECO/#RP0530) +
                           NBRCURRCD(&NBRCURRCD)
                MONMSG     MSGID(CPF0000)
                IF         COND(&NBRCURRCD *GT 00000) THEN(DO)
                   CPYF       FROMFILE(TVRELWAECO/#RP0530) +
                          TOFILE(TVRELWAECO/#RP0530S#) TOMBR(*FIRST) +
                          MBROPT(*ADD) CRTFILE(*NO)
                   MONMSG     MSGID(CPF0000)
                   OVRDBF     FILE(INPUT) TOFILE(TVRELWAECO/QCLSRC) +
                             MBR(RPMIICMD)
                   MONMSG     MSGID(CPF0000)
                   OVRDBF     FILE(OUTPUT) TOFILE(TVRELWAECO/QCLSRC) +
                             MBR(RPMIILOG)
                   MONMSG     MSGID(CPF0000)
                   CALL     PGM(DUMMY512) PARM(&MD '#DC0010' ' ' ' ' +
                        'OUTPUT    '  'TVRELWAECO' '*ADD')
                   MONMSG     MSGID(CPF0000)

             /*   *** ABRUFDATEI FTP                                         */
                   QSYS/CPYTOIMPF FROMFILE(#RP0530) +
                          TOFILE(TVRELWAECO/RPMII4_OUT RPMII4_OUT) +
                          MBROPT(*REPLACE) STRDLM('"') +
                          RMVBLANK(*BOTH) FLDDLM(';') DECPNT(*COMMA)
                   MONMSG     MSGID(CPF0000)

                   IF         COND(&CC *EQ 'NL411     ') THEN(DO)
                      CHGVAR     VAR(%SST(&MD 01 32)) VALUE(&TOFILENL)
                   ENDDO
                   IF         COND(&CC *EQ 'BE111     ') THEN(DO)
                      CHGVAR     VAR(%SST(&MD 01 32)) VALUE(&TOFILEBE)
                   ENDDO
                   IF         COND(&CC *EQ 'CH412     ') THEN(DO)
                      CHGVAR     VAR(%SST(&MD 01 32)) VALUE(&TOFILECH)
                   ENDDO
                   CALL      PGM(DUMMY512) PARM(&MD '#RP0520' ' ' ' ' +
                             ' ' ' ' ' ')
                   MONMSG     MSGID(CPF0000)
                   FTP        RMTSYS('ftp.seit.dometic.com')
       /*          FTP        RMTSYS('ftp.seit.Bometic.BOB')  */
                   DLTOVR     FILE(INPUT)
                   MONMSG     MSGID(CPF0000)
                   DLTOVR     FILE(OUTPUT)
                   MONMSG     MSGID(CPF0000)
       /*   *** ...                                                          */
/*                                                                            */
                   RMVLNK    OBJLNK('/SALESCOMPANY/RPMII/#RP0530.CSV')
                   MONMSG     MSGID(CPF0000)
                   CVTDBF     OBJ('/SALESCOMPANY/RPMII/#RP0530.CSV') +
                            DBFILE(TVRELWAECO/#RP0530) DBOUTFMT(*CSV) +
                            DBFLDDSC(*YES)
                   MONMSG     MSGID(CPF0000)
                   OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                              FORMTYPE('#RP0530') OVRSCOPE(*JOB)
                   MONMSG     MSGID(CPF0000)
/*                                                                            */
                   CALL  PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                                 ' ' ' ' ' ')
                   MONMSG     MSGID(CPF0000)
                   DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
                   MONMSG     MSGID(CPF0000)
                   IF         COND(&CC *EQ 'CH412     ') THEN(DO)
                      OVRPRTF   FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                                 FORMTYPE('#RP0530CH') OVRSCOPE(*JOB)
                      MONMSG     MSGID(CPF0000)
/*                                                                            */
                    CALL PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                                 ' ' ' ' ' ')
                      MONMSG     MSGID(CPF0000)
                      DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
                      MONMSG     MSGID(CPF0000)
                   ENDDO


                ENDDO
                IF         COND(&CC *EQ 'NL411     ') THEN(DO)
                   CHGVAR     VAR(&CC) VALUE('BE111     ')
                   GOTO  LOOP
                ENDDO
                IF         COND(&CC *EQ 'BE111     ') THEN(DO)
                   CHGVAR     VAR(&CC) VALUE('CH412     ')
                   GOTO  LOOP
                ENDDO
             ENDDO
/*                                                                            */
 ENDPGM:
 /*          CHGVAR     VAR(&#DAYMINUS) VALUE(&#DAYMINUS -1)     */
 /*          CHGDTAARA  DTAARA(#DAYMINUS *ALL) VALUE(&#DAYMINUS) */
             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(TVRELWAECO)
                MONMSG     MSGID(CPF0000)
             ENDDO
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

             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
             ENDDO

             ENDPGM
