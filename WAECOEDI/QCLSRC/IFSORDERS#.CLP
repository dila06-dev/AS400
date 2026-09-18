/*    * PROGRAMMNAME.:CALL AUF WAECOEDI/IFSORDREAP                           */
/*    * FUNKTION.....:PROTOKOLLIERUNG ERWEITERUNG TEXTE                      */
/*    * MÄRZ 2010   GANG, MANFRED                                             */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&HEADPATH &LINEPATH)

             DCL        VAR(&PARM)    TYPE(*CHAR) LEN(01)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')

             DCL        VAR(&HEADPATH) TYPE(*CHAR) LEN(140)
             DCL        VAR(&LINEPATH) TYPE(*CHAR) LEN(140)
             RTVJOBA    USER(&USER)

             CALL       PGM(WAECOEDI/IFSORDREAP) PARM(&HEADPATH +
                          &LINEPATH &USER)

             MONMSG     MSGID(CPF0000)

 ENDPGM:
             IF         COND(&ERROR2 = '0') THEN(DO)
             ENDDO

             ENDPGM
