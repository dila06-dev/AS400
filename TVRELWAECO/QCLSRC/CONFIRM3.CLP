/*    * PROGRAMMNAME.:CALL ........                                          */
/*    * FUNKTION.....:DELIVERYC                                              */
/*    *               ...                                                    */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    *                                                                       */
/*    * CPYF FROMFILE(QTEMP/XX) TOFILE(DIRMAIL/DMITMHDR) MBROPT(*ADD)         */
/*    *                                                                       */
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
             DCL        VAR(&NBR2)       TYPE(*DEC) LEN(10 0)
             DCL        VAR(&TOFILE)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&#APAFNR)    TYPE(*CHAR) LEN(06)
             DCL        VAR(&#APAFJJ) TYPE(*CHAR) LEN(04)

             DCL        VAR(&PGM)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)      TYPE(*CHAR) LEN(06)
             DCL        VAR(&DIR)      TYPE(*CHAR) LEN(64)
             DCL        VAR(&FORMTYPE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&TXT)      TYPE(*CHAR) LEN(50)
             DCL        VAR(&QDAYOFWEEK) TYPE(*CHAR) LEN(04)
             DCL        VAR(&QDAY)  TYPE(*CHAR) LEN(02)

             DCLF       FILE(TVRELWAECO/#DC5200)

/*          MONMSG     MSGID(CPF0000)                                     */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('CONFIRM3 ')
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
             CLRPFM     FILE(TVRELWAECO/#DC5200)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(&MD '#DC5200' ' ' ' ' +
                           '#DC5200'  'TVRELWAECO' '*REPLACE')
             MONMSG     MSGID(CPF0000)

/*           ACHTUNG ALTE SÄTZE WERDEN NICHT GELÖSCH UND VERFÄLSCHEN */
/*           DAS ERGEBNIS, VORHER LÖSCHEN, DA KEIN UPDATE            */
             CALL       PGM(DUMMY512) PARM(&MD '#DC5230' ' ' ' ' ' ' +
                          ' ' ' ')
             MONMSG     MSGID(CPF0000)

             RTVMBRD    FILE(TVRELWAECO/#DC5200) MBR(*FIRST) +
                          NBRCURRCD(&NBRCURRCD)
             MONMSG     MSGID(CPF0000)
             IF         COND( &NBRCURRCD *EQ 0) THEN(DO)
                GOTO    ENDLOOP
             ENDDO
/*                                                                            */
/* *** DOMCHKBAS  FÜLLEN                                                     */
/*                                                                            */
             RTVSYSVAL  SYSVAL(QDAYOFWEEK) RTNVAR(&QDAYOFWEEK)
             MONMSG     MSGID(CPF0000)
             RTVSYSVAL  SYSVAL(QDAY) RTNVAR(&QDAY)
             MONMSG     MSGID(CPF0000)

             IF         COND(&NBRCURRCD *GT 0) THEN(DO)
 LOOP:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDLOOP))
/*                                                                            */
             CHGVAR     VAR(&#APAFNR) VALUE(%SST(&APAFNR 01 06))
             CHGVAR     VAR(&#APAFJJ) VALUE(&APAFJJ)

             CALL       PGM(TVRELWAECO/DOMCHKVERF) PARM(&APFIRM +
                          &#APAFJJ &#APAFNR)
             MONMSG     MSGID(CPF0000)

             GOTO LOOP
             ENDDO
 ENDLOOP:
/*                                                                            */
             CPYF       FROMFILE(DOMCHKBAS)                         +
                        TOFILE(TVRELWAECO/#DOMCHKBAS) MBROPT(*ADD)   +
                        CRTFILE(*NO)
             MONMSG     MSGID(CPF0000)

 ENDPGM:

/*          PROTOKOLLIERUNG ---                                           */
             CHGVAR     VAR(&MD)             VALUE(' ')
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

             ENDPGM
