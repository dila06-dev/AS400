/*    * PROGRAMMNAME.:SICHERUNG                                              */
/*    *       HINWEIS:SUBR36/SCHILLING                                       */
/*    *               MONATSENDEDEFINITION:                                  */
/*    *               MONATSENDE BEDEUTET HIER DER LETZE TAG EINES           */
/*    *               MONATS, DIESES BEDEUTET BEISPIELSWEISE, DASS           */
/*    *               AM 30.03.2007(FREITAG) DAS MONATSENDEBAND              */
/*    *               EINGELEGT WERDEN MUSS. DIE NACHTSICHERUNG              */
/*    *               ERFOLGT MIT *REWIND. AM 31.03.2007 WIRD IN             */
/*    *               DER NACHTSICHERUNG(UNABHÄNGIG VOM TAG) DIE             */
/*    *               MONATSSICHERUNG AUF DIESES BAND DURCHGEFÜHRT           */
/*    *               UND ARCHIVIERT.                                        */
/*    *               ----                                                   */
/*    *                  WENN PARAMETER = 0, DANN KEINE VERABEITUNG          */
/*    *                  WIE TAGESABSCHLUß ETC.                              */
/*    *                  WENN PARAMETER = 1, DANN       VERABEITUNG          */
/*    *                  WIE TAGESABSCHLUß ETC.                              */
/*    *               SUBR36/SAVE_TIM                                        */
/*    *                  WENN PARAMETER = 0, DANN KEIN AUFBAU                */
/*    *                  DER AKTUALISIERUNG TESTENV.+SAVEFILES               */
/*    *                  WENN PARAMETER = 1, DANN      AUFBAU                */
/*    *                  DER AKTUALISIERUNG TESTENV.+SAVEFILES               */
/*    *               SUBR36/PSEUDOMON                                       */
/*    *                  WENN PARAMETER = 0, DANN KEIN ERZWINGEN             */
/*    *                  DER MONATSSICHERUNG + FOLGEJOBS                     */
/*    *                  WENN PARAMETER = 1, DANN ERZWINGEN                  */
/*    *                  DER MONATSSICHERUNG + FOLGEJOBS                     */
/*    *               SUBR36/ENDSYSTEM                                       */
/*    *                  WENN PARAMETER = 0, DANN KEIN HERUNTER-             */
/*    *                  FAHREN DER SERVER/SUBSYSTEME ETC.                   */
/*    *                  WENN PARAMETER = 1, DANN HERUNTERFAHREN             */
/*    *                  DER SERVER/SUBSYSTEME ETC.                          */
/*    * FUNKTION.....:SICHERUNGSAUFRUF UND FOLGEVERARBEITUNG                 */
/*    *               AUFRUFROUTINEN:                                        */
/*    *               1.) AUFBAU DER TESTUMGEBUNGEN UND SICHERUNG            */
/*    *                   ( PROTOKOLLDATEI BEFINDET SICH IN                  */
/*    *                     SUBR36/SAVE_TIM UND WIRD MIT STANDARD-           */
/*    *                     SICHERUNG MITGESICHERT)                          */
/*    *                     CLRPFM ERFOLGT AM MONATSENDE NACH                */
/*    *                     SICHERUNG                                        */
/*    *               2.) SICHERUNG DER LIBS MIT *ALLUSR                     */
/*    *                   DERZEITIGE AUSNAHMEN BEI DER SICHERUNG             */
/*    *                   1.) PROTOKOLLDATEI FÜR SICHERUNG                   */
/*    *                       SUBR36/SICHERUNG                               */
/*    *                   2.) BIBLIOTHEK: SAVEFILE (SICHERUNGEN AUF          */
/*    *                       PLATTE)                                        */
/*    *                       DIE BIBLIOTHEK SAVEFILE WIRD NUR ZUM           */
/*    *                       MONATSENDE (LETZTER TAG IM MONAT)              */
/*    *                       GESICHERT                                      */
/*    *               3.) PROTOKOLL AM MONATSENDETAG                         */
/*    *                   PROTOKOLLDATEI: QGPL/DSPOBJD#                      */
/*    *               4.) AUFRUF SCHILLING TAGESABSCHLUß, WENN               */
/*    *                   PARAMETER SCHILLING = 1                            */
/*    *               5.) AUFBAU ARCHIVJOBS                                  */
/*    *               6.) SICHERUNG DER SICHERUNGSDATEI SICHERUNG            */
/*    *                   IN DIE DATEI SICHERUNG# UND LÖSCHEN DER            */
/*    *                   AUFGELAUFENEN SAVFILE D_, L_ ZUM                   */
/*    *                   M O N A T S E N D E                                */
/*    *                   HINWEIS: DA AUF SICHUNGSDATUM ABGEFRAGT_           */
/*    *                   WIRD, DER JOB DERZEIT UM 22:00UHR IN DAS           */
/*    *                   SYSTEM ÜBERGEBEN WIRD, SOLLTE DIE TAT-             */
/*    *                   SÄCHLICHE SICHERUNG NICHT ÜBER DEN TAGES-          */
/*    *                   WEHSEL LIEGEN. IM ANDEREN FALL AUF                 */
/*    *                   DATENTRÄGER ABFRAGEN IN SAV0001 ODER ZEIT-         */
/*    *                   FENSTER VORZIEHEN. SIEHE JOBPROTOKOLL UND          */
/*    *                   SPOOLS. NACH TATSÄCHLICHER SICHERUNG ER-           */
/*    *                   FOLGT MELDUNG AUF HANDY.                           */
/*    *                   (ODSDAT IN DSPOBJD# ENSPRICHT Z.B. 013107          */
/*    *                   FÜR JANUAR 31012007 )                              */
/*    *               7.) PRINT JOBLOG MIT BENUTZERDATEN JJJJMMTT            */
/*    *                                                                       */
/*    * 01/2007        MANFRED GANG                                           */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM
             DCL        VAR(&##DAT)     TYPE(*CHAR) LEN(08)
             DCL        VAR(&##LND)     TYPE(*DEC)  LEN(1 0)
             DCL        VAR(&##ATAG)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&##FTAG)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&##WOTAG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&##FEIERT)  TYPE(*CHAR) LEN(25)
             DCL        VAR(&##WOCHE)   TYPE(*DEC)  LEN(2 0)
             DCL        VAR(&##LFDKTAG) TYPE(*DEC)  LEN(3 0)
             DCL        VAR(&##LFDATAG) TYPE(*DEC)  LEN(3 0)
             DCL        VAR(&CODE)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT)       TYPE(*CHAR) LEN(10)
             DCL        VAR(&CTL)       TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&DATMOD)    TYPE(*CHAR) LEN(5)
             DCL        VAR(&RTNCOD)    TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&SYSGES)    TYPE(*CHAR) LEN(26)
             DCL        VAR(&SYSDAT)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&SYSZEI)    TYPE(*CHAR) LEN(8)
             DCL        VAR(&NEWVOL)    TYPE(*CHAR) LEN(06)
             DCL        VAR(&NEWOWNID)  TYPE(*CHAR) LEN(14)
             DCL        VAR(&GSMMSG)    TYPE(*CHAR) LEN(160)
             DCL        VAR(&SWITCH)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&MONATENDE) TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&ENDOPT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&SICHERPER) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SCHILLING) TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&SAVE_TIM)  TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&PSEUDOMON) TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&ENDSYSTEM) TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&SAVESTATUS) TYPE(*CHAR) LEN(80)
             DCLF FILE(SUBR36/SAV0003)

             CHGVAR     VAR(&SAVESTATUS) VALUE('Sicherungsjob aktiv: +
                          Initialisierungsbeginn')
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(SUBR36/SAVESTATUS) VALUE(&SAVESTATUS)
             MONMSG     MSGID(CPF0000)

             CHGJOB     RUNPTY(19)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(SICHERPER) VALUE('1')
             MONMSG     MSGID(CPF0000)
             RTVDTAARA  DTAARA(SUBR36/SCHILLING) RTNVAR(&SCHILLING)
             MONMSG     MSGID(CPF0000)
             RTVDTAARA  DTAARA(SUBR36/SAVE_TIM)  RTNVAR(&SAVE_TIM)
             MONMSG     MSGID(CPF0000)
             RTVDTAARA  DTAARA(SUBR36/PSEUDOMON) RTNVAR(&PSEUDOMON)
             MONMSG     MSGID(CPF0000)
             RTVDTAARA  DTAARA(SUBR36/ENDSYSTEM) RTNVAR(&ENDSYSTEM)
             MONMSG     MSGID(CPF0000)
/*----------------------------------------------------------------------------*/
/*    *     SYSGES: 20050322090226                                           */
/*    *     SYSDAT: 20050322                                                 */
/*    *     SYSZEI: 090226                                                   */
             CHGVAR     VAR(&DATMOD) VALUE('*JMT4')
             CALL       PGM(SUBR36/#DATAKTR) PARM(&DATMOD &RTNCOD +
                          &SYSGES &SYSDAT &SYSZEI)
             CHGVAR     VAR(%SST(&NEWVOL 01 06)) VALUE(%SST(&SYSDAT +
                          03 06))
             CHGVAR     VAR(%SST(&GSMMSG 01 43)) VALUE('WAECO400 +
                          Sicherung abgebrochen, kein INZTAP ')
             CHGVAR     VAR(%SST(&GSMMSG 45 08)) VALUE(&SYSDAT)
/*    *     ##DAT    :                                                       */
/*    *     ##LND    :                                                       */
/*    *     ##ATAG   :                                                       */
/*    *     ##FTAG   :                                                       */
/*    *     ##WOTAG  :                                                       */
/*    *     ##FEIERT :                                                       */
/*    *     ##WOCHE  :                                                       */
/*    *     ##LFDKTAG:                                                       */
/*    *     ##LFDATAG:                                                       */
             CALL       PGM(#DRDATINF) PARM(&##DAT &##LND &##ATAG +
                          &##FTAG &##WOTAG &##FEIERT &##WOCHE +
                          &##LFDKTAG &##LFDATAG)

             CHGVAR     VAR(%SST(&NEWOWNID 01 03)) +
                          VALUE(%SST(&##WOTAG 01 03))
             CHGVAR     VAR(%SST(&NEWOWNID 05 08)) VALUE(&SYSDAT)

/*    *     STANDARD *UNLOAD AUSNAHMEN MIT *REWIND, DA FÜR DEN               */
/*    *     MONATSABSCHLUß AM FOLGETAG DAS BAND FÜR DIE MONATS-              */
/*    *     SICHERUNG BENÖTIGT WIRD                                          */
             CHGVAR     VAR(&ENDOPT) VALUE('*UNLOAD')
             IF         COND( %SST(&SYSDAT 1 8) *EQ '20070330'  +
                        *OR   %SST(&SYSDAT 1 8) *EQ '20070629'  +
                        *OR   %SST(&SYSDAT 1 8) *EQ '20070928'  +
                        *OR   %SST(&SYSDAT 1 8) *EQ '20071228') +
                          THEN(DO)
/*    *     BAND NICHT AUF UNLOAD SETZEN FÜR FOLGE TAG, WO                   */
/*    *     MONATSSICHERUNG ERFOLGT                                          */
                CHGVAR     VAR(&ENDOPT) VALUE('*REWIND')
             ENDDO

/*    *     MONATSSICHERUNGSTAGE                                             */
             IF         COND( %SST(&SYSDAT 5 4) *EQ '0131'  +
                        *OR   %SST(&SYSDAT 1 8) *EQ '20070228'  +
                        *OR   %SST(&SYSDAT 5 4) *EQ '0331'  +
                        *OR   %SST(&SYSDAT 5 4) *EQ '0430'  +
                        *OR   %SST(&SYSDAT 5 4) *EQ '0531'  +
                        *OR   %SST(&SYSDAT 5 4) *EQ '0630'  +
                        *OR   %SST(&SYSDAT 5 4) *EQ '0731'  +
                        *OR   %SST(&SYSDAT 5 4) *EQ '0830'  +
                        *OR   %SST(&SYSDAT 5 4) *EQ '0930'  +
                        *OR   %SST(&SYSDAT 5 4) *EQ '1031'  +
                        *OR   %SST(&SYSDAT 5 4) *EQ '1130'  +
                        *OR   %SST(&SYSDAT 5 4) *EQ '1231') +
                          THEN(DO)
                CHGVAR     VAR(&MONATENDE) VALUE('1')
                GOTO       CMDLBL(START)
             ENDDO
             IF         COND(&##WOTAG *EQ 'Samstag   ' *OR &##WOTAG +
                          *EQ 'Sonntag   ') THEN(DO)
                GOTO       CMDLBL(ENDPGM)
             ENDDO

 START:

/*----------------------------------------------------------------------------*/

             CHGVAR     VAR(&SAVESTATUS) VALUE('Sicherungsjob aktiv: +
                          -------- um ------ ')
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(%SST(&SAVESTATUS 22 08)) VALUE(&SYSDAT)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(%SST(&SAVESTATUS 34 06)) VALUE(&SYSZEI)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(SUBR36/SAVESTATUS) VALUE(&SAVESTATUS)
             MONMSG     MSGID(CPF0000)

/*    *     SCHILLING                                                        */
             IF         COND(&SCHILLING *EQ '1') THEN(DO)
    /*       PRÜFEN DAß KEIN JOB IN SASBATCH AKTIV, SONST WARTEN   */
                CHGVAR     VAR(%SST(&SAVESTATUS 41 40)) +
                          VALUE('Schilling Verarbeitung +
                          Vorlauf          ')
                MONMSG     MSGID(CPF0000)
                CHGDTAARA  DTAARA(SUBR36/SAVESTATUS) VALUE(&SAVESTATUS)
                MONMSG     MSGID(CPF0000)

 JOB:           CALL       PGM(SUBR36/#SASBATCH) PARM(&CODE)
                MONMSG     MSGID(CPF0000)
                IF         COND(&CODE *NE '0') THEN(DO)
                   DLYJOB     DLY(20)
                   GOTO       CMDLBL(JOB)
                ENDDO

    /*          PRÜFEN DAß KEIN JOB INTERAKTIV IST                   */
                CALL       PGM(SUBR36/#ENDINTERC)
                MONMSG     MSGID(CPF0000)

    /*          BATCHLAUF FÜR STAMMDATENAKTUALISIEREN IN SCHILLING   */
    /*          JOB MUß VOR DER SICHERUNG LAUFEN                     */
    /*          JOB IST RESTARTFÄHIG UND KÖNNTE ABGEBROCHEN WERDEN   */
    /*          HINTERGRUNDPROGRAMME                                 */
    /*          IN SFB (FDIABUCH,FDIAKORE,FDIAANBU) WERDEN GESTOPPT  */

                CALL       PGM(SFB/FDIASTOP) PARM('SFB' ' ')
                MONMSG     MSGID(CPF0000)
                DLYJOB     DLY(45)
             ENDDO
/*----------------------------------------------------------------------------*/
/*-SICHERUNGSFILES IN SAVEFILE GENERIEREN-------------------------------------*/
/*-SICHERUNG AUF BAND---------------------------------------------------------*/
/*-SOLLTEN FEHLER GEMELDET WERDEN, LIEGT KEINE VOLLSTÄNDIGE SICHERUNG  -------*/
/* VOR. NUR DAS OBJEKT SICHERUNG IN LIB SUBR36F CHARAKTER *FILE BILDET -------*/
/* DIE AUSNAHME UND ENTSPRICHT DEM PROTOKOLL                           -------*/
/* DER SCHALTER SWITCH MUSS AUF 0 STEHEN, ANSONSTEN IM POROTOKOLL      -------*/
/* DIE SÄTZE ANZEIGEN LASSEN, DIE IM SQL WIE FOLGT ANGEZEIGT WERDEN:   -------*/
/*     SELECT * FROM SICHERUNG WHERE SROSTA = '0'                      -------*/
/*     * SIEHE AUCH FEHLERMESSAGE IN DATEI                             -------*/
/* AUSNAHMEN IN DER SICHERUNG: 1.) PROTOKOLLDATEI                      -------*/
/*                             2.) OBJECT/*LIB   SAVEFILE/*LIB         -------*/
/*----------------------------------------------------------------------------*/
             IF         COND(&ENDSYSTEM *EQ '1') THEN(DO)
                CHGVAR     VAR(%SST(&SAVESTATUS 41 40)) +
                             VALUE('Subsysteme beenden/Server +
                             abfahren      ')
                MONMSG     MSGID(CPF0000)
                CHGDTAARA  DTAARA(SUBR36/SAVESTATUS) VALUE(&SAVESTATUS)
                MONMSG     MSGID(CPF0000)
                ENDSBS     SBS(AUTO_FORM) OPTION(*IMMED)
                MONMSG     MSGID(CPF0000)
                EFS/ENDTCPCMN
                MONMSG     MSGID(CPF0000)
                EFS/ENDMDASVR
                MONMSG     MSGID(CPF0000)
                DLYJOB     DLY(05)
                MONMSG     MSGID(CPF0000)
             ENDDO

             IF         COND(&PSEUDOMON *EQ '1') THEN(DO)
                CHGVAR     VAR(&MONATENDE) VALUE('1')
                MONMSG     MSGID(CPF0000)
             ENDDO

             CLRPFM     FILE(SUBR36/SICHERUNG)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(SUBR36/SAVCFG)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(SUBR36/SAVSECDTA)
             MONMSG     MSGID(CPF0000)

/*    *     SAVE_TIM                                                         */
             IF         COND(&SAVE_TIM *EQ '1') THEN(DO)
                CHGVAR   VAR(%SST(&SAVESTATUS 41 40)) VALUE('Save_Tim +
                          gestartet                      ')
                MONMSG     MSGID(CPF0000)
                CHGDTAARA  DTAARA(SUBR36/SAVESTATUS) VALUE(&SAVESTATUS)
                MONMSG     MSGID(CPF0000)

                CALL       PGM(UEBERNAHME/SAVE_TIM) PARM('1')
                MONMSG     MSGID(CPF0000)
             ENDDO

             CHGVAR     VAR(%SST(&SAVESTATUS 41 40)) +
                          VALUE('Bandinitialisierung INZTAP +
                          gestartet    ')
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(SUBR36/SAVESTATUS) VALUE(&SAVESTATUS)
             MONMSG     MSGID(CPF0000)

             INZTAP     DEV(TAP02) NEWVOL(&NEWVOL) +
                          NEWOWNID(&NEWOWNID) CHECK(*NO) +
                          DENSITY(*CTGTYPE) ENDOPT(*REWIND)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                CHGVAR     VAR(&SWITCH) VALUE('1')
                GOTO       CMDLBL(NEXTSTEP)
             ENDDO

             IF         COND(&MONATENDE *EQ '1') THEN(DO)

                CHGVAR     VAR(%SST(&SAVESTATUS 41 40)) +
                             VALUE('Sicherung Monatsende +
                             SAVLIB             ')
                MONMSG     MSGID(CPF0000)
                CHGDTAARA  DTAARA(SUBR36/SAVESTATUS) VALUE(&SAVESTATUS)
                MONMSG     MSGID(CPF0000)
                SAVLIB     LIB(*ALLUSR) DEV(TAP02) ENDOPT(*LEAVE) +
                           UPDHST(*YES) SAVACT(*SYNCLIB) +
                           SAVACTWAIT(005 005 005) SAVACTMSGQ(*NONE) +
                           ACCPTH(*YES) SPLFDTA(*ALL) +
                           OMITLIB(TESTLIB) +
                           OMITOBJ((SUBR36/SICHERUNG *FILE) +
                           (SFBF/FHBUCHD *FILE) (SFBF/FHKORED *FILE) +
                           (QMPGDATA/*ALL *MGTCOL)) OUTPUT(*OUTFILE) +
                           OUTFILE(SUBR36/SICHERUNG) OUTMBR(*FIRST +
                           *ADD) INFTYPE(*OBJ)
                MONMSG     MSGID(CPF0000)

         /*  MONMSG  MSGID(CPF3761 CPF3741) EXEC(GOTO CMDLBL(ENDE)) */

                CHGVAR     VAR(%SST(&SAVESTATUS 41 40)) +
                             VALUE('Sicherung Monatsende +
                             SAVSECDTA          ')
                MONMSG     MSGID(CPF0000)
                CHGDTAARA  DTAARA(SUBR36/SAVESTATUS) VALUE(&SAVESTATUS)
                MONMSG     MSGID(CPF0000)
                SAVSECDTA  DEV(TAP02) ENDOPT(*LEAVE) OUTPUT(*OUTFILE) +
                          OUTFILE(SUBR36/SAVSECDTA) OUTMBR(*FIRST *ADD)
                MONMSG     MSGID(CPF0000)

                CHGVAR     VAR(%SST(&SAVESTATUS 41 40)) +
                             VALUE('Sicherung Monatsende +
                             SAVCFG             ')
                MONMSG     MSGID(CPF0000)
                CHGDTAARA  DTAARA(SUBR36/SAVESTATUS) VALUE(&SAVESTATUS)
                MONMSG     MSGID(CPF0000)
                SAVCFG     DEV(TAP02) ENDOPT(*LEAVE) OUTPUT(*OUTFILE) +
                           OUTFILE(SUBR36/SAVCFG) OUTMBR(*FIRST *ADD)
                MONMSG     MSGID(CPF0000)

                CHGVAR     VAR(%SST(&SAVESTATUS 41 40)) +
                             VALUE('Sicherung Monatsende +
                             SAV IFS-SYSTEM     ')
                MONMSG     MSGID(CPF0000)
                CHGDTAARA  DTAARA(SUBR36/SAVESTATUS) VALUE(&SAVESTATUS)
                MONMSG     MSGID(CPF0000)
             SAV        DEV('/qsys.lib/tap02.devd') +
                        OBJ(('/*' *INCLUDE) +
                          ('/QSYS.LIB' *OMIT) ('/QDLS' *OMIT) +
                          ('/QIBM/PRODDATA' *OMIT) +
                          ('/QOPENSYS/QIBM/PRODDATA' *OMIT)) +
                          SAVACT(*SYNC) OUTPUT(*print) +
                          ENDOPT(*UNLOAD) UPDHST(*YES)
                MONMSG     MSGID(CPF0000)

                CHGVAR     VAR(%SST(&GSMMSG 01 43)) +
                           VALUE('Bandsicherung Sicherung +
                           gelaufen            ')
                CALL       PGM(SUBR36/#SNDGSMCO) PARM('EDVBER' &GSMMSG)
                MONMSG     MSGID(CPF0000)

                CHGVAR     VAR(%SST(&SAVESTATUS 41 40)) +
                             VALUE('Protokoll #PRFOBJC gestartet +
                             Monatsende ')
                MONMSG     MSGID(CPF0000)
                CHGDTAARA  DTAARA(SUBR36/SAVESTATUS) VALUE(&SAVESTATUS)
                MONMSG     MSGID(CPF0000)
                CALL PGM(SUBR36/#PRFOBJC) PARM(' ')
                MONMSG     MSGID(CPF0000)
             ENDDO

             IF         COND(&MONATENDE *EQ '0') THEN(DO)
                CHGVAR   VAR(%SST(&SAVESTATUS 41 40)) VALUE('tägliche +
                          Sicherung SAVLIB               ')
                MONMSG     MSGID(CPF0000)
                CHGDTAARA  DTAARA(SUBR36/SAVESTATUS) VALUE(&SAVESTATUS)
                MONMSG     MSGID(CPF0000)
              SAVLIB     LIB(*ALLUSR) DEV(TAP02) ENDOPT(&ENDOPT) +
                           UPDHST(*YES) SAVACT(*SYNCLIB) +
                           SAVACTWAIT(05 05 05) SAVACTMSGQ(*NONE) +
                           ACCPTH(*YES) SPLFDTA(*ALL) +
                           OMITLIB(SAVEFILE TESTLIB) +
                           OMITOBJ((SUBR36/SICHERUNG *FILE) +
                           (SFBF/FHBUCHD *FILE) (SFBF/FHKORED *FILE) +
                           (QMPGDATA/*ALL *MGTCOL)) OUTPUT(*OUTFILE) +
                           OUTFILE(SUBR36/SICHERUNG) OUTMBR(*FIRST +
                           *ADD) INFTYPE(*OBJ)
                MONMSG     MSGID(CPF0000)
             ENDDO

    /*       SICHERUNG KORREKT                                    */

             CHGVAR     VAR(&SWITCH) VALUE('0')
             GOTO       CMDLBL(NEXTSTEP)

 NEXTSTEP:
    /*       MELDUNGEN AN HANDY ÜBER NICHT GESICHERTE OBJEKTE     */
    /*       SPEICHERUNG ALLE VORGÄNGE NICHT GESICHERTER OBJEKTE  */
             CALL SUBR36/SICHERUNG1
             MONMSG     MSGID(CPF0000)

             IF         COND(&ENDSYSTEM *EQ '1') THEN(DO)
                CHGVAR     VAR(%SST(&SAVESTATUS 41 40)) +
                             VALUE('Subsysteme starten/Server +
                             hochfahren    ')
                MONMSG     MSGID(CPF0000)
                CHGDTAARA  DTAARA(SUBR36/SAVESTATUS) VALUE(&SAVESTATUS)
                MONMSG     MSGID(CPF0000)

                STRSBS     SBSD(APF3812/AUTO_FORM)
                MONMSG     MSGID(CPF0000)
                EFS/STRTCPCMN
                MONMSG     MSGID(CPF0000)
                EFS/STRMDASVR
                MONMSG     MSGID(CPF0000)
                DLYJOB     DLY(05)
                MONMSG     MSGID(CPF0000)
             ENDDO

             CALL       PGM(SUBR36/#ENDINTERC)
             MONMSG     MSGID(CPF0000)
             IF         COND(&SWITCH *EQ '0') THEN(DO)
             OVRPRTF    FILE(QPQUPRFIL) HOLD(*YES) USRDTA(&SYSDAT)
                MONMSG     MSGID(CPF0000)
                CALL       PGM(UEBERNAHME/DRUCK_R) PARM(&PRT)
             CALL       PGM(PRTCTL) PARM(&PRT 'QPQUPRFIL ' &CTL +
                          '*YES' '1')
/*           OVRPRTF    FILE(QPQUPRFIL) HOLD(*YES) USRDTA(&SYSDAT)  */
/*              MONMSG     MSGID(CPF0000)                           */
             RUNQRY     QRY(SUBR36/SICHERUNG)
                MONMSG     MSGID(CPF0000)
             CALL       PGM(PRTCTL) PARM(&PRT 'QPQUPRFIL ' &CTL '*NO +
                          ' '0')
                CHGVAR     VAR(%SST(&GSMMSG 01 43)) VALUE('WAECO400 +
                             Sicherung abgeschlossen, alles OK! ')
             ENDDO
             CALL       PGM(SUBR36/#SNDGSMCO) PARM('EDVBER' &GSMMSG)
             MONMSG     MSGID(CPF0000)

/*    *     SCHILLING                                                        */
             IF         COND(&SCHILLING *EQ '1') THEN(DO)
                CHGVAR     VAR(%SST(&SAVESTATUS 41 40)) +
                             VALUE('Schilling Tagesabschluß +
                             gestartet       ')
                MONMSG     MSGID(CPF0000)
                CHGDTAARA  DTAARA(SUBR36/SAVESTATUS) VALUE(&SAVESTATUS)
                MONMSG     MSGID(CPF0000)

           /*   JOB STARTET TAGESABSCHLUSS AUS FREMDANWENDUNGEN      */
           /*   IN  SASBATCH                                         */
                ADDLIBLE   LIB(SFB)
                MONMSG     MSGID(CPF0000)
                ADDLIBLE   SFBF
                MONMSG     MSGID(CPF0000)
                ADDLIBLE   SAS
                MONMSG     MSGID(CPF0000)
                ADDLIBLE   SASF
                MONMSG     MSGID(CPF0000)
                ADDLIBLE   SFBS
                MONMSG     MSGID(CPF0000)
                ADDLIBLE   SASS
                MONMSG     MSGID(CPF0000)
                ADDLIBLE   BUDRA
                MONMSG     MSGID(CPF0000)
                ADDLIBLE   SUE
                MONMSG     MSGID(CPF0000)
                ADDLIBLE   SUESAB
                MONMSG     MSGID(CPF0000)

                OVRPRTF    FILE(SPRT) TOFILE(SAS/SPRT) DEV(WAECO_P01) +
                           SPOOL(*YES) OUTQ(*DEV) FORMTYPE(0001) +
                           SAVE(*YES)
                MONMSG     MSGID(CPF0000)

                CALL       PGM(UEBERNAHME/DRUCK_R) PARM(&PRT)
                MONMSG     MSGID(CPF0000)
    /* DRUCKAUSGABE AUF LASERDRUCKER SYSTEM (KYOCERA)             */
/*              -CALL AUF DRUCKSTEUERPROGRAMM---==> START---------------------*/
                CALL       PGM(PRTCTL) PARM(&PRT 'SPRT     ' &CTL +
                           '*NO ' '1')
                CALL       PGM(PRTCTL) PARM(&PRT 'SPRT2    ' &CTL +
                           '*NO ' '1')
                CALL       PGM(PRTCTL) PARM(&PRT 'SPRT3    ' &CTL +
                           '*NO ' '1')

    /* PRÜFEN DAß KEIN JOB INTERAKTIV IST                         */

                CALL       PGM(SUBR36/#ENDINTERC)
                MONMSG     MSGID(CPF0000)

                CALL      PGM(SFB/FTGABFREMD) PARM('N' 'J' 'SFB       +
                             ' 'J' 'A1        ' ' ' ' ')
                MONMSG     MSGID(CPF0000)

                DLTOVR     FILE(SPRT SPRT2 SPRT3)
                MONMSG     MSGID(CPF0000)

/*             -CALL AUF DRUCKSTEUERPROGRAMM---==> ENDE--------------*/
                CALL       PGM(PRTCTL) PARM(&PRT 'SPRT     ' &CTL +
                           '*NO ' '0')
                CALL       PGM(PRTCTL) PARM(&PRT 'SPRT2    ' &CTL +
                           '*NO ' '0')
                CALL       PGM(PRTCTL) PARM(&PRT 'SPRT3    ' &CTL +
                           '*NO ' '0')

                RMVLIBLE   SFB
                MONMSG     MSGID(CPF0000)
                RMVLIBLE   SFBF
                MONMSG     MSGID(CPF0000)
                RMVLIBLE   SAS
                MONMSG     MSGID(CPF0000)
                RMVLIBLE   SASF
                MONMSG     MSGID(CPF0000)
                RMVLIBLE   SFBS
                MONMSG     MSGID(CPF0000)
                RMVLIBLE   SASS
                MONMSG     MSGID(CPF0000)
                RMVLIBLE   BUDRA
                MONMSG     MSGID(CPF0000)
                RMVLIBLE   SUE
                MONMSG     MSGID(CPF0000)
                RMVLIBLE   SUESAB
                MONMSG     MSGID(CPF0000)
             ENDDO

             CHGVAR     VAR(%SST(&SAVESTATUS 41 40)) +
                          VALUE('Archivaufbau +
                          gestartet                  ')
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(SUBR36/SAVESTATUS) VALUE(&SAVESTATUS)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(SICHERPER) VALUE('0')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(UEBERNAHME/ARCHIVC)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(SICHERPER) VALUE('1')
             MONMSG     MSGID(CPF0000)

 ENDE:
             CHGVAR     VAR(%SST(&SAVESTATUS 41 40)) +
                          VALUE('SaveFiles +
                          bereinigen                    ')
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(SUBR36/SAVESTATUS) VALUE(&SAVESTATUS)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(%SST(&MD 01 02)) VALUE('D_')
             CHGVAR     VAR(%SST(&MD 03 06)) VALUE(%SST(&SYSDAT 01 06))
             CHGVAR     VAR(%SST(&MD 09 02)) VALUE('L_')
             CHGVAR     VAR(%SST(&MD 11 06)) VALUE(%SST(&SYSDAT 01 06))
             CHGVAR     VAR(%SST(&MD 17 02)) VALUE(%SST(&SYSDAT 05 02))
             CHGVAR     VAR(%SST(&MD 19 02)) VALUE(%SST(&SYSDAT 07 02))
             CHGVAR     VAR(%SST(&MD 21 02)) VALUE(%SST(&SYSDAT 03 02))
             CALL       PGM(DUMMY512) PARM(&MD 'SAV0001' ' ' ' ' +
                          'SAV0001' 'SUBR36' '*ADD')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(&MD 'SAV0002' ' ' ' ' +
                          'SAV0002' 'SUBR36' '*REPLACE')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(&MD 'SAV0003' ' ' ' ' +
                          'SAV0003' 'SUBR36' '*REPLACE')
             MONMSG     MSGID(CPF0000)

             IF         COND(&MONATENDE *NE '1') THEN(DO)
                GOTO       CMDLBL(ENDPGM)
             ENDDO

 LOOP:       RCVF
                MONMSG MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDPGM))
                OVRPRTF    FILE(QPRTOBJD) USRDTA(&ODOBNM)
                MONMSG     MSGID(CPF0000)
                DSPOBJD    OBJ(SAVEFILE/&ODOBNM) OBJTYPE(*FILE) +
                          OUTPUT(*PRINT)
                MONMSG     MSGID(CPF0000)
                DLTF       FILE(SAVEFILE/&ODOBNM)
                MONMSG     MSGID(CPF0000)
                GOTO CMDLBL(LOOP)

 ENDPGM:
             CHGVAR     VAR(%SST(&SAVESTATUS 41 40)) +
                          VALUE('Abschlußarbeiten Job +
                          SICHERUNG          ')
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(SUBR36/SAVESTATUS) VALUE(&SAVESTATUS)
             MONMSG     MSGID(CPF0000)
             IF         COND(&MONATENDE *EQ '1') THEN(DO)
                CPYF       FROMFILE(SICHERUNG) TOFILE(SICHERUNG#) +
                           MBROPT(*ADD)
                MONMSG     MSGID(CPF0000)
                CHGVAR     VAR(%SST(&GSMMSG 01 43)) VALUE('WAECO400 +
                          Monatssicherung gelaufen           ')
                CALL       PGM(SUBR36/#SNDGSMCO) PARM('EDVBER' &GSMMSG)
                MONMSG     MSGID(CPF0000)
             ENDDO

             OVRPRTF    FILE(QPJOBLOG) USRDTA(&SYSDAT)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(PSEUDOMON) VALUE('0')
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(SCHILLING) VALUE('1')
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(SAVE_TIM) VALUE('1')
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(ENDSYSTEM) VALUE('1')
             MONMSG     MSGID(CPF0000)
             DSPJOBLOG  OUTPUT(*PRINT)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(SICHERPER) VALUE('0')
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&SAVESTATUS) VALUE('Sicherung +
                          inaktiv                                     -
                          ')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(SUBR36/#DATAKTR) PARM(&DATMOD &RTNCOD +
                          &SYSGES &SYSDAT &SYSZEI)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(%SST(&GSMMSG 60 08)) VALUE(&SYSDAT)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(%SST(&SAVESTATUS 69 06)) VALUE(&SYSZEI)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(SUBR36/SAVESTATUS) VALUE(&SAVESTATUS)
             MONMSG     MSGID(CPF0000)
             DSPLOG     OUTPUT(*PRINT)
             MONMSG     MSGID(CPF0000)
             ENDPGM

