/*    * PROGRAMMNAME.:CALL ........                                          */
/*    * FUNKTION.....:IDCO                                                   */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    * .                                                                     */
/*    * SELECT HEL010, HEL020, HEL030, HEL040, HEL050, HEL060, HEL070,        */
/*    * HEL080, HEL090, HEL100, HEL110, HEL120, HEL130, HEL140, HEL150,       */
/*    * HEL160, HEL170, HEL180, HEL190, HEL200, HEL210, HEL220, HEL230,       */
/*    * HEL240, HEL250, HEL260, HEL270, HEL280, HEL290, HEL300, HEL310,       */
/*    * HEL320, HEL330, HEL340, HEL350, HEL360, HEL370, HEL380, HEL390,       */
/*    * HEL400, HEL410, HEL420, HEL430, HEL440, HEL450, HEL460, HEL470,       */
/*    * CURRENT DATE #DATE, CURRENT TIMESTAMP #TIMESTAMP FROM SPED10          */
/*    * .                                                                     */
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
             DCL        VAR(&NBRCURR##)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBRCURRCD2) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&VERSION)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&VON) TYPE(*DEC) LEN(6 0) VALUE(010110)
             DCL        VAR(&BIS) TYPE(*DEC) LEN(6 0) VALUE(310311)

             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))

             ADDLIBLE   LIB(TVRELWAECO) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('SPED11#C  ')
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

/*          SICHERUNG                                                        */
             CPYF       FROMFILE(MODWAO/SPED10) +
                          TOFILE(TVRELWAECO/SPED11#) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF0000)
             QSYS/RTVMBRD FILE(MODWAO/SPED10) +
                          NBRCURRCD(&NBRCURRCD)
             MONMSG     MSGID(CPF0000)
/*                                                                            */
 ENDPGM:
/*          PROTOKOLLIERUNG ---                                           */
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('ENDE ')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CHGVAR     VAR(%SST(&MD 100 14)) VALUE('Sätze verarb.')
             CHGVAR     VAR(&NBRCURR##) VALUE(&NBRCURRCD)
             CHGVAR     VAR(%SST(&MD 115 10)) VALUE(&NBRCURR##)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */

             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
             ENDDO

             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(TVRELWAECO)
             ENDDO

             ENDPGM
