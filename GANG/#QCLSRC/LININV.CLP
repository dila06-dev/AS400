/*    * PROGRAMMNAME.:INVENTUR                                               */
/*    * FUNKTION.....:INVENTURLISTE/BESTANDLISTE                             */
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
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CTL) TYPE(*CHAR) LEN(1)  VALUE(' ')
/*----------------------------------------------------------------------------*/
/*    *                                                                      */
             CALL       PGM(DRUCK_R) PARM(&PRT)
             MONMSG     MSGID(CPF0000)
/*-CALL AUF DRUCKSTEUERPROGRAMM---==> START                                   */
             CALL       PGM(PRTCTL) PARM(&PRT 'QPQUPRFIL ' &CTL +
                          '*NO ' '1')
/******************************************************************************/
             DLTF       FILE(QTEMP/INV0003)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/INV0004)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/INV0005)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/INV0006)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/INV0066)
             MONMSG     MSGID(CPF0000)
/*                                                          */
             RUNQRY     QRY(FWLFR/INV0003)
             MONMSG     MSGID(CPF0000)
/*           CLRPFM     FILE(QTEMP/INV0003)                 */
/*           MONMSG     MSGID(CPF0000)                      */
             DLTF       FILE(QTEMP/INV0004)
/*           CLRPFM     FILE(QTEMP/INV0004)         */
             MONMSG     MSGID(CPF0000)
             CALL       PGM(INV0003R)
             MONMSG     MSGID(CPF0000)
             RUNQRY     QRY(FWLFR/INV0004)
             MONMSG     MSGID(CPF0000)
             RUNQRY     QRY(FWLFR/INV0005) RCDSLT(*YES)
             MONMSG     MSGID(CPF0000)
             RUNQRY     QRY(FWLFR/INV0006)
             MONMSG     MSGID(CPF0000)
/*                                                          */
/*********************************************************************       */
/*-CALL AUF RUCKSTEUERPROGRAMM---==> ENDE                                    */
             CALL       PGM(PRTCTL) PARM(&PRT 'QPQUPRFIL ' &CTL +
                          '*NO ' '0')
/*********************************************************************       */
ENDE:
             ENDPGM
