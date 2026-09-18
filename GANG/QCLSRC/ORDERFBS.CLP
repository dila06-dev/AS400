/*    * PROGRAMMNAME.:ORDERFBS                                               */
/*    * FUNKTION.....:..                                                     */
/*    * SEPTEMBER 2010   GANG, MANFRED                                        */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX         PARM( '88505' '170910')              PGMR.....       */
/******************************************************************************/
             PGM

             DCL        VAR(&PARM) TYPE(*CHAR) LEN(01)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR3)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&OUTFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFKT)  TYPE(*CHAR) LEN(10)

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))
             CHGCURLIB  CURLIB(GANG)

             OVRDBF     FILE(INPUT) TOFILE(GANG/QCLSRC) MBR(ORDERFBCMD)
             CLRPFM FILE(GANG/QCLSRC) MBR(ORDERFBLOG)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(OUTPUT) TOFILE(GANG/QCLSRC) +
                          MBR(ORDERFBLOG)
             FTP        RMTSYS('DOMETIC-GROUP.COM')
             CHGCURLIB  CURLIB(*CRTDFT)
             DLTOVR     FILE(INPUT)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(OUTPUT)
             MONMSG     MSGID(CPF0000)

             IF         COND(&PARM = '1') THEN(DO)
             ENDDO
 ENDPGM:
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
             ENDDO

             ENDPGM
