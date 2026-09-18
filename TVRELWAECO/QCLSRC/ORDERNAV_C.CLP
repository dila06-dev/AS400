/*    * PROGRAMMNAME.: $GANG                                                 */
/*    * FUNKTION.....: ...                                                   */
/*    * OKTOBER  2010   GANG, MANFRED                                         */
/*    * CALL   PGM(ORDERSFTP) PARM('00005')                                   */
/*    *CALL   PGM(ORDERIN_C) PARM('0000005')                                 */
/*    * CALL PGM(ORDERR) PARM(00005)                                          */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM

             DCL        VAR(&CLIENT)     TYPE(*CHAR) LEN(07)
             DCL        VAR(&CRTDATE)    TYPE(*CHAR) LEN(13)
             DCL        VAR(&NBRCURRCD)  TYPE(*DEC) LEN(10 0)
             DCL        VAR(&WEBCLIENT)  TYPE(*DEC) LEN(07 0)
             DCL        VAR(&APICLIENT)  TYPE(*DEC) LEN(07 0)
             DCL        VAR(&DCS)        TYPE(*DEC) LEN(07 0)
             DCL        VAR(&MBR)        TYPE(*CHAR) LEN(10)
             DCL        VAR(&RECORDS)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)       TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATETIME)   TYPE(*CHAR) LEN(20)
             DCL        VAR(&TXT50)      TYPE(*CHAR) LEN(50)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&NAVLOG)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&ERROR)  TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&ERROR1) TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&ERROR2) TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&ERROR3) TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&RUN)    TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&QTIME)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&BENELUX)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&TECCOM)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&ORDERTEST) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DAFEHL)    TYPE(*CHAR) LEN(1)

             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('ORDERNAV_C')
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

       /*   *** AUFBEREITUNG FÜR TREND                                       */
             CALL       PGM(GANG/##SVRLDA) PARM('S')
             MONMSG     MSGID(CPF0000)

         /*  CALL       PGM(MODWAO/STRTRDSJ)  */
         /*  CALL       PGM(MODWAO/STRACM)    */
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(*LDA (1 2)) VALUE('01')
             CALL       PGM(TRDV00ST) PARM('ORDERNAV_C')
             RTVDTAARA  DTAARA(*LDA (28 1)) RTNVAR(&DAFEHL)
             IF         COND(&DAFEHL = '1') THEN(GOTO CMDLBL(ENDPGM))


       /*   *** ACHTUNG SYSVAL                                               */
             CHGJOB     CCSID(*SYSVAL)

             CALL       PGM(WAECOEDI/DOMORDERFR)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(WAECOEDI/DOMORDERUK)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(WAECOEDI/DOMORDERCH)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(WAECOEDI/DOMORDERPL)
             MONMSG     MSGID(CPF0000)

             ADDLIBLE   LIB(WAECOEDI) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR3) +
                          VALUE('1'))

             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&QTIME)
             IF         COND(&QTIME *GT '075900' *AND &QTIME *LT +
                          '080200') THEN(DO)
                CHGVAR VAR(&BENELUX) VALUE('0')
             ENDDO

       /*   *** SIND IM HEADER BENELUX SÄTZE VORHANDEN?                      */
             CHGVAR VAR(&BENELUX) VALUE('0')
             RTVMBRD    FILE(WAECOEDI/DOM003)      MBR(*FIRST) +
                        NBRCURRCD(&NBRCURRCD)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&BENELUX) +
                          VALUE('0'))
             IF         COND( &NBRCURRCD *EQ 0) THEN(DO)
                CHGVAR VAR(&BENELUX) VALUE('0')
             ENDDO
             IF         COND( &NBRCURRCD *NE 0) THEN(DO)
                CHGVAR VAR(&BENELUX) VALUE('1')
                DLYJOB     DLY(05)
             ENDDO

       /*   *** SIND FÜR TECCOM SÄTZE VORHANDEN?                             */
             CHGVAR VAR(&TECCOM) VALUE('0')
             RTVMBRD    FILE(BAR_TEC/ORDHEAD)      MBR(*FIRST) +
                        NBRCURRCD(&NBRCURRCD)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&TECCOM) +
                          VALUE('0'))
             IF         COND( &NBRCURRCD *EQ 0) THEN(DO)
                CHGVAR VAR(&TECCOM) VALUE('0')
             ENDDO
             IF         COND( &NBRCURRCD *NE 0) THEN(DO)
                CHGVAR VAR(&TECCOM) VALUE('1')
                DLYJOB     DLY(05)
             ENDDO


             RTVJOBA    USER(&USER) DATETIME(&DATETIME)
             MONMSG     MSGID(CPF0000)
             DLYJOB     DLY(1)

             ADDLIBLE   LIB(TVRELWAECO) POSITION(*AFTER TFXF)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))

       /*   CALL AUF TREND? '0'=NEIN, '1'=JA                                 */
             RTVDTAARA  DTAARA(TVRELWAECO/ORDERTEST (01 01)) +
                          RTNVAR(&ORDERTEST)
             MONMSG     MSGID(CPF0000)

             RTVDTAARA  DTAARA(TVRELWAECO/NAVLOG (01 01)) +
                          RTNVAR(&NAVLOG)
             MONMSG     MSGID(CPF0000)

       /*   *** SPERRE AUF JOB                                               */
             IF         COND( &NAVLOG *EQ '0') THEN(DO)
       /*      SPERRE AUFBAUEN                                               */
                CHGDTAARA  DTAARA(TVRELWAECO/NAVLOG (01 01)) VALUE('1')

       /*      1)* Start NAVHEAD01 UND NAVLINE01 verarbeiten                 */
       /*          ==>   NAVHEAD   UND NAVLINE                               */
                CHGVAR VAR(&ERROR) VALUE('0')
       /*      OBJEKTSPERRE NAVHEAD01                                        */
                ALCOBJ     OBJ((TVRELWAECO/NAVHEAD01 *FILE *EXCL)) +
                                                     WAIT(1)
                MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR) +
                           VALUE('1'))
       /*      OBJEKTSPERRE NAVLINE01                                        */
                ALCOBJ     OBJ((TVRELWAECO/NAVLINE01 *FILE *EXCL)) +
                                                     WAIT(1)
                MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR) +
                           VALUE('1'))
       /*      INHALTE AUF HEADER ?                                          */
                RTVMBRD    FILE(TVRELWAECO/NAVHEAD01) MBR(*FIRST) +
                           NBRCURRCD(&NBRCURRCD)
                MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR) +
                           VALUE('1'))
                IF         COND( &NBRCURRCD *EQ 0) THEN(DO)
                   CHGVAR VAR(&ERROR) VALUE('1')
                ENDDO
       /*      INHALTE AUF LINE   ?                                          */
                RTVMBRD    FILE(TVRELWAECO/NAVLINE01) MBR(*FIRST) +
                           NBRCURRCD(&NBRCURRCD)
                MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR) +
                           VALUE('1'))
                IF         COND( &NBRCURRCD *EQ 0) THEN(DO)
                   CHGVAR VAR(&ERROR) VALUE('1')
                ENDDO
       /*      FEHLER, ERROR <> NULL OBJEKTFREIGABE                          */
                IF         COND( &ERROR *NE '0') THEN(DO)
                   DLCOBJ     OBJ((TVRELWAECO/NAVHEAD01 *FILE *EXCL))
                   MONMSG     MSGID(CPF0000)
                   DLCOBJ     OBJ((TVRELWAECO/NAVLINE01 *FILE *EXCL))
                   MONMSG     MSGID(CPF0000)
                ENDDO
       /*      DATEIEN KOPIEREN, P A R T  1  ÜBER  NAVHEAD01/NAVLINE01       */
                IF         COND( &ERROR *EQ '0') THEN(DO)
                   CHGVAR     VAR(&RUN) VALUE('1')
                   CPYF       FROMFILE(TVRELWAECO/NAVHEAD01) +
                              TOFILE(TVRELWAECO/NAVHEAD) +
                              MBROPT(*REPLACE) FMTOPT(*CVTSRC)
                   MONMSG     MSGID(CPF0000)

                   CPYF       FROMFILE(TVRELWAECO/NAVLINE01) +
                              TOFILE(TVRELWAECO/NAVLINE) +
                              MBROPT(*REPLACE) FMTOPT(*CVTSRC)
                   MONMSG     MSGID(CPF0000)

       /*         STRASSE ANPASSEN FÜR ITALIEN                               */
                   CALL  PGM(DUMMY512) PARM(&MD '#DC3001' ' ' ' ' ' ' +
                                ' ' ' ')
                   MONMSG     MSGID(CPF0000)

       /*         STADT   ANPASSEN FÜR ITALIEN                               */
                   CALL  PGM(DUMMY512) PARM(&MD '#DC3002' ' ' ' ' ' ' +
                                ' ' ' ')
                   MONMSG     MSGID(CPF0000)

       /*         ORDER   ANPASSEN FÜR SPANIEN                               */
                   CALL  PGM(DUMMY512) PARM(&MD '#DC3010' ' ' ' ' ' ' +
                                ' ' ' ')
                   MONMSG     MSGID(CPF0000)

       /*         ORDER   ANPASSEN FÜR ITALIEN UND SPANIEN                   */
                   CALL  PGM(DUMMY512) PARM(&MD '#DC3005' ' ' ' ' ' ' +
                                ' ' ' ')
                   MONMSG     MSGID(CPF0000)

       /*         ORDER   ANPASSEN FÜR SCHWEIZ KOPF                          */
                   CALL  PGM(DUMMY512) PARM(&MD '#DC3007' ' ' ' ' ' ' +
                             ' ' ' ')
                   MONMSG     MSGID(CPF0000)

       /*         ORDER   ANPASSEN FÜR SCHWEIZ LINE                          */
                   CALL  PGM(DUMMY512) PARM(&MD '#DC3006' ' ' ' ' ' ' +
                                ' ' ' ')
                   MONMSG     MSGID(CPF0000)

       /*         ORDER  ANPASSEN ZEIT  HEAD/LINE                            */
                   CALL  PGM(DUMMY512) PARM(&MD '#DC3011' ' ' ' ' ' ' +
                                ' ' ' ')
                   MONMSG     MSGID(CPF0000)

       /*         ORDER   ANPASSEN ZEIT  HEAD/LINE                           */
                   CALL  PGM(DUMMY512) PARM(&MD '#DC3012' ' ' ' ' ' ' +
                                ' ' ' ')
                   MONMSG     MSGID(CPF0000)

       /*         SICHERUNG                                                  */
                   CALL       PGM(ORDERIN_R2)
                   MONMSG     MSGID(CPF0000)
                   CPYF       FROMFILE(TVRELWAECO/NAVHEAD) +
                             TOFILE(TVRELWAECO/NAVHEADS) MBROPT(*ADD) +
                              CRTFILE(*YES)
                   MONMSG     MSGID(CPF0000)
                   CLRPFM     FILE(TVRELWAECO/NAVHEAD)
                   MONMSG     MSGID(CPF0000)

                   CPYF       FROMFILE(TVRELWAECO/NAVLINE) +
                             TOFILE(TVRELWAECO/NAVLINES) MBROPT(*ADD) +
                              CRTFILE(*YES)
                   MONMSG     MSGID(CPF0000)
                   CLRPFM     FILE(TVRELWAECO/NAVLINE)
                   MONMSG     MSGID(CPF0000)
                   CLRPFM     FILE(TVRELWAECO/NAVHEAD01)
                   MONMSG     MSGID(CPF0000)
                   CLRPFM     FILE(TVRELWAECO/NAVLINE01)
                   MONMSG     MSGID(CPF0000)
                   DLCOBJ     OBJ((TVRELWAECO/NAVHEAD01 *FILE *EXCL))
                   MONMSG     MSGID(CPF0000)
                   DLCOBJ     OBJ((TVRELWAECO/NAVLINE01 *FILE *EXCL))
                   MONMSG     MSGID(CPF0000)
                ENDDO
       /*      *** Ende NAVHEAD01 UND NAVLINE01                              */

/*          __________________________________________________________       */

       /*      2)* Start WWWORD10/WWWORD50 verarbeiten                       */
       /*          ==>   WWWORK10  UND WWWORK50                              */
       /*          ==>   NAVHEAD   UND NAVLINE                               */
                CHGVAR VAR(&ERROR) VALUE('0')
       /*      OBJEKTSPERRE WWWORD10                                         */
                ALCOBJ     OBJ((TVRELWAECO/WWWORD10  *FILE *EXCL)) +
                                                     WAIT(1)
                MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR) +
                           VALUE('1'))
       /*      OBJEKTSPERRE WWWORD50                                         */
                ALCOBJ     OBJ((TVRELWAECO/WWWORD50  *FILE *EXCL)) +
                                                     WAIT(1)
                MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR) +
                           VALUE('1'))
       /*      INHALTE AUF HEADER ?                                          */
                RTVMBRD    FILE(TVRELWAECO/WWWORD10)  MBR(*FIRST) +
                           NBRCURRCD(&NBRCURRCD)
                MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR) +
                           VALUE('1'))
                IF         COND( &NBRCURRCD *EQ 0) THEN(DO)
                   CHGVAR VAR(&ERROR) VALUE('1')
                ENDDO
       /*      INHALTE AUF LINE   ?                                          */
                RTVMBRD    FILE(TVRELWAECO/WWWORD50)  MBR(*FIRST) +
                           NBRCURRCD(&NBRCURRCD)
                MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR) +
                           VALUE('1'))
                IF         COND( &NBRCURRCD *EQ 0) THEN(DO)
                   CHGVAR VAR(&ERROR) VALUE('1')
                ENDDO
       /*      FEHLER, ERROR <> NULL OBJEKTFREIGABE                          */
                IF         COND( &ERROR *NE '0') THEN(DO)
                   DLCOBJ     OBJ((TVRELWAECO/WWWORD10  *FILE *EXCL))
                   MONMSG     MSGID(CPF0000)
                   DLCOBJ     OBJ((TVRELWAECO/WWWORD50  *FILE *EXCL))
                   MONMSG     MSGID(CPF0000)
                ENDDO
       /*      DATEIEN KOPIEREN, P A R T  1  ÜBER  NAVHEAD01/NAVLINE01       */
                IF         COND( &ERROR *EQ '0') THEN(DO)

                   CHGVAR     VAR(&RUN) VALUE('1')
                   CPYFRMIMPF FROMFILE(TVRELWAECO/WWWORD10) +
                              TOFILE(TVRELWAECO/WWWORK10) +
                              MBROPT(*REPLACE) FLDDLM(';') +
                              RPLNULLVAL(*FLDDFT)
                   MONMSG     MSGID(CPF0000)

                   CPYF       FROMFILE(TVRELWAECO/WWWORK10) +
                              TOFILE(TVRELWAECO/NAVHEAD) +
                              MBROPT(*REPLACE) FMTOPT(*NOCHK)
                   MONMSG     MSGID(CPF0000)

                   CPYFRMIMPF FROMFILE(TVRELWAECO/WWWORD50) +
                              TOFILE(TVRELWAECO/WWWORK50) +
                              MBROPT(*REPLACE) FLDDLM(';') +
                              RPLNULLVAL(*FLDDFT)
                   MONMSG     MSGID(CPF0000)

                   CPYF       FROMFILE(TVRELWAECO/WWWORK50) +
                              TOFILE(TVRELWAECO/NAVLINE) +
                              MBROPT(*REPLACE) FMTOPT(*NOCHK)
                   MONMSG     MSGID(CPF0000)

       /*         STRASSE ANPASSEN FÜR ITALIEN                               */
                   CALL  PGM(DUMMY512) PARM(&MD '#DC3001' ' ' ' ' ' ' +
                                ' ' ' ')
                   MONMSG     MSGID(CPF0000)

       /*         STADT   ANPASSEN FÜR ITALIEN                               */
                   CALL  PGM(DUMMY512) PARM(&MD '#DC3002' ' ' ' ' ' ' +
                                ' ' ' ')
                   MONMSG     MSGID(CPF0000)

       /*         ORDER   ANPASSEN FÜR SPANIEN                               */
                   CALL  PGM(DUMMY512) PARM(&MD '#DC3010' ' ' ' ' ' ' +
                                ' ' ' ')
                   MONMSG     MSGID(CPF0000)

       /*         ORDER   ANPASSEN FÜR ITALIEN UND SPANIEN                   */
                   CALL  PGM(DUMMY512) PARM(&MD '#DC3005' ' ' ' ' ' ' +
                                ' ' ' ')
                   MONMSG     MSGID(CPF0000)

       /*         ORDER   ANPASSEN ZEIT  HEAD/LINE                           */
                   CALL  PGM(DUMMY512) PARM(&MD '#DC3011' ' ' ' ' ' ' +
                                ' ' ' ')
                   MONMSG     MSGID(CPF0000)

       /*         ORDER   ANPASSEN ZEIT  HEAD/LINE                           */
                   CALL  PGM(DUMMY512) PARM(&MD '#DC3012' ' ' ' ' ' ' +
                                ' ' ' ')
                   MONMSG     MSGID(CPF0000)

       /*         SICHERUNG                                                  */
                   CALL       PGM(ORDERIN_R2)
                   MONMSG     MSGID(CPF0000)
                   CPYF       FROMFILE(TVRELWAECO/NAVHEAD) +
                             TOFILE(TVRELWAECO/NAVHEADS) MBROPT(*ADD) +
                              CRTFILE(*YES)
                   MONMSG     MSGID(CPF0000)
                   CLRPFM     FILE(TVRELWAECO/NAVHEAD)
                   MONMSG     MSGID(CPF0000)

                   CPYF       FROMFILE(TVRELWAECO/NAVLINE) +
                             TOFILE(TVRELWAECO/NAVLINES) MBROPT(*ADD) +
                              CRTFILE(*YES)
                   MONMSG     MSGID(CPF0000)
                   CLRPFM     FILE(TVRELWAECO/NAVLINE)
                   MONMSG     MSGID(CPF0000)
                   CLRPFM     FILE(TVRELWAECO/WWWORK10)
                   MONMSG     MSGID(CPF0000)
                   CLRPFM     FILE(TVRELWAECO/WWWORK50)
                   MONMSG     MSGID(CPF0000)
                   CLRPFM     FILE(TVRELWAECO/WWWORD10)
                   MONMSG     MSGID(CPF0000)
                   CLRPFM     FILE(TVRELWAECO/WWWORD50)
                   MONMSG     MSGID(CPF0000)
                   DLCOBJ     OBJ((TVRELWAECO/WWWORD10  *FILE *EXCL))
                   MONMSG     MSGID(CPF0000)
                   DLCOBJ     OBJ((TVRELWAECO/WWWORD50  *FILE *EXCL))
                   MONMSG     MSGID(CPF0000)
                ENDDO

       /*      *** Ende WWWORD10 UND WWWORD50                                */

/*          __________________________________________________________       */

       /*      3)* Start WAEEDIHX  UND WAEEDILX  verarbeiten                 */
       /*          ==>   NAVHEAD   UND NAVLINE                               */
                CHGVAR VAR(&ERROR) VALUE('0')
       /*      OBJEKTSPERRE WAEEDIHX                                         */
                ALCOBJ     OBJ((TVRELWAECO/WAEEDIHX  *FILE *EXCL)) +
                                                     WAIT(1)
                MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR) +
                           VALUE('1'))
       /*      OBJEKTSPERRE WAEEDILX                                         */
                ALCOBJ     OBJ((TVRELWAECO/WAEEDILX  *FILE *EXCL)) +
                                                     WAIT(1)
                MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR) +
                           VALUE('1'))
       /*      INHALTE AUF HEADER ?                                          */
                RTVMBRD    FILE(TVRELWAECO/WAEEDIHX)  MBR(*FIRST) +
                           NBRCURRCD(&NBRCURRCD)
                MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR) +
                           VALUE('1'))
                IF         COND( &NBRCURRCD *EQ 0) THEN(DO)
                   CHGVAR VAR(&ERROR) VALUE('1')
                ENDDO
       /*      INHALTE AUF LINE   ?                                          */
                RTVMBRD    FILE(TVRELWAECO/WAEEDILX)  MBR(*FIRST) +
                           NBRCURRCD(&NBRCURRCD)
                MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR) +
                           VALUE('1'))
                IF         COND( &NBRCURRCD *EQ 0) THEN(DO)
                   CHGVAR VAR(&ERROR) VALUE('1')
                ENDDO
       /*      FEHLER, ERROR <> NULL OBJEKTFREIGABE                          */
                IF         COND( &ERROR *NE '0') THEN(DO)
                   DLCOBJ     OBJ((TVRELWAECO/WAEEDIHX  *FILE *EXCL))
                   MONMSG     MSGID(CPF0000)
                   DLCOBJ     OBJ((TVRELWAECO/WAEEDILX  *FILE *EXCL))
                   MONMSG     MSGID(CPF0000)
                ENDDO
                IF         COND( &ERROR *EQ '0') THEN(DO)
                   CHGVAR     VAR(&RUN) VALUE('1')
       /*         DATEIEN KOPIEREN, P A R T  3  ÜBER  WAECOEDI               */
                   CPYF       FROMFILE(TVRELWAECO/WAEEDIHX) +
                              TOFILE(TVRELWAECO/NAVHEAD) +
                              MBROPT(*REPLACE) FMTOPT(*NOCHK)
                   MONMSG     MSGID(CPF0000)

                   CPYF       FROMFILE(TVRELWAECO/WAEEDILX) +
                              TOFILE(TVRELWAECO/NAVLINE) +
                              MBROPT(*REPLACE) FMTOPT(*NOCHK)
                   MONMSG     MSGID(CPF0000)

       /*         ORDER   ANPASSEN FÜR SCHWEIZ KOPF                          */
                   CALL  PGM(DUMMY512) PARM(&MD '#DC3007' ' ' ' ' ' ' +
                                ' ' ' ')
                   MONMSG     MSGID(CPF0000)

       /*         ORDER   ANPASSEN FÜR SCHWEIZ LINE                          */
                   CALL  PGM(DUMMY512) PARM(&MD '#DC3006' ' ' ' ' ' ' +
                                ' ' ' ')
                   MONMSG     MSGID(CPF0000)

       /*         SICHERUNG                                                  */
                   CALL       PGM(ORDERIN_R2)
                   MONMSG     MSGID(CPF0000)
                   CPYF       FROMFILE(TVRELWAECO/NAVHEAD) +
                             TOFILE(TVRELWAECO/NAVHEADS) MBROPT(*ADD) +
                              CRTFILE(*YES)
                   MONMSG     MSGID(CPF0000)
                   CLRPFM     FILE(TVRELWAECO/NAVHEAD)
                   MONMSG     MSGID(CPF0000)

                   CPYF       FROMFILE(TVRELWAECO/NAVLINE) +
                             TOFILE(TVRELWAECO/NAVLINES) MBROPT(*ADD) +
                              CRTFILE(*YES)
                   MONMSG     MSGID(CPF0000)
                   CLRPFM     FILE(TVRELWAECO/NAVLINE)
                   MONMSG     MSGID(CPF0000)
                   CLRPFM     FILE(TVRELWAECO/WAEEDIHX)
                   MONMSG     MSGID(CPF0000)
                   CLRPFM     FILE(TVRELWAECO/WAEEDILX)
                   MONMSG     MSGID(CPF0000)
                   DLCOBJ     OBJ((TVRELWAECO/WAEEDIHX  *FILE *EXCL))
                   MONMSG     MSGID(CPF0000)
                   DLCOBJ     OBJ((TVRELWAECO/WAEEDILX  *FILE *EXCL))
                   MONMSG     MSGID(CPF0000)
                ENDDO

       /*      *** Ende WAEEDIHX UND WAEEDILX                                */

/*          __________________________________________________________       */


       /*      4)* Start TEWWW10, TEWWW15 UND TEWWW50 verarbeiten            */
       /*          ==>   NAVHEAD2  UND NAVLINE2 UND (NAVHEAD3)               */
       /*          ==>   NAVHEAD   UND NAVLINE                               */
                CHGVAR VAR(&ERROR) VALUE('0')
                IF      COND(&TECCOM *NE '1') THEN(DO)
       /*         SPÄTER ERROR WIEDER AUF 0 SETZEN                           */
                   CHGVAR VAR(&ERROR) VALUE('1')
       /*                                                                    */
                ENDDO

       /*      OBJEKTSPERRE TEWWW10                                          */
                ALCOBJ     OBJ((BAR_TEC/ORDHEAD      *FILE *EXCL)) +
                                                     WAIT(1)
                MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR) +
                           VALUE('1'))
       /*      OBJEKTSPERRE TEWWW50                                          */
                ALCOBJ     OBJ((BAR_TEC/ORDITEM      *FILE *EXCL)) +
                                                     WAIT(1)
                MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR) +
                           VALUE('1'))
       /*      INHALTE AUF HEADER ?                                          */
                RTVMBRD    FILE(BAR_TEC/ORDHEAD)      MBR(*FIRST) +
                           NBRCURRCD(&NBRCURRCD)
                MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR) +
                           VALUE('1'))
                IF         COND( &NBRCURRCD *EQ 0) THEN(DO)
                   CHGVAR VAR(&ERROR) VALUE('1')
                ENDDO
       /*      INHALTE AUF LINE   ?                                          */
                RTVMBRD    FILE(BAR_TEC/ORDITEM   )   MBR(*FIRST) +
                           NBRCURRCD(&NBRCURRCD)
                MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR) +
                           VALUE('1'))
                IF         COND( &NBRCURRCD *EQ 0) THEN(DO)
                   CHGVAR VAR(&ERROR) VALUE('1')
                ENDDO
       /*      FEHLER, ERROR <> NULL OBJEKTFREIGABE                          */
                IF         COND( &ERROR *NE '0') THEN(DO)
                   DLCOBJ     OBJ((BAR_TEC/ORDHEAD      *FILE *EXCL))
                   MONMSG     MSGID(CPF0000)
                   DLCOBJ     OBJ((BAR_TEC/ORDITEM      *FILE *EXCL))
                   MONMSG     MSGID(CPF0000)
                ENDDO
                IF         COND( &ERROR *EQ '0') THEN(DO)
       /*      DATEIEN KOPIEREN, P A R T  4  FÜR TECCOM                      */

       /*          CPYFRMIMPF FROMFILE(TVRELWAECO/TEWWW10) +  */
                   CHGVAR     VAR(&RUN) VALUE('1')
                   CPYFRMIMPF FROMFILE(BAR_TEC/ORDHEAD) +
                              TOFILE(TVRELWAECO/NAVHEAD2) +
                              MBROPT(*REPLACE) FLDDLM(',') +
                              RPLNULLVAL(*FLDDFT)
                   MONMSG     MSGID(CPF0000)

                   CPYF       FROMFILE(NAVHEAD2) TOFILE(NAVHEAD) +
                              MBROPT(*ADD) FMTOPT(*MAP *DROP)
                   MONMSG     MSGID(CPF0000)

          /*       CPYFRMIMPF FROMFILE(TVRELWAECO/TEWWW50) +  */
                   CPYFRMIMPF FROMFILE(BAR_TEC/ORDITEM) +
                              TOFILE(TVRELWAECO/NAVLINE2) +
                              MBROPT(*REPLACE) FLDDLM(',') +
                              RPLNULLVAL(*FLDDFT)
                   MONMSG     MSGID(CPF0000)

                   CPYF       FROMFILE(NAVLINE2) TOFILE(NAVLINE) +
                              MBROPT(*ADD) FMTOPT(*MAP *DROP)
                   MONMSG     MSGID(CPF0000)

       /*          CPYFRMIMPF FROMFILE(TVRELWAECO/TEWWW15) +  */
                   CPYFRMIMPF FROMFILE(BAR_TEC/ORDSHIP)    +
                              TOFILE(TVRELWAECO/NAVHEAD3) +
                              MBROPT(*REPLACE) FLDDLM(',') +
                              RPLNULLVAL(*FLDDFT)
                   MONMSG     MSGID(CPF0000)

       /*          CPYF       FROMFILE(NAVHEAD3) TOFILE(NAVHEAD) + */
       /*                     MBROPT(*ADD) FMTOPT(*MAP *DROP)      */
       /*          MONMSG     MSGID(CPF0000)                       */

                   CLRPFM     TECCOM
                   MONMSG     MSGID(CPF0000)

       /*         TECCOM -KUNDER ERMITTELN FÜR PROZESS                       */
                   CALL PGM(DUMMY512) PARM(&MD '#DC3063' ' ' ' '   +
                             'TECCOM' 'TVRELWAECO' '*ADD')
                   MONMSG     MSGID(CPF0000)

       /*         ORDER   ANPASSEN EDIH010 FÜR TECCOM KUNDEN#                */
                   CALL  PGM(DUMMY512) PARM(&MD '#DC3064' ' ' ' ' ' ' +
                                ' ' ' ')
                   MONMSG     MSGID(CPF0000)
       /*         ORDER   ANPASSEN EDIH010 FÜR TECCOM KUNDEN#                */
                   CALL  PGM(DUMMY512) PARM(&MD '#DC3061' ' ' ' ' ' ' +
                                ' ' ' ')
                   MONMSG     MSGID(CPF0000)
       /*         ORDER   ANPASSEN EDIH010 FÜR TECCOM KUNDEN#                */
                   CALL  PGM(DUMMY512) PARM(&MD '#DC3062' ' ' ' ' ' ' +
                                ' ' ' ')
                   MONMSG     MSGID(CPF0000)

       /*         ORDER   ANPASSEN EDIL010 FÜR TECCOM                        */
                   CALL  PGM(DUMMY512) PARM(&MD '#DC3060' ' ' ' ' ' ' +
                                ' ' ' ')
                   MONMSG     MSGID(CPF0000)

       /*         SICHERUNG                                                  */
                   CALL       PGM(ORDERIN_R2)
                   MONMSG     MSGID(CPF0000)
                   CPYF       FROMFILE(TVRELWAECO/NAVHEAD) +
                             TOFILE(TVRELWAECO/NAVHEADS) MBROPT(*ADD) +
                              CRTFILE(*YES)
                   MONMSG     MSGID(CPF0000)
                   CLRPFM     FILE(TVRELWAECO/NAVHEAD)
                   MONMSG     MSGID(CPF0000)

                   CPYF       FROMFILE(TVRELWAECO/NAVLINE) +
                             TOFILE(TVRELWAECO/NAVLINES) MBROPT(*ADD) +
                              CRTFILE(*YES)
                   MONMSG     MSGID(CPF0000)
                   CLRPFM     FILE(TVRELWAECO/NAVLINE)
                   MONMSG     MSGID(CPF0000)

                   CPYF       FROMFILE(BAR_TEC/ORDHEAD)    +
                             TOFILE(TVRELWAECO/ORDHEADS) MBROPT(*ADD) +
                             CRTFILE(*NO)
                   MONMSG     MSGID(CPF0000)
                   CPYF       FROMFILE(BAR_TEC/ORDITEM)    +
                             TOFILE(TVRELWAECO/ORDITEMS) MBROPT(*ADD) +
                             CRTFILE(*NO)
                   MONMSG     MSGID(CPF0000)
                   CPYF       FROMFILE(BAR_TEC/ORDSHIP)    +
                             TOFILE(TVRELWAECO/ORDSHIPS) MBROPT(*ADD) +
                             CRTFILE(*NO)
                   MONMSG     MSGID(CPF0000)
                   CLRPFM     FILE(BAR_TEC/ORDHEAD)
                   MONMSG     MSGID(CPF0000)
                   CLRPFM     FILE(BAR_TEC/ORDITEM)
                   MONMSG     MSGID(CPF0000)
                   CLRPFM     FILE(BAR_TEC/ORDSHIP)
                   MONMSG     MSGID(CPF0000)
                   DLCOBJ     OBJ((BAR_TEC/ORDHEAD      *FILE *EXCL))
                   MONMSG     MSGID(CPF0000)
                   DLCOBJ     OBJ((BAR_TEC/ORDITEM      *FILE *EXCL))
                   MONMSG     MSGID(CPF0000)
                ENDDO
       /*      *** Ende TEWWW10, TEWWW15 UND TEWWW50                         */

/*          __________________________________________________________       */


       /*      5)* Start DOM003,  DOM001  UND DOM002  verarbeiten            */
       /*          ==>   PWINORH, PWINORD UND PWINORT NAGEL/DOMORDER01       */
                CHGVAR VAR(&ERROR) VALUE('0')

                RTVJOBA    USER(&USER)
                MONMSG     MSGID(CPF0000)

                IF      COND(&BENELUX *NE '1') THEN(DO)
       /*         SPÄTER ERROR WIEDER AUF 0 SETZEN                           */
                   CHGVAR VAR(&ERROR) VALUE('1')
       /*                                                                    */
                ENDDO

       /*      BERECHTIGUNGSCHECK                                            */
                ADDSVRAUTE USRPRF(&USER) SERVER(QDDMSERVER) +
                             USRID(TRANSFER)
                MONMSG     MSGID(CPF0000)

       /*      OBJEKTSPERRE DOM003                                           */
                ALCOBJ     OBJ((WAECOEDI/DOM003 *FILE *EXCL)) WAIT(1)
                MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR) +
                           VALUE('1'))
       /*      OBJEKTSPERRE D0M001                                           */
                ALCOBJ     OBJ((WAECOEDI/DOM001 *FILE *EXCL)) WAIT(1)
                MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR) +
                           VALUE('1'))
       /*      INHALTE AUF HEADER ?                                          */
                RTVMBRD    FILE(WAECOEDI/DOM003)  MBR(*FIRST) +
                           NBRCURRCD(&NBRCURRCD)
                MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR) +
                           VALUE('1'))
                IF         COND( &NBRCURRCD *EQ 0) THEN(DO)
                   CHGVAR VAR(&ERROR) VALUE('1')
                ENDDO
       /*      INHALTE AUF LINE   ?                                          */
                RTVMBRD    FILE(WAECOEDI/DOM001)    MBR(*FIRST) +
                           NBRCURRCD(&NBRCURRCD)
                MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR) +
                           VALUE('1'))
                IF         COND( &NBRCURRCD *EQ 0) THEN(DO)
                   CHGVAR VAR(&ERROR) VALUE('1')
                ENDDO
       /*      FEHLER, ERROR <> NULL OBJEKTFREIGABE                          */
                IF         COND( &ERROR *NE '0') THEN(DO)
                   DLCOBJ     OBJ((WAECOEDI/DOM003    *FILE *EXCL))
                   MONMSG     MSGID(CPF0000)
                   DLCOBJ     OBJ((WAECOEDI/DOM001    *FILE *EXCL))
                   MONMSG     MSGID(CPF0000)
                ENDDO
       /*      DATEIEN KOPIEREN, P A R T  5  ÜBER  PWINORH/..D, ..T          */
                IF         COND( &ERROR *EQ '0') THEN(DO)
                   CHGVAR     VAR(&RUN) VALUE('1')
                   CPYF       FROMFILE(WAECOEDI/DOM001) +
                              TOFILE(TVRELWAECO/PWINORD) MBROPT(*ADD) +
                              CRTFILE(*NO) FMTOPT(*NOCHK)
                   MONMSG     MSGID(CPF0000)
                   CPYF       FROMFILE(WAECOEDI/DOM002) +
                              TOFILE(TVRELWAECO/PWINORT) MBROPT(*ADD) +
                              CRTFILE(*NO) FMTOPT(*NOCHK)
                   MONMSG     MSGID(CPF0000)
                   CPYF       FROMFILE(WAECOEDI/DOM003) +
                              TOFILE(TVRELWAECO/PWINORH) MBROPT(*ADD) +
                              CRTFILE(*NO) FMTOPT(*NOCHK)
                   MONMSG     MSGID(CPF0000)

       /*         SICHERUNG                                                  */
                   CALL       PGM(ORDERIN_R3)
                   MONMSG     MSGID(CPF0000)
                   CPYF       FROMFILE(TVRELWAECO/PWINORH) +
                             TOFILE(TVRELWAECO/PWINORHS) MBROPT(*ADD) +
                              CRTFILE(*NO)
                   MONMSG     MSGID(CPF0000)
                   CLRPFM     FILE(TVRELWAECO/PWINORH)
                   MONMSG     MSGID(CPF0000)
                   CPYF       FROMFILE(TVRELWAECO/PWINORD) +
                             TOFILE(TVRELWAECO/PWINORDS) MBROPT(*ADD) +
                              CRTFILE(*NO)
                   MONMSG     MSGID(CPF0000)
                   CLRPFM     FILE(TVRELWAECO/PWINORD)
                   MONMSG     MSGID(CPF0000)
                   CPYF       FROMFILE(TVRELWAECO/PWINORT) +
                             TOFILE(TVRELWAECO/PWINORTS) MBROPT(*ADD) +
                              CRTFILE(*NO)
                   MONMSG     MSGID(CPF0000)
                   CLRPFM     FILE(TVRELWAECO/PWINORT)
                   MONMSG     MSGID(CPF0000)

                   CLRPFM     FILE(WAECOEDI/DOM003)
                   MONMSG     MSGID(CPF0000)
                   CLRPFM     FILE(WAECOEDI/DOM002)
                   MONMSG     MSGID(CPF0000)
                   CLRPFM     FILE(WAECOEDI/DOM001)
                   MONMSG     MSGID(CPF0000)

                   DLCOBJ     OBJ((WAECOEDI/DOM001 *FILE *EXCL))
                   MONMSG     MSGID(CPF0000)
                   DLCOBJ     OBJ((WAECOEDI/DOM003 *FILE *EXCL))
                   MONMSG     MSGID(CPF0000)
                ENDDO
       /*      *** Ende DOM001, DOM002, DOM003                               */

/*          __________________________________________________________       */

/*          __________________________________________________________       */
       /*         HDX AUFTRÄGE ABARBEITEN                                    */
       /*         ==> 000002                                                 */
                   CALL ORDERHDXC
                   MONMSG     MSGID(CPF0000)
       /*         B2B AUFTRÄGE ABARBEITEN DIREKT                             */
       /*         ==> 000055                                                 */
                   CALL PGM(TVRELWAECO/B2BB2C)
                   MONMSG     MSGID(CPF0000)
       /*         FRANKREICH TREND INTERFACE FÜLLEN ÜBER NEUES MODUL         */
                   CALL PGM(ORDERSFTP) PARM('88505')
                   MONMSG     MSGID(CPF0000)
       /*         ITALIEN    TREND INTERFACE FÜLLEN ÜBER NEUES MODUL         */
                   CALL PGM(ORDERSFTP) PARM('55278')
                   MONMSG     MSGID(CPF0000)
       /*         SPANIEN    TREND INTERFACE FÜLLOK ÜBER NEUES MODUL         */
                   CALL PGM(ORDERSFTP) PARM('78146')
                   MONMSG     MSGID(CPF0000)
       /*         SCHWEDEN   TREND INTERFACE FÜLLEN ÜBER NEUES MODUL         */
                   CALL PGM(ORDERSFTP) PARM('08138')
                   MONMSG     MSGID(CPF0000)
       /*         NORWEGEN   TREND INTERFACE FÜLLEN ÜBER NEUES MODUL         */
                   CALL PGM(ORDERSFTP) PARM('42634')
                   MONMSG     MSGID(CPF0000)
       /*         HDX AUFTRÄGE ABARBEITEN WEGEN PERFORMANCE                  */
       /*         ==> 000002                                                 */
                   CALL ORDERHDXC
                   MONMSG     MSGID(CPF0000)
       /*         POLEN      TREND INTERFACE FÜLLEN ÜBER NEUES MODUL         */
                   CALL PGM(ORDERSFTP) PARM('78678')
                   MONMSG     MSGID(CPF0000)
       /*         POLEN DIST TREND INTERFACE FÜLLEN ÜBER NEUES MODUL         */
                   CALL PGM(ORDERSFTP) PARM('78680')
                   MONMSG     MSGID(CPF0000)
       /*         ÖSTERREICH TREND INTERFACE FÜLLEN ÜBER NEUES MODUL         */
                   CALL PGM(ORDERSFTP) PARM('54939')
                   MONMSG     MSGID(CPF0000)
       /*         ENGLAND    TREND INTERFACE FÜLLEN ÜBER NEUES MODUL         */
                   CALL PGM(ORDERSFTP) PARM('40631')
                   MONMSG     MSGID(CPF0000)
       /*         DÄNEMARK   TREND INTERFACE FÜLLEN ÜBER NEUES MODUL         */
                   CALL PGM(ORDERSFTP) PARM('01887')
                   MONMSG     MSGID(CPF0000)
       /*         RUSSLAND   TREND INTERFACE FÜLLEN ÜBER NEUES MODUL         */
       /*         ==> 191453                                                 */
                   CALL PGM(ORDERSFTP) PARM('91453')
                   MONMSG     MSGID(CPF0000)
       /*         SLOWAKIA   TREND INTERFACE FÜLLEN ÜBER NEUES MODUL         */
       /*         ==> 002511 + 772511                                        */
                   CALL PGM(ORDERSFTP) PARM('02511')
                   MONMSG     MSGID(CPF0000)
       /*         LUXEMBURG  TREND INTERFACE FÜLLEN ÜBER NEUES MODUL         */
       /*         ==> 052774 + 752774                                       */
                   CALL PGM(ORDERSFTP) PARM('52774')
                   MONMSG     MSGID(CPF0000)
       /*         UNGARN     TREND INTERFACE FÜLLEN ÜBER NEUES MODUL         */
       /*         ==> 096690 + 796690                                       */
                   CALL PGM(ORDERSFTP) PARM('96690')
                   MONMSG     MSGID(CPF0000)
       /*         FINNLAND   TREND INTERFACE FÜLLEN ÜBER NEUES MODUL         */
       /*         ==> 005084                                                */
                   CALL PGM(ORDERSFTP) PARM('05084')
                   MONMSG     MSGID(CPF0000)
       /*         ITALIEN2   TREND INTERFACE FÜLLEN ÜBER NEUES MODUL         */
                   CALL PGM(ORDERSFTP) PARM('35671')
                   MONMSG     MSGID(CPF0000)
       /*         FRANKREICH TREND TEST AUS ANDERES VERZEICHNIS!!!!!!!       */
                   CALL PGM(ORDERSFTP) PARM('T8505')
                   MONMSG     MSGID(CPF0000)
       /*         UK         TREND TEST AUS ANDERES VERZEICHNIS!!!!!!!       */
                   CALL PGM(ORDERSFTP) PARM('T0631')
                   MONMSG     MSGID(CPF0000)
       /*         POLEN      TREND TEST AUS ANDERES VERZEICHNIS!!!!!!!       */
                   CALL PGM(ORDERSFTP) PARM('T8678')
                   MONMSG     MSGID(CPF0000)
       /*         UK 2 CWL   TREND INTERFACE FÜLLEN ÜBER NEUES MODUL         */
                   CALL PGM(ORDERSFTP) PARM('40670')
                   MONMSG     MSGID(CPF0000)
       /*         UK 3 CWL   TREND INTERFACE FÜLLEN ÜBER NEUES MODUL         */
                   CALL PGM(ORDERSFTP) PARM('40642')
                   MONMSG     MSGID(CPF0000)
       /*         DOMETIC CLAINM SYSTEM DCS                                */
       /*         ==> 0000005                                               */
      /*           CALL PGM(ORDERSFTP) PARM('00005')                         */
      /*           MONMSG     MSGID(CPF0000)                                 */
      /*           CHGVAR     VAR(&DCS) VALUE(0000077)                       */
      /*           CALL       PGM(ORDERR) PARM(&DCS)                         */
      /*           MONMSG     MSGID(CPF0000)                                 */
       /*         AUFTRÄGE ÜBER WEB FREIGEBEN                                */
       /*         ==> 000077                                                 */
                   CHGVAR     VAR(&WEBCLIENT) VALUE(0000077)
                   CALL       PGM(ORDERR) PARM(&WEBCLIENT)
                   MONMSG     MSGID(CPF0000)
       /*         EASYIMPORT AUFTRÄGE ABARBEITEN                             */
       /*         ==> 000025                                                 */
       /*          CALL EASYIMPORT              25.11.2025 INAKTIV GESETZT    */
       /*          MONMSG     MSGID(CPF0000)    DIREKTER IMOIRT               */
/*          __________________________________________________________       */
/*          DIMITRI GGF. VORLAGE FÜR KOPIE    DIREKTES SCHREIBEN ORDERH/K/T  */
       /*         &APICLIENT AUFTRÄGE ABARBEITEN API CLIENT INTERFACE        */
       /*         ==> 000025                                                 */
                   CHGVAR     VAR(&APICLIENT) VALUE(0000025)
                   CALL       PGM(ORDERR) PARM(&APICLIENT)
                   MONMSG     MSGID(CPF0000)
/*          __________________________________________________________       */
       /*         WORKIST    AUFTRÄGE ABARBEITEN                             */
       /*         ==> 000035                                                 */
                   CALL WORKIST_R9
                   MONMSG     MSGID(CPF0000)
/*          __________________________________________________________       */
                   DLYJOB     DLY(35)
                   MONMSG     MSGID(CPF0000)
/*          __________________________________________________________       */
       /*         AUFTRÄGE AUS D365 FREIGEBEN                                */
                   RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&QTIME)
                   IF         COND(&QTIME *GT '050000' *AND &QTIME *LT +
                             '220000') THEN(DO)
                      CALL       PGM(ORDERS365)
                      MONMSG     MSGID(CPF0000)
                   ENDDO



                IF         COND( &RUN *EQ '1') THEN(DO)
       /*         TREND ENVIRNOMENT NACHBILDEN                               */
       /*          CALL PGM(TE)                    */
       /*          MONMSG     MSGID(CPF0000)       */
       /*         TREND INTERFACE FÜLLEN                                     */
                   IF      COND( &ORDERTEST *EQ '1') THEN(DO)
                      CALL PGM(TVRELWAECO/ORDERTEST)
                   ENDDO
                   CHGDTAARA  DTAARA(TVRELWAECO/NAVLOG (01 01)) +
                              VALUE('0')
                   CALL PGM(#DEFLDA)
                   MONMSG     MSGID(CPF0000)
                ENDDO
             ENDDO
             GOTO       CMDLBL(ENDPGM)

 ENDPGM:
       /*   FREIGABEN IN JEDEM FALL                                          */
             DLCOBJ     OBJ((TVRELWAECO/NAVHEAD01 *FILE *EXCL))
             MONMSG     MSGID(CPF0000)
             DLCOBJ     OBJ((TVRELWAECO/NAVLINE01 *FILE *EXCL))
             MONMSG     MSGID(CPF0000)
             DLCOBJ     OBJ((TVRELWAECO/WWWORD10 *FILE *EXCL))
             MONMSG     MSGID(CPF0000)
             DLCOBJ     OBJ((TVRELWAECO/WWWORD50 *FILE *EXCL))
             MONMSG     MSGID(CPF0000)
             DLCOBJ     OBJ((TVRELWAECO/WAEEDIHX *FILE *EXCL))
             MONMSG     MSGID(CPF0000)
             DLCOBJ     OBJ((TVRELWAECO/WAEEDILX *FILE *EXCL))
             MONMSG     MSGID(CPF0000)
             DLCOBJ     OBJ((BAR_TEC/ORDHEAD    *FILE *EXCL))
             MONMSG     MSGID(CPF0000)
             DLCOBJ     OBJ((BAR_TEC/ORDITEM    *FILE *EXCL))
             MONMSG     MSGID(CPF0000)
             DLCOBJ     OBJ((WAECOEDI/DOM001 *FILE *EXCL))
             MONMSG     MSGID(CPF0000)
             DLCOBJ     OBJ((WAECOEDI/DOM003 *FILE *EXCL))
             MONMSG     MSGID(CPF0000)

             DLTOVR     FILE(ORDERINPUT)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(TVRELWAECO/NAVLOG (01 01)) VALUE('0')

       /*   DOMETIC CLAINM SYSTEM DCS                                */
       /*   ==> 0000005                                               */
             CALL       PGM(#DCSR)
             MONMSG     MSGID(CPF0000)

             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(TVRELWAECO)
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&ERROR3 = '0') THEN(DO)
                RMVLIBLE   LIB(WAECOEDI)
                MONMSG     MSGID(CPF0000)
             ENDDO

             CHGJOB     CCSID(1141)
     /*      DSPJOBLOG  OUTPUT(*PRINT)                */

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

             ENDPGM
