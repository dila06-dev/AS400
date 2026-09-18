/*    * PROGRAMMNAME.:..                                                     */
/*    * FUNKTION.....:..                                                     */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&PARM &CUSTOMER &ORDERC)

             DCL        VAR(&PARM)    TYPE(*CHAR) LEN(01)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&OUTFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFKT)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&SPLNBR) TYPE(*DEC) LEN(06 0)
             DCL        VAR(&CUSTOMER) TYPE(*DEC) LEN(05 0)
             DCL        VAR(&ORDERC)  TYPE(*CHAR) LEN(08)

             CHGVAR     VAR(&CUSTOMER) VALUE(40631)
             CHGVAR     VAR(&ORDERC) VALUE('160207  ')

             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))

             CLRPFM     FILE(GANG/EDC_ORDERR)
             MONMSG     MSGID(CPF0000)

             CALL       PGM(EDC_ORDERR) PARM(&PARM &CUSTOMER &ORDERC)
             MONMSG     MSGID(CPF0000)

        /*   CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&VERSION)  */
        /*   CALL       PGM(DUMMY512) PARM(&MD '#FT1200' ' ' ' ' +*/
        /*                '#FT1200' 'QTEMP' '*REPLACE')           */
        /*   MONMSG     MSGID(CPF0000)                            */

             RUNQRY     QRY(GANG/EDC_ORDERQ)

     /*      WRKSPLFA   FILE(QPQUPRFIL) JOB(&NBR/&USER/&JOB) + */
     /*                   SPLNBR(*LAST)                        */
     /*      MONMSG     MSGID(CPF0000)                         */

             FAXSPLF    EMAIL('Theresa Bowler/Dometic Ltd/United') +
                          FILE(QPQUPRFIL) JOB(&NBR/&USER/&JOB) +
                          SPLNBR(*LAST) DLTSPLF(*NO)
             MONMSG     MSGID(CPF0000)

             FAXSPLF    EMAIL('hartmann@waeco.de') FILE(QPQUPRFIL) +
                          JOB(&NBR/&USER/&JOB) SPLNBR(*LAST) +
                          DLTSPLF(*NO)
             MONMSG     MSGID(CPF0000)

             FAXSPLF    EMAIL('gang@waeco.de') FILE(QPQUPRFIL) +
                          JOB(&NBR/&USER/&JOB) SPLNBR(*LAST) +
                          DLTSPLF(*YES)
             MONMSG     MSGID(CPF0000)

             IF         COND(&PARM = '1') THEN(DO)
             ENDDO
 ENDPGM:
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
             ENDDO

             ENDPGM
