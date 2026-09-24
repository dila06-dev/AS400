/*    * PROGRAMMNAME.:OBSOLETE                                               */
/*    * HINWEIS     .:==> PARAMETER D IST DERZEIT IMMER *BLANK               */
/*    *             .:    FUNKTION "GESTERN" IST AUSGESCHALTET               */
/*    *             .:    DAMIT WIRD DER AKTUELLE TAG ALS AUS-               */
/*    *             .:    GABE GENOMMEN(NAMENSVERGABE)                       */
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
      /*        CALL    PGM($DATER) PARM(&GESTERN &TAG &MONAT &JAHR */
      /*                  &WOTAG)                                   */
      /*        MONMSG     MSGID(CPF0000)                           */
      /*        CHGVAR     VAR(%SST(&FILE 3 8)) VALUE(&GESTERN)     */
      /*        CHGVAR   VAR(%SST(&D 5 2)) VALUE(%SST(&FILE 5 2))   */
      /*        CHGVAR   VAR(%SST(&D 3 2)) VALUE(%SST(&FILE 7 2))   */
      /*        CHGVAR   VAR(%SST(&D 1 2)) VALUE(%SST(&FILE 9 2))   */
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
             ADDLIBLE   LIB(WAECOEDI) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             IF         COND(&K *NE '88505' *AND &K *NE '40631') +
                          THEN(DO)
                GOTO ENDPGM
             ENDDO

    /*      AUFBAU DER UPDATE-FILE FÜR OBSOLETE ARTICLES                     */
             CALL       PGM(DUMMY512) PARM(&MD '#DC0051' ' ' ' ' +
                             '#DC0051' 'BAR_KALK' '*ADD')
             MONMSG     MSGID(CPF0000)
    /*      LÖSCHEN ÄLTERER SÄTZE                                            */
             CALL       PGM(DUMMY512) PARM(&MD '#DC0052' ' ' ' ' ' ' +
                          ' ' ' ')
             MONMSG     MSGID(CPF0000)
    /*      ÜBERGABEDATEI GENERIEREN FÜR PROTOKOLL(#DC0053) *ADD  */
    /*       CALL       PGM(DUMMY512) PARM(&MD '#DC0053' ' ' ' ' + */
    /*                       'OBSOLETE' 'GANG' '*ADD')             */
    /*       MONMSG     MSGID(CPF0000)                             */

    /*      ÜBERGABEDATEI GENERIEREN FÜR PROTOKOLL(#DC0053) *REPLACE         */
             DLTF       FILE(GANG/OBSOLETE)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0053' ' ' ' ' +
                             'OBSOLETE' 'GANG' '*REPLACE')
             MONMSG     MSGID(CPF0000)

             CHGCURLIB  CURLIB(GANG)

             OVRDBF     FILE(INPUT) TOFILE(GANG/QCLSRC) MBR(OBSOLETCMD)
             IF         COND(&K = '88505') THEN(DO)
                CHGVAR     VAR(%SST(&FILE 1 2)) VALUE('OA')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0061' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO
             IF         COND(&K = '40631') THEN(DO)
                CHGVAR     VAR(%SST(&FILE 1 2)) VALUE('OA')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0060' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO
             CHGVAR     VAR(%SST(&MD 1 10)) VALUE(&FILE)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0079' ' ' ' ' ' ' +
                          ' ' ' ')
             CLRPFM FILE(GANG/QCLSRC) MBR(OBSOLETLOG)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(OUTPUT) TOFILE(GANG/QCLSRC) +
                          MBR(OBSOLETLOG)
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
             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(WAECOEDI)
             ENDDO

             ENDPGM
