/*    * PROGRAMMNAME.:$INTERFACE                                             */
/*    * FUNKTION.....:...                                                    */
/*    * JULI    2010   GANG, MANFRED                                          */
/*    *                                                                       */
/*    *-DER JOB IST RESTARTFÄHIG                                             */
/*    * ....                                                                 */
/*    *  SELECT ODLBNM, ODUDAT, ODCRTU, ODOBNM, ODOBTP, ODOBAT, ODOBSZ        */
/*    *  FROM                                                                 */
/*    *  #OBJEKTE ORDER BY ODOBSZ                                             */
/*    *                                                                -------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM

             DCL        VAR(&CODE)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&QTIME)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&QDATETIME) TYPE(*CHAR) LEN(20)
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
             CHGVAR     VAR(&PGM) VALUE('#OBJEKTE  ')
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

/*   -AUFRUF  */

             QSYS/DSPOBJD OBJ(*USRLIBL/*ALL) OBJTYPE(*ALL) +
                          OUTPUT(*OUTFILE) +
                          OUTFILE(TVRELWAECO/#OBJEKTE) +
                          OUTMBR(*FIRST *ADD)
             MONMSG     MSGID(CPF0000)

             QSYS/DSPOBJD OBJ(DATENKW/*ALL) OBJTYPE(*ALL) +
                          OUTPUT(*OUTFILE) +
                          OUTFILE(TVRELWAECO/#OBJEKTE) +
                          OUTMBR(*FIRST *ADD)
             MONMSG     MSGID(CPF0000)

       /*   *** SENDEN INFOS                                                 */
/*                                                                            */
             CALL       PGM(DUMMY512) PARM(&MD '#DC0009' ' ' ' ' +
                          '#DC0009' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*                                                                            */
             RMVLNK     OBJLNK('/IT/#OBJEKTE.CSV')
             MONMSG     MSGID(CPF0000)
             CVTDBF     OBJ('/IT/#OBJEKTE.CSV') +
                          DBFILE(QTEMP/#DC0009)          +
                          DBOUTFMT(*CSV) DBFLDDSC(*YES)
             MONMSG     MSGID(CPF0000)
             OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                    FORMTYPE('#OBJEKTE') OVRSCOPE(*JOB)
             MONMSG     MSGID(CPF0000)
/*                                                                            */
             CALL       PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                          ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
             MONMSG     MSGID(CPF0000)

 ENDPGM:

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
