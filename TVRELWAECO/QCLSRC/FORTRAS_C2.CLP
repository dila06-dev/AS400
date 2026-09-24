/*    * PROGRAMMNAME.:CALL ........                                          */
/*    * FUNKTION.....:BATCH RUN FORTRAS DERZEIT NUR LOXX                     */
/*    *               KEIN PARAMETER                                         */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    * .                                                                     */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM

             DCL        VAR(&PARM)    TYPE(*CHAR) LEN(01)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&IFAKIFFI)   TYPE(*CHAR) LEN(05)
             DCL        VAR(&IFAKMAAF)   TYPE(*CHAR) LEN(10)

             DCL        VAR(&ERROR1)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR3)     TYPE(*CHAR) LEN(01) VALUE('0')
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

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('FORTRAS_C2')
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

             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&QTIME)
             RTVSYSVAL  SYSVAL(QDATETIME) RTNVAR(&QDATETIME)
             CHGVAR     VAR(&D) VALUE(%SST(&QDATETIME 1 8))

             ADDLIBLE   LIB(TVRELWAECO) POSITION(*AFTER TFXF)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

       /*    ADDLIBLE   LIB(GANG) POSITION(*LAST)                */
       /*    MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +*/
       /*                 VALUE('1'))                            */
             ALCOBJ     OBJ((TVRELWAECO/FORTRAS  *FILE *EXCLRD))
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDPGM))

             CLRPFM     FILE(TVRELWAECO/FORTRAS)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(SPEDK0) TOFILE(TVRELWAECO/#SPEDK0)
             MONMSG     MSGID(CPF0000)
/*                                                                            */
/*          DATEI UPDATEN                                                   */
             CALL       PGM(FORTRAS_R#)
             MONMSG     MSGID(CPF0000)
/*                                                                            */
             CPYF       FROMFILE(TVRELWAECO/FORTRAS) +
                          TOFILE(TVRELWAECO/FORTRAS#2) MBROPT(*ADD) +
                          FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(INPUT) TOFILE(TVRELWAECO/QCLSRC) +
                        MBR(FORTRAKOMD)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(OUTPUT) TOFILE(TVRELWAECO/QCLSRC) +
                        MBR(FORTRASLOG)
             MONMSG     MSGID(CPF0000)
             CALL     PGM(DUMMY512) PARM(&MD '#DC0010' ' ' ' ' +
                  'OUTPUT    '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
             FTP        RMTSYS('dfue.koch-international.de')
             CHGCURLIB  CURLIB(*CRTDFT)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0011' ' ' ' ' +
                           'FTPLOG'  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(INPUT)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(OUTPUT)
             MONMSG     MSGID(CPF0000)
/*           CLRPFM FILE(TVRELWAECO/QCLSRC) MBR(FORTRASLOG)   */
/*           MONMSG     MSGID(CPF0000)                        */
/*                                                                            */
 ENDPGM:
             DLCOBJ     OBJ((TVRELWAECO/FORTRAS  *FILE *EXCLRD))
             MONMSG     MSGID(CPF0000)

             DLTOVR     FILE(SPEDK0)
             MONMSG     MSGID(CPF0000)

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
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */

             ENDPGM
