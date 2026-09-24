/*    * PROGRAMMNAME.:DIS0002C                                               */
/*    * FUNKTION.....:INVENTURLISTE/BESTANDSLISTE                            */
/*    * NOVEMBER 2000                                                         */
/*    *                                                                       */
/*    * FASERWERKE-LINGEN GMBH                                                */
/*    * DARMER ESCH 75                                                        */
/*    * 49811 LINGEN                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&CDORD &LNNUM &CDODL &PRNBR &F13)

             DCL        VAR(&CDORD)   TYPE(*CHAR) LEN(06)
             DCL        VAR(&LNNUM)   TYPE(*CHAR) LEN(03)
             DCL        VAR(&CDODL)   TYPE(*CHAR) LEN(02)
             DCL        VAR(&PRNBR)   TYPE(*CHAR) LEN(03)
             DCL        VAR(&F13)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(10)
/* &CTL      CTL     'B'= BILDSCHIRM, ELSE DRUCKER   */
             DCL        VAR(&CTL) TYPE(*CHAR) LEN(1) VALUE(' ')
/*----------------------------------------------------------------------------*/
/*********************************************************************       */
             CALL       ENGSYS
             CALL       PGM(DRUCK_R) PARM(&PRT)
             MONMSG     MSGID(CPF0000)
/*-CALL AUF DRUCKSTEUERPROGRAMM---==> START-----------------------------------*/
             CALL       PGM(PRTCTL) PARM(&PRT 'QPQUPRFIL ' &CTL +
                          '*NO ' '1')
/*********************************************************************       */
/*----------------------------------------------------------------------------*/
             CALL       PGM(DIS0002) PARM(&CDORD &LNNUM &CDODL &PRNBR)
             MONMSG     MSGID(CPF0000)
             IF         COND(&F13 *EQ 'AUFTRAG   ') THEN(DO)
                IF         COND(&CDORD *EQ '000000' *AND &LNNUM *EQ +
                             '000' *AND &CDODL *EQ '00' *AND &PRNBR +
                             *EQ '000') THEN(DO)
                   RUNQRY     QRY(FMAPLIB/DIS0002)
                   MONMSG     MSGID(CPF0000)
                   GOTO       CMDLBL(ENDE)
                ENDDO
                RUNQRY     QRY(FMAPLIB/DIS0002B)
                MONMSG     MSGID(CPF0000)
                GOTO       CMDLBL(ENDE)
             ENDDO
/*                                                          */
             IF         COND(&F13 *EQ 'BALLEN    ') THEN(DO)
                IF         COND(&CDORD *EQ '000000' *AND &LNNUM *EQ +
                             '000' *AND &CDODL *EQ '00' *AND &PRNBR +
                             *EQ '000') THEN(DO)
                   RUNQRY     QRY(FMAPLIB/DIS0003)
                   MONMSG     MSGID(CPF0000)
                   GOTO       CMDLBL(ENDE)
                ENDDO
                RUNQRY     QRY(FMAPLIB/DIS0003B)
                MONMSG     MSGID(CPF0000)
                GOTO       CMDLBL(ENDE)
             ENDDO
/*                                                          */
             IF         COND(&F13 *EQ 'HOLD      ') THEN(DO)
                IF         COND(&CDORD *EQ '000000' *AND &LNNUM *EQ +
                             '000' *AND &CDODL *EQ '00' *AND &PRNBR +
                             *EQ '000') THEN(DO)
                   RUNQRY     QRY(FMAPLIB/DIS0004)
                   MONMSG     MSGID(CPF0000)
                   GOTO       CMDLBL(ENDE)
                ENDDO
                RUNQRY     QRY(FMAPLIB/DIS0004B)
                MONMSG     MSGID(CPF0000)
                GOTO       CMDLBL(ENDE)
             ENDDO
/*********************************************************************       */
/*-CALL AUF DRUCKSTEUERPROGRAMM---==> ENDE------------------------------------*/
             CALL       PGM(PRTCTL) PARM(&PRT 'QPQUPRFIL ' &CTL +
                          '*NO ' '0')
/*********************************************************************       */
/*                                                          */
ENDE:
             ENDPGM
