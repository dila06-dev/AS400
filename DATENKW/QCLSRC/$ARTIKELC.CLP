/*    * PROGRAMMNAME.:$ARTIKELC                                              */
/*    * FUNKTION.....:...                                                    */
/*    * JULI    2010   GANG, MANFRED                                          */
/*    *                                                                       */
/*    *-DER JOB IST RESTARTFÄHIG                                             */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM

             DCL        VAR(&CODE)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&QTIME)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&LAGERBEWC) TYPE(*CHAR) LEN(32)
             DCL        VAR(&$LAGERBEWC) TYPE(*CHAR) LEN(01)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

/*   -AKTUALISIERUNG DER ARTIKELDATEN AKTIV(1), INAKTIV(0)                   */
             RTVDTAARA  DTAARA(DATENKW/$LAGERBEWC *ALL) +
                          RTNVAR(&$LAGERBEWC)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                 GOTO       CMDLBL(ENDPGM)
             ENDDO

/*   -AKTUALISIERUNG DER ARTIKELDATEN ÜBER STAMMDATEN                        */
             IF         COND(&$LAGERBEWC *NE '1') THEN(DO)
                   CHGDTAARA DTAARA(DATENKW/$LAGERBEWC *ALL) VALUE('1')
                   ADDLIBLE   LIB(GANG) POSITION(*LAST)
                   MONMSG     MSGID(CPF0000)
                   ADDLIBLE   LIB(DATENKW) POSITION(*LAST)
                   MONMSG     MSGID(CPF0000)
                   ADDLIBLE   LIB(BAR_KALK) POSITION(*LAST)
                   MONMSG     MSGID(CPF0000)
                   CLRPFM     FILE(BAR_KALK/KALK_FILES)

                   CALL      PGM(DUMMY512) PARM(&MD '#KA0290' ' ' ' ' +
                                '#KA0290' 'BAR_KALK' '*REPLACE')
                   CLRPFM     FILE(#KA0290L1)
                   MONMSG     MSGID(CPF0000)
/*                INDEX LEGEN AUF UMSÄTZE/ABSÄTZE                            */
                   CALL      PGM(DUMMY512) PARM(&MD '#KP0291' ' ' ' ' +
                             ' ' ' ' '*REPLACE')

/*                MENGEN AUS LAGER HOLEN                                     */
                   CALL      PGM(DUMMY512) PARM(&MD '#KP0105' ' ' ' ' +
                              '#KP0105' 'GANG' '*REPLACE')
                   CLRPFM     FILE(#KP0105L1)
                   MONMSG     MSGID(CPF0000)
/*                INDEX LEGEN AUF ARTIKEL UND LAGER                          */
                   CALL      PGM(DUMMY512) PARM(&MD '#KP0107' ' ' ' ' +
                              ' ' ' ' '*REPLACE')
/*                KALKULATION DURCHFÜHREN                                    */
                   CALL       PGM(BAR_KALK/KALK) PARM('$$EL_PS_DB')
                   MONMSG     MSGID(CPF0000) EXEC(DO)
                       GOTO       CMDLBL(ENDPGM)
                   ENDDO
/*                -ARTIKELDATEN AUFBAUEN                                     */
                   CALL PGM(ARTIKELC) PARM('$$EL_PS_DB')
                   MONMSG     MSGID(CPF0000) EXEC(DO)
                       GOTO       CMDLBL(ENDPGM)
                   ENDDO
/*                PROTOKOLL IN SBGFAN00                                      */
                   CALL      PGM(DUMMY512) PARM(&MD 'SKU0001' ' ' ' ' +
                             'SBGFAN00' 'QS36F' '*ADD')
                   MONMSG     MSGID(CPF0000)
                   CHGDTAARA DTAARA(DATENKW/$LAGERBEWC *ALL) VALUE('0')
             ENDDO

 ENDPGM:

             DSPJOBLOG  OUTPUT(*PRINT)
             SIGNOFF
             ENDPGM
