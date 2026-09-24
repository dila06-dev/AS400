/*    * PROGRAMMNAME.:BALL002C                                               */
/*    * FUNKTION.....:CALL BALL002R                                          */
/*    *               BALLENÄNDERUNG                                         */
/*    * NOVEMBER 2000                                                         */
/*    *                                                                       */
/*    * FASERWERKE-LINGEN GMBH                                                */
/*    * DARMER ESCH 75                                                        */
/*    * 49811 LINGEN                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&RECORDS &D3N_HOLD1 &D3N_HOLD2 +
                          &D3N_HOLD3 &D3N_LAGER &D3N_WERTK +
                          &D3N_PDAT &D3N_BRUTTO &D3N_NETTO +
                          &D3N_MERGE &D3N_BALLEN &D3N_TOEN)

             DCL        VAR(&FWLFIRM) TYPE(*CHAR) LEN(01)
             DCL        VAR(&RECORDS) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&LOT)        TYPE(*CHAR) LEN(02)
             DCL        VAR(&MISCH)      TYPE(*DEC) LEN(01 0)

             DCL        VAR(&D3N_HOLD1)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&D3N_HOLD2)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&D3N_HOLD3)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&D3N_LAGER)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&D3N_WERTK)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&D3N_PDAT)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&D3N_BRUTTO) TYPE(*DEC) LEN(08 02)
             DCL        VAR(&D3N_NETTO)  TYPE(*DEC) LEN(08 02)
             DCL        VAR(&D3N_MERGE)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&D3N_BALLEN) TYPE(*CHAR) LEN(9)
             DCL        VAR(&D3N_TOEN)   TYPE(*CHAR) LEN(2)

             DCL        VAR(&ENV)     TYPE(*CHAR) LEN(01)
/*----------------------------------------------------------------------------*/
/*-ENVIRONMENT ANPASSEN BZW ERSTELLEN-----------------------------------------*/
/*----------------------------------------------------------------------------*/
             RTVDTAARA  DTAARA(FWLFIRM (1 1)) RTNVAR(&FWLFIRM)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             GOTO       CMDLBL(ENDE)
             ENDDO
             IF         COND(&FWLFIRM *EQ 'D') THEN(DO)
                   GOTO       CMDLBL(ENDE)
             ENDDO
             IF         COND(&FWLFIRM *EQ 'L') THEN(DO)
             ENDDO
             RTVDTAARA  DTAARA(FWLFIRM (2 1)) RTNVAR(&ENV)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             GOTO       CMDLBL(ENDE)
             ENDDO
/*----------------------------------------------------------------------------*/
/*                                                          */
             RTVMBRD    FILE(QTEMP/UNTBL) NBRCURRCD(&RECORDS)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                GOTO       CMDLBL(ENDE)
             ENDDO
             IF         COND(&RECORDS *EQ 0) THEN(DO)
                   GOTO       CMDLBL(ENDE)
             ENDDO
             CALL       PGM(#DEFLDA) PARM(' ')
/*          ------------------------LOGISTISCHE MISCHUNG--------------       */
             IF         COND(&ENV *EQ 'T') THEN(DO)
                OVRDBF     FILE(UNTBL08L) TOFILE(TESDATFWLT/UNTBL08L) +
                             MBR(*FIRST) OVRSCOPE(*CALLLVL)
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&ENV *EQ 'P') THEN(DO)
                OVRDBF     FILE(UNTBL08L) TOFILE(TESDATFWL/UNTBL08L) +
                             MBR(*FIRST) OVRSCOPE(*CALLLVL)
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&ENV *EQ 'M') THEN(DO)
                OVRDBF     FILE(UNTBL08L) TOFILE(TESDATFWLM/UNTBL08L) +
                             MBR(*FIRST) OVRSCOPE(*CALLLVL)
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&ENV *EQ 'G') THEN(DO)
                OVRDBF     FILE(UNTBL08L) TOFILE(TESDATFWLG/UNTBL08L) +
                             MBR(*FIRST) OVRSCOPE(*CALLLVL)
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&ENV *EQ '2') THEN(DO)
                OVRDBF     FILE(UNTBL08L) TOFILE(TESDATFWL2/UNTBL08L) +
                             MBR(*FIRST) OVRSCOPE(*CALLLVL)
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&ENV *EQ '3') THEN(DO)
                OVRDBF     FILE(UNTBL08L) TOFILE(TESDATFWL3/UNTBL08L) +
                             MBR(*FIRST) OVRSCOPE(*CALLLVL)
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&ENV *EQ 'D') THEN(DO)
                OVRDBF     FILE(UNTBL08L) TOFILE(TESDATFWLD/UNTBL08L) +
                             MBR(*FIRST) OVRSCOPE(*CALLLVL)
                MONMSG     MSGID(CPF0000)
             ENDDO
/*           CRTLF      FILE(QTEMP/UNTBL90L) +            */
/*                        SRCFILE(UEBERNAHME/QDDSSRC)     */
/*           MONMSG     MSGID(CPF0000)                    */

             CALL       PGM(BALL002R) PARM(&RECORDS &D3N_HOLD1 +
                          &D3N_HOLD2 &D3N_HOLD3 &D3N_LAGER +
                          &D3N_WERTK &D3N_PDAT &D3N_BRUTTO &D3N_NETTO +
                          &D3N_MERGE &D3N_BALLEN &D3N_TOEN)

/*           CPYF       FROMFILE(QTEMP/UNTBL) +                   */
/*                        TOFILE(FMAPLIB_T/UNTBL) MBROPT(*ADD)    */
/*           MONMSG     MSGID(CPF0000)                            */
             CALL       PGM(##SVRLDA) PARM('S')
/*          ------------------------STOIN00F VERBUCHEN ---------------       */
/*           CALL       PGM(YS2001)                 */
             CALL       PGM(YS2001C)
             CALL       PGM(##SVRLDA) PARM('R')
/*                                                          */
ENDE:

/*           DLTF       FILE(QTEMP/UNTBL)    */
/*           MONMSG     MSGID(CPF0000)       */
             DLTOVR     FILE(*ALL) LVL(*)

             RCLRSC
             ENDPGM
