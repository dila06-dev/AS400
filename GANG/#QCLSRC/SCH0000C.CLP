/*    * PROGRAMMNAME.:SCH####C                                               */
/*    * FUNKTION.....:LISTEN FÜR KTR                                         */
/*    * NOVEMBER 2000                                                         */
/*    *                                                                       */
/*    * FASERWERKE-LINGEN GMBH                                                */
/*    * DARMER ESCH 75                                                        */
/*    * 49811 LINGEN                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&LISTE)

             DCL        VAR(&LISTE)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(10)
/* &CTL      CTL     'B'= BILDSCHIRM, ELSE DRUCKER   */
             DCL        VAR(&CTL) TYPE(*CHAR) LEN(1) VALUE(' ')
/*----------------------------------------------------------------------------*/
/*********************************************************************       */
             CALL       PGM(DRUCK_R) PARM(&PRT)
             MONMSG     MSGID(CPF0000)
/*-CALL AUF DRUCKSTEUERPROGRAMM---==> START-----------------------------------*/
             CALL       PGM(PRTCTL) PARM(&PRT 'QPQUPRFIL ' &CTL +
                          '*NO ' '1')
/*********************************************************************       */
/*----------------------------------------------------------------------------*/
             RUNQRY     QRY(FWLFR/&LISTE)
             MONMSG     MSGID(CPF0000) CMPDTA(*DO)
             GOTO       CMDLBL(ENDE)
/*                                                          */
/*********************************************************************       */
/*-CALL AUF DRUCKSTEUERPROGRAMM---==> ENDE------------------------------------*/
             CALL       PGM(PRTCTL) PARM(&PRT 'QPQUPRFIL ' &CTL +
                          '*NO ' '0')
/*********************************************************************       */
/*                                                          */
ENDE:
             ENDPGM
