/*    * PROGRAMMNAME.:ÜBERNAHME TECHNISCHE FELDER                            */
/*    * FUNKTION.....:INITIALISIEREN DER BEREICHE                            */
/*    * 06.07.98                                                              */
/*    *                                                                       */
/*    * Manfred Gang                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&KONTO &FIRMA &KOSTENST &PROJEKT +
                          &MERKMALE &MENGE &KONTOX)

             DCL        VAR(&KONTO) TYPE(*DEC) LEN(09 0)
             DCL        VAR(&FIRMA) TYPE(*DEC) LEN(05 0)
             DCL        VAR(&KOSTENST) TYPE(*CHAR) LEN(01)
             DCL        VAR(&PROJEKT)  TYPE(*CHAR) LEN(01)
             DCL        VAR(&MERKMALE) TYPE(*CHAR) LEN(01)
             DCL        VAR(&MENGE)    TYPE(*CHAR) LEN(01)
             DCL        VAR(&KONTOX)   TYPE(*CHAR) LEN(05)
             DCL        VAR(&ERROR1)    TYPE(*CHAR) LEN(01) VALUE('0')
/*----------------------------------------------------------------------------*/
             ADDLIBLE   LIB(SFBF) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))
             MONMSG     MSGID(CPF0000)
             CALL       PGM(KONTOR) PARM(&KONTO &FIRMA &KOSTENST +
                          &PROJEKT &MERKMALE &MENGE &KONTOX)

ENDE:
             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(SFBF)
             ENDDO
             RCLRSC

             ENDPGM
