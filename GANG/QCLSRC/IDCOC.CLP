/*    * PROGRAMMNAME.:CALL ........                                          */
/*    * FUNKTION.....:IDCO                                                   */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    * SELECT #LBLBTENR, SUBSTR(#LBLBTMST, 1, 4) JAHR,                       */
/*    * SUBSTR(#LBLBTMST,                                                     */
/*    * 5, 2) MONAT, #LBLBBWMG, #LBLBBWME, #RWERT, #WE#EL, CHAR(CURRENT       */
/*    * DATE - 1 MONTH, ISO) FROM DATENKW/#LBLB WHERE #STATUSX <> '' ''       */
/*    * AND                                                                   */
/*    *   SUBSTR(CHAR(CURRENT DATE - 1 MONTH, ISO), 1, 4) =                   */
/*    * SUBSTR(#LBLBTMST,                                                     */
/*    *   1, 4) AND SUBSTR(CHAR(CURRENT DATE - 1 MONTH, ISO), 6, 2) =         */
/*    *   SUBSTR(#LBLBTMST, 5, 2)'                                            */
/*    * .                                                                     */
/*    *  SELECT DCCODE, INUMBE, IDESCR, IDCO_, REPYEA, REPMON, QTY,           */
/*    *  UNIT,                                                                */
/*    *  ACPAID, CURREN, STK, STKPRI, SUPNAM, SUPTYP, SUPCOU, DELTER,         */
/*    *  PAYTER, CASHDI, GRPCON, PROGRP, PURCHC , X'0D25' FROM #ID1999        */
/*    *  DATEI #ID1999#2 IN TVRELWAECO WURDE ERSTELLT.                        */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&PARM)

             DCL        VAR(&PARM)    TYPE(*CHAR) LEN(01)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&ERROR1)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&OUTFILE)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFKT)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBRCURRCD)  TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBRCURRCD2) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&DATE)      TYPE(*CHAR) LEN(06)
             DCL        VAR(&DAYOFWEEK) TYPE(*CHAR) LEN(04)

             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('IDCOC     ')
             RTVMBRD    FILE(GANG/QCLSRC) MBR(&PGM) TEXT(&TXT)
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
             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))

             ADDLIBLE   LIB(PRODWIN51) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))


/*          ANLAGE IDCOS IN TEOS AUTOMATISCH ÜBER GRUPPE                  */
             CALL       PGM(IDCOUPDR)
             MONMSG     MSGID(CPF0000)

/*          PROTOKOLLIERUNG ---                                           */

             CALL       PGM(DUMMY512) PARM(&MD '#DC0003' ' ' ' ' +
                           '#DC0003' 'QTEMP     ' '*REPLACE')
             MONMSG     MSGID(CPF0000)
             RTVMBRD    FILE(QTEMP/#DC0003) +
                        NBRCURRCD(&NBRCURRCD)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&NBRCURRCD) +
                        VALUE(0))
             IF         COND(&NBRCURRCD *EQ 0) THEN(GOTO +
                          CMDLBL(ENDPGM))


             IF         COND(&PARM *EQ '2' ) THEN(DO)
/*             GENERELLER AUFBAU                                             */
                DLTF       FILE(TVRELWAECO/#ID1000)
                MONMSG     MSGID(CPF0000)
                DLTF       FILE(TVRELWAECO/#ID1010)
                MONMSG     MSGID(CPF0000)
                DLTF       FILE(TVRELWAECO/#ID1500)
                MONMSG     MSGID(CPF0000)
                CLRPFM     FILE(TVRELWAECO/#IDCO)
                MONMSG     MSGID(CPF0000)
/*         01  IDCO-DATEN AUS DATENKW/#LBLB HOLEN MIT ERLEDIGTEN WE          */
/*             VORMONAT AUS TIMESTAMP                                        */
                CALL       PGM(DUMMY512) PARM(&MD '#ID1000' ' ' ' ' +
                             '#ID1000' 'TVRELWAECO' '*REPLACE')
                MONMSG     MSGID(CPF0000)
/*         02  VERBINDEN AUS #ID1000 MIT KALK_FILE ZUSATZINFOS               */
                CALL       PGM(DUMMY512) PARM(&MD '#ID1010' ' ' ' ' +
                             '#ID1010' 'TVRELWAECO' '*REPLACE')
                MONMSG     MSGID(CPF0000)
/*         03  MIT IDCOCODE VERSORGEN UPDATE TVRELWAECO/#ID1010              */
/*             ÜBER STATISTIKNUMMER IN TABELLE                               */
/*              CALL       PGM(DUMMY512) PARM(&MD '#ID1020' ' ' ' ' +         */
/*                           ' ' ' ' '*REPLACE')                              */
/*              MONMSG     MSGID(CPF0000)                                     */
/*         04  FEHLENDE LINKS ÜBER ARTIKEL UPDATE #ID1010                    */
/*             ÜBER ARTIKEL DIREKTZUORDNUNG                                  */
/*              CALL       PGM(DUMMY512) PARM(&MD '#ID1030' ' ' ' ' +         */
/*                           ' ' ' ' '*REPLACE')                              */
/*              MONMSG     MSGID(CPF0000)                                     */
/*         05  JETZT DIREKTE ZUORDNUNG ÜBER TEOS                             */
                CALL       PGM(DUMMY512) PARM(&MD '#ID1035' ' ' ' ' +
                             ' ' ' ' '*REPLACE')
                MONMSG     MSGID(CPF0000)
/*         05  LINK PRJ627P RECHNUNGSMENGE EINBEZIEHEN UPDATE #ID1010        */
                CALL       PGM(DUMMY512) PARM(&MD '#ID1040' ' ' ' ' +
                             ' ' ' ' '*REPLACE')
                MONMSG     MSGID(CPF0000)
/*         06  LINK PRJ627P RECHNUNGSEINHEITEN UPDATE #ID1010                */
                CALL       PGM(DUMMY512) PARM(&MD '#ID1050' ' ' ' ' +
                             ' ' ' ' '*REPLACE')
                MONMSG     MSGID(CPF0000)
/*         07  LINK PRJ627P KTOHAB UPDATE #ID1010                            */
                CALL       PGM(DUMMY512) PARM(&MD '#ID1060' ' ' ' ' +
                             ' ' ' ' '*REPLACE')
                MONMSG     MSGID(CPF0000)
/*         08  LINK PRJ627P RECHNUNGSBETRAG UPDATE #ID1010                   */
                CALL       PGM(DUMMY512) PARM(&MD '#ID1070' ' ' ' ' +
                             ' ' ' ' '*REPLACE')
                MONMSG     MSGID(CPF0000)
/*         09  LINK PRJ627P RECHNUNGS# FÜR PRJ626P UPDATE #ID1010            */
                CALL       PGM(DUMMY512) PARM(&MD '#ID1080' ' ' ' ' +
                             ' ' ' ' '*REPLACE')
                MONMSG     MSGID(CPF0000)
/*         10  AUS PRJ626P BUCDAT HOLEN (BUCHUNGSDATUM)UPDATE #ID1010        */
                CALL       PGM(DUMMY512) PARM(&MD '#ID1090' ' ' ' ' +
                             ' ' ' ' '*REPLACE')
                MONMSG     MSGID(CPF0000)

                CALL #ID1010R
                MONMSG     MSGID(CPF0000)

/*         10B ERGÄNZUNG PRJ627P RECHNUNGBEZUG                               */
/*             FÜR WÄHRUNG LESEN UPDATE #ID1500                              */
                CALL       PGM(DUMMY512) PARM(&MD '#ID1525' ' ' ' ' +
                             ' ' ' ' '*REPLACE')
                MONMSG     MSGID(CPF0000)

/*         11  CUMDATEI IDCO GRUPPIERUNG AUS #ID1010 IN #ID1500              */
                CALL       PGM(DUMMY512) PARM(&MD '#ID1500' ' ' ' ' +
                           '#ID1500' 'TVRELWAECO' '*REPLACE')
                MONMSG     MSGID(CPF0000)
/*         12  ERGÄNZUNG UM ZAHLUNGSBEDINGUNGEN AUS BUCHHALTUNG              */
/*             UPDATE #ID1500                                                */
                CALL       PGM(DUMMY512) PARM(&MD '#ID1510' ' ' ' ' +
                             ' ' ' ' '*REPLACE')
                MONMSG     MSGID(CPF0000)
/*         13  ERGÄNZUNG UM NAME AUS BUCHHALTUNG UPDATE #ID1500              */
                CALL       PGM(DUMMY512) PARM(&MD '#ID1520' ' ' ' ' +
                             ' ' ' ' '*REPLACE')
                MONMSG     MSGID(CPF0000)
/*         13B ERGÄNZUNG UM KÜRZEL AUS BUCHHALTUNG UPDATE #ID1500            */
                CALL       PGM(DUMMY512) PARM(&MD '#ID1521' ' ' ' ' +
                             ' ' ' ' '*REPLACE')
                MONMSG     MSGID(CPF0000)
/*         14  FIRMA GEHÖRT ZUM VERBAND KENNUNG G                            */
                CALL       PGM(DUMMY512) PARM(&MD '#ID1530' ' ' ' ' +
                             ' ' ' ' '*REPLACE')
                MONMSG     MSGID(CPF0000)
/*     ??  15  ZIEHEN RELEVANTER DATEN AUS #LBLB                             */
                CALL       PGM(DUMMY512) PARM(&MD '#ID1540' ' ' ' ' +
                             ' ' ' ' '*REPLACE')
                MONMSG     MSGID(CPF0000)
/*     ??  16  LÖSCHEN VORMONAT                                              */
                CALL       PGM(DUMMY512) PARM(&MD '#ID1560' ' ' ' ' +
                             ' ' ' ' '*REPLACE')
                MONMSG     MSGID(CPF0000)

/*         16  ANPASSUNGEN ÜBER RPG                                          */
                CALL IDCOR
                MONMSG     MSGID(CPF0000)

/*         18  KANN SPÄTER WIEDER HERAUSGENOMMEN WERDEN                      */
                CALL       PGM(DUMMY512) PARM(&MD '#ID1570' ' ' ' ' +
                             ' ' ' ' ' ')
                MONMSG     MSGID(CPF0000)
/*                                                                            */
                CLRPFM     FILE(#ID1999)
                MONMSG     MSGID(CPF0000)
/*                                                                            */
                CALL       PGM(DUMMY512) PARM(&MD '#ID1999' ' ' ' ' +
                                '#ID1999' 'TVRELWAECO' '*REPLACE')
                MONMSG     MSGID(CPF0000)
             ENDDO
       /*   *** *******N E U ************************                        */
             IF         COND(&PARM *EQ '1') THEN(DO)
                CLRPFM     FILE(#ID1999)
                MONMSG     MSGID(CPF0000)
                CLRPFM     FILE(SIEVO_VL)
                MONMSG     MSGID(CPF0000)
                CLRPFM     FILE(SIEVO_VL2)
                MONMSG     MSGID(CPF0000)
                CALL       PGM(SIEVONEWR)
                MONMSG     MSGID(CPF0000)
/*             KORREKTUR DER TEXTE                                           */
                CALL       PGM(SIEVONEWRK)
                MONMSG     MSGID(CPF0000)
             ENDDO

             IF         COND(&PARM *EQ '1' *OR &PARM *EQ '2') THEN(DO)
       /*   *** ÜBERGABE IDCO AUSGABE PER MAIL                               */

                RMVLNK     OBJLNK('/SIEVO_DATA/#ID1999.CSV')
                MONMSG     MSGID(CPF0000)
                CVTDBF     OBJ('/SIEVO_DATA/#ID1999.CSV') +
                             DBFILE(TVRELWAECO/#ID1999) +
                             DBOUTFMT(*CSV) DBFLDDSC(*YES)
                MONMSG     MSGID(CPF0000)
                OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                       FORMTYPE('SIEVO_DATA') OVRSCOPE(*JOB)
                MONMSG     MSGID(CPF0000)
/*                                                                            */
                CALL     PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                          ' ' ' ' ' ')
                MONMSG     MSGID(CPF0000)
                DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
                MONMSG     MSGID(CPF0000)
             ENDDO

/*                                                                            */
 ENDPGM:
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
             ENDDO
             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(PRODWIN51)
             ENDDO

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
