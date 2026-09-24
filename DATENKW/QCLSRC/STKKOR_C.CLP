/*    * PROGRAMMNAME.:$GANG                                                  */
/*    * FUNKTION.....:...                                                    */
/*    * JULI    2010   GANG, MANFRED                                          */
/*    *                                                                       */
/*    *-KORREKTUR STK                                                        */
/*    *                                                                       */
/*    *                                                                       */
/*    *                                                                       */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/

             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&CODE)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&SC) TYPE(*DEC) LEN(07 0) VALUE(0000000)
             DCL        VAR(&K)         TYPE(*CHAR) LEN(5)
             DCL        VAR(&#)         TYPE(*CHAR) LEN(1)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&QTIME)     TYPE(*CHAR) LEN(6)

             ADDLIBLE   LIB(DATENKW) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             ADDLIBLE   LIB(BAR_KALK) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))

             DLTF       FILE(#KW0030)
             MONMSG     MSGID(CPF0000)

             DLTF       FILE(#KW0032)
             MONMSG     MSGID(CPF0000)

             DLTF       FILE(#KW0050)
             MONMSG     MSGID(CPF0000)

             CALL    PGM(DUMMY512) PARM(&MD '#KW0030' ' ' ' ' +
                         '#KW0030' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)

             CALL    PGM(DUMMY512) PARM(&MD '#KW0032' ' ' ' ' +
                         '#KW0032' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)

             CALL    PGM(DUMMY512) PARM(&MD '#KW0033' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             CALL    PGM(DUMMY512) PARM(&MD '#KW0034' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             CALL    PGM(DUMMY512) PARM(&MD '#KW0035' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             CALL    PGM(DUMMY512) PARM(&MD '#KW0036' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             CALL    PGM(DUMMY512) PARM(&MD '#KW0037' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             CALL    PGM(DUMMY512) PARM(&MD '#KW0040' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             CALL    PGM(DUMMY512) PARM(&MD '#KW0041' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             CALL    PGM(DUMMY512) PARM(&MD '#KW0042' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             CALL    PGM(DUMMY512) PARM(&MD '#KW0043' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)

/*    *     BASISDATENBANK #KW0032 ACHTUNG!                                  */
/*    *     GEMATCHED MIT TREND UND EL_PS                                    */

/*    *     SIND MEHRFACH VORHANDEN ALS SKU ACHTUNG UND WERDEN DANN ..       */
             CALL    PGM(DUMMY512) PARM(&MD '#KW0050' ' ' ' ' +
                         '#KW0050' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*    *     .. VERBUNDEN ==> SKU UND ARTIKEL, DIE DOPPELT SIND               */
             CALL    PGM(DUMMY512) PARM(&MD '#KW0051' ' ' ' ' +
                         '#KW0051' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*    *     IN EL-PS GLEICHE ARTSKU ABER!!!! UNGLEICH ALS ARTIKEL            */
/*    *     DÜRFEN IN KEINEM FALL IN'S EL LANDEN                             */
             CALL    PGM(DUMMY512) PARM(&MD '#KW0052' ' ' ' ' +
                         '#KW0052' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*    *     INDEX QTEMP/#KW0051L1  ON QTEMP/#KW0051                          */
             CALL    PGM(DUMMY512) PARM(&MD '#KW0055' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(STKKOR_R)
             MONMSG     MSGID(CPF0000)
             CPYF       FROMFILE(QTEMP/#KW0032) +
                        TOFILE(DATENKW/S#KW0032) MBROPT(*ADD) +
                        CRTFILE(*NO)
             MONMSG     MSGID(CPF0000)

 ENDPGM:
     /*      DSPJOBLOG  OUTPUT(*PRINT)                */

             ENDPGM
