/*    * PROGRAMMNAME.:CALL ........                                          */
/*    * FUNKTION.....:IDCO                                                   */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    * .                                                                     */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&IFAKIFFI &IFAKMAAF &PARM)

             DCL        VAR(&PARM)    TYPE(*CHAR) LEN(01)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&IFAKIFFI)   TYPE(*CHAR) LEN(05)
             DCL        VAR(&IFAKMAAF)   TYPE(*CHAR) LEN(10)

             DCL        VAR(&ERROR1)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&OUTFILE)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFKT)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBRCURRCD)  TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBRCURRCD2) TYPE(*DEC) LEN(10 0)

             ADDLIBLE   LIB(TVRELWAECO) POSITION(*AFTER TFXF)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))

             IF         COND(&PARM *EQ '1' ) THEN(DO)
/*             GENERELLER AUFBAU PROTOKOLL                                   */
                CALL       PGM(DUMMY512) PARM(&MD '#DC4500' ' ' ' ' +
                           '#AFKM40631' 'TVRELWAECO' '*ADD')
                MONMSG     MSGID(CPF0000)
/*             GREAT BRITAIN ZUORDNUNG ALLER INHALTE                         */
                CALL   PGM(SC40631_RB)
                MONMSG     MSGID(CPF0000)
                RTVMBRD    FILE(QTEMP/#DC4501) NBRCURRCD(&NBRCURRCD)
                MONMSG     MSGID(CPF0000)

/*             STATUS ÄNDERN PROTOKOLL                                       */
                CALL       PGM(DUMMY512) PARM(&MD '#DC4502' ' ' ' ' +
                           ' ' ' ' ' ')
                MONMSG     MSGID(CPF0000)

                IF         COND(&NBRCURRCD *GT 0) THEN(DO)
                   IF         COND(&IFAKIFFI *EQ '40631') THEN(DO)
                   OVRPRTF    FILE(QPQUPRFIL) TOFILE(*LIBL/QPQUPRFIL) +
                          FORMTYPE('UKOUTPUT') OVRSCOPE(*JOB)
                      MONMSG     MSGID(CPF0000)
                   ENDDO
/*                             */
                   RUNQRY     QRY(TVRELWAECO/#DC4501) RCDSLT(*NO)
                   MONMSG     MSGID(CPF0000)
                   DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
                   MONMSG     MSGID(CPF0000)
                ENDDO
             ENDDO
/*                                                                            */
 ENDPGM:
             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(TVRELWAECO)
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
                MONMSG     MSGID(CPF0000)
             ENDDO

             ENDPGM
