/*    * PROGRAMMNAME.:TREND ENVIRONMENT AUFBAUEN                             */
/*    * FUNKTION.....:..                                                     */
/*    * SEPTEMBER 2010   GANG, MANFRED                                        */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                          PGMR.....           */
/******************************************************************************/
             PGM

             DCL        VAR(&PARM) TYPE(*CHAR) LEN(04)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')

             CALL PGM(TVRELWAECO/ORDERNAV_C)
             MONMSG     MSGID(CPF0000)

             CALL PGM(#DEFLDA)
             MONMSG     MSGID(CPF0000)

 ENDPGM:

             ENDPGM
