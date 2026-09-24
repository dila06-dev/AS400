/*-------------------------------------------------*/
/* Generischen FTP Command erstellen - Invoices    */
/*-------------------------------------------------*/
             PGM        PARM(&SUBSIDIARY)


/*Variablen bestimmen */
             DCL        VAR(&CMD) TYPE(*CHAR) LEN(3) VALUE('CMD')
             DCL        VAR(&LOG) TYPE(*CHAR) LEN(3) VALUE('LOG')

             DCL        VAR(&MBRNAMECMD) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&MBRNAMELOG) TYPE(*CHAR) LEN(10) VALUE(' ')

             DCL        VAR(&SYSTEMNAME) TYPE(*CHAR) LEN(32) VALUE('  ')
             DCL        VAR(&Subsidiary) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FtpUser)    TYPE(*CHAR) LEN(10) VALUE('  ')
             DCL        VAR(&Password)   TYPE(*CHAR) LEN(10) VALUE('  ')
             DCL        VAR(&FtpMode)    TYPE(*CHAR) LEN(10) VALUE('  ')
             DCL        VAR(&NameFormat) TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&FtpCommand) TYPE(*CHAR) LEN(4 ) VALUE('  ')
             DCL        VAR(&FromDir)   TYPE(*CHAR) LEN(80) VALUE('  ')
             DCL        VAR(&FromFile)   TYPE(*CHAR) LEN(32) VALUE('  ')
             DCL        VAR(&ToDir)     TYPE(*CHAR) LEN(80) VALUE('  ')
             DCL        VAR(&Tofile)     TYPE(*CHAR) LEN(32) VALUE('  ')
             DCL        VAR(&TIMESTAMP) TYPE(*CHAR) LEN(11) VALUE(' ')
             DCL        VAR(&SRCCOMMENT) TYPE(*CHAR) LEN(40) VALUE(' ')
             DCL        VAR(&LOGCOMMENT) TYPE(*CHAR) LEN(40) VALUE(' ')
             DCL        VAR(&DELE_AFTER) TYPE(*CHAR) LEN(1) VALUE('0')

/*Nur bei gefüllten Subsidiary ausführen */
             CHGVAR     VAR(&SUBSIDIARY) VALUE(&SUBSIDIARY)
             MONMSG     MSGID(MCH3601) EXEC(GOTO CMDLBL(ENDE))
             IF         COND(&SUBSIDIARY *EQ '  ') THEN(GOTO +
                          CMDLBL(ENDE))

/* Fix-Felder belegen */
             CHGVAR     VAR(&CMD) VALUE('CMD')
             CHGVAR     VAR(&LOG) VALUE('LOG')
             CHGVAR     VAR(&SYSTEMNAME) VALUE('dometic-group.com')
             CHGVAR     VAR(&FtpUser) VALUE('winadmin')
             CHGVAR     VAR(&Password) VALUE('3veKhCMZ')
             CHGVAR     VAR(&FtpMode) VALUE('ascii')
             CHGVAR     VAR(&NameFormat) VALUE('0')
             CHGVAR     VAR(&FTPCOMMAND) VALUE('PUT')
             CHGVAR     VAR(&FROMDIR) +
                          VALUE('domains/dometic-group.com/public_ftp+
                          /dw' *CAT &SUBSIDIARY *CAT '/rcv')
             CHGVAR     VAR(&FROMFILE) VALUE('DOMINV_' *CAT +
                          &SUBSIDIARY)
             CHGVAR     VAR(&ToDir) VALUE('TVRELWAECO')
      /*     CHGVAR     VAR(&ToDir) VALUE('POHL')    */
             CALL       PGM(FTP_TIMEST) PARM(&TIMESTAMP)
             CHGVAR     VAR(&TOFILE) VALUE(&SUBSIDIARY *CAT 'i' *CAT +
                          &TIMESTAMP *CAT '.txt')
             CHGVAR     VAR(&SRCCOMMENT) VALUE('Invoices ' *CAT +
                          &SUBSIDIARY *CAT ' per FTP melden')
             CHGVAR     VAR(&LOGCOMMENT) VALUE('Protokoll - ' *CAT +
                          &SRCComment)
             CHGVAR     VAR(&dele_after) VALUE('0')

/* MBR-Files erstellen und clearen */
             CHGVAR     VAR(&MBRNAMECMD) VALUE(&SUBSIDIARY *CAT +
                          'INV' *CAT &CMD)

             CHGVAR     VAR(&MBRNAMELOG) VALUE(&SUBSIDIARY *CAT +
                          'INV' *CAT &LOG)

             ADDPFM     FILE(TVRELWAECO/QCLSRC) MBR(&MBRNAMECMD)
             MONMSG     MSGID(CPF7306)
             ADDPFM     FILE(TVRELWAECO/QCLSRC) MBR(&MBRNAMELOG)
             MONMSG     MSGID(CPF7306)

             CLRPFM     FILE(TVRELWAECO/QCLSRC) MBR(&MBRNAMECMD)
             CLRPFM     FILE(TVRELWAECO/QCLSRC) MBR(&MBRNAMELOG)

/* Source Files in QTEMP vorbereiten */
             CRTSRCPF   FILE(QTEMP/QFTPSRC)
             MONMSG     MSGID(CPF7302)
             ADDPFM     FILE(QTEMP/QFTPSRC) MBR(FTPCMD)
             MONMSG     MSGID(CPF7306)
             CLRPFM     FILE(QTEMP/QFTPSRC) MBR(FTPCMD)
             OVRDBF     FILE(QFTPSRC) TOFILE(QTEMP/QFTPSRC) +
                          MBR(FTPCMD) OVRSCOPE(*JOB)


/* Generischen Befehl erstellen */
             CALL       PGM(TVRELWAECO/CRTGFTPCMD) PARM(&SUBSIDIARY +
                          &FTPUSER &PASSWORD &FTPMODE &NAMEFORMAT +
                          &FTPCOMMAND &FROMDIR &FROMFILE &TODIR +
                          &TOFILE &DELE_AFTER)

             CPYSRCF    FROMFILE(QTEMP/QFTPSRC) +
                          TOFILE(TVRELWAECO/QCLSRC) FROMMBR(FTPCMD) +
                          TOMBR(&MBRNAMECMD) MBROPT(*REPLACE)

             CHGPFM     FILE(TVRELWAECO/QCLSRC) MBR(&MBRNAMECMD) +
                          SRCTYPE(*NONE) TEXT(&SRCCOMMENT)
             CHGPFM     FILE(TVRELWAECO/QCLSRC) MBR(&MBRNAMELOG) +
                          SRCTYPE(*NONE) TEXT(&LOGCOMMENT)

             OVRDBF     FILE(INPUT) TOFILE(TVRELWAECO/QCLSRC) +
                          MBR(&MBRNAMECMD)
             OVRDBF     FILE(OUTPUT) TOFILE(TVRELWAECO/QCLSRC) +
                          MBR(&MBRNAMELOG)

/* Generischen Befehl ausführen */
             FTP        RMTSYS(&SYSTEMNAME)

             DLTOVR *ALL LVL(*JOB)


 ENDE:       ENDPGM
