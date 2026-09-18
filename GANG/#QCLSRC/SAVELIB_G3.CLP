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
                CLRSAVF    FILE(SAVEFILE/DATAFWL)
                MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDE))
                CHGVAR     VAR(&TXT) VALUE('Lingen   SICHERUNG    ')
                CHGVAR     VAR(%SST(&TXT 31 10))   VALUE(&SYSDAT)
                CHGVAR     VAR(%SST(&TXT 42 08))   VALUE(&SYSZEI)
                CHGOBJD    OBJ(SAVEFILE/DATADOR) OBJTYPE(*FILE) +
                           TEXT(&TXT)
                MONMSG     MSGID(CPF0000)
                SAVLIB     LIB(TESDATFWL) DEV(*SAVF) +
                             SAVF(SAVEFILE/DATAFWL) SAVACT(*SYNCLIB) +
                             SAVACTWAIT(*NOMAX) ACCPTH(*YES)
                MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDE))
             ENDDO
/*----------------------------------------------------------------------------*/
/* LIB:     TESDATFWLG                                                       */
             IF         COND(&ENV *EQ 'G') THEN(DO)
                DLTLIB     LIB(TESDATFWLG)
                MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDE))
                CHGVAR     VAR(&TXT) VALUE('Lingen   Testumgebung +
                             GEHA                        ')
                CHGVAR     VAR(%SST(&TXT 31 10))   VALUE(&SYSDAT)
                CHGVAR     VAR(%SST(&TXT 42 08))   VALUE(&SYSZEI)
                CRTLIB     LIB(TESDATFWLG) TEXT(&TXT)
                MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDE))
                RSTLIB     SAVLIB(TESDATFWL) DEV(*SAVF) +
                             SAVF(SAVEFILE/DATAFWL) MBROPT(*ALL) +
                          ALWOBJDIF(*ALL) RSTLIB(TESDATFWLG)
                MONMSG     MSGID(CPF0000)
             ENDDO
/*----------------------------------------------------------------------------*/
/* LIB:     TESDATFWLT                                                       */
             IF         COND(&ENV *EQ 'T') THEN(DO)
                DLTLIB     LIB(TESDATFWLT)
                MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDE))
                CHGVAR     VAR(&TXT) VALUE('Lingen   Testumgebung ')
                CHGVAR     VAR(%SST(&TXT 31 10))   VALUE(&SYSDAT)
                CHGVAR     VAR(%SST(&TXT 42 08))   VALUE(&SYSZEI)
                CRTLIB     LIB(TESDATFWLT) TEXT(&TXT)
                MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDE))
                RSTLIB     SAVLIB(TESDATFWL) DEV(*SAVF) +
                             SAVF(SAVEFILE/DATAFWL) MBROPT(*ALL) +
                             ALWOBJDIF(*ALL) RSTLIB(TESDATFWLT)
                MONMSG     MSGID(CPF0000)
             ENDDO
/*----------------------------------------------------------------------------*/
/* LIB:     TESDATFWLM                                                       */
             IF         COND(&ENV *EQ 'M') THEN(DO)
                DLTLIB     LIB(TESDATFWLM)
                MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDE))
                CHGVAR     VAR(&TXT) VALUE('Lingen   Testumgebung +
                             Market.')
                CHGVAR     VAR(%SST(&TXT 31 10))   VALUE(&SYSDAT)
                CHGVAR     VAR(%SST(&TXT 42 08))   VALUE(&SYSZEI)
                CRTLIB     LIB(TESDATFWLM) TEXT(&TXT)
                MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDE))
                RSTLIB     SAVLIB(TESDATFWL) DEV(*SAVF) +
                             SAVF(SAVEFILE/DATAFWL) MBROPT(*ALL) +
                             ALWOBJDIF(*ALL) RSTLIB(TESDATFWLM)
                MONMSG     MSGID(CPF0000)
             ENDDO
/*----------------------------------------------------------------------------*/
/* LIB:     TESDATFWL3                                                       */
             IF         COND(&ENV *EQ '3') THEN(DO)
                DLTLIB     LIB(TESDATFWL3)
                MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDE))
                CHGVAR     VAR(&TXT) VALUE('Lingen   Testumgebung +
                       FÜR  JUNI    ')
                CHGVAR     VAR(%SST(&TXT 31 10))   VALUE(&SYSDAT)
                CHGVAR     VAR(%SST(&TXT 42 08))   VALUE(&SYSZEI)
                CRTLIB     LIB(TESDATFWL3) TEXT(&TXT)
                MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDE))
                RSTLIB     SAVLIB(TESDATFWL) DEV(*SAVF) +
                             SAVF(SAVEFILE/DATAFWL) MBROPT(*ALL) +
                             ALWOBJDIF(*ALL) RSTLIB(TESDATFWL3)
                MONMSG     MSGID(CPF0000)
             ENDDO
/*----------------------------------------------------------------------------*/

 ENDE:
             RCLRSC

             ENDPGM
