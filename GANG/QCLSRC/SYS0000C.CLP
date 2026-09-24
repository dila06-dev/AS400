/*    * PROGRAMMNAME.:SYS0000C                                               */
/*    * FUNKTION.....:CALL COMMANDS                                          */
/*    * OKTOBER 2009                                                          */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&PARM &LENGTHA)

/*----------------------------------------------------------------------------*/

/* &PGM      PROGRAMM                                          */
             DCL        VAR(&PARM)   TYPE(*CHAR) LEN(256)
/* &LIB      BIBLIOTHEK                                        */
             DCL        VAR(&LENGTH) TYPE(*DEC) LEN(15 5)
             DCL        VAR(&LENGTHA) TYPE(*CHAR) LEN(15)

             DCL        VAR(&ERROR)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&PGMSAVE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CURLIB) TYPE(*CHAR) LEN(10)
/*----------------------------------------------------------------------------*/
             CHGVAR     VAR(&LENGTH) VALUE(&LENGTHA)
             CALL       PGM(*LIBL/QCMDEXC) PARM(&PARM &LENGTH)
ENDE:
             ENDPGM
