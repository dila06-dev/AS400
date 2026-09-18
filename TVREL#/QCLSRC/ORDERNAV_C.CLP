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
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&NAVLOG)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&ERROR)  TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&ERROR1) TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&ERROR2) TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&RUN)    TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&QTIME)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&BENELUX)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&ORDERTEST) TYPE(*CHAR) LEN(1)

       /*   *** ACHTUNG SYSVAL                                               */
             CHGJOB     CCSID(*SYSVAL)

             CALL       PGM(WAECOEDI/DOMORDERFR)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(WAECOEDI/DOMORDERUK)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(WAECOEDI/DOMORDERCH)
             MONMSG     MSGID(CPF0000)

             CHGVAR VAR(&BENELUX) VALUE('0')
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&QTIME)
             IF         COND(&QTIME *GT '075900' *AND &QTIME *LT +
                          '080200') THEN(DO)
                CHGVAR VAR(&BENELUX) VALUE('1')
             ENDDO
             IF         COND(&QTIME *GT '093900' *AND &QTIME *LT +
                          '094200') THEN(DO)
                CHGVAR VAR(&BENELUX) VALUE('1')
             ENDDO
             IF         COND(&QTIME *GT '113900' *AND &QTIME *LT +
                          '114200') THEN(DO)
                CHGVAR VAR(&BENELUX) VALUE('1')
             ENDDO
             IF         COND(&QTIME *GT '132900' *AND &QTIME *LT +
                          '133200') THEN(DO)
                CHGVAR VAR(&BENELUX) VALUE('1')
             ENDDO
             IF         COND(&QTIME *GT '143900' *AND &QTIME *LT +
                          '144200') THEN(DO)
                CHGVAR VAR(&BENELUX) VALUE('1')
             ENDDO
             IF         COND(&QTIME *GT '153900' *AND &QTIME *LT +
                          '154200') THEN(DO)
                CHGVAR VAR(&BENELUX) VALUE('1')
             ENDDO

             IF      COND(&BENELUX *EQ '0') THEN(DO)
                RTVDTAARA  DTAARA(TVRELWAECO/BENELUX (01 01)) +
                          RTNVAR(&BENELUX)
             ENDDO

             IF      COND(&BENELUX *EQ '1') THEN(DO)
        /*      CALL       PGM(NAGEL/DOMORDER01)     */
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

             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(TVRELWAECO)
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
                MONMSG     MSGID(CPF0000)
             ENDDO
             CHGJOB     CCSID(1141)

     /*      DSPJOBLOG  OUTPUT(*PRINT)                */

             ENDPGM
