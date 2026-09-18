/*    * PROGRAMMNAME.:ÜBERNAHME ARTIKELDATEN                                 */
/*    * FUNKTION.....:INITIALISIEREN DER BEREICHE                            */
/*    * 06.07.98                                                              */
/*    *                                                                       */
/*    * Manfred Gang                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM

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
/*----------------------------------------------------------------------------*/
/* LIB:     TESDATFWLG                                                       */
             RSTLIB     SAVLIB(TESDATFWL) DEV(*SAVF) +
                          SAVF(SAVEFILE/DATAFWL) MBROPT(*ALL) +
                          ALWOBJDIF(*ALL) RSTLIB(TESDATFWL)
                MONMSG     MSGID(CPF0000)
             RSTLIB     SAVLIB(TESDATFWL) DEV(*SAVF) +
                          SAVF(SAVEFILE/DATAFWL) MBROPT(*ALL) +
                          ALWOBJDIF(*ALL) RSTLIB(TESDATFWLG)
                MONMSG     MSGID(CPF0000)
/*----------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

 ENDE:
             RCLRSC

             ENDPGM
