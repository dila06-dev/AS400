/*    * PROGRAMMNAME.:ÜBERNAHME ARTIKELDATEN                                 */
/*    * FUNKTION.....:INITIALISIEREN DER BEREICHE                            */
/*    * FUNKTION.....:D_20051201        L_20051201                           */
/*    * FUNKTION.....:D_20051202        L_20051202                           */
/*    * FUNKTION.....:D_20051205        L_20051205                           */
/*    * FUNKTION.....:...               ...                                  */
/*    * 06.07.98                                                              */
/*    *                                                                       */
/*    * Manfred Gang                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&SAV)

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
             DCL        VAR(&OBJ)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&RUFJOB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&RUFUSR)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&RUFJNR)  TYPE(*CHAR) LEN(6)

             RTVJOBA    JOB(&RUFJOB) USER(&RUFUSR) NBR(&RUFJNR)

/*----------------------------------------------------------------------------*/
/*    *     SYSGES: 20050322090226                                           */
/*    *     SYSDAT: 20050322                                                 */
/*    *     SYSZEI: 090226                                                   */
             CHGVAR     VAR(&DATMOD) VALUE('*JMT4')
             CALL       PGM(SUBR36/#DATAKTR) PARM(&DATMOD &RTNCOD +
                          &SYSGES &SYSDAT &SYSZEI)
/*----------------------------------------------------------------------------*/
/* LIB:     SICHERUNG  DORMAGEN                                              */
             IF         COND(&SAV *EQ '1') THEN(DO)

             CALL       PGM(SUBR36/#PPLCKPRFC) PARM('TESDAT### ' +
                          &RUFJOB &RUFUSR &RUFJNR)
             MONMSG     MSGID(CPF0000)

                CHGVAR     VAR(%SST(&OBJ 01 02))   VALUE('D_')
                CHGVAR     VAR(%SST(&OBJ 03 08)) VALUE(&SYSDAT)
                CHGVAR     VAR(&TXT) VALUE('Dormagen SICHERUNG    +
                                                        ')
                CHGVAR     VAR(%SST(&TXT 31 10))   VALUE(&SYSDAT)
                CHGVAR     VAR(%SST(&TXT 42 08))   VALUE(&SYSZEI)
                CRTSAVF    FILE(SAVEFILE/&OBJ) TEXT(&TXT)
                MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDE))
                SAVLIB     LIB(TESDAT###) DEV(*SAVF) +
                             SAVF(SAVEFILE/&OBJ) SAVACT(*SYNCLIB) +
                             SAVACTWAIT(*NOMAX) ACCPTH(*YES)
                MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDE))

             CALL       PGM(SUBR36/#PPLCKPRFC) PARM('TESDAT###T' +
                          &RUFJOB &RUFUSR &RUFJNR)
             MONMSG     MSGID(CPF0000)

                DLTLIB     LIB(TESDAT###T)
                MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDE))
                CRTLIB     LIB(TESDAT###T) TEXT(&TXT)
                MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDE))
                RSTLIB     SAVLIB(TESDAT###) DEV(*SAVF) +
                           SAVF(SAVEFILE/&OBJ) MBROPT(*ALL) +
                           ALWOBJDIF(*ALL) RSTLIB(TESDAT###T)
                MONMSG     MSGID(CPF0000)

             ENDDO
/*----------------------------------------------------------------------------*/

 ENDE:
             DSPJOB     OUTPUT(*PRINT) OPTION(*ALL)
             RCLRSC

             ENDPGM
