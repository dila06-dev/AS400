/*    * PROGRAMMNAME.: $GANG                                                 */
/*    * FUNKTION.....: ...                                                   */
/*    * OKTOBER  2010   GANG, MANFRED                                         */
/*    *                                                                       */
/*    *...                                                                   */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM

             DCL        VAR(&CLIENT)     TYPE(*CHAR) LEN(07)
             DCL        VAR(&CRTDATE)    TYPE(*CHAR) LEN(13)
             DCL        VAR(&NBRCURRCD)  TYPE(*DEC) LEN(10 0)
             DCL        VAR(&MBR)        TYPE(*CHAR) LEN(10)
             DCL        VAR(&RECORDS)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)       TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATETIME)   TYPE(*CHAR) LEN(20)
             DCL        VAR(&TXT50)      TYPE(*CHAR) LEN(50)
             DCL        VAR(&LINK)       TYPE(*CHAR) LEN(50)
             DCL        VAR(&FROMSTMF)   TYPE(*CHAR) LEN(60)
             DCL        VAR(&TOMBR)      TYPE(*CHAR) LEN(60)
             DCL        VAR(&NOW)        TYPE(*CHAR) LEN(1)
             DCL        VAR(&OBJ)        TYPE(*CHAR) LEN(10)
             DCL        VAR(&NEWOBJ)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&RC) TYPE(*INT) LEN(4)
             DCL        VAR(&MSGDTA)       TYPE(*CHAR) LEN(4)
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TXT50)      TYPE(*CHAR) LEN(50)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCLF       FILE(TVRELWAECO/#DSPLNK)

             GOTO       CMDLBL(ENDPGM)


             RTVJOBA    USER(&USER) DATETIME(&DATETIME)
             MONMSG     MSGID(CPF0000)
    /*       DLYJOB     DLY(1)              */

             CHGJOB     LOG(4 00 *SECLVL) LOGCLPGM(*YES) +
                          JOBMSGQFL(*WRAP)

             CD         DIR('/home/gerwae/')
             MONMSG     MSGID(CPF0000)

             CHGAUT     OBJ('/home/gerwae') USER(*PUBLIC) +
                          DTAAUT(*RWX) OBJAUT(*NONE)
             MONMSG     MSGID(CPF0000)


             CHGPGP     OBJ('/home/gerwae/FORD') NEWPGP(*NONE) +
                          DTAAUT(*RX)
             MONMSG     MSGID(CPF0000)
          /* CHMOD 755 /home/GANG   */

    /*    CALL PGM(QP2SHELL) PARM('/QOpenSys/usr/bin/-sh' '-c' + */
    /*    'sftp -b /home/gang/cmd.txt     +                      */
    /*    gang@194.8.210.149')                                   */

             CHGCURLIB  CURLIB(TVRELWAECO)
             MONMSG     MSGID(CPF0000)

             QSH        CMD('/QOpenSys/usr/bin/sftp -vvv -b        +
                             /home/gerwae/FORD/cmddealer.txt       +
                             gerwae@194.8.210.149 >                +
                             /home/gerwae/FORD/logdealer.txt  2>&1 ')

       /*   *** DEALER ANLEGEN, WENN NICHT VORHANDEN                         */
             CRTPF      FILE(TVRELWAECO/DEALERFORD) RCDLEN(512) +
                          TEXT('Dealer FORD') MAXMBRS(*NOMAX) +
                          CCSID(65535)
             MONMSG     MSGID(CPF0000)

             CHGCURDIR  DIR('/home/gerwae/FORD/dealer')
             MONMSG     MSGID(CPF0000)

             DSPLNK     OBJ('GER*') OUTPUT(*PRINT)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/#DSPLNK)
             MONMSG     MSGID(CPF0000)

             QSYS/CPYSPLF FILE(QSYSPRT) TOFILE(TVRELWAECO/#DSPLNK) +
                          SPLNBR(*LAST) JOBSYSNAME(*CURRENT) +
                          CRTDATE(*LAST) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF0000)

             DLTSPLF    FILE(QSYSPRT) SPLNBR(*LAST) +
                          JOBSYSNAME(*CURRENT)
             MONMSG     MSGID(CPF0000)

             RTVMBRD    FILE(TVRELWAECO/#DSPLNK) MBR(*FIRST) +
                          NBRCURRCD(&NBRCURRCD)
             MONMSG     MSGID(CPF0000)

             IF         COND(&NBRCURRCD *EQ 0) THEN(GOTO +
                          CMDLBL(LOOPENDE))

 LOOP:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(LOOPENDE))

             IF         COND(&NOW = '1') THEN(DO)
                CHGVAR     VAR(&OBJ) VALUE(%SST(&DSPLNK 02 10))
                MONMSG     MSGID(CPF0000)
                CHGVAR     VAR(&NEWOBJ) VALUE('#' *TCAT &OBJ)
                CHGVAR     VAR(&FROMSTMF) VALUE(&LINK *TCAT &OBJ)
                MONMSG     MSGID(CPF0000)
                CHGVAR     VAR(&TOMBR) +
                          VALUE('/QSYS.LIB/TVRELWAECO.LIB/DEALERFORD.+
                          FILE/' *TCAT &OBJ *TCAT '.MBR')
                MONMSG     MSGID(CPF0000)

    /*  CPYFRMSTMF FROMSTMF('/HOME/GERWAE/FORD/DEALER/GER0207') +*/
    /*               TOMBR('/QSYS.LIB/TVRELWAECO.LIB/TEST.FILE/T+*/
    /*               EST.MBR') MBROPT(*REPLACE)                  */
                CPYFRMSTMF FROMSTMF(&FROMSTMF) TOMBR(&TOMBR) +
                             MBROPT(*REPLACE)
                MONMSG     MSGID(CPF0000)
                RNM        OBJ(&OBJ) NEWOBJ(&NEWOBJ)
                MONMSG     MSGID(CPF0000)
                RMVLNK     OBJLNK(&OBJ)
                MONMSG     MSGID(CPF0000)

             ENDDO

             IF         COND(%SST(&DSPLNK 1 23) = ' +
                          Objektverbindung') THEN(DO)
                CHGVAR     VAR(&NOW) VALUE('1')
             ENDDO

             IF         COND(%SST(&DSPLNK 1 12) = ' Verzeichnis') +
                          THEN(DO)
                CHGVAR  VAR(&LINK) VALUE(%SST(&DSPLNK 25 50) *TCAT '/')
             ENDDO

             GOTO LOOP
 LOOPENDE:



        /*   RMVLNK OBJLNK(GER*)            */
        /*   MONMSG     MSGID(CPF0000)      */

             CHGAUT     OBJ('/home/gerwae/FORD') USER(*PUBLIC) +
                          DTAAUT(*EXCLUDE) OBJAUT(*NONE)

             GOTO       CMDLBL(ENDPGM)

 ENDPGM:
       /* 0 *** DATEI FÜR DEALER AUFBAUEN                                    */
             RUNQRY QRY(FORDDEALER)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(QTEMP/X)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/Y)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/Z)
             MONMSG     MSGID(CPF0000)

       /* 1 *** FILTERN, WELCHE DIREKT NICHT VORHANDEN SIND ALS              */
       /*   *** HAUPTKUNDE                                                   */
       /*   *** KSBA-VERGLEICH UND KUNDENSTAMMDATEN AUF CODE1 + CODE2        */
             CALL    PGM(DUMMY512) PARM(&MD '#CT0601' ' ' ' ' +
                         'X' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
       /* 2 *** AUFBAU ZWISCHENTRÄGER FEHLENDE AUS #CT0601 MIT               */
       /*   *** FEHLENDE ZUORDNUNG D.MITGLIEDSNUMMER IN KDZR01               */
             CALL    PGM(DUMMY512) PARM(&MD '#CT0602' ' ' ' ' +
                         'Y' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
       /* 3 *** ERGÄNZUNG DER FEHLENDEN, DIESE SÄTZE FEHLEN                  */
       /*   *** UND "FLIEGEN" AUS DER ZULASSUNG RAUS (Z/QTEMP)               */
             CALL    PGM(DUMMY512) PARM(&MD '#CT0603' ' ' ' ' +
                         'Z' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
       /* 4 *** BEI DEN Y - SÄTZEN PRÜFEN, OB HAUPTKUNDE IM KSB/             */
       /*   *** FORDREGISTER , WENN NEIN Z/QTEMP) UND SIE "FLIEGEN"          */
       /*   *** RAUS                                                         */
             CALL    PGM(DUMMY512) PARM(&MD '#CT0604' ' ' ' ' +
                         'Z' 'QTEMP' '*ADD')
             MONMSG     MSGID(CPF0000)

       /* 5 *** PROTOKOLL AUS QTEMP/Z                                        */
       /*   *** KANN VOM WEITEREN PROGRAMM GENUTZT WERDEN(ZEITSTEMPEL)       */
             CALL    PGM(DUMMY512) PARM(&MD '#CT0605' ' ' ' ' +
                         'FORD_OFF' 'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)

       /* 6 *** UPDATE AUF KUNDENDATEN ÜBER STANDARDKUNDEN (PARAMETER)       */
       /*    CALL       PGM(CT007260KR)   */
       /*    MONMSG     MSGID(CPF0000)    */

             RUNQRY     QRY(FORD)
             MONMSG     MSGID(CPF0000)

             DSPJOBLOG  OUTPUT(*PRINT)

             ENDPGM
