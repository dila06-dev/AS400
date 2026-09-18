/*    * PROGRAMMNAME.:CALL ........                                          */
/*    * FUNKTION.....:KALKINPUTC                                             */
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
             CHGVAR     VAR(&PGM) VALUE('KALKINPUTC')
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

             ADDLIBLE   LIB(PRODWIN51) POSITION(*FIRST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))
       /*   *** CLEAR                                                        */
             CLRPFM     FILE(TVRELWAECO/KALKINPUT)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/KALKOUTPUT)
             MONMSG     MSGID(CPF0000)

/*          ACHTUNG! INPUT AUS EXCEL MUSS KORREKT SEIN EVTL.                 */
/*          MONMSG UND AUSSTIEG EINBAUEN                                     */
       /*   *** ABRUFDATEI PC                                                */
   /*        CPYFRMIMPF FROMFILE(TVRELWAECO/SKUTRANSF#) +   */
   /*        TOFILE(TVRELWAECO/KALKINPUT)               +   */
   /*        MBROPT(*REPLACE) FLDDLM(';')               +   */
   /*        DECPNT(*COMMA) RPLNULLVAL(*FLDDFT)             */
   /*        MONMSG     MSGID(CPF0000)                      */

/*          INTEGRATION                                                      */
             CALL KALKINPUT
             MONMSG     MSGID(CPF0000)


/*          INTEGRATION EL                                                   */
             CALL KALKOUTPUT
             MONMSG     MSGID(CPF0000)

       /*   *** MAILING                                                      */
             RMVLNK     +
                          OBJLNK('/CONTROLLING/KALKULATION/KALKINPUT.+
                          CSV')
             MONMSG     MSGID(CPF0000)
             CVTDBF     +
                          OBJ('/CONTROLLING/KALKULATION/KALKINPUT.csv+
                          ') DBFILE(TVRELWAECO/KALKINPUT) +
                          DBOUTFMT(*CSV) DBFLDDSC(*YES)
             MONMSG     MSGID(CPF0000)
             RMVLNK     +
                          OBJLNK('/CONTROLLING/KALKULATION/KALKOUTPUT.+
                          CSV')
             MONMSG     MSGID(CPF0000)
             CVTDBF     +
                          OBJ('/CONTROLLING/KALKULATION/KALKOUTPUT.csv+
                          ') DBFILE(TVRELWAECO/KALKOUTPUT) +
                          DBOUTFMT(*CSV) DBFLDDSC(*YES)
             MONMSG     MSGID(CPF0000)
             OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                    FORMTYPE('KALKINPUT') OVRSCOPE(*JOB)
             MONMSG     MSGID(CPF0000)
             CALL    PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                             ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
             MONMSG     MSGID(CPF0000)
/*                                                                            */

 ENDPGM:
             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(PRODWIN51)
             ENDDO
             IF         COND(&ERROR2 = '0') THEN(DO)
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
