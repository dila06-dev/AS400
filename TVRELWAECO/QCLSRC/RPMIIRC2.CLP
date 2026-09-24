/*    * PROGRAMMNAME.:CALL ........                                          */
/*    * FUNKTION.....:IDCO                                                   */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    *                                                                       */
/*    * STANDARD:                                                             */
/*    * CHGDTAARA DTAARA(#DAYMINUS *ALL) VALUE(1)                             */
/*    * FUNKTION.....:ES WERDEN IMMER DIE DATEN VOM VORTAG VER-              */
/*    *               ARBEITET MIT DEM ZEITSTEMPEL VOM "CURRENT DAY".        */
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
             DCL        VAR(&NBRCURRCD)  TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBRCURRCD2) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&TIMESTAMP) TYPE(*CHAR) LEN(11) VALUE(' ')
             DCL        VAR(&TOFILE) TYPE(*CHAR) LEN(32) VALUE('  ')
             DCL        VAR(&QDAYOFWEEK) TYPE(*CHAR) LEN(04)
             DCL        VAR(&QDAY)  TYPE(*CHAR) LEN(02)

             DCL        VAR(&#DAYMINUS) TYPE(*DEC) LEN(04 0)
             DCL        VAR(&PGM)       TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)       TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)       TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)       TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)       TYPE(*CHAR) LEN(50)

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('RPMIIRC2  ')
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

         /*  GOTO       CMDLBL(ENDPGM) */

             RTVSYSVAL  SYSVAL(QDAYOFWEEK) RTNVAR(&QDAYOFWEEK)
             MONMSG     MSGID(CPF0000)
             RTVSYSVAL  SYSVAL(QDAY) RTNVAR(&QDAY)
             MONMSG     MSGID(CPF0000)

             CHGDTAARA  DTAARA(#DAYMINUS *ALL) VALUE(1)
             MONMSG     MSGID(CPF0000)

             IF         COND(&QDAYOFWEEK = '*MON' *AND &QDAY < '99') +
                          THEN(DO)
                CHGDTAARA  DTAARA(#DAYMINUS *ALL) VALUE(3)
                MONMSG     MSGID(CPF0000)
             ENDDO

             IF         COND(&PARM *EQ '1' ) THEN(DO)
                CALL      PGM(FTP_TIMEST) PARM(&TIMESTAMP)
                          CHGVAR VAR(&TOFILE) VALUE('DE411-20' *CAT +
                          (%SST(&TIMESTAMP 1 6)) *CAT '.csv')
                MONMSG     MSGID(CPF0000)
             /*        GOTO  GO         */
                RTVDTAARA  DTAARA(#DAYMINUS *ALL) +
                          RTNVAR(&#DAYMINUS)
    /*          IF         COND(&#DAYMINUS *EQ  02  ) THEN(DO) */
    /*            CHGVAR VAR(&TOFILE) VALUE('DE411-20' *CAT +  */
    /*                    '121107' *CAT '.csv')                */
    /*          ENDDO                                          */
                IF         COND(&#DAYMINUS *EQ  01  ) THEN(DO)
    /*            CHGVAR VAR(&TOFILE) VALUE('DE411-20' *CAT +  */
    /*                    '121031' *CAT '.csv')                */
                ENDDO
/*             GENERELLER AUFBAU                                             */
/*             ZIEHEN RELEVANTER DATEN AUS #LBLB                             */
          /*    CPYF       FROMFILE(TVRELWAECO/RPMII_TO) +        */
          /*               TOFILE(TVRELWAECO/RPMII_TOS) +         */
          /*               TOMBR(*FIRST) MBROPT(*ADD) CRTFILE(*NO)*/
          /*    MONMSG     MSGID(CPF0000)                         */
                CLRPFM     FILE(TVRELWAECO/RPMII_ERR)
                MONMSG     MSGID(CPF0000)
                CLRPFM     FILE(TVRELWAECO/RPMII_TO)
                MONMSG     MSGID(CPF0000)
                CALL       PGM(RPMIIRP2)
                MONMSG     MSGID(CPF0000)
                CALL       PGM(RPMIIRP2_)
                MONMSG     MSGID(CPF0000)
                CLRPFM     FILE(TVRELWAECO/#RP0530)
                MONMSG     MSGID(CPF0000)

       /*   *** NUR INHALTE, DIE ÜBERGEBEN WERDEN MÜSSEN                     */
       /*   ***  FROM RPMII WHERE RPMREPORT = '' ''                          */
                CALL    PGM(DUMMY512) PARM(&MD '#RP0530' ' ' ' ' +
                            '#RP0530' 'TVRELWAECO' '*REPLACE')
                MONMSG     MSGID(CPF0000)
 GO:
                RTVMBRD    FILE(TVRELWAECO/#RP0530) +
                           NBRCURRCD(&NBRCURRCD)
                MONMSG     MSGID(CPF0000)
                IF         COND(&NBRCURRCD *GT 00000) THEN(DO)
                   CPYF       FROMFILE(TVRELWAECO/#RP0530) +
                          TOFILE(TVRELWAECO/#RP0530S) TOMBR(*FIRST) +
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

             /*   *** ABRUFDATEI PC                                          */
                   QSYS/CPYTOIMPF FROMFILE(#RP0530) +
                          TOFILE(TVRELWAECO/RPMII4_OUT RPMII4_OUT) +
                          MBROPT(*REPLACE) STRDLM('"') +
                          RMVBLANK(*BOTH) FLDDLM(';') DECPNT(*COMMA)
                   MONMSG     MSGID(CPF0000)

                   CHGVAR     VAR(%SST(&MD 01 32)) VALUE(&TOFILE)
                   CALL      PGM(DUMMY512) PARM(&MD '#RP0520' ' ' ' ' +
                             ' ' ' ' ' ')
                   MONMSG     MSGID(CPF0000)
                   FTP        RMTSYS('ftp.seit.dometic.com')
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

                ENDDO
             ENDDO

/*    _UPDATE MONATLICH FREITAGS NEUE SKUS UND STK3  ________________     */
             IF         COND(&QDAYOFWEEK *EQ '*FRI' *AND &QDAY < +
                          '38') THEN(DO)
/*          *** STK3 UPLOAD FÜR RPM                                          */
                CALL       PGM(RPMIINEWC)
                MONMSG     MSGID(CPF0000)
/*                                                                            */
             ENDDO
/*    _______________________________________________________________     */

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
