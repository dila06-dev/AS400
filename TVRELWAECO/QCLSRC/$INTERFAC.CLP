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
             DCL        VAR(&$INTERFACE) TYPE(*CHAR) LEN(01)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&QTIME)

/*             -AUFRUF MESSAGES CONFIRMATION DAILY                           */
                CALL       PGM(TVRELWAECO/MESSAGE_SC) PARM('15177' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/MESSAGE_SC) PARM('62765' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/MESSAGE_SC) PARM('98264' +
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
                CALL       PGM(TVRELWAECO/MESSAGE_SC) PARM('88505' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/MESSAGE_SC) PARM('40631' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TVRELWAECO/MESSAGE_SC) PARM('78678' +
                          '20110111' '2')
                MONMSG     MSGID(CPF0000)

 ENDPGM:


             ENDPGM
