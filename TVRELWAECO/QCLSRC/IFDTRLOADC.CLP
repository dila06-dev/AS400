/*    * PROGRAMMNAME.:CALL ........                                          */
/*    * FUNKTION.....:IFDTRLOADC                                             */
/*    * 10.12.2015     GANG, MANFRED                                          */
/*    * REPORT LOGDATEI UND AUSBAU WORKAREA FÜR EINZELNE ARBEITSPLÄTZE        */
/*    * JEDER ARBEITSPLATZ ARBEITET AUSSCHLIEßLICH MIT SEINER QTEMP/          */
/*    * ARBEITSUMGEBUNG, DAHER WIRD DIESES PROGRAMM NUR ZU BEGINN EIN-        */
/*    * MALIG AUFGERUFEN                                                      */
/*    * RESTART: JA OHNE PROBLEME                                             */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/*    * 03.08.15                                                              */
/*    * INTEGRATION DATEN AUS ANDEREN COIMPANIES                              */
/*    * ERWEITERUNG DER QTEMP-BEREICHE FF7 UND FF8                            */
/******************************************************************************/
             PGM        PARM(&RTN &JOB &USER &NBR)

             DCL        VAR(&PARM)    TYPE(*CHAR) LEN(01)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&RTN)        TYPE(*CHAR) LEN(05)

             DCL        VAR(&ERROR1)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR3)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&OUTFILE)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFKT)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBRCURRCD)  TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBRCURRCD2) TYPE(*DEC) LEN(10 0)

             DCL        VAR(&D)         TYPE(*CHAR) LEN(8)
             DCL        VAR(&ABDATUM)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&QTIME)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&QDATETIME) TYPE(*CHAR) LEN(20)

             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('IFDTRLOADC')
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

             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&QTIME)
             RTVSYSVAL  SYSVAL(QDATETIME) RTNVAR(&QDATETIME)
             CHGVAR     VAR(&D) VALUE(%SST(&QDATETIME 1 8))

             IF         COND(&RTN *EQ 'OPEN ') THEN(DO)
                ADDLIBLE   LIB(TVRELWAECO) POSITION(*AFTER TFXF)
                MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                           VALUE('1'))
                ADDLIBLE   LIB(GANG) POSITION(*LAST)
                MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                           VALUE('1'))
                ADDLIBLE   LIB(VLF95DWE)   POSITION(*LAST)
                MONMSG     MSGID(CPF0000)
                ADDLIBLE   LIB(VLPLGUSR)   POSITION(*LAST)
                MONMSG     MSGID(CPF0000)
                ADDLIBLE   LIB(VLF95USR)   POSITION(*LAST)
                MONMSG     MSGID(CPF0000)
                ADDLIBLE   LIB(VLNABUSR27) POSITION(*LAST)
                MONMSG     MSGID(CPF0000)
             ENDDO

             IF         COND(&QTIME *GT '200000') THEN(GOTO +
                          CMDLBL(ENDPGM))
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&QTIME)
             MONMSG     MSGID(CPF0000)

/*          EIGENES OBJEKT                                                  */
             IF         COND(&RTN *EQ 'OPEN ') THEN(DO)
                CRTDUPOBJ  OBJ(FF1) FROMLIB(TVRELWAECO) +
                OBJTYPE(*FILE)   TOLIB(QTEMP)
                MONMSG     MSGID(CPF0000)
                CRTDUPOBJ  OBJ(FF2) FROMLIB(TVRELWAECO) +
                OBJTYPE(*FILE)   TOLIB(QTEMP)
                MONMSG     MSGID(CPF0000)
                CRTDUPOBJ  OBJ(FF3) FROMLIB(TVRELWAECO) +
                OBJTYPE(*FILE)   TOLIB(QTEMP)
                MONMSG     MSGID(CPF0000)
                CRTDUPOBJ  OBJ(FF4) FROMLIB(TVRELWAECO) +
                OBJTYPE(*FILE)   TOLIB(QTEMP)
                MONMSG     MSGID(CPF0000)
                CRTDUPOBJ  OBJ(FF5) FROMLIB(TVRELWAECO) +
                OBJTYPE(*FILE)   TOLIB(QTEMP)
                MONMSG     MSGID(CPF0000)
                CRTDUPOBJ  OBJ(FF6) FROMLIB(TVRELWAECO) +
                OBJTYPE(*FILE)   TOLIB(QTEMP)
                MONMSG     MSGID(CPF0000)
                CRTDUPOBJ  OBJ(FF1FULL) FROMLIB(TVRELWAECO) +
                OBJTYPE(*FILE)   TOLIB(QTEMP)
                MONMSG     MSGID(CPF0000)
                CRTDUPOBJ  OBJ(FF3_B) FROMLIB(TVRELWAECO) +
                OBJTYPE(*FILE)   TOLIB(QTEMP)
                MONMSG     MSGID(CPF0000)
                CRTDUPOBJ  OBJ(FRDGP#) FROMLIB(TVRELWAECO) +
                           OBJTYPE(*FILE) TOLIB(QTEMP)
                MONMSG     MSGID(CPF0000)
                CRTDUPOBJ  OBJ(FRDGP#2) FROMLIB(TVRELWAECO) +
                           OBJTYPE(*FILE) TOLIB(QTEMP)
                MONMSG     MSGID(CPF0000)
                CRTDUPOBJ  OBJ(FF7) FROMLIB(TVRELWAECO) +
                OBJTYPE(*FILE)   TOLIB(QTEMP)
                MONMSG     MSGID(CPF0000)
                CRTDUPOBJ  OBJ(FF8) FROMLIB(TVRELWAECO) +
                OBJTYPE(*FILE)   TOLIB(QTEMP)
                MONMSG     MSGID(CPF0000)
             ENDDO
/*                                                                          */
             IF         COND(&RTN *EQ 'CLOSE') THEN(DO)
        /*      CRTDUPOBJ  OBJ(FF5) FROMLIB(TVRELWAECO) + */
        /*      OBJTYPE(*FILE)   TOLIB(QTEMP)             */
        /*      MONMSG     MSGID(CPF0000)                 */
             ENDDO
/*                                                                            */
 ENDPGM:

/*          PROTOKOLLIERUNG ---                                           */
             CHGVAR     VAR(&MD) +
                          VALUE('                                     -
                                                           ')
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

             IF         COND(&RTN *EQ 'CLOSE') THEN(DO)
                RMVLIBLE   LIB(TVRELWAECO)
                MONMSG     MSGID(CPF0000)
                RMVLIBLE   LIB(GANG)
                MONMSG     MSGID(CPF0000)
             ENDDO

             ENDPGM
