/*    * PROGRAMMNAME.:CALL ........                                          */
/*    * FUNKTION.....:ERGÄNZUNG                                              */
/*    *                                                                      */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM

             DCL        VAR(&PARM)    TYPE(*CHAR) LEN(01)
             DCL        VAR(&RDAT)    TYPE(*CHAR) LEN(08)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&ERROR1)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&USER)       TYPE(*CHAR) LEN(10)
             DCL        VAR(&OUTFILE)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFKT)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBRCURRCD)  TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBRCURRCD2) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&JOB)       TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&$GANG)     TYPE(*CHAR) LEN(32)
             DCL        VAR(&EXCEL)  TYPE(*CHAR) LEN(512) VALUE(' ')
             DCL        VAR(&BEFEHL)   TYPE(*CHAR) LEN(126) VALUE(' ')
             DCL        VAR(&DOKUMENT) TYPE(*CHAR) LEN(512) VALUE(' ')

/*          FESTSTELLEN, OB SÄTZE IN ÜBERTRAGUNGSDATEI SIND                  */
             RTVMBRD    FILE(WAETECHP) NBRCURRCD(&NBRCURRCD)
             MONMSG     MSGID(CPF0000)
             IF         COND(&NBRCURRCD > 0) THEN(DO)
                CLRPFM     FILE(EDI_TECHP)
                MONMSG     MSGID(CPF0000) EXEC(DO)
                   GOTO   ENDPGM
                ENDDO
             CALL       PGM(TECHNOR)
             ENDDO

             RTVJOBA    USER(&USER)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))
             CHGVAR     VAR(&EXCEL) VALUE('C:\EDI')
             CHGVAR     VAR(&DOKUMENT) VALUE('TECHNOEDI_1252.DTF')
             CHGVAR     VAR(&BEFEHL) VALUE('"' *TCAT &EXCEL *TCAT ' +
                          /' *CAT &DOKUMENT *TCAT '"')
             STRPCO     PCTA(*NO)
             MONMSG     MSGID(CPF0000)
             STRPCCMD   PCCMD(&BEFEHL) PAUSE(*NO)
             MONMSG     MSGID(CPF0000)
       /* CHGVAR     VAR(&EXCEL) +                                 */
       /*             VALUE('G:\Abteilungen\Export\' *TCAT &USER  +*/
       /*             *TCAT '\Excel\backorder\ALMAX')              */
       /*MONMSG     MSGID(CPF0000)                                 */
             OVRDBF     FILE(INPUT) TOFILE(GANG/QCLSRC) MBR(TECHNOCMD)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(OUTPUT) TOFILE(GANG/QCLSRC) MBR(TECHNOLOG)
             MONMSG     MSGID(CPF0000)
             FTP        RMTSYS('MY.EDIEXPERTS.DE')
             DLTOVR     FILE(INPUT)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(OUTPUT)
             MONMSG     MSGID(CPF0000)

 ENDPGM:
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
             ENDDO

             ENDPGM
