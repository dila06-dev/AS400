/******************************************************************************/
/*  Copyright 2013 by     trend SWM                                           */
/*                        Verwaltung GmbH                                     */
/*                        Gundelfinger Straße 11                              */
/*                        DE 79108 Freiburg                                   */
/* -------------------------------------------------------------------------- */
/*  Senden Daten an TNT Innight per FTP                                       */
/* -------------------------------------------------------------------------- */
/*  Erstellt: SZ 14.03.2013 Projekt 8997                                      */
/*                                                                            */
/******************************************************************************/
             PGM
/* -------------------------------------------------------------------------- */
/*  Definieren Programmvariable                                               */
/* -------------------------------------------------------------------------- */
             DCLF       FILE(PFTP)
             /* ------------------------------------------------------------- */
             DCL        VAR(&DAFIRM) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DASPCD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DAFEHL) TYPE(*CHAR) LEN(1)
             /* ------------------------------------------------------------- */
             DCL        VAR(&WKFNU2) TYPE(*CHAR) LEN(7)
             DCL        VAR(&WKFNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WKMSGF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WKLIBN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WKSTMF) TYPE(*CHAR) LEN(256)
             /* ------------------------------------------------------------- */
             DCL        VAR(&EXTREND) TYPE(*CHAR) LEN(1808)
             DCL        VAR(&RTTREND) TYPE(*CHAR) LEN(1621)
             DCL        VAR(&EXFTPI) TYPE(*CHAR) LEN(2048)
             DCL        VAR(&RTFTPI) TYPE(*CHAR) LEN(2048)
             /* ------------------------------------------------------------- */
             DCL        VAR(&EXFTPIPGST) TYPE(*CHAR) LEN(6)
             DCL        VAR(&EXFTPIZUBG) TYPE(*CHAR) LEN(20)
             DCL        VAR(&EXFTPIWKNR) TYPE(*CHAR) LEN(3)
             DCL        VAR(&EXFTPILANR) TYPE(*CHAR) LEN(3)
             /* ------------------------------------------------------------- */
             DCL        VAR(&RTFTPIWKNR) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RTFTPILANR) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RTFTPIZUBG) TYPE(*CHAR) LEN(20)
             DCL        VAR(&RTFTPIIADR) TYPE(*CHAR) LEN(128)
             DCL        VAR(&RTFTPITDIR) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RTFTPINASE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTFTPIAFSE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTFTPIUESC) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTFTPIUEBS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTFTPIUETS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTFTPIUEPR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTFTPIUEBP) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTFTPIUEPS) TYPE(*CHAR) LEN(10)
/* -------------------------------------------------------------------------- */
/*  Ermitteln Einstellungen aus FTPI                                          */
/* -------------------------------------------------------------------------- */
             CHGVAR     VAR(&EXFTPIPGST) VALUE('ERFTPI')
             CHGVAR     VAR(&EXFTPIWKNR) VALUE('001')
             CHGVAR     VAR(&EXFTPILANR) VALUE('001')
             CHGVAR     VAR(&EXFTPIZUBG) VALUE('TNT')
             /* ------------------------------------------------------------- */
             CHGVAR     VAR(%SST(&EXFTPI 1 6)) VALUE(&EXFTPIPGST)
             CHGVAR     VAR(%SST(&EXFTPI 65 3)) VALUE(&EXFTPIWKNR)
             CHGVAR     VAR(%SST(&EXFTPI 68 3)) VALUE(&EXFTPILANR)
             CHGVAR     VAR(%SST(&EXFTPI 71 20)) VALUE(&EXFTPIZUBG)
             /* ------------------------------------------------------------- */
             CALL       PGM(TRFTPI) PARM(&EXFTPI &RTFTPI)
             RTVDTAARA  DTAARA(*LDA (28 1)) RTNVAR(&DAFEHL)
/* -------------------------------------------------------------------------- */
/*  Programmvariable füllen                                                   */
/* -------------------------------------------------------------------------- */
             RTVDTAARA  DTAARA(*LDA (1 2)) RTNVAR(&DAFIRM)
             RTVDTAARA  DTAARA(*LDA (27 1)) RTNVAR(&DASPCD)
             CHGVAR     VAR(&WKMSGF) VALUE('TRFEHL' *TCAT &DASPCD)
             /* ------------------------------------------------------------- */
             CHGVAR     VAR(&RTFTPIWKNR) VALUE(%SST(&RTFTPI 134 3))
             CHGVAR     VAR(&RTFTPILANR) VALUE(%SST(&RTFTPI 137 3))
             CHGVAR     VAR(&RTFTPIZUBG) VALUE(%SST(&RTFTPI 140 20))
             CHGVAR     VAR(&RTFTPIIADR) VALUE(%SST(&RTFTPI 406 128))
             CHGVAR     VAR(&RTFTPITDIR) VALUE(%SST(&RTFTPI 549 256))
             CHGVAR     VAR(&RTFTPINASE) VALUE(%SST(&RTFTPI 805 10))
             CHGVAR     VAR(&RTFTPIAFSE) VALUE(%SST(&RTFTPI 830 10))
             CHGVAR     VAR(&RTFTPIUESC) VALUE(%SST(&RTFTPI 1382 10))
             CHGVAR     VAR(&RTFTPIUEBS) VALUE(%SST(&RTFTPI 1392 10))
             CHGVAR     VAR(&RTFTPIUETS) VALUE(%SST(&RTFTPI 1402 10))
             CHGVAR     VAR(&RTFTPIUEPR) VALUE(%SST(&RTFTPI 1412 10))
             CHGVAR     VAR(&RTFTPIUEBP) VALUE(%SST(&RTFTPI 1422 10))
             CHGVAR     VAR(&RTFTPIUEPS) VALUE(%SST(&RTFTPI 1442 10))
/* -------------------------------------------------------------------------- */
/*  Datei prüfen/zuordnen                                                     */
/* -------------------------------------------------------------------------- */
             CHKOBJ     OBJ(QTEMP/&RTFTPINASE) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             DLYJOB     DLY(1)
             ENDDO
             MONMSG     MSGID(CPF9801) EXEC(CRTDUPOBJ OBJ(&RTFTPINASE) +
                          FROMLIB(&RTFTPIUEBS) OBJTYPE(*FILE) TOLIB(QTEMP) +
                          NEWOBJ(&RTFTPINASE))
                                                                            /**/
 STEP01:     ALCOBJ     OBJ((QTEMP/&RTFTPINASE *FILE *EXCL))
             MONMSG     MSGID(CPF0000) EXEC(DO)
             DLYJOB     DLY(1)
             ENDDO
             MONMSG     MSGID(CPF1002) EXEC(DO)
             DLYJOB     DLY(5)
             GOTO       CMDLBL(STEP01)
             ENDDO
/* -------------------------------------------------------------------------- */
/*  Kopie Protokolldatei in QTEMP erstellen und Inhalt löschen                */
/* -------------------------------------------------------------------------- */
             CHKOBJ     OBJ(QTEMP/&RTFTPIUEPR) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTDUPOBJ OBJ(&RTFTPIUEPR) +
                          FROMLIB(&RTFTPIUEBP) OBJTYPE(*FILE) TOLIB(QTEMP) +
                          NEWOBJ(&RTFTPIUEPR))
             CLRPFM     FILE(QTEMP/&RTFTPIUEPR)
             MONMSG     MSGID(CPF3130)
/* -------------------------------------------------------------------------- */
/*  Inhalt Interfacedatei löschen und neu füllen                              */
/* -------------------------------------------------------------------------- */
             CLRPFM     FILE(QTEMP/&RTFTPINASE)
             MONMSG     MSGID(CPF0000)
             /* ------------------------------------------------------------- */
 STEP02:     OVRDBF     FILE(&RTFTPINASE) TOFILE(QTEMP/&RTFTPINASE) +
                          LVLCHK(*NO)
             CALL       PGM(&RTFTPIUEPS)
             DLTOVR     FILE(&RTFTPINASE)
                                                                            /**/
             RTVDTAARA  DTAARA(*LDA (28 1)) RTNVAR(&DAFEHL)
             IF         COND(&DAFEHL = '1') THEN(GOTO CMDLBL(WEITER))
             IF         COND(&DAFEHL = '2') THEN(GOTO CMDLBL(ERR2))
/* -------------------------------------------------------------------------- */
/*  Datum, Uhrzeit, Jobname und User in LOG-File schreiben                    */
/* -------------------------------------------------------------------------- */
 STEP04:     CALL       PGM(FTP000)
/* -------------------------------------------------------------------------- */
/*  Dateiüberschreibungen                                                     */
/* -------------------------------------------------------------------------- */
             OVRDBF     FILE(INPUT) TOFILE(&RTFTPIUEBS/&RTFTPIUESC) +
                          MBR(&RTFTPIUETS) LVLCHK(*NO)
             OVRDBF     FILE(OUTPUT) TOFILE(QTEMP/&RTFTPIUEPR) +
                          MBR(&RTFTPIUEPR) LVLCHK(*NO)
/* -------------------------------------------------------------------------- */
/*  FTP-Source ändern                                                         */
/* -------------------------------------------------------------------------- */
 STEP05:     CALL       PGM(FTP001) PARM(&RTFTPI)
                                                                            /**/
             RTVDTAARA  DTAARA(*LDA (28 1)) RTNVAR(&DAFEHL)
             IF         COND(&DAFEHL = '1') THEN(GOTO CMDLBL(ERR3))
/* -------------------------------------------------------------------------- */
             CHGVAR     VAR(&WKFNU2) VALUE(%SST(&RTFTPI 853 7))
             CHGVAR     VAR(&WKFNAM) VALUE(&RTFTPIAFSE *TCAT &WKFNU2)
/* -------------------------------------------------------------------------- */
/*  Senden Datei                                                              */
/* -------------------------------------------------------------------------- */
 FTP:        FTP        RMTSYS(&RTFTPIIADR)
/* -------------------------------------------------------------------------- */
/*  Protokolldatei prüfen                                                     */
/* -------------------------------------------------------------------------- */
             OVRDBF     FILE(&RTFTPIUEPR) TOFILE(QTEMP/&RTFTPIUEPR) LVLCHK(*NO)
             /* ------------------------------------------------------------- */
 LESEN:      RCVF       RCDFMT(PFTP1)
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ERR4))
             /* ------------------------------------------------------------- */
             IF         COND(%SST(&PFTPFELD 1 22) *EQ '226 Transfer +
                          complete.') THEN(GOTO CMDLBL(KORREKT))
             IF         COND(%SST(&PFTPFELD 1 41) *EQ '226 File +
                          transfer completed successfully.') +
                          THEN(GOTO CMDLBL(KORREKT))
             IF         COND(%SST(&PFTPFELD 1 33) *EQ '226 File +
                          successfully transferred') +
                          THEN(GOTO CMDLBL(KORREKT))
             IF         COND(%SST(&PFTPFELD 1 3) *NE '250') +
                          THEN(GOTO CMDLBL(LESEN))
             IF         COND(%SST(&PFTPFELD 5 37) *EQ 'File transfer +
                          completed successfully.') THEN(GOTO +
                          CMDLBL(KORREKT))
             IF         COND(%SST(&PFTPFELD 1 38) *EQ '250 File +
                          successfully renamed or moved') +
                          THEN(GOTO CMDLBL(KORREKT))
             GOTO       CMDLBL(LESEN)
/* -------------------------------------------------------------------------- */
/*  Update Status bei korrekter Übertragung                                   */
/* -------------------------------------------------------------------------- */
 KORREKT:    CALL       PGM(FTP002) PARM('0' &WKFNAM &RTFTPIZUBG &RTFTPIWKNR)
/* -------------------------------------------------------------------------- */
/*  Protokolldatei in Standarddatei kopieren                                  */
/* -------------------------------------------------------------------------- */
 KOPIEREN:   DLTOVR     FILE(&RTFTPIUEPR)
             MONMSG     MSGID(CPF0000)
             CPYF       FROMFILE(QTEMP/&RTFTPIUEPR) +
                          TOFILE(&RTFTPIUEBP/&RTFTPIUEPR) MBROPT(*ADD)
             MONMSG     MSGID(CPF0000)
/* -------------------------------------------------------------------------- */
/*  Überschreibungen löschen                                                  */
/* -------------------------------------------------------------------------- */
 WEITER:     DLTOVR     FILE(INPUT)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(OUTPUT)
             MONMSG     MSGID(CPF0000)
             DLCOBJ     OBJ((&RTFTPINASE *FILE *EXCL))
             MONMSG     MSGID(CPF0000)
             RCLRSC
             CHGVAR     VAR(&WKLIBN) VALUE(%SST(&RTFTPIZUBG 1 10))
                                                                            /**/
             IF         COND((%SST(&RTFTPIZUBG 1 3) = 'TNT') +
                          *AND ((&DAFEHL = '0') *OR (&DAFEHL = ' +
                          '))) THEN(DO)
             CPYF       FROMFILE(QTEMP/&RTFTPINASE) +
                          TOFILE(&WKLIBN/&WKFNAM) CRTFILE(*YES)
             MONMSG     MSGID(CPF0000)
             ENDDO
                                                                            /**/
             RGZPFM     FILE(QTEMP/&RTFTPINASE)
             MONMSG     MSGID(CPF0000)
             SNDPGMMSG  MSG(&RTFTPIUEPS *CAT ' ' *CAT &WKFNAM)
                                                                            /**/
             GOTO       CMDLBL(ENDE)
/* -------------------------------------------------------------------------- */
/*  Fehlerbehandlung                                                          */
/* -------------------------------------------------------------------------- */
 ERR1:       SNDPGMMSG  MSGID(STA8102) MSGF(&WKMSGF) TOUSR(*SYSOPR) +
                          MSGTYPE(*ESCAPE)
             CHGDTAARA  DTAARA(*LDA (28 1)) VALUE('1')
             GOTO       CMDLBL(WEITER)
/* -------------------------------------------------------------------------- */
 ERR2:       SNDPGMMSG  MSGID(STA8103) MSGF(&WKMSGF) TOUSR(*SYSOPR) +
                          MSGTYPE(*ESCAPE)
             CHGDTAARA  DTAARA(*LDA (28 1)) VALUE('1')
             GOTO       CMDLBL(WEITER)
/* -------------------------------------------------------------------------- */
 ERR3:       SNDPGMMSG  MSGID(STA8104) MSGF(&WKMSGF) TOUSR(*SYSOPR) +
                          MSGTYPE(*ESCAPE)
             CHGDTAARA  DTAARA(*LDA (28 1)) VALUE('1')
             GOTO       CMDLBL(WEITER)
/* -------------------------------------------------------------------------- */
 ERR4:       SNDPGMMSG  MSGID(STA8104) MSGF(&WKMSGF) TOUSR(*SYSOPR) +
                          MSGTYPE(*ESCAPE)
             CHGDTAARA  DTAARA(*LDA (28 1)) VALUE('1')
             CALL       PGM(FTP002) PARM('1' &WKFNAM &RTFTPIZUBG &RTFTPIWKNR)
             GOTO       CMDLBL(KOPIEREN)
/* -------------------------------------------------------------------------- */
/*  Programmende                                                              */
/* -------------------------------------------------------------------------- */
 ENDE:       RCLRSC
             ENDPGM
