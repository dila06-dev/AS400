/*    * PROGRAMMNAME.:DRUCK MDO                                              */
/*    * FUNKTION.....:CALL PROD0004C                                         */
/*    *               ...                                                    */
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

             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&FWLFIRM) TYPE(*CHAR) LEN(01)
             DCL        VAR(&NBRCURRCD) TYPE(*DEC) LEN(10)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(10)
/* &CTL      CTL     'B'= BILDSCHIRM, ELSE DRUCKER   */
             DCL        VAR(&CTL) TYPE(*CHAR) LEN(1) VALUE(' ')
/*                                                              */
/*-ENVIRONMENT ANPASSEN BZW ERSTELLEN-----------------------------------------*/
/*----------------------------------------------------------------------------*/
             RTVMBRD    FILE(QTEMP/DIS0005) NBRCURRCD(&NBRCURRCD)
             MONMSG     MSGID(CPF0000)
             IF         COND(&NBRCURRCD *GT 0  ) THEN(DO)
/*********************************************************************       */
                CALL       PGM(DRUCK_R) PARM(&PRT)
                MONMSG     MSGID(CPF0000)
/*-CALL AUF DRUCKSTEUERPROGRAMM---==> START-----------------------------------*/
                CALL       PGM(PRTCTL) PARM(&PRT 'QPQUPRFIL ' &CTL +
                          '*NO ' '1')
/*********************************************************************       */
                RUNQRY     QRY(FWLFR/DIS0005)
                MONMSG     MSGID(CPF0000)
/*********************************************************************       */
/*-CALL AUF DRUCKSTEUERPROGRAMM---==> ENDE------------------------------------*/
                CALL       PGM(PRTCTL) PARM(&PRT 'QPQUPRFIL ' &CTL +
                          '*NO ' '0')
/*********************************************************************       */
             ENDDO

ENDE:
             RCLRSC
             ENDPGM
