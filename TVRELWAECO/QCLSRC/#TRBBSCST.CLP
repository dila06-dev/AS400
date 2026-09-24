/*    * PROGRAMMNAME.:CALL ........                                          */
/*    * FUNKTION.....:#TRBBSCST                                              */
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
             DCL        VAR(&NBRCURR##)  TYPE(*CHAR) LEN(10)

             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('#TRBBSCST ')
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

             QSYS/RTVMBRD FILE(BBSC) NBRCURRCD(&NBRCURRCD)
             MONMSG     MSGID(CPF0000)

             IF         COND(&NBRCURRCD *NE 0) THEN(DO)
       /*   *** CALL AUF TREND AUFTRÄGE GENERIEREN                           */
                CALL TRBBSCST
                MONMSG     MSGID(CPF0000)
                DSPJOBLOG  OUTPUT(*PRINT)
                MONMSG     MSGID(CPF0000)

       /*   *** ABGLEICHEN BESTELLDATEN IN PORDB2BV4                         */
                CALL    PGM(DUMMY512) PARM(&MD 'B2B0050' ' ' ' ' +
                            ' ' ' ' ' ')
                MONMSG     MSGID(CPF0000)
       /*   *** ABGLEICHEN ITEM#, ÜBERN-DAT, LF-TERMIN                       */
                CALL    PGM(DUMMY512) PARM(&MD 'B2B0060' ' ' ' ' +
                            ' ' ' ' ' ')
                MONMSG     MSGID(CPF0000)

       /*   *** ABGLEICHEN BESTELLDATEN IN PORDB2BV4                         */
                CALL    PGM(DUMMY512) PARM(&MD 'B2B0080' ' ' ' ' +
                            ' ' ' ' ' ')
                MONMSG     MSGID(CPF0000)

       /*   *** MELDUNG DEPARTMENT PURCHASING                                */
                CALL       PGM(DUMMY512) PARM(&MD 'B2B0070' ' ' ' ' +
                           'B2B0070   '  'TVRELWAECO' '*REPLACE')
                MONMSG     MSGID(CPF0000)

                CPYF       FROMFILE(BBSC) TOFILE(TVRELWAECO/BBSC_S) +
                     MBROPT(*ADD) CRTFILE(*NO)
                MONMSG     MSGID(CPF0000)

/*                                                                            */
       /*   *** PURCHASING                                                   */
/*                                                                            */
                RMVLNK     OBJLNK('/B2B/POSCHMANN/BBSC.CSV')
                MONMSG     MSGID(CPF0000)
                CVTDBF     OBJ('/B2B/POSCHMANN/BBSC.CSV') +
                             DBFILE(TVRELWAECO/B2B0070) +
                             DBOUTFMT(*CSV) DBFLDDSC(*YES)
                MONMSG     MSGID(CPF0000)
        /*      OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) + */
        /*             FORMTYPE('B2B') OVRSCOPE(*JOB)              */
                OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                          DEV(PRT55) FORMTYPE('B2B') OVRSCOPE(*JOB)
                MONMSG     MSGID(CPF0000)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                          ' ' ' ' ' ')
                MONMSG     MSGID(CPF0000)
                DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
                MONMSG     MSGID(CPF0000)
                CLRPFM     FILE(BBSC)
                MONMSG     MSGID(CPF0000)

             ENDDO

 ENDPGM:
             IF         COND(&ERROR2 = '0') THEN(DO)
             ENDDO
     /*      DSPJOBLOG  OUTPUT(*PRINT)        */

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
