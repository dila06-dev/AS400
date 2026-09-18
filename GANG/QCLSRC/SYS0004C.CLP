/*    * PROGRAMMNAME.:SYS0004C                                               */
/*    * FUNKTION.....:API CALLS                                              */
/*    * OKTOBER 2009                                                          */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&PARM &LENGTHA &LIB &PGMART)

/*----------------------------------------------------------------------------*/

/* &PGM      PARM                                              */
             DCL        VAR(&PARM)   TYPE(*CHAR) LEN(256)
/* &LIB      STRING-LENGTH                                     */
             DCL        VAR(&LENGTH) TYPE(*DEC) LEN(15 5)
             DCL        VAR(&LENGTHA) TYPE(*CHAR) LEN(15)
/* &LIB      BIBLIOTHEK                                        */
             DCL        VAR(&LIB)    TYPE(*CHAR) LEN(10)
/* &PGMART   PROGRAMMART                                       */
             DCL        VAR(&PGMART) TYPE(*CHAR) LEN(1)
/* &PGM      PROGRAMMART                                       */
             DCL        VAR(&PGM   ) TYPE(*CHAR) LEN(10)

             DCL        VAR(&ERROR)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&PGMSAVE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CURLIB) TYPE(*CHAR) LEN(10)
/*----------------------------------------------------------------------------*/
             IF         COND(&PGMART = 'D') THEN(DO)
                RTVDTAARA  DTAARA(*LDA (954 10)) RTNVAR(&PGMSAVE)
                CHGDTAARA  DTAARA(*LDA (954 10)) VALUE(&PGM)
             ENDDO
             RTVJOBA    CURLIB(&CURLIB)
             ADDLIBLE   LIB(&LIB)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR) +
                          VALUE('1'))
             CHGVAR     VAR(&LENGTH) VALUE(&LENGTHA)
             CALL       PGM(*LIBL/QCMDEXC) PARM(&PARM &LENGTH)
             MONMSG     MSGID(CPF0000)
             CHGCURLIB  &CURLIB
             MONMSG     MSGID(CPF0000)
             IF         COND(&ERROR = '0') THEN(DO)
                RMVLIBLE   LIB(&LIB)
                MONMSG     MSGID(CPF0000)
             ENDDO
ENDE:
             IF         COND(&PGMART = 'D') THEN(DO)
                CHGDTAARA  DTAARA(*LDA (954 10)) VALUE(&PGMSAVE)
             ENDDO
             ENDPGM
