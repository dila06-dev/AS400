/*    * PROGRAMMNAME.:CALL ........                                          */
/*    * FUNKTION.....:IDCO                                                   */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    * .                                                                     */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&IFAKIFFI &IFAKMAAF)

             DCL        VAR(&PARM)    TYPE(*CHAR) LEN(01)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&IFAKIFFI)   TYPE(*CHAR) LEN(05)
             DCL        VAR(&IFAKMAAF)   TYPE(*CHAR) LEN(10)

             DCL        VAR(&ERROR1)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&OUTFILE)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFKT)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBRCURRCD)  TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBRCURRCD2) TYPE(*DEC) LEN(10 0)

             DCL        VAR(&D)         TYPE(*CHAR) LEN(8)
             DCL        VAR(&ABDATUM)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&QTIME)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&QDATETIME) TYPE(*CHAR) LEN(20)

             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('CONFIRM_SC')
             RTVMBRD    FILE(TVRELWAECO/QCLSRC) MBR(&PGM) TEXT(&TXT)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('START')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CHGVAR     VAR(%SST(&MD 100 5)) VALUE(&IFAKIFFI)
             CHGVAR     VAR(%SST(&MD 105 10)) VALUE(&IFAKMAAF)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */

             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&QTIME)
             RTVSYSVAL  SYSVAL(QDATETIME) RTNVAR(&QDATETIME)
             CHGVAR     VAR(&D) VALUE(%SST(&QDATETIME 1 8))

             ADDLIBLE   LIB(TVRELWAECO) POSITION(*AFTER TFXF)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))
             CLRPFM     FILE(QTEMP/#DC2580)
             MONMSG     MSGID(CPF0000)

             IF         COND(&IFAKIFFI *NE '     ') THEN(DO)
/*             GENERELLER AUFBAU                                             */
/*             ZIEHEN RELEVANTER DATEN AUS #LBLB                             */
                CHGVAR     VAR(%SST(&MD 01 05)) VALUE(&IFAKIFFI)
                CHGVAR     VAR(%SST(&MD 06 10)) VALUE(&IFAKMAAF)
                CALL      PGM(DUMMY512) PARM(&MD '#DC2579' ' ' ' ' +
                           '#DC2580' 'QTEMP' '*REPLACE')
                MONMSG     MSGID(CPF0000)

                RTVMBRD    FILE(QTEMP/#DC2580) NBRCURRCD(&NBRCURRCD)
                MONMSG     MSGID(CPF0000)
                IF         COND(&NBRCURRCD *GT 0) THEN(DO)
                   CALL    PGM(DUMMY512) PARM(&MD '#DC2581' ' ' ' ' +
                              '#DC2581' 'QTEMP' '*REPLACE')
                   MONMSG     MSGID(CPF0000)
/*         *RÜCKSTANDSKENNUNG SETZEN                                         */
                   CALL      PGM(DUMMY512) PARM(&MD '#DC2582' ' ' ' ' +
                             ' ' ' ' ' ')
                   MONMSG     MSGID(CPF0000)
/*         *ARTICLE IS PROTECTED BY SUPERVISOR                               */
                   CALL      PGM(DUMMY512) PARM(&MD '#DC2583' ' ' ' ' +
                             ' ' ' ' ' ')
                   MONMSG     MSGID(CPF0000)
/*         *ARTICLE IS NOT ANYMORE VALID REPLACED BY:                        */
                   CALL      PGM(DUMMY512) PARM(&MD '#DC2584' ' ' ' ' +
                             ' ' ' ' ' ')
                   MONMSG     MSGID(CPF0000)
/*         *SELLING UNIT ARE NOT CONFORM                                     */
                   CALL      PGM(DUMMY512) PARM(&MD '#DC2585' ' ' ' ' +
                             ' ' ' ' ' ')
                   MONMSG     MSGID(CPF0000)
/*         *NO PRICE FOR THIS ARTICLE AVAILABLE                              */
                   CALL      PGM(DUMMY512) PARM(&MD '#DC2586' ' ' ' ' +
                             ' ' ' ' ' ')
                   MONMSG     MSGID(CPF0000)
/*         ADDRESS FIELDS ARE NOT CORRECT OR MISSING                         */
                   CALL      PGM(DUMMY512) PARM(&MD '#DC2587' ' ' ' ' +
                             ' ' ' ' ' ')
                   MONMSG     MSGID(CPF0000)
/*         REPLACED ARTICLE IN CASE OF A MISTAKE                             */
                   CALL      PGM(DUMMY512) PARM(&MD '#DC2588' ' ' ' ' +
                             ' ' ' ' ' ')
                   MONMSG     MSGID(CPF0000)
/*         ADDRESS FIELDS ARE MISSING                                        */
                   CALL      PGM(DUMMY512) PARM(&MD '#DC2589' ' ' ' ' +
                             ' ' ' ' ' ')
                   MONMSG     MSGID(CPF0000)
/*         REPLACED ARTICLE IN ANY CASE                                      */
                   CALL      PGM(DUMMY512) PARM(&MD '#DC2595' ' ' ' ' +
                             ' ' ' ' ' ')
                   MONMSG     MSGID(CPF0000)
/*         ÜBERSCHREIBUNG ARTIKEL !!! AUFTRAGPOSITIONSDATEI !!!              */
                   CALL      PGM(DUMMY512) PARM(&MD '#DC2596' ' ' ' ' +
                             ' ' ' ' ' ')
                   MONMSG     MSGID(CPF0000)
/*         CLEAR AUF DATEN FÜR SAUBERE DARSTELLUNG                           */
                   CALL      PGM(DUMMY512) PARM(&MD '#DC2597' ' ' ' ' +
                             ' ' ' ' ' ')
                   MONMSG     MSGID(CPF0000)
                ENDDO
             ENDDO
             CALL       PGM(CONFIRMINR)
             MONMSG     MSGID(CPF0000)
/*          WIEDERVERFÜGBARKEITSDATUM PRÜFEN 18.09.2012                     */
/*           IF         COND(&IFAKIFFI *EQ '01887') THEN(DO)   */
             IF         COND(&IFAKIFFI *EQ '99999') THEN(DO)
             CLRPFM FILE(TVRELWAECO/#CONFIRM)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(TVRELWAECO/CONFIRMDLR)
             MONMSG     MSGID(CPF0000)
/*          TEST MIT LARS                                                   */
       /*   *** AUSGABE TEST                                                 */
             RMVLNK     OBJLNK('/SALESCOMPANY/DK/CHECKTEST.CSV')
             MONMSG     MSGID(CPF0000)
             CVTDBF     OBJ('/SALESCOMPANY/DK/CHECKTEST.CSV') +
                          DBFILE(TVRELWAECO/#CONFIRM) +
                          DBOUTFMT(*CSV) DBFLDDSC(*YES)
             MONMSG     MSGID(CPF0000)
             OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                    FORMTYPE('CHECKTE_DK') OVRSCOPE(*JOB)
             MONMSG     MSGID(CPF0000)
/*                                                                            */
             CALL       PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                          ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
             MONMSG     MSGID(CPF0000)

       /*   *** AUSGABE TEST                                                 */
             ENDDO
             CLRPFM     FILE(QTEMP/#DC2580)
             MONMSG     MSGID(CPF0000)
             DLYJOB     DLY(05)
             MONMSG     MSGID(CPF0000)
/*          SENDEN PER FTP                                                  */
             CALL       PGM(CONFIRMFTP) PARM(&IFAKIFFI)
             MONMSG     MSGID(CPF0000)
             DLYJOB     DLY(10)
             MONMSG     MSGID(CPF0000)
/*                                                                            */
 ENDPGM:

             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(TVRELWAECO)
                MONMSG     MSGID(CPF0000)
             ENDDO

             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
                MONMSG     MSGID(CPF0000)
             ENDDO

/*          PROTOKOLLIERUNG ---                                           */
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('ENDE ')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CHGVAR     VAR(%SST(&MD 100 5)) VALUE(&IFAKIFFI)
             CHGVAR     VAR(%SST(&MD 105 10)) VALUE(&IFAKMAAF)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */

             ENDPGM
