/*    * PROGRAMMNAME.:SCH0010C                                               */
/*    * FUNKTION.....:ARTYA00F AKTUALISIEREN                                 */
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
             DCL        VAR(&FWLFIRM) TYPE(*CHAR) LEN(01)
             DCL        VAR(&BASISJA) TYPE(*DEC) LEN(07) VALUE(9999999)
             DCL        VAR(&X) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
/*----------------------------------------------------------------------------*/
             RTVDTAARA  DTAARA(BASISJA)          RTNVAR(&BASISJA)
             CHGVAR     VAR(&X) VALUE(&BASISJA)
/*----------------------------------------------------------------------------*/
             RTVDTAARA  DTAARA(FWLFIRM (1 1)) RTNVAR(&FWLFIRM)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             GOTO       CMDLBL(ENDE)
             ENDDO
             IF         COND(&FWLFIRM *EQ 'D') THEN(DO)
             ENDDO
             IF         COND(&FWLFIRM *EQ 'L') THEN(DO)
             ENDDO
             IF         COND(&FWLFIRM *EQ 'D') THEN(DO)
                CHGVAR     VAR(%SST(&MD 9 1))   VALUE('2')
             ENDDO
             IF         COND(&FWLFIRM *EQ 'L') THEN(DO)
                CHGVAR     VAR(%SST(&MD 9 1))   VALUE('1')
             ENDDO
/*          INITIALISIERUNGSROUTINEN                                         */
             CALL       PGM(SCH0002C) PARM('99999999999999999999')
             MONMSG     MSGID(CPF0000)
/*          PRODUKTIONSDATEN, WENN PRODUKTIONSAUFTRAG VORHANDEN!             */
             CALL       PGM(DUMMY512) PARM(&MD 'SCH0030' ' ' ' ' +
                          'SCH0030' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*          ERMITTLUNG DER DOPPELTEN KOMBINATIONEN                           */
/*          1 F_ARTIKEL > 1 S-ARTIKEL ( NUR ARTIKEL OHNE MENGEN )            */
             CALL       PGM(DUMMY512) PARM(&MD 'SCH0035' ' ' ' ' +
                          'SCH0035' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*          ERMITTLUNG DER DOPPELTEN KOMBINATIONEN                           */
/*          1 F_ARTIKEL > 1 S-ARTIKEL ( ARTIKEL UND MENGEN )                 */
             CALL       PGM(DUMMY512) PARM(&MD 'SCH0040' ' ' ' ' +
                          'SCH0040' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*          ERMITTLUNG DER DOPPELTEN KOMBINATIONEN                           */
/*          AUS ARTYA00F(SCH0002)                                            */
/*          1 F_ARTIKEL > 1 S-ARTIKEL ( ARTIKEL OHNE MENGEN )                */
             CALL       PGM(DUMMY512) PARM(&MD 'SCH0045' ' ' ' ' +
                          'SCH0045' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*          ERMITTLUNG DER DOPPELTEN KOMBINATIONEN                           */
/*          AUS ARTYA00F(SCH0002)                                            */
/*          1 F_ARTIKEL > 1 S-ARTIKEL ( ARTIKEL MIT PROZENTEN)               */
             CALL       PGM(DUMMY512) PARM(&MD 'SCH0050' ' ' ' ' +
                          'SCH0050' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(SCH0010R)
             MONMSG     MSGID(CPF0000)
/*                                                */
ENDE:
             RCLRSC
             ENDPGM
