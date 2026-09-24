/*    * PROGRAMMNAME.:$INTERFACE                                             */
/*    * FUNKTION.....:...                                                    */
/*    * JULI    2010   GANG, MANFRED                                          */
/*    *                                                                       */
/*    *-DER JOB IST RESTARTFÄHIG                                             */
/*    * $INTERFACE                                                           */
/*    *  CHGDTAARA DTAARA(TVRELWAECO/$INTERFACE *ALL) VALUE('0')              */
/*    *  DSPDTAARA DTAARA(TVRELWAECO/$INTERFACE)                              */
/*    *  0 BEDEUTET NICHT AKTIV 1 BEDEUTET AKTIV                              */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM

             DCL        VAR(&CODE)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&DONE) TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&RUN) TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&QTIME)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&$INTERFACE) TYPE(*CHAR) LEN(01)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('$INTERFACE')
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

             CALL       PGM(DUMMY512) PARM(&MD '#TR0050' ' ' ' ' ' ' +
                          ' ' ' ')
             MONMSG     MSGID(CPF0000)

             CALL  PGM(DUMMY512) PARM(&MD '#DC0008' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)

             RGZPFM FILE($INTERFACE)
             MONMSG     MSGID(CPF0000)

             RGZPFM FILE(JOB_RUN)
             MONMSG     MSGID(CPF0000)

             CALL PGM(TVRELWAECO/#JOBS) PARM()
             MONMSG     MSGID(CPF0000)


 LOOP:       RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&QTIME)

    /*       IF         COND(&QTIME *GT '185500') THEN(GOTO +    */
             IF         COND(&QTIME *GT '190500') THEN(GOTO +
                          CMDLBL(ENDPGM))

       /*    RUN WIEDER RAUSNEHMEN                ......................*/
       /*          CHGVAR     VAR(&RUN) VALUE('1')......................*/
             IF         COND(&QTIME *GT '064000') THEN(DO)
                IF         COND(&RUN *EQ '0') THEN(DO)
/*                - STATISTIK                                                */
                   IF         COND(&QTIME *LT '080000') THEN(DO)
                      CALL       PGM(ABSATZC)
                      MONMSG     MSGID(CPF0000)
                   ENDDO
/*                - VERLÄNGERUNG ABGELAUFENER                                */
/*                  ICS PREISE (073) UM 10 TAGE                              */
                   CALL       PGM(PREISE4_C) PARM('1')
                   MONMSG     MSGID(CPF0000)

/*                - MELDUNG UNZUREICHENDER EINTRAG IM ARTIKELSTAMM           */
/*                - UND MELDUNG PER MAIL                                     */
                   CALL       PGM(ITEMCHECKC)
                   MONMSG     MSGID(CPF0000)

/*                - VNOTES DATENBANK AKTUALISIEREN                           */
                   CALL  PGM(DUMMY512) PARM(&MD '#LO5000' ' ' ' ' +
                          'ARTNOTES' 'LOTUS' '*REPLACE')

             MONMSG     MSGID(CPF0000)
/*                -RPMII DATENKONVERTIERUNG                                  */
/*                -RPMII AUSGEGLIEDERT 2013.05.10                            */
             /*    CALL       PGM(RPMIIC)       */
             /*    MONMSG     MSGID(CPF0000)    */
                   CHGVAR     VAR(&RUN) VALUE('1')
                   MONMSG     MSGID(CPF0000)
                ENDDO
             ENDDO

 /*          DSPJOBLOG  OUTPUT(*OUTFILE) +                 */
 /*                       OUTFILE(TVRELWAECO/$INTERFACE) + */
 /*                       OUTMBR(*FIRST *ADD)              */
 /*          MONMSG     MSGID(CPF0000)                     */
             CALL       PGM(DUMMY512) PARM(&MD '#JC1000' ' ' ' ' ' ' +
                          ' ' ' ')
             MONMSG     MSGID(CPF0000)

/*   -INTERFACE STOPPEN PER PARAMETER AKTIV(1), INAKTIV(0)                   */
             RTVDTAARA  DTAARA(TVRELWAECO/$INTERFACE *ALL) +
                          RTNVAR(&$INTERFACE)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                 GOTO       CMDLBL(ENDPGM)
             ENDDO

/*   -ENDEBEDINGUNG  $INTERFACE = '0'                                        */
             IF         COND(&$INTERFACE *EQ '0') THEN(DO)
                 GOTO       CMDLBL(ENDPGM)
             ENDDO

/*   -AUFRUF ....                                                            */
             IF         COND(&QTIME *GT '183000') THEN(DO)
/*             -PART INVOICES OVER FTP                                       */
                CALL PGM(TVRELWAECO/SC08138_C) PARM('1')
                MONMSG     MSGID(CPF0000)
                CALL PGM(TVRELWAECO/SC88505_C) PARM('1')
                MONMSG     MSGID(CPF0000)
                CALL PGM(TVRELWAECO/SC40631_C) PARM('1')
                MONMSG     MSGID(CPF0000)
                CALL PGM(TVRELWAECO/SC01887_C) PARM('1')
                MONMSG     MSGID(CPF0000)
                CALL PGM(TVRELWAECO/SC05084_C) PARM('1')
                MONMSG     MSGID(CPF0000)
                CALL PGM(TVRELWAECO/SC55278_C) PARM('1')
                MONMSG     MSGID(CPF0000)
                CALL PGM(TVRELWAECO/SC15177_C) PARM('1')
                MONMSG     MSGID(CPF0000)
                CALL PGM(TVRELWAECO/SC62765_C) PARM('1')
                MONMSG     MSGID(CPF0000)
                CALL PGM(TVRELWAECO/SC98264_C) PARM('1')
                MONMSG     MSGID(CPF0000)
                CALL PGM(TVRELWAECO/SC78678_C) PARM('1')
                MONMSG     MSGID(CPF0000)
                CALL PGM(TVRELWAECO/SC78680_C) PARM('1')
                MONMSG     MSGID(CPF0000)
                CALL PGM(TVRELWAECO/SC42634_C) PARM('1')
                MONMSG     MSGID(CPF0000)
/*             -AUFRUF MESSAGES CONFIRMATION DAILY                           */
                CALL       PGM(TVRELWAECO/MESSAGE_SC) PARM('15177' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/MESSAGE_SC) PARM('01887' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/MESSAGE_SC) PARM('78146' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/MESSAGE_SC) PARM('62765' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/MESSAGE_SC) PARM('98264' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/MESSAGE_SC) PARM('05084' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
     /*   CALL       PGM(TVRELWAECO/MESSAGE_SC) PARM('08138' +  */
     /*              '20110111' '2')                            */
     /*   MONMSG     MSGID(CPF0000)                             */
/*                                                             */
/*             -AUFRUF INVOICES FÜR MAILS (CSV-DATEI)                        */
/*             -RESTART BEI ABBRUCH IM FORFELD BARENKAMP                     */
/*      1      -CHGDTAARA DTAARA(ABDATUM) VALUE('20120120')BARENKAMP         */
/*      2      -CALL QCMD                                  BARENKAMP         */
/*      3      -PGM'S KOPIEREN OHNE + ZEICHEN              BARENKAMP         */
/*      4      -CHGDTAARA DTAARA(ABDATUM) VALUE('        ')BARENKAMP         */
                CALL       PGM(TVRELWAECO/DELIVER_SC) PARM('40631' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/DELIVER_SC) PARM('54939' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/DELIVER_SC) PARM('62765' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/DELIVER_SC) PARM('02921' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/DELIVER_SC) PARM('01887' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/DELIVER_SC) PARM('78146' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/DELIVER_SC) PARM('05084' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/DELIVER_SC) PARM('88505' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/DELIVER_SC) PARM('55278' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/DELIVER_SC) PARM('15177' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/DELIVER_SC) PARM('42634' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/DELIVER_SC) PARM('08138' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
/*             -AUFRUF FORWARDER INFORMATIONPER MAIL SV-DATEI)               */
                CALL PGM(TVRELWAECO/FORWARD_SC) PARM( '40631' '' '2')
                MONMSG     MSGID(CPF0000)


/*             -PART INVOICES TECHNO OVER FTP                                */
                CALL       PGM(TVRELWAECO/TE11016_C) PARM('1')
                MONMSG     MSGID(CPF0000)

/*             -PART INVOICES CLIFFORDTHAMES (SFTP)  FORD                    */
                CALL       PGM(TVRELWAECO/CT007260_C) PARM('1')
                MONMSG     MSGID(CPF0000)

/*             -PART INVOICES CLIFFORDTHAMES (SFTP)  MOBISPART               */
                CALL       PGM(TVRELWAECO/CT190629_C) PARM('1')
                MONMSG     MSGID(CPF0000)

/*             -PART INVOICES MOBISPART NEU 1.1.2014                         */
                CALL       PGM(TVRELWAECO/TEMOBIS_C) PARM('1')
                MONMSG     MSGID(CPF0000)

/*             -PART INVOICES HDX                                            */
                CALL       PGM(TVRELWAECO/HDX0000_C)
                MONMSG     MSGID(CPF0000)

/*             -IDCO MELDUNGEN AUSGELAGERT IN #JOBS  02.10.2014              */
          /*    CALL       PGM(GANG/IDCOC) PARM('1')  */
          /*    MONMSG     MSGID(CPF0000)             */

                GOTO       CMDLBL(ENDPGM)
             ENDDO

/*          -AUFRUF MESSAGES CONFIRMATION DAILY                              */
             IF      COND(&QTIME *GT '163000' *AND &DONE *EQ '0') +
                          THEN(DO)
                CHGVAR     VAR(&DONE) VALUE('1')
                CALL       PGM(TVRELWAECO/MESSAGE_SC) PARM('88505' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/MESSAGE_SC) PARM('40631' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/MESSAGE_SC) PARM('78678' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/MESSAGE_SC) PARM('54939' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/MESSAGE_SC) PARM('55278' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(JISINVOICE)
                MONMSG     MSGID(CPF0000)
             ENDDO

/*          -ABRÄUMEN DER ORDER                                              */
             CALL PGM(TVRELWAECO/ORDERNAV_C)
             MONMSG     MSGID(CPF0000)

/*          -ABRÄUMEN DER ORDER FÜR SUNSHINE                                 */
/*           CALL       PGM(TVRELWAECO/SUNSHINE_C) PARM('1')  STOP 28.5.21    */
/*           MONMSG     MSGID(CPF0000)                        STOP 28.5.21    */

/*          -BESTANDSERMITTLUNGEN FÜR FTP - FOLGEJOBS                        */
/*          -EIGENER JOB AB 7.5.2012                                         */
   /*        CALL PGM(TVRELWAECO/ABESTAND_C)                */
   /*        MONMSG     MSGID(CPF0000)                      */

             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&QTIME)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA($INTEQTIME) VALUE(&QTIME)
             MONMSG     MSGID(CPF0000)
             DLYJOB     DLY(009)
  /*         DSPJOBLOG  OUTPUT(*OUTFILE) +                   */
  /*                      OUTFILE(TVRELWAECO/$INTERFACE) +   */
  /*                      OUTMBR(*FIRST *ADD)                */
  /*         MONMSG     MSGID(CPF0000)                       */
             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)

             CALL       PGM(DUMMY512) PARM(&MD '#JC1000' ' ' ' ' ' ' +
                          ' ' ' ')
             MONMSG     MSGID(CPF0000)

             GOTO       CMDLBL(LOOP)

 ENDPGM:

/*          -STATISTIK, ERNEUTE DATENAUFBEREITUNG                            */
             CHGDTAARA  DTAARA(TVRELWAECO/ABSATZR) VALUE('SR40631')
             CALL       PGM(ABSATZC)
             MONMSG     MSGID(CPF0000)
/*          -AUFRUF FORWARDER INFORMATIONPER MAIL SV-DATEI                   */
             CALL PGM(TVRELWAECO/FORWARD_SC) PARM( '40631' '' '2')
             MONMSG     MSGID(CPF0000)

/*          -STATISTIK, ERNEUTE DATENAUFBEREITUNG                            */
             CHGDTAARA  DTAARA(TVRELWAECO/ABSATZR) VALUE('SR08138')
             CALL       PGM(ABSATZC)
             MONMSG     MSGID(CPF0000)
/*          -AUFRUF FORWARDER INFORMATIONPER MAIL SV-DATEI                   */
             CALL PGM(TVRELWAECO/FORWARD_SC) PARM( '08138' '' '2')
             MONMSG     MSGID(CPF0000)

/*          -STATISTIK, ERNEUTE DATENAUFBEREITUNG                            */
             CHGDTAARA  DTAARA(TVRELWAECO/ABSATZR) VALUE('SR55278')
             CALL       PGM(ABSATZC)
             MONMSG     MSGID(CPF0000)
/*          -AUFRUF FORWARDER INFORMATIONPER MAIL SV-DATEI                   */
             CALL PGM(TVRELWAECO/FORWARD_SC) PARM( '55278' '' '2')
             MONMSG     MSGID(CPF0000)

             CHGDTAARA DTAARA(TVRELWAECO/ABSATZR) VALUE('       ')
             MONMSG     MSGID(CPF0000)

/*          -MITTEILUNG ÜBER GEÄNDERTE LIEFERTERMINE AN SC'S                 */
             CALL       PGM(CONFIRM4)
             MONMSG     MSGID(CPF0000)

/*          -CONRAD RECHNUNGEN                                               */
/*          -ACHTUNG AM ENDE LAUFEN LASSEN, DIESES PGM ZERSTÖRT DAS          */
/*           ENVIRNONMENT                                                    */

             CALL       PGM(*LIBL/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          '          ' '006016')

             CALL       PGM(*LIBL/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          '          ' '009202')

             RCLRSC
             MONMSG     MSGID(CPF0000)
   /*        DSPJOBLOG  OUTPUT(*OUTFILE) +                     */
   /*                     OUTFILE(TVRELWAECO/$INTERFACE) +     */
   /*                     OUTMBR(*FIRST *ADD)                  */
   /*        MONMSG     MSGID(CPF0000)                         */
             CALL       PGM(DUMMY512) PARM(&MD '#JC1000' ' ' ' ' ' ' +
                          ' ' ' ')
             MONMSG     MSGID(CPF0000)

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(TVRELWAECO) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)
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
