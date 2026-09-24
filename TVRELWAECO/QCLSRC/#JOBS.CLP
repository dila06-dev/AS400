/*    * PROGRAMMNAME.:$GANG                                                  */
/*    * FUNKTION.....:...                                                    */
/*    * JULI    2010   GANG, MANFRED                                          */
/*    *                                                                       */
/*    *-START SUBSTYSTEM                                                     */
/*    * SELECT TETENR, CHAR('001') LAGER FROM TEIL                            */
/*    *       .                                                               */
/*    *            .                                                          */
/*    *                .                                                      */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/

             DCL        VAR(&ERROR1)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&CODE)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&SC) TYPE(*DEC) LEN(07 0) VALUE(0000000)
             DCL        VAR(&K)         TYPE(*CHAR) LEN(5)
             DCL        VAR(&#)         TYPE(*CHAR) LEN(1)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&QTIME)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&DAFEHL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&QDAYOFWEEK) TYPE(*CHAR) LEN(04)
             DCL        VAR(&QDATETIME)  TYPE(*CHAR) LEN(20)
             DCL        VAR(&QDAY)  TYPE(*CHAR) LEN(02)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)
             DCL        VAR(&NBRCURRCD)  TYPE(*DEC) LEN(10 0)
             DCL        VAR(&D)          TYPE(*CHAR) LEN(8)
             RTVSYSVAL  SYSVAL(QDATETIME) RTNVAR(&QDATETIME)
             CHGVAR     VAR(&D) VALUE(%SST(&QDATETIME 1 8))
             CHGVAR     VAR(&D) VALUE('20130401')

             ADDLIBLE   LIB(TVRELWAECO) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('#JOBS     ')

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('#JOBS     ')
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

             RTVSYSVAL  SYSVAL(QDAYOFWEEK) RTNVAR(&QDAYOFWEEK)
             MONMSG     MSGID(CPF0000)
             RTVSYSVAL  SYSVAL(QDAY) RTNVAR(&QDAY)
             MONMSG     MSGID(CPF0000)
       /*    *MON  */
       /*    *TUE  */
       /*    *WED  */
       /*    *THU  */
       /*    *FRI  */
       /*    *SAT  */
       /*    *SUN  */

/*                                                                            */
/*    _RPMEXPECM ____________________________________________________     */
       /*   *** EXPECTED SALES CALCULATION FOR RPM                           */
       /*   *** WOCHENTAG WIRD INTERN ERMITTELT                              */
       /*       ADDLIBLE   LIB(DOMCOMV7) POSITION(*LAST)                      */
       /*       MONMSG     MSGID(CPF0000)                                     */
       /*       ADDLIBLE   LIB(DOMDATV7) POSITION(*AFTER DOMCOMV7)            */
       /*       MONMSG     MSGID(CPF0000)                                     */
       /*       CALL       PGM(RPMEXPECM)   AZSGELAGERT IN JOB_R              */
/*                                                                            */
/*    _RPMEXPECM ____________________________________________________     */
       /*   *** STK-3 ÜBERGABE                                               */
             IF         COND(&QDAYOFWEEK = '*FRI' *AND &QDAY < '99') +
                          THEN(DO)
       /***     AUSGELAGERT IN'S RPG 09.02.2017                            ***/
       /***     CALL       PGM(RPMIISTK3R)                                 ***/
             ENDDO
/*                                                                            */
/*    _HÜLLE_________________________________________________________     */
             IF         COND(&QDAYOFWEEK = '*WED' *AND &QDAY < '03') +
                          THEN(DO)
       /*   *** STK3                                                         */
       /*    CALL    PGM(DUMMY512) PARM(&MD 'STK1000' ' ' ' ' +     */
       /*                ' ' ' ' ' ')                               */
       /*    MONMSG     MSGID(CPF0000)                              */
/*                                                                            */
             ENDDO
/*    _______________________________________________________________     */

/*    _SKU-ANPASSUNGEN_______________________________________________     */
       /*   *** NEUE SKU'S ÜBERGEBEN UND IN TEOS EINTRAGEN                   */
       /*   *** BASIS BAR_KALK/KALK_FILE WO ARTBEZFRA = ' ', ALSO            */
       /*   *** KEINE ZUORDNUNG HABEN, SIE WERDEN DANN IM FOLGEJOB           */
       /*   *** ZUGEORDNET IN TREND TEOS UND IN SKU0011 IN                   */
       /*   *** BAR_KALK/KALK_FILE EINGETRAGEN. DAMIT SCHLIESST SICH         */
       /*   *** DER KREIS                                                    */
             CALL    PGM(DUMMY512) PARM(&MD 'SKU0010' ' ' ' ' +
                         'SKUTRANSF' 'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(SKUTRANSFR)
             MONMSG     MSGID(CPF0000)
             CALL    PGM(DUMMY512) PARM(&MD 'SKU0011' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
       /*   *** AUSGABE UND MELDUNG AN SC'S                                  */
             CPYF       FROMFILE(TVRELWAECO/NEW_ITEMS) +
                          TOFILE(TVRELWAECO/NEW_ITEMS#) +
                          MBROPT(*ADD) CRTFILE(*NO)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(TVRELWAECO/NEW_ITEMS)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(SKU0012R)
             MONMSG     MSGID(CPF0000)
       /*    CALL    PGM(DUMMY512) PARM(&MD 'SKU0012' ' ' ' ' +*/
       /*                'NEW_ITEMS' 'TVRELWAECO' '*REPLACE')  */
             RTVMBRD    FILE(TVRELWAECO/ITEM_NEWS) MBR(*FIRST) +
                          NBRCURRCD(&NBRCURRCD)
             MONMSG     MSGID(CPF0000)
             IF         COND(&NBRCURRCD *EQ 0) THEN(DO)
                RMVLNK     OBJLNK('/SALESCOMPANY/NEW_ITEMS.CSV')
                MONMSG     MSGID(CPF0000)
                CVTDBF     OBJ('/SALESCOMPANY/NEW_ITEMS.CSV') +
                             DBFILE(TVRELWAECO/NEW_ITEMS) +
                             DBOUTFMT(*CSV) DBFLDDSC(*YES)
                MONMSG     MSGID(CPF0000)
                OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                       FORMTYPE('NEW_ITEMS') OVRSCOPE(*JOB)
                MONMSG     MSGID(CPF0000)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                             ' ' ' ' ' ')
                MONMSG     MSGID(CPF0000)
                DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
                MONMSG     MSGID(CPF0000)
       /*   *** AUS URSPRÜNGLICHER DATEI                                     */
       /*   *** SELECT KPFIRM, KPKDNR FROM KPIFTRANS GROUP BY KPFIRM,        */
       /*   *** KPKDNR                                                       */
       /*   *** DATEI SC_TOTAL IN TVRELWAECO WURDE ERSTELLT UND              */
       /*   *** BEINHALTET ALLE KUNDEN (SC'S)                                */
       /*   *** ÜBERNAHME IN KPIF                                            */
                CPYF       FROMFILE(TVRELWAECO/KPIFTRANS) +
                           TOFILE(TVRELWAECO/KPIFTRANS#) +
                           MBROPT(*ADD) CRTFILE(*NO)
                MONMSG     MSGID(CPF0000)
                CALL    PGM(DUMMY512) PARM(&MD 'SKU0013' ' ' ' ' +
                            'KPIFTRANS' 'TVRELWAECO' '*REPLACE')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(KPIFR)
             ENDDO
/*    _______________________________________________________________     */

/*    _HÜLLE_________________________________________________________     */
             IF         COND(&QDAYOFWEEK *NE '*SUN' *AND &QDAY < +
                          '99') THEN(DO)
       /*   *** BESTELLUNG/BESTELLDATEN                                      */
             CALL       PGM(DUMMY512) PARM(&MD '#ST0010' ' ' ' ' +
                             '#ST0010' 'QTEMP' '*ADD')
             MONMSG     MSGID(CPF0000)
/*                                                                            */
       /*   *** VERBINDUNG BESTELLDATEN ARTIKELDATEN                         */
             CALL       PGM(DUMMY512) PARM(&MD '#ST0011' ' ' ' ' +
                        '#ST0011' 'BAR_VERT' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*                                                                            */
       /*   *** INTEGRATION FEHLENDE ARTIKEL                                 */
             CALL       PGM(DUMMY512) PARM(&MD '#ST0012' ' ' ' ' +
                        '#ST0011' 'BAR_VERT' '*ADD')
             MONMSG     MSGID(CPF0000)
/*                                                                            */
             ENDDO
/*    _______________________________________________________________     */
/*    _CALL ANALYSESKU ______________________________________________     */
             IF         COND(&QDAYOFWEEK *NE '*SUN' *AND &QDAY < +
                          '99') THEN(DO)
       /*   *** AUSLAGERUNGEN ORDERINPUT                                     */
          /*    CALL       PGM(BAR_KALK/STR_KALK) PARM('0')  */
          /*    MONMSG     MSGID(CPF0000)                    */
                CALL       PGM(ANALYSESKU)
                MONMSG     MSGID(CPF0000)
                RTVMBRD    FILE(TVRELWAECO/ANALYSESKU) MBR(*FIRST) +
                           NBRCURRCD(&NBRCURRCD)
                MONMSG     MSGID(CPF0000)
                IF         COND(&NBRCURRCD *NE 0) THEN(DO)
                   RMVLNK     OBJLNK('/SALESCOMPANY/ANALYSESKU.CSV')
                   MONMSG     MSGID(CPF0000)
                   CVTDBF     OBJ('/SALESCOMPANY/ANALYSESKU.CSV') +
                              DBFILE(TVRELWAECO/ANALYSESKU) +
                              DBOUTFMT(*CSV) DBFLDDSC(*YES)
                   MONMSG     MSGID(CPF0000)
                   OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                              FORMTYPE('ANALYSESKU') OVRSCOPE(*JOB)
                   MONMSG     MSGID(CPF0000)
                   CALL  PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                               ' ' ' ' ' ')
                   MONMSG     MSGID(CPF0000)
                   DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
                   MONMSG     MSGID(CPF0000)
/*                                                                            */
                   RMVLNK     OBJLNK('/SALESCOMPANY/SKU_CHANGE.CSV')
                   MONMSG     MSGID(CPF0000)
                   CVTDBF     OBJ('/SALESCOMPANY/SKU_CHANGE.CSV') +
                              DBFILE(TVRELWAECO/SKU_CHANGE) +
                              DBOUTFMT(*CSV) DBFLDDSC(*YES)
                   MONMSG     MSGID(CPF0000)
/*                                                                            */
                ENDDO
             ENDDO

/*    _HÜLLE_________________________________________________________     */
             IF         COND(&QDAYOFWEEK *NE '*SUN' *AND &QDAY < +
                          '99') THEN(DO)
       /*   *** AUSLAGERUNGEN ORDERINPUT                                     */
       /*       CALL       PGM(SWAPC)           */
       /*       MONMSG     MSGID(CPF0000)       */
/*                                                                            */
             ENDDO
/*    _HÜLLE_________________________________________________________     */
             IF         COND(&QDAYOFWEEK *NE '*SUN' *AND &QDAY < +
                          '07') THEN(DO)
       /*   *** IDCO DATEN ERMITTELN FÜR PROZESSE                            */
                        CALL       PGM(GANG/IDCOC) PARM('1')
              /*        CALL       PGM(IDCOUPDR)             */
                        MONMSG     MSGID(CPF0000)
             ENDDO
/*    _______________________________________________________________     */
/*                                                                            */
/*    _HÜLLE_________________________________________________________     */
       /*   *** ÜBERGABE ABC KENNZEICHEN IN WIN FÜR ELPS                     */
       /*   *** ZEITFENSTER WIRD DIREKT IM PROGRAMM DEFINIERT!               */
       /*   *** ACHTUNG AUSGELAGERT IN JOB_R   14.03.2016                    */
       /*       CALL       PGM(#ABCUPDATE)                                    */
       /*       MONMSG     MSGID(CPF0000)                                     */
/*                                                                            */
/*    _______________________________________________________________     */
/*                                                                            */
/*                                                                            */
/*    _HÜLLE_________________________________________________________     */
       /*   *** AUSGABE FÜR HENK GELUWE WOCHENREPORT                         */
             IF         COND(&QDAYOFWEEK *EQ '*MON' *AND &QDAY < +
                          '99') THEN(DO)
       /*       CALL       PGM(HENKR)                                    */
       /*       MONMSG     MSGID(CPF0000)                                */
       /*       OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +       */
       /*              FORMTYPE('HENKR    ') OVRSCOPE(*JOB)              */
       /*       MONMSG     MSGID(CPF0000)                                */
       /*       CALL     PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +  */
       /*                    ' ' ' ' ' ')                                */
       /*       MONMSG     MSGID(CPF0000)                                */
       /*       DLTOVR     FILE(QPQXPRTF) LVL(*JOB)                      */
       /*       MONMSG     MSGID(CPF0000)                                */
             ENDDO
/*                                                                            */
/*    _______________________________________________________________     */
/*                                                                            */
/*                                                                            */
/*    _JALIX_CRM_____________________________________________________     */
       /*   *** AUSGABE FÜR NICLAS PANNEWUIN JALIX_CRM                       */
             IF         COND(&QDAYOFWEEK *NE '*SAT' *AND &QDAY < +
                          '99') THEN(DO)
        /*      CALL       PGM(CRMOUTPUTR)          28.04.2023*/
        /*      MONMSG     MSGID(CPF0000)           28.04.2023*/
        /*      CALL       PGM(JALIX_CRMR)          */
        /*      MONMSG     MSGID(CPF0000)           */
                OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                       FORMTYPE('JALIX_CRMR') OVRSCOPE(*JOB)
                MONMSG     MSGID(CPF0000)
        /*      CALL     PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' + */
        /*                   ' ' ' ' ' ')                               */
                MONMSG     MSGID(CPF0000)
                DLTOVR     FILE(QPQXPRTF) LVL(*JOB)
                MONMSG     MSGID(CPF0000)
       /*      *** REL1.0 NEU ABGESTIMMTE VERSION AUFGRUND DER GRÖSSE KEIN MAIL*/
             ENDDO
/*                                                                            */
/*    _RPMCUSTOMERS__________________________________________________     */
       /*   *** AUSGABE FÜR RPM ALLE CUSTOMERS                               */
             IF         COND(&QDAYOFWEEK *EQ '*FRI' *AND &QDAY < +
                          '99') THEN(DO)
                CALL       PGM(RPMCUSTOM)
                MONMSG     MSGID(CPF0000)
             ENDDO
/*                                                                            */
/*                                                                            */
/*    _SAV_LIBRM_____________________________________________________     */
       /*   *** AUSGABE FÜR ..........................                       */
             IF         COND(&QDAYOFWEEK *EQ '*FRI' *AND &QDAY < +
                          '99') THEN(DO)
/*              CRTSAVF    FILE(#GANG/GANG) TEXT('SICHERUNG ')     */
/*              MONMSG     MSGID(CPF0000)                          */
/*              SAVLIB     LIB(DOMGEN) DEV(*SAVF)              +   */
/*                  SAVF(#GANG/GANG) SAVACT(*SYNCLIB)          +   */
/*                  SAVACTWAIT(120) ACCPTH(*YES)               +   */
/*                  OUTPUT(*OUTFILE)                           +   */
/*                  OUTFILE(SAVEFILE/SAVE_ELPS) OUTMBR(*FIRST  +   */
/*                  *ADD)                                          */
/*              MONMSG     MSGID(CPF0000)                          */
/*  CPY OBJ('/QSYS.LIB/#gang.LIB/gang.FILE') TODIR('/home/gang')   */
/*                                                                 */
/*              MONMSG     MSGID(CPF0000)                          */
/*              CRTSAVF    FILE(#GANG/GANG) TEXT('SICHERUNG ')     */
/*              MONMSG     MSGID(CPF0000)                          */
/*              SAVLIB     LIB(DOMGEN) DEV(*SAVF)              +   */
/*                  SAVF(#GANG/GANG) SAVACT(*SYNCLIB)          +   */
/*                  SAVACTWAIT(120) ACCPTH(*YES)               +   */
/*                  OUTPUT(*OUTFILE)                           +   */
/*                  OUTFILE(SAVEFILE/SAVE_ELPS) OUTMBR(*FIRST  +   */
/*                  *ADD)                                          */
/*              MONMSG     MSGID(CPF0000)                          */
             ENDDO
/*                                                                            */
/*    _STARTEN DER LFS SUBSYTEME + HINTERGRUNDJOBS __________________     */
       /*   *** STARTEN DER LFS SUBSYTEME + HINTERGRUNDJOBS                  */
             IF         COND(&QDAYOFWEEK *EQ '*MON' *AND &QDAY < +
                          '99') THEN(DO)
                SBMJOB CMD(CALL PGM(DOMPGMV7/LGPGM0020) PARM('BATSTR'))
                MONMSG     MSGID(CPF0000)
        /* und für die Testumgebung */
                SBMJOB     CMD(CALL PGM(TSTPGMV7/LGPGM0020) PARM('BATSTR'))
                MONMSG     MSGID(CPF0000)
             ENDDO
/*                                                                            */
/*                                                                            */
/*    _______________________________________________________________     */
/*                                                                            */

 ENDPGM:
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

     /*      DSPJOBLOG  OUTPUT(*PRINT)                */

             ENDPGM
