/*    * PROGRAMMNAME.:$GANG                                                  */
/*    * FUNKTION.....:...                                                    */
/*    * JULI    2010   GANG, MANFRED                                          */
/*    *                                                                       */
/*    *-START SUBSTYSTEM                                                     */
/*    * SELECT TETENR, CHAR('001') LAGER FROM TEIL                            */
/*    *       .                                                               */
/*    *            .                                                          */
/*    *                .                                                      */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/

             DCL        VAR(&ERROR1)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&CODE)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&SC) TYPE(*DEC) LEN(07 0) VALUE(0000000)
             DCL        VAR(&K)         TYPE(*CHAR) LEN(5)
             DCL        VAR(&#)         TYPE(*CHAR) LEN(1)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&QTIME)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&DAFEHL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&QDAYOFWEEK) TYPE(*CHAR) LEN(04)
             DCL        VAR(&QDATETIME)  TYPE(*CHAR) LEN(20)
             DCL        VAR(&QDAY)  TYPE(*CHAR) LEN(02)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)
             DCL        VAR(&NBRCURRCD)  TYPE(*DEC) LEN(10 0)
             DCL        VAR(&D)          TYPE(*CHAR) LEN(8)
             RTVSYSVAL  SYSVAL(QDATETIME) RTNVAR(&QDATETIME)
             CHGVAR     VAR(&D) VALUE(%SST(&QDATETIME 1 8))
             CHGVAR     VAR(&D) VALUE('20130401')

             ADDLIBLE   LIB(TVRELWAECO) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('#JOBS     ')

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('#JOBS     ')
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

             RTVSYSVAL  SYSVAL(QDAYOFWEEK) RTNVAR(&QDAYOFWEEK)
             MONMSG     MSGID(CPF0000)
             RTVSYSVAL  SYSVAL(QDAY) RTNVAR(&QDAY)
             MONMSG     MSGID(CPF0000)
       /*    *MON  */
       /*    *TUE  */
       /*    *WED  */
       /*    *THU  */
       /*    *FRI  */
       /*    *SAT  */
       /*    *SUN  */

/*    _HÜLLE_________________________________________________________     */
             IF         COND(&QDAYOFWEEK = '*WED' *AND &QDAY < '03') +
                          THEN(DO)
       /*   *** STK3                                                         */
             DSPUSRPRF  USRPRF(*ALL) OUTPUT(*OUTFILE) +
                          OUTFILE(TVRELWAECO/#DSPUSRPRF)
             MONMSG     MSGID(CPF0000)



/*                                                                            */
             ENDDO
/*    _______________________________________________________________     */

/*    _______________________________________________________________     */
/*    _CALL ANALYSESKU ______________________________________________     */
             IF         COND(&QDAYOFWEEK *NE '*SUN' *AND &QDAY < +
                          '99') THEN(DO)
       /*   *** AUSLAGERUNGEN ORDERINPUT                                     */
          /*    CALL       PGM(BAR_KALK/STR_KALK) PARM('0')  */
          /*    MONMSG     MSGID(CPF0000)                    */
                CALL       PGM(ANALYSESKU)
                MONMSG     MSGID(CPF0000)
                RTVMBRD    FILE(TVRELWAECO/ANALYSESKU) MBR(*FIRST) +
                           NBRCURRCD(&NBRCURRCD)
                MONMSG     MSGID(CPF0000)
                IF         COND(&NBRCURRCD *NE 0) THEN(DO)
                   RMVLNK     OBJLNK('/SALESCOMPANY/ANALYSESKU.CSV')
                   MONMSG     MSGID(CPF0000)
                   CVTDBF     OBJ('/SALESCOMPANY/ANALYSESKU.CSV') +
                              DBFILE(TVRELWAECO/ANALYSESKU) +
                              DBOUTFMT(*CSV) DBFLDDSC(*YES)
                   MONMSG     MSGID(CPF0000)
                   OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                              FORMTYPE('ANALYSESKU') OVRSCOPE(*JOB)
                   MONMSG     MSGID(CPF0000)
                   CALL  PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                               ' ' ' ' ' ')
                   MONMSG     MSGID(CPF0000)
                   DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
                   MONMSG     MSGID(CPF0000)
/*                                                                            */
                   RMVLNK     OBJLNK('/SALESCOMPANY/SKU_CHANGE.CSV')
                   MONMSG     MSGID(CPF0000)
                   CVTDBF     OBJ('/SALESCOMPANY/SKU_CHANGE.CSV') +
                              DBFILE(TVRELWAECO/SKU_CHANGE) +
                              DBOUTFMT(*CSV) DBFLDDSC(*YES)
                   MONMSG     MSGID(CPF0000)
/*                                                                            */
                ENDDO
             ENDDO

/*    _HÜLLE_________________________________________________________     */
             IF         COND(&QDAYOFWEEK *NE '*SUN' *AND &QDAY < +
                          '99') THEN(DO)
       /*   *** AUSLAGERUNGEN ORDERINPUT                                     */
       /*       CALL       PGM(SWAPC)           */
       /*       MONMSG     MSGID(CPF0000)       */
/*                                                                            */
             ENDDO
/*    _______________________________________________________________     */
/*                                                                            */

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

             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(TVRELWAECO)
                MONMSG     MSGID(CPF0000)
             ENDDO

     /*      DSPJOBLOG  OUTPUT(*PRINT)                */

             ENDPGM
