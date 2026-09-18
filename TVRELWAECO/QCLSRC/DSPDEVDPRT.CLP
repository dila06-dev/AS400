/*    * PROGRAMMNAME.:CALL ........                                          */
/*    * FUNKTION.....:IDCO                                                   */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    * CRTPF FILE(PRINTER) RCDLEN(2400) TEXT('DSPOBJD *DEVD *PRT *SERVICE')  */
/*    * CRTPF FILE(PRINTER2) RCDLEN(132) TEXT('DSPOBJD *DEVD *PRT *SERVICE')  */
/*    * CRTPF FILE(PRINTER3) RCDLEN(132) TEXT('DSPOBJD *DEVD *PRT *SERVICE')  */
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
             DCL        VAR(&PRTDEV)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&OUTFILE)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFKT)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBRCURRCD)  TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBRCURRCD2) TYPE(*DEC) LEN(10 0)

             DCL        VAR(&D)         TYPE(*CHAR) LEN(8)
             DCL        VAR(&SWAPC)     TYPE(*CHAR) LEN(8)
             DCL        VAR(&ABDATUM)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&QTIME)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&QDATETIME) TYPE(*CHAR) LEN(20)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)

             DCLF       FILE(TVRELWAECO/PRINTER3)

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('DSPDEVDPRT')
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

             CLRPFM     FILE(TVRELWAECO/PRINTER)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(TVRELWAECO/PRINTER2)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(TVRELWAECO/PRINTER3)
             MONMSG     MSGID(CPF0000)
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&QTIME)
             RTVSYSVAL  SYSVAL(QDATETIME) RTNVAR(&QDATETIME)

             ADDLIBLE   LIB(TVRELWAECO) POSITION(*AFTER TFXF)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))

             QSYS/DSPOBJD OBJ(PRT*) OBJTYPE(*DEVD) DETAIL(*SERVICE) +
                          OUTPUT(*OUTFILE) OUTFILE(TVRELWAECO/PRINTER)
             MONMSG     MSGID(CPF0000)

             RTVMBRD    FILE(TVRELWAECO/PRINTER) NBRCURRCD(&NBRCURRCD)
             MONMSG     MSGID(CPF0000)

             WRKOUTQ OUTQ(*ALL/PRT*) OUTPUT(*PRINT)
             MONMSG     MSGID(CPF0000)
             CPYSPLF    FILE(QPRTSPLQ) TOFILE(TVRELWAECO/PRINTER3) +
                        SPLNBR(*LAST) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF0000)
             DLTSPLF    FILE(QPRTSPLQ)
             MONMSG     MSGID(CPF0000)
         /*   DELETE   FROM  PRINTER3 WHERE SUBSTR( PRINTER3, 02, 10) */
         /*   IN (SELECT ODOBNM FROM PRINTER)                         */
         /*   DELETE   FROM PRINTER3    WHERE                         */
         /*   SUBSTR( PRINTER3, 38, 10) =  ' '                        */


                IF         COND(&NBRCURRCD *GT 0) THEN(DO)
 LOOP:             RCVF
                   MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDLOOP))
                   CHGVAR     VAR(&PRTDEV) VALUE(%SST(&PRINTER3 02 10))
              /*   DSPDEVD    DEVD(&PRTDEV) OUTPUT(*PRINT)      */
                   WRKOUTQD   OUTQ(&PRTDEV) OUTPUT(*PRINT)
                   MONMSG     MSGID(CPF0000)
              /*   CPYSPLF    FILE(QPDCDEV) TOFILE(TVRELWAECO/PRINTER2) + */
              /*              SPLNBR(*LAST) MBROPT(*ADD)                  */
                   CPYSPLF    FILE(QPDSPSQD) TOFILE(TVRELWAECO/PRINTER2) +
                              SPLNBR(*LAST) MBROPT(*ADD)
                   MONMSG     MSGID(CPF0000)
              /*   DLTSPLF    FILE(QPDCDEV)          */
                   DLTSPLF    FILE(QPDSPSQD)
                   MONMSG     MSGID(CPF0000)
                   GOTO LOOP
                ENDDO
/*                                                                            */
 ENDLOOP:
/*                                                                            */
             GOTO       CMDLBL(ENDPGM)
/*                                                                            */
 ENDPGM:

             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(TVRELWAECO)
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
