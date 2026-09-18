/*    * PROGRAMMNAME.:ORDER_XC                                               */
/*    * FUNKTION.....:ORDER_XC                                               */
/*    * OKTOBER 2012   DIMITRI LANGLITZ/GANG, MANFRED                                          */
/*    *                                                                       */
/*CRTPF FILE(TVRELWAECO/KAMPA_DB) RCDLEN(132) TEXT('EASYIMPORT DATENBANK')    */
/*    *                                                                       */
/*CRTSRCPF FILE(TVRELWAECO/KAMPA_SRC) RCDLEN(1028)                            */
/*MBR(KAMPA_SRC) TEXT('EASYIMPORT (WIE AKTIVBANKR)')                          */
/*    *                                                                       */
/*    *                                                                       */
/* QSYS/CPYTOIMPF FROMFILE(QTEMP/CONFIRMHDX)                                  */
/* TOSTMF('/HDX/RCV/FILEY.TXT') ST                                            */
/* MFCODPAG(819) RCDDLM(*LF) STRDLM('') RMVBLANK(*BOTH) FLDDLM(';')           */
/* DECPNT(*                                                                   */
/* COMMA)                                                                     */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM

             DCL        VAR(&PARM)    TYPE(*CHAR) LEN(05)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&ERROR)      TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR1)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&OUTFILE)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFKT)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBRCURRCD)  TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBRCURRCD2) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&TOFILE) TYPE(*CHAR) LEN(32) VALUE('  ')
             DCL        VAR(&SC) TYPE(*DEC) LEN(07 0) VALUE(0051234)
             DCL        VAR(&TIMESTAMP)  TYPE(*CHAR) LEN(20)
             DCL        VAR(&RECORDS)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)       TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATETIME)   TYPE(*CHAR) LEN(20)
             DCL        VAR(&TXT50)      TYPE(*CHAR) LEN(50)
             DCL        VAR(&LINK)       TYPE(*CHAR) LEN(50)
             DCL        VAR(&FROMSTMF)   TYPE(*CHAR) LEN(45)
             DCL        VAR(&TOMBR)      TYPE(*CHAR) LEN(60)
             DCL        VAR(&NOW)        TYPE(*CHAR) LEN(1)
             DCL        VAR(&OBJ)        TYPE(*CHAR) LEN(22)
             DCL        VAR(&NEWOBJ)     TYPE(*CHAR) LEN(22)
             DCL        VAR(&RC) TYPE(*INT) LEN(4)
             DCL        VAR(&MSGDTA)       TYPE(*CHAR) LEN(4)
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)

             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)

             DCLF       FILE(TVRELWAECO/WORKISDB)


             ADDLIBLE   LIB(TVRELWAECO) POSITION(*AFTER TFXF)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('WORKIST_R9')
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

             RTVSYSVAL SYSVAL(QDATETIME) RTNVAR(&TIMESTAMP)

             RTVJOBA    USER(&USER) DATETIME(&DATETIME)
             MONMSG     MSGID(CPF0000)

             CD         DIR('/WORKIST')
             MONMSG     MSGID(CPF0000)

             CHGAUT     OBJ('/WORKIST') USER(*PUBLIC) +
                          DTAAUT(*RWX) OBJAUT(*NONE)
             MONMSG     MSGID(CPF0000)

             DSPLNK     OBJ('ORDER_*') OUTPUT(*PRINT)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/WORKISDB)
             MONMSG     MSGID(CPF0000)

             QSYS/CPYSPLF FILE(QSYSPRT) TOFILE(TVRELWAECO/WORKISDB) +
                          SPLNBR(*LAST) JOBSYSNAME(*CURRENT)       +
                          CRTDATE(*LAST) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF0000)

             DLTSPLF    FILE(QSYSPRT) SPLNBR(*LAST) +
                          JOBSYSNAME(*CURRENT)
             MONMSG     MSGID(CPF0000)

             RTVMBRD    FILE(TVRELWAECO/WORKISDB) MBR(*FIRST) +
                          NBRCURRCD(&NBRCURRCD)
             MONMSG     MSGID(CPF0000)

             IF         COND(&NBRCURRCD *EQ 0) THEN(GOTO +
                          CMDLBL(LOOPENDE))
             CLRPFM     FILE(TVRELWAECO/WORKISRC)
             MONMSG     MSGID(CPF0000)

 LOOP:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(LOOPENDE))

             IF         COND(%SST(&WORKISDB 02 06) = 'ORDER_' *OR +
                          %SST(&WORKISDB 02 06) = 'ORDER_') THEN(DO)
                CHGVAR     VAR(&NOW) VALUE('1')
             ENDDO

             IF         COND(%SST(&WORKISDB 1 12) = ' Verzeichnis') +
                          THEN(DO)
                CHGVAR  VAR(&LINK) VALUE(%SST(&WORKISDB 25 50) *TCAT '/')
             ENDDO

             IF         COND(&NOW = '1') THEN(DO)
                CHGVAR     VAR(&OBJ) VALUE(%SST(&WORKISDB 02 35))
                MONMSG     MSGID(CPF0000)
                CHGVAR     VAR(&NEWOBJ) VALUE('#' *TCAT &OBJ)
                CHGVAR     VAR(&FROMSTMF) VALUE(&LINK *TCAT &OBJ)
                MONMSG     MSGID(CPF0000)
                CHGVAR     VAR(&TOMBR) +
                          VALUE('/QSYS.LIB/TVRELWAECO.LIB/WORKISRC.F+
                          ILE/' *TCAT 'WORKISRC' *TCAT '.MBR')
                MONMSG     MSGID(CPF0000)
                CPYFRMSTMF FROMSTMF(&FROMSTMF) TOMBR(&TOMBR) +
                          MBROPT(*ADD)
                MONMSG     MSGID(CPF0000)

/*          PROTOKOLLIERUNG ---                                           */
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('ENDE ')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CHGVAR     VAR(%SST(&MD 100 05)) VALUE('WORKIST: ')
             CHGVAR     VAR(%SST(&MD 106 22)) VALUE(&OBJ)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */

                RNM        OBJ(&OBJ) NEWOBJ(&NEWOBJ)
                MONMSG     MSGID(CPF0000)
                RMVLNK     OBJLNK(&OBJ)
                MONMSG     MSGID(CPF0000)
             ENDDO

             GOTO LOOP
 LOOPENDE:


     /*      IF         COND( &ERROR *NE '0') THEN(DO)            */
     /*          DLCOBJ     OBJ((TVRELWAECO/NAVHEAD01 *FILE *EXCL)*/
     /*          MONMSG     MSGID(CPF0000)                        */
     /*      ENDDO                                                */

             RTVMBRD   FILE(TVRELWAECO/WORKISRC) NBRCURRCD(&NBRCURRCD)
             MONMSG     MSGID(CPF0000)

             IF         COND(&NBRCURRCD *GT 00000) THEN(DO)
                   CPYFRMIMPF FROMFILE(TVRELWAECO/WORKISRC) +
                              TOFILE(TVRELWAECO/WORKIST_R9)    +
                              MBROPT(*REPLACE) FLDDLM(';')   +
                              RPLNULLVAL(*FLDDFT)
                   MONMSG     MSGID(CPF0000)

/*                SICHERUNG  WORKIST_R9                                     */
                   CPYFRMIMPF FROMFILE(TVRELWAECO/WORKISRC) +
                              TOFILE(TVRELWAECO/WORKISTR9#)   +
                              MBROPT(*ADD) FLDDLM(';')   +
                              RPLNULLVAL(*FLDDFT)
                   MONMSG     MSGID(CPF0000)

/*                STARTEN    ORDERIN_RT                                     */
                   CALL       PGM(ORDERIN_RT)
                   MONMSG     MSGID(CPF0000)


/*                COPY WORKIST ORDERS TO TEST                               */
                   RUNSQL SQL('CALL DOMGENT.COPY_WORKIST_ORDERS_TO_TEST') COMMIT(*CHG)

/*                STARTEN    ORDERR                                         */
                   CHGVAR     VAR(&SC) VALUE(0000035)
                   CALL       PGM(ORDERR) PARM(&SC)
             ENDDO

/*                                                                            */
 ENDPGM:
     /*      CHGVAR     VAR(&SC) VALUE(0000025)       */
     /*      CALL       PGM(ORDERR) PARM(&SC)         */

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

             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(TVRELWAECO)
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
                MONMSG     MSGID(CPF0000)
             ENDDO

             ENDPGM
