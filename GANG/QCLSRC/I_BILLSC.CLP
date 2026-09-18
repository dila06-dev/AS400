/*    * PROGRAMMNAME.:I_BILLSC                                               */
/*    * FUNKTION.....:RELOAD RECHNUNGEN FÜR AXAPTA                           */
/*    *               DOMINV_XX PER FTP SENDEN                               */
/*    * NOVEMBER 2009                                                         */
/*    *                                                                       */
/*    *                                                                       */
/*    *                                                                       */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
/*           PGM        PARM(&KUNDE &DATUM)  */
             PGM

             DCL        VAR(&KUNDE) TYPE(*DEC) LEN(05 00)
             DCL        VAR(&DATUM) TYPE(*DEC) LEN(06 00)
             DCL        VAR(&NBRCURRCD) TYPE(*DEC) LEN(10 00)
             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR3)  TYPE(*CHAR) LEN(01) VALUE('0')
             CHGVAR     VAR(&KUNDE) VALUE(88505)
             CHGVAR     VAR(&DATUM) VALUE(260410)

             ADDLIBLE   LIB(WAECOEDI) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))

             ADDLIBLE   LIB(BAR_FTP) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR3) +
                          VALUE('1'))
             CLRPFM     FILE(GANG/FAKWAEFRH)
             CLRPFM     FILE(GANG/FAKWAEFRHC)
             CLRPFM     FILE(GANG/FAKWAEFRL)

             CALL       PGM(I_BILLSR) PARM(&KUNDE &DATUM)
             MONMSG     MSGID(CPF0000)

             RUNQRY     QRY(GANG/FAKWAEFRT)

             OVRDBF     FILE(FAKWAEFRH) TOFILE(GANG/FAKWAEFRH) +
                          OVRSCOPE(*CALLLVL)
             OVRDBF     FILE(FAKWAEFRL) TOFILE(GANG/FAKWAEFRL) +
                          OVRSCOPE(*CALLLVL)
             OVRDBF     FILE(FAKWAEFRT) TOFILE(GANG/FAKWAEFRT) +
                          OVRSCOPE(*CALLLVL)

             IF         COND(&KUNDE  = 88505) THEN(DO)
                CLRPFM     FILE(DOMINV_FR)
                CALL       PGM(DOMINV_FR)
                RTVMBRD    FILE(WAECOEDI/DOMINV_FR) +
                           NBRCURRCD(&NBRCURRCD)
                IF         COND(&NBRCURRCD *GT 0) THEN(DO)
                   CPYF       FROMFILE(WAECOEDI/DOMINV_FR) +
                                TOFILE(WAECOEDI/DOMINVCHCK) +
                                MBROPT(*REPLACE) CRTFILE(*NO)
                   MONMSG     MSGID(CPF2817) EXEC(GOTO CMDLBL(ENDPGM))
                   MONMSG     MSGID(CPF2869) EXEC(GOTO CMDLBL(ENDPGM))
                   CALL       PGM(BAR_FTP/GFTPINV#) PARM('FR')
                ENDDO
             ENDDO



 ENDPGM:
             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(WAECOEDI)
             ENDDO
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
             ENDDO
             IF         COND(&ERROR3 = '0') THEN(DO)
                RMVLIBLE   LIB(BAR_FTP)
             ENDDO

             RCLRSC

             ENDPGM
