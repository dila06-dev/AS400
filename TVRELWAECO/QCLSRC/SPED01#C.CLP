/*    * PROGRAMMNAME.:CALL ........                                          */
/*    * FUNKTION.....:IDCO                                                   */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    * BEI ERNEUTER ÜBERTRAGUNG WIRD VORHER EINE PC-DATEI GENERIERT          */
/*    * ÜBER:                                                                 */
/*    * QSYS/CPYTOIMPF FROMFILE(TVRELWAECO/SPEDC0#) +                         */
/*    *              TOFILE(MODWAO/SPEDC1) MBROPT(*REPLACE) +                 */
/*    *              STRDLM(*NONE) RMVBLANK(*BOTH) FLDDLM(';')                */
/*    *              DECPNT(*COMMA)                                           */
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
             DCL        VAR(&DIR)      TYPE(*CHAR) LEN(64)
             DCL        VAR(&FORMTYPE) TYPE(*CHAR) LEN(50)

             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)
             DCL        VAR(&SHORTCUT) TYPE(*CHAR) LEN(02) VALUE('UK')

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))

             ADDLIBLE   LIB(TVRELWAECO) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('SPED01#C  ')
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
             CPYF       FROMFILE(MODWAO/SPED00) +
                          TOFILE(TVRELWAECO/SPED00#) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF0000)
             CALL    PGM(DUMMY512) PARM(&MD 'HEL0151' ' ' 'PRT55' +
                          ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             CLRPFM     (TVRELWAECO/#DC0600)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0600' ' ' ' ' +
                           '#DC0600' 'TVRELWAECO' '*REPLACE')
             MONMSG     MSGID(CPF0000)
             QSYS/RTVMBRD FILE(TVRELWAECO/#DC0600) +
                          NBRCURRCD(&NBRCURRCD)
             MONMSG     MSGID(CPF0000)
             IF         COND(&NBRCURRCD *NE 0) THEN(DO)
                CHGVAR     VAR(&DIR) VALUE('/SALESCOMPANY/' *TCAT +
                           &SHORTCUT *TCAT '/')
                CRTDIR DIR(&DIR)
                MONMSG     MSGID(CPF0000)

                CHGVAR     VAR(&DIR) VALUE('/SALESCOMPANY/' *TCAT +
                           &SHORTCUT *TCAT '/' *TCAT 'SPED01#C.TXT')
                RMVLNK     OBJLNK(&DIR)
                MONMSG     MSGID(CPF0000)
                CVTDBF     OBJ(&DIR) DBFILE(TVRELWAECO/#DC0600) +
                           DBOUTFMT(*CSV) DBFLDDSC(*YES)
                MONMSG     MSGID(CPF0000)
                CVTDBF     OBJ(&DIR) DBFILE(TVRELWAECO/#DC0600) +
                           DBOUTFMT(*TXT) DBFLDDSC(*YES)
                MONMSG     MSGID(CPF0000)

                CHGVAR     VAR(&FORMTYPE) VALUE('SPED01#C' *TCAT +
                           &SHORTCUT)
                OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                          DEV(PRT55) FORMTYPE(&FORMTYPE) OVRSCOPE(*JOB)
                MONMSG     MSGID(CPF0000)
/*                                                                            */
                CALL    PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                             ' ' ' ' ' ')
                MONMSG     MSGID(CPF0000)
                DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
                MONMSG     MSGID(CPF0000)
             ENDDO
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
