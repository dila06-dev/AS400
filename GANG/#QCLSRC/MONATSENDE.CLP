/*    * PROGRAMMNAME.:MONATSENDE                                             */
/*    * FUNKTION.....:....                                                   */
/*    * 06.07.98                                                              */
/*    *                                                                       */
/*    * Manfred Gang                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM

/*----------------------------------------------------------------------------*/
             DCL        VAR(&MSGPGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LDAS)   TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&ERROR)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(10)
/* &CTL      CTL     'B'= BILDSCHIRM, ELSE DRUCKER   */
             DCL        VAR(&CTL) TYPE(*CHAR) LEN(1) VALUE(' ')
/*********************************************************************       */
             CALL       PGM(DIS0003C) PARM(' ' '9')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DRUCK_R) PARM(&PRT)
             MONMSG     MSGID(CPF0000)
/*-CALL AUF DRUCKSTEUERPROGRAMM---==> START-----------------------------------*/
             CALL       PGM(PRTCTL) PARM(&PRT 'QPQUPRFIL ' &CTL +
                          '*NO ' '1')
/*********************************************************************       */
             RUNQRY     QRY(FWLFR/MONENDE01) RCDSLT(*YES)
             MONMSG     MSGID(CPF0000)
             RUNQRY     QRY(FWLFR/MONENDE02) RCDSLT(*YES)
             MONMSG     MSGID(CPF0000)
/*********************************************************************       */

/*-CALL AUF DRUCKSTEUERPROGRAMM---==> ENDE------------------------------------*/
             CALL       PGM(PRTCTL) PARM(&PRT 'QPQUPRFIL ' &CTL +
                          '*NO ' '0')

/*********************************************************************       */
ENDE:
             DLTOVR     FILE(*ALL) LVL(*)
             RCLRSC

             ENDPGM
