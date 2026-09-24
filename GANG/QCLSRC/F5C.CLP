/*    * PROGRAMMNAME.:F5C                                                    */
/*    * FUNKTION.....:.                                                      */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&PARM)

             DCL        VAR(&PARM)    TYPE(*CHAR) LEN(01)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&NBRCURRCD)  TYPE(*DEC) LEN(10 0)
             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&OUTFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&F5C)     TYPE(*CHAR) LEN(20)
             DCL        VAR(&QDATE)   TYPE(*CHAR) LEN(20)
             DCL        VAR(&QDATEV)  TYPE(*CHAR) LEN(20)
             DCL        VAR(&MSGFKT)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&FTP_DC) TYPE(*CHAR) LEN(10)

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))

             RTVSYSVAL  SYSVAL(QDATETIME) RTNVAR(&QDATE)
             CHGVAR     VAR(%SST(&QDATEV 1 2)) VALUE(%SST(&QDATE 7 2))
             CHGVAR     VAR(%SST(&QDATEV 3 2)) VALUE(%SST(&QDATE 5 2))
             CHGVAR     VAR(%SST(&QDATEV 5 4)) VALUE(%SST(&QDATE 1 4))

             RTVDTAARA  DTAARA(GANG/F5C) RTNVAR(&F5C)

    /*       GOTO       FTPDC                           */
             GOTO       X
             IF         COND(&QDATEV = &F5C) THEN(DO)
                GOTO       ENDPGM
             ENDDO
    /*                                                  */
    /*      HIST.OMA                                                         */
    /*                                                  */
             CLRPFM     FILE(GANG/F1)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(GANG/F2)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(GANG/F3)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(GANG/F4)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(GANG/F5)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(GANG/F6)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(GANG/FAKTURA_U)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(SBGNMON) TOFILE(HIST.OMA) +
                          OVRSCOPE(*CALLLVL)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(F5R)

             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(*ALL)
    /*                                                  */
    /*      SBGN.MON                                                         */
    /*                                                  */
             CLRPFM     FILE(GANG/F1B)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(GANG/F2B)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(GANG/F3B)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(GANG/F4B)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(GANG/F5B)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(GANG/F6B)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(GANG/FAKTURA_U)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(SBGNMON) TOFILE(SBGN.MON) +
                          OVRSCOPE(*CALLLVL)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(F1) TOFILE(F1B) OVRSCOPE(*CALLLVL)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(F2) TOFILE(F2B) OVRSCOPE(*CALLLVL)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(F3) TOFILE(F3B) OVRSCOPE(*CALLLVL)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(F4) TOFILE(F4B) OVRSCOPE(*CALLLVL)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(F5) TOFILE(F5B) OVRSCOPE(*CALLLVL)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(F6) TOFILE(F6B) OVRSCOPE(*CALLLVL)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(F5R)

             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(*ALL)

/*    *-PRÜFUNG RECHNUNGSDATEN AUS TREND                                     */
             CALL       PGM(DUMMY512) PARM(&MD '#DC1800' ' ' ' ' +
                             '#DC1800' 'GANG' '*REPLACE')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(' ' '#DC1801' ' ' ' ' ' ' +
                          ' ' ' ')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(' ' '#DC1802' ' ' ' ' ' ' +
                          ' ' ' ')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(' ' '#DC1803' ' ' ' ' ' ' +
                          ' ' ' ')
             MONMSG     MSGID(CPF0000)

             CHGDTAARA  DTAARA(GANG/F5C) VALUE(&QDATEV)
             MONMSG     MSGID(CPF0000)

 STA:
             CALL PGM(GANG/STATISTIK) PARM( '0')
             MONMSG     MSGID(CPF0000)

/*    *-ERSTELLEN ABHÄNGIGER ALTER ARTIKEL                                   */
             CALL       PGM(DUMMY512) PARM(&MD '#TR0001' ' ' ' ' +
                             'ERTEALT' 'MODWAO' '*REPLACE')
             MONMSG     MSGID(CPF0000)

 X:
    /* -AUFBAU PROTOKOLL MAHNDATEI(DOPPLETE NOCH ÜBERARBEITEN)               */
             CALL       PGM(DUMMY512) PARM(&MD '#SC0050' ' ' ' ' +
                             '#SC00502' 'GANG' '*ADD')
             MONMSG     MSGID(CPF0000)
             GOTO       CMDLBL(ENDPGM)

 #SBGAU600:
             CALL PGM(GANG/#SBGAU600) PARM()
             MONMSG     MSGID(CPF0000)

 INVOICE:
             CALL PGM(GANG/INVOICES) PARM('88505' '')
             MONMSG     MSGID(CPF0000)
             CALL PGM(GANG/INVOICES) PARM('40631' '')
             MONMSG     MSGID(CPF0000)

 OBSOLETE:
             CALL PGM(GANG/OBSOLETE) PARM('88505' '')
             MONMSG     MSGID(CPF0000)
             GOTO       CMDLBL(ENDPGM)

 FTPDC:

    /*      AUFBAU DER UPDATE-FILE FÜR OBSOLETE ARTICLES                     */
             CALL       PGM(DUMMY512) PARM(&MD '#DC0051' ' ' ' ' +
                             '#DC0051' 'BAR_KALK' '*ADD')
             MONMSG     MSGID(CPF0000)
    /*      LÖSCHEN ÄLTERER SÄTZE                                            */
             CALL       PGM(DUMMY512) PARM(&MD '#DC0052' ' ' ' ' ' ' +
                          ' ' ' ')
             MONMSG     MSGID(CPF0000)
    /*      ÜBERGABEDATEI GENERIEREN FÜR PROTOKOLL(#DC0053)                  */
             CALL       PGM(DUMMY512) PARM(&MD '#DC0053' ' ' ' ' +
                             '#DC0053' 'BAR_KALK' '*ADD')
             MONMSG     MSGID(CPF0000)
    /*      ÜBERGABEDATEI GENERIEREN FTP(&FTP_DC)                            */
             CHGVAR     VAR(%SST(&FTP_DC 1 2)) VALUE('DC')
             CHGVAR     VAR(%SST(&FTP_DC 3 8)) VALUE(%SST(&QDATE 1 +
                          8))
             CALL       PGM(DUMMY512) PARM(&MD '#DC0053' ' ' ' ' +
                             &FTP_DC 'BAR_KALK' '*REPLACE')
             MONMSG     MSGID(CPF0000)
    /*      ÜBERTRAGUNG FTP                                                  */
             RTVMBRD    FILE(BAR_KALK/&FTP_DC) NBRCURRCD(&NBRCURRCD)
             MONMSG     MSGID(CPF0000)
             IF         COND(&NBRCURRCD > 0) THEN(DO)
                CHGCURLIB  CURLIB(BAR_KALK)
                DLTF       FILE(BAR_KALK/OBSOLETE)
                MONMSG     MSGID(CPF0000)
                CPYF       FROMFILE(BAR_KALK/&FTP_DC) +
                           TOFILE(BAR_KALK/OBSOLETE) TOMBR(OBSOLETE) +
                           MBROPT(*REPLACE) CRTFILE(*YES)
                MONMSG     MSGID(CPF0000)
                OVRDBF     FILE(INPUT) TOFILE(GANG/FTP_DC)
                OVRDBF     FILE(OUTPUT) TOFILE(GANG/FTP_DCLOG)
       /*       FTP        RMTSYS('FTP.172.16.100.51')       */
       /*       ADDTCPHTE                                    */
                FTP        RMTSYS('BARENKAMP')
                CHGCURLIB  CURLIB(*CRTDFT)
             ENDDO
    /*                                                  */
             IF         COND(&NBRCURRCD > 0) THEN(DO)
                CHGCURLIB  CURLIB(GANG)
                DLTF       FILE(GANG/INVOICES)
                MONMSG     MSGID(CPF0000)
                CPYF       FROMFILE(QS36F/DOMINV_XX) +
                           TOFILE(GANG/INVOICES) TOMBR(INVOICES) +
                           MBROPT(*REPLACE) CRTFILE(*YES)
                MONMSG     MSGID(CPF0000)
                OVRDBF     FILE(INPUT) TOFILE(GANG/FTP_FR#050)
                OVRDBF     FILE(OUTPUT) TOFILE(GANG/FTP_FRLOG)
                FTP        RMTSYS('DOMETIC-GROUP.COM')
                CHGCURLIB  CURLIB(*CRTDFT)
             ENDDO
    /*                                                  */
    /* OVRDBF     FILE(INPUT) TOFILE(BAR_FTP/FTPCMD2)   */
    /* OVRDBF     FILE(OUTPUT) TOFILE(BAR_FTP/FTPLOG2)  */
    /*                                                  */
             IF         COND(&PARM = '1') THEN(DO)
             ENDDO
 ENDPGM:
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
             ENDDO
             OVRPRTF    FILE(QPJOBLOG) USRDTA(F5C)
             MONMSG     MSGID(CPF0000)
             DSPJOBLOG  OUTPUT(*PRINT)

             ENDPGM
