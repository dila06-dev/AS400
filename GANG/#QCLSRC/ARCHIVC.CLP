/*    * PROGRAMMNAME.:ARCHIVC                                                */
/*    * FUNKTION.....:ZENTRALER AUFRUF ALLER VERARBEITUNGSROUTINEN           */
/*    *               FÜR ARCHIVE UND FOLGESYSTEME WIE BOARD ETC.            */
/*    * NOVEMBER 2000                                                         */
/*    * JANUAR 2006    GANG, MANFRED                                          */
/*    *                                                                       */
/*    * FASERWERKE-LINGEN GMBH                                                */
/*    * DARMER ESCH 75                                                        */
/*    * 49811 LINGEN                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM

/*----------------------------------------------------------------------------*/
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&MSGPGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LDAS)   TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR3)  TYPE(*CHAR) LEN(01) VALUE('0')
/*                                                              */
             DCL        VAR(&MODUS)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&DATMOD)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&RTNCOD)  TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&SYSGES)  TYPE(*CHAR) LEN(26)
             DCL        VAR(&SYSDAT)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&SYSZEI)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FWLFIRM) TYPE(*CHAR) LEN(01)
             DCL        VAR(&BASISJA) TYPE(*DEC) LEN(07) VALUE(9999999)
             DCL        VAR(&SICHERPER) TYPE(*CHAR) LEN(1)
             DCL        VAR(&X) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&Y)         TYPE(*CHAR) LEN(7)
             DCL        VAR(&Y2)        TYPE(*CHAR) LEN(7)
             DCL        VAR(&FWLFIRM) TYPE(*CHAR) LEN(01)
             DCL        VAR(&CODE) TYPE(*CHAR) LEN(01)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(10)
/* &CTL      CTL     'B'= BILDSCHIRM, ELSE DRUCKER   */
             DCL        VAR(&CTL) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&TAS0001C) TYPE(*CHAR) LEN(1)
             DCL        VAR(&INFO01) TYPE(*CHAR) LEN(132) VALUE(' ')
             DCL        VAR(&MELDUNG) TYPE(*CHAR) LEN(132)
             DCL        VAR(&MELDUNG2) TYPE(*CHAR) LEN(132)
             DCL        VAR(&DATMOD)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&RTNCOD)  TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&SYSGES)  TYPE(*CHAR) LEN(26)
             DCL        VAR(&SYSDAT)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&SYSZEI)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
/*    *     PRÜFUNG                                                          */
             RTVDTAARA  DTAARA(SUBR36/SICHERPER) RTNVAR(&SICHERPER)
             MONMSG     MSGID(CPF0000)
             IF         COND(&SICHERPER = '1') THEN(DO)
                 GOTO       CMDLBL(ENDJOB)
             ENDDO
             RTVDTAARA  DTAARA(TAS0001C) RTNVAR(&TAS0001C)
             IF         COND(&TAS0001C = '1') THEN(DO)
                 GOTO       CMDLBL(ENDJOB)
             ENDDO
             CHGDTAARA  DTAARA(TAS0001C) VALUE('1')
/*----------------------------------------------------------------------------*/
/*    *     KURSE NOCHMALS AKTUALISIEREN                                     */
             CALL       PGM(SUBR36/#UPDWHRGC)
             MONMSG     MSGID(CPF0000)
/*----------------------------------------------------------------------------*/
/*    *     PROTOKOLL ZEITEN START                                           */
             CHGVAR     VAR(&DATMOD) VALUE('*JMT4')
             CALL       PGM(SUBR36/#DATAKTR) PARM(&DATMOD &RTNCOD +
                          &SYSGES &SYSDAT &SYSZEI)
             CHGVAR     VAR(&MELDUNG2) VALUE('Aktualisierung +
                          gestartet am: ')
             CHGVAR     VAR(%SST(&MELDUNG2 031 08)) VALUE(&SYSDAT)
             CHGVAR     VAR(%SST(&MELDUNG2 041 08)) VALUE(&SYSZEI)
             RTVJOBA    USER(&USER)
             CHGVAR     VAR(%SST(&MELDUNG2 122 10)) VALUE(&USER)
/*----------------------------------------------------------------------------*/
             RTVDTAARA  DTAARA(*LDA (954 10)) RTNVAR(&MSGPGM)
/*           IF         COND(&MSGPGM= '          ') THEN(DO)     */
                CALL       PGM(##SVRLDA) PARM('S')
                CHGDTAARA  DTAARA(*LDA (954 10)) VALUE(ARCHIVC)
                CHGVAR     VAR(&LDAS) VALUE('S')
                CALL       PGM(#DEFLDA) PARM(' ')
/*           ENDDO                                               */
/*----------------------------------------------------------------------------*/
             RTVDTAARA  DTAARA(BASISJA)          RTNVAR(&BASISJA)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                GOTO       CMDLBL(ENDE)
             ENDDO
             CHGVAR     VAR(&X) VALUE(&BASISJA)

             CLRPFM     FWLGSMLIB/ARCHIV_EK
             MONMSG     MSGID(CPF0000)
/*----------------------------------------------------------------------------*/
SCHILLING:
             RTVDTAARA  DTAARA(FWLFIRM (1 1)) RTNVAR(&FWLFIRM)
             MONMSG     MSGID(CPF0000) EXEC(DO)
/*             AUFRUF DER ÄNDERUNGEN IN TIM FÜR SCHILLING                    */
/*             SCHNITTSTELLE WIRD GEFÜLLT UND PRINTING ERZEUGT               */
/*             ÜBER STANDARDDRUCKER DES JOBEIGNERS                           */
                CRTDTAARA  DTAARA(QTEMP/FWLFIRM) TYPE(*CHAR) LEN(2)
                CALL       PGM(#LIBNEUC) PARM('L' 'P')
                RTVDTAARA  DTAARA(FWLFIRM (1 1)) RTNVAR(&FWLFIRM)
/*             *******************************************************       */
                CALL       PGM(DRUCK_R) PARM(&PRT)
                MONMSG     MSGID(CPF0000)
/*              -CALL AUF DRUCKSTEUERPROGRAMM---==> START---------------------*/
                CALL       PGM(PRTCTL) PARM(&PRT 'GER0260P ' &CTL +
                          '*NO ' '1')
                CALL       PGM(PRTCTL) PARM(&PRT 'GER2130P ' &CTL +
                          '*NO ' '1')
                CALL       PGM(PRTCTL) PARM(&PRT 'GER0160P ' &CTL +
                          '*NO ' '1')
/*             *******************************************************       */
                CALL       PGM(GER010)
                CALL       PGM(GER020)
                CALL       PGM(GER210)
/*             ..                                                            */
                CALL       PGM(#CHGLIBL) PARM('D' 'P')
                RTVDTAARA  DTAARA(FWLFIRM (1 1)) RTNVAR(&FWLFIRM)
                CALL       PGM(GER010)
                CALL       PGM(GER020)
                CALL       PGM(GER210)
/*             *******************************************************       */
/*             -CALL AUF DRUCKSTEUERPROGRAMM---==> ENDE--------------*/
                CALL       PGM(PRTCTL) PARM(&PRT 'GER0260P ' &CTL +
                          '*NO ' '0')
                CALL       PGM(PRTCTL) PARM(&PRT 'GER2130P ' &CTL +
                          '*NO ' '0')
                CALL       PGM(PRTCTL) PARM(&PRT 'GER0160P ' &CTL +
                          '*NO ' '0')
/*             *******************************************************       */
             ENDDO
/*----------------------------------------------------------------------------*/
      /*     RTVDTAARA  DTAARA(FWLFIRM (1 1)) RTNVAR(&FWLFIRM)      */
      /*     MONMSG     MSGID(CPF0000) EXEC(DO)                     */
/*             DER JOB BEFINDET SICH DANN IN DER REGEL IM BATCH              */
/*             START MIT LINGEN UMGEBUNG ??                                  */
      /*        CRTDTAARA  DTAARA(QTEMP/FWLFIRM) TYPE(*CHAR) LEN(2) */
                CALL       PGM(#CHGLIBL) PARM('L' 'P')
      /*        CALL       PGM(#LIBNEUC) PARM('L' '2') */
                RTVDTAARA  DTAARA(FWLFIRM (1 1)) RTNVAR(&FWLFIRM)
      /*     ENDDO                                             */

             RTVDTAARA  DTAARA(FWLFIRM (1 1)) RTNVAR(&FWLFIRM)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             GOTO       CMDLBL(ENDE)
             ENDDO

/*----------------------------------------------------------------------------*/
START:
/*    *     SYSGES: 20050322090226                                           */
/*    *     SYSDAT: 20050322                                                 */
/*    *     SYSZEI: 090226                                                   */
             CHGVAR     VAR(&DATMOD) VALUE('*JMT4')
             CALL       PGM(SUBR36/#DATAKTR) PARM(&DATMOD &RTNCOD +
                          &SYSGES &SYSDAT &SYSZEI)
             CHGVAR     VAR(&MELDUNG) VALUE('Aktualisierung +
                          gestartet für:  ' *CAT &FWLFIRM)
             CHGVAR     VAR(%SST(&MELDUNG 035 08)) VALUE(&SYSDAT)
             CHGVAR     VAR(%SST(&MELDUNG 045 08)) VALUE(&SYSZEI)
             CHGDTAARA  DTAARA(SUBR36/INFO01) VALUE(&MELDUNG)

/*    *     AKTUALISIERUNG DER DATENBANKEN FÜR SCHILLING                     */
/*    *     BUCHHALTUNG UND BANKENACCOUNTING                                 */
             IF         COND(&FWLFIRM *EQ 'L') THEN(DO)
    /*          CALL       PGM(*LIBL/SFBF001C)        */
    /*          MONMSG     MSGID(CPF0000)             */
             ENDDO
/*    *     ...                                                              */
             IF         COND(&FWLFIRM *EQ 'D') THEN(DO)
                CALL       PGM(BOARD/BOARD0020C)
                MONMSG     MSGID(CPF0000)
             ENDDO
/*    *     ...                                                              */
             IF         COND(&FWLFIRM *EQ 'L') THEN(DO)
                CALL       PGM(BOARD/BOARD0030C)
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&FWLFIRM *EQ 'L') THEN(DO)
/*    *        LÖSCHEN ÄLTERER PRODUKTIONSAUFTRÄGE IN LINGEN                 */
/*    *        ALLE PRODUKTIONSAUFTRÄGE, DIE ÄLTER ALS DAS AKTUELLE          */
/*    *        DATUM SIND, WERDEN GELÖSCHT ÜBER TIM-STANDARDPROGRAMM         */
                CALL       PGM(UEBERNAHME/PROD002C)
                MONMSG     MSGID(CPF0000)
             ENDDO
/*          HEISTER PROGRAMM SONSTIES  DORMAGEN                              */
/*                                                                           */
/*-ENVIRONMENT ANPASSEN BZW ERSTELLEN-----------------------------------------*/
             ADDLIBLE   LIB(FWLFR)      POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR3) +
                          VALUE('1'))
/*                                                                           */
/*          --------------------------------------------                     */
             CHGVAR     VAR(&Y)              VALUE(&BASISJA)
             CHGVAR     VAR(&Y2) VALUE(&Y)
             CHGVAR     VAR(%SST(&Y2 6 02)) VALUE('01')
/*          TRANSPORTVERSICHERUNG AKTUALISIEREN                              */
/*          AKTUELLER MONAT AUS BASISJA - 0 MONAT                            */
/*          DIE GESAMTEN UMSÄTZE WERDEN IN DER DATEI TRVPROZPF               */
/*          ABGELEGT                                                         */
             CALL       PGM(FWLFR/AVIS00070R) PARM('FRAFIN' &Y2 '00')
/*          DRALON_KOSTEN NUR FÜR LINGEN                                     */
/*          AKTUELLER MONAT AUS BASISJA - 0 MONAT                            */
/*          DIE GESAMTEN UMSÄTZE WERDEN IN DER DATEI TRVPROZPF               */
/*          ABGELEGT                                                         */
             IF         COND(&FWLFIRM *EQ 'L') THEN(DO)
                CHGVAR     VAR(&Y2) VALUE(&Y)
                CHGVAR     VAR(%SST(&Y2 6 02)) VALUE('01')
                CALL    PGM(FWLFR/AVIS00070R) PARM('DRALON' &Y2 '00')
             ENDDO
             CHGVAR     VAR(&Y2) VALUE(&Y)
             CHGVAR     VAR(%SST(&Y2 6 02)) VALUE('01')
/*          TRANSPORTVERSICHERUNG AKTUALISIEREN                              */
/*          AKTUELLER MONAT AUS BASISJA - 1 MONAT                            */
/*          DIE GESAMTEN UMSÄTZE WERDEN IN DER DATEI TRVPROZPF               */
/*          ABGELEGT                                                         */
/*                                                */
        /*   CALL       PGM(FWLFR/AVIS00070R) PARM('FRAFIN' &Y2 '00')*/
/*          DRALON_KOSTEN NUR FÜR LINGEN                                     */
/*          AKTUELLER MONAT AUS BASISJA - 1 MONAT                            */
/*          DIE GESAMTEN UMSÄTZE WERDEN IN DER DATEI TRVPROZPF               */
/*          ABGELEGT                                                         */
             IF         COND(&FWLFIRM *EQ 'L') THEN(DO)
                CHGVAR     VAR(&Y2) VALUE(&Y)
                CHGVAR     VAR(%SST(&Y2 6 02)) VALUE('01')
        /*      CALL    PGM(FWLFR/AVIS00070R) PARM('DRALON' &Y2 '01')*/
             ENDDO
/*                                                */
/*          SONDER UND MENGENRABATTE ABLEITEN IN BAB0888                     */
/*          AUTOMATISCHES ANLEGEN NEUER KUNDEN/ARTIKELKONSTELLATIONEN        */
             CALL       FWLFR/PRV0002C
             MONMSG     MSGID(CPF0000)
/*          --------------------------------------------                     */

/*          ÜBERNAHME NEUER KUNDEN IN FWLGSMLIB/KLIMITPF                     */
/*          AUS ANCLI00F                                                     */
             CALL       PGM(DUMMY512) PARM(&MD 'KVS0008' ' ' ' ' ' ' +
                          ' ' ' ')
             MONMSG     MSGID(CPF0000)

/*          SCHILLING SCHNITTSTELLE FWLGSMLIB/W§BAB570 ERSTELLEN             */
/*          VORHER WERDEN DIE NEUEN SÄTZE WEGEN AKTUALISIERUNG               */
/*          IN KVS01C GELÖSCHT                                               */
/*          SOWIE DIE VERBINDLICHKEITSUMGEBUNG W$BAB580                      */
/*          VORHER PRÜFEN OB JOB IN SASBATCH (TAGESABSCHLUß                  */
/*          SCHILLING ODER SONSTIGER JOB AKTIV)                              */
    /*           CHGVAR     VAR(%SST(&MD 1 01))   VALUE('2')    */
    /*           CHGVAR     VAR(%SST(&MD 2 07)) VALUE(&X)       */
JOB:
             CALL       PGM(#SASBATCH) PARM(&CODE)
             IF         COND(&CODE = '1') THEN(DO)
                DLYJOB     DLY(20)
                GOTO       CMDLBL(JOB)
             ENDDO
             CALL       PGM(KVS01C)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(KVS02C)
             MONMSG     MSGID(CPF0000)
/*                                                */
/*          LÖSCHEN DER SÄTZTE, DIE GLEICH ODER GRÖßER BASISJA SIND          */
/*          IN ABHÄNGIGKEIT DER FIRMA (AUCH IN FWLGSMLIB)                    */
             CALL       FWLFR/BAB5575R
/*                                                                           */
/*          LIBLIST ÄNDERN                                                   */
             ADDLIBLE   LIB(SFBF)      POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))
             ADDLIBLE   LIB(FWLGSMLIB)  POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))
/*                                                */
/*          ARCHIV EINKAUF ABLEITEN                                          */
             CALL       A0010R
             MONMSG     MSGID(CPF0000)
/*                                                                           */
/*          INVOICES ABLEITEN  + OFFENE POSTEN KUNDENORDER ABLEITEN          */
             CALL       A0001C
             MONMSG     MSGID(CPF0000)
/*                                                */
/*          RABATTE UND BONI-SÄTZE ABLEITEN                                  */
             CALL       PGM(PRTCTL) PARM(&PRT 'QPQUPRFIL' &CTL +
                          '*NO ' '1')
             CALL       PGM(FWLFR/PRV0002C)
             CALL       PGM(PRTCTL) PARM(&PRT 'QPQUPRFIL' &CTL +
                          '*NO ' '0')
/*                                                */
             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(FWLGSMLIB)
             ENDDO
/*                                                */
/*          ÜBERNAHME IN FWLGSMLIB                                           */
/*           EVTL ÜBER OVR                        */
/*                                                */
/*          ----------------------------------------------------------       */
             DLTOVR     FILE(*ALL) LVL(*)
             MONMSG     MSGID(CPF0000)
/*                                                */
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(SFBF)
             ENDDO
/*                                                */
/*          KREDITVERSICHERUNG BEI PERIODENWECHSEL                           */
/*          HIER GILT IMMER NOCH L_KKT_A UND D_KKT_A WEITERE                 */
/*          STEUERUNG DANN ÜBER #BABCTLF                                     */
             CALL       PGM(FWLFR/BAB5576R) PARM('H')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(FWLFR/BAB5576R) PARM('G')
             MONMSG     MSGID(CPF0000)
/*                                                */
/*          AUFRUFE SONSTIGER PROGRAMME UBER #BABCTLF GESTEUERT              */
/*          HIER JETZT TAGESDATUM/MONATSWECHSEL (PARAMETER '1')              */
/*          ACHTUNG ! DADURCH ERFOLGT TÄGLICHER AUFRUF ALLER                 */
/*          FUNKTIONEN                                                       */
/*          -SICHERUNG DER FWLGSMLIB/W§BAB57F                                */
/*          -FESTTELLEN, WELCHE AUSGANSRECHNUNGEN IN SCHILLING FEHLEN        */
/*          -BAB460 EINZELSATZAUSWERTUNG ERZEUGEN                            */
             CALL       PGM(FWLFR/BAB5578R) PARM('1')
/*                                                                           */
/*             ERNEUTES LADEN MIT DORMAGEN UMGEBUNG M                        */
             IF         COND(&FWLFIRM *EQ 'L') THEN(DO)
                CALL       PGM(#CHGLIBL) PARM('D' 'P')
                RTVDTAARA  DTAARA(FWLFIRM (1 1)) RTNVAR(&FWLFIRM)
                GOTO       CMDLBL(START)
             ENDDO
             GOTO       CMDLBL(NACHTRAG)

/*----------------------------------------------------------------------------*/
NACHTRAG:
/*          ARCHIVK1/K2/K3 AUFBAUEN                                          */
             CALL       PGM(FWLFR/ARCHIVK1) PARM('       ')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(FWLFR/ARCHIVK2) PARM('       ')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(FWLFR/ARCHIVK3) PARM('       ')
             MONMSG     MSGID(CPF0000)

             DLTDTAARA  DTAARA(QTEMP/FWLFIRM)
             MONMSG     MSGID(CPF0000)
/*                                                */
/*          ZULATO  AUFBAU FORDERUNGSMANAGEMENT                              */
/*          ACHTUNG PARAMETER Z WICHTIG                                      */
             CALL       PGM(FWLFR/BAB650C) PARM('GANG' ' ' 'D' '0' +
                          '       ' '00' '3' '      ' '   ' '13' +
                          'N' '   ' '  ' 'Z' 'J')
/*                                                */
             GOTO       CMDLBL(ENDE)
/*                                                */
ENDE:
             IF         COND(&ERROR3 = '0') THEN(DO)
                RMVLIBLE   LIB(FWLFR)
             ENDDO
             CALL       PGM(#LIBALTC)
             CALL       PGM(##SVRLDA) PARM('R')
             CLRLIB     LIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(SUBR36/#DATAKTR) PARM(&DATMOD &RTNCOD +
                          &SYSGES &SYSDAT &SYSZEI)
             CHGVAR     VAR(%SST(&MELDUNG 055 08)) VALUE(&SYSDAT)
             CHGVAR     VAR(%SST(&MELDUNG 065 08)) VALUE(&SYSZEI)
             CHGDTAARA  DTAARA(SUBR36/INFO01) VALUE(&MELDUNG)
/*    *     SPOOLBEREINIGUNG AUFRUFEN                                        */
             CALL       PGM(#DLTSPLF0C)
             MONMSG     MSGID(CPF0000)
/*    *     PROTOKOLL ZEITEN ENDE                                            */
             CHGVAR     VAR(&DATMOD) VALUE('*JMT4')
             CALL       PGM(SUBR36/#DATAKTR) PARM(&DATMOD &RTNCOD +
                          &SYSGES &SYSDAT &SYSZEI)
             CHGVAR     VAR(%SST(&MELDUNG2 050 05)) VALUE('Ende:')
             CHGVAR     VAR(%SST(&MELDUNG2 056 08)) VALUE(&SYSDAT)
             CHGVAR     VAR(%SST(&MELDUNG2 066 08)) VALUE(&SYSZEI)
             CHGDTAARA  DTAARA(SUBR36/INFO01) VALUE(&MELDUNG2)

       /*    DSPJOBLOG  OUTPUT(*PRINT)                   */
             CHGDTAARA  DTAARA(TAS0001C) VALUE('0')

             RCLRSC
ENDJOB:
             ENDPGM
