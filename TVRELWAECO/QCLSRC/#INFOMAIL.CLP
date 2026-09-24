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
             PGM        PARM(&DST &LONGMSG1 &LONGMSG2 &LONGMSG3)
             DCL        VAR(&ERROR1)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&CODE)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&SC) TYPE(*DEC) LEN(07 0) VALUE(0000000)
             DCL        VAR(&K)         TYPE(*CHAR) LEN(5)
             DCL        VAR(&DST)       TYPE(*CHAR) LEN(44) VALUE(' ')
             DCL        VAR(&LONGMSG)  TYPE(*CHAR) LEN(5000) VALUE(' ')
             DCL        VAR(&LONGMSG1)  TYPE(*CHAR) LEN(132)
             DCL        VAR(&LONGMSG2)  TYPE(*CHAR) LEN(132)
             DCL        VAR(&LONGMSG3)  TYPE(*CHAR) LEN(132)
             DCL        VAR(&#)         TYPE(*CHAR) LEN(1)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&QTIME)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&DAFEHL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&QDAYOFWEEK) TYPE(*CHAR) LEN(04)
             DCL        VAR(&QDAY)  TYPE(*CHAR) LEN(02)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)
             DCL        VAR(&NBRCURRCD)  TYPE(*DEC) LEN(10 0)

             ADDLIBLE   LIB(TVRELWAECO) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('#JOBS     ')

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('#INFOMAIL ')
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
       /*    CALL    PGM(DUMMY512) PARM(&MD 'STK1000' ' ' ' ' +     */
       /*                ' ' ' ' ' ')                               */
       /*    MONMSG     MSGID(CPF0000)                              */
/*                                                                            */
             ENDDO

/*    _INFO__________________________________________________________     */
             IF         COND(&QDAYOFWEEK *NE '****' *AND &QDAY < +
                          '99') THEN(DO)
       /*   *** BESTELLUNG/BESTELLDATEN                                      */
             CHGVAR     VAR(%SST(&LONGMSG 001 132)) VALUE(&LONGMSG1)
             CHGVAR     VAR(%SST(&LONGMSG 133 132)) VALUE(&LONGMSG2)
             CHGVAR     VAR(%SST(&LONGMSG 265 132)) VALUE(&LONGMSG3)
             SNDDST     TYPE(*LMSG) TOINTNET(('gang@dometic.com')) +
                          DSTD(&DST) LONGMSG(&LONGMSG)
             MONMSG     MSGID(CPF0000)
             SNDDST     TYPE(*LMSG) +
                          TOINTNET(('INGO.SCHLEMPER@DOMETIC.COM')) +
                          DSTD(&DST) LONGMSG(&LONGMSG)
             MONMSG     MSGID(CPF0000)
             SNDDST     TYPE(*LMSG) +
                          TOINTNET(('LISE.BERRUE@DOMETIC.COM')) +
                          DSTD(&DST) LONGMSG(&LONGMSG)
             MONMSG     MSGID(CPF0000)
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
