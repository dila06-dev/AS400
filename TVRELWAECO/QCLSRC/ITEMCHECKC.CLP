/*    * PROGRAMMNAME.:CALL ........                                          */
/*    * FUNKTION.....:ITEMCHECKC                                             */
/*    *               ...                                                    */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM

             DCL        VAR(&PARM)    TYPE(*CHAR) LEN(01)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&ERROR1)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&OUTFILE)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFKT)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBRCURRCD)  TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBRCURRCD2) TYPE(*DEC) LEN(10 0)

             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('ITEMCHECKC')
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
             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))


       /*   *** ITEMCHECKC                                                   */
             CALL       PGM(DUMMY512) PARM(&MD '#KP0108' ' ' ' ' +
                           '#KP0108   '  'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*                                                                            */
             CALL       PGM(DUMMY512) PARM(&MD '#KP0109' ' ' ' ' +
                           '#KP0109   '  'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*                                                                            */
             CALL       PGM(DUMMY512) PARM(&MD '#KP0110' ' ' ' ' +
                           '#KP0110   '  'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*                                                                            */
             CALL       PGM(DUMMY512) PARM(&MD '#KP0112' ' ' ' ' +
                           ' '  ' ' ' ')
             MONMSG     MSGID(CPF0000)
/*                                                                            */
             CPYF FROMFILE(QTEMP/#KP0110) TOFILE(QTEMP/#KP0111) +
             MBROPT(*ADD) FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF0000)
/*                                                                            */
             RMVLNK     OBJLNK('/LOGISTIC/ITEMCHECK/ITEMCHECKC.CSV')
             MONMSG     MSGID(CPF0000)
             CVTDBF     OBJ('/LOGISTIC/ITEMCHECK/ITEMCHECKC.CSV') +
                          DBFILE(QTEMP/#KP0110) +
                          DBOUTFMT(*CSV) DBFLDDSC(*YES)
             MONMSG     MSGID(CPF0000)
             OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                    FORMTYPE('ITEMCHECKC') OVRSCOPE(*JOB)
             MONMSG     MSGID(CPF0000)
/*                                                                            */
       /*   *** ARTIKELINFOS ZUSATZDATEN                                     */
             CLRPFM     FILE(TVRELWAECO/ITEMINFO)
             MONMSG     MSGID(CPF0000)
             CALL ITEMINFOR
             MONMSG     MSGID(CPF0000)
             RMVLNK     OBJLNK('/LOGISTIC/ITEMCHECK/ITEMINFO.CSV')
             MONMSG     MSGID(CPF0000)
             CVTDBF     OBJ('/LOGISTIC/ITEMCHECK/ITEMINFO.CSV') +
                        DBFILE(TVRELWAECO/ITEMINFO) +
                        DBOUTFMT(*CSV) DBFLDDSC(*YES)
             MONMSG     MSGID(CPF0000)
             OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                    FORMTYPE('ITEMCHECKC') OVRSCOPE(*JOB)
             MONMSG     MSGID(CPF0000)

/*                                                                            */
             CALL       PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                          ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
             MONMSG     MSGID(CPF0000)
/*                                                                            */
 ENDPGM:
             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&ERROR2 = '0') THEN(DO)
             ENDDO
     /*      DSPJOBLOG  OUTPUT(*PRINT)        */

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
