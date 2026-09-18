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
             DCL        VAR(&DONE) TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&QTIME)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&$INTERFACE) TYPE(*CHAR) LEN(01)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')


 LOOP:       RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&QTIME)

             IF         COND(&QTIME *GT '210000') THEN(GOTO +
                          CMDLBL(ENDPGM))


/*   -AKTUALISIERUNG DER ARTIKELDATEN AKTIV(1), DNAKTIV(0)                   */
             RTVDTAARA  DTAARA(TVRELWAECO/$INTERFACE *ALL) +
                          RTNVAR(&$INTERFACE)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                 GOTO       CMDLBL(ENDPGM)
             ENDDO

/*   -ENDEBEDINGUNG  $INTERFACE = '0'                                        */
             IF         COND(&$INTERFACE *EQ '0') THEN(DO)
                 GOTO       CMDLBL(ENDPGM)
             ENDDO

/*   -AUFRUF VERBUCHUNG DER LAGERBEWEGUNGEN                                  */
             IF         COND(&QTIME *GT '185500') THEN(DO)
                CALL PGM(TVRELWAECO/SC88505_C) PARM('1')
                MONMSG     MSGID(CPF0000)
                CALL PGM(TVRELWAECO/SC40631_C) PARM('1')
                MONMSG     MSGID(CPF0000)
                CALL PGM(TVRELWAECO/SC01887_C) PARM('1')
                MONMSG     MSGID(CPF0000)
                CALL PGM(TVRELWAECO/SC15177_C) PARM('1')
                MONMSG     MSGID(CPF0000)
                CALL PGM(TVRELWAECO/SC62765_C) PARM('1')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/MESSAGE_SC) PARM('15177' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/MESSAGE_SC) PARM('62765' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
/*                                                             */
                CALL       PGM(TVRELWAECO/DELIVER_SC) PARM('40631' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/DELIVER_SC) PARM('54939' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/DELIVER_SC) PARM('62765' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/DELIVER_SC) PARM('02921' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/DELIVER_SC) PARM('01887' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/DELIVER_SC) PARM('78146' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/DELIVER_SC) PARM('05084' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/DELIVER_SC) PARM('88505' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/DELIVER_SC) PARM('55278' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/DELIVER_SC) PARM('15177' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/DELIVER_SC) PARM('42634' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/DELIVER_SC) PARM('08138' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)

                CALL PGM(TE11016_C) PARM('1')
                MONMSG     MSGID(CPF0000)

                GOTO       CMDLBL(ENDPGM)
             ENDDO

/*   -AUFRUF MESSAGES CONFIRMATION                                           */
             IF      COND(&QTIME *GT '143000' *AND &DONE *EQ '0') +
                          THEN(DO)
                CHGVAR     VAR(&DONE) VALUE('1')
                CALL       PGM(TVRELWAECO/MESSAGE_SC) PARM('88505' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/MESSAGE_SC) PARM('40631' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
             ENDDO

         /*  CALL PGM(TVRELWAECO/ORDERNAV_C)   */
         /*  MONMSG     MSGID(CPF0000)         */
             CALL PGM(TVRELWAECO/ABESTAND_C)
             MONMSG     MSGID(CPF0000)

             DLYJOB     DLY(900)
             GOTO       CMDLBL(LOOP)

 ENDPGM:

             DSPJOBLOG  OUTPUT(*PRINT)

             ENDPGM
