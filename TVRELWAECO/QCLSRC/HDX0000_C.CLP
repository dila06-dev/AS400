/*    * PROGRAMMNAME.:ORDER_XC                                               */
/*    * FUNKTION.....:ORDER_XC                                               */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/* SELECT C020, C030, '2012/788519' c070#1, '0010' c070#2,                    */
/* substr(C100, 1, 15) c100, C040 soll, C040 ist, C050 soll, c050 ist         */
/* FROM confirm WHERE C010 =2                                                 */
/* Datei CONFIRMHDX in QTEMP wurde erstellt.                                  */
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
             DCL        VAR(&SC) TYPE(*DEC) LEN(07 0) VALUE(0055278)
             DCL        VAR(&TIMESTAMP) TYPE(*CHAR) LEN(20)
             DCL        VAR(&RECORDS)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)       TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATETIME)   TYPE(*CHAR) LEN(20)
             DCL        VAR(&TXT50)      TYPE(*CHAR) LEN(50)
             DCL        VAR(&LINK)       TYPE(*CHAR) LEN(50)
             DCL        VAR(&FROMSTMF)   TYPE(*CHAR) LEN(45)
             DCL        VAR(&TOMBR)      TYPE(*CHAR) LEN(60)
             DCL        VAR(&TOSTMF)     TYPE(*CHAR) LEN(60)
             DCL        VAR(&NOW)        TYPE(*CHAR) LEN(1)
             DCL        VAR(&OBJ)        TYPE(*CHAR) LEN(22)
             DCL        VAR(&NEWOBJ)     TYPE(*CHAR) LEN(22)
             DCL        VAR(&#$AFRHDX)   TYPE(*DEC) LEN(10 0)
             DCL        VAR(&#$AFRHDXA)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&RC)         TYPE(*INT) LEN(4)
             DCL        VAR(&MSGDTA)     TYPE(*CHAR) LEN(4)
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TXT50)      TYPE(*CHAR) LEN(50)
             DCL        VAR(&DFTCCSID)   TYPE(*DEC) LEN(5 0)

             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)
             DCL        VAR(&NBRCURR##)  TYPE(*CHAR) LEN(10)


             DCLF       FILE(QTEMP/HDX0110)

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('HDX0000_C ')
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

             RTVJOBA    USER(&USER) DFTCCSID(&DFTCCSID) +
                          DATETIME(&DATETIME)
             MONMSG     MSGID(CPF0000)
             CHGJOB     CCSID(273)

             CALL       PGM(DUMMY512) PARM(&MD 'HDX0100' ' ' ' ' +
                        '#AFRKHDX' 'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(HDX0000_R)
             MONMSG     MSGID(CPF0000)

             RTVDTAARA  DTAARA($AFRHDX *ALL) RTNVAR(&#$AFRHDX)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&#$AFRHDXA) VALUE(&#$AFRHDX)

             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&#$AFRHDXA)
             CALL      PGM(DUMMY512) PARM(&MD 'HDX0110' ' ' ' ' +
                          'HDX0110' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)

             ADDLIBLE   LIB(TVRELWAECO) POSITION(*AFTER TFXF)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))

             CD         DIR('/HDX/rcv')
             MONMSG     MSGID(CPF0000)

             CHGAUT     OBJ('/HDX/rcv') USER(*PUBLIC) +
                          DTAAUT(*RWX) OBJAUT(*NONE)
             MONMSG     MSGID(CPF0000)

             RTVMBRD    FILE(QTEMP/HDX0110) MBR(*FIRST) +
                          NBRCURRCD(&NBRCURRCD)
             MONMSG     MSGID(CPF0000)

             IF         COND(&NBRCURRCD *EQ 0) THEN(GOTO +
                          CMDLBL(LOOPENDE))
      /*     CLRPFM     FILE(TVRELWAECO/HDXORDER#)   */
      /*     MONMSG     MSGID(CPF0000)               */

 LOOP:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(LOOPENDE))

             CHGVAR     VAR(%SST(&MD 01 20)) VALUE(&HDX#)
             CALL      PGM(DUMMY512) PARM(&MD 'HDX0120' ' ' ' ' +
                          'HDX0120' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
             RTVMBRD    FILE(QTEMP/HDX0120) MBR(*FIRST) +
                          NBRCURRCD(&NBRCURRCD)
             MONMSG     MSGID(CPF0000)

             IF         COND(&NBRCURRCD *GT 0) THEN(DO)
                CHGVAR VAR(&TOSTMF) VALUE('/HDX/rcv/VK_LS_TREND_' +
                          *TCAT &HDX# *TCAT '.TXT')
                MONMSG     MSGID(CPF0000)
                QSYS/CPYTOIMPF FROMFILE(QTEMP/HDX0120) +
                          TOSTMF(&TOSTMF) +
                          STMFCODPAG(819) RCDDLM(*LF) STRDLM('') +
                          RMVBLANK(*BOTH) FLDDLM(';') DECPNT(*COMMA)
                MONMSG     MSGID(CPF0000)
             ENDDO

             GOTO LOOP
 LOOPENDE:

/*                                                                            */
 ENDPGM:

/*          PROTOKOLLIERUNG ---                                           */
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('ENDE ')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CHGVAR     VAR(%SST(&MD 100 14)) VALUE('HDX-Stapel:=>')
             CHGVAR     VAR(&NBRCURR##) VALUE(&#$AFRHDX)
             CHGVAR     VAR(%SST(&MD 115 10)) VALUE(&NBRCURR##)
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
             CHGJOB     CCSID(&DFTCCSID)

             ENDPGM
