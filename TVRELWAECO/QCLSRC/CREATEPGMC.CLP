/*    * PROGRAMMNAME.:LAGERBEWUC                                             */
/*    * FUNKTION.....:BUCHUNGEN DER BEWEGUNGEN AUS TREND                     */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM
             DCL        VAR(&PARM)    TYPE(*CHAR) LEN(01)
             DCL        VAR(&VERSION) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MODUS)   TYPE(*CHAR) LEN(01)
             DCL        VAR(&RC)      TYPE(*CHAR) LEN(01)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&NBRCURRCD)  TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBRCURRCD2) TYPE(*DEC) LEN(10 0)

             DCL        VAR(&ERROR)   TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR3)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR4)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR5)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&OUTFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFKT)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TXT)       TYPE(*CHAR) LEN(50)
             DCLF       FILE(QTEMP/#UPDATE)

             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)
             DCL        VAR(&TIMESTAMP) TYPE(*CHAR) LEN(11) VALUE(' ')
             DCL        VAR(&QDAYOFWEEK) TYPE(*CHAR) LEN(04)

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('CREATEPGMC')
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

             ADDLIBLE   LIB(BAR_KALK) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR3) +
                          VALUE('1'))

             ADDLIBLE   LIB(TVPF) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR4) +
                          VALUE('1'))

/*          _FILES        _____________________________________    */
             RTVSYSVAL  SYSVAL(QDAYOFWEEK) RTNVAR(&QDAYOFWEEK)
             MONMSG     MSGID(CPF0000)

             CALL      PGM(FTP_TIMEST) PARM(&TIMESTAMP)
             CHGVAR VAR(&TXT) VALUE('UPDATE ' *CAT &QDAYOFWEEK  *CAT +
             ':' *CAT (%SST(&TIMESTAMP 1 11)) *CAT ' createpgmc')

             DLTF       FILE(TVRELWAECO/#TEOSL1)
             MONMSG     MSGID(CPF0000)

             CRTLF      FILE(TVRELWAECO/#TEOSL1)      +
                          SRCFILE(TVRELWAECO/QDDSSRC) +
                          SRCMBR(#TEOSL1) TEXT(&TXT)
             MONMSG     MSGID(CPF0000)

             DLTF       FILE(TVRELWAECO/#TEEW)
             MONMSG     MSGID(CPF0000)

             CRTLF      FILE(TVRELWAECO/#TEEW)      +
                          SRCFILE(TVRELWAECO/QDDSSRC) +
                          SRCMBR(#TEEW) TEXT(&TXT)
             MONMSG     MSGID(CPF0000)

             CRTSQLRPGI OBJ(BAR_KALK/KALK) SRCFILE(BAR_KALK/QRPGLESRC)
             MONMSG     MSGID(CPF0000)

             CRTSQLRPGI OBJ(BAR_KALK/KALK_STCKN) +
                          SRCFILE(BAR_KALK/QRPGLESRC)
             MONMSG     MSGID(CPF0000)

             CRTSQLRPGI OBJ(BAR_KALK/ERSATZR) +
                          SRCFILE(BAR_KALK/QRPGLESRC)
             MONMSG     MSGID(CPF0000)

             CRTSQLRPGI OBJ(BAR_KALK/KALK_CH) +
                          SRCFILE(BAR_KALK/QRPGLESRC)
             MONMSG     MSGID(CPF0000)

/*          _WORKFLOW WIN _____________________________________    */
             ADDLIBLE   LIB(DATENKW) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR5) +
                          VALUE('1'))

             ADDLIBLE   LIB(PRODWIN51) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)

             ADDLIBLE   LIB(TVPF) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)

             CRTSQLRPGI OBJ(DATENKW/LAGERBEWR) +
                          SRCFILE(DATENKW/QRPGLESRC)
             MONMSG     MSGID(CPF0000)
             CRTSQLRPGI OBJ(DATENKW/LAGERBEW2R) +
                          SRCFILE(DATENKW/QRPGLESRC)
             MONMSG     MSGID(CPF0000)
             CRTSQLRPGI OBJ(DATENKW/TRENDSTATR) +
                          SRCFILE(DATENKW/QRPGLESRC)
             MONMSG     MSGID(CPF0000)
             CRTSQLRPGI OBJ(DATENKW/ARTIKELR) +
                          SRCFILE(DATENKW/QRPGLESRC)
             MONMSG     MSGID(CPF0000)

             RMVLIBLE   LIB(PRODWIN51)
             MONMSG     MSGID(CPF0000)

             RMVLIBLE   LIB(DATENKW)
             MONMSG     MSGID(CPF0000)

/*          _WORKFLOW SCHWEIZ__________________________________    */
             ADDLIBLE   LIB(DATENKWCH) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR5) +
                          VALUE('1'))

             ADDLIBLE   LIB(PRODWIN55) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)

             ADDLIBLE   LIB(TVPF) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)

             CRTSQLRPGI OBJ(DATENKWCH/LAGERBEWR) +
                          SRCFILE(DATENKW/QRPGLESRC)
             MONMSG     MSGID(CPF0000)
             CRTSQLRPGI OBJ(DATENKWCH/LAGERBEW2R) +
                          SRCFILE(DATENKW/QRPGLESRC)
             MONMSG     MSGID(CPF0000)
             CRTSQLRPGI OBJ(DATENKWCH/TRENDSTATR) +
                          SRCFILE(DATENKW/QRPGLESRC)
             MONMSG     MSGID(CPF0000)
             CRTSQLRPGI OBJ(DATENKWCH/ARTIKELR) +
                          SRCFILE(DATENKW/QRPGLESRC)
             MONMSG     MSGID(CPF0000)

             RMVLIBLE   LIB(PRODWIN55)
             MONMSG     MSGID(CPF0000)

             RMVLIBLE   LIB(DATENKWCH)
             MONMSG     MSGID(CPF0000)

/*          _RHENANIA LIBS_____________________________________    */
             ADDLIBLE   LIB(VLF95DWE) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)

             ADDLIBLE   LIB(VLPLGUSR) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)

             ADDLIBLE   LIB(VLF95USR) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)

             ADDLIBLE   LIB(VLNABUSR27) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)

/*          ___________________________________________________    */
             DSPFD      FILE(TVRELWAECO/QRPGLESRC) TYPE(*MBR) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/#UPDATE) +
                          OUTMBR(*FIRST *REPLACE)

             DSPFD      FILE(BAR_KALK/QRPGLESRC) TYPE(*MBR) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/#UPDATE) +
                          OUTMBR(*FIRST *ADD)

             RTVMBRD    FILE(QTEMP/#UPDATE) NBRCURRCD(&NBRCURRCD)
             MONMSG     MSGID(CPF0000)

             RTVMBRD    FILE(TVRELWAECO/QCLSRC) MBR(&PGM) TEXT(&TXT)
             MONMSG     MSGID(CPF0000)

                IF         COND(&NBRCURRCD *GT 0) THEN(DO)
 LOOP:             RCVF
                   MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDLOOP))

        /*   IF         COND(%SST(&MBNAME 01 02) *EQ 'XX') THEN(DO)     */
                   IF        COND(%SST(&MBMTXT 49 01) *EQ '3' *OR +
                          %SST(&MBMTXT 50 01) *EQ '3') THEN(DO)
                      IF COND(&MBSEU2  *EQ 'SQLRPGLE')   THEN(DO)
                         CRTSQLRPGI OBJ(&MBLIB/&MBNAME)                         +
                         SRCFILE(&MBLIB/&MBFILE) SRCMBR(&MBNAME) OUTPUT(*PRINT)
                         MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR) +
                                 VALUE('1'))
/*          ACHTUNG AUF *ISO DATUMSFORMAT  )WAR MAL ALLES AUF *ISO        */
                      IF COND(&MBSEU2  *EQ 'SQLRPGLE' *AND &MBNAME  ='ORDERIN_R ')
                         CRTSQLRPGI OBJ(&MBLIB/&MBNAME) SRCFILE(&MBLIB/&MBFILE) +
                         SRCMBR(&MBNAME) OUTPUT(*PRINT) DATFMT(*ISO)
                         MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR) +
                                 VALUE('1'))
/*          PROTOKOLLIERUNG ---                                           */
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('LOOP ')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CHGVAR     VAR(%SST(&MD 100 10)) VALUE(&MBNAME)
             CHGVAR     VAR(%SST(&MD 112 10)) VALUE('CRTSQLRPGI')
             CHGVAR     VAR(%SST(&MD 114 01)) VALUE('3')
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */

                      ENDDO
                   ENDDO
                   IF        COND(%SST(&MBMTXT 49 01) *EQ '9' *OR +
                          %SST(&MBMTXT 50 01) *EQ '9') THEN(DO)
                      IF COND(&MBSEU2  *EQ 'SQLRPGLE')   THEN(DO)
                          CRTSQLRPGI OBJ(&MBLIB/&MBNAME)   +
                          SRCFILE(&MBLIB/&MBFILE)          +
                          SRCMBR(&MBNAME) OBJTYPE(*MODULE) +
                          OUTPUT(*PRINT)
                          MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR) +
                                     VALUE('1'))

                          CRTPGM  PGM(&MBLIB/&MBNAME) MODULE(&MBLIB/&MBNAME)
                          MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR) +
                                     VALUE('1'))

                          UPDPGM     PGM(&MBNAME) MODULE(&MBNAME)
                          MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR) +
                                     VALUE('1'))

/*          PROTOKOLLIERUNG ---                                           */
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('LOOP ')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CHGVAR     VAR(%SST(&MD 100 10)) VALUE(&MBNAME)
             CHGVAR     VAR(%SST(&MD 112 10)) VALUE('CRTSQLRPGI')
             CHGVAR     VAR(%SST(&MD 114 01)) VALUE('9')
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */

                      ENDDO
                   ENDDO
                   GOTO LOOP
                ENDDO
/*                                                                            */
 ENDLOOP:
/*                                                                            */
/*          ÜBERSETZUNG ALLER GXS INVOICING PROGRAMME                     */
             CALL PGM(TVRELWAECO/#INVOICPGM) PARM('1')
             MONMSG     MSGID(CPF0000)

             IF         COND(&ERROR *EQ '1') THEN(DO)
                DSPJOBLOG  OUTPUT(*PRINT)
             ENDDO
             GOTO       CMDLBL(ENDPGM)
/*                                                                            */
 ENDPGM:
             IF         COND(&ERROR3 = '0') THEN(DO)
                RMVLIBLE   LIB(BAR_KALK)
             ENDDO
             IF         COND(&ERROR3 = '0') THEN(DO)
                RMVLIBLE   LIB(TVPF)
             ENDDO

/*          PROTOKOLLIERUNG ---                                           */
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('ENDE ')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CHGVAR     VAR(%SST(&MD 100 10)) VALUE('          ')
             CHGVAR     VAR(%SST(&MD 112 10)) VALUE('          ')
             CHGVAR     VAR(%SST(&MD 114 01)) VALUE(' ')
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */

             ENDPGM
