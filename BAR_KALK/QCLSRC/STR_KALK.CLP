/*    * PROGRAMMNAME.:STR_KALK                                               */
/*    * FUNKTION.....:KALKULATIONSVERARBEITUNG                               */
/*    *               PARM = 0 = AUFBAU DER KALKULATION NACH VERSION         */
/*    *                          DIE VERSION ERFOLGT ÜBER DIE DTAARA         */
/*    *                          UND NICHT ÜBER DEN PARAMETER.               */
/*    *                                                                      */
/*    *               PARM = 1 = LISTEN UND DATEIEN WERDEN GENERIERT         */
/*    *                          DIE VERSION ERFOLGT ÜBER DIE DTAARA         */
/*    *                          UND NICHT ÜBER DEN PARAMETER.               */
/*    *                                                                      */
/*    *               PARM = 2 = AUSGABE FÜR ARTIKELUPDATE                   */
/*    *                          DIE VERSION ERFOLGT ÜBER DIE DTAARA         */
/*    *                          UND NICHT ÜBER DEN PARAMETER.               */
/*    *               PARM = 3 = EXN 70XXX  E X N                            */
/*    *                          DIE VERSION ERFOLGT ÜBER DIE DTAARA         */
/*    *                          UND NICHT ÜBER DEN PARAMETER.               */
/*    *               PARM = 4 = EXN 72XXX  I C N                            */
/*    *                          DIE VERSION ERFOLGT ÜBER DIE DTAARA         */
/*    *                          UND NICHT ÜBER DEN PARAMETER.               */
/*    *               PARM = 5 = EXN 73XXX  I C S                            */
/*    *                          DIE VERSION ERFOLGT ÜBER DIE DTAARA         */
/*    *                          UND NICHT ÜBER DEN PARAMETER.               */
/*    *               PARM = 6 = EXN 74XXX  E X S                            */
/*    *                          DIE VERSION ERFOLGT ÜBER DIE DTAARA         */
/*    *                          UND NICHT ÜBER DEN PARAMETER.               */
/*    *               PARM = 7 = EXN 75XXX  O E M                            */
/*    *                          DIE VERSION ERFOLGT ÜBER DIE DTAARA         */
/*    *                          UND NICHT ÜBER DEN PARAMETER.               */
/*    *               PARM = 8 = PREISE EINZELNER KUNDEN ÜBER                */
/*    *                          GANG/E_PREISE#1                             */
/*    *               PARM = 9 = AUFBAU DER WAECOLCP                         */
/*    *                          DIE VERSION ERFOLGT ÜBER DIE DTAARA         */
/*    *                          UND NICHT ÜBER DEN PARAMETER.               */
/*    *               PARM = A = LISTEN/DATEIEN                              */
/*    *                                                                      */
/*    *               PARM = B = PREISE FÜR ARTIKELSTAMM ÜBER                */
/*    *                          GANG/A_PREISE#1                             */
/*    *               PARM = # = INTEGRIEREN NEUE ARTIKEL IN PREIS-          */
/*    *                          DATEI                                       */
/*    *                          - ES WERDEN NUR SÄTZE VERARBEITET,          */
/*    *                            DIE JÜNGER/GLEICH SIND ALS DAS            */
/*    *                            VERGLEICHSDATUM DATUM_AB AUS              */
/*    *                            *DTAARA                                   */
/*    *                          - VERSION WIRD FIXIERT ##########           */
/*    *                                                                      */
/*    * DEZEMBER 2010                                                         */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&PARM)

             DCL        VAR(&PARM)     TYPE(*CHAR) LEN(01)
             DCL        VAR(&VERSION)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WAECOLCP) TYPE(*CHAR) LEN(01)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR3)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR4)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&OUTFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)
             DCL        VAR(&DATUM_AB) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&D_AB)     TYPE(*CHAR) LEN(8)
             DCL        VAR(&VON) TYPE(*DEC) LEN(6 0) VALUE(010110)
             DCL        VAR(&BIS) TYPE(*DEC) LEN(6 0) VALUE(310311)
             DCL        VAR(&NBRCURRCD) TYPE(*DEC) LEN(10)

             DCLF       FILE(bar_kalk/P_KUNDE)

             RTVDTAARA  DTAARA(VERSION) RTNVAR(&VERSION)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDPGM))
             RTVDTAARA  DTAARA(WAECOLCP) RTNVAR(&WAECOLCP)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDPGM))

             RTVDTAARA  DTAARA(VERSION) RTNVAR(&VERSION)
             IF         COND(&VERSION = '          ') THEN(DO)
                GOTO       CMDLBL(ENDPGM)
             ENDDO

             ADDLIBLE   LIB(BAR_KALK) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))
             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))
             ADDLIBLE   LIB(DATENKW) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR3) +
                          VALUE('1'))
             ADDLIBLE   LIB(TVRELWAECO) POSITION(*AFTER TFXF)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR4) +
                          VALUE('1'))

/*             TEEW UPDATEN                                                  */
                CALL       PGM(DUMMY512) PARM(&MD '#KW0100' ' ' ' ' +
                             ' ' ' ' ' ')
                MONMSG     MSGID(CPF0000)

             IF         COND(&PARM = '0' *OR &PARM = '#') THEN(DO)
/* Kalkulationsdateien leeren */
/*      ES EXISTIEREN UNTERSCHIEDLICHE VERSIONEN IN BAR_KALK/KALK_FILE       */
         /*     CLRPFM     FILE(BAR_KALK/KALK_FILE)    */
                CLRPFM     FILE(BAR_KALK/KALK_FILES)

                CALL       PGM(DUMMY512) PARM(&MD '#KA0290' ' ' ' ' +
                             '#KA0290' 'BAR_KALK' '*REPLACE')
                CLRPFM     FILE(#KA0290L1)
                MONMSG     MSGID(CPF0000)
/*             INDEX LEGEN AUF UMSÄTZE/ABSÄTZE                               */
                CALL       PGM(DUMMY512) PARM(&MD '#KP0291' ' ' ' ' +
                             ' ' ' ' '*REPLACE')

/*             MENGEN AUS LAGER HOLEN                                        */
                CALL       PGM(DUMMY512) PARM(&MD '#KP0105' ' ' ' ' +
                             '#KP0105' 'GANG' '*REPLACE')
                CLRPFM     FILE(#KP0105L1)
                MONMSG     MSGID(CPF0000)
/*             INDEX LEGEN AUF ARTIKEL UND LAGER                             */
                CALL       PGM(DUMMY512) PARM(&MD '#KP0107' ' ' ' ' +
                             ' ' ' ' '*REPLACE')

/* Kalkulation ausführen */
                IF         COND(&PARM = '0') THEN(DO)
                   CALL       PGM(BAR_KALK/KALK) PARM(&VERSION)
                enddo
                IF         COND(&PARM = '#') THEN(DO)
                   CALL       PGM(BAR_KALK/KALK) PARM('##########')
                enddo
             enddo

             IF         COND(&PARM = '1') THEN(DO)
                CHGDTAARA  DTAARA(VERSION) VALUE(&VERSION)
                MONMSG     MSGID(CPF0000)
                CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&VERSION)
/*             AUSGABE STANDARDDEFINITION FÜR PREISLISTE EXPORT              */
                CALL       PGM(DUMMY512) PARM(&MD '#KA0160' ' ' ' ' +
                             '#KA0160' 'GANG' '*REPLACE')
                MONMSG     MSGID(CPF0000)
                CHGVAR     VAR(&TXT) VALUE+
              ('STANDARDDEFINITION FÜR PREISLISTE EXPORT         ')
                CHGOBJD    OBJ(#KA0160) OBJTYPE(*FILE) TEXT(&TXT)
                MONMSG     MSGID(CPF0000)

/*             AUSGABE PREISLISTE FÜR PRÄSIDENTEN                            */
                CALL       PGM(DUMMY512) PARM(&MD '#KA0165' ' ' ' ' +
                             '#KA0165' 'GANG' '*REPLACE')
                MONMSG     MSGID(CPF0000)
                CHGVAR     VAR(&TXT) VALUE+
              ('AUSGABE PREISLISTE FÜR PRÄSIDENTEN               ')
                CHGOBJD    OBJ(#KA0165) OBJTYPE(*FILE) TEXT(&TXT)
                MONMSG     MSGID(CPF0000)

/*             PREISLISTE MIT ICN, EXS, EXN UND OEM                          */
                CALL       PGM(DUMMY512) PARM(&MD '#KA0170' ' ' ' ' +
                             '#KA0170' 'GANG' '*REPLACE')
                MONMSG     MSGID(CPF0000)
                CHGVAR     VAR(&TXT) VALUE+
              ('PREISLISTE MIT ICN, EXS, EXN UND OEM             ')
                CHGOBJD    OBJ(#KA0170) OBJTYPE(*FILE) TEXT(&TXT)
                MONMSG     MSGID(CPF0000)

/*             PREISLISTE FÜR MARKETING                                      */
                CALL       PGM(DUMMY512) PARM(&MD '#KA0180' ' ' ' ' +
                             '#KA0180' 'GANG' '*REPLACE')
                MONMSG     MSGID(CPF0000)
                CHGVAR     VAR(&TXT) VALUE+
              ('PREISLISTE FÜR MARKETING                         ')
                CHGOBJD    OBJ(#KA0180) OBJTYPE(*FILE) TEXT(&TXT)
                MONMSG     MSGID(CPF0000)

/*             VB-A THOMAS BRUNNE                                            */
                CALL       PGM(DUMMY512) PARM(&MD '#KA0190' ' ' ' ' +
                             '#KA0190' 'GANG' '*REPLACE')
                MONMSG     MSGID(CPF0000)
                CHGVAR     VAR(&TXT) VALUE+
              ('VB-A THOMAS BRUNNE                               ')
                CHGOBJD    OBJ(#KA0190) OBJTYPE(*FILE) TEXT(&TXT)
                MONMSG     MSGID(CPF0000)

/*             MARINE UND KALKULATION IN #KA0200                             */
                CLRPFM     FILE(#KA0200)
                MONMSG     MSGID(CPF0000)
                CALL       PGM(KALKMARINE) PARM(&VERSION)
                MONMSG     MSGID(CPF0000)
                CHGVAR     VAR(&TXT) VALUE+
              ('MARINE UND KALKULATION IN #KA0200                ')
                CHGOBJD    OBJ(#KA0200) OBJTYPE(*FILE) TEXT(&TXT)
                MONMSG     MSGID(CPF0000)

/*             LISTE FÜR THOMAS FELD                                         */
                CALL       PGM(DUMMY512) PARM(&MD '#KA0210' ' ' ' ' +
                             '#KA0210' 'GANG' '*REPLACE')
                MONMSG     MSGID(CPF0000)
                CHGVAR     VAR(&TXT) VALUE+
              ('LISTE FÜR THOMAS FELD                            ')
                CHGOBJD    OBJ(#KA0210) OBJTYPE(*FILE) TEXT(&TXT)
                MONMSG     MSGID(CPF0000)

/*             LISTE FÜR KONERT                                              */
                CHGVAR     VAR(%SST(&MD 11 01)) VALUE('1')
                CALL       PGM(DUMMY512) PARM(&MD '#KA0220' ' ' ' ' +
                             '#KA0221' 'GANG' '*REPLACE')
                MONMSG     MSGID(CPF0000)
                CHGVAR     VAR(&TXT) VALUE+
              ('LISTE FÜR KONERT                                 ')
                CHGOBJD    OBJ(#KA0221) OBJTYPE(*FILE) TEXT(&TXT)
                MONMSG     MSGID(CPF0000)

/*             LISTE FÜR WESTENDARP                                          */
                CHGVAR     VAR(%SST(&MD 11 01)) VALUE('2')
                CALL       PGM(DUMMY512) PARM(&MD '#KA0220' ' ' ' ' +
                             '#KA0222' 'GANG' '*REPLACE')
                MONMSG     MSGID(CPF0000)
                CHGVAR     VAR(&TXT) VALUE+
              ('LISTE FÜR WESTENDARP                             ')
                CHGOBJD    OBJ(#KA0222) OBJTYPE(*FILE) TEXT(&TXT)
                MONMSG     MSGID(CPF0000)

/*             LISTE FÜR ERDMANN                                             */
                CHGVAR     VAR(%SST(&MD 11 01)) VALUE('3')
                CALL       PGM(DUMMY512) PARM(&MD '#KA0220' ' ' ' ' +
                             '#KA0223' 'GANG' '*REPLACE')
                MONMSG     MSGID(CPF0000)
                CHGVAR     VAR(&TXT) VALUE+
              ('LISTE FÜR ERDMANN                                ')
                CHGOBJD    OBJ(#KA0223) OBJTYPE(*FILE) TEXT(&TXT)
                MONMSG     MSGID(CPF0000)

/*             LISTE FÜR LUETJEN                                             */
                CHGVAR     VAR(%SST(&MD 11 01)) VALUE('4')
                CALL       PGM(DUMMY512) PARM(&MD '#KA0220' ' ' ' ' +
                             '#KA0224' 'GANG' '*REPLACE')
                MONMSG     MSGID(CPF0000)
                CHGVAR     VAR(&TXT) VALUE+
              ('LISTE FÜR LUETJEN                                ')
                CHGOBJD    OBJ(#KA0224) OBJTYPE(*FILE) TEXT(&TXT)
                MONMSG     MSGID(CPF0000)

/*             LISTE FÜR TUFAN                                               */
                CHGVAR     VAR(%SST(&MD 11 01)) VALUE('7')
                CALL       PGM(DUMMY512) PARM(&MD '#KA0220' ' ' ' ' +
                             '#KA0227' 'GANG' '*REPLACE')
                MONMSG     MSGID(CPF0000)
                CHGVAR     VAR(&TXT) VALUE+
              ('LISTE FÜR TUFAN                                  ')
                CHGOBJD    OBJ(#KA0227) OBJTYPE(*FILE) TEXT(&TXT)
                MONMSG     MSGID(CPF0000)

             enddo

             IF         COND(&PARM = '1') THEN(DO)
/*             AUSGABE PREISLISTEN FÜR KUNDEN/VERTRETER                      */
 LOOP:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDPGM))
             IF         COND(&FIRMA = '1' *AND &AKTIV = 'J') THEN(DO)
                CHGVAR     VAR(%SST(&OUTFILE 01 03)) VALUE('KD_')
                CHGVAR     VAR(%SST(&OUTFILE 04 05)) VALUE(&KUNDE)
                CHGVAR     VAR(%SST(&MD 01 05)) VALUE(%SST(&KUNDE +
                          01 05))
                CALL       PGM(DUMMY512) PARM(&MD '#KA0150' ' ' ' ' +
                             &OUTFILE  'GANG' '*REPLACE')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(DUMMY512) PARM(&MD '#KA0151' ' ' ' ' +
                             &OUTFILE 'GANG' '*ADD')
                MONMSG     MSGID(CPF0000)
                CHGVAR     VAR(&TXT) VALUE+
              ('LISTE FÜR:                                       ')
                CHGVAR     VAR(%SST(&TXT 15 05)) VALUE(&KUNDE)
                CHGOBJD    OBJ(&OUTFILE) OBJTYPE(*FILE) TEXT(&TXT)
                MONMSG     MSGID(CPF0000)

             ENDDO
             GOTO       CMDLBL(LOOP)
             ENDDO

             IF         COND(&PARM = '2') THEN(DO)
/*             ABLEITUNG DER PREISE FÜR ARTIKELSTAMMAKTUALISIERUNG           */
                RTVDTAARA  DTAARA(VERSION) RTNVAR(&VERSION)
                CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&VERSION)
                CALL       PGM(DUMMY512) PARM(&MD '#PR0150' ' ' ' ' +
                             'A_PREIS' 'BAR_KALK' '*ADD')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(SBGART00_P) PARM('               ' ' ')
                MONMSG     MSGID(CPF0000)
             ENDDO

             IF         COND(&PARM = '3') THEN(DO)
/*             ABLEITUNG DER PREISE FÜR SBGPRS00 HIER EXN 70XXX              */
                RTVDTAARA  DTAARA(VERSION) RTNVAR(&VERSION)
                CHGVAR     VAR(%SST(&MD 11 06)) VALUE(&VON)
                CHGVAR     VAR(%SST(&MD 17 06)) VALUE(&BIS)
                CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&VERSION)
                CALL       PGM(DUMMY512) PARM(&MD '#PR0160' ' ' ' ' +
                             'E_PREIS' 'BAR_KALK' '*ADD')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(SBGPRS00_P) PARM('70XXX' ' ')
                MONMSG     MSGID(CPF0000)
             ENDDO

             IF         COND(&PARM = '4') THEN(DO)
/*             ABLEITUNG DER PREISE FÜR SBGPRS00 HIER ICN 72XXX              */
                RTVDTAARA  DTAARA(VERSION) RTNVAR(&VERSION)
                CHGVAR     VAR(%SST(&MD 11 06)) VALUE(&VON)
                CHGVAR     VAR(%SST(&MD 17 06)) VALUE(&BIS)
                CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&VERSION)
                CALL       PGM(DUMMY512) PARM(&MD '#PR0161' ' ' ' ' +
                             'E_PREIS' 'BAR_KALK' '*ADD')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(SBGPRS00_P) PARM('72XXX' ' ')
                MONMSG     MSGID(CPF0000)
             ENDDO

             IF         COND(&PARM = '5') THEN(DO)
/*             ABLEITUNG DER PREISE FÜR SBGPRS00 HIER ICS 73XXX              */
                RTVDTAARA  DTAARA(VERSION) RTNVAR(&VERSION)
                CHGVAR     VAR(%SST(&MD 11 06)) VALUE(&VON)
                CHGVAR     VAR(%SST(&MD 17 06)) VALUE(&BIS)
                CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&VERSION)
                CALL       PGM(DUMMY512) PARM(&MD '#PR0162' ' ' ' ' +
                             'E_PREIS' 'BAR_KALK' '*ADD')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(SBGPRS00_P) PARM('73XXX' ' ')
                MONMSG     MSGID(CPF0000)
             ENDDO

             IF         COND(&PARM = '6') THEN(DO)
/*             ABLEITUNG DER PREISE FÜR SBGPRS00 HIER EXS 74XXX              */
                RTVDTAARA  DTAARA(VERSION) RTNVAR(&VERSION)
                CHGVAR     VAR(%SST(&MD 11 06)) VALUE(&VON)
                CHGVAR     VAR(%SST(&MD 17 06)) VALUE(&BIS)
                CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&VERSION)
                CALL       PGM(DUMMY512) PARM(&MD '#PR0163' ' ' ' ' +
                             'E_PREIS' 'BAR_KALK' '*ADD')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(SBGPRS00_P) PARM('74XXX' ' ')
                MONMSG     MSGID(CPF0000)
             ENDDO

             IF         COND(&PARM = '7') THEN(DO)
/*             ABLEITUNG DER PREISE FÜR SBGPRS00 HIER OEM 75XXX              */
                RTVDTAARA  DTAARA(VERSION) RTNVAR(&VERSION)
                CHGVAR     VAR(%SST(&MD 11 06)) VALUE(&VON)
                CHGVAR     VAR(%SST(&MD 17 06)) VALUE(&BIS)
                CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&VERSION)
                CALL       PGM(DUMMY512) PARM(&MD '#PR0164' ' ' ' ' +
                             'E_PREIS' 'BAR_KALK' '*ADD')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(SBGPRS00_P) PARM('75XXX' ' ')
                MONMSG     MSGID(CPF0000)
             ENDDO

             IF         COND(&PARM = '8') THEN(DO)
/*             ABLEITUNG DER PREISE FÜR SBGPRS00 HIER GANG/E_PREISE#1        */
               QSYS/RTVMBRD FILE(GANG/E_PREISE#1) NBRCURRCD(&NBRCURRCD)
               MONMSG     MSGID(CPF0000)
                IF         COND(&NBRCURRCD *NE 0) THEN(DO)
                   RTVDTAARA  DTAARA(VERSION) RTNVAR(&VERSION)
                   CHGVAR     VAR(%SST(&MD 11 06)) VALUE(&VON)
                   CHGVAR     VAR(%SST(&MD 17 06)) VALUE(&BIS)
                   CHGVAR     VAR(%SST(&MD 01 10)) VALUE('          ')
                   CALL      PGM(DUMMY512) PARM(&MD '#PR0100' ' ' ' ' +
                                'ACCESS' 'QTEMP' '*REPLACE')
                   MONMSG     MSGID(CPF0000)
                   CPYF       FROMFILE(QTEMP/ACCESS) TOFILE(E_PREIS) +
                              MBROPT(*ADD) FMTOPT(*MAP *DROP)
                   MONMSG     MSGID(CPF0000)
                   CALL       PGM(SBGPRS00_P) PARM('          ' ' ')
                   MONMSG     MSGID(CPF0000)
                   DLTF       FILE(GANG/E_PREISE#1)
                   MONMSG     MSGID(CPF0000)
                ENDDO
             ENDDO

             IF         COND(&PARM = '9') THEN(DO)
/*             AUFBAU DER WAECOLCP                                           */
                RTVDTAARA  DTAARA(VERSION) RTNVAR(&VERSION)
                CHGVAR     VAR(%SST(&MD 11 06)) VALUE(&VON)
                CHGVAR     VAR(%SST(&MD 17 06)) VALUE(&BIS)
                CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&VERSION)
                MONMSG     MSGID(CPF0000)
                CALL       PGM(WAECOLCP_P) PARM(&VERSION ' ' &WAECOLCP)
                MONMSG     MSGID(CPF0000)
             ENDDO

             IF         COND(&PARM = 'A') THEN(DO)
/*             LISTENABGLEICH FÜR KUNDEN AUS SBGPRS00                        */
 LOOP2:      RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDPGM))
             IF         COND(&FIRMA = '1' *AND &AKTIV = 'J') THEN(DO)
                CHGVAR     VAR(%SST(&OUTFILE 01 03)) VALUE('KL_')
                CHGVAR     VAR(%SST(&OUTFILE 04 05)) VALUE(&KUNDE)
                CHGVAR     VAR(%SST(&MD 01 05)) VALUE(%SST(&KUNDE +
                          01 05))
                CHGVAR     VAR(%SST(&MD 06 10)) VALUE(&VERSION)
                CALL       PGM(DUMMY512) PARM(&MD '#KA0230' ' ' ' ' +
                             &OUTFILE  'GANG' '*REPLACE')
                MONMSG     MSGID(CPF0000)
                CHGVAR     VAR(&TXT) VALUE+
              ('SBGPRS00:                                        ')
                CHGVAR     VAR(%SST(&TXT 15 05)) VALUE(&KUNDE)
                CHGOBJD    OBJ(&OUTFILE) OBJTYPE(*FILE) TEXT(&TXT)
                MONMSG     MSGID(CPF0000)

             ENDDO
             GOTO       CMDLBL(LOOP2)
             ENDDO

             IF         COND(&PARM = 'B') THEN(DO)
               QSYS/RTVMBRD FILE(GANG/A_PREISE#1) NBRCURRCD(&NBRCURRCD)
               MONMSG     MSGID(CPF0000)
                IF         COND(&NBRCURRCD *NE 0) THEN(DO)
/*                ABLEITUNG DER PREISE FÜR ARTIKELSTAMMAKTUALISIERUNG        */
                   CALL      PGM(DUMMY512) PARM(&MD '#PR0140' ' ' ' ' +
                                'A_PREIS' 'BAR_KALK' '*ADD')
                   MONMSG     MSGID(CPF0000)
                   CALL     PGM(SBGART00_P) PARM('               ' ' ')
                   MONMSG     MSGID(CPF0000)
                   DLTF       FILE(GANG/A_PREISE#1)
                   MONMSG     MSGID(CPF0000)
                ENDDO
             ENDDO

             IF         COND(&PARM = '#') THEN(DO)
/*             ABLEITUNG DER PREISE FÜR SBGPRS00 HIER EXN 70XXX              */
/*             ABLEITUNG DER PREISE FÜR SBGPRS00 HIER ICS 73XXX              */
/*             ABLEITUNG DER PREISE FÜR SBGPRS00 HIER EXS 74XXX              */
/*             ABLEITUNG DER PREISE FÜR SBGPRS00 HIER OEM 75XXX              */
                CHGVAR     VAR(%SST(&MD 11 06)) VALUE(&VON)
                CHGVAR     VAR(%SST(&MD 17 06)) VALUE(&BIS)
                CHGVAR     VAR(%SST(&MD 01 10)) VALUE('##########')
                CALL       PGM(DUMMY512) PARM(&MD '#PR0160' ' ' ' ' +
                             'E_PREIS' 'BAR_KALK' '*ADD')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(DUMMY512) PARM(&MD '#PR0162' ' ' ' ' +
                             'E_PREIS' 'BAR_KALK' '*ADD')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(DUMMY512) PARM(&MD '#PR0163' ' ' ' ' +
                             'E_PREIS' 'BAR_KALK' '*ADD')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(DUMMY512) PARM(&MD '#PR0164' ' ' ' ' +
                             'E_PREIS' 'BAR_KALK' '*ADD')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(SBGPRS00_P) PARM('          ' ' ')
                MONMSG     MSGID(CPF0000)
                RTVDTAARA  DTAARA(DATUM_AB) RTNVAR(&DATUM_AB)
                CHGVAR     VAR(&D_AB) VALUE(&DATUM_AB)
                CHGVAR     VAR(%SST(&MD 01 02)) VALUE('##')
                CHGVAR     VAR(%SST(&MD 03 08)) VALUE(&D_AB)
                CALL       PGM(DUMMY512) PARM(&MD '#KA0610' ' ' ' ' +
                             ' ' ' ' ' ')
                MONMSG     MSGID(CPF0000)
             ENDDO

 ENDPGM:
             RUNQRY QRY(HAUSE/KALK2011)
             MONMSG     MSGID(CPF0000)

             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(BAR_KALK)
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&ERROR3 = '0') THEN(DO)
                RMVLIBLE   LIB(DATENKW)
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&ERROR4 = '0') THEN(DO)
                RMVLIBLE   LIB(TVRELWAECO)
                MONMSG     MSGID(CPF0000)
             ENDDO

             ENDPGM
