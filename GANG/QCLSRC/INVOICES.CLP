/*    * PROGRAMMNAME.:INVOICES                                               */
/*    * FUNKTION.....:..                                                     */
/*    * SEPTEMBER 2010   GANG, MANFRED                                        */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX         PARM( '88505' '170910')              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&K &D)

             DCL        VAR(&K)    TYPE(*CHAR) LEN(05)
             DCL        VAR(&D)    TYPE(*CHAR) LEN(06)
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(01)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR3)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&GESTERN) TYPE(*CHAR) LEN(08)
             DCL        VAR(&TAG)   TYPE(*DEC) LEN(02 0)
             DCL        VAR(&MONAT) TYPE(*DEC) LEN(02 0)
             DCL        VAR(&JAHR)  TYPE(*DEC) LEN(04 0)
             DCL        VAR(&WOTAG) TYPE(*DEC) LEN(02 0)
             DCL        VAR(&OUTFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFKT)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&QDATE)   TYPE(*CHAR) LEN(20)
             DCL        VAR(&QDATEV)  TYPE(*CHAR) LEN(20)
             DCL        VAR(&FILE)    TYPE(*CHAR) LEN(10)

             IF         COND(&D = ' ') THEN(DO)
                RTVSYSVAL  SYSVAL(QDATETIME) RTNVAR(&QDATE)
                CHGVAR   VAR(%SST(&QDATEV 1 2)) VALUE(%SST(&QDATE 7 2))
                CHGVAR   VAR(%SST(&QDATEV 3 2)) VALUE(%SST(&QDATE 5 2))
                CHGVAR   VAR(%SST(&QDATEV 5 4)) VALUE(%SST(&QDATE 1 4))
                CHGVAR   VAR(%SST(&QDATEV 1 8)) VALUE(%SST(&QDATE 1 8))

                CHGVAR   VAR(%SST(&FILE   3 8)) VALUE(%SST(&QDATE 1 8))
                CALL    PGM($DATER) PARM(&GESTERN &TAG &MONAT &JAHR +
                          &WOTAG)
                MONMSG     MSGID(CPF0000)
                CHGVAR     VAR(%SST(&FILE 3 8)) VALUE(&GESTERN)
                CHGVAR   VAR(%SST(&D 5 2)) VALUE(%SST(&FILE 5 2))
                CHGVAR   VAR(%SST(&D 3 2)) VALUE(%SST(&FILE 7 2))
                CHGVAR   VAR(%SST(&D 1 2)) VALUE(%SST(&FILE 9 2))
             ENDDO
             IF         COND(&D *NE ' ') THEN(DO)
                CHGVAR   VAR(%SST(&FILE 3 2)) VALUE('20')
                CHGVAR   VAR(%SST(&FILE 5 2)) VALUE(%SST(&D 5 2))
                CHGVAR   VAR(%SST(&FILE 7 2)) VALUE(%SST(&D 3 2))
                CHGVAR   VAR(%SST(&FILE 9 2)) VALUE(%SST(&D 1 2))
             ENDDO

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))
             ADDLIBLE   LIB(POHL) POSITION(*FIRST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR3) +
                          VALUE('1'))
             ADDLIBLE   LIB(WAECOEDI) POSITION(*FIRST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))
             CLRPFM     FILE(DOMINV_XX)
             CLRPFM     FILE(FAKWAE__H)
             CLRPFM     FILE(FAKWAE__L)
             CALL       PGM(INVOICESR) PARM(&K &D)
             IF         COND(&K *NE '88505' *AND &K *NE '40631') +
                          THEN(DO)
                GOTO ENDPGM
             ENDDO
        /*   RUNQRY     QRY(WAECOQRY/FAKWAE__H)   */
        /*   RUNQRY     QRY(WAECOQRY/FAKWAE__L)   */
             RUNQRY     QRY(WAECOQRY/FAKWAE__T)
             CALL       PGM(DUMMY512) PARM(' ' '#DC0058' ' ' ' ' ' ' +
                          ' ' ' ')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DOMINV_XX)
             MONMSG     MSGID(CPF0000)
             CHGCURLIB  CURLIB(GANG)
             DLTF       FILE(GANG/INVOICES)
             MONMSG     MSGID(CPF0000)
             CPYF       FROMFILE(WAECOEDI/DOMINV_XX) +
                        TOFILE(GANG/INVOICES) TOMBR(INVOICES) +
                        MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(INPUT) TOFILE(GANG/QCLSRC) MBR(INVOICECMD)
             MONMSG     MSGID(CPF0000)
             IF         COND(&K = '88505') THEN(DO)
                CHGVAR     VAR(%SST(&FILE 1 2)) VALUE('FR')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0061' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO
             IF         COND(&K = '40631') THEN(DO)
                CHGVAR     VAR(%SST(&FILE 1 2)) VALUE('UK')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0060' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO
             CHGVAR     VAR(%SST(&MD 1 10)) VALUE(&FILE)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0059' ' ' ' ' ' ' +
                          ' ' ' ')
             CHGVAR     VAR(%SST(&MD 1 10)) VALUE(&FILE)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0062' ' ' ' ' ' ' +
                          ' ' ' ')
             CLRPFM FILE(GANG/QCLSRC) MBR(INVOICELOG)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(OUTPUT) TOFILE(GANG/QCLSRC) +
                          MBR(INVOICELOG)
             MONMSG     MSGID(CPF0000)
             FTP        RMTSYS('DOMETIC-GROUP.COM')
             DLTOVR     FILE(INPUT)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(OUTPUT)
             MONMSG     MSGID(CPF0000)

  /* PROTOKOLLAUSGABE               */
             OVRDBF     FILE(PROTOKOLL) TOFILE(GANG/QCLSRC) +
                          MBR(INVOICELOG)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(INPUT) TOFILE(GANG/QCLSRC) MBR(INVOICEPRT)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(GANG/QCLSRC) MBR(INVOICELO2)
             MONMSG     MSGID(CPF0000)
             IF         COND(&K = '88505') THEN(DO)
                CHGVAR     VAR(%SST(&FILE 1 2)) VALUE('FR')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0061' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO
             IF         COND(&K = '40631') THEN(DO)
                CHGVAR     VAR(%SST(&FILE 1 2)) VALUE('UK')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0060' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO

             CPYF       FROMFILE(GANG/QCLSRC) +
                          TOFILE(GANG/INVOICELOG) +
                          FROMMBR(INVOICELOG) TOMBR(*FIRST) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*CVTSRC)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(OUTPUT) TOFILE(GANG/QCLSRC) +
                          MBR(INVOICELO2)
             MONMSG     MSGID(CPF0000)
             FTP        RMTSYS('DOMETIC-GROUP.COM')
             DLTOVR     FILE(INPUT)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(OUTPUT)
             MONMSG     MSGID(CPF0000)

             DLTOVR     FILE(PROTOKOLL)
             MONMSG     MSGID(CPF0000)

             CHGCURLIB  CURLIB(*CRTDFT)

             IF         COND(&PARM = '1') THEN(DO)
             ENDDO
 ENDPGM:
             IF         COND(&ERROR3 = '0') THEN(DO)
                RMVLIBLE   LIB(POHL)
             ENDDO
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
             ENDDO
             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(WAECOEDI)
             ENDDO

             ENDPGM
