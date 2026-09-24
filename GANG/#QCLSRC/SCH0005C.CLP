/*    * PROGRAMMNAME.:ÜBERNAHME ARTIKELDATEN                                 */
/*    * FUNKTION.....:INITIALISIEREN DER BEREICHE                            */
/*    * 06.07.98                                                              */
/*    *                                                                       */
/*    * Manfred Gang                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&DATE)

             DCL        VAR(&DATE) TYPE(*CHAR)  LEN(06)
             DCL        VAR(&ENV)  TYPE(*CHAR) LEN(01)
             DCL        VAR(&LIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TXT)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&MODUS)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&DATMOD)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&RTNCOD)  TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&SYSGES)  TYPE(*CHAR) LEN(26)
             DCL        VAR(&SYSDAT)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&SYSZEI)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&OBJ)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&FWLFIRM) TYPE(*CHAR) LEN(01)
             DCL        VAR(&UMGEB)   TYPE(*CHAR) LEN(01)
/*----------------------------------------------------------------------------*/
             RTVDTAARA  DTAARA(FWLFIRM (1 1)) RTNVAR(&FWLFIRM)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             GOTO       CMDLBL(ENDE)
             ENDDO
             RTVDTAARA  DTAARA(FWLFIRM (2 1)) RTNVAR(&UMGEB)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             GOTO       CMDLBL(ENDE)
             ENDDO
/*    *     SYSGES: 20050322090226                                           */
/*    *     SYSDAT: 20050322                                                 */
/*    *     SYSZEI: 090226                                                   */
             CHGVAR     VAR(&DATMOD) VALUE('*JMT4')
             CALL       PGM(SUBR36/#DATAKTR) PARM(&DATMOD &RTNCOD +
                          &SYSGES &SYSDAT &SYSZEI)
/*----------------------------------------------------------------------------*/
/* LIB:     SICHERUNG  DORMAGEN                                              */
             IF         COND(&FWLFIRM *EQ 'D') THEN(DO)
                CHGVAR     VAR(%SST(&OBJ 01 02)) VALUE('H_')
                CHGVAR     VAR(%SST(&OBJ 03 06)) VALUE(&DATE)
                CHGVAR     VAR(&TXT) VALUE('Sicherung H-Preise    ')
                CHGVAR     VAR(%SST(&TXT 31 10))   VALUE(&SYSDAT)
                CHGVAR     VAR(%SST(&TXT 42 08))   VALUE(&SYSZEI)
                IF         COND(&UMGEB *EQ '3') THEN(DO)
                   CHGVAR     VAR(&LIB) VALUE('TESDATDOR3')
                ENDDO
                IF         COND(&UMGEB *EQ '2') THEN(DO)
                   CHGVAR     VAR(&LIB) VALUE('TESDATDOR2')
                ENDDO
                IF         COND(&UMGEB *EQ 'M') THEN(DO)
                   CHGVAR     VAR(&LIB) VALUE('TESDATDORM')
                ENDDO
                IF         COND(&UMGEB *EQ 'P') THEN(DO)
                   CHGVAR     VAR(&LIB) VALUE('TESDATDOR')
                ENDDO
                CPYF       FROMFILE(SFBKORE/HFPREISE2) +
                          TOFILE(&LIB/&OBJ) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
                MONMSG     MSGID(CPF0000) EXEC(DO)
                ENDDO
                CHGVAR     VAR(%SST(&OBJ 01 02)) VALUE('S_')
                CPYF       FROMFILE(SFBKORE/SPPREISE2) +
                           TOFILE(&LIB/&OBJ) MBROPT(*REPLACE) +
                           CRTFILE(*YES)
                MONMSG     MSGID(CPF0000) EXEC(DO)
                ENDDO
                CHGVAR     VAR(%SST(&OBJ 01 02)) VALUE('F_')
                CPYF       FROMFILE(SFBKORE/FEPREISE2) +
                           TOFILE(&LIB/&OBJ) MBROPT(*REPLACE) +
                           CRTFILE(*YES)
                MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDE))
             ENDDO
/*----------------------------------------------------------------------------*/
/* LIB:     SICHERUNG  LINGEN                                                */
/*----------------------------------------------------------------------------*/
             IF         COND(&FWLFIRM *EQ 'L') THEN(DO)
                CHGVAR     VAR(%SST(&OBJ 01 02)) VALUE('H_')
                CHGVAR     VAR(%SST(&OBJ 03 06)) VALUE(&DATE)
                CHGVAR     VAR(&TXT) VALUE('Sicherung H-Preise    ')
                CHGVAR     VAR(%SST(&TXT 31 10))   VALUE(&SYSDAT)
                CHGVAR     VAR(%SST(&TXT 42 08))   VALUE(&SYSZEI)
                IF         COND(&UMGEB *EQ '3') THEN(DO)
                   CHGVAR     VAR(&LIB) VALUE('TESDATFWL3')
                ENDDO
                IF         COND(&UMGEB *EQ '2') THEN(DO)
                   CHGVAR     VAR(&LIB) VALUE('TESDATFWL2')
                ENDDO
                IF         COND(&UMGEB *EQ 'M') THEN(DO)
                   CHGVAR     VAR(&LIB) VALUE('TESDATFWLM')
                ENDDO
                IF         COND(&UMGEB *EQ 'P') THEN(DO)
                   CHGVAR     VAR(&LIB) VALUE('TESDATFWL')
                ENDDO
                CPYF       FROMFILE(SFBKORE/HFPREISE1) +
                           TOFILE(&LIB/&OBJ) MBROPT(*REPLACE) +
                           CRTFILE(*YES)
                MONMSG     MSGID(CPF0000) EXEC(DO)
                ENDDO
                CHGVAR     VAR(%SST(&OBJ 01 02)) VALUE('S_')
                CPYF       FROMFILE(SFBKORE/SPPREISE1) +
                           TOFILE(&LIB/&OBJ) MBROPT(*REPLACE) +
                           CRTFILE(*YES)
                MONMSG     MSGID(CPF0000) EXEC(DO)
                ENDDO
                CHGVAR     VAR(%SST(&OBJ 01 02)) VALUE('F_')
                CPYF       FROMFILE(SFBKORE/FEPREISE1) +
                           TOFILE(&LIB/&OBJ) MBROPT(*REPLACE) +
                           CRTFILE(*YES)
                MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDE))
             ENDDO

 ENDE:
             RCLRSC

             ENDPGM
