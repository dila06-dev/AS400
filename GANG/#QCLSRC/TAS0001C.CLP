/*    * PROGRAMMNAME.:TAS0001C                                               */
/*    * FUNKTION.....:...                                                    */
/*    *               AUFRUFSTEP NACH BMAP-TAGESABSCHLUß                     */
/*    *               -ERSTELLUNG MONATLICHE JOBS                            */
/*    *               -ERSTELLUNG DER RECHNUNGSDATEN                         */
/*    *               -ERSTELLUNG DER AUFTRAGSDATEN                          */
/*    *               -KREDITVERSICHERUNGSMANAGEMENT                         */
/*    *               -FORDERUNGSMANAGEMENT                                  */
/*    *               -RABATTE UND BONI                                      */
/*    * OKTOBER 2000                                                          */
/*    *                                                                       */
/*    * FASERWERKE-LINGEN GMBH                                                */
/*    * DARMER ESCH 75                                                        */
/*    * 49811 LINGEN                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM

/*                                                              */
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10) +
                          VALUE('FWLSQLANW ')
             DCL        VAR(&FIRMA) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FIRMAX) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MELDUNG) TYPE(*CHAR) LEN(132)
             DCL        VAR(&MELDUNG2) TYPE(*CHAR) LEN(24) +
                          VALUE('TAS0001C gestartet von: ')
             DCL        VAR(&MELDUNG3) TYPE(*CHAR) LEN(132) +
                          VALUE('Aktualisierung +
                          Kredit/Forderungsmanagement gestartet')
             DCL        VAR(&MELDUNG4) TYPE(*CHAR) LEN(132) +
                          VALUE('Aktualisierung +
                          Kredit/Forderungsmanagement beendet')
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TAS0001C) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&TASSTOP)  TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&INFO01) TYPE(*CHAR) LEN(132) VALUE(' ')
             DCL        VAR(&KVR_PGM)  TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&PROTOKOLL) TYPE(*CHAR) LEN(10) VALUE(' ')
             RTVDTAARA  DTAARA(QTEMP/FWLFIRM (1 1)) RTNVAR(&FIRMA)
             MONMSG     MSGID(CPF0000)
             IF         COND(&FIRMA *EQ 'L') THEN(DO)
             CHGVAR     VAR(&FIRMAX) VALUE('Lingen  ')
             ENDDO
             IF         COND(&FIRMA *EQ 'D') THEN(DO)
             CHGVAR     VAR(&FIRMAX) VALUE('Dormagen')
             ENDDO
             RTVJOBA    USER(&USER)
             CHGVAR     VAR(&MELDUNG) VALUE('Aktualisierung +
                          gestartet von: ' *CAT &USER *CAT 'für ' +
                          *CAT &FIRMAX)
             CHGVAR     VAR(%SST(&PROTOKOLL 01 10)) VALUE('TAS_ _    ')
             CHGVAR     VAR(%SST(&PROTOKOLL 05 01)) VALUE(&FIRMA)
/*----------------------------------------------------------------------------*/
             CALL       PGM(#DEFLDA) PARM(' ')
/*          - 01 ---START----PROTOKOLL--TAS0001C--------                     */
             CHGVAR     VAR(%SST(&PROTOKOLL 07 04)) VALUE('00_S')
             CALL       PGM(#SNDHANDY) PARM(&PROTOKOLL)
             MONMSG     MSGID(CPF0000)
/*          --------------------------------------------                     */
/*----------------------------------------------------------------------------*/
/*AKTUALISIEREN DER DATAAREAS FÜR BUCHHALTUNGSUMGEBUNGEN LINGEN/DORM.---------*/
             ADDLIBLE   LIB(FWLFR) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))
/*          BREAK #1------------------------------------                     */
          /* CALL       PGM(FWLFR/BABC)       */
/*          END   #1------------------------------------                     */
/*----------------------------------------------------------------------------*/
/*KREDITVERSICHERUNGSFUNKTIONEN STARTEN FÜR HERMES APG   LINGEN/DORM.---------*/
/*KREDITVERSICHERUNGSFUNKTIONEN STARTEN FÜR HERMES PRIV. LINGEN/DORM.---------*/
             CHGVAR     VAR(&MELDUNG) VALUE('monatliche Buchungen +
                          Kreditv. Hermes gestartet von: ' *CAT &USER)
             CHGDTAARA  DTAARA(SUBR36/INFO01) VALUE(&MELDUNG)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(FWLFR/BAB5576R) PARM('H')
             CHGVAR     VAR(&MELDUNG) VALUE('monatliche Buchungen +
                          Kreditv. Gerling gestartet von: ' *CAT &USER)
             CHGDTAARA  DTAARA(SUBR36/INFO01) VALUE(&MELDUNG)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(FWLFR/BAB5576R) PARM('G')
             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(FWLFR)
             ENDDO
/*----------------------------------------------------------------------------*/
/*AUTO_QUERY MONATLICH                 LINGEN/DORMAGEN/FWLGSMLIB     ---------*/
             CHGVAR     VAR(&MELDUNG) VALUE('monatliche +
                          Query-funktionen gestartet von: ' *CAT &USER)
             CHGDTAARA  DTAARA(SUBR36/INFO01) VALUE(&MELDUNG)
             ADDLIBLE   LIB(FWLFR) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))
/*          BREAK #2------------------------------------                     */
         /*  CALL       PGM(FWLFR/BAB5577R)   */
/*          END   #2------------------------------------                     */
             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(FWLFR)
             ENDDO
/*----------------------------------------------------------------------------*/
/*TAS0001C BEREITS AKTIV? WENN JA, DANN ENDE                       -----------*/
             RTVDTAARA  DTAARA(SUBR36/TAS0001C (1 1)) RTNVAR(&TAS0001C)
             MONMSG     MSGID(CPF0000)
             IF         COND(&TAS0001C *EQ '1') THEN(DO)
                   GOTO ENDE
             ENDDO
             RTVDTAARA  DTAARA(SUBR36/TASSTOP (1 1)) RTNVAR(&TASSTOP)
             MONMSG     MSGID(CPF0000)
             IF         COND(&TASSTOP *EQ '3') THEN(DO)
                CHGDTAARA  DTAARA(SUBR36/TAS0001C) VALUE('0')
                MONMSG     MSGID(CPF0000)
                IF         COND(&FIRMA *EQ 'L') THEN(DO)
/*          BREAK #3------------------------------------                     */
          /*       SBMJOB  CMD(CALL PGM(FWLFR/TAS0010C) PARM('L')) + */
          /*                 JOBQ(FWLSYSTEM/FWLBATCH)                */
          /*       MONMSG     MSGID(CPF0000)                         */
/*          END   #3------------------------------------                     */
                ENDDO
                IF         COND(&FIRMA *EQ 'D') THEN(DO)
/*          BREAK #4------------------------------------                     */
          /*       SBMJOB  CMD(CALL PGM(FWLFR/TAS0010C) PARM('D')) + */
          /*                  JOBQ(FWLSYSTEM/FWLBATCH)               */
          /*       MONMSG     MSGID(CPF0000)                         */
/*          END   #4------------------------------------                     */
                ENDDO
                GOTO       CMDLBL(ENDEX)
             ENDDO
             IF         COND(&TASSTOP *EQ '2') THEN(DO)
                IF         COND(&FIRMA *EQ 'D') THEN(DO)
                   GOTO       CMDLBL(STEP3)
                ENDDO
             ENDDO
             CHGVAR     VAR(&MELDUNG) VALUE('Vorbereitungen TAS0001C +
                          gestartet von: ' *CAT &USER)
             CHGDTAARA  DTAARA(SUBR36/INFO01) VALUE(&MELDUNG)
             MONMSG     MSGID(CPF0000)
             CLROUTQ    OUTQ(SCHEDULE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(SUBR36/TAS0001C) VALUE('1')
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(SUBR36/INFO01) VALUE(&MELDUNG)
             MONMSG     MSGID(CPF0000)
     /*      SNDBRKMSG  MSG(&MELDUNG) TOMSGQ(B4)      */
     /*      MONMSG     MSGID(CPF0000)                */
/*----------------------------------------------------------------------------*/
             DLTF       FILE(QTEMP/BAB0702L1)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/BAB0704L1)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/BAB0705L1)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/BAB0707L1)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/W§BAB555L1)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/B*)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/W*)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/DEB*)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/KRE*)
             MONMSG     MSGID(CPF0000)
/*----------------------------------------------------------------------------*/
/* RABATTE UND BONI ÜBER DATEI BAB0888 AKTUALISIEREN -------------------------*/
/* NEUE KUNDEN/ARTIKELKOMBINATIONEN AUFNEHMEN        -------------------------*/
/*----------------------------------------------------------------------------*/
             RTVDTAARA  DTAARA(SUBR36/TASSTOP (1 1)) RTNVAR(&TASSTOP)
             MONMSG     MSGID(CPF0000)
             IF         COND(&TASSTOP *EQ '3') THEN(DO)
                CHGDTAARA  DTAARA(SUBR36/TAS0001C) VALUE('0')
                MONMSG     MSGID(CPF0000)
                GOTO       CMDLBL(ENDEX)
             ENDDO
             IF         COND(&FIRMA *EQ 'L') THEN(DO)
                CHGVAR    VAR(&MELDUNG) VALUE('Rabatte/Boni:Übernahme +
                          neuer Kunden/Artikelk.f.Lingen: ' *CAT &USER)
                CHGDTAARA  DTAARA(SUBR36/INFO01) VALUE(&MELDUNG)
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&FIRMA *EQ 'D') THEN(DO)
                CHGVAR   VAR(&MELDUNG) VALUE('Rabatte/Boni:Übernahme +
                          neuer Kunden/Artikelk.f.Dormagen: ' *CAT +
                          &USER)
                CHGDTAARA  DTAARA(SUBR36/INFO01) VALUE(&MELDUNG)
                MONMSG     MSGID(CPF0000)
             ENDDO
             CALL       PGM(FWLFR/PRV0002C)
/*----------------------------------------------------------------------------*/
/*           IF         COND(&USER *NE 'GANG      ') THEN(DO)  */
/*           SNDGSMTMSG USID(EDVBER) MTXT(&MELDUNG)            */
/*           MONMSG     MSGID(CPF0000)                         */
/*           ENDDO                                             */
/*----------------------------------------------------------------------------*/
/* D E B I T O R E N ---------------------------------------------------------*/
/*ÜBERNAHME DER ABGESCHLOSSENEN BUCHUNGEN AUS BUCHHALTUNG---------------------*/
             RTVDTAARA  DTAARA(SUBR36/TASSTOP (1 1)) RTNVAR(&TASSTOP)
             MONMSG     MSGID(CPF0000)
             IF         COND(&TASSTOP *EQ '3') THEN(DO)
                CHGDTAARA  DTAARA(SUBR36/TAS0001C) VALUE('0')
                MONMSG     MSGID(CPF0000)
                GOTO       CMDLBL(ENDEX)
             ENDDO
             IF         COND(&FIRMA *EQ 'L') THEN(DO)
             CHGVAR     VAR(&MELDUNG) VALUE('Übernahme der alten +
                          Buchungen f.Lingen: ' *CAT &USER)
             CHGDTAARA  DTAARA(SUBR36/INFO01) VALUE(&MELDUNG)
             MONMSG     MSGID(CPF0000)
/*          BREAK #5------------------------------------                     */
       /*    CALL       PGM(DUMMY512) PARM(' ' 'BAB0777' ' ' ' ' + */
       /*                 'DEBITOREN' 'BMAP0475L' '*REPLACE')      */
/*          END   #5------------------------------------                     */
             ENDDO
             IF         COND(&FIRMA *EQ 'D') THEN(DO)
             CHGVAR     VAR(&MELDUNG) VALUE('Übernahme der alten +
                          Buchungen f.Dormagen: ' *CAT &USER)
             CHGDTAARA  DTAARA(SUBR36/INFO01) VALUE(&MELDUNG)
             MONMSG     MSGID(CPF0000)
/*          BREAK #6------------------------------------                     */
       /*    CALL       PGM(DUMMY512) PARM(' ' 'BAB0777' ' ' ' ' + */
       /*                 'DEBITOREN' 'BMAP0476L' '*REPLACE')      */
/*          END   #6------------------------------------                     */
             ENDDO
/*----------------------------------------------------------------------------*/
/* R E T O U R E N A N P A S S U N G AB 2001 ERNEUTE ÄNDERUNG MAPICS----------*/
/* WENN FIRMA LINGEN                                                   -------*/
             RTVDTAARA  DTAARA(SUBR36/TASSTOP (1 1)) RTNVAR(&TASSTOP)
             MONMSG     MSGID(CPF0000)
             IF         COND(&TASSTOP *EQ '3') THEN(DO)
                CHGDTAARA  DTAARA(SUBR36/TAS0001C) VALUE('0')
                MONMSG     MSGID(CPF0000)
                GOTO       CMDLBL(ENDEX)
             ENDDO
             IF         COND(&FIRMA *EQ 'L') THEN(DO)
                CHGVAR     VAR(&MELDUNG) VALUE('Mapics +
                          Retourenanpassung, hoffentlich die +
                          "Letzte" ' *CAT &USER)
                CHGDTAARA  DTAARA(SUBR36/INFO01) VALUE(&MELDUNG)
                MONMSG     MSGID(CPF0000)
/*          BREAK #7------------------------------------                     */
           /*   CALL       PGM(FWLFR/BAB0513C)         */
           /*   MONMSG     MSGID(CPF0000)              */
/*          END   #7------------------------------------                     */
             ENDDO
/*----------------------------------------------------------------------------*/
/* R E C H N U N G S D A T E N -----------------------------------------------*/
/*          - 01 ---START----PROTOKOLL--RECHNUNGSDATEN--                     */
             CHGVAR     VAR(%SST(&PROTOKOLL 07 04)) VALUE('01_S')
             CALL       PGM(#SNDHANDY) PARM(&PROTOKOLL)
             MONMSG     MSGID(CPF0000)
/*          --------------------------------------------                     */
             RTVDTAARA  DTAARA(SUBR36/TASSTOP (1 1)) RTNVAR(&TASSTOP)
             MONMSG     MSGID(CPF0000)
             IF         COND(&TASSTOP *EQ '3') THEN(DO)
                CHGDTAARA  DTAARA(SUBR36/TAS0001C) VALUE('0')
                MONMSG     MSGID(CPF0000)
                GOTO       CMDLBL(ENDEX)
             ENDDO
             CHGVAR     VAR(&MELDUNG) VALUE('Aktualisierung +
                          Rechnungsdaten gestartet von: ' *CAT +
                          &USER *CAT 'für ' *CAT &FIRMAX)
             CHGDTAARA  DTAARA(SUBR36/INFO01) VALUE(&MELDUNG)
             MONMSG     MSGID(CPF0000)
       /*    SNDBRKMSG  MSG(&MELDUNG) TOMSGQ(B4)  */
       /*    MONMSG     MSGID(CPF0000)            */
/*MAPICS-DATEN ÜBERNHEMEN/AKTUALISIEREN IN QTEMP UND ÜBERGABE-----------------*/
/*          BREAK #8-----WECHSEL AUF NEUES PGM----------                     */
       /*    CALL       PGM(FWLFR/BAB555C)           */
             CALL       PGM(UEBERNAHME/ARCHIVC)
             MONMSG     MSGID(CPF0000)
             GOTO       TIM01
/*          END   #8------------------------------------                     */
/*AUFGRUND VON AKTUALISIERUNGSPROBLEMEN ZUM MONATSENDE WERDEN ALLE -----------*/
/*SÄTZE DES AKTUELLEN UND DER FOLGENDEN MONATE GELÖSCHT.(VERSCHIEBUNG---------*/
/*VON AUFTRÄGEN IN NACHFOLGENDE MONATE, DIE COPY-FUNKTIONEN BERÜCK-  ---------*/
/*SICHTIGEN DIESE AUFTRÄGE NICHT.                                    ---------*/
             CHGDTAARA  DTAARA(*LIBL/BABAKT) VALUE('1')
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(FWLGSMLIB/BABAKT) VALUE('1')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(FWLFR/BAB5575R) PARM('1')
             MONMSG     MSGID(CPF0000)
/*                                                              */
             DLTF       FILE(QTEMP/BAB0708L1)
             MONMSG     MSGID(CPF0000)
             IF         COND(&FIRMA *EQ 'L') THEN(DO)
                /*STERN AN POSITION 15 LÖSCHEN-----------------------*/
                CHGDTAARA  DTAARA(*LDA (890 10)) VALUE(&MSGF)
                MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(' ' 'BAB0510' ' ' ' ' ' ' +
                          ' ' ' ')
                MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&MELDUNG) VALUE('COPY-Funktionen +
                          Rechnungsdaten gestartet von: ' *CAT +
                          &USER *CAT 'für ' *CAT &FIRMAX)
             CHGDTAARA  DTAARA(SUBR36/INFO01) VALUE(&MELDUNG)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(SUBR36/CPYFWLBAB) PARM('BAB0706' +
                          'FMAPLIB' '0')
                MONMSG     MSGID(CPF0000)
             CALL       PGM(SUBR36/CPYFWLBAB) PARM('BAB0706' +
                          'FWLGSMLIB' '0')
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&FIRMA *EQ 'D') THEN(DO)
                /*STERN AN POSITION 15 LÖSCHEN-----------------------*/
                CHGDTAARA  DTAARA(*LDA (890 10)) VALUE(&MSGF)
                MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(' ' 'BAB0511' ' ' ' ' ' ' +
                          ' ' ' ')
                MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&MELDUNG) VALUE('COPY-Funktionen +
                          Rechnungsdaten gestartet von: ' *CAT +
                          &USER *CAT 'für ' *CAT &FIRMAX)
             CHGDTAARA  DTAARA(SUBR36/INFO01) VALUE(&MELDUNG)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(SUBR36/CPYFWLBAB) PARM('BAB0706' +
                          'DMAPLIB' '0')
                MONMSG     MSGID(CPF0000)
             CALL       PGM(SUBR36/CPYFWLBAB) PARM('BAB0706' +
                          'FWLGSMLIB' '0')
                MONMSG     MSGID(CPF0000)
             ENDDO
             CHGDTAARA  DTAARA(*LIBL/BABAKT) VALUE('0')
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(FWLGSMLIB/BABAKT) VALUE('0')
             MONMSG     MSGID(CPF0000)
/*          - 01 -- ENDE-----PROTOKOLL--RECHNUNGSDATEN--                     */
             CHGVAR     VAR(%SST(&PROTOKOLL 07 04)) VALUE('01_E')
             CALL       PGM(#SNDHANDY) PARM(&PROTOKOLL)
             MONMSG     MSGID(CPF0000)
/*          --------------------------------------------                     */
/*----------------------------------------------------------------------------*/
/* A U F T R A G S D A T E N -------------------------------------------------*/
/*          - 01 ---START----PROTOKOLL--AUFTRAGSDATEN---                     */
             CHGVAR     VAR(%SST(&PROTOKOLL 07 04)) VALUE('02_S')
             CALL       PGM(#SNDHANDY) PARM(&PROTOKOLL)
             MONMSG     MSGID(CPF0000)
/*          --------------------------------------------                     */
             RTVDTAARA  DTAARA(SUBR36/TASSTOP (1 1)) RTNVAR(&TASSTOP)
             MONMSG     MSGID(CPF0000)
             IF         COND(&TASSTOP *EQ '3') THEN(DO)
                CHGDTAARA  DTAARA(SUBR36/TAS0001C) VALUE('0')
                MONMSG     MSGID(CPF0000)
                GOTO       CMDLBL(ENDEX)
             ENDDO
             CHGVAR     VAR(&MELDUNG) VALUE('Aktualisierung +
                          Auftragsdaten gestartet von: ' *CAT &USER +
                          *CAT 'für ' *CAT &FIRMAX)
             CHGDTAARA  DTAARA(SUBR36/INFO01) VALUE(&MELDUNG)
             MONMSG     MSGID(CPF0000)
       /*    SNDBRKMSG  MSG(&MELDUNG) TOMSGQ(B4)   */
       /*    MONMSG     MSGID(CPF0000)             */
/*MAPICS-DATEN ÜBERNHEMEN/AKTUALISIEREN IN QTEMP UND ÜBERGABE-----------------*/
             CALL       PGM(FWLFR/BAB556C)
             MONMSG     MSGID(CPF0000)
/*AUFGRUND VON AKTUALISIERUNGSPROBLEMEN ZUM MONATSENDE WERDEN ALLE -----------*/
/*SÄTZE DES AKTUELLEN UND DER FOLGENDEN MONATE GELÖSCHT.(VERSCHIEBUNG---------*/
/*VON AUFTRÄGEN IN NACHFOLGENDE MONATE, DIE COPY-FUNKTIONEN BERÜCK-  ---------*/
/*SICHTIGEN DIESE AUFTRÄGE NICHT.                                    ---------*/
             CHGDTAARA  DTAARA(*LIBL/BABAKT) VALUE('2')
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(FWLGSMLIB/BABAKT) VALUE('2')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(FWLFR/BAB5575R) PARM('2')
             MONMSG     MSGID(CPF0000)
/*                                                              */
             IF         COND(&FIRMA *EQ 'L') THEN(DO)
             CHGVAR     VAR(&MELDUNG) VALUE('COPY-Funktionen +
                          Auftragsdaten gestartet von: ' *CAT &USER +
                          *CAT 'für ' *CAT &FIRMAX)
             CHGDTAARA  DTAARA(SUBR36/INFO01) VALUE(&MELDUNG)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(SUBR36/CPYFWLBAB) PARM('BAB0721' +
                          'FMAPLIB' '0')
                MONMSG     MSGID(CPF0000)
             CALL       PGM(SUBR36/CPYFWLBAB) PARM('BAB0721' +
                          'FWLGSMLIB' '0')
                MONMSG     MSGID(CPF0000)
             CALL       PGM(SUBR36/CPYFWLBAB) PARM('BAB0738' +
                          'FMAPLIB' '0')
                MONMSG     MSGID(CPF0000)
             CALL       PGM(SUBR36/CPYFWLBAB) PARM('BAB0738' +
                          'FWLGSMLIB' '0')
                MONMSG     MSGID(CPF0000)
             CALL       PGM(SUBR36/CPYFWLBAB) PARM('BAB0740' +
                          'FMAPLIB' '0')
                MONMSG     MSGID(CPF0000)
             CALL       PGM(SUBR36/CPYFWLBAB) PARM('BAB0740' +
                          'FWLGSMLIB' '0')
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&FIRMA *EQ 'D') THEN(DO)
             CHGVAR     VAR(&MELDUNG) VALUE('COPY-Funktionen +
                          Auftragsdaten gestartet von: ' *CAT &USER +
                          *CAT 'für ' *CAT &FIRMAX)
             CHGDTAARA  DTAARA(SUBR36/INFO01) VALUE(&MELDUNG)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(SUBR36/CPYFWLBAB) PARM('BAB0721' +
                          'DMAPLIB' '0')
                MONMSG     MSGID(CPF0000)
             CALL       PGM(SUBR36/CPYFWLBAB) PARM('BAB0721' +
                          'FWLGSMLIB' '0')
                MONMSG     MSGID(CPF0000)
             CALL       PGM(SUBR36/CPYFWLBAB) PARM('BAB0738' +
                          'DMAPLIB' '0')
                MONMSG     MSGID(CPF0000)
             CALL       PGM(SUBR36/CPYFWLBAB) PARM('BAB0738' +
                          'FWLGSMLIB' '0')
                MONMSG     MSGID(CPF0000)
             CALL       PGM(SUBR36/CPYFWLBAB) PARM('BAB0740' +
                          'DMAPLIB' '0')
                MONMSG     MSGID(CPF0000)
             CALL       PGM(SUBR36/CPYFWLBAB) PARM('BAB0740' +
                          'FWLGSMLIB' '0')
                MONMSG     MSGID(CPF0000)
             ENDDO
             CHGDTAARA  DTAARA(*LIBL/BABAKT) VALUE('0')
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(FWLGSMLIB/BABAKT) VALUE('0')
             MONMSG     MSGID(CPF0000)
/*          - 01 ---ENDE-----PROTOKOLL--AUFTRAGSDATEN---                     */
             CHGVAR     VAR(%SST(&PROTOKOLL 07 04)) VALUE('02_E')
             CALL       PGM(#SNDHANDY) PARM(&PROTOKOLL)
             MONMSG     MSGID(CPF0000)
/*          --------------------------------------------                     */
/*----------------------------------------------------------------------------*/
/* EXTENDED-VERSIONEN ERSTELLEN-----------------------------------------------*/
/*-EXTENDED VERSIONEN BAB0706E UND BAB0721E AUS BAB0706/BAB0721---------------*/
             RTVDTAARA  DTAARA(SUBR36/TASSTOP (1 1)) RTNVAR(&TASSTOP)
             MONMSG     MSGID(CPF0000)
             IF         COND(&TASSTOP *EQ '3') THEN(DO)
                CHGDTAARA  DTAARA(SUBR36/TAS0001C) VALUE('0')
                MONMSG     MSGID(CPF0000)
                GOTO       CMDLBL(ENDEX)
             ENDDO
/*          - 01 ---START----PROTOKOLL--EXTENDED--------                     */
             CHGVAR     VAR(%SST(&PROTOKOLL 07 04)) VALUE('03_S')
             CALL       PGM(#SNDHANDY) PARM(&PROTOKOLL)
             MONMSG     MSGID(CPF0000)
/*          --------------------------------------------                     */
             CHGDTAARA  DTAARA(*LIBL/BABAKT) VALUE('3')
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(FWLGSMLIB/BABAKT) VALUE('3')
             CHGVAR     VAR(&MELDUNG) VALUE('E-Dateien werden +
                          erstellt: ' *CAT &USER *CAT 'für ' *CAT +
                          &FIRMAX)
             CHGDTAARA  DTAARA(SUBR36/INFO01) VALUE(&MELDUNG)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(FWLFR/BAB5574C)
             MONMSG     MSGID(CPF0000)
             IF         COND(&FIRMA *EQ 'L') THEN(DO)
                SBMJOB     CMD(CALL PGM(FWLFR/TAS0010C) PARM('L')) +
                             JOBQ(FWLSYSTEM/FWLBATCH)
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&FIRMA *EQ 'D') THEN(DO)
                SBMJOB     CMD(CALL PGM(FWLFR/TAS0010C) PARM('D')) +
                             JOBQ(FWLSYSTEM/FWLBATCH)
                MONMSG     MSGID(CPF0000)
             ENDDO
             CHGDTAARA  DTAARA(*LIBL/BABAKT) VALUE('0')
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(FWLGSMLIB/BABAKT) VALUE('0')
             MONMSG     MSGID(CPF0000)
/*          - 01 ---ENDE-----PROTOKOLL--EXTENDED--------                     */
             CHGVAR     VAR(%SST(&PROTOKOLL 07 04)) VALUE('03_E')
             CALL       PGM(#SNDHANDY) PARM(&PROTOKOLL)
             MONMSG     MSGID(CPF0000)
/*          --------------------------------------------                     */
/*----------------------------------------------------------------------------*/
/*-ZUSAMMENFÜHRUNG D.DATEN IN FWLGSMLIB/BAB0706E UND FWLGSMLIB/BAB0721E-------*/
/* NACHDEM DORMAGEN ALS LETZTES ERSTELLT WORDEN IST                    -------*/
/* KREDITVERSICHERUNG TEIL 1 AKTUELLE STAMMDATEN ABLEITEN              -------*/
STEP3:       IF         COND(&FIRMA *EQ 'D') THEN(DO)
               RTVDTAARA  DTAARA(SUBR36/TASSTOP (1 1)) RTNVAR(&TASSTOP)
                MONMSG     MSGID(CPF0000)
                IF         COND(&TASSTOP *EQ '3') THEN(DO)
                   CHGDTAARA  DTAARA(SUBR36/TAS0001C) VALUE('0')
                   MONMSG     MSGID(CPF0000)
                   GOTO       CMDLBL(ENDEX)
                ENDDO
/*          - 01 ---START----PROTOKOLL--FWLGSMLIB-------                     */
                CHGVAR     VAR(%SST(&PROTOKOLL 07 04)) VALUE('04_S')
                CALL       PGM(#SNDHANDY) PARM(&PROTOKOLL)
                MONMSG     MSGID(CPF0000)
/*          --------------------------------------------                     */
                CHGVAR     VAR(&MELDUNG) VALUE('Stammdaten +
                             aktualisieren in FWLGSMLIB: ' *CAT &USER)
                CHGDTAARA  DTAARA(SUBR36/INFO01) VALUE(&MELDUNG)
                MONMSG     MSGID(CPF0000)
                CALL       PGM(FWLFR/BAB557C)
                MONMSG     MSGID(CPF0000)
/* B1KL.006 UND B1KL.015 SOWIE SYS140 PARTERSTAMM IN FWLGSMLIB ABLEITEN-------*/
                CALL       PGM(FWLFR/BAB558C)
                MONMSG     MSGID(CPF0000)
/*          - 01 ---ENDE-----PROTOKOLL--FWLGSMLIB-------                     */
                CHGVAR     VAR(%SST(&PROTOKOLL 07 04)) VALUE('04_E')
                CALL       PGM(#SNDHANDY) PARM(&PROTOKOLL)
                MONMSG     MSGID(CPF0000)
/*          --------------------------------------------                     */
/* KREDITVERSICHERUNGS UND FORDERUNGSMANAGEMENT                        -------*/
/* FWLGSMLIB VORRANGIG IN LIBLIST STELLEN                              -------*/
TIM01:
                RTVDTAARA DTAARA(SUBR36/KVR_PGM (1 1)) RTNVAR(&KVR_PGM)
                MONMSG     MSGID(CPF0000)
                IF         COND(&KVR_PGM *EQ '0') THEN(DO)
/*          - 01 ---START----PROTOKOLL--KREDITV.--------                     */
                    CHGVAR    VAR(%SST(&PROTOKOLL 07 04)) VALUE('05_S')
                    CALL      PGM(#SNDHANDY) PARM(&PROTOKOLL)
                    MONMSG    MSGID(CPF0000)
/*          --------------------------------------------                     */
                    CHGDTAARA  DTAARA(SUBR36/INFO01) VALUE(&MELDUNG3)
                    MONMSG     MSGID(CPF0000)
          /*        SNDBRKMSG  MSG(&MELDUNG3) TOMSGQ(B4)    */
          /*        MONMSG     MSGID(CPF0000)               */
                    CALL       PGM(FWLFR/BAB600CC) PARM('1')
                    MONMSG     MSGID(CPF0000)
                    CALL       PGM(FWLFR/BAB600C) PARM('A' ' ' ' ' +
                          'KVS0015' 'D' '0' ' ' '00' '000000' '000' +
                          ' ' '000')
                    MONMSG     MSGID(CPF0000)
/*                  AUFTRAGSDATEN                                      -------*/
                    CHGVAR     VAR(&MELDUNG) VALUE('Auftragsdaten in +
                            Kreditversicherung aktualisieren: ' *CAT +
                            &USER)
                    CHGDTAARA  DTAARA(SUBR36/INFO01) VALUE(&MELDUNG)
                    MONMSG     MSGID(CPF0000)
                    CALL       PGM(FWLFR/BAB5572R)
                    MONMSG     MSGID(CPF0000)
/*                  ROTE LAMPE                                         -------*/
                    CHGVAR     VAR(&MELDUNG) VALUE('Überfälligkeiten  +
                         "rote Lampe" ermitteln: ' *CAT &USER)
                    CHGDTAARA  DTAARA(SUBR36/INFO01) VALUE(&MELDUNG)
                    MONMSG     MSGID(CPF0000)
                    CALL       PGM(FWLFR/BAB5573R)
                    MONMSG     MSGID(CPF0000)
/*                  KOPIEREN QTEMP/W§BAB570 IN FWLGSMLIB/BAB570        -------*/
                    CHGVAR     VAR(&MELDUNG) VALUE('W§BAB570 +
                          Forderungsmanagementdaten ableiten: ' +
                          *CAT &USER)
                    CHGDTAARA  DTAARA(SUBR36/INFO01) VALUE(&MELDUNG)
                    MONMSG     MSGID(CPF0000)
                    CALL       PGM(FWLFR/BAB5575C)
                    MONMSG     MSGID(CPF0000)
                    CALL       PGM(FWLFR/BAB600CC) PARM('0')
                    MONMSG     MSGID(CPF0000)
                    CHGDTAARA  DTAARA(SUBR36/INFO01) VALUE(&MELDUNG4)
                    MONMSG     MSGID(CPF0000)
           /*       SNDBRKMSG  MSG(&MELDUNG4) TOMSGQ(B4)     */
           /*       MONMSG     MSGID(CPF0000)                */
/*          - 01 ---ENDE-----PROTOKOLL--KREDITV.--------                     */
                    CHGVAR    VAR(%SST(&PROTOKOLL 07 04)) VALUE('05_E')
                    CALL      PGM(#SNDHANDY) PARM(&PROTOKOLL)
                    MONMSG    MSGID(CPF0000)
/*          --------------------------------------------                     */
                ENDDO
             ENDDO
/*----------------------------------------------------------------------------*/
/* MELDUNGEN + DATAAREA ÄENDERN ----------------------------------------------*/
             CHGVAR     VAR(&MELDUNG) VALUE('Aktualisierung beendet: +
                          ' *CAT &USER *CAT 'für ' *CAT &FIRMAX)
             MONMSG     MSGID(CPF0000)
          /* SNDBRKMSG  MSG(&MELDUNG) TOMSGQ(B4)           */
          /* MONMSG     MSGID(CPF0000)                     */
             CHGDTAARA  DTAARA(SUBR36/TAS0001C) VALUE('0')
             MONMSG     MSGID(CPF0000)
             GOTO       CMDLBL(ENDEX)
/*----------------------------------------------------------------------------*/
ENDE:
             CHGVAR     VAR(&MELDUNG) VALUE('TAS0001C abgewiesen für +
                          User: ' *CAT &USER *CAT 'für ' *CAT &FIRMAX)
             MONMSG     MSGID(CPF0000)
             SNDBRKMSG  MSG(&MELDUNG) TOMSGQ(B4)
             MONMSG     MSGID(CPF0000)
ENDEX:
             IF         COND(&FIRMA *EQ 'D') THEN(DO)
               OVRPRTF    FILE(QPJOBLOG) USRDTA('Dormagen')
               MONMSG     MSGID(CPF0000)
               DSPJOBLOG  OUTPUT(*PRINT)
               DSPJOBLOG  OUTPUT(*OUTFILE) OUTFILE(FWLGSMLIB/TAS0001CD)
             ENDDO
             IF         COND(&FIRMA *EQ 'L') THEN(DO)
               OVRPRTF    FILE(QPJOBLOG) USRDTA('Lingen')
               MONMSG     MSGID(CPF0000)
               DSPJOBLOG  OUTPUT(*PRINT)
               DSPJOBLOG  OUTPUT(*OUTFILE) OUTFILE(FWLGSMLIB/TAS0001CL)
             ENDDO
/*          - 01 ---ENDE-----PROTOKOLL--TAS0001C--------                     */
             CHGVAR     VAR(%SST(&PROTOKOLL 07 04)) VALUE('00_E')
             CALL       PGM(#SNDHANDY) PARM(&PROTOKOLL)
             MONMSG     MSGID(CPF0000)
/*          --------------------------------------------                     */
             DLTOVR     FILE(QPJOBLOG)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(SUBR36/INFO01) VALUE(' ')
             ENDPGM
