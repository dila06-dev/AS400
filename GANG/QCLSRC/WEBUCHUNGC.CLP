/*    * PROGRAMMNAME.:CALL WEBUCHUNGC                                        */
/*    * FUNKTION.....:VERBUCHUNG WARENEINGANG                                */
/*    * FEBRUAR 2010   GANG, MANFRED                                          */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&PARM)

             DCL        VAR(&PARM)    TYPE(*CHAR) LEN(01)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&OUTFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFKT)  TYPE(*CHAR) LEN(10)

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))
             CLRPFM     FILE(#HB0500)
             MONMSG     MSGID(CPF0000)

             DLTF       FILE(QTEMP/SBGNMON)
             MONMSG     MSGID(CPF0000)
             CRTPF      FILE(QTEMP/SBGNMON) RCDLEN(256)
             MONMSG     MSGID(CPF0000)

/*          NUR RELEVANTE 10ER SÄTZE                                         */
             CPYF       FROMFILE(QS36F/SBGN.MON)                 +
                          TOFILE(QTEMP/SBGNMON) MBROPT(*ADD)     +
                          CRTFILE(*NO) INCCHAR(*RCD 16 *EQ '10') +
                          FMTOPT(*NOCHK)


             MONMSG     MSGID(CPF0000)

             CALL       PGM(METROR)
             MONMSG     MSGID(CPF0000)
             DSPPFM     #HB0500
             MONMSG     MSGID(CPF0000)

             MONMSG     MSGID(CPF0000)
             IF         COND(&PARM = '1') THEN(DO)
             ENDDO
 ENDPGM:
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
             ENDDO

             ENDPGM
