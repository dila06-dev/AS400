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
             MONMSG     MSGID(CPF9801) EXEC(CRTDUPOBJ OBJ(&RTFTPINASE) +
                          FROMLIB(&RTFTPIUEBS) OBJTYPE(*FILE) TOLIB(QTEMP) +
                          NEWOBJ(&RTFTPINASE))
                                                                            /**/
 STEP01:     ALCOBJ     OBJ((QTEMP/&RTFTPINASE *FILE *EXCL))
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
  /*         CLRPFM     FILE(QTEMP/&RTFTPINASE)   */
  /*         MONMSG     MSGID(CPF0000)            */
             /* ------------------------------------------------------------- */
 STEP02:     OVRDBF     FILE(&RTFTPINASE) TOFILE(QTEMP/&RTFTPINASE) +
                          LVLCHK(*NO)
             CALL       PGM(&RTFTPIUEPS)
             DLTOVR     FILE(&RTFTPINASE)
                                                                            /**/
             RTVDTAARA  DTAARA(*LDA (28 1)) RTNVAR(&DAFEHL)
/* -------------------------------------------------------------------------- */
/*  Datum, Uhrzeit, Jobname und User in LOG-File schreiben                    */
/* -------------------------------------------------------------------------- */
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
             GOTO       CMDLBL(ENDE)
/* -------------------------------------------------------------------------- */
/*  Programmende                                                              */
/* -------------------------------------------------------------------------- */
 ENDE:       RCLRSC
             ENDPGM
