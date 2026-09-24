/*    * PROGRAMMNAME.: $GANG                                                 */
/*    * FUNKTION.....: ...                                                   */
/*    * OKTOBER  2010   GANG, MANFRED                                         */
/*    *                                                                       */
/*    *...                                                                   */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM

             DCL        VAR(&CRTDATE)    TYPE(*CHAR) LEN(13)
             DCL        VAR(&NBRCURRCD)  TYPE(*DEC) LEN(10 0)
             DCL        VAR(&MBR)        TYPE(*CHAR) LEN(10)
             CLRPFM     FILE(#RAB1)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(#RAB2)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(#RAB3)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(#RAB4)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(#RAB4)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(#RAB5)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(#RAB6)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(RABATTE)
             MONMSG     MSGID(CPF0000)

 ENDPGM:

     /*      DSPJOBLOG  OUTPUT(*PRINT)                */

             ENDPGM
