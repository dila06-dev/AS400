/*    * PROGRAMMNAME.:ARCHIVC                                                */
/*    * FUNKTION.....:ZENTRALER AUFRUF ALLER VERARBEITUNGSROUTINEN           */
/*    *               FÜR ARCHIVE UND FOLGESYSTEME WIE BOARD ETC.            */
/*    * NOVEMBER 2000                                                         */
/*    *                                                                       */
/*    * FASERWERKE-LINGEN GMBH                                                */
/*    * DARMER ESCH 75                                                        */
/*    * 49811 LINGEN                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM

/*----------------------------------------------------------------------------*/
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&MSGPGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LDAS)   TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR3)  TYPE(*CHAR) LEN(01) VALUE('0')
/*                                                              */
             DCL        VAR(&MODUS)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&DATMOD)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&RTNCOD)  TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&SYSGES)  TYPE(*CHAR) LEN(26)
             DCL        VAR(&SYSDAT)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&SYSZEI)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FWLFIRM) TYPE(*CHAR) LEN(01)
             DCL        VAR(&BASISJA) TYPE(*DEC) LEN(07) VALUE(9999999)
             DCL        VAR(&X) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&Y)         TYPE(*CHAR) LEN(7)
             DCL        VAR(&Y2)        TYPE(*CHAR) LEN(7)
             DCL        VAR(&FWLFIRM) TYPE(*CHAR) LEN(01)
             DCL        VAR(&CODE) TYPE(*CHAR) LEN(01)
/*----------------------------------------------------------------------------*/
             RTVDTAARA  DTAARA(*LDA (954 10)) RTNVAR(&MSGPGM)
/*           IF         COND(&MSGPGM= '          ') THEN(DO)     */
                CALL       PGM(##SVRLDA) PARM('S')
                CHGDTAARA  DTAARA(*LDA (954 10)) VALUE(ARCHIVC)
                CHGVAR     VAR(&LDAS) VALUE('S')
                CALL       PGM(#DEFLDA) PARM(' ')
/*           ENDDO                                               */
/*----------------------------------------------------------------------------*/
             RTVDTAARA  DTAARA(BASISJA)          RTNVAR(&BASISJA)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                GOTO       CMDLBL(ENDE)
             ENDDO
/*----------------------------------------------------------------------------*/
FORDE:
             RTVDTAARA  DTAARA(FWLFIRM (1 1)) RTNVAR(&FWLFIRM)
             MONMSG     MSGID(CPF0000) EXEC(DO)
/*             FORDERUNGSMANAGEMENT AUFRUFEN                                 */
                CRTDTAARA  DTAARA(QTEMP/FWLFIRM) TYPE(*CHAR) LEN(2)
                CALL       PGM(#LIBNEUC) PARM('L' 'P')
                RTVDTAARA  DTAARA(FWLFIRM (1 1)) RTNVAR(&FWLFIRM)
                ADDLIBLE   LIB(FWLFR)      POSITION(*LAST)
                MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR3) +
                           VALUE('1'))
                CALL       PGM(BAB655AC)
             ENDDO
/*                                                */
ENDE:
             IF         COND(&ERROR3 = '0') THEN(DO)
                RMVLIBLE   LIB(FWLFR)
                MONMSG     MSGID(CPF0000)
             ENDDO
             CALL       PGM(#LIBALTC)
             CALL       PGM(##SVRLDA) PARM('R')
             RCLRSC
             ENDPGM
