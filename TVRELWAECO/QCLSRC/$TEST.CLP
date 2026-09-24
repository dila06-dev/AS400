/*    * PROGRAMMNAME.:$INTERFACE                                             */
/*    * FUNKTION.....:...                                                    */
/*    * JULI    2010   GANG, MANFRED                                          */
/*    *                                                                       */
/*    *-DER JOB IST RESTARTFÄHIG                                             */
/*    * $INTERFACE                                                           */
/*    *  CHGDTAARA DTAARA(TVRELWAECO/$INTERFACE *ALL) VALUE('0')              */
/*    *  DSPDTAARA DTAARA(TVRELWAECO/$INTERFACE)                              */
/*    *  0 BEDEUTET NICHT AKTIV 1 BEDEUTET AKTIV                              */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM

             DCL        VAR(&CODE)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&QTIME)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&QDATETIME) TYPE(*CHAR) LEN(20)
             DCL        VAR(&$INTERFACE) TYPE(*CHAR) LEN(01)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

 LOOP:       RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&QTIME)
             RTVSYSVAL  SYSVAL(QDATETIME) RTNVAR(&QDATETIME)

             IF         COND(&QTIME *GT '070000') THEN(GOTO +
                          CMDLBL(ENDPGM))


/*   -AUFRUF VERBUCHUNG DER LAGERBEWEGUNGEN                                  */
             IF         COND(&QTIME *GT '190000') THEN(DO)

                CALL PGM(TVRELWAECO/SC62765_C) PARM('1')
                MONMSG     MSGID(CPF0000)
                GOTO       CMDLBL(ENDPGM)

             ENDDO


 ENDPGM:

             DSPJOBLOG  OUTPUT(*PRINT)

             ENDPGM
