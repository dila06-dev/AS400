/*    * PROGRAMMNAME.:TREND ENVIRONMENT AUFBAUEN                             */
/*    * FUNKTION.....:..                                                     */
/*    * SEPTEMBER 2010   GANG, MANFRED                                        */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                          PGMR.....           */
/******************************************************************************/
             PGM

             DCL        VAR(&PARM) TYPE(*CHAR) LEN(01)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             CHGAUT OBJ('/LAGER/RHENANIA/OUTBOUND.CSV') +
             USER(*PUBLIC) DTAAUT(*RWX)                 +
             OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)
             MONMSG     MSGID(CPF0000)

             CHGAUT OBJ('/LAGER/RHENANIA/OUTBOUNDOP.CSV') +
             USER(*PUBLIC) DTAAUT(*RWX)                 +
             OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)
             MONMSG     MSGID(CPF0000)

    /*       HLDWTR WTR(PRTLAG01)              */
    /*       MONMSG     MSGID(CPF0000)         */
             RLSWTR WTR(PRTLAG01)
             MONMSG     MSGID(CPF0000)
    /*       DLYJOB     DLY(5)                 */
    /*       MONMSG     MSGID(CPF0000)         */
             RLSWTR WTR(PRTLAG02)
             MONMSG     MSGID(CPF0000)

    /*       HLDWTR     WTR(PRTLAG02) OPTION(*CNTRLD) */
    /*       MONMSG     MSGID(CPF0000)                */
    /*       RLSWTR     WTR(PRTLAG02)                 */
    /*       MONMSG     MSGID(CPF0000)                */

    /*       HLDWTR WTR(PRTLAG06)        */
    /*       MONMSG     MSGID(CPF0000)   */
             RLSWTR WTR(PRTLAG06)
             MONMSG     MSGID(CPF0000)


 ENDPGM:

             ENDPGM
