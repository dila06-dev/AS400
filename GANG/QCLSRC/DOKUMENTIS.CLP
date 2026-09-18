/*    * PROGRAMMNAME.: ZUGRIFF AUF DOKUMENTE                                  */
/*    * FUNKTION.....: ZUGRIFF AUF DOKUMENTE                                  */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&DOKUMENT)

             DCL        VAR(&COMMAND)  TYPE(*CHAR) LEN(128) VALUE(' ')
             DCL        VAR(&BEFEHL)   TYPE(*CHAR) LEN(132) VALUE(' ')
             DCL        VAR(&DOKUMENT) TYPE(*CHAR) LEN(132) VALUE(' ')
             DCL        VAR(&ERROR1)   TYPE(*CHAR) LEN(01)  VALUE('0')
             DCL        VAR(&ERROR2)   TYPE(*CHAR) LEN(01)  VALUE('0')

             RTVDTAARA  DTAARA(IBSSC/COMMAND) RTNVAR(&COMMAND)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))

              IF         COND(&ERROR2 = '0') THEN(DO)
                CHGVAR     VAR(&BEFEHL) VALUE('"' *TCAT &COMMAND *TCAT +
                           ' ' *CAT &DOKUMENT *TCAT '"')
                CHGVAR     VAR(&BEFEHL) VALUE(&COMMAND *TCAT +
                           ' ' *CAT &DOKUMENT)
                STRPCO     PCTA(*NO)
                MONMSG     MSGID(CPF0000)
                STRPCCMD   PCCMD(&BEFEHL) PAUSE(*NO)
                MONMSG     MSGID(CPF0000)
              ENDDO

              CRTDTAARA  DTAARA(QTEMP/EASYPRINT) TYPE(*CHAR) LEN(132)
              MONMSG     MSGID(CPF0000)
              CHGDTAARA  DTAARA(QTEMP/EASYPRINT) VALUE(&BEFEHL)
              MONMSG     MSGID(CPF0000)

  ENDPGM:
              IF         COND(&ERROR2 = '0') THEN(DO)
              ENDDO

              ENDPGM
