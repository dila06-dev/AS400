/*    * PROGRAMMNAME.:......                                                 */
/*    * FUNKTION.....:...                                                    */
/*    * JANUAR  2012   M. GANG                                                */
/******************************************************************************/
             PGM

             DCL        VAR(&CODE)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&DONE) TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&RUN) TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&QTIME)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&$INTERFACE) TYPE(*CHAR) LEN(01)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('TRTESTENVC')
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

             ADDLIBLE   LIB(TMNP)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(MODWAO1) POSITION(*AFTER TMNP)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(MODWAOTEST) POSITION(*AFTER MODWAO1)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(MODWAO) POSITION(*AFTER MODWAOTEST)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(TEVMFTEST) POSITION(*AFTER MODWAO)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(TEVMP) POSITION(*AFTER TEVMFTEST)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(TAMF1) POSITION(*AFTER TEVMP)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(TAMFTEST) POSITION(*AFTER TAMF1)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(TAMP1) POSITION(*AFTER TAMFTEST)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(TVPP) POSITION(*AFTER TAMP1)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(TEVMF) POSITION(*AFTER TVPP)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(TAMF) POSITION(*AFTER TEVMF)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(TVPFTEST) POSITION(*AFTER TAMF)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(SEAXCALP) POSITION(*AFTER TVPF)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(MODWAOQRY) POSITION(*AFTER SEAXCALP)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(TVRELWAECO) POSITION(*AFTER MODWAOQRY)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(DOMDTAPRD) POSITION(*AFTER TVRELWAECO)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(EDIFACT) POSITION(*AFTER DOMDTAPRD)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(GANG) POSITION(*AFTER EDIFACT)
             MONMSG     MSGID(CPF0000)

 ENDPGM:
   /*        DSPJOBLOG  OUTPUT(*PRINT)      */

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


