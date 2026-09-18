/*    * PROGRAMMNAME.:SFB001C                                                */
/*    * FUNKTION.....:...                                                    */
/*    *               ...                                                    */
/*    * NOVEMBER 2000                                                         */
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
/*                                                              */
             DCL        VAR(&MODUS)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&DATMOD)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&RTNCOD)  TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&SYSGES)  TYPE(*CHAR) LEN(26)
             DCL        VAR(&SYSDAT)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&SYSZEI)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&L_HABU)  TYPE(*CHAR) LEN(48)
             DCL        VAR(&D_HABU)  TYPE(*CHAR) LEN(48)
             DCL        VAR(&FWLFIRM) TYPE(*CHAR) LEN(01)
             DCL        VAR(&BASISJA) TYPE(*DEC) LEN(07) VALUE(9999999)
             DCL        VAR(&X) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
/*----------------------------------------------------------------------------*/
             RTVDTAARA  DTAARA(BASISJA)          RTNVAR(&BASISJA)
             CHGVAR     VAR(&X) VALUE(&BASISJA)
             RTVDTAARA  DTAARA(L_HABU)           RTNVAR(&L_HABU)
             RTVDTAARA  DTAARA(D_HABU)           RTNVAR(&D_HABU)
/*----------------------------------------------------------------------------*/
             RTVDTAARA  DTAARA(FWLFIRM (1 1)) RTNVAR(&FWLFIRM)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             GOTO       CMDLBL(ENDE)
             ENDDO
             IF         COND(&FWLFIRM *EQ 'D') THEN(DO)
             ENDDO
             IF         COND(&FWLFIRM *EQ 'L') THEN(DO)
             ENDDO
/*-ENVIRONMENT ANPASSEN BZW ERSTELLEN-----------------------------------------*/
/*                                                */
             ADDLIBLE   LIB(BMAP0475L) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

/*                                                */
             ADDLIBLE   LIB(SFBF)      POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))

             IF         COND(&FWLFIRM *EQ 'D') THEN(DO)
                CHGVAR     VAR(%SST(&MD 9 1))   VALUE('2')
             ENDDO
             IF         COND(&FWLFIRM *EQ 'L') THEN(DO)
                CHGVAR     VAR(%SST(&MD 9 1))   VALUE('1')
             ENDDO
/*           LÖSCHEN DER AKTUELLEN MONATSDATEN    */
             CHGVAR     VAR(%SST(&MD 1 01))   VALUE('2')
             CHGVAR     VAR(%SST(&MD 2 07)) VALUE(&X)
             CHGVAR     VAR(%SST(&MD 1 02))   VALUE('20')
             CHGVAR     VAR(%SST(&MD 3 02)) VALUE(%SST(&X 2 6))
             CALL       PGM(#DEFLDA) PARM(' ')
             MONMSG     MSGID(CPF0000)
/*                                                */
/*          LÖSCHUNGEN FÜR NEUAUFBAU                                         */
             CLRPFM     FILE(UEBERNAHME/BANKENPF)
             MONMSG     MSGID(CPF0000)
/*                                                */
             CHGVAR     VAR(%SST(&MD 1 04)) VALUE(%SST(&L_HABU 41 4))
             CHGVAR     VAR(%SST(&MD 5 05)) VALUE('00001')
             CALL       PGM(DUMMY512) PARM(&MD 'ZUL0080' ' ' ' ' +
                          ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(&MD 'ZUL0081' ' ' ' ' +
                          ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(%SST(&MD 1 04)) VALUE(%SST(&D_HABU 41 4))
             CHGVAR     VAR(%SST(&MD 5 05)) VALUE('00002')
             CALL       PGM(DUMMY512) PARM(&MD 'ZUL0080' ' ' ' ' +
                          ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(&MD 'ZUL0081' ' ' ' ' +
                          ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
/*                                                */
/*                                                */
/*          AUFRUF NEUAUFBAU                                                 */
             CALL       PGM(SFBF001R)
             MONMSG     MSGID(CPF0000)
/*                                                */
/*          KONTEN     FRAVER EINZELSICHT                                    */
             CHGVAR     VAR(%SST(&MD 1 04)) VALUE(%SST(&L_HABU 41 4))
             CHGVAR     VAR(%SST(&MD 5 05)) VALUE('00001')
             CALL       PGM(DUMMY512) PARM(&MD 'ZUL0300' ' ' ' ' +
                          'KONTO' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(%SST(&MD 1 04)) VALUE(%SST(&D_HABU 41 4))
             CHGVAR     VAR(%SST(&MD 5 05)) VALUE('00002')
             CALL       PGM(DUMMY512) PARM(&MD 'ZUL0300' ' ' ' ' +
                          'KONTO' 'QTEMP' '*ADD')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(&MD 'ZUL0310' ' ' ' ' +
                          'ZUL0310' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*          S-KENNUNG AUF 6 UPDATE                                           */
             CALL       PGM(DUMMY512) PARM(&MD 'ZUL0311' ' ' ' ' +
                          ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
/*          ZUORDNUNGEN FRAVER HOLEN                                         */
             CALL       PGM(DUMMY512) PARM(&MD 'ZUL0315' ' ' ' ' +
                          'ZUL0315' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*          INTEGRATION                                                      */
             CALL       PGM(DUMMY512) PARM(&MD 'ZUL0313' ' ' ' ' +
                          'KONTENPF' 'UEBERNAHME' '*ADD')
             MONMSG     MSGID(CPF0000)
/*                                                */
             GOTO       ENDEX
/*                                                */
/*          KONTEN     KONTENEINZELSICHT                                     */
             CALL       PGM(DUMMY512) PARM(&MD 'ZUL0090' ' ' ' ' +
                          'KONTEN' 'UEBERNAHME' '*REPLACE')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(&MD 'ZUL0091' ' ' ' ' +
                          'KONTEN' 'UEBERNAHME' '*ADD')
             MONMSG     MSGID(CPF0000)
/*                                                */
/*          ERGEBNIS   ÜBER SFPOSTEN08 UND KONTENPF                          */
             CALL       PGM(DUMMY512) PARM(&MD 'ZUL0100' ' ' ' ' +
                          'ERGEBNIS' 'UEBERNAHME' '*REPLACE')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(&MD 'ZUL0101' ' ' ' ' +
                          'ERGEBNIS' 'UEBERNAHME' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          FRAVER     ÜBER SFPOSTEN02 UND KONTENPF                          */
             CALL       PGM(DUMMY512) PARM(&MD 'ZUL0110' ' ' ' ' +
                          'FRAVER' 'UEBERNAHME' '*REPLACE')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(&MD 'ZUL0111' ' ' ' ' +
                          'FRAVER' 'UEBERNAHME' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          GKV        ÜBER SFBIL02    UND KONTENPF                          */
             CALL       PGM(DUMMY512) PARM(&MD 'ZUL0120' ' ' ' ' +
                          'GKV' 'UEBERNAHME' '*REPLACE')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(&MD 'ZUL0121' ' ' ' ' +
                          'GKV' 'UEBERNAHME' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          UKV        ÜBER SFBIL01    UND KONTENPF                          */
             CALL       PGM(DUMMY512) PARM(&MD 'ZUL0130' ' ' ' ' +
                          'UKV' 'UEBERNAHME' '*REPLACE')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(&MD 'ZUL0131' ' ' ' ' +
                          'UKV' 'UEBERNAHME' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          ANHANG     ÜBER SFPOSTEN10 UND KONTENPF                          */
             CALL       PGM(DUMMY512) PARM(&MD 'ZUL0140' ' ' ' ' +
                          'ANHANG' 'UEBERNAHME' '*REPLACE')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(&MD 'ZUL0141' ' ' ' ' +
                          'ANHANG' 'UEBERNAHME' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          WIESBADEN  ÜBER SFPOSTEN09 UND KONTENPF                          */
             CALL       PGM(DUMMY512) PARM(&MD 'ZUL0150' ' ' ' ' +
                          'WIESBADEN' 'UEBERNAHME' '*REPLACE')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(&MD 'ZUL0151' ' ' ' ' +
                          'WIESBADEN' 'UEBERNAHME' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          ITALGAAP   ÜBER SFBIL03                                          */
/*                                                */
/*                                                */
ENDEX:
             DLTOVR     FILE(*ALL) LVL(*)
             MONMSG     MSGID(CPF0000)
             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(BMAP0475L)
             ENDDO
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(SFBF)
             ENDDO
/*                                                */
ENDE:
             RCLRSC
             ENDPGM
