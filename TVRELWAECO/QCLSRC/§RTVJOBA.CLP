/*    * PROGRAMMNAME.:TREND ENVIRONMENT AUFBAUEN                             */
/*    * FUNKTION.....:..                                                     */
/*    * SEPTEMBER 2010   GANG, MANFRED                                        */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                          PGMR.....           */
/******************************************************************************/
             PGM        PARM(&FKT &§CURLIB &§USRLIB)

             DCL        VAR(&FKT)     TYPE(*CHAR) LEN(0006) VALUE(' ')
             DCL        VAR(&§CURLIB) TYPE(*CHAR) LEN(0010) VALUE(' ')
             DCL        VAR(&§USRLIB) TYPE(*CHAR) LEN(2750) VALUE(' ')
             DCL        VAR(&§RSTLIB) TYPE(*CHAR) LEN(2775) VALUE(' ')


       /*   *** LADEN LIBLIST IN SICHERUNG                                   */
             IF         COND(&FKT = 'LOAD') THEN(DO)
                RTVJOBA    CURLIB(&§CURLIB) USRLIBL(&§USRLIB)
                MONMSG     MSGID(CPF0000)
             ENDDO

       /*   *** RESTOREN LIBLIST AUS SICHERUNG                                   */
             IF         COND(&FKT = 'RELOAD') THEN(DO)
                CHGVAR     VAR(&§RSTLIB) +
                           VALUE('CHGLIBL LIBL(' !! &§USRLIB !< ')')
                CALL       PGM(QCMDEXC) PARM(&§RSTLIB 2775)
                MONMSG     MSGID(CPF0000)
             ENDDO

 ENDPGM:

             ENDPGM
