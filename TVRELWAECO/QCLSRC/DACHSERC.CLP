/*    * PROGRAMMNAME.:CALL ........                                          */
/*    * FUNKTION.....:IDCO                                                   */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    * .MACHT TREND SCHON ACHTUNG                                            */
/*    * QSYS/CPYTOIMPF FROMFILE(MODWAO/SPED80) +                              */
/*    *              TOFILE(MODWAO/SPED81) MBROPT(*REPLACE) +                 */
/*    *              STRDLM(*NONE) RMVBLANK(*BOTH) FLDDLM(';') +              */
/*    *              DECPNT(*COMMA)                                           */
/*    *  MONMSG     MSGID(CPF2817) EXEC(SNDPGMMSG MSG('DATEI +                */
/*    *               LEER.') MSGTYPE(*DIAG))                                 */
/*    * .                                                                     */
/*    * .                                                                     */
/*    * QSYS/CPYTOIMPF FROMFILE(SPED81)                                       */
/*    * TOSTMF('/SPEDITION/SPED81X.CSV')                                      */
/*    * .                                                                     */
/*    * QSYS/CPYTOIMPF FROMFILE(SPED81)                                       */
/*    * TOSTMF('/SPEDITION/SPED81X.CSV')                                      */
/*    * RCDDLM(*CR)                                                           */
/*    * .                                                                     */
/*    * .                                                                     */
/*    * .                                                                     */
/*    * .                                                                     */
/*    * .                                                                     */
/*    * .                                                                     */
/*    * .                                                                     */
/*    * .                                                                     */
/*    * .                                                                     */
/*    * .                                                                     */
/*    * .                                                                     */
/*    * .                                                                     */
/*    * .                                                                     */
/*    * .                                                                     */
/*    * .                                                                     */
/*    * .                                                                     */
/*    * .                                                                     */
/*    * .                                                                     */
/*    * .                                                                     */
/*    * .                                                                     */
/*    * .                                                                     */
/*    * .                                                                     */
/*    * .                                                                     */
/*    * .                                                                     */
/*    * .                                                                     */
/*    * .                                                                     */
/*    * .                                                                     */
/*    * .                                                                     */
/*    * .                                                                     */
/*    * .                                                                     */
/*    * .                                                                     */
/*    * .                                                                     */
/*    * .                                                                     */
/*    * .                                                                     */
/*    * .                                                                     */
/*    * .                                                                     */
/*    * .                                                                     */
/*    * .                                                                     */
/*    * .                                                                     */
/*    * .                                                                     */
/*    * .                                                                     */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM

             DCL        VAR(&PARM)    TYPE(*CHAR) LEN(01)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&BEFEHL)   TYPE(*CHAR) LEN(126) VALUE(' ')

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

             ADDLIBLE   LIB(MODWAO) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))

             ADDLIBLE   LIB(TVRELWAECO) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))


/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('DACHSERC  ')
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


/*          LÖSCHEN DER ÜBERTRAGUNGSDATEI                                    */
             QSYS/RTVMBRD FILE(MODWAO/SPED81) +
                          NBRCURRCD(&NBRCURRCD)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(MODWAO/SPED81)
             MONMSG     MSGID(CPF0000)
             RMVLNK     OBJLNK('/SPEDITION/SPED81.CSV')
             MONMSG     MSGID(CPF0000)

/*          PROTOKOLLIERUNG ---                                           */
             CHGVAR     VAR(&MD)             VALUE(' ')
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('.....')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CHGVAR     VAR(%SST(&MD 100 21)) VALUE('sped81Sätze +
                          gelöscht ')
             CHGVAR     VAR(&NBRCURR##) VALUE(&NBRCURRCD)
             CHGVAR     VAR(%SST(&MD 118 10)) VALUE(&NBRCURR##)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */
             CALL       PGM(MODWAO/TRSP16DA)
             MONMSG     MSGID(CPF0000)
             QSYS/RTVMBRD FILE(MODWAO/SPED81) +
                          NBRCURRCD(&NBRCURRCD)
             MONMSG     MSGID(CPF0000)
             IF         COND(&NBRCURRCD *GT 00000) THEN(DO)
                RMVLNK     OBJLNK('/SPEDITION/SPED81.CSV')
                MONMSG     MSGID(CPF0000)
                CVTDBF     OBJ('/SPEDITION/SPED81.CSV') +
                            DBFILE(MODWAO/SPED81) DBOUTFMT(*CSV)
                MONMSG     MSGID(CPF0000)
                CHGAUT     OBJ('/SPEDITION/SPED81.CSV') USER(*PUBLIC) +
                          DTAAUT(*RWX)
                MONMSG     MSGID(CPF0000)
             ENDDO
             CLRPFM     FILE(MODWAO/SPED80)
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */
             CHGVAR     VAR(&MD)             VALUE(' ')
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('.....')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CHGVAR     VAR(%SST(&MD 100 21)) VALUE('sped81Sätze +
                          generiert:')
             CHGVAR     VAR(&NBRCURR##) VALUE(&NBRCURRCD)
             CHGVAR     VAR(%SST(&MD 118 10)) VALUE(&NBRCURR##)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */
             CPYF       FROMFILE(SPED81) TOFILE(SPED81#) +
                          MBROPT(*ADD) FMTOPT(*MAP)
             MONMSG     MSGID(CPF0000)
 CMD:
/*          WÄRE ALTERNATIV, DERZEIT NICHT IM EINSATZ                     */
             GOTO       ENDPGM
             CHGVAR     VAR(&BEFEHL) VALUE('del +
                          \\waeco-server-01\waeco\Abteilungen\Lager\D+
                          ACHSER\SPED81V*.*')
             STRPCO     PCTA(*NO)
             MONMSG     MSGID(CPF0000)
             STRPCCMD   PCCMD(&BEFEHL) PAUSE(*NO)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&BEFEHL) VALUE('xcopy +
                          \\172.16.100.1\SPEDITION\SPED81.CSV +
                          \\waeco-server-01\waeco\Abteilungen\Lager\D+
                          ACHSER')
             STRPCO     PCTA(*NO)
             MONMSG     MSGID(CPF0000)
             STRPCCMD   PCCMD(&BEFEHL) PAUSE(*NO)
             MONMSG     MSGID(CPF0000)

/*                                                                            */
 ENDPGM:
/*          PROTOKOLLIERUNG ---                                           */
             CHGVAR     VAR(&MD)             VALUE(' ')
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

             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
             ENDDO

             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(TVRELWAECO)
             ENDDO
             DSPJOBLOG  OUTPUT(*PRINT)
             MONMSG     MSGID(CPF0000)

             ENDPGM
