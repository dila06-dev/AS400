/*    * PROGRAMMNAME.:LOTS002C                                               */
/*    * FUNKTION.....:CALL LOTS002R                                          */
/*    *               LOTÄNDERUNEGN                                          */
/*    * NOVEMBER 2000                                                         */
/*    *                                                                       */
/*    * FASERWERKE-LINGEN GMBH                                                */
/*    * DARMER ESCH 75                                                        */
/*    * 49811 LINGEN                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&RECORDS &LOT)

             DCL        VAR(&FWLFIRM) TYPE(*CHAR) LEN(01)
             DCL        VAR(&RECORDS) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&LOT)     TYPE(*CHAR) LEN(02)

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
/*----------------------------------------------------------------------------*/
/*                                                          */
             RTVMBRD    FILE(QTEMP/UNTBL) NBRCURRCD(&RECORDS)
             MONMSG     MSGID(CPF0000)
             IF         COND(&RECORDS *EQ 0) THEN(DO)
                   GOTO       CMDLBL(ENDE)
             ENDDO
             CALL       PGM(#DEFLDA) PARM(' ')
/*          ------------------------LOTÄNDERUNGEN --------------------       */
             CALL       PGM(LOTS002R) PARM(&LOT)
             CPYF       FROMFILE(QTEMP/UNTBL) +
                          TOFILE(DMAPLIB_T/UNTBL) MBROPT(*ADD)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(##SVRLDA) PARM('S')
/*          ------------------------STOIN00F VERBUCHEN ---------------       */
/*           CALL       PGM(YS2001)                 */
             CALL       PGM(YS2001C)
             CALL       PGM(##SVRLDA) PARM('R')
             CALL       PGM(#DEFLDA) PARM(' ')
/*                                                          */
ENDE:

/*           DLTF       FILE(QTEMP/UNTBL)    */
/*           MONMSG     MSGID(CPF0000)       */

             RCLRSC
             ENDPGM
