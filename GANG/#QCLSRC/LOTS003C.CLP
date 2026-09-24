/*    * PROGRAMMNAME.:LOTS002C                                               */
/*    * FUNKTION.....:CALL LOTS003R                                          */
/*    *               LOGISTISCHE MISCHUNG                                   */
/*    * NOVEMBER 2000                                                         */
/*    *                                                                       */
/*    * FASERWERKE-LINGEN GMBH                                                */
/*    * DARMER ESCH 75                                                        */
/*    * 49811 LINGEN                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&RECORDS &LOT &MISCH)

             DCL        VAR(&FWLFIRM) TYPE(*CHAR) LEN(01)
             DCL        VAR(&RECORDS) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&LOT)     TYPE(*CHAR) LEN(02)
             DCL        VAR(&MISCH)   TYPE(*DEC) LEN(01 0)

             DCL        VAR(&ENV)     TYPE(*CHAR) LEN(01)
/*----------------------------------------------------------------------------*/
/*-ENVIRONMENT ANPASSEN BZW ERSTELLEN-----------------------------------------*/
/*----------------------------------------------------------------------------*/
             RTVDTAARA  DTAARA(FWLFIRM (1 1)) RTNVAR(&FWLFIRM)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             GOTO       CMDLBL(ENDE)
             ENDDO
             IF         COND(&FWLFIRM *EQ 'L') THEN(DO)
                   GOTO       CMDLBL(ENDE)
             ENDDO
             IF         COND(&FWLFIRM *EQ 'D') THEN(DO)
             ENDDO
             RTVDTAARA  DTAARA(FWLFIRM (2 1)) RTNVAR(&ENV)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             GOTO       CMDLBL(ENDE)
             ENDDO
             IF         COND(&ENV *NE 'P' *AND &ENV *NE 'T' *AND +
                          &ENV *NE 'M' *AND &ENV *NE 'G' *AND &ENV +
                          *NE '2' *AND &ENV *NE '3' *AND &ENV *NE +
                          'D') THEN(DO)
                   GOTO       CMDLBL(ENDE)
             ENDDO
/*----------------------------------------------------------------------------*/
/*                                                          */
             RTVMBRD    FILE(QTEMP/UNTBL) NBRCURRCD(&RECORDS)
             MONMSG     MSGID(CPF0000)
             IF         COND(&RECORDS *EQ 0) THEN(DO)
                   GOTO       CMDLBL(ENDE)
             ENDDO
             CALL       PGM(#DEFLDA) PARM(' ')
/*          ------------------------LOGISTISCHE MISCHUNG--------------       */
             IF         COND(&ENV *EQ 'T') THEN(DO)
                OVRDBF     FILE(UNTBL08L) TOFILE(TESDATDORT/UNTBL08L) +
                             MBR(*FIRST) OVRSCOPE(*CALLLVL)
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&ENV *EQ 'M') THEN(DO)
                OVRDBF     FILE(UNTBL08L) TOFILE(TESDATDORM/UNTBL08L) +
                             MBR(*FIRST) OVRSCOPE(*CALLLVL)
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&ENV *EQ 'G') THEN(DO)
                OVRDBF     FILE(UNTBL08L) TOFILE(TESDATDORG/UNTBL08L) +
                             MBR(*FIRST) OVRSCOPE(*CALLLVL)
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&ENV *EQ '3') THEN(DO)
                OVRDBF     FILE(UNTBL08L) TOFILE(TESDATDOR3/UNTBL08L) +
                             MBR(*FIRST) OVRSCOPE(*CALLLVL)
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&ENV *EQ '2') THEN(DO)
                OVRDBF     FILE(UNTBL08L) TOFILE(TESDATDOR2/UNTBL08L) +
                             MBR(*FIRST) OVRSCOPE(*CALLLVL)
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&ENV *EQ 'P') THEN(DO)
                OVRDBF     FILE(UNTBL08L) TOFILE(TESDATDOR/UNTBL08L) +
                             MBR(*FIRST) OVRSCOPE(*CALLLVL)
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&ENV *EQ 'D') THEN(DO)
                OVRDBF     FILE(UNTBL08L) TOFILE(TESDATDORD/UNTBL08L) +
                             MBR(*FIRST) OVRSCOPE(*CALLLVL)
                MONMSG     MSGID(CPF0000)
             ENDDO
/*           CRTLF      FILE(QTEMP/UNTBL90L) +            */
/*                        SRCFILE(UEBERNAHME/QDDSSRC)     */
/*           MONMSG     MSGID(CPF0000)                    */

             CALL       PGM(LOTS003R) PARM(&LOT &RECORDS &MISCH)

/*           CPYF       FROMFILE(QTEMP/UNTBL) +                   */
/*                        TOFILE(DMAPLIB_T/UNTBL) MBROPT(*ADD)    */
/*           MONMSG     MSGID(CPF0000)                            */
             CALL       PGM(##SVRLDA) PARM('S')
/*          ----------------------------------------------------------       */
             CALL       PGM(##SVRLDA) PARM('R')
/*                                                          */
ENDE:

/*           DLTF       FILE(QTEMP/UNTBL)    */
/*           MONMSG     MSGID(CPF0000)       */
             DLTOVR     FILE(*ALL) LVL(*)

             RCLRSC
             ENDPGM
