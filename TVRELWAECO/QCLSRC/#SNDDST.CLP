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
             DCL        VAR(&QDAY)  TYPE(*CHAR) LEN(02)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)
             DCL        VAR(&NBRCURRCD)  TYPE(*DEC) LEN(10 0)

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

             IF         COND(&QDAYOFWEEK = '*WED' *AND &QDAY < '03') +
                          THEN(DO)
       /*   *** STK3                                                         */
       /*    CALL    PGM(DUMMY512) PARM(&MD 'STK1000' ' ' ' ' +     */
       /*                ' ' ' ' ' ')                               */
       /*    MONMSG     MSGID(CPF0000)                              */
/*                                                                            */
             ENDDO

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
