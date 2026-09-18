/*    * PROGRAMMNAME.:E_ZOLLNR                                               */
/*    * FUNKTION.....:ZOLLNUMMERNÜBERGABE IN ARTIKELSTAMM                    */
/*    * JANUAR   2010                                                         */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/

             DCL        VAR(&PARM)    TYPE(*CHAR) LEN(01)
             DCL        VAR(&VERSION) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&OUTFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)
             DCL        VAR(&VON) TYPE(*DEC) LEN(6 0) VALUE(010110)
             DCL        VAR(&BIS) TYPE(*DEC) LEN(6 0) VALUE(310311)
             DCL        VAR(&NBRCURRCD) TYPE(*DEC) LEN(10)

             DCLF       FILE(bar_kalk/P_KUNDE)

             ADDLIBLE   LIB(BAR_KALK) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))
             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))

/*             ZOLLNUMMERNÜBERGABE                                           */
                CALL       PGM(DUMMY512) PARM(&MD '#SC0010' ' ' ' ' +
                             'E_ZOLLNR' 'BAR_KALK' '*ADD')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(SBGART01_P) PARM('               ' ' ')
                MONMSG     MSGID(CPF0000)
                DLTF       FILE(GANG/E_ZOLLNR#1)
                MONMSG     MSGID(CPF0000)

 ENDPGM:
             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(BAR_KALK)
             ENDDO
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
             ENDDO

             ENDPGM
