/*    * PROGRAMMNAME.:ABSATZZAHLEN ERMITTELN                                 */
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
             DCL        VAR(&CALL) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ABSATZR) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')

             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('ABSATZICC ')
             RTVMBRD    FILE(TVRELWAECO/QCLSRC) MBR(&PGM) TEXT(&TXT)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('START')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */

             ADDLIBLE   LIB(TVRELWAECO) POSITION(*FIRST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))

/*          ______________________________________________                   */
/*          CLEAR                                                            */
             CLRPFM     FILE(TVRELWAECO/ICSPRICE)
             MONMSG     MSGID(CPF0000)
/*          ______________________________________________                   */

             CALL       PGM(TVRELWAECO/ABSATZICR)
             MONMSG     MSGID(CPF0000)

/*          ________UK____________________________________                   */
             CPYF       FROMFILE(TVRELWAECO/ICSPRICE) +
                          TOFILE(TVRELWAECO/ICSPRICEUK) +
                          MBROPT(*REPLACE) CRTFILE(*NO)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(%SST(&MD 01 06)) VALUE('040631')
             CALL  PGM(DUMMY512) PARM(&MD '#DC5600' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             CALL  PGM(DUMMY512) PARM(&MD '#DC5601' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             CALL  PGM(DUMMY512) PARM(&MD '#DC5602' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)

/*          ________FR____________________________________                   */
             CPYF       FROMFILE(TVRELWAECO/ICSPRICE) +
                          TOFILE(TVRELWAECO/ICSPRICEFR) +
                          MBROPT(*REPLACE) CRTFILE(*NO)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(%SST(&MD 01 06)) VALUE('088505')
             CALL  PGM(DUMMY512) PARM(&MD '#DC5700' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             CALL  PGM(DUMMY512) PARM(&MD '#DC5701' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             CALL  PGM(DUMMY512) PARM(&MD '#DC5702' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)

/*          ________ES____________________________________                   */
             CPYF       FROMFILE(TVRELWAECO/ICSPRICE) +
                          TOFILE(TVRELWAECO/ICSPRICEES) +
                          MBROPT(*REPLACE) CRTFILE(*NO)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(%SST(&MD 01 06)) VALUE('078146')
             CALL  PGM(DUMMY512) PARM(&MD '#DC5800' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             CALL  PGM(DUMMY512) PARM(&MD '#DC5801' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             CALL  PGM(DUMMY512) PARM(&MD '#DC5802' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)

/*          ________SE____________________________________                   */
             CPYF       FROMFILE(TVRELWAECO/ICSPRICE) +
                          TOFILE(TVRELWAECO/ICSPRICESE) +
                          MBROPT(*REPLACE) CRTFILE(*NO)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(%SST(&MD 01 06)) VALUE('008138')
             CALL  PGM(DUMMY512) PARM(&MD '#DC5900' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             CALL  PGM(DUMMY512) PARM(&MD '#DC5901' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             CALL  PGM(DUMMY512) PARM(&MD '#DC5902' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)

/*          ________NO____________________________________                   */
             CPYF       FROMFILE(TVRELWAECO/ICSPRICE) +
                          TOFILE(TVRELWAECO/ICSPRICENO) +
                          MBROPT(*REPLACE) CRTFILE(*NO)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(%SST(&MD 01 06)) VALUE('042634')
             CALL  PGM(DUMMY512) PARM(&MD '#DC6000' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             CALL  PGM(DUMMY512) PARM(&MD '#DC6001' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             CALL  PGM(DUMMY512) PARM(&MD '#DC6002' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)

/*          ________CH____________________________________                   */
             CPYF       FROMFILE(TVRELWAECO/ICSPRICE) +
                          TOFILE(TVRELWAECO/ICSPRICECH) +
                          MBROPT(*REPLACE) CRTFILE(*NO)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(%SST(&MD 01 06)) VALUE('002921')
             CALL  PGM(DUMMY512) PARM(&MD '#DC6100' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             CALL  PGM(DUMMY512) PARM(&MD '#DC6101' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             CALL  PGM(DUMMY512) PARM(&MD '#DC6102' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)

/*          ________DK____________________________________                   */
             CPYF       FROMFILE(TVRELWAECO/ICSPRICE) +
                          TOFILE(TVRELWAECO/ICSPRICEDK) +
                          MBROPT(*REPLACE) CRTFILE(*NO)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(%SST(&MD 01 06)) VALUE('001887')
             CALL  PGM(DUMMY512) PARM(&MD '#DC6200' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             CALL  PGM(DUMMY512) PARM(&MD '#DC6201' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             CALL  PGM(DUMMY512) PARM(&MD '#DC6202' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
/*          ______________________________________________                   */

 ENDPGM:
             IF         COND(&ERROR2 = '0') THEN(DO)
    /*          RMVLIBLE   LIB(GANG)                       */
             ENDDO
             IF         COND(&ERROR1 = '0') THEN(DO)
    /*          RMVLIBLE   LIB(TVRELWAECO)                 */
             ENDDO

/*          PROTOKOLLIERUNG ---                                           */
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('ENDE ')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */

             ENDPGM
