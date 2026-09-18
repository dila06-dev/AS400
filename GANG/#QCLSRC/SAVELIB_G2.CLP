/*    * PROGRAMMNAME.:ÜBERNAHME ARTIKELDATEN                                 */
/*    * FUNKTION.....:INITIALISIEREN DER BEREICHE                            */
/*    * 06.07.98                                                              */
/*    *                                                                       */
/*    * Manfred Gang                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&SAV &ENV)

             DCL        VAR(&SAV) TYPE(*CHAR)  LEN(01)
             DCL        VAR(&ENV)  TYPE(*CHAR) LEN(01)
             DCL        VAR(&LIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TXT)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&MODUS)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&DATMOD)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&RTNCOD)  TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&SYSGES)  TYPE(*CHAR) LEN(26)
             DCL        VAR(&SYSDAT)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&SYSZEI)  TYPE(*CHAR) LEN(8)
/*----------------------------------------------------------------------------*/
/*    *     SYSGES: 22.03.200509.02.26                                       */
/*    *     SYSDAT: 22.03.2005                                               */
/*    *     SYSZEI: 09.02.26                                                 */
             CHGVAR     VAR(&DATMOD) VALUE('*EUR ')
             CALL       PGM(SUBR36/#DATAKTR) PARM(&DATMOD &RTNCOD +
                          &SYSGES &SYSDAT &SYSZEI)
/*----------------------------------------------------------------------------*/
/* LIB:     SICHERUNG                                                        */
             IF         COND(&SAV *EQ '1') THEN(DO)
                CLRSAVF    FILE(SAVEFILE/DATADOR)
                MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDE))
                CHGVAR     VAR(&TXT) VALUE('Dormagen SICHERUNG    +
                                                        ')
                CHGVAR     VAR(%SST(&TXT 31 10))   VALUE(&SYSDAT)
                CHGVAR     VAR(%SST(&TXT 42 08))   VALUE(&SYSZEI)
                CHGOBJD    OBJ(SAVEFILE/DATADOR) OBJTYPE(*FILE) +
                          TEXT(&TXT)
                MONMSG     MSGID(CPF0000)
                SAVLIB     LIB(TESDATDOR) DEV(*SAVF) +
                             SAVF(SAVEFILE/DATADOR) SAVACT(*SYNCLIB) +
                             SAVACTWAIT(*NOMAX) ACCPTH(*YES)
                MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDE))
             ENDDO
/*----------------------------------------------------------------------------*/
/* LIB:     TESDATDORG                                                       */
             IF         COND(&ENV *EQ 'G') THEN(DO)
                DLTLIB     LIB(TESDATDORG)
                MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDE))
                CHGVAR     VAR(&TXT) VALUE('Dormagen Testumgebung +
                             GEHA                        ')
                CHGVAR     VAR(%SST(&TXT 31 10))   VALUE(&SYSDAT)
                CHGVAR     VAR(%SST(&TXT 42 08))   VALUE(&SYSZEI)
                CRTLIB     LIB(TESDATDORG) TEXT(&TXT)
                MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDE))
                RSTLIB     SAVLIB(TESDATDOR) DEV(*SAVF) +
                             SAVF(SAVEFILE/DATADOR) MBROPT(*ALL) +
                          ALWOBJDIF(*ALL) RSTLIB(TESDATDORG)
                MONMSG     MSGID(CPF0000)
             ENDDO
/*----------------------------------------------------------------------------*/
/* LIB:     TESDATDORT                                                       */
             IF         COND(&ENV *EQ 'T') THEN(DO)
                DLTLIB     LIB(TESDATDORT)
                MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDE))
                CHGVAR     VAR(&TXT) VALUE('Dormagen Testumgebung +
                            FÜR JUNI                    ')
                CHGVAR     VAR(%SST(&TXT 31 10))   VALUE(&SYSDAT)
                CHGVAR     VAR(%SST(&TXT 42 08))   VALUE(&SYSZEI)
                CRTLIB     LIB(TESDATDORT) TEXT(&TXT)
                MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDE))
                RSTLIB     SAVLIB(TESDATDOR) DEV(*SAVF) +
                             SAVF(SAVEFILE/DATADOR) MBROPT(*ALL) +
                             ALWOBJDIF(*ALL) RSTLIB(TESDATDORT)
                MONMSG     MSGID(CPF0000)
             ENDDO
/*----------------------------------------------------------------------------*/
/* LIB:     TESDATDORM                                                       */
             IF         COND(&ENV *EQ 'M') THEN(DO)
                DLTLIB     LIB(TESDATDORM)
                MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDE))
                CHGVAR     VAR(&TXT) VALUE('Dormagen Testumgebung +
                             Market.                    ')
                CHGVAR     VAR(%SST(&TXT 31 10))   VALUE(&SYSDAT)
                CHGVAR     VAR(%SST(&TXT 42 08))   VALUE(&SYSZEI)
                CRTLIB     LIB(TESDATDORM) TEXT(&TXT)
                MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDE))
                RSTLIB     SAVLIB(TESDATDOR) DEV(*SAVF) +
                             SAVF(SAVEFILE/DATADOR) MBROPT(*ALL) +
                             ALWOBJDIF(*ALL) RSTLIB(TESDATDORM)
                MONMSG     MSGID(CPF0000)
             ENDDO
/*----------------------------------------------------------------------------*/
/* LIB:     TESDATDOR3                                                       */
             IF         COND(&ENV *EQ '3') THEN(DO)
                DLTLIB     LIB(TESDATDOR3)
                MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDE))
                CHGVAR     VAR(&TXT) VALUE('Dormagen Testumgebung +
                                                        ')
                CHGVAR     VAR(%SST(&TXT 31 10))   VALUE(&SYSDAT)
                CHGVAR     VAR(%SST(&TXT 42 08))   VALUE(&SYSZEI)
                CRTLIB     LIB(TESDATDOR3) TEXT(&TXT)
                MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDE))
                RSTLIB     SAVLIB(TESDATDOR) DEV(*SAVF) +
                             SAVF(SAVEFILE/DATADOR) MBROPT(*ALL) +
                             ALWOBJDIF(*ALL) RSTLIB(TESDATDOR3)
                MONMSG     MSGID(CPF0000)
             ENDDO
/*----------------------------------------------------------------------------*/

 ENDE:
             RCLRSC

             ENDPGM
