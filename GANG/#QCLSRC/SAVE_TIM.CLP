/*    * PROGRAMMNAME.:ÜBERNAHME ARTIKELDATEN                                 */
/*    * FUNKTION.....:INITIALISIEREN DER BEREICHE                            */
/*    *             .:D_20051201        L_20051201                           */
/*    * 06.07.98                                                              */
/*    *                                                                       */
/*    * Manfred Gang                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * 20070130  MG   WEGEN DER SPERREN BEI DLTLIB JETZT CLRLIB MIT          */
/*    *                RSTOBJ                                                 */
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

                CALL       PGM(SUBR36/#ENDINTERC)
                MONMSG     MSGID(CPF0000)

                CHGVAR     VAR(%SST(&OBJ 01 02))   VALUE('D_')
                CHGVAR     VAR(%SST(&OBJ 03 08)) VALUE(&SYSDAT)
                CHGVAR     VAR(&TXT) VALUE('Dormagen SICHERUNG    +
                                                        ')
                CHGVAR     VAR(%SST(&TXT 31 10))   VALUE(&SYSDAT)
                CHGVAR     VAR(%SST(&TXT 42 08))   VALUE(&SYSZEI)
                CRTSAVF    FILE(SAVEFILE/&OBJ) TEXT(&TXT)
                MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDE))
 DOR001:        CLRSAVF    FILE(SAVEFILE/&OBJ)
                MONMSG     MSGID(CPF0000)
                SAVLIB     LIB(TESDATDOR) DEV(*SAVF) +
                           SAVF(SAVEFILE/&OBJ) SAVACT(*SYNCLIB) +
                           SAVACTWAIT(120) ACCPTH(*YES) +
                           OUTPUT(*OUTFILE) OUTFILE(SUBR36/SAVE_TIM) +
                           OUTMBR(*FIRST *ADD)
                MONMSG     MSGID(CPF0000) EXEC(DO)
                DLYJOB     DLY(10)
                GOTO       CMDLBL(DOR001)
                ENDDO

                CALL       PGM(SUBR36/#ENDINTERC)
                MONMSG     MSGID(CPF0000)

 DOR002:
  /**20070130   DLTLIB     LIB(TESDATDORT)                          **/
                CLRLIB     LIB(TESDATDORT)
                MONMSG     MSGID(CPF0000) EXEC(DO)
                DLYJOB     DLY(10)
                GOTO       CMDLBL(DOR002)
                ENDDO
  /**20070130   CRTLIB     LIB(TESDATDORT) TEXT(&TXT)               **/
  /**20070130   MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDE))   **/

/*             RSTOBJ ANSTATT RSTLIB                                         */
                RSTOBJ     OBJ(*ALL) SAVLIB(TESDATDOR) DEV(*SAVF) +
                           SAVF(SAVEFILE/&OBJ) MBROPT(*ALL) +
                           ALWOBJDIF(*ALL) RSTLIB(TESDATDORT)
                MONMSG     MSGID(CPF0000)

/*             RSTLIB JETZT NICHT MEHR WEGEN SPERRE DLTLIB                   */
  /**20070130   RSTLIB     SAVLIB(TESDATDOR) DEV(*SAVF) +           **/
  /**20070130              SAVF(SAVEFILE/&OBJ) MBROPT(*ALL) +       **/
  /**20070130              ALWOBJDIF(*ALL) RSTLIB(TESDATDORT)       **/
  /**20070130   MONMSG     MSGID(CPF0000)                           **/

             ENDDO
/*----------------------------------------------------------------------------*/
/* LIB:     SICHERUNG  LINGEN                                                */
             IF         COND(&SAV *EQ '1') THEN(DO)

                CALL       PGM(SUBR36/#ENDINTERC)
                MONMSG     MSGID(CPF0000)

                CHGVAR     VAR(%SST(&OBJ 01 02))   VALUE('L_')
                CHGVAR     VAR(%SST(&OBJ 03 08)) VALUE(&SYSDAT)
                CHGVAR     VAR(&TXT) VALUE('Lingen   SICHERUNG    +
                                                        ')
                CHGVAR     VAR(%SST(&TXT 31 10))   VALUE(&SYSDAT)
                CHGVAR     VAR(%SST(&TXT 42 08))   VALUE(&SYSZEI)
                CRTSAVF    FILE(SAVEFILE/&OBJ) TEXT(&TXT)
                MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDE))
 LIN001:        CLRSAVF    FILE(SAVEFILE/&OBJ)
                MONMSG     MSGID(CPF0000)
                SAVLIB     LIB(TESDATFWL) DEV(*SAVF) +
                           SAVF(SAVEFILE/&OBJ) SAVACT(*SYNCLIB) +
                           SAVACTWAIT(120) ACCPTH(*YES) +
                           OUTPUT(*OUTFILE) OUTFILE(SUBR36/SAVE_TIM) +
                           OUTMBR(*FIRST *ADD)
                MONMSG     MSGID(CPF0000) EXEC(DO)
                DLYJOB     DLY(10)
                GOTO       CMDLBL(LIN001)
                ENDDO

                CALL       PGM(SUBR36/#ENDINTERC)
                MONMSG     MSGID(CPF0000)

 LIN002:
  /**20070130   DLTLIB     LIB(TESDATFWLT)                          **/
                CLRLIB     LIB(TESDATFWLT)
                MONMSG     MSGID(CPF0000) EXEC(DO)
                DLYJOB     DLY(10)
                GOTO       CMDLBL(LIN002)
                ENDDO
  /**20070130   CRTLIB     LIB(TESDATFWLT) TEXT(&TXT)               **/
  /**20070130   MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDE))   **/
/*             RSTOBJ ANSTATT RSTLIB                                         */
                RSTOBJ     OBJ(*ALL) SAVLIB(TESDATFWL) DEV(*SAVF) +
                           SAVF(SAVEFILE/&OBJ) MBROPT(*ALL) +
                           ALWOBJDIF(*ALL) RSTLIB(TESDATFWLT)
                MONMSG     MSGID(CPF0000)

/*             RSTLIB JETZT NICHT MEHR WEGEN SPERRE DLTLIB                   */
  /**20070130   RSTLIB     SAVLIB(TESDATFWL) DEV(*SAVF) +           **/
  /**20070130              SAVF(SAVEFILE/&OBJ) MBROPT(*ALL) +       **/
  /**20070130              ALWOBJDIF(*ALL) RSTLIB(TESDATFWLT)       **/
  /**20070130   MONMSG     MSGID(CPF0000)                           **/

             ENDDO
/*----------------------------------------------------------------------------*/

 ENDE:
             CALL       PGM(UEBERNAHME/DOCDSC2)
             MONMSG     MSGID(CPF0000)

     /*      DSPJOBLOG  OUTPUT(*PRINT)  */
             RCLRSC

             ENDPGM
