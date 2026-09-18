/*    * PROGRAMMNAME.:WEBUSER3                                               */
/*    * FUNKTION.....:..                                                     */
/*    * SEPTEMBER 2010   GANG, MANFRED                                        */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                          PGMR.....           */
/******************************************************************************/
             PGM

             DCL        VAR(&PARM) TYPE(*CHAR) LEN(04)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&CALL) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&RC) TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&USR) TYPE(*CHAR) LEN(10) VALUE(' ')

             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR3)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&TEXT)    TYPE(*CHAR) LEN(50) VALUE(' ')

   /*TESTUMGEBUNG AKTIV           */
             RTVUSRPRF  USRPRF(*CURRENT) RTNUSRPRF(&USR) TEXT(&TEXT)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDPGM))
             IF         COND(%SST(&TEXT 01 30) *NE 'WEBUSER TREND +
                          ERP per Internet') THEN(DO)
                CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&USR)
                ADDLIBLE   LIB(GANG) POSITION(*LAST)
                MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))
                CALL  PGM(DUMMY512) PARM(&MD '#WA0001' ' ' ' ' +
                          '#WA0001' 'QTEMP' '*REPLACE')
                MONMSG     MSGID(CPF0000)
                CPYF       FROMFILE(QTEMP/#WA0001) +
                           TOFILE(TVRELWAECO/&USR) MBROPT(*REPLACE)
                MONMSG     MSGID(CPF0000)
                CPYF       FROMFILE(QTEMP/#WA0001) +
                           TOFILE(TVRELWAECO/&USR) MBROPT(*REPLACE) +
                           CRTFILE(*YES)
                MONMSG     MSGID(CPF0000)
                CALL       PGM(MODWAO/STRACM)
                MONMSG     MSGID(CPF0000)
                ADDLIBLE   LIB(BAR_KALK) POSITION(*LAST)
                MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR3) +
                          VALUE('1'))
                GOTO CMDLBL(ENDPGM)
             ENDDO
   NEXT:
             ADDLIBLE   LIB(TVRELWAECO) POSITION(*FIRST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))
             ADDLIBLE   LIB(TVPF) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDPGM))
             DSPJOBLOG  OUTPUT(*OUTFILE) +
                          OUTFILE(TVRELWAECO/WEBACCESS) +
                          OUTMBR(*FIRST *ADD)
             CALL       PGM(TVRELWAECO/WEBACCESS) PARM(&RC)
             MONMSG     MSGID(CPF0000)
             IF         COND(&RC = '1') THEN(DO)
                CPYF       FROMFILE(QTEMP/#WA0001) +
                           TOFILE(TVRELWAECO/&USR) MBROPT(*REPLACE)
                MONMSG     MSGID(CPF0000)
                CPYF       FROMFILE(QTEMP/#WA0001) +
                           TOFILE(TVRELWAECO/&USR) MBROPT(*REPLACE) +
                           CRTFILE(*YES)
                MONMSG     MSGID(CPF0000)
                CALL       PGM(MODWAO/STRACM)
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&RC = '0') THEN(DO)
                CHGUSRPRF  USRPRF(&USR) STATUS(*DISABLED)
                MONMSG     MSGID(CPF0000)
             ENDDO

 ENDPGM:
             IF         COND(&ERROR2 = '0') THEN(DO)
    /*          RMVLIBLE   LIB(GANG)                       */
             ENDDO
             IF         COND(&ERROR1 = '0') THEN(DO)
    /*          RMVLIBLE   LIB(TVRELWAECO)                 */
             ENDDO
             DSPJOBLOG
             ENDPGM
