/*    * PROGRAMMNAME.:#SNDMSG                                                */
/*    * FUNKTION.....:NACHRICHTEN AN EIN BESTIMMTES PROGRAMM SENDEN          */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&MSG &MSGF &DATA)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(256)
             SNDPGMMSG  MSGID(&MSG) MSGF(&MSGF) MSGDTA(&DATA) +
                          TOPGMQ(*PRV)
             MONMSG     MSGID(CPF0000)
             ENDPGM
